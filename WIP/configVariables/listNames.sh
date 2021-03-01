specs._.store.configVariables.listNames() {
  ## ## listNames
  ##
  ## | | Parameters |
  ## |-|------------|
  ## | | _None_ |
  ##
  local __specs__configVariables
  for __specs__configVariables in "${SPECS_CONFIG_VARIABLES[@]}"
  do
    echo "$__specs__configVariables"
  done
}