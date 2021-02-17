spec.display.after:run.specFile() { ___spec___.display.after:run.specFile "$@"; }

___spec___.display.after:run.specFile() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.after:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}