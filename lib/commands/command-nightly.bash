#!/usr/bin/env bash

set -euo pipefail

current_script_path=${BASH_SOURCE[0]}
plugin_dir=$(dirname "$(dirname "$current_script_path")")

# shellcheck source=../lib/utils.bash
source "${plugin_dir}/utils.bash"

uninstall() {
  asdf uninstall camunda-modeler nightly
}

install() {
  asdf install camunda-modeler nightly
}

get_installation() {
  local installation
  installation="$(asdf where camunda-modeler nightly)"

  if [ $? == 0 ]; then
    echo "$installation/$(executable)"
  else
    echo "failed"
  fi
}

installation=$(get_installation)

if [ $installation == "failed" ]; then
  echo "* No nightly installation found; installing..."
  install
elif [ $(expr $(date +%s) - $(date -r $installation +%s)) -gt 86400 ]; then
  echo "* Outdated nightly found; reinstalling..."
  uninstall
  install
fi

ASDF_CAMUNDA_MODELER_VERSION=nightly asdf camunda-modeler "$*"
