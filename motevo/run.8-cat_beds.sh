#!/bin/sh
# Jake Yeung
# run.8-cat_beds.sh
#  
# 2023-06-09

bs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/motevo/8-cat_beds.sh"

indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/closestbed_multiple_genes/long_format"
outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long"

bash $bs $indir $outdir
