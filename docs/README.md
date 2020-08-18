# 🔬 Shell Specifications

> - Familiar syntax
> - Pleasant to write
> - Small (< 500 LOC)

---

`spec.sh` is a shell script testing library written for developer happiness 💝

If you've used any popular testing framework `spec.sh` should feel familiar!

## Features

 - Easy-to-use CLI for running test specification files (`*.spec|test.sh`)
 - Different testing syntax to choose from (_`xUnit`-style or `BDD`-style_)
 - Integrated libraries for `expect`-style or `assert`-style assertions
 - Absurdly customizable: _hook into any function, customize anything!_
 - TAP compliant output (_as well as `JUnit.xml` and pretty formatters_)

### xUnit-style tests

```sh
setUp()    { directory="$( mktemp -d )"; }
tearDown() { rm -r "$directory"; }

testFileExists() {
  assert [ -f "$directory/file" ]
}
```

### BDD-style specs

```sh
@before() { directory="$( mktemp -d )"; }
@after()  { rm -r "$directory"; }

@spec.file_should_exist() {
  expect { ls "$directory" } toContain "file"
}
```