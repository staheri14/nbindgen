/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use std::io::Write;

use syn;

use crate::bindgen::config::Config;
use crate::bindgen::dependencies::Dependencies;
use crate::bindgen::ir::{
    AnnotationSet, Cfg, ConditionWrite, Documentation, GenericParams, GenericPath, Item,
    ItemContainer, Path, Repr, ReprStyle, ReprType, Struct, ToCondition, Type,
};
use crate::bindgen::library::Library;
use crate::bindgen::rename::{IdentifierType, RenameRule};
use crate::bindgen::reserved;
use crate::bindgen::utilities::find_first_some;
use crate::bindgen::writer::{Source, SourceWriter};

#[derive(Debug, Clone)]
pub struct EnumVariant {
    pub name: String,
    pub export_name: String,
    pub discriminant: Option<i64>,
    pub body: Option<(String, Struct)>,
    pub documentation: Documentation,
}

fn value_from_expr(val: &syn::Expr) -> Option<i64> {
    match *val {
        syn::Expr::Lit(ref lit) => match lit.lit {
            syn::Lit::Int(ref lit) => lit.base10_parse::<i64>().ok(),
            _ => None,
        },
        syn::Expr::Unary(ref unary) => {
            let v = value_from_expr(&unary.expr)?;
            match unary.op {
                syn::UnOp::Deref(..) => None,
                syn::UnOp::Neg(..) => v.checked_mul(-1),
                syn::UnOp::Not(..) => v.checked_neg(),
            }
        }
        _ => None,
    }
}

impl EnumVariant {
    pub fn load(
        is_tagged: bool,
        variant: &syn::Variant,
        generic_params: GenericParams,
        mod_cfg: Option<&Cfg>,
    ) -> Result<Self, String> {
        let discriminant = match variant.discriminant {
            Some((_, ref expr)) => match value_from_expr(expr) {
                Some(v) => Some(v),
                None => return Err(format!("Unsupported discriminant {:?}.", expr)),
            },
            None => None,
        };

        fn parse_fields(
            is_tagged: bool,
            fields: &syn::punctuated::Punctuated<syn::Field, syn::token::Comma>,
        ) -> Result<Vec<(String, Type, Documentation)>, String> {
            let mut res = Vec::new();

            if is_tagged {
                res.push((
                    "tag*".to_string(),
                    Type::Path(GenericPath::new(Path::new("Tag"), vec![])),
                    Documentation::none(),
                ));
            }

            for (i, field) in fields.iter().enumerate() {
                if let Some(ty) = Type::load(&field.ty)? {
                    res.push((
                        reserved::escaped(&match field.ident {
                            Some(ref ident) => ident.to_string(),
                            None => i.to_string(),
                        }),
                        ty,
                        Documentation::load(&field.attrs),
                    ));
                }
            }

            Ok(res)
        }

        let body = match variant.fields {
            syn::Fields::Unit => None,
            syn::Fields::Named(ref fields) => {
                let path = Path::new(format!("{}_Body", variant.ident));
                Some(Struct::new(
                    path,
                    generic_params,
                    parse_fields(is_tagged, &fields.named)?,
                    is_tagged,
                    true,
                    None,
                    false,
                    false,
                    Cfg::append(mod_cfg, Cfg::load(&variant.attrs)),
                    AnnotationSet::load(&variant.attrs)?,
                    Documentation::none(),
                ))
            }
            syn::Fields::Unnamed(ref fields) => {
                let path = Path::new(format!("{}_Body", variant.ident));
                Some(Struct::new(
                    path,
                    generic_params,
                    parse_fields(is_tagged, &fields.unnamed)?,
                    is_tagged,
                    true,
                    None,
                    false,
                    true,
                    Cfg::append(mod_cfg, Cfg::load(&variant.attrs)),
                    AnnotationSet::load(&variant.attrs)?,
                    Documentation::none(),
                ))
            }
        };

        Ok(EnumVariant::new(
            variant.ident.to_string(),
            discriminant,
            body.map(|body| {
                (
                    RenameRule::SnakeCase.apply_to_pascal_case(
                        &format!("{}", variant.ident),
                        IdentifierType::StructMember,
                    ),
                    body,
                )
            }),
            Documentation::load(&variant.attrs),
        ))
    }

