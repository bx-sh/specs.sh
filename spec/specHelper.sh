source vendor/assert.sh
source vendor/refute.sh
source vendor/expect.sh
source vendor/run.sh
source tools/expectMatchers/toBeDefined.sh

# Call `spec` by path, explicitly calling it as a binary (incase the `specs` function is loaded)
binSpecs() {
  ./bin/specs "$@"
}

# source ./bin/specs and call a command so that specs() is already initialized
loadSpecs() {
  source ./bin/specs
  specs --version # invoke a command to cause specs() to initialize
}