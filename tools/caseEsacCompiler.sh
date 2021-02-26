## `caseEsacCompiler.sh`
##
## Compile multiple .sh files into a single file with a single top-level
## function and multiple commands and subcommands.
##
## - Every directory represents a `case`/`esac`
## - Every `.sh` file represents a `case` option
##
## | | Parameters |
## |-|------------|
## | `$1` | The name of the top-level function to generate. All subcommands will be run through this top-level function. |
## | `$2` | The name of the source file to output. Will contain one function with any number of commands and subcommands. |
## | `$3` | The root path of command files. Used to determine the depth of subcommands to generate. |
##
caseEsacCompiler() {

  # Return the case/esac text for the given command
  if [ "$1" = "--" ] && [ "$2" = "caseWhenForDir" ]
  then
    shift; shift;
    local commandDepth="$1"
    local commandsDirectoryPath="$2"
    local rootCommandsDirectoryPath="$3"
    local topLevelFunctionName="$4"
    local indentation=""
    local i=0
    while [ $i -lt $commandDepth ]
    do
      indentation="$indentation  "
      : $(( i++ ))
    done
    echo -e "${indentation}case \"\$$commandDepth\" in"
    local commandFileOrSubcommandDirectory
    for commandFileOrSubcommandDirectory in $commandsDirectoryPath/*
    do
      local commandName="${commandFileOrSubcommandDirectory##*/}"
      commandName="${commandName%.sh}"
      echo "${indentation}  $commandName)"
      if [ -d "$commandFileOrSubcommandDirectory" ]
      then
        caseEsacCompiler -- caseWhenForDir "$(( $commandDepth + 1 ))" "$commandFileOrSubcommandDirectory" "$rootCommandsDirectoryPath" "$topLevelFunctionName" | sed "s/^/$indentation/"
      elif [ -f "$commandFileOrSubcommandDirectory" ]
      then
        cat "$commandFileOrSubcommandDirectory" | sed "s/^/$indentation    /"
      fi
      echo -e "\n${indentation}      ;;"
    done
    echo "  *)"
    local subCommandName="${commandsDirectoryPath/"$rootCommandsDirectoryPath"}"
    subCommandName="${subCommandName#/}"
    subCommandName="${subCommandName//// }"
    if [ $commandDepth = 1 ]
    then
      echo "    echo \"Unknown '$topLevelFunctionName' command: \$$commandDepth\" >&2"
    else
      echo "    echo \"Unknown '$topLevelFunctionName $subCommandName' command: \$$commandDepth\" >&2"
    fi
    echo "    return 1"
    echo "    ;;"
    echo "${indentation}esac"
    return 0
  fi

  local topLevelFunctionName="$1"
  shift

  local outputFilePath="$1"
  shift

  local commandFilesRootPath="$1"
  shift

  # Go through the commands and, for each command, find its children and generate the text for them!
  local sourceFileContent="$topLevelFunctionName() {
$( caseEsacCompiler -- caseWhenForDir 1 "$commandFilesRootPath" "$commandFilesRootPath" "$topLevelFunctionName" )
}
"

  echo "$sourceFileContent" > "$outputFilePath"
}