    pub fn new(
        name: String,
        discriminant: Option<i64>,
        body: Option<(String, Struct)>,
        documentation: Documentation,
    ) -> Self {
        let export_name = name.clone();
        Self {
            name,
            export_name,
            discriminant,
            body,
            documentation,
        }
    }

    fn add_dependencies(&self, library: &Library, out: &mut Dependencies) {
        if let Some((_, ref item)) = self.body {
            item.add_dependencies(library, out);
        }
    }
}

impl Source for EnumVariant {
    fn write<F: Write>(&self, config: &Config, out: &mut SourceWriter<F>) {
        self.documentation.write(config, out);
        write!(out, "{}*", self.export_name);
        if let Some(discriminant) = self.discriminant {
            write!(out, " = {}", discriminant);
        }
        out.write(",");
    }
}

#[derive(Debug, Clone)]
pub struct Enum {
    pub path: Path,
    pub export_name: String,
    pub generic_params: GenericParams,
    pub repr: Repr,
    pub variants: Vec<EnumVariant>,
    pub tag: Option<String>,
    pub cfg: Option<Cfg>,
    pub annotations: AnnotationSet,
    pub documentation: Documentation,
}

impl Enum {
    pub fn load(item: &syn::ItemEnum, mod_cfg: Option<&Cfg>) -> Result<Enum, String> {
        let repr = Repr::load(&item.attrs)?;
        if repr.style == ReprStyle::Rust && repr.ty.is_none() {
            return Err("Enum is not marked with a valid #[repr(prim)] or #[repr(C)].".to_owned());
        }
        // TODO: Implement translation of aligned enums.
        if repr.align.is_some() {
            return Err("Enum is marked with #[repr(align(...))] or #[repr(packed)].".to_owned());
        }

        let generic_params = GenericParams::new(&item.generics);

        let mut variants = Vec::new();
        let mut is_tagged = false;

        for variant in item.variants.iter() {
            let variant = EnumVariant::load(
                repr.style == ReprStyle::Rust,
                variant,
                generic_params.clone(),
                mod_cfg,
            )?;
            is_tagged = is_tagged || variant.body.is_some();
            variants.push(variant);
        }

        let annotations = AnnotationSet::load(&item.attrs)?;

        if let Some(names) = annotations.list("enum-trailing-values") {
            for name in names {
                variants.push(EnumVariant::new(name, None, None, Documentation::none()));
            }
        }

        let path = Path::new(item.ident.to_string());
        let tag = if is_tagged {
            Some("Tag".to_string())
        } else {
            None
        };
        Ok(Enum::new(
            path,
            generic_params,
            repr,
            variants,
            tag,
            Cfg::append(mod_cfg, Cfg::load(&item.attrs)),
            annotations,
            Documentation::load(&item.attrs),
        ))
    }

    pub fn new(
        path: Path,
        generic_params: GenericParams,
        repr: Repr,
        variants: Vec<EnumVariant>,
        tag: Option<String>,
        cfg: Option<Cfg>,
        annotations: AnnotationSet,
        documentation: Documentation,
    ) -> Self {
        let export_name = path.name().to_owned();
        Self {
            path,
            export_name,
            generic_params,
            repr,
            variants,
            tag,
            cfg,
            annotations,
            documentation,
        }
    }
}

impl Item for Enum {
    fn path(&self) -> &Path {
        &self.path
    }

    fn export_name(&self) -> &str {
        &self.export_name
    }

    fn cfg(&self) -> Option<&Cfg> {
        self.cfg.as_ref()
    }

    fn annotations(&self) -> &AnnotationSet {
        &self.annotations
    }

    fn annotations_mut(&mut self) -> &mut AnnotationSet {
        &mut self.annotations
    }

    fn container(&self) -> ItemContainer {
        ItemContainer::Enum(self.clone())
    }

