#! /usr/bin/env bash

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
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]
  then
    spec.display.cliUsage
    return 0
  fi
  local runningAsFilename="${0/*\/}"
  declare SPEC_PATH_ARGUMENTS=()
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
  declare SPEC_FILE_LIST=()
  
  spec.load.specFiles
  declare SPEC_PASSED_FILES=()
  declare SPEC_FAILED_FILES=()
  spec.run.specFiles
  spec.get.specSuiteStatus
}

spec.set.defaultSpecFunctionPrefixes() { ___spec___.set.defaultSpecFunctionPrefixes "$@"; }
___spec___.set.defaultSpecFunctionPrefixes() {
  local functionName="spec.styles.$SPEC_STYLE.set.defaultSpecFunctionPrefixes"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.set.defaultFormatter() { ___spec___.set.defaultFormatter "$@"; }
___spec___.set.defaultFormatter() {
  [ -z "$SPEC_FORMATTER" ] && SPEC_FORMATTER="documentation"
}

spec.set.defaultVariables() { ___spec___.set.defaultVariables "$@"; }
___spec___.set.defaultVariables() {
  spec.set.defaultStyle
  spec.set.defaultFormatter
  spec.set.defaultTheme
  spec.set.defaultSpecFileSuffixes
  spec.set.defaultSpecFunctionPrefixes
  spec.set.defaultPendingFunctionPrefixes
  spec.set.defaultConfigFilenames
}

spec.set.defaultStyle() { ___spec___.set.defaultStyle "$@"; }
___spec___.set.defaultStyle() {
  [ -z "$SPEC_STYLE" ] && SPEC_STYLE="xunit_and_spec"
}

spec.set.defaultConfigFilenames() { ___spec___.set.defaultConfigFilenames "$@"; }
___spec___.set.defaultConfigFilenames() {
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
}

spec.set.defaultPendingFunctionPrefixes() { ___spec___.set.defaultPendingFunctionPrefixes "$@"; }
___spec___.set.defaultPendingFunctionPrefixes() {
  local functionName="spec.styles.$SPEC_STYLE.set.defaultPendingFunctionPrefixes"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.set.defaultSpecFileSuffixes() { ___spec___.set.defaultSpecFileSuffixes "$@"; }
___spec___.set.defaultSpecFileSuffixes() {
  [ -z "$SPEC_FILE_SUFFIXES" ] && SPEC_FILE_SUFFIXES=".spec.sh:.test.sh"
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

spec.display.cliUsage.header() { ___spec___.display.cliUsage.header "$@"; }
___spec___.display.cliUsage.header() {
  echo "${0/*\/} [file.spec.sh] [directory/] [-f/--flags]"
}

spec.display.cliUsage() { ___spec___.display.cliUsage "$@"; }
___spec___.display.cliUsage() {
  spec.display.cliUsage.header
  spec.display.cliUsage.footer
}

spec.display.after:run.specFunction() { ___spec___.display.after:run.specFunction "$@"; }
___spec___.display.after:run.specFunction() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.after:run.specFunction"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.display.cliUsage.footer() { ___spec___.display.cliUsage.footer "$@"; }
___spec___.display.cliUsage.footer() {
  :
}

spec.display.before:run.specFile() { ___spec___.display.before:run.specFile "$@"; }
___spec___.display.before:run.specFile() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.before:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.load.specFunctions() { ___spec___.load.specFunctions "$@"; }
___spec___.load.specFunctions() {
  local functionName="spec.styles.$SPEC_STYLE.load.specFunctions"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
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

spec.load.pendingFunctions() { ___spec___.load.pendingFunctions "$@"; }
___spec___.load.pendingFunctions() {
  local functionName="spec.styles.$SPEC_STYLE.load.pendingFunctions"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}

spec.get.functionDisplayName() { ___spec___.get.functionDisplayName "$@"; }
___spec___.get.functionDisplayName() {
  local functionName="spec.styles.$SPEC_STYLE.get.functionDisplayName"
  if [ "$( type -t "$functionName" )" = "function" ]
  then
    "$functionName" "$@"
  else
    printf "$*"
  fi
}

spec.get.specSuiteStatus() { ___spec___.get.specSuiteStatus "$@"; }
___spec___.get.specSuiteStatus() {
  [ "${#SPEC_FAILED_FILES[@]}" -eq 0 ]
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

spec.run.function() { ___spec___.run.function "$@"; }
___spec___.run.function() {
  local functionName="$1"
  shift
  "$functionName" "$@"
}

spec.run.specFile() { ___spec___.run.specFile "$@"; }
___spec___.run.specFile() {
  spec.source.specFile "$1"
  declare -a SPEC_FUNCTIONS=()
  declare -a SPEC_DISPLAY_NAMES=()
  
  spec.load.specFunctions
  declare -a SPEC_PENDING_FUNCTIONS=()
  declare -a SPEC_PENDING_DISPLAY_NAMES=()
  spec.load.pendingFunctions
  declare -a SPEC_PASSED_FUNCTIONS=()
  declare -a SPEC_PASSED_DISPLAY_NAMES=()
  declare -a SPEC_FAILED_FUNCTIONS=()
  declare -a SPEC_FAILED_DISPLAY_NAMES=()
  local SPEC_CURRENT_INDEX=0
  local SPEC_CURRENT_FUNCTION
  for SPEC_CURRENT_FUNCTION in "${SPEC_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    local SPEC_TEMP_STDOUT_FILE="$( mktemp )"
    local SPEC_TEMP_STDERR_FILE="$( mktemp )"
    local ___spec___unusedOutput
    ___spec___unusedOutput="$( spec.run.specFunction "$SPEC_CURRENT_FUNCTION" 1>>"$SPEC_TEMP_STDOUT_FILE" 2>>"$SPEC_TEMP_STDERR_FILE" )"
    SPEC_CURRENT_EXITCODE=$?
    local SPEC_CURRENT_STDOUT="$( < "$SPEC_TEMP_STDOUT_FILE" )"
    local SPEC_CURRENT_STDERR="$( < "$SPEC_TEMP_STDERR_FILE" )"
    rm "$SPEC_TEMP_STDOUT_FILE"
    rm "$SPEC_TEMP_STDERR_FILE"
    if [ $SPEC_CURRENT_EXITCODE -eq 0 ]
    then
      local SPEC_CURRENT_STATUS=PASS
      SPEC_PASSED_FUNCTIONS+="$SPEC_CURRENT_FUNCTION"
      SPEC_PASSED_DISPLAY_NAMES+="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    else
      local SPEC_CURRENT_STATUS=FAIL
      SPEC_FAILED_FUNCTIONS+="$SPEC_CURRENT_FUNCTION"
      SPEC_FAILED_DISPLAY_NAMES+="${SPEC_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    fi
    spec.display.after:run.specFunction
    (( SPEC_CURRENT_INDEX += 1 ))
  done
  local SPEC_CURRENT_INDEX=0
  local SPEC_CURRENT_FUNCTION
  for SPEC_CURRENT_FUNCTION in "${SPEC_PENDING_FUNCTIONS[@]}"
  do
    SPEC_CURRENT_DISPLAY_NAME="${SPEC_PENDING_DISPLAY_NAMES[$SPEC_CURRENT_INDEX]}"
    SPEC_CURRENT_STATUS=PENDING
    spec.display.after:run.specFunction
    (( SPEC_CURRENT_INDEX += 1 ))
  done
  [ "${#SPEC_FAILED_FUNCTIONS[@]}" -eq 0 ]
}

spec.run.specFunction() { ___spec___.run.specFunction "$@"; }
___spec___.run.specFunction() {
  spec.run.function "$@"
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

spec.loadAndSource.configFiles() { ___spec___.loadAndSource.configFiles "$@"; }
___spec___.loadAndSource.configFiles() {
  declare -a SPEC_CONFIG_FILES=()
  spec.load.configFiles && spec.source.configFiles
}

spec.formatters.documentation.display.after:run.specFunction() {
  ___spec___.formatters.documentation.display.after:run.specFunction "$@"
}
___spec___.formatters.documentation.display.after:run.specFunction() {
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "["
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  case "$SPEC_CURRENT_STATUS" in
    PASS)
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_PASS_COLOR}m" >&2
      printf "OK"
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
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
  printf "] "
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SPEC_COLOR}m" >&2
  printf "$SPEC_CURRENT_DISPLAY_NAME\n"
  [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
  if [ "$SPEC_DISPLAY_OUTPUT" = "true" ] || [ "$SPEC_CURRENT_STATUS" = "FAIL" ]
  then
    if [ -n "$SPEC_CURRENT_STDOUT" ]
    then
      echo
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_HEADER_COLOR}m" >&2
      printf "Standard Output"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDOUT\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
    fi
    if [ -n "$SPEC_CURRENT_STDERR" ]
    then
      echo
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_HEADER_COLOR}m" >&2
      printf "Standard Error"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDERR\n"
    fi
  fi
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

spec.styles.spec.set.defaultSpecFunctionPrefixes() { ___spec___.styles.spec.set.defaultSpecFunctionPrefixes "$@"; }
___spec___.styles.spec.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="@spec.\n@example.\n@it."
}

spec.styles.spec.set.defaultPendingFunctionPrefixes() { ___spec___.styles.spec.set.defaultPendingFunctionPrefixes "$@"; }
___spec___.styles.spec.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="@pending.\n@xspec.\n@xexample.\n@xit."
}

spec.styles.spec.load.specFunctions() { ___spec___.styles.spec.load.specFunctions "$@"; }
___spec___.styles.spec.load.specFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_DISPLAY_NAMES+=("$displayName")
    done
  done
}

