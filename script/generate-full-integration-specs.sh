#! /usr/bin/env bash

rm -rf spec/full/integration

while read -d '' -r specFile
do
  fullSpecFile="${specFile/spec\/integration/spec\/full\/integration}"
  newSpecFilename="${fullSpecFile/*\/}"
  newSpecFolder="${fullSpecFile%"$newSpecFilename"}"
  mkdir -p "$newSpecFolder"
  cat "$specFile" | sed 's/\.\/specs\.sh /.\/specs-full.sh /g' > "$fullSpecFile"
done < <( find spec/integration \( -iname "*.spec.sh" -o -iname specHelper.sh \) -print0 )

echo "Generated spec/full/integration specs (copy of specs.sh specs for specs-full.sh)"