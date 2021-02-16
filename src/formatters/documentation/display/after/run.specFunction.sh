## @function spec.display.formatters.documentation.after:run.specFunction
##
## - Displays `[PASS]` or `[FAIL]` or `[PENDING]` with name of spec
##

spec.formatters.documentation.display.after:run.specFunction() {
  ___spec___.formatters.documentation.display.after:run.specFunction "$@"
}

___spec___.formatters.documentation.display.after:run.specFunction() {
  # [OK] or [FAIL] or [PENDING]
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  case "$SPEC_CURRENT_STATUS" in
    PASS)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PASS_COLOR}m" >&2
      printf "OK"
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
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "] "

  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SPEC_COLOR}m" >&2
  printf "$SPEC_CURRENT_DISPLAY_NAME\n"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  if [ "$SPEC_DISPLAY_OUTPUT" = "true" ] || [ "$SPEC_CURRENT_STATUS" = "FAIL" ]
  then
    if [ -n "$SPEC_CURRENT_STDOUT" ]
    then
      echo
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "\t["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_HEADER_COLOR}m" >&2
      printf "Standard Output"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDOUT\n\n" | sed 's/^/\t/'
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
    fi
    if [ -n "$SPEC_CURRENT_STDERR" ]
    then
      echo
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "\t["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_HEADER_COLOR}m" >&2
      printf "Standard Error"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDERR\n\n" | sed 's/^/\t/'
    fi
  fi
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
}