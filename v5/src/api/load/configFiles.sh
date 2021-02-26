## @function spec.load.configFiles
##
## Responsible for loading `SPEC_CONFIG_FILES`
##
## - if SPEC_CONFIG= is set, use that instead
## - else use SPEC_CONFIG_FILENAMES to search up and up

spec.load.configFiles() { ___spec___.load.configFiles "$@"; }

___spec___.load.configFiles() {
  declare -a SPEC_CONFIG_FILES=()

  if [ -n "$SPEC_CONFIG" ]
  then
    IFS=: read -ra configPaths <<<"$SPEC_CONFIG"
    local configPath
    for configPath in "${configPaths[@]}"
    do
      #if [ -n "$configPath" ] # TODO try :foo:
      #then
      if [ -f "$configPath" ]
      then
        spec.source.file "$configPath"
      else
        echo "Spec config file not found: $configPath" >&2
        return 1
      fi
      #fi
    done
  else
    IFS=: read -ra configFilenames <<<"$SPEC_CONFIG_FILENAMES"
    local directory="$( pwd )"
    while [ "$directory" != "/" ] && [ "$directory" != "." ]
    do
      local configFilename
      for configFilename in "${configFilenames[@]}"
      do
        [ -f "$directory/$configFilename" ] && SPEC_CONFIG_FILES+=("$directory/$configFilename")
      done
      directory="$( dirname "$directory" )"
    done
  fi
}