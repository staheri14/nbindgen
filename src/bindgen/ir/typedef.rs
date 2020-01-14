/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use std::collections::HashMap;
use std::io::Write;

use syn;

use crate::bindgen::config::Config;
use crate::bindgen::dependencies::Dependencies;
use crate::bindgen::ir::{
    AnnotationSet, Cfg, ConditionWrite, Documentation, GenericParams, Item, ItemContainer, Path,
    ToCondition, Type,
};
use crate::bindgen::library::Library;
use crate::bindgen::writer::{Source, SourceWriter};

/// A type alias that is represented as a C typedef
#[derive(Debug, Clone)]
pub struct Typedef {
    pub path: Path,
    pub export_name: String,
    pub generic_params: GenericParams,
    pub aliased: Type,
    pub cfg: Option<Cfg>,
    pub annotations: AnnotationSet,
    pub documentation: Documentation,
}

impl Typedef {
    pub fn load(item: &syn::ItemType, mod_cfg: Option<&Cfg>) -> Result<Typedef, String> {
        if let Some(x) = Type::load(&item.ty)? {
            let path = Path::new(item.ident.to_string());
            Ok(Typedef::new(
                path,
                GenericParams::new(&item.generics),
                x,
                Cfg::append(mod_cfg, Cfg::load(&item.attrs)),
                AnnotationSet::load(&item.attrs)?,
                Documentation::load(&item.attrs),
            ))
        } else {
            Err("Cannot have a typedef of a zero sized type.".to_owned())
        }
    }

    pub fn new(
        path: Path,
        generic_params: GenericParams,
        aliased: Type,
        cfg: Option<Cfg>,
        annotations: AnnotationSet,
        documentation: Documentation,
    ) -> Self {
        let export_name = path.name().to_owned();
        Self {
            path,
            export_name,
            generic_params,
            aliased,
            cfg,
            annotations,
            documentation,
        }
    }

    pub fn simplify_standard_types(&mut self) {
        self.aliased.simplify_standard_types();
    }

    pub fn transfer_annotations(&mut self, out: &mut HashMap<Path, AnnotationSet>) {
        if self.annotations.is_empty() {
            return;
        }

        if let Some(alias_path) = self.aliased.get_root_path() {
            if out.contains_key(&alias_path) {
                warn!(
                    "Multiple typedef's with annotations for {}. Ignoring annotations from {}.",
                    alias_path, self.path
                );
                return;
            }

            out.insert(alias_path, self.annotations.clone());
            self.annotations = AnnotationSet::new();
        }
    }
}

impl Item for Typedef {
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
        ItemContainer::Typedef(self.clone())
    }

    fn rename_for_config(&mut self, config: &Config) {
        config.export.rename(&mut self.export_name);
        self.aliased.rename_for_config(config, &self.generic_params);
    }

    fn add_dependencies(&self, library: &Library, out: &mut Dependencies) {
        self.aliased
            .add_dependencies_ignoring_generics(&self.generic_params, library, out);
    }
}

impl Source for Typedef {
    fn write<F: Write>(&self, config: &Config, out: &mut SourceWriter<F>) {
        let condition = (&self.cfg).to_condition(config);
        condition.write_before(config, out);

        self.documentation.write(config, out);

        write!(out, "type {}*", self.export_name());

        self.generic_params.write(config, out);

        out.write(" = ");
        self.aliased.write(config, out);

        condition.write_after(config, out);
    }
}
