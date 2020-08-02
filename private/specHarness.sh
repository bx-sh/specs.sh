##
# Placeholders for user customization / point to default implementations
##

spec.getTestDisplayName() {
  ___spec___.getTestDisplayName "$@"
}

spec.specFunctionPrefixes() {
  ___spec___.specFunctionPrefixes "$@"
}

spec.pendingFunctionPrefixes() {
  ___spec___.pendingFunctionPrefixes "$@"
}

spec.setupFunctionNames() {
  ___spec___.setupFunctionNames "$@"
}

spec.teardownFunctionNames() {
  ___spec___.teardownFunctionNames "$@"
}

spec.setupFixtureFunctionNames() {
  ___spec___.setupFixtureFunctionNames "$@"
}

spec.teardownFixtureFunctionNames() {
  ___spec___.teardownFixtureFunctionNames "$@"
}

spec.beforeFile() {
  ___spec___.beforeFile "$@"
}

spec.afterFile() {
  ___spec___.afterFile "$@"
}

spec.loadHelpers() {
  ___spec___.loadHelpers "$@"
}

spec.helperFilenames() {
  ___spec___.helperFilenames "$@"
}

spec.displayTestsBanner() {
  ___spec___.displayTestsBanner "$@"
}

spec.displayRunningTest() {
  ___spec___.displayRunningTest "$@"
}

spec.runTests() {
  ___spec___.runTests "$@"
}

spec.runTest() {
  ___spec___.runTest "$@"
}

spec.displayTestResult() {
  ___spec___.displayTestResult "$@"
}

spec.displayPendingTestResult() {
  ___spec___.displayPendingTestResult "$@"
}

spec.displayTestsSummary() {
  ___spec___.displayTestsSummary "$@"
}

##
# Private API
##

___spec___.getTestDisplayName() {
  printf "${1//_/ }"
}

___spec___.specFunctionPrefixes() {
  echo @spec. @test. @it. @example.
}

___spec___.pendingFunctionPrefixes() {
  echo @pending. @xtest. @xit. @xexample.
}

___spec___.setupFunctionNames() {
  echo @setup @before
}

___spec___.teardownFunctionNames() {
  echo @teardown @after
}

___spec___.setupFixtureFunctionNames() {
  echo @beforeAll @setupFixture
}

___spec___.teardownFixtureFunctionNames() {
  echo @afterAll @teardownFixture
}

___spec___.helperFilenames() {
  echo specHelper.sh testHelper.sh helper.spec.sh helper.test.sh
}

___spec___.loadHelpers() {
  local dirpath="$1"
  declare -a specHelperPathsToSource=()

  local helperFilename
  for helperFilename in $( spec.helperFilenames )
  do
    specHelperPathsToSource+=("$dirpath/$helperFilename")
  done
  while [ "$dirpath" != "/" ] && [ "$dirpath" != "." ]
  do
    dirpath="$( dirname "$dirpath" )"
    for helperFilename in $( spec.helperFilenames )
    do
      specHelperPathsToSource+=("$dirpath/$helperFilename")
    done
  done
  
  local i="${#specHelperPathsToSource[@]}"
  (( i -= 1 ))
  while [ $i -gt -1 ]
  do
    [ -f "${specHelperPathsToSource[$i]}" ] && source "${specHelperPathsToSource[$i]}"
    (( i -= 1 ))
  done
}

___spec___.beforeFile() {
  echo
  echo -e "[\e[34m$1\e[0m]"
}

___spec___.afterFile() {
  :
}

___spec___.displayTestsBanner() {
  :
}

___spec___.displayRunningTest() {
  :
}

___spec___.displayTestResult() {
  local functionName="$3"
  local name="$2"
  local status="$3"
  local stdout="$4"
  local stderr="$5"

  if [ "$status" = "PASS" ]
  then
    echo -e "[\e[32mOK\e[0m] $name"
  else
    echo -e "[\e[31mFAIL\e[0m] $name"
  fi

  if [ "$status" = "FAIL" ] || [ -n "$VERBOSE" ]
  then
    if [ -n "$stderr" ]
    then
      echo
      echo -e "\t[\e[31;1mStandard Error\e[0m]"
      echo -e "$stderr" | sed 's/\(.*\)/\t\1/'
      echo
    fi
    if [ -n "$stdout" ]
    then
      echo
      echo -e "\t[\e[34;1mOutput\e[0m]"
      echo -e "$stdout" | sed 's/\(.*\)/\t\1/'
      echo
    fi
  fi
}

___spec___.displayPendingTestResult() {
  local functionName="$3"
  local name="$2"

  echo -e "[\e[33mPENDING\e[0m] $name"
}

