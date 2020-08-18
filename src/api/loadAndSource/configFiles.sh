spec.loadAndSource.configFiles() { ___spec___.loadAndSource.configFiles "$@"; }

___spec___.loadAndSource.configFiles() {
  declare -a SPEC_CONFIG_FILES=()
  spec.load.configFiles && spec.source.configFiles
}