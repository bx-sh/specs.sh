#! /usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

SPEC_VERSION=0.5.0

spec.main() {
  ___spec___.main "$@"
}
___spec___.main() {
  spec.load.defaultVariables
  if [ "$1" = "--runFile" ]
  then
    shift
    spec.runFile "$@"
    return $?
  fi
  if [ $# -eq 1 ] && [ "$1" = "--version" ]
  then
    printf "spec.sh version " >&2
    printf "$SPEC_VERSION"
    return 0
  fi
  local runningAsFilename="${0/*\/}"
  declare -a SPEC_PATH_ARGUMENTS=()
  while [ $# -gt 0 ]
  do
    case "$1" in
      *)
        if [ -f "$1" ] || [ -d "$1" ]
        then
          SPEC_PATH_ARGUMENTS+=("$1")
          shift
        else
          echo "$runningAsFilename received unknown argument: $1. Expected file or directory or flag, e.g. --version." >&2
          return 1
        fi
        ;;
    esac
  done
  declare -a SPEC_FILE_LIST=()
  
  spec.load.specFiles
  declare SPEC_PASSED_FILES=()
  declare SPEC_FAILED_FILES=()
  spec.run.specFiles
  spec.get.specSuiteStatus
}

spec.get.specSuiteStatus() { ___spec___.get.specSuiteStatus "$@"; }
___spec___.get.specSuiteStatus() {
  [ "${#SPEC_FAILED_FILES[@]}" -eq 0 ]
}

spec.run.specFunction() { ___spec___.run.specFunction "$@"; }
___spec___.run.specFunction() {
  spec.run.function "$@"
}

spec.run.specFile() { ___spec___.run.specFile "$@"; }
___spec___.run.specFile() {
  local specFile="$1"
  set -e
  source "$specFile"
  set +e
  IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f @spec\." | sed 's/^declare -f //' )
  declare -a passedSpecFunctions=()
  declare -a failedSpecFunctions=()
  local specFunction
  for specFunction in "${specFunctions[@]}"
  do
    SPEC_CURRENT_FUNCTION="$specFunction"
    local _
    _="$( spec.run.specFunction "$specFunction" )"
    SPEC_CURRENT_EXITCODE=$?
    if [ $SPEC_CURRENT_EXITCODE -eq 0 ]
    then
      SPEC_CURRENT_STATUS=PASS
      passedSpecFunctions+="$specFunction"
    else
      SPEC_CURRENT_STATUS=FAIL
      failedSpecFunctions+="$specFunction"
    fi
    spec.display.after:run.specFunction
  done
  [ "${#failedSpecFunctions[@]}" -eq 0 ]
}

spec.run.specFiles() { ___spec___.run.specFiles "$@"; }
___spec___.run.specFiles() {
  local specFile
  for specFile in "${SPEC_FILE_LIST[@]}"
  do
    SPEC_CURRENT_FILEPATH="$specFile"
    SPEC_CURRENT_FILENAME="${specFile/*\/}"
    spec.display.before:run.specFile
    local _
    _="$( spec.run.specFile "$specFile" )"
    if [ $? -eq 0 ]
    then
      SPEC_PASSED_FILES+=("$specFile")
    else
      SPEC_FAILED_FILES+=("$specFile")
    fi
  done
}

spec.run.function() { ___spec___.run.function "$@"; }
___spec___.run.function() {
  local functionName="$1"
  shift
  "$functionName" "$@"
}

spec.display.after:run.specFunction() { ___spec___.display.after:run.specFunction "$@"; }
___spec___.display.after:run.specFunction() {
  local functionName="spec.display.formatters.$SPEC_FORMATTER.after:run.specFunction"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.display.before:run.specFile() { ___spec___.display.before:run.specFile "$@"; }
___spec___.display.before:run.specFile() {
  local functionName="spec.display.formatters.$SPEC_FORMATTER.before:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.load.defaultVariables() { ___spec___.load.defaultVariables "$@"; }
___spec___.load.defaultVariables() {
  [ -z "$SPEC_FILE_SUFFIXES" ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
  [ -z "$SPEC_FORMATTER"     ] && SPEC_FORMATTER="documentation"
  [ -z "$SPEC_COLOR"         ] && SPEC_COLOR=true
}

spec.load.specFiles() { ___spec___.load.specFiles "$@"; }
___spec___.load.specFiles() {
  IFS=: read -ra specFileExtensions <<<"$SPEC_FILE_SUFFIXES"
  local pathArgument
  for pathArgument in "${SPEC_PATH_ARGUMENTS[@]}"
  do
    if [ -f "$pathArgument" ]
    then
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

spec.display.formatters.documentation.after:run.specFunction() {
  ___spec___.display.formatters.documentation.after:run.specFunction "$@"
}
___spec___.display.formatters.documentation.after:run.specFunction() {
  :
}

spec.display.formatters.documentation.before:run.specFile() {
  ___spec___.display.formatters.documentation.before:run.specFile "$@"
}
___spec___.display.formatters.documentation.before:run.specFile() {
  [ -z "$SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR" ] && local SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR=34
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR}m" >&2
  printf "$SPEC_CURRENT_FILENAME"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  printf "]\n"
}

[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"
