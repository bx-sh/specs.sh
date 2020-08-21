spec.styles.spec.get.functionDisplayName() { ___spec___.styles.spec.get.functionDisplayName "$@"; }

___spec___.styles.spec.get.functionDisplayName() {
  local functionName="$1"
  displayName="${functionName//_/ }" # convert _ into space
  displayName="${displayName//\./ }" # convert . into space
  displayName="$( echo "$displayName" | sed 's/ \+/ /g' )" # compact spaces
  printf "$displayName"
}