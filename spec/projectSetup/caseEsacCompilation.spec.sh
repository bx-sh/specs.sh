# Author `caseEsacCompiler` as a generic tool.
#
# Will be used with other projects.
#
# This tests for functionality which `specs` may not use.

# foo=42

before() {
  foo=53
}

@spec.caseEsacCompiler.can_compile_top_level_index_with_one_subcommand() {
  echo "foo $foo"
  [ 1 -eq 2 ]
}