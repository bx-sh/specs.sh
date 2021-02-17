spec.run.specFiles() { ___spec___.run.specFiles "$@"; }

___spec___.run.specFiles() {
  local specFile
  for specFile in "${SPEC_FILE_LIST[@]}"
  do
    SPEC_CURRENT_FILEPATH="$specFile"
    SPEC_CURRENT_FILENAME="${specFile/*\/}"
    spec.display.before:run.specFile

    # Create a new descriptor which redirects to STDOUT for subshell to write to.
    # This allows the child process (spec.run.specFile) colors to come thru!
    exec 4>&1

    local ___spec___unusedOutput
      ___spec___unusedOutput="$( spec.run.specFile "$specFile" >&4 )"
    SPEC_FILE_CURRENT_EXITCODE=$?

    # Close the redirection
    exec 4>&-

    if [ $SPEC_FILE_CURRENT_EXITCODE -eq 0 ]
    then
      SPEC_PASSED_FILES+=("$specFile")
    else
      SPEC_FAILED_FILES+=("$specFile")
    fi
    spec.display.after:run.specFile
  done
}