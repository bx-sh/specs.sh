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

@spec.caseEsacCompiler.can_compile_top_level_index_with_small_tree_of_subcommands() {
  expect { myCommand } toFail "myCommand: command not found"

  caseEsacCompiler myCommand "$outputFile" $commandsFolder/variousCommands/

  sourceGeneratedFile

  expect { myCommand --version } toEqual "This is the version"
  expect { myCommand foo hello } toEqual "Foo Hello"
  expect { myCommand foo world } toEqual "Foo World"
  expect { myCommand foo bar baz } toEqual "Foo Bar Baz"

  expect { myCommand doesntExist } toFail "Unknown 'myCommand' command: doesntExist"
  expect { myCommand foo doesntExist } toFail "Unknown 'myCommand foo' command: doesntExist"
  expect { myCommand foo bar doesntExist } toFail "Unknown 'myCommand foo bar' command: doesntExist"
}

@pending.caseEsacCompiler.individiual_files_can_be_working_functions_with_multiline_comment_headers() {
  :
}

@pending.caseEsacCompiler.can_replace_argument_indexes_to_be_the_correct_depth() {
  :
}

@pending.caseEsacCompiler.can_replace_parent_command_name_eg_in_docs_and_the_code() {
  :
}