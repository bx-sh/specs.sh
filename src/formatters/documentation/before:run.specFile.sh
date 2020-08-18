spec.display.formatters.documentation.before:run.specFile() {
  ___spec___.display.formatters.documentation.before:run.specFile "$@"
}

___spec___.display.formatters.documentation.before:run.specFile() {
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[34m" >&2
  printf "$SPEC_CURRENT_FILENAME"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  printf "]\n"
}