spec.loadSpecHelpers() {
  local dirpath="$1"
  declare -a specHelperPathsToSource=()
  specHelperPathsToSource+=("$dirpath/specHelper.sh")
  while [ "$dirpath" != "/" ] && [ "$dirpath" != "." ]
  do
    dirpath="$( dirname "$dirpath" )"
    specHelperPathsToSource+=("$dirpath/specHelper.sh")
  done
  local i="${#specHelperPathsToSource[@]}"
  (( i -= 1 ))
  while [ $i -gt -1 ]
  do
    [ -f "${specHelperPathsToSource[$i]}" ] && source "${specHelperPathsToSource[$i]}"
    (( i -= 1 ))
  done
}

spec.runTests() {
  local nameMatcher="$1"
  local testCount=0
  local passedCount=0
  local failedCount=0
  declare -a failedTestNames=()
  for testName in $( declare -F | grep "declare -f @spec\." | sed 's/declare -f //' | sort -R  )
  do
    [ -n "$nameMatcher" ] && [[ ! "$testName" =~ $nameMatcher ]] && continue

    testCount=$(( testCount + 1 ))
    local displayTestName="${testName/@spec\.}"
    displayTestName="${displayTestName//_/ }"

    local stdoutFile="$( mktemp )"
    local stderrFile="$( mktemp )"

    eval "___spec___testFn() {
      @setup
      $testName
      @teardown
    }"

    : "$( ___spec___testFn 1> "$stdoutFile" 2> "$stderrFile" )"

    if [ $? -eq 0 ]
    then
      passedCount=$(( passedCount + 1 ))
      echo -e "[\e[32mOK\e[0m] $displayTestName"
      if [ -n "$VERBOSE" ]
      then
        local stdout="$( cat "$stdoutFile" | sed 's/\(.*\)/\t\1/' )"
        if [ -n "$stdout" ]
        then
          echo
          echo -e "\t[\e[1;34mSTDOUT\e[0m] -------------------------------------------"
          echo -e "$stdout"
          echo -e "\t----------------------------------------------------"
        fi
        local stderr="$( cat "$stderrFile" | sed 's/\(.*\)/\t\1/' )"
        if [ -n "$stderr" ]
        then
          echo
          echo -e "\t[\e[1;31mSTDERR\e[0m] -------------------------------------------"
          echo -e "$stderr"
          echo -e "\t----------------------------------------------------"
        fi
        echo
      fi
    else
      failedCount=$(( failedCount + 1))
      failedTestNames+=("$testName")
      echo -e "[\e[31mFAIL\e[0m] $displayTestName"
      local stdout="$( cat "$stdoutFile" | sed 's/\(.*\)/\t\1/' )"
      if [ -n "$stdout" ]
      then
        echo
        echo -e "\t[\e[1;34mSTDOUT\e[0m] -------------------------------------------"
        echo -e "$stdout"
        echo -e "\t----------------------------------------------------"
      fi
      local stderr="$( cat "$stderrFile" | sed 's/\(.*\)/\t\1/' )"
      if [ -n "$stderr" ]
      then
        echo
        echo -e "\t[\e[1;31mSTDERR\e[0m] -------------------------------------------"
        echo -e "$stderr"
        echo -e "\t----------------------------------------------------"
      fi
      echo
    fi
  done
  for pendingTestName in $( declare -F | grep "declare -f @pending\." | sed 's/declare -f //'  )
  do
    [ -n "$nameMatcher" ] && [[ ! "$pendingTestName" =~ $nameMatcher ]] && continue
    local displayPendingTestName="${pendingTestName/@pending\.}"
    displayPendingTestName="${displayPendingTestName//_/ }"
    echo -e "[\e[33mPENDING\e[0m] $displayPendingTestName"
  done
  echo
  if [ $failedCount -gt 0 ]
  then
    echo -e "\e[1;31mTests failed\e[0m. Ran $testCount tests. $passedCount passed, $failedCount failed."
    echo
    local failedTestName
    for failedTestName in "${failedTestNames[@]}"
    do
      echo "- $failedTestName"
    done
    exit 1
  else
    if [ $testCount -gt 0 ]
    then
      echo -e "\e[1;32mTests passed\e[0m. Ran $testCount tests. $passedCount passed, $failedCount failed."
      exit 0
    else
      echo "No tests run"
      exit 0
    fi
  fi
}