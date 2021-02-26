spec.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes() { ___spec___.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes "$@"; }

___spec___.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="test\n@spec.\n@example.\n@it."
}