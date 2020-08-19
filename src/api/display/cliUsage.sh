spec.display.cliUsage() { ___spec___.display.cliUsage "$@"; }

___spec___.display.cliUsage() {
  spec.display.cliUsage.header
  # for each registered flag argument, loop and show its display usage documentation
  spec.display.cliUsage.footer
}