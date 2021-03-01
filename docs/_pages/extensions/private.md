---
title: 'private API Reference'
permalink: /extensions/private
layout: singleModified
sidebar:
  nav: 'extensions-private'
---

# Private API

🕵️ The private API contains functions which cannot be overriden or extended via Specs Extensions.

## init

Private init ...
### initializeSpecs

🕵️ `store private init initializeSpecs`

This is the very first block of code which runs the first time the `specs`
function is executed (immediately when running `specs` as a binary).

- Configures default configation variables with default values (via [`loadDefaultConfigVariables`](#loadDefaultConfigVariables))
  - This loads any configuration values which were provided via environment variables, including registered Extensions
- Initializes all Extensions registered via environment variables.
- Invokes configuration file loading (_this can be extended or overriden_)

#### 👩‍💻 Implementation Details

- Sets the `SPECS_INITIALIZED` variable equal to the current time when the `specs` function was first initialized.
- Sets the `SPECS_VERSION` variable to the current version of `specs`

| | Parameter description |
|-|------------|
| `$@` | _No parameters_ |

| | Return value | |
|-|------------|
| `$?` | _No explicit return_ |

### loadDefaultConfigVariables

🕵️ `store private init loadDefaultConfigVariables`

| | Parameter description |
|-|------------|
| `$@` | _No parameters_ |

| | Return value | |
|-|------------|
| `$?` | _No explicit return_ |

| `$1` | Name of configuration variable, e.g. `SPECS_FOO` |
| `$2` | Type of configuration variable, e.g. `value` or `list` or `bool` |
| `$3` | Helpful description of the variable for users of your variable |
| `$4` | Space-separated list of CLI flags for configuring this variable, if any |
| `$5` | Default value, if any. For `bool` values this should be `true` or empty string for false. |
