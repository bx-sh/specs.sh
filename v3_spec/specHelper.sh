. "$( bx BxSH )"

PACKAGE_PATH=".:packages/"

import @assert
import @expect
import @run-command

test_specs="examples/.test_specs"

spec() {
  ./bin/spec "$@"
}