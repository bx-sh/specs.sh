## @function spec.load.specFiles
##
## Input: `SPEC_PATH_ARGUMENTS`
##
## Responsible for populating `SPEC_FILE_LIST`
##
## Default extensions defined in `SPEC_FILE_SUFFIXES`
##
spec.load.specFiles() {
  ___spec___.load.specFiles "$@"
}

___spec___.load.specFiles() {
  IFS=: read -ra specFileExtensions <<<"$SPEC_FILE_SUFFIXES"
  local pathArgument
  for pathArgument in "${SPEC_PATH_ARGUMENTS[@]}"
  do
    if [ -f "$pathArgument" ]
    then
      ## Default behavior:
      ##
      ## - Allow explicit files regardless of file extension
      SPEC_FILE_LIST+=("$pathArgument")
    elif [ -d "$pathArgument" ]
    then
      local suffix
      for suffix in "${specFileExtensions[@]}"
      do
        local specFile
        while read -d '' -r specFile
        do
          [ -f "$specFile" ] && SPEC_FILE_LIST+=("$specFile")
        done < <( find "$pathArgument" -type f -iname "*$suffix" -print0 )
      done
    else
      echo "Unexpected argument for spec.load.specFiles: $pathArgument. Expected: file or directory." >&2
      return 1
    fi
  done
}
