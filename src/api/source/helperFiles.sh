spec.source.helperFiles() { ___spec___.source.helperFiles "$@"; }

# Loaded in reverse order so that the top-level (project-level) files are loaded before subdirectory onces
# SPEC_HELPER_FILES is populated in the reverse order (spec file dir, higher dir, higher dir...)
___spec___.source.helperFiles() {
  local ___spec___localHelperFile_index="$((${#SPEC_HELPER_FILES[@]}-1))"
  local ___spec___localHelperFile="${SPEC_HELPER_FILES[$___spec___localHelperFile_index]}"

  while [ $___spec___localHelperFile_index -gt -1 ]
  do
    spec.source.file "$___spec___localHelperFile"
    : $((___spec___localHelperFile_index--))
    ___spec___localHelperFile="${SPEC_HELPER_FILES[$___spec___localHelperFile_index]}"
  done
}