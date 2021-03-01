specs._.private.init.loadEnvironmentVariables() {
  ## ### loadEnvironmentVariables
  ##
  ## 🕵️ `store private init loadEnvironmentVariables`
  ##
  ## | | Parameter description |
  ## |-|------------|
  ## | `SPECS_STYLE` | ... |
  ## | `SPECS_REPORTER` | ... |
  ## | `SPECS_THEME` | ... |
  ## | `SPECS_RANDOM` | ... |
  ## | `SPECS_RANDOM_SEED` | ... |
  ## | `SPECS_EXTENSIONS` | ... |
  ##
  ## | | Return value | |
  ## |-|------------|
  ## | `$?` | _No explicit return_ |
  ##

  # TODO MOVE OUT OF 'store' and just have a top-level `configVariables`
  [ -n "$SPECS_STYLE" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_STYLE "$SPECS_STYLE"
  [ -n "$SPECS_REPORTER" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_REPORTER "$SPECS_REPORTER"
  [ -n "$SPECS_THEME" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_THEME "$SPECS_THEME"
  [ -n "$SPECS_RANDOM" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_RANDOM "$SPECS_RANDOM"
  [ -n "$SPECS_RANDOM_SEED" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_RANDOM_SEED "$SPECS_RANDOM_SEED"
  [ -n "$SPECS_PARALLEL" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_PARALLEL "$SPECS_PARALLEL"
  [ -n "$SPECS_EXTENSIONS" ] && specs -- store configVariables setValueFromEnvironmentVariable SPECS_EXTENSIONS "$SPECS_EXTENSIONS"
}