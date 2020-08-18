spec.display.formatters.documentation.before:run.specFile() {
  ___spec___.display.formatters.documentation.before:run.specFile "$@"
}

___spec___.display.formatters.documentation.before:run.specFile() {
  [ -z "$SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR" ] && local SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR=34
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR}m" >&2
  printf "$SPEC_CURRENT_FILENAME"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  printf "]\n"
}