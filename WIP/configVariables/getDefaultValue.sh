specs._.store.configVariables.getDefaultValue() {
  ## ## getDefaultValue
  ##
  ## Get the default value of the configuration variable.
  ##
  ## | | Parameters |
  ## |-|------------|
  ## | `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
  ## | `$2` | (Optional) Name of BASH variable to store the output value. When provided, function does not print to STDOUT. |
  ##
  ## | | Return value | |
  ## |-|------------|
  ## | `0` | OK |
  ## | `1` | Configuration variable with the provided name does not exist. |
  ##

  # TODO return 1 if there is no var
  # [[ = "" ]] && return 1

  # Get the index of the configuration variable definition
  local __specs__configVariableIndex="${SPECS_CONFIG_VARIABLES[0]##*;$1:}"
  __specs__configVariableIndex="${__specs__configVariableIndex%%;*}"

  local __specs__configVariableDefaultValue="${SPECS_CONFIG_VARIABLES[$__specs__configVariableIndex]#*+}"
  echo "${__specs__configVariableDefaultValue%\[\[DESCRIPTION\]\]*}"
}