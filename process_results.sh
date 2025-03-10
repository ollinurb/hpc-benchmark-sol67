#!/bin/bash
#PBS -N Bench_proc_out
#PBS -q long
#PBS -l nodes=1

echo "processing results"

grep "Elapsed time" /nodes/*/OUTCAR > processed_output.txt

