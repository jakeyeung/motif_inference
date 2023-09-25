# Jake Yeung
# sum_across_genes.R
# 2023-08-16
# DESCRIPTION
#
#     Sum across genes  given bed intersectfile
#
# FOR HELP
#
#     Rscript sum_across_genes.R --help
#
# AUTHOR:      Jake Yeung (jake.yeung@epfl.ch)
# LAB:         Computational Systems Biology Lab (http://naef-lab.epfl.ch)
# CREATED ON:  2023-08-16
# LAST CHANGE: see git log
# LICENSE:     MIT License (see: http://opensource.org/licenses/MIT)

suppressPackageStartupMessages(library("argparse"))
library(dplyr)
library(data.table)

# create parser object
parser <- ArgumentParser()

# specify our desired options
# by default ArgumentParser will add an help option

parser$add_argument('-infile', metavar='INFILE',
                                            help='Input .bed.gz file')
parser$add_argument('-outfile', metavar='OUTFILE',
                                            help='Output .bed.gz file zipped, summed across genes')
parser$add_argument('-motifname', metavar='string',
                                            help='Name of motif')
parser$add_argument("-v", "--verbose", action="store_true", default=TRUE,
                        help="Print extra output [default]")

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults,
args <- parser$parse_args()

# print some progress messages to stderr if "quietly" wasn't requested
if ( args$verbose ) {
    print("Arguments:")
    print(args)
}

cnames <- c("Chromo", "Start", "End", "Gene", "ChromoB", "StartB", "EndB", "Peak", "Sitecount")
dat <- fread(args$infile, header = FALSE, col.names = cnames)
dat.sum <- dat %>%
		group_by(Chromo, Start, End, Gene) %>%
		summarise(Motif = args$motifname, 
				  Sitecount = sum(Sitecount))

fwrite(dat.sum, file = args$outfile, col.names = FALSE, sep = "\t", compress = "gzip") 

