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

spec.loadAndSource.configFiles() { ___spec___.loadAndSource.configFiles "$@"; }
___spec___.loadAndSource.configFiles() {
  declare -a SPEC_CONFIG_FILES=()
  spec.load.configFiles && spec.source.configFiles
}

spec.source.specFile() { ___spec___.source.specFile "$@"; }
___spec___.source.specFile() {
  spec.source.file "$@"
}

spec.source.configFiles() { ___spec___.source.configFiles "$@"; }
___spec___.source.configFiles() {
  local ___spec___localConfigFile
  for ___spec___localConfigFile in "${SPEC_CONFIG_FILES[@]}"
  do
    spec.source.file "$___spec___localConfigFile"
  done
}

spec.source.file() { ___spec___.source.file "$@"; }
___spec___.source.file() {
  set -e
  source "$1"
  set +e
}

spec.run.specFunction() { ___spec___.run.specFunction "$@"; }
___spec___.run.specFunction() {
  spec.run.function "$@"
}

spec.run.specFile() { ___spec___.run.specFile "$@"; }
___spec___.run.specFile() {
  spec.source.specFile "$1"
  declare -a SPEC_FUNCTIONS=()
  declare -a SPEC_DISPLAY_NAMES=()
  
  spec.load.specFunctions
  declare -a passedSpecFunctions=()
  declare -a failedSpecFunctions=()
  local index=0
  local specFunction
  for specFunction in "${SPEC_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_FUNCTION="$specFunction"
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_DISPLAY_NAMES[$index]}"
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
    (( index += 1 ))
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
    spec.run.specFile "$specFile"
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
  local functionName="spec.formatters.$SPEC_FORMATTER.display.after:run.specFunction"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.display.before:run.specFile() { ___spec___.display.before:run.specFile "$@"; }
___spec___.display.before:run.specFile() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.before:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.set.defaultVariables() { ___spec___.set.defaultVariables "$@"; }
___spec___.set.defaultVariables() {
  spec.set.defaultStyle
  spec.set.defaultFormatter
  spec.set.defaultTheme
  spec.set.defaultSpecFileSuffixes
  spec.set.defaultConfigFilenames
}

spec.set.defaultFormatter() { ___spec___.set.defaultFormatter "$@"; }
___spec___.set.defaultFormatter() {
  [ -z "$SPEC_FORMATTER" ] && SPEC_FORMATTER="documentation"
}

spec.set.defaultConfigFilenames() { ___spec___.set.defaultConfigFilenames "$@"; }
___spec___.set.defaultConfigFilenames() {
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
}

spec.set.defaultTheme() { ___spec___.set.defaultTheme "$@"; }
___spec___.set.defaultTheme() {
  [ -z "$SPEC_COLOR"                     ] && SPEC_COLOR="true"
  [ -z "$SPEC_THEME_TEXT_COLOR"          ] && SPEC_THEME_TEXT_COLOR=39
  [ -z "$SPEC_THEME_PASS_COLOR"          ] && SPEC_THEME_PASS_COLOR=32
  [ -z "$SPEC_THEME_FAIL_COLOR"          ] && SPEC_THEME_FAIL_COLOR=31
  [ -z "$SPEC_THEME_PENDING_COLOR"       ] && SPEC_THEME_PENDING_COLOR=33
  [ -z "$SPEC_THEME_ERROR_COLOR"         ] && SPEC_THEME_ERROR_COLOR=31
  [ -z "$SPEC_THEME_FILE_COLOR"          ] && SPEC_THEME_FILE_COLOR=34
  [ -z "$SPEC_THEME_SPEC_COLOR"          ] && SPEC_THEME_SPEC_COLOR=39
  [ -z "$SPEC_THEME_SEPARATOR_COLOR"     ] && SPEC_THEME_SEPARATOR_COLOR=39
  [ -z "$SPEC_THEME_HEADER_COLOR"        ] && SPEC_THEME_HEADER_COLOR=39
  [ -z "$SPEC_THEME_STDOUT_COLOR"        ] && SPEC_THEME_STDOUT_COLOR=39
  [ -z "$SPEC_THEME_STDERR_COLOR"        ] && SPEC_THEME_STDERR_COLOR=39
  [ -z "$SPEC_THEME_STDOUT_HEADER_COLOR" ] && SPEC_THEME_STDOUT_HEADER_COLOR="34;1"
  [ -z "$SPEC_THEME_STDERR_HEADER_COLOR" ] && SPEC_THEME_STDERR_HEADER_COLOR="31;1"
}

