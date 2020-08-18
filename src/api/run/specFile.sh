## @function spec.run.specFile
##
## spec.runFile is run in a subshell by `spec.sh`
##
## It accepts one command-line argument: path to the file
##
spec.run.specFile() { ___spec___.run.specFile "$@"; }

___spec___.run.specFile() {

  # if args > 1 error ---- unit test this
  local specFile="$1"

  set -e
  source "$specFile"
  set +e

  # move to spec.load.specFunctions
  # get the @spec functions
  IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f @spec\." | sed 's/^declare -f //' )

  declare -a passedSpecFunctions=()
  declare -a failedSpecFunctions=()

  local specFunction
  for specFunction in "${specFunctions[@]}"
  do
    SPEC_CURRENT_FUNCTION="$specFunction"
    #spec.display.before:run.specFunction
    local _
    _="$( spec.run.specFunction "$specFunction" )"
    SPEC_CURRENT_EXITCODE=$?
    if [ $SPEC_CURRENT_EXITCODE -eq 0 ]
    then
      SPEC_CURRENT_STATUS=PASS
      passedSpecFunctions+="$specFunction"
    else
      SPEC_CURRENT_STATUS=FAIL
      failedSpecFunctions+="$specFunction"
    fi
    spec.display.after:run.specFunction
  done

  [ "${#failedSpecFunctions[@]}" -eq 0 ]
}
