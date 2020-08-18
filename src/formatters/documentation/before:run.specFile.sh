## @function spec.display.formatters.documentation.before:run.specFile
##
## - Displays the name of the file being run
##

spec.display.formatters.documentation.before:run.specFile() {
  ___spec___.display.formatters.documentation.before:run.specFile "$@"
}

___spec___.display.formatters.documentation.before:run.specFile() {
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_FILE_COLOR}m" >&2
  printf "$SPEC_CURRENT_FILENAME"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "]\n"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
}