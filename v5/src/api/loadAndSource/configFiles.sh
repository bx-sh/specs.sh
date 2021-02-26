spec.loadAndSource.configFiles() { ___spec___.loadAndSource.configFiles "$@"; }

# TODO remove this and make separate calls to load and source
___spec___.loadAndSource.configFiles() {
  spec.load.configFiles && spec.source.configFiles
}