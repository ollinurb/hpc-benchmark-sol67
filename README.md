# Instructions to Run the sol67-benchmark

## 1) Prepare the Template Directory
- Create a directory named `template` and place all the required input files inside it, including the launch scripts.
- Ensure that the expected duration of the test is reasonable (no more than 1 hour).

## 2) Verify PBS Submit Script
- Make sure there is **only one PBS submit script** located directly inside the `template` directory.

## 3) Running the Configuration
To run the benchmark configuration, use the following command:

```
./benchmark_configuration.sh -t vasp -n 4
```

- `-t vasp`: Specifies the type of tool (in this case, `vasp`).
- `-n 4`: Specifies the number of nodes for the benchmark. This will create one test suite for each node configuration (1 node, 2 nodes, 3 nodes, 4 nodes).

## 4) Sending Jobs to Queue
If the configuration is successful, run the following script to send the jobs to the queue:

```
./send_jobs.sh
```

This will submit all the jobs to the queue.

