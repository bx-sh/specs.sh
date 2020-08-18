# 🔬 Simple Shell Specifications

> - Small
> - Flexible
> - Simply BASH

---

`spec.sh` is a shell script testing library written for developer happiness 💝

If you've used any popular testing framework `spec.sh` should feel familiar!

## Features

 - Different testing syntax to choose from (`xUnit`-style or `BDD`-style)
 - Integrated libraries for `expect`-style or `assert`-style assertions
 - TAP compliant output (as well as `jUnit.xml` and pretty formatters)
 - y

### xUnit-style tests

```sh
setUp() {
  directory="$( mktemp -d )"
}

testFileExists() {
  assert [ -f "$directory/file" ]
}
```

### BDD-style specs

```sh
@before() {
  directory="$( mktemp -d )"
}

@spec.file_should_exist() {
  expect { ls "$directory" } toContain "file"
}
```