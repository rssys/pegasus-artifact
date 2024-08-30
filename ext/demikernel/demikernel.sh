#!/bin/bash
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=nightly
rm -rf demikernel dpdk-rs
git clone https://github.com/microsoft/demikernel.git
cd demikernel
git checkout ea7449f8b9d1c596a52ad5d50814de5726851214
cp -rf dpdk-rs ../
git checkout 00e577ce56145fef6647d50a3ac6509adc5308e3
mv ../dpdk-rs ./
sed -i -e 's*dpdk-rs = { git = "https://github.com/demikernel/dpdk-rs", rev = "5a339766b6f64c2b09c2e4089c62013bfb48297e", optional = true }*dpdk-rs = { path = "dpdk-rs", optional = true }*g' Cargo.toml
sed -i '/trace!("connection established ({:?})", self_.sockaddr);/d' src/rust/catnap/futures/connect.rs
echo "nightly-2023-12-07" > rust-toolchain
make LIBOS=catnip all-libs
sudo cp -rf include/demi/ /usr/local/include/
sudo cp target/release/libdemikernel.so /usr/local/lib/
cd ..
cd redis-demikernel
make distclean
cd deps/jemalloc
./autogen.sh
cd ../../
make
sudo cp src/redis-server /usr/local/bin/redis-server-demikernel
