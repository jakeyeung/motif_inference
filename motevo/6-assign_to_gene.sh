#!/bin/sh
# Jake Yeung
# 6-assign_to_gene.sh
#  
# 2023-06-08

# Assign gene to bed
# assignscript="/Home/jyeung/projects/tissue_specificity_hogenesch_shellscripts/merged_dhs/assign_nearest_gene_bed.py"
# assignscript="/home/hub_oudenaarden/jyeung/projects/from_PhD/tissue-specificity-shellscripts/merged_dhs/assign_nearest_gene_bed.py"
# assignscript="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/assign_nearest_gene_bed.py"
assignscript=$1
[[ ! -e $assignscript ]] && echo "$assignscript not found, exiting" && exit 1

windowsf=$2

# output dir
motevodirtmpbed=$3

# motevodirtmpbase=$4

# motevodirtmpclosest=$motevodirtmpbase/closestbed_multiple_genes
motevodirtmpclosest=$4

outlog="${motevodirtmpclosest}/assign_gene_log.out"

# check input dirs and files
[[ ! -d $motevodirtmpbed ]] && echo "$motevodirtmpbed not found, exiting" && exit 1  # output dir
[[ ! -e $windowsf ]] && echo "$windowsf not found, exiting" && exit 1  # our ref bed
# # nohupdir="/scratch/el/monthly/jyeung/nohups/motevo_assign_nearestmulti"
# nohupdir="$scratchmain/nohups_motevo_assign_nearestmulti"
nohupdir=${motevodirtmpclosest}/nohups

[[ ! -e $assignscript ]] && echo "$assignscript not found, exiting" && exit 1
[[ ! -d $motevodirtmpbed ]] && echo "$motevodirtmpbed not found, exiting" && exit 1
[[ ! -d $motevodirtmpclosest ]] && mkdir $motevodirtmpbedclosest
[[ ! -d $nohupdir ]] && mkdir $nohupdir

jmem="10G"
jtime="2:00:00"

for inbed in `ls -d $motevodirtmpbed/*.bed`; do
	base=$(basename $inbed)	
	bedout=$motevodirtmpclosest/${base%%.*}.closestmulti.bed
	[[ -e $bedout ]] && echo "$bedout found, continuing" && continue
	# bsub -o $nohupdir/$base.out -e $nohupdir/$base.err -M 10000000 "python $assignscript $inbed $windowsf $bedout --has_motevo_id --save_pickle"
    BNAME=$nohupdir/$base
	# echo "python $assignscript $inbed $windowsf $bedout --has_motevo_id --save_pickle" | qsub -l h_rt=${jtime} -l h_vmem=${jmem} -o ${BNAME}.out -e ${BNAME}.err -N MOTEVO
	cmd="python $assignscript $inbed $windowsf $bedout --has_motevo_id --save_pickle"
    sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --job-name=MOTEVO --wrap "$cmd" 
done

# wait for jobs
while [[ `squeue -u jyeung | grep MOTEVO |  wc -l` > 0 ]]; do
        echo "sleep for 60 seconds"
        sleep 60
done

echo "Finished assigning gene to bed" > $outlog
