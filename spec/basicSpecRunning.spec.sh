@spec.exits_zero_when_running_one_file_with_passing_specs() {
  assert run ./spec.sh examples/specSpecs/basics/passing.oneSpec.return0.spec.sh
}

@spec.default_formatter.prints_the_name_of_the_file_being_run() {
  refute run ./spec.sh examples/specSpecs/basics/failing.oneSpec.return1.spec.sh
}

@pending.default_formatter.prints_the_name_of_the_spec_functions_run() {
  :
}

@pending.exits_zero_when_running_one_file_with_passing_and_pending_specs() {
  :
}

@pending.exits_non_zero_when_running_one_file_with_a_failing_spec() {
  :
}

@pending.runs_spec_files_in_separate_processes() {
  :
}

@pending.runs_individual_spec_functions_in_separate_function() {
  :
}

@pending.runs_spec_functions_in_random_order() {
  :
  # put 100 spec functions into a file and run it until the order is different
  # timeout 20 runs
  # that makes is so very insanely unlikely that this would flake out.
}