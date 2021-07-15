#!/bin/bash --login

set -exo pipefail

rm -rf $PWD/env
mkdir -p $PWD/env

#spack view --verbose symlink $PWD/env gotcha argobots mercury mochi-margo spath openssl
mkdir -p $PWD/env/bin
mkdir -p $PWD/env/lib
mkdir -p $PWD/env/lib64
mkdir -p $PWD/env/include

ln -s /g/g92/xu23/apps/GOTCHA-1.0.3/lib64/* $PWD/env/lib64
ln -s /g/g92/xu23/apps/GOTCHA-1.0.3/include/* $PWD/env/include

export PATH=$PWD/env/bin:$PATH
export LDFLAGS="-L$PWD/env/lib -L$PWD/env/lib64"
export CFLAGS="-I$PWD/env/include -g -O0"
export CXXFLAGS=$CFLAGS
export PKG_CONFIG_PATH=$PWD/env/lib/pkgconfig:$PKG_CONFIG_PATH
