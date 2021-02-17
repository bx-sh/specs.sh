## @function spec.display.formatters.documentation.after:run.specFile
##
## - Displays the name of the file being run
##

spec.formatters.documentation.display.after:run.specFile() {
  ___spec___.formatters.documentation.display.after:run.specFile "$@"
}

___spec___.formatters.documentation.display.after:run.specFile() {
  echo
}