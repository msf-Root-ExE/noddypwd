#!/bin/bash

# ASCII Art and Authorship
echo "__________                  __  ___________        ___________"
echo "\\______   \\  ____    ____ _/  |_\\_   _____/___  ___\\_   _____/"
echo " |       _/ /  _ \\  /  _ \\   __\\|    __)_ \\  \\/  / |    __)_ "
echo " |    |   \\(  <_> )(  <_> )|  |  |        \\ >    <  |        \\"
echo " |____|_  / \\____/  \\____/ |__| /_______  //__/\\_ \\/_______  /"
echo "        \\/                              \\/       \\/        \\/"
echo ""
echo "# Author: Ross Brereton (https://www.linkedin.com/in/ross-b-673872107/)"
echo "# Website: https://github.com/msf-Root-ExE"
echo ""

declare -A replacements=( ["a"]="@" ["e"]="3" ["o"]="0" ["i"]="!" ["s"]="5" ["t"]="$" ["g"]="9" ["z"]="2" 
                          ["A"]="@" ["E"]="3" ["O"]="0" ["I"]="!" ["S"]="5" ["T"]="$" ["G"]="9" ["Z"]="2" )

declare -A seen_passwords=()

recursive_replacements() {
    local pass="$1"
    local index="$2"

    if [[ $index -ge ${#pass} ]]; then
        print_unique "$pass"
        return
    fi

    local char="${pass:$index:1}"
    if [[ ${replacements[$char]} ]]; then
        local before="${pass:0:$index}"
        local after="${pass:$((index+1))}"
        
        # without replacement
        recursive_replacements "$pass" $((index+1))
        # with replacement
        recursive_replacements "${before}${replacements[$char]}${after}" $((index+1))
    else
        recursive_replacements "$pass" $((index+1))
    fi
}

print_unique() {
    if [[ ! ${seen_passwords[$1]} ]]; then
        echo "$1"
        if [[ ! "$1" =~ [0-9]$ ]]; then
            echo "${1}1"
        fi
        echo "${1}!"
        echo "${1}1!"
        echo "${1}1@"
        echo "${1}@"
        seen_passwords["$1"]=1
    fi
}

generate_passwords() {
    local pass="$1"
    
    # Basic password variations
    print_unique "$pass"
    print_unique "${pass^}"

    # Recursive replacements for each variation
    recursive_replacements "$pass" 0
    recursive_replacements "${pass^}" 0
}

print_usage() {
    echo "Usage: $0 [-h] [-p password]"
    echo "Options:"
    echo "  -h               Display this help message."
    echo "  -p password      Provide the base password for which variations should be generated."
}

while getopts ":hp:" opt; do
    case $opt in
        h)
            print_usage
            exit 0
            ;;
        p)
            password="$OPTARG"
            generate_passwords "$password"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            print_usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            print_usage
            exit 1
            ;;
    esac
done

# If no options are provided
if [ $OPTIND -eq 1 ]; then
    print_usage
    exit 1
fi
