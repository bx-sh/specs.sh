name spec

version "$( grep SPEC_VERSION= bin/spec | sed 's/SPEC_VERSION="\([0-9]\.[0-9]\.[0-9]\)"/\1/' )"

description "🔬 Test specifications"

exclude examples/ private/