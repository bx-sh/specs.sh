## @function spec.run.specFile
##
## - `spec.runFile` is run in a subshell by `spec.sh`
## - It accepts one command-line argument: path to the file
##
spec.run.specFile() { ___spec___.run.specFile "$@"; }

___spec___.run.specFile() {
  spec.source.specFile "$1"

  declare -a SPEC_FUNCTIONS=()
  declare -a SPEC_DISPLAY_NAMES=()
  
  spec.load.specFunctions

  declare -a SPEC_PENDING_FUNCTIONS=()
  declare -a SPEC_PENDING_DISPLAY_NAMES=()

  spec.load.pendingFunctions

  declare -a passedSpecFunctions=()
  declare -a failedSpecFunctions=()

  # TODO extract
  local index=0
  local specFunction
  for specFunction in "${SPEC_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_FUNCTION="$specFunction"
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_DISPLAY_NAMES[$index]}"
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
    (( index += 1 ))
  done

  # "run" all pending functions after the rest (uses same display formatter but status=PENDING)
  # TODO extract
  local index=0
  local pendingFunction
  for pendingFunction in "${SPEC_PENDING_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_FUNCTION="$pendingFunction"
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_PENDING_DISPLAY_NAMES[$index]}"
    SPEC_CURRENT_STATUS=PENDING
    #spec.display.before:run.specFunction
    spec.display.after:run.specFunction
    (( index += 1 ))
  done

  [ "${#failedSpecFunctions[@]}" -eq 0 ]
}
