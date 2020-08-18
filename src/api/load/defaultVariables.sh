spec.load.defaultVariables() {
  ___spec___.load.defaultVariables "$@"
}

___spec___.load.defaultVariables() {
  [ -z "$SPEC_FILE_SUFFIXES" ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
  [ -z "$SPEC_FORMATTER"     ] && SPEC_FORMATTER="documentation"
  [ -z "$SPEC_COLOR"         ] && SPEC_COLOR=true
}
