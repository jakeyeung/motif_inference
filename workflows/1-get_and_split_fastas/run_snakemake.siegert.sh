#!/bin/sh
# Jake Yeung
# run_snakemake.sh
#  
# 2023-05-31

# indir="/hpc/hub_oudenaarden/jyeung/data/dblchic/simulation_data"
indir="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/workflows/1-get_and_split_fastas"
cd $indir

conda init bash; conda activate motevo; snakemake --cluster-config cluster.json --cluster "sbatch --time={cluster.time} --mem-per-cpu={cluster.mem} --cpus-per-task={cluster.N}" --jobs 50 --latency-wait 60

