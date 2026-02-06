

#### miniapps_rero
This guide provides instructions for running the miniapps. You must first ensure that your system is correctly configured.

##### Prerequisites
Before submitting jobs, confirm that your High-Performance Computing (HPC) system has the following software installed:

**Apptainer/Singularity:** A container platform.

**Open MPI:** The Message Passing Interface for parallel computing. Version 4.1.6 or later is expected.

##### Environment Setup
You must load the necessary modules to prepare your environment. The specific versions may vary by system.



##### Load containerization module
```
module load apptainer  # Or singularity if Apptainer is not available
```
##### Load MPI module
```
module load openmpi/gcc/64/4.1.5
```

##### Load the Slurm module if your system uses it for job submission
```
module load slurm
```
##### Verification
Verify the versions of the loaded software and check your environment variables.

**Check Open MPI version:**


```
mpirun --version
```
**Check Apptainer/Singularity version:**

```

apptainer --version
singularity --version
```
**Verify Environment Variables:** Ensure that your $PATH variable includes the correct paths to the MPI and Apptainer/Singularity binaries. You may need to run the following commands to configure your environment.


```
export PATH=$PATH:/usr/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export OMPI_MCA_plm_rsh_agent=ssh
export OMP_NUM_THREADS=1
export TMPDIR=/tmp
```
##### Job Submission
Once the environment is configured, you can submit the jobs using the provided script.


```
sbatch run_jobs.sh
```

## Folder Structure

```
├── .gitignore
├── README.md
├── analyze_minivite_result.sh
├── create_minivite_input_jobs.sh
├── run_jobs.sh
├── write_file.py
└── write_file.sh


/.gitignore:
--------------------------------------------------------------------------------
1 | minivite_input/*.*
2 | minivite_input/
3 | *.sif
4 | result/
5 | *.out
6 | *.err

```
#### 1. MiniAMR Application Guide
This document provides instructions for running the MiniAMR application using Singularity/Apptainer and Open MPI.

##### 1. Setup
First, create the necessary directory structure for your results. This command creates a result directory with input and output subdirectories.


```
mkdir -p result result/input/ result/output/
```

Next, pull the MiniAMR Singularity image from the cloud. The if statement ensures the image is only downloaded if it doesn't already exist in the current directory.
```
## for miniAMR
if ! [ -f miniamr_latest.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/miniamr
fi
```
##### 2. Running the Application
To run MiniAMR, you'll use the mpirun command in conjunction with singularity run. The output for each run will be redirected to a specific file within the result/output/ directory.

Note: If you are running on an HPC system with a job scheduler like Slurm or PBS, ensure you allocate a large queue and sufficient memory (e.g., 120GB) for the job to complete successfully.

##### 3. Execution Commands
###### Run with 16 Processors
This command executes the MiniAMR application on 16 processors. The output is stored in result/output/miniamr_result16.txt.
```
mpirun  -np 16 singularity run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 6000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 2 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result16.txt
```
###### Run with 32 Processors
To run with 32 processors, use this command. The output will be saved to result/output/miniamr_result32.txt.
```
mpirun  -np 32 singularity run  --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --max_blocks 4000 --num_refine 4 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 2 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result32.txt
```
###### Run with 64 Processors
This command runs the application on 64 processors, with the output directed to result/output/miniamr_result64.txt.
```
mpirun -np 64 singularity run --bind result:/opt/result miniamr_latest.sif  /opt/miniAMR/openmp/miniAMR.x --num_refine 4 --max_blocks 4000 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 4 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 200 --comm_vars 2 > result/output/miniamr_result64.txt

```
#### 2. LULESH Application Guide
##### 1. Setup
First, create the necessary directory structure for your results. This command creates a result directory with input and output subdirectories.


```
mkdir -p result result/input/ result/output/
```
##### 2. LULESH Application

**Pulling the LULESH Image**
To get the LULESH image, run the following command. The if statement ensures the image is only downloaded if it doesn't already exist.
```
if ! [ -f lulesh_latest.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/lulesh
fi
```
**Execution Commands** 

