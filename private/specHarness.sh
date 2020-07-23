spec.loadSpecHelpers() {
  ##
  # Load specHelper.sh if it exists (load all of them from left to right)
  #
  # TODO - update so that it only goes so high up as the nearest package.sh !!!
  ##
  local dirpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
  declare -a specHelperPathsToSource=()
  while [ "$dirpath" != "/" ]
  do
    specHelperPathsToSource+=("$dirpath/specHelper.sh")
    dirpath="$( dirname "$dirpath" )"
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
  local testCount=0
  local passedCount=0
  local failedCount=0
  for testName in $( declare -F | grep "declare -f @spec\." | sed 's/declare -f //'  )
  do
    testCount=$(( testCount + 1 ))
    local displayTestName="${testName/@spec\.}"
    displayTestName="${displayTestName//_/ }"

    local stdoutFile="$( mktemp )"
    local stderrFile="$( mktemp )"

    x="$( $testName 1> "$stdoutFile" 2> "$stderrFile" )"

    if [ $? -eq 0 ]
    then
      passedCount=$(( passedCount + 1 ))
      echo -e "[\e[32mOK\e[0m] $displayTestName"
    else
      failedCount=$(( failedCount + 1))
      echo -e "[\e[31mFAIL\e[0m] $displayTestName"
      local stdout="$( cat "$stdoutFile" | sed 's/\(.*\)/\1/' )"
      if [ -n "$stdout" ]
      then
        echo
        echo -e "[\e[1;34mSTDOUT\e[0m] -------------------------------------------"
        echo -e "$stdout"
        echo -e "----------------------------------------------------"
      fi
      local stderr="$( cat "$stderrFile" | sed 's/\(.*\)/\1/' )"
      if [ -n "$stderr" ]
      then
        echo
        echo -e "[\e[1;31mSTDERR\e[0m] -------------------------------------------"
        echo -e "$stderr"
        echo -e "----------------------------------------------------"
      fi
      echo
    fi
  done
  for pendingTestName in $( declare -F | grep "declare -f @pending\." | sed 's/declare -f //'  )
  do
    local displayPendingTestName="${pendingTestName/@pending\.}"
    displayPendingTestName="${displayPendingTestName//_/ }"
    echo -e "[\e[33mPENDING\e[0m] $displayPendingTestName"
  done
  echo
  if [ $failedCount -gt 0 ]
  then
    echo -e "\e[1;31mTests failed\e[0m. Ran $testCount tests. $passedCount passed, $failedCount failed."
    exit 1
  else
    echo -e "\e[1;32mTests passed\e[0m. Ran $testCount tests. $passedCount passed, $failedCount failed."
    exit 0
  fi
}