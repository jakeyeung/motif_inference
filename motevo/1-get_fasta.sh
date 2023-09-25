#!/bin/sh
# Jake Yeung
# 1-get_fasta_run_motevo_general.sh
#  
# 2023-05-30

windowsf=$1
windowsnoext=$2
fastaref=$3
fastadirtmp=$4 # recommend: $scratchmain/fasta 
wmdir=$5
bedtoolsbin=$6

# wmdir="/hpc/hub_oudenaarden/jyeung/data/databases/WMs/SwissRegulon/mm10_weight_matrices_v2_split"
# wmdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/public_data/WMs/SwissRegulon"
[[ ! -d $wmdir ]] && echo "$wmdir not found, exiting" && exit 1

# sitecountscript="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/calculate_sitecount.sbatch.py"
# sitecountscript="/nfs/scistore12/hpcgrp/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/calculate_sitecount.sbatch.py"
# [[ ! -e $sitecountscript ]] && echo "$sitecountscript not found, exiting" && exit 1
# motevobin="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/software/motevo_ver1.12/source/motevo"

# windowsf="/hpc/hub_oudenaarden/jyeung/data/zebrafish_scchic/hiddendomains_outputs.FromR/hd_merged.${jmark}.minlength_1000/merged.${jmark}.minlength_${minlength}.cutoff_analysis.merged.withchr.annotated.bed"
# windowsf="/hpc/hub_oudenaarden/jyeung/data/scChiC/from_rstudioserver/tables_H3K9me3_dynamic_bins/coords_H3K9me3_dynamic_bins.bed"
# windowsf="/hpc/hub_oudenaarden/jyeung/data/scChiC/from_rstudioserver/tables_H3K9me3_dynamic_bins/coords_H3K9me3_dynamic_bins.noname.2021-01-28.annotated.bed"
# windowsf="/hpc/hub_oudenaarden/jyeung/data/scChiC/from_rstudioserver/tables_top_6085_four_marks_dynamic_bins/top_6085.${jmark}.2021-02-17.annotated.bed"
# windowsf="/hpc/hub_oudenaarden/jyeung/data/scChiC/raw_data/ZellerRawData_B6_All_MergedByMarks_final.hiddenDomains_output/hd_merged.H3K4me3.minlength_1000/merged.H3K4me3.minlength_1000.cutoff_analysis.merged.withchr.annotated.test.bed"
[[ ! -e $windowsf ]] && echo "$windowsf not found, exiting" && exit 1

# windowsbname=$(basename $windowsf)
# windowsnoext=${windowsbname%.*}

[[ ! -e $fastaref ]] && echo "$fastaref not found, exiting" && exit 1

## BEGIN GET FASTA ##
# fastadirtmp=$scratchmain/fasta
[[ ! -d $fastadirtmp ]] && mkdir $fastadirtmp

flagfile=$fastadirtmp/get_fasta.log

# fname=${windowsbname%%.*}
fastaftmp=$fastadirtmp/$windowsnoext.fa
[[ ! -e $fastaftmp ]] && $bedtoolsbin getfasta -fi $fastaref -bed $windowsf | awk 'NR % 2 { print } !(NR % 2) {print toupper($0)}' > $fastaftmp && ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: getfasta failed" && exit 1

## END GET FASTA ##

echo "${fastaftmp}" > $flagfile
