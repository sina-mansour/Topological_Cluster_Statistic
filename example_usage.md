# Example usage:

Here you'll find explanations describing how to:

1. Run TCS using FSL [PALM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM)'s integrated scripts: this allows performing nonparametric inference using permutation testing
2. Run TCS's topological clustering algorithm using Python: this can be used to aid post-hoc interpretation of TCS results (or any alternative inference technique)

---

## Running TCS with PALM

TCS can be used in conjunction with PALM to run nonparametric statistical inference on either:

1. CIFTI space: where cortical data is represented on surface meshes and subcortical data is represented using a volumetric space
2. NIfTI space: where all data is represented in a volumetric space

For an overview of the wide range of capabilities of PALM in creating alternative designs, make sure to check out [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide)

---

### TCS with PALM for CIFTI data

To run a nonparametric statistical inference with TCS & PALM, you would need the following:

- General files that PALM needs: (similarly needed for non-TCS PALM scripts)
  - A design matrix: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-d` option). An example design matrix which was used to run TCS on a sample of size 40 is provided [here](data/consensus_topology/design.csv).
  - A t-contrast file: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-t` option). An example contrast file which was used to run TCS on a sample of size 40 is provided [here](data/consensus_topology/contrast.csv).
  - Input file: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-i` option). For CIFTI data the input can be created by merging first-level z-stats with [Connectome Workbench Command](http://www.humanconnectome.org/software/connectome-workbench.html) (see `wb_command -cifti-merge`).

- Files required specifically for TCS to run with PALM:
  - An adjacency matrix: A file that describes the topology which will be used for clustering the effects. We have provided example files described [here](README.md#hcp-group-connectomes). You could also generate alternative topologies if deemed necessary (more information [here](mapping_connectomes.md)).

Once these files are made/available, TCS can be simply executed with PALM using a PALM command line request such as the one below:

```sh
/<path-to-palm>/palm \
    -d /<path-to-design>/design.csv \
    -t /<path-to-contrast>/contrast.csv \
    -i /<path-to-cifti>/merged.zstat1.dtseries.nii \
    -adj /<path-to-adj>/hybrid_adjacency_clnorm.csv \
    -Cstat topology -C 3.3 -ise -n 1000 -transposedata \
    -o TCS_output -twotail -logp
