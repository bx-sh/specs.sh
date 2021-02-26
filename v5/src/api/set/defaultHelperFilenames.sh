spec.set.defaultHelperFilenames() { ___spec___.set.defaultHelperFilenames "$@"; }

___spec___.set.defaultHelperFilenames() {
  [ -z "$SPEC_HELPER_FILENAMES"  ] && SPEC_HELPER_FILENAMES="specHelper.sh:testHelper.sh"
}