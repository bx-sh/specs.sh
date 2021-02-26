# Author `caseEsacCompiler` as a generic tool.
#
# Will be used with other projects.
#
# This tests for functionality which `specs` may not use.

@before() {
  foo=15
  echo "hi from before"
}

@spec.caseEsacCompiler.can_compile_top_level_index_with_one_subcommand() {
  echo "foo $foo"
  [ 1 -eq 2 ]
}

@spec.caseEsacCompiler.something_else() {
  echo "foo $foo"
  [ 1 -eq 2 ]
}