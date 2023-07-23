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
