#! /usr/bin/env installer

install() {
  echo "🔬 [specs.sh]"
  echo
  printf "Checking for latest version... "
  local latestReleaseInfoUrl="https://api.github.com/repos/bx-sh/specs.sh/releases/latest"
  local downloadUrl="$( curl -s "$latestReleaseInfoUrl" | grep tarball | awk '{print $2}' | sed 's/[",]//g' )"
  [ $? -ne 0 ] && { echo -e "\nFailed to get latest release version of specs.sh ($latestReleaseInfoUrl)"; return 1; }
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
  [ ! -f specs.sh ] && { echo "Failed to extract latest.tar.gz: $tempDirectory/latest.tar.gz"; return 1; }
  local specVersion="$( grep "SPEC_VERSION=" specs.sh | sed 's/SPEC_VERSION=//' )"
  printf "specs.sh version $specVersion downloaded.\n"
  echo
  cp specs.sh "$workingDirectory/specs.sh"
  cp specs-full.sh "$workingDirectory/specs-full.sh"
  cd "$workingDirectory"
  chmod +x specs.sh
  chmod +x specs-full.sh
  rm -r "$tempDirectory"
  echo "Downloaded latest versions of:
- specs.sh
- specs-full.sh

If you intend to use \`expect\`, \`assert\`, or \`run\`
then you can delete \`specs.sh\` and replace it with \`specs-full.sh\`

If you don't want to use these libraries, you can delete \`specs-full.sh\`

Enjoy!

Printing the \`specs.sh\` usage documentation:
"
  ./specs.sh --help
}

install