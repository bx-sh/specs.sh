name spec

version "$( grep SPEC_VERSION= bin/spec | sed 's/SPEC_VERSION="\([0-9]\.[0-9]\.[0-9]\)"/\1/' )"

description "🔬 Test specifications"

exclude examples/ private/ spec/

script build ./script/generate-all.sh
script spec ./script/spec

devDependency assert
devDependency expect
devDependency run