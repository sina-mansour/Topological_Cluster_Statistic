#!/bin/bash

# some colors for fancy logging :D
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# topology_adjacency=$1
# output_folder=$2

adjacencies=("local_adjacency" "hybrid_adjacency_clnorm")
topology_dir="/data/gpfs/projects/punim0695/fMRI/DataStore/Outputs/Connectivity/consensus_topology/"

for random_seed in {0..499}
do
    for sample_size in 10 20 40 80 160 320
    do
        for adjacency in ${adjacencies[@]}
        do
            topology_adjacency="${topology_dir}/${adjacency}.csv"
            output_folder=$adjacency
            echo -e "${GREEN}[INFO]${NC} `date`: Submitting #${random_seed}_${sample_size}_${output_folder}."
            sbatch --job-name="${random_seed}_${sample_size}_${output_folder}" topological_clustering.sh \
                   ${sample_size} ${random_seed} ${topology_adjacency} ${output_folder}
        done
    done
done
