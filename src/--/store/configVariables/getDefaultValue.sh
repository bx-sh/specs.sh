specs._.store.configVariables.getDefaultValue() {
  ## ### getDefaultValue
  ##
  ## | | Parameters |
  ## |-|------------|
  ## | `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
  ## | `$2` | (Optional) Name of BASH variable to store the output value. When provided, function does not print to STDOUT. |
  ##
  # SPECS_CONFIG_VARIABLES+=("$1;$2|$4+$5[[DESCRIPTION]]$3")
  echo foo
}