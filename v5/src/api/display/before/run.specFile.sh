spec.display.before:run.specFile() { ___spec___.display.before:run.specFile "$@"; }

___spec___.display.before:run.specFile() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.before:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}