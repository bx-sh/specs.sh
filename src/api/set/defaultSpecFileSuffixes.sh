## @variable SPEC_FILE_SUFFIXES
##
## - Sets the list of suffixes to use when searching directories for specs.
## - Default: `.specs.sh:.test.sh`
## - Can provide multiple `:`-separated suffixes
##
## @function spec.set.defaultSpecFileSuffixes
##
## - Sets default `SPEC_FILE_SUFFIXES` value: `.specs.sh:.test.sh`

spec.set.defaultSpecFileSuffixes() { ___spec___.set.defaultSpecFileSuffixes "$@"; }

___spec___.set.defaultSpecFileSuffixes() {
  [ -z "$SPEC_FILE_SUFFIXES" ] && SPEC_FILE_SUFFIXES=".specs.sh:.test.sh"
}