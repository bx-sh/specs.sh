---
title: 'private API Reference'
permalink: /extensions/private
layout: singleModified
sidebar:
  nav: 'extensions-private'
---

# 🕵️ Private API

🕵️ The private API contains functions which cannot be overriden or extended via Specs Extensions.

## initializeEnvironment

Private init ...
### init

🕵️ `store private initialize init`

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

### loadEnvironmentVariables

🕵️ `store private init loadEnvironmentVariables`

| | Parameter description |
|-|------------|
| `SPECS_STYLE` | ... |
| `SPECS_REPORTER` | ... |
| `SPECS_THEME` | ... |
| `SPECS_RANDOM` | ... |
| `SPECS_RANDOM_SEED` | ... |
| `SPECS_EXTENSIONS` | ... |

| | Return value | |
|-|------------|
| `$?` | _No explicit return_ |

