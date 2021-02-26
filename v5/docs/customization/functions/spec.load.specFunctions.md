#### `spec.load.specFunctions()`

- Responsible for loading all functions which "represent"
  specs/tests from the currently sourced environment.
- This runs after the spec file has already been sourced.
  If you need to compare the state before/after the spec
  file has been sourced, look into overriding `spec.source.specFile`
- This function must populate 2 arrays:
  - `SPEC_FUNCTIONS` which should contain the full function
     names of all functions which "represent" specs/tests
  - `SPEC_DISPLAY_NAMES` which should contain the "pretty" display
    names for each function. To get a display name for a function,
    you use the same array index (and vice versa). These arrays must
    have an equal length and every function must have a display name.

