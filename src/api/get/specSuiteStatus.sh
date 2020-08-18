spec.get.specSuiteStatus() { ___spec___.get.specSuiteStatus "$@"; }

___spec___.get.specSuiteStatus() {
  [ "${#SPEC_FAILED_FILES[@]}" -eq 0 ]
}