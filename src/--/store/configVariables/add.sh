specs._.store.configVariables.add() {
  ## ### add
  ##
  ## `store configVariables add`
  ##
  ## Add a configuration file and accompanying meta information, e.g.
  ##
  ## - The CLI flag(s) used to set the variable, if any
  ## - A friendly description
  ## - Default value
  ## - The type of variable, e.g. a `list`, a `bool`, or a single `value`
  ##
  ## | | Parameter description |
  ## |-|------------|
  ## | `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
  ## | `$2` | Type of configuration variable, e.g. `value` or `list` or `bool` |
  ## | `$3` | Helpful description of the variable for users of your variable |
  ## | `$4` | Space-separated list of CLI flags for configuring this variable, if any |
  ## | `$5` | Default value, if any. For `bool` values this should be `true` or empty string for false. |
  ##
  ## | | Return value | |
  ## |-|------------|
  ## | `0` | OK |
  ## | `1` | TODO: Variable with this name has already been configured. Consider using [`remove`](#remove) and then add again. |
  ##
  SPECS_CONFIG_VARIABLES[0]="${SPECS_CONFIG_VARIABLES[0]};$1:${#SPECS_CONFIG_VARIABLES[@]}"
  SPECS_CONFIG_VARIABLES+=("$1;$2|$4+$5[[DESCRIPTION]]$3")
}