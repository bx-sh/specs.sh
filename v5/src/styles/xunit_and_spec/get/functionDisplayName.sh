spec.styles.xunit_and_spec.get.functionDisplayName() { ___spec___.styles.xunit_and_spec.get.functionDisplayName "$@"; }

___spec___.styles.xunit_and_spec.get.functionDisplayName() {
  local functionName="$1"
  displayName="${functionName//_/ }" # convert _ into space
  displayName="${displayName//\./ }" # convert . into space
  displayName="$( printf "$displayName" | sed 's/\([A-Z]\)/ \1/g' )" # convert 'camelCase' to ' Camel Case'
  displayName="${displayName##[[:space:]]}" # strip extraneous leading space
  displayName="$( echo "$displayName" | sed 's/ \+/ /g' )" # compact spaces
  printf "$displayName"
}