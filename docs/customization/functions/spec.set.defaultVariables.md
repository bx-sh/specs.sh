#### `spec.set.defaultVariables()`

- Sets all default variables
- This is run BEFORE config files are loaded and therefore CANNOT be customized
- All of the default variables are set only if there isn't already a value present for the given variable
- To customize variables, either:
  - `export` an environment variable or pass it directly to `ENV= ./specs.sh` when running it
  - Simply set the variable in your `spec.config.sh`, e.g. `SPEC_FORMATTER=tap`