spec.styles.spec.load.pendingFunctions() { _.spec___.styles.spec.load.pendingFunctions "$@"; }
_.spec___.styles.spec.load.pendingFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_PENDING_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_PENDING_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_PENDING_DISPLAY_NAMES+=("$displayName")
    done
  done
}

spec.styles.spec.get.functionDisplayName() { ___spec___.styles.spec.get.functionDisplayName "$@"; }
___spec___.styles.spec.get.functionDisplayName() {
  local functionName="$1"
  displayName="${functionName//_/ }" # convert _ into space
  displayName="${displayName//\./ }" # convert . into space
  displayName="$( echo "$displayName" | sed 's/ \+/ /g' )" # compact spaces
  printf "$displayName"
}

spec.styles.xunit.set.defaultSpecFunctionPrefixes() { ___spec___.styles.xunit.set.defaultSpecFunctionPrefixes "$@"; }
___spec___.styles.xunit.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="test"
}

spec.styles.xunit.set.defaultPendingFunctionPrefixes() { ___spec___.styles.xunit.set.defaultPendingFunctionPrefixes "$@"; }
___spec___.styles.xunit.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="xtest"
}

spec.styles.xunit.load.specFunctions() { ___spec___.styles.xunit.load.specFunctions "$@"; }
___spec___.styles.xunit.load.specFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_DISPLAY_NAMES+=("$displayName")
    done
  done
}

