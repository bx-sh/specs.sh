#! /usr/bin/env installer

downloadUrl="https://github.com/bx-sh/spec.sh/archive/latest.tar.gz"

install() {
  echo "🔬 [spec.sh]"
  echo
  printf "Downloading latest version... "
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