spec.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes() { ___spec___.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes "$@"; }

___spec___.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="xtest\n@pending.\n@xspec.\n@xexample.\n@xit.\n@_."
}