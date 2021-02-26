# Load default variable values (so config can alter them if so desired)
spec.set.defaultVariables

# Before anything happens, load config files
spec.loadAndSource.configFiles

# Run specs.sh as executable if called directly:
[ "$0" = "${BASH_SOURCE[0]}" ] && spec.main "$@"
