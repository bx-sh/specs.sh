## @function spec.source.specFile
##
## - Responsible for `source`-ing the provided spec file (provided as `$1`)
## - File name also available via `SPEC_CURRENT_FILEPATH`

spec.source.specFile() { ___spec___.source.specFile "$@"; }

___spec___.source.specFile() {
  spec.source.file "$@"
}