/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use std::io::Write;

use syn;

use crate::bindgen::config::Config;
use crate::bindgen::dependencies::Dependencies;
use crate::bindgen::ir::{
    AnnotationSet, Cfg, ConditionWrite, Documentation, GenericParams, Item, ItemContainer, Path,
    ToCondition,
};
use crate::bindgen::library::Library;
use crate::bindgen::writer::{Source, SourceWriter};

#[derive(Debug, Clone)]
pub struct OpaqueItem {
    pub path: Path,
    pub export_name: String,
    pub generic_params: GenericParams,
    pub cfg: Option<Cfg>,
    pub annotations: AnnotationSet,
    pub documentation: Documentation,
}

impl OpaqueItem {
    pub fn load(
        path: Path,
        generics: &syn::Generics,
        attrs: &[syn::Attribute],
        mod_cfg: Option<&Cfg>,
    ) -> Result<OpaqueItem, String> {
        Ok(Self::new(
            path,
            GenericParams::new(generics),
            Cfg::append(mod_cfg, Cfg::load(attrs)),
            AnnotationSet::load(attrs).unwrap_or_else(|_| AnnotationSet::new()),
            Documentation::load(attrs),
        ))
    }

    pub fn new(
        path: Path,
        generic_params: GenericParams,
        cfg: Option<Cfg>,
        annotations: AnnotationSet,
        documentation: Documentation,
    ) -> OpaqueItem {
        let export_name = path.name().to_owned();
        Self {
            path,
            export_name,
            generic_params,
            cfg,
            annotations,
            documentation,
        }
    }
}

impl Item for OpaqueItem {
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
        ItemContainer::OpaqueItem(self.clone())
    }

    fn rename_for_config(&mut self, config: &Config) {
        config.export.rename(&mut self.export_name);
    }

    fn add_dependencies(&self, _: &Library, _: &mut Dependencies) {}
}

impl Source for OpaqueItem {
    fn write<F: Write>(&self, config: &Config, out: &mut SourceWriter<F>) {
        let condition = (&self.cfg).to_condition(config);
        condition.write_before(config, out);

        self.documentation.write(config, out);

        write!(out, "type {}*", self.export_name());

        self.generic_params.write(config, out);

        out.write(" {.incompleteStruct.} = object");

        condition.write_after(config, out);
    }
}
