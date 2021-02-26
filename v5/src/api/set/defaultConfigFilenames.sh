spec.set.defaultConfigFilenames() { ___spec___.set.defaultConfigFilenames "$@"; }

___spec___.set.defaultConfigFilenames() {
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
}