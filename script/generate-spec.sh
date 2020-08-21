#! /usr/bin/env bash

rm -f spec.sh

cat src/header.sh >> spec.sh
echo >> spec.sh
cat src/version.sh | grep -v "^[[:space:]]*#\|^$" >> spec.sh
echo >> spec.sh
# load config
cat src/main.sh | grep -v "^[[:space:]]*#\|^$" >> spec.sh
echo >> spec.sh
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec.sh
  echo >> spec.sh
done < <( find src/api -type f -name "*.sh" -print0 )
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec.sh
  echo >> spec.sh
done < <( find src/formatters -type f -name "*.sh" -print0 )
while read -d '' -r apiFile
do
  cat "$apiFile" | grep -v "^[[:space:]]*#\|^$" >> spec.sh
  echo >> spec.sh
done < <( find src/styles -type f -name "*.sh" -print0 )
cat src/footer.sh | grep -v "^[[:space:]]*#\|^$" >> spec.sh

chmod +x spec.sh

echo "Generated spec.sh"