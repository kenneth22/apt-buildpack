#!/bin/bash
set -euo pipefail

GO_VERSION="1.9.1"

export GoInstallDir="/tmp/go$GO_VERSION"
mkdir -p $GoInstallDir

if [ ! -f $GoInstallDir/go/bin/go ]; then
  GO_MD5="0571886e9b9ba07773b542a11e9859a4"
  URL=https://buildpacks.cloudfoundry.org/dependencies/go/go${GO_VERSION}.linux-amd64-${GO_MD5:0:8}.tar.gz

  echo "-----> Download go ${GO_VERSION}"
  echo $URL
  curl -s -L -v --retry 15 --retry-delay 2 $URL -o /tmp/go.tar.gz --resolve buildpacks.cloudfoundry.org:443:54.230.211.108
  echo "download step done"
  DOWNLOAD_MD5=$(md5sum /tmp/go.tar.gz | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_MD5 != $GO_MD5 ]]; then
    echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $GO_MD5"
    exit 1
  fi
  echo "EXTR2 $GoInstallDir"
  tar xzf /tmp/go.tar.gz -C $GoInstallDir
  rm /tmp/go.tar.gz
  echo "EXTR1"
fi
if [ ! -f $GoInstallDir/go/bin/go ]; then
  echo "       **ERROR** Could not download go"
  exit 1
else 
  echo "Downloaded go $GO_VERSION"
fi

