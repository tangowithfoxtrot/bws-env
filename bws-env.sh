#!/usr/bin/env bash
# This script was generated by bashly 1.0.7 (https://bashly.dannyb.co)
# Modifying it manually is not recommended

# :wrapper.bash3_bouncer
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
  printf "bash version 4 or higher is required\n" >&2
  exit 1
fi

# :command.master_script
# :command.root_command
root_command() {
  # src/root_command.sh
  # shellcheck disable=SC2154
  if [[ ${#other_args[@]} -eq 0 ]]; then
    ${0} --help
    exit 0
  fi

  # echo "# this file is located in 'src/root_command.sh'"
  # echo "# you can edit it freely and regenerate (it will not be overwritten)"
  # inspect_args
  # exit 0

  bws_command() {
    # shellcheck disable=SC2086
    # we want to split args
    bws "${@}" ${args[--project]:-}
  }

  if [[ -z "${BWS_ACCESS_TOKEN:-}" || -n "${args[--interactive]:-}" ]]; then
    read -r -s -p "Paste your access token: " BWS_ACCESS_TOKEN
    echo
    export BWS_ACCESS_TOKEN
  fi

  secrets_json=$(bws_command secret list | jq '[.[] | {key: .key, value: .value}]')

  for row in $(echo "${secrets_json}" | jq -r '.[] | @base64'); do
    _jq() {
      echo "${row}" | base64 --decode | jq -r "${1}"
    }

    key=$(_jq '.key')
    value=$(_jq '.value')

    export "${key}"="${value}"
  done

  # shellcheck disable=SC2154
  bash -c "${other_args[0]}"

}

# :command.version_command
version_command() {
  echo "$version"
}

# :command.usage
bws_env.sh_usage() {
  if [[ -n $long_usage ]]; then
    printf "bws-env.sh - Inject secrets from Bitwarden into a command.\n"
    echo

  else
    printf "bws-env.sh - Inject secrets from Bitwarden into a command.\n"
    echo

  fi

  printf "%s\n" "$(bold "Usage:")"
  printf "  bws-env.sh [OPTIONS] [COMMAND...]\n"
  printf "  bws-env.sh --help | -h\n"
  printf "  bws-env.sh --version | -v\n"
  echo

  # :command.long_usage
  if [[ -n $long_usage ]]; then
    printf "%s\n" "$(bold "Options:")"

    # :command.usage_flags
    # :flag.usage
    printf "  %s\n" "$(magenta "--interactive, -i")"
    printf "    Interactively supply a BWS_ACCESS_TOKEN\n"
    echo

    # :flag.usage
    printf "  %s\n" "$(magenta "--project, -p PROJECT")"
    printf "    Project ID to use for secrets\n"
    echo

    # :command.usage_fixed_flags
    printf "  %s\n" "$(magenta "--help, -h")"
    printf "    Show this help\n"
    echo
    printf "  %s\n" "$(magenta "--version, -v")"
    printf "    Show version number\n"
    echo

    # :command.usage_args
    printf "%s\n" "$(bold "Arguments:")"

    echo "  COMMAND..."
    printf "    The command to run with secrets injected\n"
    echo

    # :command.usage_environment_variables
    printf "%s\n" "$(bold "Environment Variables:")"

    # :environment_variable.usage
    printf "  %s\n" "$(cyan "BWS_ACCESS_TOKEN")"
    printf "    The access token used for Bitwarden Secrets Manager\n"
    echo

    # :command.usage_examples
    printf "%s\n" "$(bold "Examples:")"
    printf "  ${0##*/} --interactive 'echo \$SOME_VAR_FROM_BITWARDEN'\n"
    echo

  fi
}

# :command.normalize_input
normalize_input() {
  local arg flags

  while [[ $# -gt 0 ]]; do
    arg="$1"
    if [[ $arg =~ ^(--[a-zA-Z0-9_\-]+)=(.+)$ ]]; then
      input+=("${BASH_REMATCH[1]}")
      input+=("${BASH_REMATCH[2]}")
    elif [[ $arg =~ ^(-[a-zA-Z0-9])=(.+)$ ]]; then
      input+=("${BASH_REMATCH[1]}")
      input+=("${BASH_REMATCH[2]}")
    elif [[ $arg =~ ^-([a-zA-Z0-9][a-zA-Z0-9]+)$ ]]; then
      flags="${BASH_REMATCH[1]}"
      for ((i = 0; i < ${#flags}; i++)); do
        input+=("-${flags:i:1}")
      done
    else
      input+=("$arg")
    fi

    shift
  done
}
# :command.inspect_args
inspect_args() {
  if ((${#args[@]})); then
    readarray -t sorted_keys < <(printf '%s\n' "${!args[@]}" | sort)
    echo args:
    for k in "${sorted_keys[@]}"; do echo "- \${args[$k]} = ${args[$k]}"; done
  else
    echo args: none
  fi

  if ((${#other_args[@]})); then
    echo
    echo other_args:
    echo "- \${other_args[*]} = ${other_args[*]}"
    for i in "${!other_args[@]}"; do
      echo "- \${other_args[$i]} = ${other_args[$i]}"
    done
  fi

  if ((${#deps[@]})); then
    readarray -t sorted_keys < <(printf '%s\n' "${!deps[@]}" | sort)
    echo
    echo deps:
    for k in "${sorted_keys[@]}"; do echo "- \${deps[$k]} = ${deps[$k]}"; done
  fi

}

# :command.user_lib
# src/lib/colors.sh
print_in_color() {
  local color="$1"
  shift
  if [[ -z ${NO_COLOR+x} ]]; then
    printf "$color%b\e[0m\n" "$*"
  else
    printf "%b\n" "$*"
  fi
}

red() { print_in_color "\e[31m" "$*"; }
green() { print_in_color "\e[32m" "$*"; }
yellow() { print_in_color "\e[33m" "$*"; }
blue() { print_in_color "\e[34m" "$*"; }
magenta() { print_in_color "\e[35m" "$*"; }
cyan() { print_in_color "\e[36m" "$*"; }
bold() { print_in_color "\e[1m" "$*"; }
underlined() { print_in_color "\e[4m" "$*"; }
red_bold() { print_in_color "\e[1;31m" "$*"; }
green_bold() { print_in_color "\e[1;32m" "$*"; }
yellow_bold() { print_in_color "\e[1;33m" "$*"; }
blue_bold() { print_in_color "\e[1;34m" "$*"; }
magenta_bold() { print_in_color "\e[1;35m" "$*"; }
cyan_bold() { print_in_color "\e[1;36m" "$*"; }
red_underlined() { print_in_color "\e[4;31m" "$*"; }
green_underlined() { print_in_color "\e[4;32m" "$*"; }
yellow_underlined() { print_in_color "\e[4;33m" "$*"; }
blue_underlined() { print_in_color "\e[4;34m" "$*"; }
magenta_underlined() { print_in_color "\e[4;35m" "$*"; }
cyan_underlined() { print_in_color "\e[4;36m" "$*"; }

# :command.command_functions

# :command.parse_requirements
parse_requirements() {
  # :command.fixed_flags_filter
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      --version | -v)
        version_command
        exit
        ;;

      --help | -h)
        long_usage=yes
        bws_env.sh_usage
        exit
        ;;

      *)
        break
        ;;

    esac
  done

  # :command.dependencies_filter
  if command -v bws >/dev/null 2>&1; then
    deps['bws']="$(command -v bws | head -n1)"
  else
    printf "missing dependency: bws\n" >&2
    printf "%s\n" "https://github.com/bitwarden/sdk/releases/latest" >&2
    exit 1
  fi

  if command -v jq >/dev/null 2>&1; then
    deps['jq']="$(command -v jq | head -n1)"
  else
    printf "missing dependency: jq\n" >&2
    printf "%s\n" "https://command-not-found.com/jq" >&2
    exit 1
  fi

  # :command.command_filter
  action="root"

  # :command.parse_requirements_while
  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      # :flag.case
      --interactive | -i)

        # :flag.case_no_arg
        args['--interactive']=1
        shift
        ;;

      # :flag.case
      --project | -p)

        # :flag.case_arg
        if [[ -n ${2+x} ]]; then

          args['--project']="$2"
          shift
          shift
        else
          printf "%s\n" "--project requires an argument: --project, -p PROJECT" >&2
          exit 1
        fi
        ;;

      --)
        shift
        other_args+=("$@")
        break
        ;;

      -?*)
        other_args+=("$1")
        shift
        ;;

      *)
        # :command.parse_requirements_case
        # :command.parse_requirements_case_catch_all
        other_args+=("$1")
        shift

        ;;

    esac
  done

}

# :command.initialize
initialize() {
  version="0.1.0"
  long_usage=''
  set -e

}

# :command.run
run() {
  declare -A args=()
  declare -A deps=()
  declare -a other_args=()
  declare -a input=()
  normalize_input "$@"
  parse_requirements "${input[@]}"

  case "$action" in
    "root") root_command ;;
  esac
}

initialize
run "$@"
