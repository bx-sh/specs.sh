@spec.can_list_config_variables_including_descriptions_and_cli_flags_to_set() {
  expect { binSpec config list } toContain SPECS_EXTENSIONS
  expect { binSpec config list } toContain "List of 'specs' extensions to activate, see 'specs extensions' for info"
  expect { binSpec config list } toContain "-x" "--extension"

  expect { binSpec config list } toContain SPECS_STYLE
  expect { binSpec config list } toContain "Select a style of specs to support, see 'specs styles' for info"
  expect { binSpec config list } toContain "-s" "--style"

  expect { binSpec config list } toContain SPECS_RANDOM
  expect { binSpec config list } toContain "When set to 'true', specs are run in random order"
  expect { binSpec config list } toContain "-r" "--random"

  expect { binSpec config list } toContain SPECS_RANDOM_SEED
  expect { binSpec config list } toContain "Seed used to generate random order in which specs may be run"
  expect { binSpec config list } toContain "--random-seed"
}

@pending.can_configure_style_via_SPECS_STYLE_variable() {
  expect { binSpec config list } toContain "SPECS_STYLE" "e.g. bdd or xunit" "[common]" # [selected value]
  expect { binSpec config list } not toContain "[bdd]" "[xunit]" # neither bdd nor xunit are selected

  expect { binSpec config list -s bdd }
  expect { binSpec config list } toContain "[bdd]" # bdd is selected
  expect { binSpec config list } not toContain "[common]" "[xunit]" # neither common nor xunit are selected
}