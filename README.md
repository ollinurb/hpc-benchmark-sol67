# SOL67 Multinode Benchmark script

Use this script to create a test suite for benchmarking how your program scales on more than one sol67 node.

## Supported programs

If your program is not supported, please go to section Unsupported Programs.

Programs available:
- VASP

## Installation

### 1) Clone this repository:
```
git clone https://github.com/ollinurb/hpc-benchmark-sol67
```

### 2) Copy source project

Put a copy of the simulation you want to benchmark on a directory named `template` inside the main directory of the repository:

```
cd hpc-benchmark-sol67
cp -r /path/to/project template
```

Make sure all the input files are directly inside the directory. 
For VASP, the directory should look like this:

```
hpc-benchmark-sol67/
├── benchmark_configuration.sh
├── README.md
├── send_jobs.sh
└── template
    ├── INCAR
    ├── KPOINTS
    ├── POSCAR
    ├── POTCAR
    └── <PBS launch script>
```

Make sure there is only one PBS qsub script on the template directory.

Make sure the output files will be created directly inside `template`.

```
└── template
    ├── <input files>
    ├── <output files>
    └── <PBS launch script>
```

### 3) Run configuration

Run the script ´benchmark_configuration.sh´ with the following settings:

- `-t vasp` for benchmarking a VASP simulation
- `-n <node amount>` to define the max amount of nodes to allocate.

For example:
```
./benchmark_configuration.sh -t vasp -n 4
```
SOL67 has 20 c48 nodes composed of:

- Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz 24 cores CPU divided in 2 sockets.
- 4 nodes with 125 GiB RAM (compute-0-[0:3])
- 16 nodes with 62 GiB RAM (compute-0-[4:19])
- 8 nodes with InfiniBand (compute-0-[12:19])

Bear in mind that the benchmark is built to run on nodes with InfiniBand, so a maximum of 8 nodes can be used.

Nevertheless, it is recommended to run the benchmark on a lower amount of nodes (eg. 4) to have initial results before proceeding to scaling further.

### 4) Send jobs

Run the script send_jobs.sh to schedule all the tests. 

```
./send_jobs.sh
```

### 5) Wait for all the jobs to finish

TODO: Automatize the output data processing to automatically plot the results and evaluate the scaling results.