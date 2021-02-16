#! /usr/bin/env bash

rm -f specs-full.sh

cat src/header.sh >> specs-full.sh
echo >> specs-full.sh

cat src/version.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh

# load config
cat src/main.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
  echo >> specs-full.sh
done < <( find src/api -type f -name "*.sh" -print0 )

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
  echo >> specs-full.sh
done < <( find src/formatters -type f -name "*.sh" -print0 )

while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
  echo >> specs-full.sh
done < <( find src/styles -type f -name "*.sh" -print0 )

########################################################
# Embed 'expect' 'assert' 'run' libraries
#
echo >> specs-full.sh
cat ./packages/assert-*/assert.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh
cat ./packages/assert-*/refute.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh
cat ./packages/run-*/run.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh
cat ./packages/expect-*/expect.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
echo >> specs-full.sh
while read -d '' -r expectMatcher
do
  cat "$expectMatcher" | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh
  echo >> specs-full.sh
done < <( find ./packages/expect-*/matchers/ -type f -name "*.sh" -print0 )
echo >> specs-full.sh
#
########################################################

echo >> specs-full.sh
cat src/footer.sh | grep -v "^[[:space:]]*#\|^$" >> specs-full.sh

chmod +x specs-full.sh

echo "Generated specs-full.sh"