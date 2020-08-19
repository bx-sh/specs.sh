spec.main() {
  ___spec___.main "$@"
}

___spec___.main() {
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

  # -h, --help
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]
  then
    spec.display.cliUsage
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
  
  # spec.load.specFiles is responsible for populating SPEC_FILE_LIST
  spec.load.specFiles

  declare SPEC_PASSED_FILES=()
  declare SPEC_FAILED_FILES=()

  # spec.run.specFiles is responsible for populating SPEC_PASSED_FILES/SPEC_FAILED_FILES
  #                                       and a whole lot more! kicks off spec.run.specFile
  spec.run.specFiles

  # spec.get.specSuiteStatus is responsible for returning 0 or a non-zero value to
  #                                             represent the whole suite's result status
  spec.get.specSuiteStatus
}
