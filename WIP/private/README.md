# `specs` `--` `private`

The `private` `specs` API functions are not called via `specs` `--` `invoke` and therefore
cannot be extended via **Specs Extensions**.

This basically just contains the core `initialize` function which:

- Loads the _default_ configuration variables
- Checks for provided _environment_ variables
- Kicks off an `init` call for each of the loaded extensions, if any
- Loads config files via `-- configFiles loadAll` which _is_ run via `invoke`
  and **Specs Extensions** can override or extend this function
