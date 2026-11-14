#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/camunda/camunda-modeler"
TOOL_NAME="modeler"
TOOL_TEST=""

NIGHTLY_LOCATION="https://downloads.camunda.cloud/release/camunda-modeler/nightly"

# after this version links use architecture in name
MACOS_OLD_ARCH_VERSION="5.22.0"

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
  MINGW* | MSYS* | CYGWIN*)
    platform="windows"
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
    echo $(mac_file_name $version)
    ;;
  linux)
    echo "camunda-modeler-$version-linux-x64.tar.gz"
    ;;
  windows)
    echo "camunda-modeler-$version-win-x64.zip"
    ;;
  *)
    fail "Unknown platform: $platform_name"
    ;;
  esac
}

mac_file_name() {
  local version="$1"

  # handle pre-arm links
  if [[ "$version" != "nightly" && $(semver_compare "$version" "$MACOS_OLD_ARCH_VERSION") != "gt" ]]; then
    echo "camunda-modeler-$version-mac.zip"
    return
  fi

  case "$(arch)" in
  arm64)
    echo "camunda-modeler-$version-mac-arm64.zip"
    ;;
  *)
    echo "camunda-modeler-$version-mac-x64.zip"
    ;;
  esac
}

semver_compare() {
  local IFS=.
  local i version1=($1) version2=($2)

  for ((i = 1; i <= ${#version1[@]}; i++)); do
    if ((${version1[i]} < ${version2[i]})); then
      echo "lt"
      return
    elif ((${version1[i]} > ${version2[i]})); then
      echo "gt"
      return
    fi
  done
  echo "eq"
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
  windows)
    echo "Camunda Modeler.exe"
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
  curl "${curl_opts[@]}" -s --compressed "https://api.github.com/repos/camunda/camunda-modeler/releases?per_page=100" |
    grep '"tag_name":' |
    sed -E 's/.*"tag_name": "v?([^"]+)".*/\1/' |
    sort -V
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

download_and_extract() {
  local version download_path url release_file
  version="$1"
  download_path="$2"

  case "$(platform)" in
  linux)
    url=$(get_download_url "$version")

    echo "* Downloading $TOOL_NAME $version..."
    curl "${curl_opts[@]}" "$url" |
      tar -xzf - -C "$download_path" --strip-components=1 ||
      fail "Could not download and extract $url"
    ;;
  windows)
    release_file="$download_path/$TOOL_NAME-$version.zip"

    download_release "$version" "$release_file"
    extract_windows_zip "$release_file" "$download_path" || fail "Could not extract $release_file"
    rm "$release_file"
    ;;
  *)
    # zip cannot be safely extracted from a stream
    release_file="$download_path/$TOOL_NAME-$version.zip"

    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$download_path" --strip-components=1 || fail "Could not extract $release_file"
    rm "$release_file"
    ;;
  esac
}

extract_windows_zip() {
  local archive="$1"
  local destination="$2"

  # Windows archive has no top-level directory, extract as is
  if command -v unzip >/dev/null 2>&1; then
    unzip -q -o "$archive" -d "$destination"
  elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -NonInteractive -Command \
      "Expand-Archive -Force -LiteralPath '$(windows_path "$archive")' -DestinationPath '$(windows_path "$destination")'"
  else
    fail "Either unzip or powershell.exe is required to extract $archive"
  fi

  # zip carries no POSIX permissions; make sure the executable is marked as such
  chmod +x "$destination/$(executable)"
}

windows_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$1"
  else
    echo "$1"
  fi
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
    rm -r "$install_path"
    mv "$ASDF_DOWNLOAD_PATH" "$install_path" || fail "Failed to copy from $ASDF_DOWNLOAD_PATH to $install_path."

    test -x "$install_path/$executable_path" || fail "Expected $install_path/$executable_path to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