spec.styles.xunit.load.pendingFunctions() { ___spec___.styles.xunit.load.pendingFunctions "$@"; }
___spec___.styles.xunit.load.pendingFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_PENDING_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_PENDING_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_PENDING_DISPLAY_NAMES+=("$displayName")
    done
  done
}

spec.styles.xunit.get.functionDisplayName() { ___spec___.styles.xunit.get.functionDisplayName "$@"; }
___spec___.styles.xunit.get.functionDisplayName() {
  local functionName="$1"
  displayName="${functionName//_/ }" # convert _ into space
  displayName="${displayName//\./ }" # convert . into space
  displayName="$( printf "$displayName" | sed 's/\([A-Z]\)/ \1/g' )" # convert 'camelCase' to ' Camel Case'
  displayName="${displayName##[[:space:]]}" # strip extraneous leading space
  displayName="$( echo "$displayName" | sed 's/ \+/ /g' )" # compact spaces
  printf "$displayName"
}

spec.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes() { ___spec___.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes "$@"; }
___spec___.styles.xunit_and_spec.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="test\n@spec.\n@example.\n@it."
}

spec.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes() { ___spec___.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes "$@"; }
___spec___.styles.xunit_and_spec.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="xtest\n@pending.\n@xspec.\n@xexample.\n@xit."
}

