#!/bin/sh
# Jake Yeung
# 1-run.make_sitecount_matrix_from_bed.sh
#  
# 2023-06-20

rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/make_sitecount_matrix_from_bed.R"

outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/sitecount_matrix"

jscale=0
jcenter=0
byrow=0

# inf=$1
# inf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.cutoff_0.35.bed"
# inf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.top_30000.bed"
# inf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.bed"
inf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.cutoff_0.35.bed"
[[ ! -e $inf ]] && echo "$inf not found, exiting" && exit 1
outf=${outdir}/"sitecount_matrix_cortex.all_peaks_cutoff_0.35.txt"

module load R/4.1.2; Rscript $rs $inf $outf --scale $jscale --center $jcenter
