#!/bin/bash

SUBMIT_FILE=run-sol67_new.sh
JOB_IDS=()
mapfile -t TESTS < <(ls nodes)

cd nodes
for test in "${TESTS[@]}"; do
    cd $test
    JOB_IDS+=($(qsub $SUBMIT_FILE))
    cd ..
done

echo ${JOB_IDS[@]}
