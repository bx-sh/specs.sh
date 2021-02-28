specs._.store.configVariables.add() {
  ## ### add
  ##
  ## Yadda yadda yadda
  ##
  ## | | Parameters |
  ## |-|------------|
  ## | `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
  ## | `$2` | Type of configuration variable, e.g. `value` or `list` or `bool` |
  ## | `$3` | Helpful description of the variable for users of your variable |
  ## | `$4` | Space-separated list of CLI flags for configuring this variable, if any |
  ## | `$5` | Default value, if any. For `bool` values this should be `true` or empty string for false. |
  ##
  SPECS_CONFIG_VARIABLES+=("$1;$2|$4+$5[[DESCRIPTION]]$3")
}