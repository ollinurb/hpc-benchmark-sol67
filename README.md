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
hpc-benchmark-sol67
├── config
├── README.md
├── scripts
│   ├── plotter.py
│   ├── process_results.sh
│   └── send_jobs.sh
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

Run the script `config` with the following settings:

- `-t vasp` for benchmarking a VASP simulation
- `-n <node amount>` to define the max amount of nodes to allocate.

For example:
```
./config -t vasp -n 4
```
SOL67 has 20 c48 nodes composed of:

- Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz 24 cores CPU divided in 2 sockets.
- 4 nodes with 125 GiB RAM (compute-0-[0:3])
- 16 nodes with 62 GiB RAM (compute-0-[4:19])
- 8 nodes with InfiniBand (compute-0-[12:19])

Bear in mind that the benchmark is built to run on nodes with InfiniBand, so a maximum of 8 nodes can be used.

Nevertheless, it is recommended to run the benchmark on a lower amount of nodes (eg. 4) to have initial results before proceeding to scaling further.

### 4) Send jobs

Go into the benchmark directory/scripts
Run the script send_jobs.sh to schedule all the tests. 

```
cd <benchmark_dir>/scripts
./send_jobs.sh
```

### 5) Wait for all the jobs to finish

Dependencies:
- Python 
- Numpy
- Matplotlib

I used the following versions:
- Python 3.13.2
- Numpy 2.2.3  
-Matplotlib 3.10.1

 though the script is so simple that it probably works with other versions as well.

#### Micromamba enviroment

1) If not installed, install micromamba.

```
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```

Create the enviroment that will be needed in the graphic creation stage.

```
micromamba -y create -n benchmark_plotter -f requirements.txt
```


Once the jobs finish, it will run a new job that plots the results. You can use `scp` to download the results into your local machine to view the plots.
