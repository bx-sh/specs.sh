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

spec.set.defaultVariables() { ___spec___.set.defaultVariables "$@"; }
___spec___.set.defaultVariables() {
  [ -z "$SPEC_FILE_SUFFIXES"     ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
  [ -z "$SPEC_FORMATTER"         ] && SPEC_FORMATTER="documentation"
  [ -z "$SPEC_COLOR"             ] && SPEC_COLOR="true"
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
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


assert() {
  local command="$1"
  shift
  "$command" "$@"
  if [ $? -ne 0 ]
  then
    echo "Expected to succeed, but failed: \$ $command $@" >&2
    exit 1
  fi
  return 0
}

refute() {
  local command="$1"
  shift
  "$command" "$@"
  if [ $? -eq 0 ]
  then
    echo "Expected to fail, but succeeded: \$ $command $@" >&2
    exit 1
  fi
  return 0
}

run() {
  local VERSION="0.3.0"
  [[ "$1" = "--version" ]] && { echo "run version $VERSION"; return 0; }
  local runInSubShell=false
  if [[ "$1" = "--" ]]
  then
    runInSubShell=true
    shift
  fi
  local stdoutFile="$( mktemp )"
  local stderrFile="$( mktemp )"
  local _
  if [ "$runInSubShell" = "true" ]
  then
    _="$( "$@" 1>"$stdoutFile" 2>"$stderrFile" )"
    EXIT_CODE=$?
  else
    "$@" 1>"$stdoutFile" 2>"$stderrFile"
    EXIT_CODE=$?
  fi
  STDOUT="$( cat "$stdoutFile" )"
  STDERR="$( cat "$stderrFile" )"
  OUTPUT="${STDOUT}\n${STDERR}"
  rm -f "$stdoutFile"
  rm -f "$stderrFile"
  return $EXIT_CODE
}

expect() {
  [ $# -eq 0 ] && { echo "Missing required argument for 'expect': actual value or { code block } or {{ subshell code block }}" >&2; return 1; }
  EXPECT_VERSION=0.3.0
  [ $# -eq 1 ] && [ "$1" = "--version" ] && { echo "expect version $EXPECT_VERSION"; return 0; }
  [ -z "$EXPECT_BLOCK_START_PATTERN" ] && local EXPECT_BLOCK_START_PATTERN="^[\[{]+$"
  [ -z "$EXPECT_BLOCK_END_PATTERN"   ] && local EXPECT_BLOCK_END_PATTERN="^[\]}]+$"
  local EXPECT_BLOCK_TYPE=""
  local EXPECT_ACTUAL_RESULT=""
  declare -a EXPECT_BLOCK=()
  if [[ "$1" =~ $EXPECT_BLOCK_START_PATTERN ]]
  then
    EXPECT_BLOCK_TYPE="$1"
    shift
    while [ $# -gt 0 ]
    do
      eval "[[ \"$1\" =~ $EXPECT_BLOCK_END_PATTERN ]] && break" 
      EXPECT_BLOCK+=("$1")
      shift
    done
    eval "if [[ \"\$1\" =~ $EXPECT_BLOCK_END_PATTERN ]]
          then
            shift
          else
            echo \"Expected block closing braces but found none\" >&2
            return 1
          fi"
  else
    EXPECT_ACTUAL_RESULT="$1"
    shift
  fi
  local EXPECT_NOT=""
  [ "$1" = "not" ] && { EXPECT_NOT=true; shift; }
  local EXPECT_MATCHER_NAME="$1"
  shift
  if [ -n "$EXPECT_MATCHER_FUNCTION" ]
  then
    "$EXPECT_MATCHER_FUNCTION" "$@"
  else
    "expect.matcher.$EXPECT_MATCHER_NAME" "$@"
  fi
}
EXPECTATION_FAILED="exit 1"
expect.fail() {
  echo -e "$*" >&2
  $EXPECTATION_FAILED
}

expect.matcher.toOutput() {
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toOutput requires a block" >&2; exit 1; }
  local ___expect___Check_STDOUT=""
  local ___expect___Check_STDERR=""
  [ "$1" = "toStdout" ] || [ "$1" = "toSTDOUT" ] && { ___expect___Check_STDOUT=true; shift; }
  [ "$1" = "toStderr" ] || [ "$1" = "toSTDERR" ] && { ___expect___Check_STDERR=true; shift; }
  [ $# -lt 1 ] && { echo "toOutput expects 1 or more arguments, received $#" >&2; exit 1; }
  local ___expect___RunInSubshell=""
  [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
  local ___expect___STDOUT_file="$( mktemp )"
  local ___expect___STDERR_file="$( mktemp )"
  local ___expect___RunInSubshell_
  local ___expect___ExitCode
  if [ "$___expect___RunInSubshell" = "true" ]
  then
    ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
    ___expect___ExitCode=$?
  else
    "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
    ___expect___ExitCode=$?
  fi
  local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
  local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
  ___expect___STDOUT="${___expect___STDOUT/%"\n"}"
  ___expect___STDERR="${___expect___STDERR/%"\n"}"
  local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
  rm -rf "$___expect___STDOUT_file"
  rm -rf "$___expect___STDERR_file"
  local ___expect___STDOUT_actual="$( echo -e "$___expect___STDOUT" | cat -vet )"
  local ___expect___STDERR_actual="$( echo -e "$___expect___STDERR" | cat -vet )"
  local ___expect___OUTPUT_actual="$( echo -e "$___expect___OUTPUT" | cat -vet )"
  local ___expect___expected
  for ___expect___expected in "$@"
  do
    local ___expect___ExpectedResult="$( echo -e "$___expect___expected" | cat -vet )"
    if [ -n "$___expect___Check_STDOUT" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$___expect___STDOUT" != *"$___expect___expected"* ]]
        then
          expect.fail "Expected STDOUT to contain text\nSTDOUT: '$___expect___STDOUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$___expect___STDOUT" = *"$___expect___expected"* ]]
        then
          expect.fail "Expected STDOUT not to contain text\nSTDOUT: '$___expect___STDOUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    elif [ -n "$___expect___Check_STDERR" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$___expect___STDERR" != *"$___expect___expected"* ]]
        then
          expect.fail "Expected STDERR to contain text\nSTDERR: '$___expect___STDERR_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$___expect___STDERR" = *"$___expect___expected"* ]]
        then
          expect.fail "Expected STDERR not to contain text\nSTDERR: '$___expect___STDERR_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    else
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$___expect___OUTPUT" != *"$___expect___expected"* ]]
        then
          expect.fail "Expected output to contain text\nOutput: '$___expect___OUTPUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$___expect___OUTPUT" = *"$___expect___expected"* ]]
        then
          expect.fail "Expected output not to contain text\nOutput: '$___expect___OUTPUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    fi
  done
  return 0
}

