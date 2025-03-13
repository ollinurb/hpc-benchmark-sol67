#!/bin/bash

SUBMIT_FILE=$(grep SUBMIT_FILE ../CONFIG | awk -F = '{print $2}')
JOB_IDS=()
mapfile -t TESTS < <(ls ../nodes)

cd ../nodes
for test in "${TESTS[@]}"; do
    cd $test
    JOB_IDS+=($(qsub $SUBMIT_FILE))
    cd ..
done
cd ../scripts

JOB_STRING=$(IFS=:; echo "${JOB_IDS[*]}")
echo ${JOB_IDS[@]}

qsub -W depend=afterok:$JOB_STRING process_results.sh 
