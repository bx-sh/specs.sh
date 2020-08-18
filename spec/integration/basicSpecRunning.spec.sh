@spec.exits_zero_when_running_one_file_with_passing_specs() {
  assert run ./spec.sh examples/specSpecs/basics/passing.oneSpec.return0.spec.sh
  assert run ./spec.sh examples/specSpecs/basics/passing.oneSpec.exit0.spec.sh
  assert run ./spec.sh examples/specSpecs/basics/passing.threeSpecs.return0.spec.sh
  assert run ./spec.sh examples/specSpecs/basics/passing.threeSpecs.exit0.spec.sh
}

@spec.returns_zero_when_running_one_file_with_passing_specs() {
  refute run ./spec.sh examples/specSpecs/basics/failing.oneSpec.return1.spec.sh
  refute run ./spec.sh examples/specSpecs/basics/failing.oneSpec.exit1.spec.sh
  refute run ./spec.sh examples/specSpecs/basics/failing.threeSpecs.return1.spec.sh
  refute run ./spec.sh examples/specSpecs/basics/failing.threeSpecs.exit1.spec.sh
}


@spec.exits_zero_when_running_one_file_with_passing_and_pending_specs() {
  assert run ./spec.sh examples/specSpecs/basics/passing.somePending.onePasses.spec.sh
}

@spec.exits_non_zero_when_running_one_file_with_a_failing_spec() {
  refute run ./spec.sh examples/specSpecs/basics/failing.somePass.oneFails.spec.sh
}

@pending.runs_spec_files_in_separate_processes() {
  :
}

@pending.runs_individual_spec_functions_in_separate_function() {
  :
}
