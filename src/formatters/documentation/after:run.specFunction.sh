## @function spec.display.formatters.documentation.after:run.specFunction
##
## - Displays `[PASS]` or `[FAIL]` or `[PENDING]` with name of spec
##

spec.display.formatters.documentation.after:run.specFunction() {
  ___spec___.display.formatters.documentation.after:run.specFunction "$@"
}

___spec___.display.formatters.documentation.after:run.specFunction() {
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  case "$SPEC_CURRENT_STATUS" in
    PASS)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PASS_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    FAIL)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_FAIL_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    PENDING)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PENDING_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    *)
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
  esac
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "] "
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SPEC_COLOR}m" >&2

  # TODO change to display name
  printf "$SPEC_CURRENT_FUNCTION\n"
  
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
}