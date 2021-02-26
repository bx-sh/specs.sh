## @function spec.load.helperFiles
##
## Responsible for loading `SPEC_HELPER_FILES`
##
## - First argument is the full path to the spec file to find helper files for
##   - Unlike config files, spec helpers are loaded once per spec function
##     and they are searched for by starting with the system root and 
##     going up to the directory that the spec file is contained within
## - Uses `SPEC_HELPER_FILENAMES` (`:`-delimited) for names of files to look for
##

spec.load.helperFiles() { ___spec___.load.helperFiles "$@"; }

___spec___.load.helperFiles() {
  IFS=: read -ra helperFilenames <<<"$SPEC_HELPER_FILENAMES"
  local directory="$( dirname "$1" )"
  while [ "$directory" != "/" ] && [ "$directory" != "." ]
  do
    local helperFilename
    for helperFilename in "${helperFilenames[@]}"
    do
      [ -f "$directory/$helperFilename" ] && SPEC_HELPER_FILES+=("$directory/$helperFilename")
    done
    directory="$( dirname "$directory" )"
  done
}