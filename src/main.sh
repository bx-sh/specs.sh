spec.main() {
  ___spec___.main "$@"
}

___spec___.main() {
  spec.load.defaultVariables

  # spec.load.configs

  # --runFile invokes spec.runFile (use this script to run file)
  if [ "$1" = "--runFile" ]
  then
    shift
    spec.runFile "$@"
    return $?
  fi

  # --version
  if [ $# -eq 1 ] && [ "$1" = "--version" ]
  then
    printf "spec.sh version " >&2
    printf "$SPEC_VERSION"
    return 0
  fi

  # 'spec' or 'spec.sh' or whatever file is named
  local runningAsFilename="${0/*\/}"

  declare -a SPEC_PATH_ARGUMENTS=()

  # Process Command Line Arguments
  #
  # TODO move this to a .load. function
  #
  while [ $# -gt 0 ]
  do
    case "$1" in
      *)
        if [ -f "$1" ] || [ -d "$1" ]
        then
          SPEC_PATH_ARGUMENTS+=("$1")
          shift
        else
          echo "$runningAsFilename received unknown argument: $1. Expected file or directory or flag, e.g. --version." >&2
          return 1
        fi
        ;;
    esac
  done

  declare -a SPEC_FILE_LIST=()

  spec.load.specFiles

  # local specPathToLoad
  # for specPathToLoad in "${SPEC_PATH_ARGUMENTS[@]}"
  # do
  #   if [ -f "$specPathToLoad" ]
  #   then
  #     SPEC_FILE_LIST+="$specPathToLoad"
  #   fi
  # done

  declare passedSpecFiles=()
  declare failedSpecFiles=()

  local specFile
  for specFile in "${SPEC_FILE_LIST[@]}"
  do
    local _
    _="$( spec.run.specFile "$specFile" )"
    if [ $? -eq 0 ]
    then
      passedSpecFiles+=("$specFile")
    else
      failedSpecFiles+=("$specFile")
    fi
  done

  [ "${#failedSpecFiles[@]}" -eq 0 ]
}
