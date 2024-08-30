#!/bin/bash
./f-stack.sh
cd demikernel && ./demikernel.sh && cd ..
./junction.sh
./bin.sh
