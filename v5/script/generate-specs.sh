#! /usr/bin/env bash

rm -f specs.sh

cat src/header.sh >> specs.sh
echo >> specs.sh
cat src/version.sh | grep -v "^[[:space:]]*#\|^$" >> specs.sh
echo >> specs.sh
# load config
cat src/main.sh | grep -v "^[[:space:]]*#\|^$" >> specs.sh
echo >> specs.sh
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs.sh
  echo >> specs.sh
done < <( find src/api -type f -name "*.sh" -print0 )
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs.sh
  echo >> specs.sh
done < <( find src/formatters -type f -name "*.sh" -print0 )
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> specs.sh
  echo >> specs.sh
done < <( find src/styles -type f -name "*.sh" -print0 )
cat src/footer.sh | grep -v "^[[:space:]]*#\|^$" >> specs.sh

chmod +x specs.sh

echo "Generated specs.sh"