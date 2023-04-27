# Topological Clustering Statistic (TCS)

---

This repository contains scripts, examples, and accompanying results and data for the publication titled **"Topological Cluster Statistic (TCS): Towards structural-connectivity-guided fMRI cluster enhancement"** currently available as a preprint at Research Square:

[![DOI:10.21203/rs.3.rs-2059418/v1](http://img.shields.io/badge/DOI-10.21203/rs.3.rs-2059418/v1-B31B1B.svg)](https://doi.org/10.21203/rs.3.rs-2059418/v1)

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

TCS is integrated with [FSL PALM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM), so you can easily combine it with arbitrary designs most appropriate for your analyses. Here's a one-liner that performs TCS:

!TODO!

For more information, make sure to check out [this explanation document](example_usage.md).

---

## Beta release

The PALM code will be merged to PALM soon. However, for the sake of full transparency and reproducibility of results, a compressed archive of the scripts used to conduct the evaluations in the manuscript is provided [here](...).

!TODO!

---

## HCP group connectomes

To use TCS with PALM, you also need a file that describes the topological structure that is used for cluster correction. We have provided example topological structures for the HCP young adult cohort in two alternative spaces (for surface based and volumetric analyses):

1. The fs-LR 32k cifti space
2. The MNI152 2mm T1 space

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

If you are interested in reproducing the evaluations performed in the manuscript, conduct a similar analytical procedure, or reproduce the visualization of our findings, you could check out the example scripts described [here](reproduce_our_results.md).

!TODO!
