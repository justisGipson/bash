#!/usr/bin/env bash

set -Eeou pipefail

# Define variables
readonly dir="$(dirname "$0")"

# Usage or Help message
usage() {
  cat <<EOF >&2
Usage: $(basename "$0") OPTION...
Description:
Options:
  -v  Verbose
EOF
  exit 1
}

# Parse Options
verbose=""
id=""
debug=
while getopts h?v:id OPT; do
  case "${OPT}" in
    h|\?)
      usage
      exit 0 ;;
    v) verbose="${OPTARG}" ;;
    i) id="${OPTARG}" ;;
    d) debug=true ;;
    *) usage ;;
  esac
done

# Define Function
func1() {
  # check params, size, null, and exit 1 when needed

  # logic for-loop
  for projectName in "${projectNames[@]}" # array len, both ${#array[*]} and ${#array[@]} ok
  #  more array ${array[@]:position:length}, unset array
do
  func2 $projectName
  # test expressions, most common, for file(-a, -e, -d, -s), string (-n, -z), int(-eq, -lt), expr, [[]]
  if [ "verbose" = "1" ]; then
  # elif commandsl then
    echo -n . 1>&2
  else
    echo "xx"
  fi
done

# read files
# read -t timeout, -p prompt, -a array, -n number of chars, -e auto completion, -d, -s hide, etc.
# while also support test expressions
  while IFS= read -r -d '' FILE # IFS default is space(" "), IFS=":" to change it
do
  case $FILE in
    *) FILENAME=$(basename "$FILE")
      echo "processing file: $FILENAME"
      #handle file
      ;;
  esac
done < <(find "$DIRECTORY" -type f -name "*.yaml" -print0)

}

