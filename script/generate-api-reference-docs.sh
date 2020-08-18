rm -rf docs/functions/
rm -rf docs/variables/

mkdir -p docs/functions/
mkdir -p docs/variables/

git grep -h "^[[:space:]]*##" src/ | sed 's/^[[:space:]]*//' | sed 's/^##[[:space:]]\?//' > all-comments.md
echo >> all-comments.md

CURRENT_OUTPUT_FILE=""
  
while IFS="" read -r line || [ -n "$line" ]
do

  # @function
  if [[ "$line" =~ ^@function ]]
  then
    functionName="${line#@function }"
    CURRENT_OUTPUT_FILE="docs/functions/$functionName.md"
    line="### \`$functionName\`"
  fi

  # @variable
  if [[ "$line" =~ ^@variable ]]
  then
    variableName="${line#@variable }"
    CURRENT_OUTPUT_FILE="docs/variables/$variableName.md"
    line="### \`$variableName\`"
  fi

  if [ -n "$CURRENT_OUTPUT_FILE" ]
  then
    echo "$line" >> "$CURRENT_OUTPUT_FILE"
  fi

done < all-comments.md

rm -f all-comments.md

echo "Generated docs/functions/ docs/variables/"