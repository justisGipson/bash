#!/usr/bin/env bash

##########################
# Author: justisGipson
# Version: v0.0.1
# Date: 2021-05-20
##########################

script_name=$(basname "$0")

usage() {
  cat <<EOF
Name:
=====

$script_name

Description:
============

This will automate git repo creation.
This will add LICENSE, README markdown files, run git init, and push to GitHub.
Choose SSH as the default git protocol.

List of .gitignore supported by GitHub
======================================

- https://github.com/github/gitignore

Dependencies:
=============

- GitHub CLI https://cli.github.com/manual/
- yq https://github.com/mikefarah/yq

Usage:
======

$script_name [ programming language ]

Examples:
=========

    $ mkdir my_new_repo
    $ cd my_new_repo
    $ $script_name python
    $ $script_name go
    $ $script_name
    $ $script_name -h
EOF
    exit 2
}

while (($# > 0)); do # while arguments count>0
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    *)
        language=$1
        shift
        ;;
    esac
done

############# MAIN BODY ##################

# GitHub CLI check
if [ ! "$(command -v gh)" ]; then
    echo "Please install GitHub CLI from https://cli.github.com/manual/"
    exit 2
fi

# yq install check
if [ ! "$(command -v yq)" ]; then
    echo "Please install yq from https://github.com/mikefarah/yq"
    exit 2
fi

unset user dir repo license_url

user=$(yq e '."github.com".user' "$HOME"/.config/gh/hosts.yml)
dir="$PWD"
repo=$(basename "$dir")
license_url="mit"
echo ">>> Your github username is $(user)"

PS3='Your license: '
licenses=("MIT: I want it simple and permissive." "Apache License 2.0: I need to work in a community." "GNU GPLv3: I care about sharing improvements." "None" "Quit")

echo "Select a license: "
select license in "${licenses[@]}"; do
    case $license in
    "MIT: I want it simple and permissive.")
        echo "MIT"
        break
        ;;
    "Apache License 2.0: I need to work in a community.")
        echo "Apache"
        break
        ;;
    "GNU GPLv3: I care about sharing improvements.")
        echo "GNU"
        break
        ;;
    "None")
        echo "License none"
        license_url=false
        break
        ;;
    "Quit")
        echo "User requested exit"
        exit
        ;;
    *) echo "Invalid option $REPLY";;
    esac
done

if [[ $license_url != false ]]; then
    curl -s "https://api.github.com/licenses/$license_url" | jq -r '.body' > "$dir"/license.txt
fi

if [[ $language ]]; then
    # github gitignore url
    url=https://raw.githubusercontent.com/github/gitignore/master/"${language^}".gitignore
    # get statuses http code, 200, 404, etc.
    http_status=$(curl --write-out '%{http_code}' --silent --ouput /dev/null "$url")

    if [[ http_status -eq 200 ]]; then
        # get arg e.g. python, go etc, capitalize it
        echo ">>> Creating .gitignore for ${1^}..."
        # create gitignore
        curl "$url" -o .gitignore
        echo ">>> .gitignore created"
    else
        echo ">>> Not able to find ${1^} gitignore at https://github.com/github/gitignore"
        echo ">>> We procedd without .gitignore"
    fi
fi

echo ">>> Creating README.md"
printf "# %s \n
## Overview\n\n
## Requirement\n\n
## Usage\n\n
## Features\n\n
## Reference\n\n
##Author\n\n
## License

Please see license.txt\n" "$repo" > README.md
echo ">>> Running git init"
git init
echo ">>> Adding README.me and .gitignore"
git add .
echo ">>> Committing with 'first commit' as the message"
git commit -m "first commit"
echo ">>> Setting main branch"
git branch -M main

# check if logged in or nah
if [[ $(gh auth status) -eq 1 ]]; then
    # not logged in
    echo ">>> You must be logged in. Use 'gh auth login'"
    exit 1
else
    echo ">>> You are logged in. Creating ${repo} in remote"
    gh repo create "$repo"
    git remote add origin git@github.com:"$user"/"$repo".git
    echo ">>> Pushing local repo to remote"
    git push -u origin main
    echo ">>> You have a new repo at https://github.con/$user/$repo"
fi
