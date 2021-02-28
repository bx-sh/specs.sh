source vendor/assert.sh
source vendor/refute.sh
source vendor/expect.sh
source vendor/run.sh
source tools/expectMatchers/toBeDefined.sh

# Call `spec` by path, explicitly calling it as a binary (incase the `specs` function is loaded)
binSpec() {
  ./bin/specs "$@"
}