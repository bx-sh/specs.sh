### `$SPEC_FUNCTION_PREFIXES`

- The list of prefixes to use when determing which functions "represent" spec/tests.
- Both the `xunit` and `spec` formatters use this to store which function prefixes should be noted as tests
  - e.g. `xunit` looks for functions starting with `test`
  - e.g. `spec` looks for functions starting with `@spec.` or `@example.` or `@it.`
- This is a `\n` separated value (_because function names can include the `:` character_)

