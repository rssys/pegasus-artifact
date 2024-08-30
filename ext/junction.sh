#!/bin/bash
rm -rf junction
git clone https://github.com/JunctionOS/junction.git
cd junction
scripts/install.sh
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=nightly
scripts/build.sh
sudo cp build/junction/junction_run /usr/local/bin/
cd ..
cp libssl.so.1.1 libcrypto.so.1.1 junction/lib/glibc/build/
