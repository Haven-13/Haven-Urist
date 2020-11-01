#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

mkdir -p $HOME/.byond/bin
wget -O $HOME/.byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x $HOME/.byond/bin/librust_g.so
ldd $HOME/.byond/bin/librust_g.so