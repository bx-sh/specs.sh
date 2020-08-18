spec.display.after:run.specFunction() { ___spec___.display.after:run.specFunction "$@"; }

___spec___.display.after:run.specFunction() {
  local functionName="spec.display.formatters.$SPEC_FORMATTER.after:run.specFunction"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}