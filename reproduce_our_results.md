# Reproducing our results

To reproduce the results and findings of our eveluations you need:

1. Access to HCP data
2. A copy of the beta release of PALM, see [here](README.md#beta-release)
3. A copy of the group-average consensus connectome in the CIFTI space (fs-LR 32k), see [here](README.md#hcp-group-connectomes)

Then, you can reproduce all of our results. All procedures were performed on Linux high-performance computing cluster and parallelizations were performed using slurm jobs. The complete procedure can be broken into the following steps:

# Running PALM

The python script provided in [code/python/scripts/topological_clustering.py](code/python/scripts/topological_clustering.py) is used to run PALM (with either TCS or simple cluster-extent statistic) on a single random sub-sample of HCP over different cluster defining thresholds and task contrasts. This script uses several python packages for file and time management. The script uses connectome workbench command to merge first-level statistics. It also uses Unix commands to call PALM's matlab script from its appropriate path.

The bash script provided in [code/python/scripts/topological_clustering.sh](code/python/scripts/topological_clustering.sh) uses slurm commands to define a job that executes the python script on an HPC cluster with several modules loaded (including python, matlab, and connectome workbench).

**Note**: you need to update the paths in this script to appropriately link to i) the PALM script directory, ii) HCP data directory, and iii) the output directory you wish to use to store the results.

Finally, the bash script provided in [code/python/scripts/topological_clustering_run.sh](code/python/scripts/topological_clustering_run.sh) is used to automate parallel job submissions for different random seeds, sample sizes, and algorithm selections (TCS or traditional cluster extent).

**Note**: you need to update the path in this script to appropriately link to the directory where the connectome topologies are stored.

# Evaluating results

Once the scripts finish running, about 1.3 TB of data will be generated in the output directory that contains the results of performing PALM with and without TCS on different tasks, sample sizes, and thresholds. Next, we used scripts in a jupyter notebook to analyze these results. An HTML view of this notebook is available [here](...).