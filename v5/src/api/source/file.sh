spec.source.file() { ___spec___.source.file "$@"; }

___spec___.source.file() {
  set -e
  source "$1"
  set +e
}