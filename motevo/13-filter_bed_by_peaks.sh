#!/bin/sh
# Jake Yeung
# 13-filter_bed_by_peaks.sh
#  
# 2023-06-21

ps="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/filter_bed_by_peaks.py"

infile="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.bed"

peaklist="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/cistopic_outputs/top_30000_peaks.txt"

outfile="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.top_30000.bed"

python $ps -infile $infile -peaklist $peaklist -outfile $outfile
