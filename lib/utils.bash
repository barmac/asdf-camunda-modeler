#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for modeler.
GH_REPO="https://github.com/camunda/camunda-modeler"
TOOL_NAME="modeler"
TOOL_TEST=""

NIGHTLY_LOCATION="https://downloads.camunda.cloud/release/camunda-modeler/nightly"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

platform() {
  local os
  local platform

  os=$(uname -s)
  case "$os" in
  Darwin)
    platform="mac"
    ;;
  Linux)
    platform="linux"
    ;;
  *)
    fail "Unknown OS: $os"
    ;;
  esac

  echo "$platform"
}

file_name() {
  local version="$1"
  local platform_name="$(platform)"

  case "$platform_name" in
  mac)
    echo "camunda-modeler-$version-mac.zip"
    ;;
  linux)
    echo "camunda-modeler-$version-linux-x64.tar.gz"
    ;;
  *)
    fail "Unknown platform: $platform_name"
    ;;
  esac
}

executable() {
  local platform_name="$(platform)"

  case "$platform_name" in
  mac)
    echo "Contents/MacOS/Camunda Modeler"
    ;;
  linux)
    echo "camunda-modeler"
    ;;
  *)
    fail "Unknown platform: $platform_name"
    ;;
  esac

}

curl_opts=(-f#SL)

# NOTE: You might want to remove this if modeler is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sort -V |    # Sort versions
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # List the tag names from GitHub releases.
  echo $(list_github_tags) nightly
}

get_download_url() {
  local version artifact_name url
  version="$1"
  artifact_name="$(file_name $version)"

  case "$version" in
  nightly)
    url="$NIGHTLY_LOCATION/$artifact_name"
    ;;
  *)
    url="$GH_REPO/releases/download/v$version/$artifact_name"
    ;;
  esac

  echo $url
}

download_release() {
  local version filename url artifact_name
  version="$1"
  filename="$2"

  url=$(get_download_url $version)

  echo "* Downloading $TOOL_NAME $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"
  local executable_path="$(executable)"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    test -x "$install_path/$executable_path" || fail "Expected $install_path/$executable_path to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
