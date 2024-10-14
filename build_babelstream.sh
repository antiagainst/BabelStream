#!/bin/bash

make clean -f ./HIP.make
make -f ./HIP.make DWORDS_PER_LANE=4 NONTEMPORAL=1 CHUNKS_PER_BLOCK=1 TBSIZE=1024
