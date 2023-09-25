# motif_inference

## Set up conda

conda create -n motevo python=3.5

conda install -c conda-forge mamba snakemake bedtools numpy argparse --yes

# https://github.com/merenlab/anvio/issues/1479
conda install -c bioconda samtools=1.9 

conda config --add channels r
conda config --add channels bioconda
conda install pysam

