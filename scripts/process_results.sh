#!/bin/bash
#PBS -N Bench_proc_out
#PBS -q long
#PBS -l nodes=1

echo "processing results"

#loop though existent nodes and add a line with the node count and the result
# we should also use awk to only get the resulting number
grep "Elapsed time" nodes/*/runs/1/OUTCAR > processed_output.txt

source ~/.bashrc
micromamba --help
micromamba run -n plotter_env python chatgptplotting.py

mkdir benchmark_$(date +"%F_%R")
