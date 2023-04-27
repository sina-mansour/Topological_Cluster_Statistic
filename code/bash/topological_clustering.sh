#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-04:00:00
#SBATCH --mem=4G
#SBATCH --partition=physical
#SBATCH -o slurm/topological_clustering/%x_%j.out

module load MATLAB/2019a
module load Python/3.6.4-intel-2017.u2
module load ConnectomeWorkbench/1.3.2-intel-2017.u2
module load Qt5/5.13.2-intel-2017.u2
module load zlib/1.2.9-intel-2017.u2
module load web_proxy/latest
source /data/gpfs/projects/punim0695/fMRI/venv/bin/activate

# some colors for fancy logging :D
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# configure palm libraries
export LD_PRELOAD=/usr/lib/libstdc++.so.6:/usr/local/easybuild/software/Qt5/5.13.2-intel-2017.u2/lib/libQt5Core.so.5:/usr/local/easybuild/software/Qt5/5.13.2-intel-2017.u2/lib/libQt5Gui.so.5:/usr/local/easybuild/software/Qt5/5.13.2-intel-2017.u2/lib/libQt5Xml.so.5:/usr/local/easybuild/software/Qt5/5.13.2-intel-2017.u2/lib/libQt5Network.so.5


# read the arguments
sample_size=$1
random_seed=$2
topology_adjacency=$3 # /data/gpfs/projects/punim0695/fMRI/DataStore/Outputs/Connectivity/consensus_topology/hybrid_adjacency_clnorm.csv
output_folder=$4

palm_dir="/data/gpfs/projects/punim0695/PALM/palm-alpha120rc2"
data_dir="/data/gpfs/projects/punim0695/fMRI/DataStore/HCP_data/HCP_1200"
output_dir="/data/gpfs/projects/punim0695/fMRI/DataStore/Outputs/PALM/${output_folder}/${sample_size}_samples/run_${random_seed}"

python3 topological_clustering.py "${palm_dir}" "${data_dir}" "${output_dir}" \
                                  "${sample_size}" "${random_seed}" "${topology_adjacency}"

deactivate
