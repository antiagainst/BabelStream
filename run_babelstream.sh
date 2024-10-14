#!/bin/bash

# For loop with number range
for i in {0..5}
do
    ./hip-stream --float -e --std -s $((256 * 1024 * 1024)) --mibibytes
done