Run LULESH with different numbers of processors. The -s flag specifies the cube size.
- Run with 8 processors (-s 2):
```
mpirun -n 8 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 2 > result/output/lulesh_result2_8.txt
```
- Run with 27 processors (-s 3):
```
mpirun -n 27 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 3 > result/output/lulesh_result3_27.txt
```
- Run with 64 processors (-s 4):
```
mpirun -n 64 singularity run lulesh_latest.sif /opt/LULESH/./lulesh2.0 -s 4 > result/output/lulesh_result4_64.txt
```
#### 3. miniVite Application Guide
##### 1. Setup
First, create the necessary directory structure for your results. This command creates a result directory with input and output subdirectories.


```
mkdir -p result result/input/ result/output/
```
##### 2.Pulling the miniVite Image

To get the miniVite image, run this command.
```
if ! [ -f minivite_1.1.sif ]; then
  singularity pull library://reproducibilitysc/reproducibility/minivite
fi
```
**Creating Input Data** 

The miniVite application requires an input file. This script will generate the neuron1024.bin file if it does not exist.
```
if ! [ -f result/input/neuron1024.bin ]; then
  chmod +x create_minivite_input_jobs.sh
  ./create_minivite_input_jobs.sh
fi
```
**Execution Commands**
Run miniVite with different numbers of processors.

- Run with 8 processors:


```
mpirun -n 8 singularity run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result8.txt
```
- Run with 32 processors:
```

mpirun -n 32 singularity run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result32.txt
```
- Run with 64 processors:
```
mpirun -n 64 singularity run --bind result:/opt/result  minivite_1.1.sif  /opt/miniVite/./miniVite -f /opt/result/input/neuron1024.bin > result/output/minivite_result64.txt
```

#### For reproducibility check:

check the output files from the result folder. 


**Comparison of miniAMR Applications Run on Different HPC Systems**
This table presents a comparison of the Number of Blocks at Level 4 for the miniAMR application across four different HPC systems (Jetstream2, ASC, UAHPC, and Pantarhei ). The data is organized by the number of MPI tasks and the maximum number of blocks allocated for each run.

| MPI Tasks	|Max Blocks	| Jetstream2 | ASC  | UAHPC |Pantarhei |
|-----------|-----------|-------------|------|-------|----------|
|16	        | 6000	    |  216        | 216	 | 216	 | 216      | 
| 32.       | 	4000	| 352   	  | 352	 | 352	 | 352      | 
| 64	    | 4000	    | 536	      | 536	 | 536	 | 536.     | 



**Comparison of Modularity Values of miniVite Applications Across Different HPC Systems**
This table presents a comparison of the Modularity Values for the miniVite application across four different HPC systems (Jetstream2, ASC, UAHPC, and Pantarhei ). The data is organized by the number of MPI tasks used in each run.

| MPI	| Jetstream2 | ASC        | UAHPC.    |Pantarhei  |
|-------|-------------|------------|-----------|-----------|
| 8	    | 0.0153565	  | 0.0153565  | 0.0153565 | 0.0153565 | 
| 32	| 0.0153565	  | 0.0153565  | 0.0153565 | 0.0153565 | 
| 64	| 0.0153565   | 0.0153565  | 0.0153565 | 0.0153565 | 

**Comparison of Final Energy Levels of LULESH Application Across Different HPC Systems**
This table presents a performance comparison of the LULESH miniapp, a proxy for hydrodynamics applications, across four different HPC systems (Jetstream2, ASC, UAHPC, and Pantarhei ). The data shows the Final Energy Level achieved for three different problem sizes, each run with a corresponding number of MPI tasks.
| Problem Size | 	MPI Tasks|	Iteration Count| Jetstream2 | ASC  | UAHPC |Pantarhei |
|--------------|-------------|-----------------|-------------|------|-------|----------|
|2.            |	8	     | 45	           | 5.55        |5.55  |  5.55 | 5.55     |
|3	           |  27	     |          196	   | 22.2	     | 22.2	|22.2 	|   22.2   |
|4	           |64	         |434	           |63.8	     |63.8	|63.8	|63.8.     |

