import numpy as np
import matplotlib.pyplot as plt

# Read benchmark data
data = np.loadtxt("output.dat")  # File format: "nodes time"
nodes = data[:, 0]
times = data[:, 1]

# Compute speedup
time_1 = times[0]  # Reference time for 1 node
speedup = time_1 / times

# Save results with speedup
np.savetxt("benchmark_results.dat", np.column_stack((nodes, times, speedup)), fmt="%.2f", header="Nodes Time Speedup")

# Plot Walltime vs Nodes
plt.figure(figsize=(8, 5))
plt.plot(nodes, times, marker='o', linestyle='-', color='b', label="Walltime")
plt.suptitle("VASP 5.4.4 MgCl2 108at DFT-D3 1200K Vatomo 30")
plt.xlabel("Nodes - Intel® Xeon® CPU E5-2650 v4")
plt.ylabel("Total Walltime (s)")
plt.title("Scaling benchmark on node amount")
plt.xticks(nodes)
plt.grid()
plt.legend()
plt.savefig("walltime_vs_nodes.png")

# Plot Speedup vs Nodes
plt.figure(figsize=(8, 5))
plt.plot(nodes, speedup, marker='s', linestyle='-', color='r', label="Speedup")
plt.suptitle("VASP 5.4.4 MgCl2 108at DFT-D3 1200K Vatomo 30")
plt.xlabel("Nodes - Intel® Xeon® CPU E5-2650 v4")
plt.ylabel("Speedup")
plt.title("Scaling benchmark on node amount")
plt.xticks(nodes)
plt.grid()
plt.legend()
plt.savefig("speedup_vs_nodes.png")

plt.show()
