specs._.private.init.loadDefaultConfigVariables() {
  ## ### loadDefaultConfigVariables
  ##
  ## 🕵️ `store private init loadDefaultConfigVariables`
  ##
  ## | | Parameter description |
  ## |-|------------|
  ## | `$@` | _No parameters_ |
  ##
  ## | | Return value | |
  ## |-|------------|
  ## | `$?` | _No explicit return_ |
  ##

  # Initialize with no variables
  SPECS_CONFIG_VARIABLES=("")

  # specs -- store configVariables add 

  ## | `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
  ## | `$2` | Type of configuration variable, e.g. `value` or `list` or `bool` |
  ## | `$3` | Helpful description of the variable for users of your variable |
  ## | `$4` | Space-separated list of CLI flags for configuring this variable, if any |
  ## | `$5` | Default value, if any. For `bool` values this should be `true` or empty string for false. |
}