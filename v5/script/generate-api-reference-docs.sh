rm -f API_REFERENCE.md
rm -f docs/API_REFERENCE.md

rm -rf docs/{user,customization}/

mkdir -p docs/user/variables
mkdir -p docs/customization/{variables,functions}

git grep -h "^[[:space:]]*##" src/ | sed 's/^[[:space:]]*//' | sed 's/^##[[:space:]]\?//' > all-comments.md
echo >> all-comments.md

CURRENT_OUTPUT_FILE=""
  
while IFS="" read -r line || [ -n "$line" ]
do

  # @user @variable
  if [[ "$line" =~ ^@user[[:space:]]@variable ]]
  then
    variableName="${line#@user @variable }"
    CURRENT_OUTPUT_FILE="docs/user/variables/$variableName.md"
    line="## \`\$$variableName\`"
  fi

  # @variable
  if [[ "$line" =~ ^@variable ]]
  then
    variableName="${line#@variable }"
    CURRENT_OUTPUT_FILE="docs/customization/variables/$variableName.md"
    line="### \`\$$variableName\`"
  fi

  # @function
  if [[ "$line" =~ ^@function ]]
  then
    functionName="${line#@function }"
    CURRENT_OUTPUT_FILE="docs/customization/functions/$functionName.md"
    line="#### \`$functionName()\`"
  fi

  [ -n "$CURRENT_OUTPUT_FILE" ] && echo "$line" >> "$CURRENT_OUTPUT_FILE"

done < all-comments.md

rm -f all-comments.md

echo "## 🎨 User Configuration

Environment variables for configuring the behavior of \`specs.sh\`

These can be exported in your shell or configured in \`spec.config.sh\`

 - Export variables
   \`\`\`sh
   export SPEC_FORMATTER=tap

   ./specs.sh file.spec.sh dir/
   \`\`\`
 - Set variables in \`spec.config.sh\`
   \`\`\`sh
   # spec.config.sh

   SPEC_FORMATTER=tap
   \`\`\`

> Note: \`spec.config.sh\` runs _after_ default variables are configured.

" >> API_REFERENCE.md

while read -d '' -r referenceDoc
do
  cat "$referenceDoc" >> API_REFERENCE.md
  echo >> API_REFERENCE.md
done < <( find ./docs/user/variables/ -type f -name "*.md" -print0 )

echo "---

# 🛠️ Customization API

\`specs.sh\` is extremely customizable.

This section provides documentation on the variables and functions you
may want to configure to customize \`specs.sh\` to meet your needs!

Every \`specs.sh\` function documented here can be overriden
by defining a new function in your \`spec.config.sh\` file.

For example:

\`\`\`sh
# TODO
\`\`\`

## Variables

" >> API_REFERENCE.md

while read -d '' -r referenceDoc
do
  cat "$referenceDoc" >> API_REFERENCE.md
  echo >> API_REFERENCE.md
done < <( find ./docs/customization/variables/ -type f -name "*.md" -print0 | sort -z )

echo "
## Functions

" >> API_REFERENCE.md

while read -d '' -r referenceDoc
do
  cat "$referenceDoc" >> API_REFERENCE.md
  echo >> API_REFERENCE.md
done < <( find ./docs/customization/functions/ -type f -name "*.md" -print0 | sort -z )

cp API_REFERENCE.md docs/API_REFERENCE.md

echo "Generated API_REFERENCE.md"