#!/bin/sh
# Jake Yeung
# 3-cat_beds.sh
#  
# 2023-08-17

indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes"
outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes/merged"
tmpdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/tmp"
outf="${outdir}/all_motifs_intersect_with_TSS.bed.gz"

conda activate scmo2022
zcat ${indir}/*.bed.gz | sort -T ${tmpdir}  -k1,1 -k2,2n | bgzip > $outf
