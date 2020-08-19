## `$SPEC_FORMATTER`

- Sets the formatter to use, e.g.
  - `documentation` - default formatter
    - supports color
    - prints `[OK]` and `[FAIL]` messages for each spec
  - `tap` - [TAP-compliant](https://testanything.org/) output
    - See [testanything.org](https://testanything.org/) for more information
  - `xml` - JUnit-style XML output
    - (_XML format used by many continuous integration platforms_
- The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax

