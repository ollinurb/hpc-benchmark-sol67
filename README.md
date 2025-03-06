-- Instructions to run the sol67-benchmark --

1) Create a directory named 'template' with all the input files, including the launch scripts.
	Make sure that the expected duration of the test is reasonable (not more than 1 hour). 



3) To run configuration:
   ./benchmark_configuration.sh -t vasp -n 4 

   - '-t vasp' refers to the type of tool used as vasp
   - '-n 4' refers to the amount of nodes the benchmark will scale. It will create
            one test suite for each node configuration (1 node, 2 nodes, 3 nodes, 4 nodes).
