#!/bin/sh
# Jake Yeung
# 9-reannotate_distance_on_bed.sh
#  
# 2023-06-09

# rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/annotate_distance_on_bed.R"
rs=$1
[[ ! -e $rs ]] && echo "$rs not found, exiting" && exit 1

inf=$2 # expect .gz ending
echo $inf
bname=$(basename $inf)

suffix=".gz"

if [[ ${bname} == *$suffix ]]; then
  echo "String ${bname} ends with given suffix $suffix."
		bname2=${bname%.*}
		bname2=${bname2%.*}
else
 		echo "String ${bname} does not end with given suffix $suffix."
		bname2=${bname%.*}
fi

outf=$inmain/${bname2}.reannotated.bed
outfzip=$inmain/${bname2}.reannotated.bed.gz
[[ ! -e $inf ]] && echo "$inf not found, exiting" && exit 1

module load R/4.1.2; Rscript $rs $inf $outf
bgzip $outf > $outfzip
