# Alternative topologies for TCS

As described in the manuscript, TCS has the ability to work with any arbitrary toplogy. The topology could be constructed from high-resolution connectomes.

Here, to showcase how an arbitrary topology can be provided to TCS, we give an example to create such a topology from an individual's tractography output.

---

## Converting the tractography into a high-resolution connectome:

Assuming [MRtrix 3](https://www.mrtrix.org/) was used to perform tractography, it stores the resulting streamlines in a `.tck` file. We first need to convert this file to a high-resolution connectome. We use the procedure originally described in [this repository](https://github.com/sina-mansour/neural-identity).

This procedure is now integrated to [python's CSS package for connectome spatial smoothing](https://github.com/sina-mansour/connectome-spatial-smoothing). For a detailed explanation of the capabilities of this package you may check [this notebook](https://github.com/sina-mansour/connectome-based-smoothing/blob/main/notebooks/example.ipynb).

In short, an individual's tractography can be mapped onto a high-resolution fs-LR 32k space connectome with the script used below:

```python
import numpy as np
import scipy.sparse as sparse
from scipy import spatial
import nibabel as nib

# Import the CSS package
from Connectome_Spatial_Smoothing import CSS as css

###############################################################################
# NOTE: You need to replace these paths to point to the correct files

# Individual's tractography output files
tractography_file = '/path_to/individual_tractography.tck'

# The 32k fs-LR surface files in the MNI space
left_MNI_surface_file = '/path_to/individual.MNI152.L.white.32k_fs_LR.surf.gii'
right_MNI_surface_file = '/path_to/individual.MNI152.R.white.32k_fs_LR.surf.gii'

# The warp files for nonlinear registration between the native and MNI space
warp_file = '/path_to/individual_standard2acpc_dc.nii.gz'

# An example cifti file that contains the volumetric brain models
cifti_file = '/path_to/ones.dscalar.nii'
###############################################################################


# Map high-resolution connectome onto native surfaces:
high_resolution_connectome = css.map_high_resolution_structural_connectivity(
    tractography_file,
    left_MNI_surface_file,
    right_MNI_surface_file,
    warp_file=warp_file,
    subcortex=True,
)
```

The resulting `high_resolution_connectome` is a sparse weighted adjacency matrix.

---

## Spatial smoothing of the high-resolution connectome

It is recommended to spatially smooth these connectomes (check [this paper](https://doi.org/10.1016/j.neuroimage.2022.118930) to find out why). The following script uses the `CSS` package to perform spatial smoothing:

```python
smoothing_kernel = css.compute_smoothing_kernel(
    left_MNI_surface_file,
    right_MNI_surface_file,
    fwhm=6, epsilon=0.01, subcortex=True
)

smoothed_high_resolution_connectome = css.smooth_high_resolution_connectome(high_resolution_connectome, smoothing_kernel)
```

The `smoothed_high_resolution_connectome` is also a sparse weighted adjacency matrix.

## Creating the sparse binary topology

The TCS algorithm requires a binary sparse adjacency matrix. We can use a simple thresholding to create this binary adjacency matrix:

```python
# A function that produces a binary adjacency (you can adjust this value)
threshold = 10

# Create a binary topology
binary_connectome = (smoothed_high_resolution_connectome>threshold).astype(float)
```

## Adding local neighborhood structure

The binary adjacency constructed above only contains the anatomical connections. We next need to add additional binary edges for spatial neighborhoods of every voxel/vertex. The following script uses [SciPy](https://scipy.org/) and [Nibabel](https://nipy.org/nibabel/gettingstarted.html) packages to construct the local neighborhoods:

```python
def get_surface_indices_left_and_right_on_cifti(cifti):
    # load the brain models from the file (first two models are the left and right cortex)
    brain_models = [x for x in cifti.header.get_index_map(1).brain_models]
    # get the names of brain structures in the cifti file
    structure_names = [x.brain_structure for x in brain_models]
    
    left_cortex_index = structure_names.index('CIFTI_STRUCTURE_CORTEX_LEFT')
    right_cortex_index = structure_names.index('CIFTI_STRUCTURE_CORTEX_RIGHT')
    
    left_surfaces_cifti_indices = [x for x in brain_models[left_cortex_index].vertex_indices]
    right_surfaces_cifti_indices = [x for x in brain_models[right_cortex_index].vertex_indices]
    
    return (left_surfaces_cifti_indices, right_surfaces_cifti_indices)

def compute_local_adjacency(left_surf, right_surf, cifti):
    # constructing the local connectivity for surfaces:
    left_surf_dim = left_surf.darrays[0].data.shape[0]
    left_surf_adj = sparse.dok_matrix((left_surf_dim, left_surf_dim), dtype=np.float32)

    for t in left_surf.darrays[1].data:
        left_surf_adj[t[0], t[1]] = 1
        left_surf_adj[t[1], t[0]] = 1
        left_surf_adj[t[2], t[1]] = 1
        left_surf_adj[t[1], t[2]] = 1
        left_surf_adj[t[0], t[2]] = 1
        left_surf_adj[t[2], t[0]] = 1


    right_surf_dim = right_surf.darrays[0].data.shape[0]
    right_surf_adj = sparse.dok_matrix((right_surf_dim, right_surf_dim), dtype=np.float32)

    for t in left_surf.darrays[1].data:
        right_surf_adj[t[0], t[1]] = 1
        right_surf_adj[t[1], t[0]] = 1
        right_surf_adj[t[2], t[1]] = 1
        right_surf_adj[t[1], t[2]] = 1
        right_surf_adj[t[0], t[2]] = 1
        right_surf_adj[t[2], t[0]] = 1

    left_surf_adj = left_surf_adj.tocsr()
    right_surf_adj = right_surf_adj.tocsr()

    left_surfaces_cifti_indices, right_surfaces_cifti_indices = get_surface_indices_left_and_right_on_cifti(cifti)

    # cortical surface local connectivity (excluding medial wall)
    left_surf_adj_selection = left_surf_adj[:,left_surfaces_cifti_indices][left_surfaces_cifti_indices,:]
    right_surf_adj_selection = right_surf_adj[:,right_surfaces_cifti_indices][right_surfaces_cifti_indices,:]

    # subcortical local connectivity (volumetric)
    brain_models = [x for x in cifti.header.get_index_map(1).brain_models]
    subijk = np.array(list(itertools.chain.from_iterable([(x.voxel_indices_ijk) for x in brain_models[2:]])))

    # to get local connectivity (26 neighbors) we'll compute those in a distance closer than 1.9 voxels (1, sqrt(2), sqrt(3) are all smaller than 1.9)
    kdtree = spatial.cKDTree(subijk)
    subdist = kdtree.sparse_distance_matrix(kdtree, 1.9)

    subcortical_adj = (subdist.tocsr()>0.5).astype(float)

    # aggregating two cortical surfaces and subcortical volume
    local_adjacency = sparse.block_diag((left_surf_adj_selection, right_surf_adj_selection, subcortical_adj))

    return local_adjacency

local_adjacency = compute_local_adjacency(
    nib.load(left_MNI_surface_file),
    nib.load(right_MNI_surface_file),
    nib.load(cifti_file),
)
```

Having computed the local adjacency, we need to combine the two sparse matrices:

```python
binary_adjacency = ((binary_connectome + local_adjacency) > 0).astype(float)
```

This binary adjacency can be directly used with the python implementation of TCS described [here](example_usage.md#running-topological-clustering-with-python).

## Converting to a PALM format

PALM requires this adjacency matrix in a slightly different format. Mainly, it needs to be saved as a CSV file representing the sparse topology with three descriptors of (row, column, value) for every edge. Next, the edge indices need to be shifted by one as Python starts indexing from zero, whereas matlab starts indexing from one.

The following code can generate the required adjacency file in a CSV format to be used with PALM:

```python
# Store adjacency as CSV
binary_adjacency = binary_adjacency.tocoo()
csv_info = np.stack((binary_adjacency.row+1, binary_adjacency.col+1, binary_adjacency.data)).T.astype(int)

# Update the path to where you like the file to be saved
np.savetxt('/path_to/adjacency.csv', csv_info, fmt="%d", delimiter=",",)

```

The final line stores a CSV file that can be used to perform TCS with PALM (as described [here](example_usage.md#running-tcs-with-palm)).
