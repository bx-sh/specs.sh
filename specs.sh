#! /usr/bin/env bash

SPEC_VERSION=0.5.0

spec.main() {
  ___spec___.main "$@"
}
___spec___.main() {
  if [ $# -eq 1 ] && [ "$1" = "--version" ]
  then
    printf "specs.sh version " >&2
    printf "$SPEC_VERSION"
    return 0
  fi
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]
  then
    spec.display.cliUsage
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
  declare -a SPEC_PASSED_FILES=()
  declare -a SPEC_FAILED_FILES=()
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
  spec.set.defaultHelperFilenames
}

spec.set.defaultStyle() { ___spec___.set.defaultStyle "$@"; }
___spec___.set.defaultStyle() {
  [ -z "$SPEC_STYLE" ] && SPEC_STYLE="xunit_and_spec"
}

spec.set.defaultConfigFilenames() { ___spec___.set.defaultConfigFilenames "$@"; }
___spec___.set.defaultConfigFilenames() {
  [ -z "$SPEC_CONFIG_FILENAMES"  ] && SPEC_CONFIG_FILENAMES="spec.config.sh"
}

spec.set.defaultHelperFilenames() { ___spec___.set.defaultHelperFilenames "$@"; }
___spec___.set.defaultHelperFilenames() {
  [ -z "$SPEC_HELPER_FILENAMES"  ] && SPEC_HELPER_FILENAMES="specHelper.sh:testHelper.sh"
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

spec.display.after:run.specFile() { ___spec___.display.after:run.specFile "$@"; }
___spec___.display.after:run.specFile() {
  local functionName="spec.formatters.$SPEC_FORMATTER.display.after:run.specFile"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
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
  declare -a SPEC_CONFIG_FILES=()
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
    while [ "$directory" != "/" ] && [ "$directory" != "." ]
    do
      local configFilename
      for configFilename in "${configFilenames[@]}"
      do
        [ -f "$directory/$configFilename" ] && SPEC_CONFIG_FILES+=("$directory/$configFilename")
      done
      directory="$( dirname "$directory" )"
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

spec.source.helperFiles() { ___spec___.source.helperFiles "$@"; }
___spec___.source.helperFiles() {
  [ "${#SPEC_HELPER_FILES[@]}" -eq 0 ] && return
  local ___spec___localHelperFile_index="$((${#SPEC_HELPER_FILES[@]}-1))"
  local ___spec___localHelperFile="${SPEC_HELPER_FILES[$___spec___localHelperFile_index]}"
  while [ ! $___spec___localHelperFile_index -lt 0 ]
  do
    spec.source.file "$___spec___localHelperFile"
    : $((___spec___localHelperFile_index--))
    [ $___spec___localHelperFile_index -lt 0 ] && break
    ___spec___localHelperFile="${SPEC_HELPER_FILES[$___spec___localHelperFile_index]}"
  done
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
  declare -a SPEC_HELPER_FILES=()
  spec.load.helperFiles "$1"
  spec.source.helperFiles
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
    exec 4>&1
    local ___spec___unusedOutput
      ___spec___unusedOutput="$( spec.run.specFile "$specFile" >&4 )"
    SPEC_FILE_CURRENT_EXITCODE=$?
    exec 4>&-
    if [ $SPEC_FILE_CURRENT_EXITCODE -eq 0 ]
    then
      SPEC_PASSED_FILES+=("$specFile")
    else
      SPEC_FAILED_FILES+=("$specFile")
    fi
    spec.display.after:run.specFile
  done
}

spec.loadAndSource.configFiles() { ___spec___.loadAndSource.configFiles "$@"; }
___spec___.loadAndSource.configFiles() {
  spec.load.configFiles && spec.source.configFiles
}

spec.formatters.documentation.display.after:run.specFile() {
  ___spec___.formatters.documentation.display.after:run.specFile "$@"
}
___spec___.formatters.documentation.display.after:run.specFile() {
  echo
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
      printf "\t["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_HEADER_COLOR}m" >&2
      printf "Standard Output"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDOUT_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDOUT\n\n" | sed 's/^/\t/'
      [ "$SPEC_COLOR" = "true" ] && printf "\033[0m" >&2
    fi
    if [ -n "$SPEC_CURRENT_STDERR" ]
    then
      echo
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "\t["
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_HEADER_COLOR}m" >&2
      printf "Standard Error"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_SEPARATOR_COLOR}m" >&2
      printf "]\n"
      [ "$SPEC_COLOR" = "true" ] && printf "\033[${SPEC_THEME_STDERR_COLOR}m" >&2
      printf "$SPEC_CURRENT_STDERR\n\n" | sed 's/^/\t/'
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
  printf "$SPEC_CURRENT_FILEPATH"
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

spec.set.defaultVariables
spec.loadAndSource.configFiles
[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"
