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

  # Return the source code for the given source file (to put into this item's case/esac statement)
  if [ "$1" = "--" ] && [ "$2" = "loadSourceFile" ]
  then
    shift; shift;
    local fullCommandName="$1"
    local commandName="${fullCommandName##* }"
    local parentCommandName="${fullCommandName% *}"
    local functionName="${fullCommandName# *}"
    local sourceFile="$2"
    # TODO Optional: replace this with string replacements instead, no shell out, will matter if we compile a ton of files, not doing any cat or sed etc would be nice, we can $(<file) and just do string replacements locally
    local sourceFileContent="$( cat "$sourceFile" | sed "s/CASE_COMMAND_ESAC/$commandName/g" | sed "s/CASE_FULL_COMMAND_ESAC/$fullCommandName/g" | sed "s/CASE_PARENT_COMMAND_ESAC/$parentCommandName/g" | sed "s/CASE_FUNCTION_ESAC/$functionName/g" )"
    if echo "$sourceFileContent" | head -1 | grep "() {" &>/dev/null
    then
      sourceFileContent="$( echo -e "$sourceFileContent" | tail -n +2 | head -n -1 )"
    fi

    # Update the argument numbers based on the number of parent commands
    # $1 is expected to be the first argument
    # this will break with over 20 arguments
    # we increment the code's argument number by N where N = the parent command count (minus one - not counting the top level function which doesn't offset)
    local offset="${fullCommandName//[^ ]}"
    offset="${#offset}"
    local argumentNumber=20
    while [ $argumentNumber -gt 0 ]
    do
      local replacement="$(( $argumentNumber + $offset ))"
      sourceFileContent="${sourceFileContent//\$$argumentNumber/\$$replacement}"
      sourceFileContent="${sourceFileContent//\${$argumentNumber/\${$replacement}"
      : $(( argumentNumber -- ))
    done

    echo -e "$sourceFileContent"
    return 0

  # Generate and output the text for the case/esac code for the given directory of files:
  elif [ "$1" = "--" ] && [ "$2" = "caseEsacForDir" ]
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
      local fullCommandName="${commandFileOrSubcommandDirectory/"$rootCommandsDirectoryPath"}"
      fullCommandName="${fullCommandName#/}"
      fullCommandName="${fullCommandName%.sh}"
      fullCommandName="$topLevelFunctionName ${fullCommandName//// }"

      local commandName="${commandFileOrSubcommandDirectory##*/}"
      commandName="${commandName%.sh}"
      echo "${indentation}  $commandName)"
      if [ -d "$commandFileOrSubcommandDirectory" ]
      then
        caseEsacCompiler -- caseEsacForDir "$(( $commandDepth + 1 ))" "$commandFileOrSubcommandDirectory" "$rootCommandsDirectoryPath" "$topLevelFunctionName" | sed "s/^/$indentation/"
      elif [ -f "$commandFileOrSubcommandDirectory" ]
      then
        caseEsacCompiler -- loadSourceFile "$fullCommandName" "$commandFileOrSubcommandDirectory" | sed "s/^/$indentation    /"
      fi
      echo -e "\n${indentation}      ;;"
    done
    echo "  *)"
    local subCommandName="${commandsDirectoryPath/"$rootCommandsDirectoryPath"}"
    subCommandName="${subCommandName#/}"
    subCommandName="${subCommandName//// }"
    if [ $commandDepth = 1 ]
    then
      if [ -f "$commandsDirectoryPath/.index.sh" ]
      then
        caseEsacCompiler -- loadSourceFile "$topLevelFunctionName" "$commandsDirectoryPath/.index.sh" | sed "s/^/$indentation    /"
      else
        echo "    echo \"Unknown '$topLevelFunctionName' command: \$$commandDepth\" >&2"
      fi
    else
      local subCommandFolder="${commandFileOrSubcommandDirectory%/*}"
      if [ -f "$subCommandFolder/.index.sh" ]
      then
        caseEsacCompiler -- loadSourceFile "$topLevelFunctionName $subCommandName" "$subCommandFolder/.index.sh" | sed "s/^/$indentation    /"
      else
        echo "    echo \"Unknown '$topLevelFunctionName $subCommandName' command: \$$commandDepth\" >&2"
      fi
    fi
    echo "    return 1"
    echo "    ;;"
    echo "${indentation}esac"
    return 0
  fi

  # main():

  local topLevelFunctionName="$1"
  shift

  local outputFilePath="$1"
  shift

  local commandFilesRootPath="$1"
  shift

  # Go through the commands and, for each command, find its children and generate the text for them!
  local sourceFileContent="$topLevelFunctionName() {
$( caseEsacCompiler -- caseEsacForDir 1 "$commandFilesRootPath" "$commandFilesRootPath" "$topLevelFunctionName" )
}
"

  echo "$sourceFileContent" > "$outputFilePath"
}