@spec.displays_stdout_and_stderr_if_spec_fails() {
  refute run ./spec.sh examples/specSpecs/basics/failing.stderrAndStdout.spec.sh
  
  # The STDERR from the test goes to out STDOUT not error
  expect "$STDERR" not toContain "[Standard Output]" "[Standard Error]"
  expect "$STDERR" not toContain "Hello STDERR from failing spec"
  expect "$STDERR" not toContain "Hello STDOUT from failing spec"

  # And it shows in the STDOUT
  # expect "$STDOUT" toContain "[Standard Error]\nHello STDERR from failing spec" # <--- TODO use as test-case for `expect` matcher
  # expect "$STDOUT" toContain "[Standard Output]\nHello STDOUT from failing spec"
  expect "$STDOUT" toContain "[Standard Error]" "Hello STDERR from failing spec"
  expect "$STDOUT" toContain "[Standard Output]" "Hello STDOUT from failing spec"
}

@spec.does_not_display_stdout_and_stderr_if_spec_passes() {
  assert run ./spec.sh examples/specSpecs/basics/passing.stderrAndStdout.spec.sh

  expect "$STDERR" not toContain "[Standard Output]"
  expect "$STDOUT" not toContain "[Standard Output]"
}

@spec.displays_stdout_and_stderr_if_SPEC_DISPLAY_OUTPUT_is_true.spec_passes() {
  export SPEC_DISPLAY_OUTPUT=true

  assert run ./spec.sh examples/specSpecs/basics/passing.stderrAndStdout.spec.sh

  expect "$STDERR" not toContain "[Standard Output]" "[Standard Error]"

  expect "$STDOUT" toContain "[Standard Error]" "Hello STDERR from passing spec"
  expect "$STDOUT" toContain "[Standard Output]" "Hello STDOUT from passing spec"
}

@pending.displays_stdout_and_stderr_if_SPEC_DISPLAY_OUTPUT_is_true.spec_fails() {
  :
}

  # @spec.i_output_things_and_i_pass() {
  #   echo "Hello STDOUT from passing spec"
  #   echo "Hello STDERR from passing spec" >&2
  # }

  # @spec.i_output_things_and_i_fail() {
  #   echo "Hello STDOUT from failing spec"
  #   echo "Hello STDERR from failing spec" >&2
  #   return 1
  # }