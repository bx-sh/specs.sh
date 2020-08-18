## @function spec.run.specFile
##
## spec.runFile is run in a subshell by `spec.sh`
##
## It accepts one command-line argument: path to the file
##
spec.run.specFile() {
  ___spec___.run.specFile "$@"
}

___spec___.run.specFile() {
  # if args > 1 error ---- unit test this
  local specFile="$1"

  set -e
  source "$specFile"
  set +e

  # move to spec.load.specFunctions
  # get the @spec functions
  IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f @spec\." | sed 's/^declare -f //' )

  declare -a passedSpecFunctions=()
  declare -a failedSpecFunctions=()

  local specFunction
  for specFunction in "${specFunctions[@]}"
  do
    local _
    _="$( spec.run.specFunction "$specFunction" )"
    if [ $? -eq 0 ]
    then
      passedSpecFunctions+="$specFunction"
    else
      failedSpecFunctions+="$specFunction"
    fi
  done

  [ "${#failedSpecFunctions[@]}" -eq 0 ]
}
