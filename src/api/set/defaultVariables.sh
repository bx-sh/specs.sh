spec.set.defaultVariables() { ___spec___.set.defaultVariables "$@"; }

___spec___.set.defaultVariables() {
  [ -z "$SPEC_FILE_SUFFIXES"     ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
  [ -z "$SPEC_FORMATTER"         ] && SPEC_FORMATTER="documentation"
  [ -z "$SPEC_COLOR"             ] && SPEC_COLOR="true"
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
}
