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

# Evaluating results and generating plots

Once the scripts finish running, about 1.3 TB of data will be generated in the output directory that contains the results of performing PALM with and without TCS on different tasks, sample sizes, and thresholds. Next, we used python scripts written in [Jupyter notebooks](code/python/notebooks/ipynb) to analyze the results. For every notebook an [HTML view](code/python/notebooks/html) is made available to present the scripts

- The first notebook, [TCS_01_loading_PALM_results](code/python/notebooks/ipynb/TCS_01_loading_PALM_results.ipynb), was used to convert outputs of FSL PALM into a binary format to be efficiently read by Python's NumPy package.

- The second notebook, [TCS_02_putative_ground_truth](code/python/notebooks/ipynb/TCS_02_putative_ground_truth.ipynb), contains the scripts that can be used to generate the putative ground truth effects from all HCP participants. This notebook also contains additional scripts used to generate some of the plots from the manuscript.

- Notebooks [3](code/python/notebooks/ipynb/TCS_03_sensitivity_improvements.ipynb), [4](code/python/notebooks/html/TCS_04_sensitivity_improvement_sample_size.ipynb), and [5](code/python/notebooks/ipynb/TCS_05_sensitivity_improvement_CDT.ipynb) contain scripts used for main and supplementary analyses of sensitivity improvements.

- Notebooks [6](code/python/notebooks/ipynb/TCS_06_bookmaker_informedness.ipynb), [7](code/python/notebooks/ipynb/TCS_07_bookmaker_informedness_smaple_size.ipynb), and [8](code/python/notebooks/ipynb/TCS_08_bookmaker_informedness_CDT.ipynb) contain scripts used for the main and supplementary analyses of inference informedness.

- Notebooks [9](code/python/notebooks/ipynb/TCS_09_localized_sensitivity.ipynb), [10](code/python/notebooks/ipynb/TCS_10_localized_sensitivity_sample_size.ipynb), and [11](code/python/notebooks/ipynb/TCS_11_localized_sensitivity_CDT.ipynb) contain scripts that can reproduce the main and supplementary analyses of localized sensitivity improvements.

- Notebook [12](code/python/notebooks/ipynb/TCS_12_brain_visualizations_ground_truth.ipynb) contains scripts that use the [Cerebro Viewer](https://github.com/sina-mansour/Cerebro_Viewer) to generate the brain visualizations of the putative ground truth.

- Notebooks [13](code/python/notebooks/ipynb/TCS_13_brain_visualizations_localized_sensitivity.ipynb), [14](code/python/notebooks/ipynb/TCS_14_brain_visualizations_localized_sensitivity_sample_size.ipynb), and [15](code/python/notebooks/ipynb/TCS_15_brain_visualizations_localized_sensitivity_CDT.ipynb) contain scripts that use the [Cerebro Viewer](https://github.com/sina-mansour/Cerebro_Viewer) to generate the main and supplementary brain visualizations of localized sensitivity.

- Notebooks [16](code/python/notebooks/ipynb/TCS_16_brain_visualizations_single_case.ipynb), and [17](/home/sina/Documents/Research/Codes/TCS/code/python/notebooks/ipynb/TCS_17_brain_visualizations_single_case_CDT.ipynb) contain scripts that use the [Cerebro Viewer](https://github.com/sina-mansour/Cerebro_Viewer) to generate the main and supplementary brain visualizations of the comparisons of TCS and spatial cluster inference on a single case.

- Notebook [18](code/python/notebooks/ipynb/TCS_18_additional_power_assessments.ipynb) contains scripts that were used to conduct additional evaluations and comparisons that were presented in the supplementary information of the manuscript.

- Notebook [19](code/python/notebooks/ipynb/TCS_19_ribbon_simulation.ipynb) contains scripts that generated the simulation which illustrates the comparative benefits of TCS on a 2-dimensional ribbon.

- Notebook [20](code/python/notebooks/ipynb/TCS_20_chord_diagrams.ipynb) contains scripts that were used to generate the connectogram (chord diagrams) that summarized the implicated anatomical networks on an arbitrary brain atlas.

