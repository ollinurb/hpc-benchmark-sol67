#!/bin/bash
#PBS -N Bench_proc_out
#PBS -q long
#PBS -l nodes=1

MAX_NODES=$(grep MAX_NODES ../CONFIG | awk -F = '{print $2}')
OUTPUT_LOCATION=$(grep OUTPUT_LOCATION ../CONFIG | awk -F = '{print $2}')

for $i in $(seq 1 $MAX_NODES);
do
echo $i $(grep "Elapsed time" ../nodes/$i/$OUTPUT_LOCATION/OUTCAR | awk '{print $NF}' >> output.dat
done

source ~/.bashrc
micromamba run -n benchmark_plotter python plotter.py

