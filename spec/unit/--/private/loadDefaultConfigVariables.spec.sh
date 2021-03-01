@pending.loadDefaultConfigVariables.loads_default_config_variables() {
  loadSpecs

  # Assert group of known variables that should exist by default (regardless of what values they are set to)
  expect { specs -- store configVariables listNames } toContain "SPECS_STYLE" "SPECS_THEME" "SPECS_RANDOM" \
    "SPECS_RANDOM_SEED" "SPECS_PARALLEL" "SPECS_EXTENSIONS" "SPECS_REPORTER"

  # Assert a few obvious words which should be present in the descriptions
  expect { specs -- store configVariables listDetails } toContain "style" "theme" "random" "seed" "asynchronous" "reporter" "bdd" "xunit" "TAP" "specs"
}