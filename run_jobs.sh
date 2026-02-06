#!/bin/bash
#SBATCH --job-name=miniapps         # Job name (change as desired)
#SBATCH --output=miniapps_%j.out    # Standard output
#SBATCH --error=miniapps_%j.err     # Standard error
#SBATCH --nodes=1
#SBATCH --ntasks=64                         # Number of MPI ranks (adjust as needed)
#SBATCH --time=01:00:00                    # Time limit (HH:MM:SS)
#SBATCH --partition=main                   # Partition
#SBATCH --qos=main                         # QOS
#SBATCH --mem-per-cpu=2G   # cpu memory per cpu-core zero means no limit

# Load necessary modules
module load singularity/3.7.2
module load slurm
module load openmpi/gcc/64/4.1.5

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export OMPI_MCA_plm_rsh_agent=ssh
export OMP_NUM_THREADS=1
export TMPDIR=/tmp


mkdir -p result result/input/ result/output/

## for miniAMR
if ! [ -f miniamr_latest.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/miniamr
fi
##submit with large queue and 120gb memory
mpirun  -np 16 singularity run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 6000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 2 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result16.txt
mpirun  -np 32 singularity run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 4000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result32.txt
mpirun -np 64 singularity run --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --num_refine 4 --max_blocks 4000 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 4 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result64.txt


## for lulesh
if ! [ -f lulesh_latest.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/lulesh
fi

mpirun -n 8 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 2 > result/output/lulesh_result2_8.txt
mpirun -n 27 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 3 > result/output/lulesh_result3_27.txt
mpirun -n 64 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 4 > result/output/lulesh_result4_64.txt



if ! [ -f minivite_latest.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/minivite
fi

if ! [ -f result/input/neuron1024.bin ]; then
  chmod +x create_minivite_input_jobs.sh
  ./create_minivite_input_jobs.sh
fi


mpirun -n 8 singularity run --bind result:/opt/result  minivite_latest.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result8.txt
mpirun -n 32 singularity run --bind result:/opt/result  minivite_latest.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result32.txt
mpirun -n 64 singularity run --bind result:/opt/result  minivite_latest.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result64.txt