# Verify options len
if [ $# -lt 1 ]; then
  usage()
fi

# Invoke cmd directly
projectNames=$(gcloud projects list | grep name | cut -d' ' -f2)

# call logic
func1 id projectNames

# verify func1 result
if [ "$?" = "1"]; then
  echo "func1 failed"
  exit 1
fi

# Next
#
# most commonly used components include
# - Error Processing
# - Parameter Handling
# - Method Definition
# - Examples of if, for, switch, and other commands
#
# - How to avoid bash5 on mac issues? Simply use
# #!/usr/bin/env bach instead of !/bin/bash
#
# How to judge whether the parameter is followed by a
# value or is just a switch?
#Look for the : in while getopts “h?b:d:” OPT;.
#
# When are spaces required in the if structure?
# They are needed almost in between all [, param, flag, etc.
#
# Is Read only for reading files from a directory?
# No, it can also read user input.
#
# How to define variables, use variables, quote variables in strings?
#And how to get variables in the pass-in methods?
#The template covers most of them.
#
#### THINGS TO REMEMBER ####
#
# mktemp and trap
# mktemp creates temporary files, while trap deletes temporary files.
#
# Generally, we use mktemp to create temporary files when running the script.
# And trap is the corresponding operation to delete them after use, similar to defer in Go.
#
# The difference between declare, readonly, let
# We can define variables by all these three commands.
# Both readonly and declare can be used to declare read-only
# variables, while the latter offers more options, such as-x,
# which is equivalent to exporting environment variables.
#
# Variables defined by let are mutable and can perform arithmetic
# expressions and assign multiple variables on one line simultaneously.
#
$ let v1=13 v2=14
$ echo $v1
13
$ v1=15
$ echo $v1
15
#
# The difference between [], {}, (), (()), [[]]
# They are all used in pattern extension but in different scenarios.
# - [] indicates an in-range selection or a selection of multiple values,
#   which can be used in combination with !,^,?, etc., such as [a-zA-Z], [abc], [!0–9] etc.
#
# - {} expands to all the values in {}, and multiple {} can be nested
#   and combined. It also represents the range, which can also be in reverse order.
#
$ echo {a, b, c}
a b c
$ echo {j{p, pe}g, png}
jpg, jpeg, png
$ echo {3..1}
3 2 1
#
# - () is commonly used to nested execute other commands, similar to ``.
#
$ echo $(date)
#
# - (( )) only applies in arithmetic calculation expression.
#
$ echo (( 1 + 1 ))
2
#
# - [[]], can be replaced by [], so it is rarely used. [[:alpha:]]
#   and [a-zA-Z] have the same effect, with the latter clearer and more readable.
#
# Special Variables
$0 # Script file name.
$1~$9 # Correspond to the parameters, from the first one to the ninth.
$# # Total number of parameters.
$@ # All parameters, separated by spaces in between.
$* # All parameters, separated by the first character of the variable $IFS value. It is a space in default but can be customized.
$? # Exit status of the last command. Usually 0 or 1, exit 1 means an abnormal exit and exit 0 indicates success. Or last executed function return value.
$$ # Expand to the process ID of the shell.
$! # ID of the most recent executed process.
LINENO # Line number in the current script.
FUNCNAME # An array and index[0] is the current function.
BASH_SOURCE # An array and index[0] is the current script.
#
# There are other special variables in bash that are less commonly used. If you have an interest, you can enrich the list. But always picking up the familiar ones and testing them before use is a good way to keep from misuse.
#
# String ops
#
# String operation is a must for every language. For Bash, there’s no complicated
# APIs and functions, so you only need to be familiar with some special usages.
#
# Calculate length: ${#str}
# Get substring: ${str:1:3} #1 offset, 3 len; offset starts from 0 and offset can be -1
# Delete pattern match from head: ${str#pattern} # shortest match` or `${str##pattern} #longest match
# Delete pattern match from tail: ${str%pattern} and ${str%%pattern}
# Replace pattern match: ${str/pattern/replace} and ${str//pattern/replace}
# To uppercase: ${str^^}
# To lowercase: ${str,,}
#
# Again, string operations are too many to list them all.
#
# ENV Variables
#
# The most common env variables are,
BASHPID # ProcessID
BASHOPTS # Parameters
HOME # current user home directory
HOST # host port
IFS # delimiter, default is space
PS1 # Shell prompt
PWD # current working directory
USER # current user name
UID # current userid
SHELLOPTS # current set command params
#
# && and || between multiple commands
# When executing shell scripts, we often need to execute multiple
# commands continuously. No pipeline relationship in between though,
# there is logical continuity. Simply put, the success or failure of
# the previous command execution decides the next command’s execution.
# Judging by $? == 0 after each execution will be redundant, and we
# can use the && and || commands combination instead.
#
# - Cmd1 && Cmd2 means that Cmd2 can be executed only if Cmd1’s execution is successful.
# - Cmd1 || Cmd2 is the opposite, that is, Cmd2 can only be executed if Cmd1 fails.
#
# Set Command
# We usually start the shell scripts with the set command. It is almost impossible
# to memorize the entire command list, which is very long, but at least we can try
# to keep the commonly used one in mind.
#
# First, the must-have ones, an option of almost every qualified script, are as below.
#
# -e change the default behavior of bash of ignoring failure and continuing execution and terminates when an error occurs.
# -o pipefail, a supplement to -e, is what we add when -e fails in encountering pipeline,
# -E complement to -e, the latter causes trap’s incapability to catch the function’s errors.
# -u change bash’s default behavior of ignoring non-existing variables and report errors in time.
#
# Other commonly used ones
#
# -x output the executed command. It shows the executable command in advance with a + at the beginning of each line. Thus, when debugging a certain section of the program, you can just add set -x at the beginning and set +x at the end to view only the relevant commands.
# -n check the syntax without executing the command.
# -v print each line of input and turn off with +v.
#
# Lint
# In addition to the set command -n mentioned above, there are many open-source tools
# that we can adopt to check and format. I only list two of them here.
#
# ShellCheck, a syntax check tool.
#
# Install brew install shellcheck on mac, and test a script.
#
# Shfmt is a tool written in Go to format shell scripts.
# Installation: go get mvdan.cc/sh/v3/cmd/shfmt ( Go1.14+ required)
# Format: shfmt -l -w script.sh
#
# Shell Scripts plugin is available on Intellij, including the above two tools.
#
# Test and Debug
#
# Now I have excluded syntax issues. Generally speaking, testing shell scripts
# completely depends on the code logic, and we can basically make it through with set -x.
#
# If set -x is not enough, bash supports enabling the built-in debugger by extdebug
# option to debug the script step by step. You can take the if condition to embed
# this option into the code, avoiding repeated modification.
if [[ -v DEBUGGER ]]; then
  shopt -s extdebug
fi
#
# You can debug a script using$ DEBUGGER=1 bash script.sh from the command line.
#
# Bash Refereence Manual - https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters
# Set builtin - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# Shopt builtin - https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

