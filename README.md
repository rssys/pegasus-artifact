# Pegasus Artifact
This repository contains the artifacts for the paper
*Pegasus: Transparent and Unified Kernel-Bypass Networking for
Fast Local and Remote Communication*.
Pegasus is a framework for transparent kernel bypass for
local and remote communication.

There are three branches: `master` that contains this documentation,
`server` and `client` that contain the scripts for the environment setup.

## Structure of the Artifacts
The artifacts require two machines, which we refer as node0 and node1.
After the [environment setup](#environment-setup) described below,
node0 contains the following contents:
`/data/setup` and `/data/deps` contain the scripts for setup and building,
and the built denpendencies. `/data/src` contains the source code of Pegasus.
`/data/ext` contains the build script and the built artifacts of comparison systems.
`/data/experiments` contains the server-side
script and configuration for the experiments. `/data/docker` contains the scripts
to build the containers used in the experiments.
These contents are built from the `server` branch of this repository.

node1 contains the following contents:
`/data/setup` and `/data/ext` are similar to the ones on node0.
`/data/experiments` contains the client-side
scripts and configuration for the experiments.
These contents are built from the `client` branch of this repository.

The source code of Pegasus and its dependencies (uSwitch and F-Stack)
is available in the following repositories:
<https://github.com/rssys/pegasus>,
<https://github.com/rssys/uswitch-kernel>, and
<https://github.com/rssys/f-stack>.
## Environment Setup
To run the experiments in the paper, two servers with the following hardware
are required: a CPU with MPK support (Intel Xeon Skylake or later,
or AMD EPYC Zen 3 or later), a NIC of Mellanox Connect-X 5 or later.
Also, the two servers are connected via two additional NICs for control.
We recommend
using the Cloudlab profile provided by us, with the physical node type `r6525`.
### Using Pre-built Cloudlab Profile (Recommended)
Start a Cloudlab experiment with the following profile:
<https://www.cloudlab.us/p/6fa2ef5e5b44c20a2d45dd80e53aee0c5bd3103a>.
When asked for a physical node type, please type `r6525`. There will be
two machines created, one as the server (node0) and one as the client (node1).

After the machines start, first log in to node1, and execute the following
command to create a SSH key to access node0:

```shell
ssh-keygen
```

Then add the public key `~/.ssh/id_rsa.pub` to node0's `~/.ssh/authorized_keys`.
After that, if the uid of your user is not `20002`, set the owner of `/data`
to your user by running the following command on both node0 and node1:

```shell
sudo chown -R $(id -u):$(id -g) /data
```

Edit node1's `/data/env.sh` to set the environment variables.
The following variables must be edited accordingly: `PEGASUS_MAC_SERVER` as
node0's MAC address for the interface `enp129s0f0np0`, `PEGASUS_MAC_CLIENT` as
node1's MAC address for the interface of the same name, and
`PEGASUS_IP_SERVER_CONTROL` as node0's IP address for the interface
`eno12399np0`(`enp129s0f0np0` is the Mellanox Connect-X 6 NIC,
and `eno12399np0` is another NIC for the control plane).
These addresses can be obtained from the `ip a` command.

Then run the following command on node1:

```shell
source /data/env.sh
scp /data/env.sh $PEGASUS_IP_SERVER_CONTROL:/data/env.sh
cd /data/setup
./setup_config.sh
```

and run the following commands on node0:

```shell
source /data/env.sh
cd /data/setup
./setup_user.sh
./setup_config.sh
```

then reboot both node0 and node1.
### Build From Scratch (Alternative)
To build from scratch, two machines newly installed with Ubuntu 22.04
are required. We refer them as node0 and node1. You should be able to
access them with `sudo` permission without having to type the password.
We recommend using Cloudlab's `r6525` nodes.

On node0, run the following commands:

```shell
sudo mkdir /data
sudo chown $(id -u):$(id -g) /data
cd /data
git clone -b server https://github.com/rssys/pegasus-artifact.git .
```

On node1, run the following commands:

```shell
sudo mkdir /data
sudo chown $(id -u):$(id -g) /data
cd /data
git clone -b client https://github.com/rssys/pegasus-artifact.git .
```

On node0, edit `/data/env.sh` as follows: `PEGASUS_K8S_NODE`
as the hostname of node0,
`PEGASUS_IP_SERVER` as the IP address of the Mellanox NIC on node0,
`PEGASUS_IP_CLIENT` as the IP address of the Mellanox NIC on node1,
`PEGASUS_PCI_SERVER` as the PCI address of the Mellanox NIC on node0
(as shown `lspci`),
`PEGASUS_PCI_CLIENT` as the PCI address of the Mellanox NIC on node1,
`PEGASUS_IP_SERVER_CONTROL` as the IP address of the other NIC on node0,
`PEGASUS_MAC_SERVER` as the MAC address of the Mellanox NIC on node0,
`PEGASUS_MAC_CLIENT` as the MAC address of the Mellanox NIC on node1.

Then run the following commands on node0:

```shell
cd /data
source env.sh
cd setup
./setup_server.sh
```

It will install all the required software, including the pre-built uSwitch kernel.
You can alternatively build your own kernel from <https://github.com/rssys/uswitch-kernel>.

On node1, set up the SSH key as mentioned above. Then, reboot node0.
After rebooting, run the following commands on node0:

```shell
cd /data/deps
./build.sh
cd ../ext
./ext.sh
cd ../src
./build.sh
```

After that, use `scp` on node1 to copy `/data/env.sh` from node0 to node1, 
and run the following commands on node1:
```shell
cd /data
source env.sh
cd setup
./setup_client.sh
```

Reboot node1, and run the following commands after that:
```shell
cd /data/ext
./ext.sh
```

## Minimal Working Example of Pegasus
On node0, use the following command to start a Pegasus instance:

```shell
cd /data/src
sudo pegasus pegasus-example.conf
```

Start another terminal, and run the following command on node0:

```shell
sudo docker run -it --rm --runtime pegasus debian:bookworm /bin/echo hello
```

The terminal should print `hello`.

## Experiments
### Key Results

The paper has the following key results:

* Table 1: Latency for synchronization primitives and local protocol opereations.
* Figure 2: Web application and HTTP API with the Istio service mesh latency and throughput
* Figure 3: Throughput of the HTTP server with different percentages of proxied requests.
* Table 3: TCP echo server latency with different systems.
* Figure 4: Latency composition of TCP echo server with Pegasus.
* Figure 5: Latency and throughput of Redis.
* Figure 6: Latency and throughput of Nginx.
* Figure 7: Latency and throughput of Memcached.
* Figure 8: Latency and throughput of Caddy + Nginx.

### Reproducing the results

Before running the experiments, run `/data/start.sh` on both machines to
set up huge pages.

#### Table 1:
Run the following commands on node0, which will finish within about 1 hour:

```shell
cd /data/experiments/microbenchmark/
./exp.sh
```

Then run the following command to print the Table 1 (in CSV):

```shell
python3 table.py
```

#### Figure 2,3,4,5,6,7,8 and Table 3
Run the following commands on node 1:
```shell
cd /data/experiments/
./exp-baseline.sh
./exp-pegasus.sh
./exp-f-stack.sh
./exp-demikernel.sh
```

The time for each command is about 5.5 hours, 6.5 hours, 1.5 hours, and 1 hour,
respectively.

Then, on node0 run the following commands:
```shell
cd /data
./start_junction.sh
```
And on node1 run the following commands:
```shell
cd /data/experiments
./exp-junction.sh
```

It will finish within about 2 hours.

Then, on node1 run the following commands:
```shell
cd /data
./start_junction.sh
cd /data/experiments/tcp
./exp-junction.sh
```

It will finish within 5 minutes.

For these experiments, you can alternatively manually run them
for each experiment. Please refer to the scripts above if so.

Run the following commands on node1 to generate the figures and tables:
```shell
cd /data/experiments/results
./setup.sh
./generate.sh
```

The filenames are as follows: `fig-web.pdf` and `fig-servicemesh.pdf` for Figure 2,
`fig-local-proxy.pdf` for Figrue 3, `tab-latency.csv` for Table 3,
`fig-latency.pdf` for Figure 4, `fig-redis.pdf` for Figure 5,
`fig-nginx.pdf` for Figure 6, `fig-memcached` for Figure 7,
and `fig-proxy.pdf` for Figure 8.

Please refer to the artifact appendix of the paper for the
details on the claims and experiments.