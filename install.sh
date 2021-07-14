#!/bin/bash --login

set -exo pipefail

rm -rf $PWD/env
mkdir -p $PWD/env

spack view --verbose symlink $PWD/env gotcha argobots mercury mochi-margo spath openssl

export PATH=$PWD/env/bin:$PATH
export LDFLAGS=-L$PWD/env/lib
export CFLAGS="-I$PWD/env/include -g -O0"
export CXXFLAGS=$CFLAGS
export PKG_CONFIG_PATH=$PWD/env/lib/pkgconfig:$PKG_CONFIG_PATH