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

  declare -a SPEC_PASSED_FUNCTIONS=()
  declare -a SPEC_PASSED_DISPLAY_NAMES=()

  declare -a SPEC_FAILED_FUNCTIONS=()
  declare -a SPEC_FAILED_DISPLAY_NAMES=()

  # TODO extract this whole bit :)

  local SPEC_CURRENT_INDEX=0
  local SPEC_CURRENT_FUNCTION
  for SPEC_CURRENT_FUNCTION in "${SPEC_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"

    #spec.display.before:run.specFunction

    # EXTRACT BELOW

    # Just do:
    # spec.run.specFunction or **spec.run.spec** "..." (not in a subshell - which'll run the function + setup etc)

    local SPEC_TEMP_STDOUT_FILE="$( mktemp )"
    local SPEC_TEMP_STDERR_FILE="$( mktemp )"

    local ___spec___unusedOutput
    #___spec___unusedOutput="$( spec.run.specWithSetupAndTeardown "$SPEC_CURRENT_FUNCTION" )"
    ___spec___unusedOutput="$( spec.run.specFunction "$SPEC_CURRENT_FUNCTION" 1>>"$SPEC_TEMP_STDOUT_FILE" 2>>"$SPEC_TEMP_STDERR_FILE" )"
    SPEC_CURRENT_EXITCODE=$?

    local SPEC_CURRENT_STDOUT="$( < "$SPEC_TEMP_STDOUT_FILE" )"
    local SPEC_CURRENT_STDERR="$( < "$SPEC_TEMP_STDERR_FILE" )"

    rm "$SPEC_TEMP_STDOUT_FILE"
    rm "$SPEC_TEMP_STDERR_FILE"

    if [ $SPEC_CURRENT_EXITCODE -eq 0 ]
    then
      local SPEC_CURRENT_STATUS=PASS
      SPEC_PASSED_FUNCTIONS+="$SPEC_CURRENT_FUNCTION"
      SPEC_PASSED_DISPLAY_NAMES+="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    else
      local SPEC_CURRENT_STATUS=FAIL
      SPEC_FAILED_FUNCTIONS+="$SPEC_CURRENT_FUNCTION"
      SPEC_FAILED_DISPLAY_NAMES+="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    fi
    # EXTRACT ABOVE

    spec.display.after:run.specFunction

    (( SPEC_CURRENT_INDEX += 1 ))
  done

  # "run" all pending functions after the rest (uses same display formatter but status=PENDING)
  # TODO extract
  local SPEC_CURRENT_INDEX=0
  local SPEC_CURRENT_FUNCTION
  for SPEC_CURRENT_FUNCTION in "${SPEC_PENDING_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_PENDING_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    SPEC_CURRENT_STATUS=PENDING
    #spec.display.before:run.specFunction
    spec.display.after:run.specFunction
    (( SPEC_CURRENT_INDEX += 1 ))
  done

  [ "${#SPEC_FAILED_FUNCTIONS[@]}" -eq 0 ]
}
