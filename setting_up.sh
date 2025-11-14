#!/bin/bash

module load rclone/1.68.1

# name of sample I'm working with (e.g., Melanotaenia_RR)
SAMPLE_ID=""

# name of github branch to pull files from, file paths to put them into (e.g., m_RR)
BRANCH=""

#create directories in /scratch
mkdir /scratch/pawsey1132/atims/curationpretext/${BRANCH}/hic -p
mkdir /scratch/pawsey1132/atims/curationpretext/${BRANCH}/hifi
mkdir /scratch/pawsey1132/atims/curationpretext/${BRANCH}/scaffolds
mkdir /scratch/pawsey1132/atims/curationpretext/${BRANCH}/results
mkdir /scratch/pawsey1132/atims/curationpretext/${BRANCH}/work

#create directory in home
mkdir ~/curationpretext/${SAMPLE_ID} -p

#symlink together
ln -s /scratch/pawsey1132/atims/curationpretext/${BRANCH}/hic ~/curationpretext/${BRANCH}/hic
ln -s /scratch/pawsey1132/atims/curationpretext/${BRANCH}/hifi ~/curationpretext/${BRANCH}/hifi
ln -s /scratch/pawsey1132/atims/curationpretext/${BRANCH}/scaffolds ~/curationpretext/${BRANCH}/scaffolds
ln -s /scratch/pawsey1132/atims/curationpretext/${BRANCH}/results ~/curationpretext/${BRANCH}/results
ln -s /scratch/pawsey1132/atims/curationpretext/${BRANCH}/work ~/curationpretext/${BRANCH}/work


### pull files from acacia

# hic files
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/reads/hic/${SAMPLE_ID}.cram ~/curationpretext/${BRANCH}/hic/
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/reads/hic/${SAMPLE_ID}.cram.crai ~/curationpretext/${BRANCH}/hic/
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/reads/hic/${SAMPLE_ID}.flagstat ~/curationpretext/${BRANCH}/hic/

#hifi files
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/reads/hifi/${SAMPLE_ID}_ccs_reads.fasta.gz ~/curationpretext/${BRANCH}/hifi/

# scaffold files
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/sanger_tol/${SAMPLE_ID}.hifiasm-hic.v1/scaffolding_hap1/yahs/out.break.yahs/hap1_scaffolds_final.fa ~/curationpretext/${BRANCH}/scaffolds/
rclone copy pawsey1132:pawsey1132.afgi.assemblies/${SAMPLE_ID}/results/sanger_tol/${SAMPLE_ID}.hifiasm-hic.v1/scaffolding_hap2/yahs/out.break.yahs/hap2_scaffolds_final.fa ~/curationpretext/${BRANCH}/scaffolds/


### merge hap1 and hap2 scaffolds
sed 's/>/>HAP1_/g' ~/curationpretext/${BRANCH}/scaffolds/hap1_scaffolds_final.fa > ~/curationpretext/${BRANCH}/scaffolds/both_haps_scaffolds_final.fa
sed 's/>/>HAP2_/g' ~/curationpretext/${BRANCH}/scaffolds/hap2_scaffolds_final.fa >> ~/curationpretext/${BRANCH}/scaffolds/both_haps_scaffolds_final.fa

### download files

# download run_curationpretext file
wget https://raw.githubusercontent.com/amytims/atol_treeval_testing/refs/heads/${BRANCH}/run_curationpretext.sh -O ~/curationpretext/${BRANCH}/run_curationpretext.sh

# download config file
wget https://raw.githubusercontent.com/amytims/atol_treeval_testing/refs/heads/${BRANCH}/curationpretext_nf.config -O ~/curationpretext/${BRANCH}/curationpretext_nf.config