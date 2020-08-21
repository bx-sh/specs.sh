#! /usr/bin/env bash

rm -f spec-full.sh

cat src/header.sh >> spec-full.sh
echo >> spec-full.sh

cat src/version.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh

# load config
cat src/main.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
  echo >> spec-full.sh
done < <( find src/api -type f -name "*.sh" -print0 )

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
  echo >> spec-full.sh
done < <( find src/formatters -type f -name "*.sh" -print0 )

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
  echo >> spec-full.sh
done < <( find src/styles -type f -name "*.sh" -print0 )

########################################################
# Embed 'expect' 'assert' 'run-command' libraries
#
echo >> spec-full.sh
cat ./packages/assert-*/assert.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh
cat ./packages/assert-*/refute.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh
cat ./packages/run-*/run.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh
cat ./packages/expect-*/expect.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
echo >> spec-full.sh
while read -d '' -r expectMatcher
do
  cat "$expectMatcher" | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh
  echo >> spec-full.sh
done < <( find ./packages/expect-*/matchers/ -type f -name "*.sh" -print0 )
echo >> spec-full.sh
#
########################################################

echo >> spec-full.sh
cat src/footer.sh | grep -v "^[[:space:]]*#\|^$" >> spec-full.sh

chmod +x spec-full.sh

echo "Generated spec-full.sh"