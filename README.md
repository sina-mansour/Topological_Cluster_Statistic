# Topological Clustering Statistic (TCS)

---

This repository contains scripts, examples, and accompanying results and data for the publication titled **"Topological Cluster Statistic (TCS): Towards structural-connectivity-guided fMRI cluster enhancement"** currently available as a preprint at Research Square:

[![DOI:10.21203/rs.3.rs-2059418/v1](http://img.shields.io/badge/DOI-10.21203/rs.3.rs–2059418/v1-B31B1B.svg)](https://doi.org/10.21203/rs.3.rs-2059418/v1)

*Sina Mansour L., Caio Seguin, Anderson Winkler et al. Topological Cluster Statistic (TCS): Towards structural-connectivity-guided fMRI cluster enhancement, 15 September 2022, PREPRINT (Version 1) available at Research Square [https://doi.org/10.21203/rs.3.rs-2059418/v1](https://doi.org/10.21203/rs.3.rs-2059418/v1)*


---

## TLDR

In short, we implemented a method that extends traditional cluster extent statistics to use alternative topological structures to cluster brainwide effects. For instance, as showcased in the manuscript, our method can make use of anatomical information in human structural connectomes to provide data-driven interpretations of implicated white matter tracts in a task activity. Our proposed method is provided as a new functionality for [FSL's PALM toolbox for Permutation Analysis of Linear Models](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM).

In the manuscript we show that:

1. The method can improve the statistical power (sensitivity) of cluster-based correction methods leading to more informed effect detection
2. The method provides data-driven aid in interpretation of findings by highlighting the implicated anatomical connections that give rise to an observed effect. (i.e. it can tell what potential anatomical pathways could be involved in the emergence of a particular functional task activity)

This repository contains:

- 📝 Examples on how to use TCS with PALM [👉 here](#example-usage)
- 💾 A beta-release version of PALM with TCS implementation (to be merged in a PR) [👉 here](#beta-release)
- 🧠 Topological structures of group-level consensus connectomes to be used with PALM [👉 here](#hcp-group-connectomes)
- 📓 Scripts for creating alternative topological structures to use with TCS [👉 here](#alternative-topologies)
- 📗 Scripts used for performing the evaluations, analyses, and visualization in the manuscript  [👉 here](#code-to-reproduce)

---

## Example usage

TCS is integrated with [FSL PALM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM), so you can easily combine it with arbitrary designs most appropriate for your analyses. Here's a PALM command that performs TCS:

```sh
/<path-to-palm>/palm \
    -d /<path-to-design>/design.csv \
    -t /<path-to-contrast>/contrast.csv \
    -i /<path-to-cifti>/merged.zstat1.dtseries.nii \
    -adj /<path-to-adj>/hybrid_adjacency_clnorm.csv \
    -Cstat topology -C 3.3 -ise -n 1000 -transposedata \
    -o TCS_output -twotail -logp
```

For more information, make sure to check out [this explanation document](example_usage.md).

---

## Beta release

As of yet (May 2023) TCS is not officially released for PALM. TCS will be merged to a future PALM release soon. However, for the sake of full transparency and reproducibility of results, a compressed archive of the PALM scripts used to conduct the evaluations in the manuscript is provided [here](code/matlab/PALM/palm-alpha120rc3.zip).

---

## HCP group connectomes

To use TCS with PALM, you also need files that describe the topological structure to be used for cluster correction. We have provided example topological structures for the HCP young adult cohort in two alternative spaces (for surface based and volumetric analyses):

1. The fs-LR 32k cifti space:

   - For cifti files, the topology is explained by a single file containing the adjacency structure in a sparse format, ready to be used by the PALM scripts. A topology built from a high-resolution group-level consensus connectome is made available [here](data/consensus_topology/hybrid_adjacency_clnorm.csv).
   - An alternative topology is also provided for cifti files that only contains spatial connections (for vertices: vertices sharing a face, for voxels: 6 directly neighboring voxels). This topology file is only included for the purpose of replicability as it is used by some of the jupyter notebooks. This spatial topology is available [here](data/consensus_topology/local_adjacency.csv) in a format that can be directly used with PALM.

2. The MNI152 2mm T1 space
   - For volumetric images, PALM requires two sets of files to be provided:
     - A file describing the high-resolution topology describing the anatomical network connecting voxels based on structural connectivity. This files should be provided in a sparse adjacency matrix format readable by PALM. An example volumetric topology derived from a high-resolution group-level consensus connectome of the HCP young adult data. The volumetric connectome has a considerably larger file size and was thus shared over a cloud storage accessible from [here](https://cloudstor.aarnet.edu.au/plus/s/0ATqinOCnWma204).
     - In addition to the adjacency matrix, another file is needed to tell PALM the order of voxels in the adjacency matrix. For this purpose, a simple nifti image file is provided [here](data/consensus_topology/node_indices_mat_MNI152_T1_2mm_brain.nii).
   - Similarly an alternative topology is also provided that only contains spatial neighborhoods (6 neighbors). This file is available from [here](https://cloudstor.aarnet.edu.au/plus/s/qUbxw3lQq6MyvWB).
   - The T1 brain mask is also available form [here](data/consensus_topology/MNI152_T1_2mm_liberal.nii) which can be used in combination with the volumetric files to limit the analysis to a liberal mask of cortical gray matter.
   - The T1 file used for this standard space is additionally available from [here](data/consensus_topology/MNI152_T1_2mm.nii.gz).

Please note that descriptions about how these files can be used with PALM are provided in [this explanation document](example_usage.md).

---

## Alternative topologies

So you might have had a closer look at the manuscript and realized that you can provide alternative connectomes (topological connectivity structures) for TCS. For instance, you may:

- Want to use an alternative group-level connectome more appropriate for the age-range of your cohort
- Want to use an individualized connectome to conduct your analyses
- Want to use a connectome from a well-established white matter atlas to ensure there are no falsely generated anatomical connections in the topology
- Want to use a resting-state functional connectome to explore capabilities of TCS with a different conceptual assumption (to group functionally linked regions in a cluster)

Then check out the examples [here](mapping_connectomes.md) to find out how you could provide your alternative topology to TCS.

!TODO!

---

## Code to reproduce

If you are interested in reproducing the evaluations performed in the manuscript, conduct a similar analytical procedure, or reproduce the visualization of our findings, you could check out the example scripts described [here](reproduce_our_results.md). There, you will find descriptions along with accompanying Jupyter notebooks that can be used to reproduce all the findings of our study.

---

## Request for features / bug fixes

If you encounter any bugs, or would like new features to be implemented for TCS, make sure to create an issue in this repository.

This repository was created and is maintained by:

[Sina Mansour L.](https://sina-mansour.github.io/) <sina.mansour.lakouraj@gmail.com>
