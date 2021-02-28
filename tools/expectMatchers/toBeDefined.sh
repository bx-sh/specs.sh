expect.matcher.toBeDefined() {
  [ $# -gt 0 ] && { echo "toBeDefined expects 0 arguments, received $# [$*]" >&2; exit 1; }

  local __expect__variableName
  if [ "${#EXPECT_BLOCK[@]}" -gt 0 ]
  then
    expect.execute_block
    __expect__variableName="${EXPECT_STDOUT}${EXPECT_STDERR}"
  else
    __expect__variableName="$EXPECT_ACTUAL_RESULT"
  fi

  local __expect__variableDefined
  local __expect__actualVariableValue
  if eval "[ -n \"\${$__expect__variableName+x}\" ]"
  then
    __expect__variableDefined=true
    eval "__expect__actualVariableValue=\"\${$__expect__variableName[@]}\""
  fi
  
  if [ -z "$EXPECT_NOT" ]
  then
    if [ -z "$__expect__variableDefined" ]
    then
      expect.fail "Expected variable $__expect__variableName to be defined but was undefined."
    fi
  else
    if [ -n "$__expect__variableDefined" ]
    then
      expect.fail "Expected variable $__expect__variableName to be undefined but was defined\nActual: '$__expect__actualVariableValue'"
    fi
  fi

  return 0
}