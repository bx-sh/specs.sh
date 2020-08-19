#! /usr/bin/env installer

install() {
  echo "🔬 [spec.sh]"
  echo
  printf "Checking for latest version... "
  local latestReleaseInfoUrl="https://api.github.com/repos/bx-sh/spec.sh/releases/latest"
  local downloadUrl="$( curl -s "$latestReleaseInfoUrl" | grep tarball | awk '{print $2}' | sed 's/[",]//g' )"
  [ $? -ne 0 ] && { echo -e "\nFailed to get latest release version of spec.sh ($latestReleaseInfoUrl)"; return 1; }
  local latestVersion="${downloadUrl/*\/}"
  echo "$latestVersion"
  echo
  printf "Downloading... "
  local workingDirectory="$( pwd )"
  local tempDirectory="$( mktemp -d )"
  cd "$tempDirectory"
  curl -O "$downloadUrl" &>/dev/null
  [ ! -f latest.tar.gz ] && { echo "Failed to download: $downloadUrl"; return 1; }
  tar zxvf latest.tar.gz &>/dev/null
  [ ! -f spec.sh ] && { echo "Failed to extract latest.tar.gz: $tempDirectory/latest.tar.gz"; return 1; }
  local specVersion="$( grep "SPEC_VERSION=" spec.sh | sed 's/SPEC_VERSION=//' )"
  printf "spec.sh version $specVersion downloaded.\n"
  echo
  cp spec.sh "$workingDirectory/spec.sh"
  cp spec-full.sh "$workingDirectory/spec-full.sh"
  cd "$workingDirectory"
  chmod +x spec.sh
  chmod +x spec-full.sh
  rm -r "$tempDirectory"
  echo "Downloaded latest versions of:
- spec.sh
- spec-full.sh

If you intend to use \`expect\`, \`assert\`, or \`run\`
then you can delete \`spec.sh\` and replace it with \`spec-full.sh\`

If you don't want to use these libraries, you can delete \`spec-full.sh\`

Enjoy!

Printing the \`spec.sh\` usage documentation:
"
  ./spec.sh --help
}

install