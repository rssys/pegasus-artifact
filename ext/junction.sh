#!/bin/bash
git clone https://github.com/JunctionOS/junction.git
cd junction
scripts/install.sh
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=nightly
. "$HOME/.cargo/env" 
scripts/build.sh
sudo cp build/junction/junction_run /usr/local/bin/
cd ..
