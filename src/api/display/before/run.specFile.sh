spec.display.before:run.specFile() {
  ___spec___.display.before:run.specFile "$@"
}

___spec___.display.before:run.specFile() {
  local functionName="spec.display.formatters.$SPEC_FORMATTER.before:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}