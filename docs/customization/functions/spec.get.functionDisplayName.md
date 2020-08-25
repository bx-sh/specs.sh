#### `spec.get.functionDisplayName()`
- Provided a full function name (`$1`), e.g. `testFooBar` or `@spec.foo_bar`
- Return a display name (via `printf`), e.g. `Foo Bar` or `foo bar`
- Delegates to the currently selected `SPEC_STYLE` (else prints the arguments given)

> Note: this delegates to the STYLE rather than the FORMATTER because
> the STYLE is responsible for figuring out what functions are spec
> functions and pending functions, etc, which may use a certain DSL.
>
> To update the output for a FORMATTER, see functions such as:
> - `spec.display.after:run.specFunction`