```

Notes:
- Replace `/<path-to-design>/design.csv` with the path to the design matrix.
- Replace `/<path-to-contrast>/contrast.csv` with the path to the t-contrast file.
- Replace `/<path-to-palm>/palm` with the path to PALM's executable.
- Replace `/<path-to-cifti>/merged.zstat1.dtseries.nii` with the path to the merged CIFTI file containing the first-level z-stats.
- Replace `/<path-to-adj>/hybrid_adjacency_clnorm.csv` with the path to the adjacency matrix file for TCS.
- The `-Cstat topology` option tells PALM to perform TCS for the cluster statistic.
- The `-C 3.3` option tells PALM to use a cluster defining threshold of z=3.3, which is equivalent to p=0.001 for a two-tailed t-test.
- The `-ise` option tells PALM to assume independent symmetric errors to perform sign-flipping for permutations.
- The `-n 1000` option tells PALM to run 1000 permutations, feel free to adjust this value.
- The `-transposedata` option tells PALM that the merged z-stats provided as input need to be transposed to be in the required dimension.
- The `-o TCS_output` option provides and output prefix, feel free to change this.
- The `-twotail` option tells PALM to run a two-tailed test. This is recommended ans TCS can possibly cluster negative and positive effects in the same cluster.
- The `-logp` option tells PALM to store the output p-values as -log10(p). (This option is strongly recommended for PALM)

---

### TCS with PALM for NIfTI data

To run a nonparametric statistical inference with TCS & PALM for volumetric NIfTI data, You would need the following:

- General files that PALM needs: (similarly needed for non-TCS PALM scripts)
  - A design matrix: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-d` option). An example design matrix which was used to run TCS on a sample of size 40 is provided [here](data/consensus_topology/design.csv).
  - A t-contrast file: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-t` option). An example contrast file which was used to run TCS on a sample of size 40 is provided [here](data/consensus_topology/contrast.csv).
  - Input file: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-i` option). For NIfTI data the input should be a 4-dimensional image with the first dimension separating first-level voxelwise z-stats of all individuals.
  - Mask file: Check [PALM's user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for detail (the `-m` option). A 3D binary NIfTI mask to select the voxels that belong to the cortical gray matter (described [here](README.md#hcp-group-connectomes)).

- Files required specifically for TCS to run with PALM:
  - An adjacency matrix: A file that describes the topology which will be used for clustering the effects. We have provided example files described [here](README.md#hcp-group-connectomes). You could also generate alternative topologies if deemed necessary (more information [here](mapping_connectomes.md)).
  - An index file: A file that describes the orders of indices in the adjacency according to the voxels on the volumetric space. This is a 1-1 mapping of indices of the adjacency matrix to the voxels of the image and is provided as a volumetric NIfTI file (described [here](README.md#hcp-group-connectomes)).

Once these files are made/available, TCS can be simply executed with PALM using a PALM command line request such as the one below:

```sh
/<path-to-palm>/palm \
    -d /<path-to-design>/design.csv \
    -t /<path-to-contrast>/contrast.csv \
    -i /<path-to-nifti>/GLM_4D.nii \
    -m /<path-to-mask>/MNI152_T1_2mm_liberal.nii \
    -adj /<path-to-adj>/hybrid_adjacency_lnorm_volumetric_MNI152_2mm.csv \
    -ind /<path-to-ind>/node_indices_mat_MNI152_T1_2mm_brain.nii \
    -Cstat topology -C 3.3 -ise -n 1000 -transposedata \
    -o TCS_output -twotail -logp -accel tail
```

Notes:
- Replace `/<path-to-design>/design.csv` with the path to the design matrix.
- Replace `/<path-to-contrast>/contrast.csv` with the path to the t-contrast file.
- Replace `/<path-to-palm>/palm` with the path to PALM's executable.
- Replace `/<path-to-nifti>/GLM_4D.nii` with the path to the 4D NIfTI file containing the first-level z-stats.
- Replace `/<path-to-mask>/MNI152_T1_2mm_liberal.nii` with the path to the 3D mask file
- Replace `/<path-to-adj>/hybrid_adjacency_lnorm_volumetric_MNI152_2mm.csv` with the path to the adjacency matrix file for TCS.
- Replace `/<path-to-ind>/node_indices_mat_MNI152_T1_2mm_brain.nii` with the path to the index file for volumetric TCS.
- The `-Cstat topology` option tells PALM to perform TCS for the cluster statistic.
- The `-C 3.3` option tells PALM to use a cluster defining threshold of z=3.3, which is equivalent to p=0.001 for a two-tailed t-test.
- The `-ise` option tells PALM to assume independent symmetric errors to perform sign-flipping for permutations.
- The `-n 1000` option tells PALM to run 1000 permutations, feel free to adjust this value.
- The `-transposedata` option tells PALM that the merged z-stats provided as input need to be transposed to be in the required dimension.
- The `-o TCS_output` option provides and output prefix, feel free to change this.
- The `-twotail` option tells PALM to run a two-tailed test. This is recommended ans TCS can possibly cluster negative and positive effects in the same cluster.
- The `-logp` option tells PALM to store the output p-values as -log10(p). (This option is strongly recommended for PALM)
- The `-accel tail` option tells PALM to run an acceleration method to fit a generalised Pareto distribution, modelling the tail of the permutation distribution.

---

## Running Topological Clustering with Python

As can be seen in multiple manuscript reporoducing notebooks (e.g. [this one](/home/sina/Documents/Research/Codes/TCS/code/python/notebooks/ipynb/TCS_17_brain_visualizations_single_case_CDT.ipynb)), you can run the topological clustering approach from within python. This can particularly be handy if you are aiming to visualize data-driven interpretations, or are trying to interpret results of previous group-level findings using TCS.

Mainly, the following function performs topological clustering:

```python
# Importing required packages
import numpy as np
import scipy.sparse as sparse

def get_all_cluster_extents(effect, effect_threshold, topological_connectivity, magnitude=True):
    # first mask regions with weak effects
    if magnitude:
        suprathreshold_mask = sparse.diags((np.abs(effect) > effect_threshold).astype(float), 0)
    else:
        suprathreshold_mask = sparse.diags(((effect) > effect_threshold).astype(float), 0)

    # update connectivity to keep masked edges only
    thresholded_connectivity = (suprathreshold_mask.dot(topological_connectivity.dot(suprathreshold_mask))).tocsr()

    # compute all connected components
    n_components, labels = sparse.csgraph.connected_components(csgraph=thresholded_connectivity, directed=False, return_labels=True)

    # count the labels and report clusters
    unique, counts = np.unique(labels, return_counts=True)
    label_counts = dict(zip(unique, counts))

    label_replace = {x: (x if (label_counts[x] > 1) else -1) for x in label_counts}

    cluster_labels = [label_replace[x] for x in labels]
    cluster_size = {x: label_counts[x] for x in label_counts if (label_counts[x] > 1)}

    final_label_replace = {x: i for (i, x) in enumerate(np.unique(cluster_labels))}
    # final_label_replace[-1] = -1
    final_cluster_size = {final_label_replace[x]: cluster_size[x] for x in cluster_size}
    final_cluster_labels = [final_label_replace[x] for x in cluster_labels]

    return (final_cluster_size, final_cluster_labels)

```

The function takes the following arguments:

- `effect`: This is a numpy vector containing the observed group-level voxelwise/vertexwise effects. The effects can be Cohen's d effect sizes, z-statistics, or t-statistics. (A higher value should mean more significant, so in case of p-values, provide `-log10(p)` instead)
- `effect_threshold`: This is similar to the cluster-defining threshold, the algorithm tries to cluster effects larger than this value.
- `topological_connectivity`: This is a sparse adjacency matrix (`scipa.sparse.csr_matrix`) that describes the topology to be used for clustering (e.g. this can be a high-resolution connectome).
- `magnitude`: This is a boolean value. If `True`, then a two-tailed test will be evaluated to cluster all effects (positive or negative). Otherwise, only effects greater than the threshold will be clustered.

After execution the function returns a tuple containing the following:
- `final_cluster_size`: a dictionary containing the number of voxels/vertices belonging to each cluster
- `final_cluster_labels`: a vector (same shape as the `effect` vector) containing lables of all voxels/vertices. (Note: voxels/vertices that do not belong to any suprathreshold cluster will be labeled as `-1`)

Make sure to check out the [notebooks for reproducing our results](reproduce_our_results.md) for examples of how this python function can be used to aid interpretations.