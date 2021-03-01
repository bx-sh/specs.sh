@pending.can_list_config_variables_including_descriptions_and_cli_flags_to_set() {
  expect { binSpecs config list } toContain SPECS_EXTENSIONS
  expect { binSpecs config list } toContain "List of 'specs' extensions to activate, see 'specs extensions' for info"
  expect { binSpecs config list } toContain "-x" "--extension"

  expect { binSpecs config list } toContain SPECS_STYLE
  expect { binSpecs config list } toContain "Select a style of specs to support, see 'specs styles' for info"
  expect { binSpecs config list } toContain "-s" "--style"

  expect { binSpecs config list } toContain SPECS_RANDOM
  expect { binSpecs config list } toContain "When set to 'true', specs are run in random order"
  expect { binSpecs config list } toContain "-r" "--random"

  expect { binSpecs config list } toContain SPECS_RANDOM_SEED
  expect { binSpecs config list } toContain "Seed used to generate random order in which specs may be run"
  expect { binSpecs config list } toContain "--random-seed"
}

@pending.can_configure_style_via_SPECS_STYLE_variable() {
  expect { binSpecs config list } toContain "SPECS_STYLE" "e.g. bdd or xunit" "[common]" # [selected value]
  expect { binSpecs config list } not toContain "[bdd]" "[xunit]" # neither bdd nor xunit are selected

  expect { binSpecs config list -s bdd }
  expect { binSpecs config list } toContain "[bdd]" # bdd is selected
  expect { binSpecs config list } not toContain "[common]" "[xunit]" # neither common nor xunit are selected
}