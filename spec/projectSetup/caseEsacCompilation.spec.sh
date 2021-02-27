source tools/caseEsacCompiler.sh

# Author `caseEsacCompiler` as a generic tool.
#
# Will be used with other projects.
#
# This tests for functionality which `specs` may not use.

@before() {
  outputFile="$( mktemp )"
  commandsFolder="spec/resources/caseEsacCompiler"
}

@after() {
  [ -f "$outputFile" ] && rm "$outputFile"
}

outputFileContent() { cat "$outputFile"; }
sourceGeneratedFile() { source "$outputFile"; }

@spec.caseEsacCompiler() {
  expect { myCommand } toFail "myCommand: command not found"

  caseEsacCompiler compile myCommand "$outputFile" $commandsFolder/variousCommands/

  sourceGeneratedFile

  expect { myCommand --version } toEqual "This is the version"
  expect { myCommand foo hello } toEqual "Foo Hello"
  expect { myCommand foo world } toEqual "Foo World"
  expect { myCommand foo bar baz } toContain "Foo Bar Baz"
  expect { myCommand foo bar baz } toContain "my full command name is myCommand foo bar baz"
  expect { myCommand foo bar baz } toContain "my parent command name is myCommand foo bar"
  expect { myCommand foo bar baz } toContain "my function name is myCommand"
  expect { myCommand foo bar baz } toContain "my command name is baz"
  expect { myCommand foo bar baz "hello foo world" } toContain "my first relevant argument is 'hello foo world' or with foo replacement: 'hello FOO world'"

  # Has no .index.sh for its catch-all block
  expect { myCommand foo doesntExist } toFail "Unknown 'myCommand foo' command: doesntExist"

  # These have .index.sh files for their *) catch-all blocks
  expect { myCommand doesntExist } toEqual "Hello from some custom code that the top-level function has, \$1 is 'doesntExist'"
  expect { myCommand foo bar doesntExist } toEqual "This is the catchall for foo bar, \$3 is doesntExist and my full command is myCommand foo bar"
}