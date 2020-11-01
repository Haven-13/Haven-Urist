#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

mkdir -p $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin
wget -O $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/librust_g.so
ldd $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/librust_g.so