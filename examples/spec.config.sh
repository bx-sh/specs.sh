spec.specFunctionPrefixes() {
  echo test $(___spec___.specFunctionPrefixes)
}

spec.setupFunctionNames() {
  echo config $(___spec___.setupFunctionNames)
}

spec.teardownFunctionNames() {
  # support the built-in @teardown plus our own
  echo cleanup $(___spec___.teardownFunctionNames)
}