spec.set.defaultStyle() { ___spec___.set.defaultStyle "$@"; }
___spec___.set.defaultStyle() {
  [ -z "$SPEC_STYLE" ] && SPEC_STYLE="xunit_and_spec"
}

spec.set.defaultSpecFileSuffixes() { ___spec___.set.defaultSpecFileSuffixes "$@"; }
___spec___.set.defaultSpecFileSuffixes() {
  [ -z "$SPEC_FILE_SUFFIXES" ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
}

spec.load.specFunctions() { ___spec___.load.specFunctions "$@"; }
___spec___.load.specFunctions() {
  local functionName="spec.styles.$SPEC_STYLE.load.specFunctions"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.load.configFiles() { ___spec___.load.configFiles "$@"; }
___spec___.load.configFiles() {
  if [ -n "$SPEC_CONFIG" ]
  then
    IFS=: read -ra configPaths <<<"$SPEC_CONFIG"
    local configPath
    for configPath in "${configPaths[@]}"
    do
      if [ -f "$configPath" ]
      then
        spec.source.file "$configPath"
      else
        echo "Spec config file not found: $configPath" >&2
        return 1
      fi
    done
  else
    IFS=: read -ra configFilenames <<<"$SPEC_CONFIG_FILENAMES"
    local directory="$( pwd )"
    [ -f "$directory/$configFilename" ] && SPEC_CONFIG_FILES+=("$directory/$configFilename")
    while [ "$directory" != "/" ] && [ "$directory" != "." ]
    do
      directory="$( dirname "$directory" )"
      local configFilename
      for configFilename in "${configFilenames[@]}"
      do
        [ -f "$directory/$configFilename" ] && SPEC_CONFIG_FILES+=("$directory/$configFilename")
      done
    done
  fi
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

spec.formatters.documentation.display.after:run.specFunction() {
  ___spec___.formatters.documentation.display.after:run.specFunction "$@"
}
___spec___.formatters.documentation.display.after:run.specFunction() {
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  case "$SPEC_CURRENT_STATUS" in
    PASS)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PASS_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    FAIL)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_FAIL_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    PENDING)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PENDING_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
    *)
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "$SPEC_CURRENT_STATUS"
      ;;
  esac
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "] "
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SPEC_COLOR}m" >&2
  printf "$SPEC_CURRENT_DISPLAY_NAME\n"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
}

spec.formatters.documentation.display.before:run.specFile() {
  ___spec___.formatters.documentation.display.before:run.specFile "$@"
}
___spec___.formatters.documentation.display.before:run.specFile() {
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_FILE_COLOR}m" >&2
  printf "$SPEC_CURRENT_FILENAME"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "]\n"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
}

spec.styles.spec.load.specFunctions() { ___spec___.styles.spec.load.specFunctions "$@"; }
___spec___.styles.spec.load.specFunctions() {
  IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f @spec\." | sed 's/^declare -f //' )
  local specFunction
  for specFunction in "${specFunctions[@]}"
  do
    SPEC_FUNCTIONS+=("$specFunction")
    SPEC_DISPLAY_NAMES+=("$( echo "$specFunction" | sed 's/^@spec\.//' | sed 's/_/ /g' )")
  done
}

spec.set.defaultVariables
spec.loadAndSource.configFiles
[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"
