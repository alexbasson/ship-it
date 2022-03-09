#!/usr/bin/env bash

function set_bash_fail_on_error() {
    set -o errexit
    set -o errtrace
    set -o nounset
    set -o pipefail
}

function go_to_root_directory() {
    root_directory=$(git rev-parse --show-toplevel)
    cd "$root_directory"
}

function fail_for_unstaged_files() {
    local -r unstaged_files_count=$(git status --porcelain | wc -l)
    local -r trimmed_unstaged_files_count=$(echo -e -n "$unstaged_files_count" | tr -d ' ')
    if [ "$trimmed_unstaged_files_count" != "0" ]; then
        local -r unstaged_files=$(git status --porcelain)
        local -r RED_COLOR_CODE='\033[0;31m'
        echo -e "${RED_COLOR_CODE}\\nERROR!\\nUnstaged and/or uncommitted files found! 😱\\nPlease clean these up and try again:\\n${unstaged_files}"
        return 1
    fi
}

function check_scripts() {
    shellcheck scripts/*.sh
}

function build_and_test() {
  echo "build and test"
}

function shut_down_app() {
    # shellcheck disable=SC2046
    kill $(lsof -t -i :8080)
}

function push_code() {
    git push
}

function display_ascii_success_message() {
    local -r green_color_code='\033[1;32m'
    echo -e "${green_color_code}\\n$(cat scripts/success_ascii_art.txt)"
}

function main() {
    set_bash_fail_on_error
    go_to_root_directory
    check_scripts
    build_and_test
    fail_for_unstaged_files
    push_code
    display_ascii_success_message
}

main "$@"
