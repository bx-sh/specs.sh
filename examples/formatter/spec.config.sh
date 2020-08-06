# Display every function that is run
spec.runFunction() {
  echo -e "\t[RUN $SPEC_CURRENT_FUNCTION]"
  ___spec___.runFunction "$@"
}

# Print the file name
spec.displaySpecBanner() {
  echo "[Spec File: $SPEC_FILE]"
}

# Print the spec that is about to be run
spec.displayRunningSpec() {
  printf "\t> Running $SPEC_NAME ... "
}

# Print the spec result
spec.displaySpecResult() {
  echo "[$SPEC_STATUS]"
  echo
  if [ -n "$SPEC_STDERR" ]
  then
    echo -e "\t\tSTDERR: (($SPEC_STDERR))"
  fi
}

# Display summary of totals
spec.displaySpecSummary() {
  if [ $SPEC_TOTAL_COUNT -eq 0 ]
  then
    echo "No tests to run"
  elif [ $SPEC_FAILED_COUNT -gt 0 ]
  then
    echo "[$SPEC_SUITE_STATUS] Tests failed. $SPEC_PASSED_COUNT passed, $SPEC_FAILED_COUNT failed, $SPEC_PENDING_COUNT pending."
  else
    echo "[$SPEC_SUITE_STATUS] Tests failed. $SPEC_PASSED_COUNT passed, $SPEC_FAILED_COUNT failed, $SPEC_PENDING_COUNT pending."
  fi
}