expect.matcher.toMatch() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toMatch expects at least 1 argument (BASH regex patterns), received $# [$*]" >&2; exit 1; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
    local ___expect___STDOUT_file="$( mktemp )"
    local ___expect___STDERR_file="$( mktemp )"
    local ___expect___RunInSubshell_
    local ___expect___ExitCode
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
      ___expect___ExitCode=$?
    else
      "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
      ___expect___ExitCode=$?
    fi
    local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
    local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
    local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
    rm -rf "$___expect___STDOUT_file"
    rm -rf "$___expect___STDERR_file"
  fi
  local actualResult
  
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    actualResult="${___expect___OUTPUT/%"\n"}"
  else
    actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"
  local pattern
  for pattern in "$@"
  do
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ ! "$actualResult" =~ $pattern ]]
      then
        expect.fail "Expected result to match\nActual text: '$actualResultOutput'\nPattern: '$pattern'"
      fi
    else
      if [[ "$actualResult" =~ $pattern ]]
      then
        expect.fail "Expected result not to match\nActual text: '$actualResultOutput'\nPattern: '$pattern'"
      fi
    fi
  done
  return 0
}

expect.matcher.toEqual() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -ne 1 ] && { echo "toEqual expects 1 argument (expected result), received $# [$*]" >&2; exit 1; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
    local ___expect___STDOUT_file="$( mktemp )"
    local ___expect___STDERR_file="$( mktemp )"
    local ___expect___RunInSubshell_
    local ___expect___ExitCode
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
      ___expect___ExitCode=$?
    else
      "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
      ___expect___ExitCode=$?
    fi
    local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
    local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
    local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
    rm -rf "$___expect___STDOUT_file"
    rm -rf "$___expect___STDERR_file"
  fi
  local actualResult
  
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    actualResult="${___expect___OUTPUT/%"\n"}"
  else
    actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"
  local expectedResultOutput="$( echo -ne "$1" | cat -vet )"
  if [ -z "$EXPECT_NOT" ]
  then
    if [ "$actualResultOutput" != "$expectedResultOutput" ]
    then
      expect.fail "Expected result to equal\nActual: '$actualResultOutput'\nExpected: '$expectedResultOutput'"
    fi
  else
    if [ "$actualResultOutput" = "$expectedResultOutput" ]
    then
      expect.fail "Expected result not to equal\nActual: '$actualResultOutput'\nExpected: '$expectedResultOutput'"
    fi
  fi
  return 0
}