spec.styles.xunit_and_spec.load.specFunctions() { ___spec___.styles.xunit_and_spec.load.specFunctions "$@"; }
___spec___.styles.xunit_and_spec.load.specFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_DISPLAY_NAMES+=("$displayName")
    done
  done
}

spec.styles.xunit_and_spec.load.pendingFunctions() { ___spec___.styles.xunit_and_spec.load.pendingFunctions "$@"; }
___spec___.styles.xunit_and_spec.load.pendingFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_PENDING_FUNCTION_PREFIXES")
  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_PENDING_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_PENDING_DISPLAY_NAMES+=("$displayName")
    done
  done
}

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
  local RUN_VERSION="0.4.0"
  [[ "$1" = "--version" ]] && { echo "run version $RUN_VERSION"; return 0; }
  local ___run___RunInSubshell=false
  declare -a ___run___CommandToRun=()
  if [ "$1" = "{" ]; then
    shift
    while [ "$1" != "}" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "}" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '{ ... }' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '{' block but no closing '}' found" >&2
      return 1
    fi
  elif [ "$1" = "{{" ]; then
    ___run___RunInSubshell=true
    shift
    while [ "$1" != "}}" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "}}" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '{{ ... }}' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '{{' block but no closing '}}' found" >&2
      return 1
    fi
  elif [ "$1" = "[" ]; then
    shift
    while [ "$1" != "]" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "]" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '[ ... ]' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '[' block but no closing ']' found" >&2
      return 1
    fi
  elif [ "$1" = "[[" ]
  then
    ___run___RunInSubshell=true
    shift
    while [ "$1" != "]]" ] && [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
    if [ "$1" = "]]" ]; then
      shift
      if [ $# -ne 0 ]; then
        echo "'run' called with '[[ ... ]]' block but unexpected argument found after block: '$1'" >&2
        return 1
      fi
    else
      echo "'run' called with '[[' block but no closing ']]' found" >&2
      return 1
    fi
  else
    while [ $# -gt 0 ]; do
      ___run___CommandToRun+=("$1")
      shift
    done
  fi
  local ___run___STDOUT_TempFile="$( mktemp )"
  local ___run___STDERR_TempFile="$( mktemp )"
  local ___run___UnusedOutput
  if [ "$___run___RunInSubshell" = "true" ]; then
    ___run___UnusedOutput="$( "${___run___CommandToRun[@]}" 1>"$___run___STDOUT_TempFile" 2>"$___run___STDERR_TempFile" )"
    EXITCODE=$?
  else
    "${___run___CommandToRun[@]}" 1>"$___run___STDOUT_TempFile" 2>"$___run___STDERR_TempFile"
    EXITCODE=$?
  fi
  STDOUT="$( < "$___run___STDOUT_TempFile" )"
  STDERR="$( < "$___run___STDERR_TempFile" )"
  rm -f "$___run___STDOUT_TempFile"
  rm -f "$___run___STDERR_TempFile"
  return $EXITCODE
}

[ -z "$EXPECT_BLOCK_PAIRS" ] && EXPECT_BLOCK_PAIRS="{\n}\n{{\n}}\n{{{\n}}}\n[\n]\n[[\n]]\n[[[\n]]]\n"
expect() {
  [ $# -eq 0 ] && { echo "Missing required argument for 'expect': actual value or { code block } or {{ subshell code block }}" >&2; return 1; }
  EXPECT_VERSION=0.5.0
  [ $# -eq 1 ] && [ "$1" = "--version" ] && { echo "expect version $EXPECT_VERSION"; return 0; }
  local ___expect___BlockPairsArray
  IFS=$'\n' read -d '' -ra ___expect___BlockPairsArray < <(printf "$EXPECT_BLOCK_PAIRS")
  local ___expect___BlockSymbolIndex=0
  while [ $___expect___BlockSymbolIndex -lt "${#___expect___BlockPairsArray[@]}" ]
  do
    local ___expect___StartSymbol="${___expect___BlockPairsArray[$___expect___BlockSymbolIndex]}"
    (( ___expect___BlockSymbolIndex += 1 ))
    local ___expect___EndSymbol="${___expect___BlockPairsArray[$___expect___BlockSymbolIndex]}"
    (( ___expect___BlockSymbolIndex += 1 ))
    if [ -n "$___expect___StartSymbol" ] && [ -n "$___expect___EndSymbol" ]
    then
      if [ "$1" = "$___expect___StartSymbol" ]
      then
        local EXPECT_BLOCK_OPEN="$___expect___StartSymbol"
        local EXPECT_BLOCK_CLOSE="$___expect___EndSymbol"
        break
      fi
    fi
  done
  local EXPECT_BLOCK_TYPE="$EXPECT_BLOCK_OPEN"
  local EXPECT_ACTUAL_RESULT=""
  declare -a EXPECT_BLOCK=()
  if [ -n "$EXPECT_BLOCK_TYPE" ]
  then
    shift    
    while [ "$1" != "$EXPECT_BLOCK_CLOSE" ] && [ $# -gt 0 ]
    do
      EXPECT_BLOCK+=("$1")
      shift
    done
    [ "$1" != "$EXPECT_BLOCK_CLOSE" ] && { echo "Expected '$EXPECT_BLOCK_OPEN' block to be closed with '$EXPECT_BLOCK_CLOSE' but no '$EXPECT_BLOCK_CLOSE' provided" >&2; return 1; }
    shift
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
EXPECT_FAIL="exit 1"
expect.fail() { echo -e "$*" >&2; $EXPECT_FAIL; }
expect.execute_block() {
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    local ___expect___RunInSubshell=""
    [ "$EXPECT_BLOCK_TYPE" = "{{" ] || [ "$EXPECT_BLOCK_TYPE" = "[[" ] && ___expect___RunInSubshell=true
    local ___expect___stdout_file="$( mktemp )"
    local ___expect___stderr_file="$( mktemp )"
    if [ "$___expect___RunInSubshell" = "true" ]
    then
      local ___expect___UnusedVariable
      ___expect___UnusedVariable="$( "${EXPECT_BLOCK[@]}" 1>"$___expect___stdout_file" 2>"$___expect___stderr_file" )"
      EXPECT_EXITCODE=$?
    else
      "${EXPECT_BLOCK[@]}" 1>"$___expect___stdout_file" 2>"$___expect___stderr_file"
      EXPECT_EXITCODE=$?
    fi
    EXPECT_STDOUT="$( < "$___expect___stdout_file" )"
    EXPECT_STDERR="$( < "$___expect___stderr_file" )"
    rm -rf "$___expect___stdout_file"
    rm -rf "$___expect___stderr_file"
  fi
}
expect.matcher.toBeEmpty() {
  [ $# -gt 0 ] && { echo "toBeEmpty expects 0 arguments, received $# [$*]" >&2; exit 1; }
  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"
  if [ -z "$EXPECT_NOT" ]
  then
    if [ -n "$___expect___actualResult" ]
    then
      expect.fail "Expected result to be empty\nActual: '$actualResultOutput'"
    fi
  else
    if [ -z "$___expect___actualResult" ]
    then
      expect.fail "Expected result not to be empty\nActual: '$actualResultOutput'"
    fi
  fi
  return 0
}
expect.matcher.toContain() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toContain expects 1 or more arguments, received $# [$*]" >&2; exit 1; }
  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"
  local expected
  for expected in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expected" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$___expect___actualResult" != *"$expected"* ]]
      then
        expect.fail "Expected result to contain text\nActual text: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$___expect___actualResult" = *"$expected"* ]]
      then
        expect.fail "Expected result not to contain text\nActual text: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done
  return 0
}
expect.matcher.toEqual() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -ne 1 ] && { echo "toEqual expects 1 argument (expected result), received $# [$*]" >&2; exit 1; }
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    local actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    local actualResult="$EXPECT_ACTUAL_RESULT"
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
expect.matcher.toFail() {
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toFail requires a block" >&2; exit 1; }
  expect.execute_block
  if [ -z "$EXPECT_NOT" ]
  then
    if [ $EXPECT_EXITCODE -eq 0 ]
    then
      expect.fail "Expected to fail, but passed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  else
    if [ $EXPECT_EXITCODE -ne 0 ]
    then
      expect.fail "Expected to pass, but failed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  fi
  local actualResultOutput="$( echo -ne "$EXPECT_STDERR" | cat -vet )"
  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expectedOutputItem" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR not to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done
  return 0
}
expect.matcher.toMatch() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toMatch expects at least 1 argument (BASH regex patterns), received $# [$*]" >&2; exit 1; }
  local actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
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
expect.matcher.toOutput() {
  local ___expect___ShouldCheckSTDOUT=""
  local ___expect___ShouldCheckSTDERR=""
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toOutput requires a block" >&2; exit 1; }
  [ "$1" = "toStdout" ] || [ "$1" = "toSTDOUT" ] && { ___expect___ShouldCheckSTDOUT=true; shift; }
  [ "$1" = "toStderr" ] || [ "$1" = "toSTDERR" ] && { ___expect___ShouldCheckSTDERR=true; shift; }
  [ $# -lt 1 ] && { echo "toOutput expects 1 or more arguments, received $#" >&2; exit 1; }
  expect.execute_block
  local EXPECT_STDOUT_actual="$( echo -e "$EXPECT_STDOUT" | cat -vet )"
  local EXPECT_STDERR_actual="$( echo -e "$EXPECT_STDERR" | cat -vet )"
  local OUTPUT_actual="$( echo -e "${EXPECT_STDOUT}${EXPECT_STDERR}" | cat -vet )"
  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local ___expect___ExpectedResult="$( echo -e "$expectedOutputItem" | cat -vet )"
    if [ -n "$___expect___ShouldCheckSTDOUT" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDOUT" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDOUT" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT not to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    elif [ -n "$___expect___ShouldCheckSTDERR" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR not to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    else
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output to contain text\nOutput: '$OUTPUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output not to contain text\nOutput: '$OUTPUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    fi
  done
  return 0
}

expect.matcher.toFail() {
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toFail requires a block" >&2; exit 1; }
  expect.execute_block
  if [ -z "$EXPECT_NOT" ]
  then
    if [ $EXPECT_EXITCODE -eq 0 ]
    then
      expect.fail "Expected to fail, but passed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  else
    if [ $EXPECT_EXITCODE -ne 0 ]
    then
      expect.fail "Expected to pass, but failed\nCommand: ${EXPECT_BLOCK[@]}\nSTDOUT: $EXPECT_STDOUT\nSTDERR: $EXPECT_STDERR"
    fi
  fi
  local actualResultOutput="$( echo -ne "$EXPECT_STDERR" | cat -vet )"
  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expectedOutputItem" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
      then
        expect.fail "Expected STDERR not to contain text\nCommand: ${EXPECT_BLOCK[@]}\nSTDERR: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done
  return 0
}

expect.matcher.toMatch() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toMatch expects at least 1 argument (BASH regex patterns), received $# [$*]" >&2; exit 1; }
  local actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
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
    expect.execute_block
    local actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    local actualResult="$EXPECT_ACTUAL_RESULT"
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

expect.matcher.toOutput() {
  local ___expect___ShouldCheckSTDOUT=""
  local ___expect___ShouldCheckSTDERR=""
  [ "${#EXPECT_BLOCK[@]}" -lt 1 ] && { echo "toOutput requires a block" >&2; exit 1; }
  [ "$1" = "toStdout" ] || [ "$1" = "toSTDOUT" ] && { ___expect___ShouldCheckSTDOUT=true; shift; }
  [ "$1" = "toStderr" ] || [ "$1" = "toSTDERR" ] && { ___expect___ShouldCheckSTDERR=true; shift; }
  [ $# -lt 1 ] && { echo "toOutput expects 1 or more arguments, received $#" >&2; exit 1; }
  expect.execute_block
  local EXPECT_STDOUT_actual="$( echo -e "$EXPECT_STDOUT" | cat -vet )"
  local EXPECT_STDERR_actual="$( echo -e "$EXPECT_STDERR" | cat -vet )"
  local OUTPUT_actual="$( echo -e "${EXPECT_STDOUT}${EXPECT_STDERR}" | cat -vet )"
  local expectedOutputItem
  for expectedOutputItem in "$@"
  do
    local ___expect___ExpectedResult="$( echo -e "$expectedOutputItem" | cat -vet )"
    if [ -n "$___expect___ShouldCheckSTDOUT" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDOUT" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDOUT" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDOUT not to contain text\nSTDOUT: '$EXPECT_STDOUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    elif [ -n "$___expect___ShouldCheckSTDERR" ]
    then
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "$EXPECT_STDERR" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "$EXPECT_STDERR" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected STDERR not to contain text\nSTDERR: '$EXPECT_STDERR_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    else
      if [ -z "$EXPECT_NOT" ]
      then
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" != *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output to contain text\nOutput: '$OUTPUT_actual'\nExpected text: '$___expect___ExpectedResult'"
        fi
      else
        if [[ "${EXPECT_STDOUT}${EXPECT_STDERR}" = *"$expectedOutputItem"* ]]
        then
          expect.fail "Expected output not to contain text\nOutput: '$OUTPUT_actual'\nUnexpected text: '$___expect___ExpectedResult'"
        fi
      fi
    fi
  done
  return 0
}

expect.matcher.toBeEmpty() {
  [ $# -gt 0 ] && { echo "toBeEmpty expects 0 arguments, received $# [$*]" >&2; exit 1; }
  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"
  if [ -z "$EXPECT_NOT" ]
  then
    if [ -n "$___expect___actualResult" ]
    then
      expect.fail "Expected result to be empty\nActual: '$actualResultOutput'"
    fi
  else
    if [ -z "$___expect___actualResult" ]
    then
      expect.fail "Expected result not to be empty\nActual: '$actualResultOutput'"
    fi
  fi
  return 0
}

expect.matcher.toContain() {
  [ "${#EXPECT_BLOCK[@]}" -eq 0 ] && [ $# -eq 0 ] && { echo "toContain expects 1 or more arguments, received $# [$*]" >&2; exit 1; }
  local ___expect___actualResult
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    ___expect___actualResult="${EXPECT_STDOUT}${EXPECT_STDERR/%"\n"}"
  else
    ___expect___actualResult="$EXPECT_ACTUAL_RESULT"
  fi
  local actualResultOutput="$( echo -ne "$___expect___actualResult" | cat -vet )"
  local expected
  for expected in "$@"
  do
    local expectedResultOutput="$( echo -ne "$expected" | cat -vet )"
    if [ -z "$EXPECT_NOT" ]
    then
      if [[ "$___expect___actualResult" != *"$expected"* ]]
      then
        expect.fail "Expected result to contain text\nActual text: '$actualResultOutput'\nExpected text: '$expectedResultOutput'"
      fi
    else
      if [[ "$___expect___actualResult" = *"$expected"* ]]
      then
        expect.fail "Expected result not to contain text\nActual text: '$actualResultOutput'\nUnexpected text: '$expectedResultOutput'"
      fi
    fi
  done
  return 0
}



spec.set.defaultVariables
spec.loadAndSource.configFiles
[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"