___spec___.displayTestsSummary() {
  local status="$1"
  local total="$2"
  local passed="$3"
  local failed="$4"
  local pending="$5"

  if [ $total -eq 0 ]
  then
    echo "No tests to run."
  elif [ "$status" = "PASS" ]
  then
    printf "Tests passed."
  else
    printf "Tests failed."
  fi
  [ $passed  -gt 0 ] && printf " $passed passed."
  [ $failed  -gt 0 ] && printf " $failed failed."
  [ $pending -gt 0 ] && printf " $pending pending."
  printf "\n"
}

___spec___.runTests() {
  local specNamePattern="$1"

  ##
  # Collect defined functions
  ##
  declare -a ___spec___AllSpecFunctionNames=()
  declare -a ___spec___AllSpecDisplayNames=()
  declare -a ___spec___AllPendingFunctionNames=()
  declare -a ___spec___AllPendingDisplayNames=()
  declare -a ___spec___AllSetupFunctionNames=()
  declare -a ___spec___AllTeardownFunctionNames=()
  declare -a ___spec___AllSetupFixtureFunctionNames=()
  declare -a ___spec___AllTeardownFixtureFunctionNames=()

  local specPrefix
  for specPrefix in $( spec.specFunctionPrefixes )
  do
    [ -z "$specPrefix" ] && continue
    local specFunctionNames
    read -rd '' -a specFunctionNames <<<"$( declare -F | grep "declare -f $specPrefix" | sed 's/declare -f //' | sort -R )"
    local specFunctionName
    for specFunctionName in "${specFunctionNames[@]}"
    do
      local withoutPrefix="${specFunctionName#"$specPrefix"}"
      [ -n "$specNamePattern" ] && [[ ! "$withoutPrefix" =~ $specNamePattern ]] && continue
      local specDisplayName="$( spec.getTestDisplayName "$withoutPrefix" )"
      local alreadyAdded=""
      local existingFunctionName
      for existingFunctionName in "${___spec___AllSpecFunctionNames[@]}"
      do
        if [ "$existingFunctionName" = "$specFunctionName" ]
        then
          alreadyAdded=true
          break
        fi
      done
      if [ -z "$alreadyAdded" ]
      then
        ___spec___AllSpecFunctionNames+=("$specFunctionName")
        ___spec___AllSpecDisplayNames+=("$specDisplayName")
      fi
    done
  done
  unset specPrefix
  unset specFunctionName
  unset specFunctionNames
  unset specDisplayName
  unset withoutPrefix
  unset alreadyAdded
  unset existingFunctionName

  local pendingPrefix
  for pendingPrefix in $( spec.pendingFunctionPrefixes )
  do
    [ -z "$pendingPrefix" ] && continue
    local pendingFunctionNames
    read -rd '' -a pendingFunctionNames <<<"$( declare -F | grep "declare -f $pendingPrefix" | sed 's/declare -f //' | sort -R )"
    local pendingFunctionName
    for pendingFunctionName in "${pendingFunctionNames[@]}"
    do
      local withoutPrefix="${pendingFunctionName#"$pendingPrefix"}"
      [ -n "$specNamePattern" ] && [[ ! "$withoutPrefix" =~ $specNamePattern ]] && continue
      local pendingDisplayName="$( spec.getTestDisplayName "$withoutPrefix" )"
      local alreadyAdded=""
      local existingFunctionName
      for existingFunctionName in "${___spec___AllPendingFunctionNames[@]}"
      do
        if [ "$existingFunctionName" = "$pendingFunctionName" ]
        then
          alreadyAdded=true
          break
        fi
      done
      if [ -z "$alreadyAdded" ]
      then
        ___spec___AllPendingFunctionNames+=("$pendingFunctionName")
        ___spec___AllPendingDisplayNames+=("$pendingDisplayName")
      fi
    done
  done
  unset pendingPrefix
  unset pendingFunctionName
  unset pendingFunctionNames
  unset pendingDisplayName
  unset withoutPrefix
  unset alreadyAdded
  unset existingFunctionName

  local setupFunctionName
  for setupFunctionName in $( spec.setupFunctionNames )
  do
    [ -z "$setupFunctionName" ] && continue
    if declare -F | grep "declare -f $setupFunctionName" >/dev/null
    then
      ___spec___AllSetupFunctionNames+=("$setupFunctionName")
    fi
  done
  unset setupFunctionName

  local teardownFunctionName
  for teardownFunctionName in $( spec.teardownFunctionNames )
  do
    [ -z "$teardownFunctionName" ] && continue
    if declare -F | grep "declare -f $teardownFunctionName" >/dev/null
    then
      ___spec___AllTeardownFunctionNames+=("$teardownFunctionName")
    fi
  done
  unset teardownFunctionName

  local setupFixtureFunctionName
  for setupFixtureFunctionName in $( spec.setupFixtureFunctionNames )
  do
    [ -z "$setupFixtureFunctionName" ] && continue
    if declare -F | grep "declare -f $setupFixtureFunctionName" >/dev/null
    then
      ___spec___AllSetupFixtureFunctionNames+=("$setupFixtureFunctionName")
    fi
  done
  unset setupFixtureFunctionName

  local teardownFixtureFunctionName
  for teardownFixtureFunctionName in $( spec.teardownFixtureFunctionNames )
  do
    [ -z "$teardownFixtureFunctionName" ] && continue
    if declare -F | grep "declare -f $teardownFixtureFunctionName" >/dev/null
    then
      ___spec___AllTeardownFixtureFunctionNames+=("$teardownFixtureFunctionName")
    fi
  done
  unset teardownFixtureFunctionName

  unset specNamePattern

  spec.displayTestsBanner

  ##
  # Run Setup Fixtures, if any (note: unlike setup/teardown these are not in a subshell)
  ##
  set -e
  local ___spec___SetupFixtureFunction
  for ___spec___SetupFixtureFunction in "${___spec___AllSetupFixtureFunctionNames[@]}"
  do
    "$___spec___SetupFixtureFunction"
  done
  set +e
  ##

  ##
  local ___spec___TotalSpecCount="${#___spec___AllSpecFunctionNames[@]}"
  local ___spec___FailedCount=0
  local ___spec___PassedCount=0
  ##

  local ___spec___CurrentSpecIndex=0
  while [ $___spec___CurrentSpecIndex -lt "${#___spec___AllSpecFunctionNames[@]}" ]
  do
    local SPEC_FUNCTION="${___spec___AllSpecFunctionNames[$___spec___CurrentSpecIndex]}"
    local SPEC_NAME="${___spec___AllSpecDisplayNames[$___spec___CurrentSpecIndex]}"

    (( ___spec___CurrentSpecIndex++ ))
    
    local ___spec___STDOUT_file="$( mktemp )"
    local ___spec___STDERR_file="$( mktemp )"

    spec.displayRunningTest "$SPEC_NAME"

    local ___spec___testRunStatus
    ___spec___unusedOutput="$( spec.runTest "${___spec___AllSetupFunctionNames[@]}" "$SPEC_FUNCTION" "${___spec___AllTeardownFunctionNames[@]}" 1> "$___spec___STDOUT_file" 2> "$___spec___STDERR_file" )"
    ___spec___testRunStatus=$?

    local ___spec___STDOUT="$( cat "$___spec___STDOUT_file" )"
    local ___spec___STDERR="$( cat "$___spec___STDERR_file" )"

    if [ $___spec___testRunStatus -eq 0 ]
    then
      (( ___spec___PassedCount++ ))
      spec.displayTestResult "$SPEC_FUNCTION" "$SPEC_NAME" "PASS" "$___spec___STDOUT" "$___spec___STDERR"
    else
      (( ___spec___FailedCount++ ))
      spec.displayTestResult "$SPEC_FUNCTION" "$SPEC_NAME" "FAIL" "$___spec___STDOUT" "$___spec___STDERR"
    fi
  done

  ##
  # Run Setup Fixtures, if any (note: unlike setup/teardown these are not in a subshell)
  ##
  set -e
  local ___spec___SetupFixtureFunction
  for ___spec___SetupFixtureFunction in "${___spec___AllSetupFixtureFunctionNames[@]}"
  do
    "$___spec___SetupFixtureFunction"
  done
  set +e
  ##

  ##
  # Print Pending Tests
  ##
  local ___spec___CurrentPendingIndex=0
  while [ $___spec___CurrentPendingIndex -lt "${#___spec___AllPendingFunctionNames[@]}" ]
  do
    local SPEC_FUNCTION="${___spec___AllPendingFunctionNames[$___spec___CurrentPendingIndex]}"
    local SPEC_NAME="${___spec___AllPendingDisplayNames[$___spec___CurrentPendingIndex]}"
    (( ___spec___CurrentPendingIndex++ ))
    spec.displayPendingTestResult "$SPEC_FUNCTION" "$SPEC_NAME"
  done
  local ___spec___PendingCount="${#___spec___AllPendingFunctionNames[@]}"

  if [ $___spec___TotalSpecCount -gt 0 ] && [ $___spec___FailedCount -gt 0 ]
  then
    spec.displayTestsSummary "FAIL" $___spec___TotalSpecCount $___spec___PassedCount $___spec___FailedCount $___spec___PendingCount
  else
    spec.displayTestsSummary "PASS" $___spec___TotalSpecCount $___spec___PassedCount $___spec___FailedCount $___spec___PendingCount
  fi
}

___spec___.runTest() {
  local ___spec___setupOrTestOrTeardownFunction
  for ___spec___setupOrTestOrTeardownFunction in "$@"
  do
    "$___spec___setupOrTestOrTeardownFunction"
    local ___spec___returnCode=$?
    if [ $___spec___returnCode -ne 0 ]
    then
      return $___spec___returnCode
    fi
  done
}

[ -n "$SPEC_CONFIG" ] && [ -f "$SPEC_CONFIG" ] && source "$SPEC_CONFIG"