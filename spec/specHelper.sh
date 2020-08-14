. "$( bx BxSH )"

PACKAGE_PATH=".:packages/"

import @assert
import @expect/all
import @run-command

test_specs="examples/.test_specs"

spec() {
  ./bin/spec "$@"
}