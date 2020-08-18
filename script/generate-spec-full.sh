#! /usr/bin/env bash

rm -f spec-full.sh

cat src/header.sh >> spec-full.sh
echo >> spec-full.sh

cat src/version.sh >> spec-full.sh
echo >> spec-full.sh

# load config
cat src/main.sh >> spec-full.sh
echo >> spec-full.sh

while read -d '' -r apiFile
do
  cat "$apiFile" >> spec-full.sh
  echo >> spec-full.sh
done < <( find src/api -type f -name "*.sh" -print0 )

while read -d '' -r apiFile
do
  cat "$apiFile" >> spec-full.sh
  echo >> spec-full.sh
done < <( find src/formatters -type f -name "*.sh" -print0 )

########################################################
# Embed 'expect' 'assert' 'run-command' libraries
#
echo >> spec-full.sh
cat ./packages/assert-*/assert.sh >> spec-full.sh
echo >> spec-full.sh
cat ./packages/assert-*/refute.sh >> spec-full.sh
echo >> spec-full.sh
cat ./packages/run-command-*/run-command.sh >> spec-full.sh
echo >> spec-full.sh
cat ./packages/expect-*/expect.sh >> spec-full.sh
echo >> spec-full.sh
while read -d '' -r expectMatcher
do
  cat "$expectMatcher" >> spec-full.sh
  echo >> spec-full.sh
done < <( find ./packages/expect-*/matchers/ -type f -name "*.sh" -print0 )
echo >> spec-full.sh
#
########################################################

echo >> spec-full.sh
cat src/footer.sh >> spec-full.sh

chmod +x spec-full.sh

echo "Generated spec-full.sh"