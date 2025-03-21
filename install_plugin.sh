#!/bin/sh -e

# Copied w/ love from the excellent hypnoglow/helm-s3

version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Downloading and installing helm-docs v${version} ..."

url=""

arch=""
case $(uname -m) in
  x86_64)
    arch="x86_64"
    ;;
  armv6*)
    arch="arm6"
    ;;
  # match every arm processor version like armv7h, armv7l and so on.
  armv7*)
    arch="arm7"
    ;;
  aarch64 | arm64)
    arch="arm64"
    ;;
  *)
    echo "Failed to detect target architecture"
    exit 1
    ;;
esac


if [ "$(uname)" = "Darwin" ]; then
    url="https://github.com/norwoodj/helm-docs/releases/download/v${version}/helm-docs_${version}_Darwin_${arch}.tar.gz"
elif [ "$(uname)" = "Linux" ] ; then
    url="https://github.com/norwoodj/helm-docs/releases/download/v${version}/helm-docs_${version}_Linux_${arch}.tar.gz"
else
    url="https://github.com/norwoodj/helm-docs/releases/download/v${version}/helm-docs_${version}_Windows_${arch}.tar.gz"
fi

echo $url

mkdir -p "bin"
mkdir -p "releases/v${version}"

# Download with curl if possible.
if [ -x "$(which curl 2>/dev/null)" ]; then
    curl -sSL "${url}" -o "releases/v${version}.tar.gz"
else
    wget -q "${url}" -O "releases/v${version}.tar.gz"
fi
tar xzf "releases/v${version}.tar.gz" -C "releases/v${version}"
mv "releases/v${version}/helm-docs" "bin/helm-chart-docs" || \
    mv "releases/v${version}/helm-docs.exe" "bin/helm-chart-docs"
