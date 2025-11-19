#!/bin/bash -l
#SBATCH --job-name=sangertol_curationpretext_guyu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4g
#SBATCH --time=23:59:00
#SBATCH --account=pawsey1132
#SBATCH --partition=work


SAMPLE_ID="MacquariaWujalwujalensis2976176"
BRANCH="guyu"

module load singularity/4.1.0-nohost
#module load nextflow/24.10.0

unset SBATCH_EXPORT

# Application specific commands:
set -eux

# where to put singularity files
if [ -z "${SINGULARITY_CACHEDIR}" ]; then
	export SINGULARITY_CACHEDIR=/software/projects/pawsey1132/atims/.singularity
	export APPTAINER_CACHEDIR="${SINGULARITY_CACHEDIR}"
fi

export NXF_APPTAINER_CACHEDIR="${SINGULARITY_CACHEDIR}/library"
export NXF_SINGULARITY_CACHEDIR="${SINGULARITY_CACHEDIR}/library"

## load the manual nextflow install
export PATH="${PATH}:/software/projects/pawsey1132/atims/assembly_testing/bin"
printf "nextflow: %s\n" "$( readlink -f $( which nextflow ) )"

# set the NXF home for plugins etc
export NXF_HOME="/software/projects/pawsey1132/atims/.nextflow"
export NXF_CACHE_DIR="/scratch/pawsey1132/atims/curationpretext/.nextflow"
export NXF_WORK="/scratch/pawsey1132/atims/curationpretext/${BRANCH}/work"
printf "NXF_HOME: %s\n" "${NXF_HOME}"
printf "NXF_WORK: %s\n" "${NXF_WORK}"

#PIPELINE_VERSION="b4d6dda"
#PIPELINE_VERSION='1.4.1'

PIPELINE_PARAMS=(
        "--sample" "${SAMPLE_ID}"
        "--outdir" "/scratch/pawsey1132/atims/curationpretext_test/${BRANCH}/results"
        "--input" "/scratch/pawsey1132/atims/curationpretext_test/${BRANCH}/scaffolds/both_haps_scaffolds_final.fa"
        "--reads" "/scratch/pawsey1132/atims/curationpretext_test/${BRANCH}/hifi/"
        "--cram" "/scratch/pawsey1132/atims/curationpretext_test/${BRANCH}/hic/"
        "--teloseq" "TTAGGG"
        "--aligner" "bwamem2"
        "--all_output" "true"
        "--skip_tracks" "NONE"
        "--split_telomere" "true"
        "-profile" "singularity,pawsey"
        "-c" "curationpretext_nf.config"
        "-r" "1.5.1"
        "--multi_mapping" "0"
        "--run_hires" "false"
)

# # check assembly pipeline before running
#nextflow \
#        -log "nextflow_logs/nextflow_inspect.$(date +"%Y%m%d%H%M%S").${RANDOM}.log" \
#        inspect \
#        -concretize sanger-tol/curationpretext \
#        "${PIPELINE_PARAMS[@]}"
#exit 0
 
# # run assembly pipeline
nextflow \
         -log "nextflow_logs/nextflow_run.$(date +"%Y%m%d%H%M%S").${RANDOM}.log" \
         run \
         sanger-tol/curationpretext \
         "${PIPELINE_PARAMS[@]}" #\
#         -resume