    fn rename_for_config(&mut self, config: &Config) {
        config.export.rename(&mut self.export_name);

        if self.tag.is_some() {
            // it makes sense to always prefix Tag with type name in C
            let new_tag = format!("{}_Tag", self.export_name);
            if self.repr.style == ReprStyle::Rust {
                for variant in &mut self.variants {
                    if let Some((_, ref mut body)) = variant.body {
                        let path = Path::new(new_tag.clone());
                        let generic_path = GenericPath::new(path, vec![]);
                        body.fields[0].1 = Type::Path(generic_path);
                    }
                }
            }
            self.tag = Some(new_tag);
        }

        for variant in &mut self.variants {
            if let Some((_, ref mut body)) = variant.body {
                body.rename_for_config(config);
            }
        }

        if config.enumeration.prefix_with_name
            || self.annotations.bool("prefix-with-name").unwrap_or(false)
        {
            for variant in &mut self.variants {
                variant.export_name = format!("{}_{}", self.export_name, variant.export_name);
                if let Some((_, ref mut body)) = variant.body {
                    body.export_name = format!("{}_{}", self.export_name, body.export_name());
                }
            }
        }

        let rules = [
            self.annotations.parse_atom::<RenameRule>("rename-all"),
            config.enumeration.rename_variants,
        ];

        if let Some(r) = find_first_some(&rules) {
            self.variants = self
                .variants
                .iter()
                .map(|variant| {
                    EnumVariant::new(
                        r.apply_to_pascal_case(
                            &variant.export_name,
                            IdentifierType::EnumVariant(self),
                        ),
                        variant.discriminant,
                        variant.body.as_ref().map(|body| {
                            (
                                r.apply_to_snake_case(&body.0, IdentifierType::StructMember),
                                body.1.clone(),
                            )
                        }),
                        variant.documentation.clone(),
                    )
                })
                .collect();
        }
    }

    fn add_dependencies(&self, library: &Library, out: &mut Dependencies) {
        for variant in &self.variants {
            variant.add_dependencies(library, out);
        }
    }
}

impl Source for Enum {
    fn write<F: Write>(&self, config: &Config, out: &mut SourceWriter<F>) {
        let size = self.repr.ty.map(|ty| match ty {
            ReprType::USize => "uint",
            ReprType::U64 => "uint64",
            ReprType::U32 => "uint32",
            ReprType::U16 => "uint16",
            ReprType::U8 => "uint8",
            ReprType::ISize => "int",
            ReprType::I64 => "int64",
            ReprType::I32 => "int32",
            ReprType::I16 => "int16",
            ReprType::I8 => "int8",
        });

        let condition = (&self.cfg).to_condition(config);

        condition.write_before(config, out);

        self.documentation.write(config, out);

        let is_tagged = self.tag.is_some();

        // If tagged, we need to emit a proper struct/union wrapper around our enum

        let enum_name = if let Some(ref tag) = self.tag {
            tag
        } else {
            self.export_name()
        };

        write!(out, "type {}*", enum_name);
        write!(out, " = {}", size.unwrap_or("int"));

        /*
        out.open_brace();
        for (i, variant) in self.variants.iter().enumerate() {
            if i != 0 {
                out.new_line()
            }
            variant.write(config, out);
        }
        if config.enumeration.add_sentinel(&self.annotations) {
            out.new_line();
            out.new_line();
            out.write("Sentinel /* this must be last for serialization purposes. */");
        }

        */
        // Done emitting the enum

        // If tagged, we need to emit structs for the cases and union them together
        if is_tagged {
            // Emit the cases for the structs
            for variant in &self.variants {
                if let Some((_, ref body)) = variant.body {
                    out.new_line();
                    out.new_line();

                    body.write(config, out);
                }
            }

            out.new_line();
            out.new_line();

            // Emit the actual union
            write!(out, "type {}*", self.export_name());
            self.generic_params.write(config, out);
            out.write(" = object");

            out.new_line();
            out.indent();

            write!(out, "tag*: {}", enum_name);

            out.new_line();

            for (i, &(ref field_name, ref body)) in self
                .variants
                .iter()
                .filter_map(|variant| variant.body.as_ref())
                .enumerate()
            {
                if i != 0 {
                    out.new_line();
                }
                write!(out, "{}*: {}", field_name, body.export_name());
            }

            out.dedent();
        }

        condition.write_after(config, out);
    }
}
