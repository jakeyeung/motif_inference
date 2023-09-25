#!/bin/sh
# Jake Yeung
# 2-split_fasta.sh
#  
# 2023-05-30

fastaftmp=$1
fastasplitdirtmp=$2 # recommend $scratchmain/fastasplit
str=$3 # ">>${str}_"
prefix=">>${str}_"
# ## BEGIN SPLIT BEDS ##
[[ ! -e $fastaftmp ]] && echo "$fastaftmp not found, exiting" && exit 1

# fastasplitdirtmp="$scratchmain/fastasplit"

# if [ ! -d $fastasplitdirtmp ]
# then
    [[ ! -d $fastasplitdirtmp ]] && mkdir $fastasplitdirtmp
    [[ ! -d $fastasplitdirtmp ]] && echo "$fastasplitdirtmp not found, exiting" && exit 1

    # use same number as in dhs_merged_tissue
    # n=60000 # works for H3K4me1 and H3K4me3
    n=10000  # must be EVEN number because fasta
    rem=$(( $n % 2 ))
    if [ $rem -eq 0 ]
    then
      echo "Even number check: $n is OK!"
    else
      echo "Even number check: $n is NOT OK... exiting!"
      exit 1
    fi

    # make into motevo format also
    fastabase=$(basename $fastaftmp)
    sed "s/>/${prefix}/" $fastaftmp | split --lines=$n - $fastasplitdirtmp/$fastabase.
# else
#         echo "fastasplitdirtmp $fastasplitdirtmp exists, skipping the split"
# fi
# after splitting, create a flag file
fastadone="$fastasplitdirtmp" > $fastasplitdirtmp/split_files.log
## END SPLIT BEDS ##

