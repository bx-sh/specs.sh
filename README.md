# 🔬 `@spec`

Simple Shell Specifications.

---

> - Small
> - Flexible
> - Simply BASH

---

```sh
@setup() {
  PATH="./greeting/bin:$PATH"
}

@teardown() {
  : # Do some cleanup
}

@spec.should_give_a_nice_greeting() {
  [ "$( greeting )" = "Hello, world!" ]
}

@pending.I_will_write_this_later() {
  : # Unimplemented test
}
```
