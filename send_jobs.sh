#!/bin/bash

SUBMIT_FILE=run-sol67_new.sh

mapfile -t TESTS < <(ls nodes)

cd nodes
for test in "${TESTS[@]}"; do
    cd $test
    qsub $SUBMIT_FILE
    cd ..
done