expect.matcher.toBeEmpty() {
  [ $# -gt 0 ] && { echo "toBeEmpty expects 0 arguments, received $# [$*]" >&2; exit 1; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
    local ___expect___STDOUT_file="$( mktemp )"
    local ___expect___STDERR_file="$( mktemp )"
    local ___expect___RunInSubshell_
    local ___expect___ExitCode
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
      ___expect___ExitCode=$?
    else
      "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
      ___expect___ExitCode=$?
    fi
    local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
    local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
    local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
    rm -rf "$___expect___STDOUT_file"
    rm -rf "$___expect___STDERR_file"
  fi
  local actualResult
  
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    actualResult="${___expect___OUTPUT/%"\n"}"
  else
    actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"
  if [ -z "$EXPECT_NOT" ]
  then
    if [ -n "$actualResult" ]
    then
      expect.fail "Expected result to be empty\nActual: '$actualResultOutput'"
    fi
  else
    if [ -z "$actualResult" ]
    then
      expect.fail "Expected result not to be empty\nActual: '$actualResultOutput'"
    fi
  fi
  return 0
}

expect.matcher.toContain() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toContain expects 1 or more arguments, received $# [$*]" >&2; exit 1; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
    local ___expect___STDOUT_file="$( mktemp )"
    local ___expect___STDERR_file="$( mktemp )"
    local ___expect___RunInSubshell_
    local ___expect___ExitCode
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
      ___expect___ExitCode=$?
    else
      "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
      ___expect___ExitCode=$?
    fi
    local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
    local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
    local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
    rm -rf "$___expect___STDOUT_file"
    rm -rf "$___expect___STDERR_file"
  fi
  local actualResult
  
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    actualResult="${___expect___OUTPUT/%"\n"}"
  else
    actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$actualResult" | cat -vet )"
  local expected
  for expected in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expected" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$actualResult" != *"$expected"* ]]
      then
        expect.fail "Expected result to contain text\nActual text: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$actualResult" = *"$expected"* ]]
      then
        expect.fail "Expected result not to contain text\nActual text: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done
  return 0
}

expect.matcher.toFail() {
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toFail requires a block" >&2; exit 1; }
  local ___expect___RunInSubshell=""
  [ "$EXPECT_BLOCK_TYPE" = "{{" ] && ___expect___RunInSubshell=true
  local ___expect___STDOUT_file="$( mktemp )"
  local ___expect___STDERR_file="$( mktemp )"
  local ___expect___RunInSubshell_
  local ___expect___ExitCode
  if [ "$___expect___RunInSubshell" = "true" ]
  then
    ___expect___RunInSubshell_="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file" )"
    ___expect___ExitCode=$?
  else
    "${EXPECT_BLOCK[@]}" 1>"$___expect___STDOUT_file" 2>"$___expect___STDERR_file"
    ___expect___ExitCode=$?
  fi
  local ___expect___STDOUT="$( cat "$___expect___STDOUT_file" )"
  local ___expect___STDERR="$( cat "$___expect___STDERR_file" )"
  ___expect___STDOUT="${___expect___STDOUT/%"\n"}"
  ___expect___STDERR="${___expect___STDERR/%"\n"}"
  local ___expect___OUTPUT="${___expect___STDOUT}\n${___expect___STDERR}"
  local ___expect___STDOUT_actual="$( echo -e "$___expect___STDOUT" | cat -vet )"
  local ___expect___STDERR_actual="$( echo -e "$___expect___STDERR" | cat -vet )"
  local ___expect___OUTPUT_actual="$( echo -e "$___expect___OUTPUT" | cat -vet )"
  rm -rf "$___expect___STDOUT_file"
  rm -rf "$___expect___STDERR_file"
  if [ -z "$EXPECT_NOT" ]
  then
    if [ $___expect___ExitCode -eq 0 ]
    then
      expect.fail "Expected to fail, but passed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $___expect___STDOUT\nSTDERR: $___expect___STDERR"
    fi
  else
    if [ $___expect___ExitCode -ne 0 ]
    then
      expect.fail "Expected to pass, but failed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $___expect___STDOUT\nSTDERR: $___expect___STDERR"
    fi
  fi
  local ___expect___expected
  for ___expect___expected in "$@"
  do
    local ___expect___ExpectedResult="$( echo -e "$___expect___expected" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$___expect___STDERR" != *"$___expect___expected"* ]]
      then
        expect.fail "Expected STDERR to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$___expect___STDERR_actual'\nExpected text: '$___expect___ExpectedResult'"
      fi
    else
      if [[ "$___expect___STDERR" = *"$___expect___expected"* ]]
      then
        expect.fail "Expected STDERR not to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$___expect___STDERR_actual'\nUnexpected text: '$___expect___ExpectedResult'"
      fi
    fi
  done
  return 0
}



spec.set.defaultVariables
spec.loadAndSource.configFiles
[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"