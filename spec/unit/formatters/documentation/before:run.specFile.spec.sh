@setup() {
  SPEC_FORMATTER=documentation
}

@spec.prints_color_when_SPEC_COLOR_is_true() {
  export SPEC_COLOR=true
  assert run ./spec.sh examples/specSpecs/basics/passing.spec.sh
  expect "$STDOUT" toContain "[passing.spec.sh]"
  expect "$STDERR" toEqual "^[[34m^[[0m"
}

@spec.does_not_print_color_when_SPEC_COLOR_not_equal_true() {
  export SPEC_COLOR=false
  assert run ./spec.sh examples/specSpecs/basics/passing.spec.sh
  expect "$STDOUT" toContain "[passing.spec.sh]"
  expect "$STDERR" toBeEmpty
}

@spec.can_change_file_output_color() {
  export SPEC_COLOR=true
  export SPEC_THEME_FILE_COLOR="32;1"
  assert run ./spec.sh examples/specSpecs/basics/passing.spec.sh
  expect "$STDOUT" toContain "[passing.spec.sh]"
  expect "$STDERR" toEqual "^[[32;1m^[[0m"
}


# spec.display.formatters.documentation.before:run.specFile() {
#   ___spec___.display.formatters.documentation.before:run.specFile "$@"
# }

# ___spec___.display.formatters.documentation.before:run.specFile() {
#   printf "["
#   [ "$SPEC_COLOR" = "true" ] && printf "\033[34m" >&2
#   printf "$SPEC_CURRENT_FILENAME"
#   [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
#   printf "]\n"
# }