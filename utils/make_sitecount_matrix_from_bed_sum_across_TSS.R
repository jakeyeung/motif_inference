# Jake Yeung
# make_sitecount_matrix_from_bed.R
# 2019-02-04
# DESCRIPTION
# 
#     Make sitecount matrix from bed. Loads up 20 GBs of data??
# 
# FOR HELP
# 
#     Rscript make_sitecount_matrix_from_bed.R --help
# 
# AUTHOR:      Jake Yeung (j.yeung@hubrecht.eu)
# LAB:         Quantitative Biology Lab (https://www.hubrecht.eu/research-groups/van-oudenaarden-group/)
# CREATED ON:  2019-02-04
# LAST CHANGE: see git log
# LICENSE:     MIT License (see: http://opensource.org/licenses/MIT)

jstart <- Sys.time()

library(data.table)
library(dplyr)
library(Matrix)

suppressPackageStartupMessages(library("argparse"))

# create parser object
parser <- ArgumentParser()

# specify our desired options 
# by default ArgumentParser will add an help option 

parser$add_argument('infile', metavar='INFILE',
                                            help='In bed ~20 GB? 8 Columns. No strand')
parser$add_argument('outfile', metavar='OUTFILE',
                                            help='Out sitecount matrix')
parser$add_argument('--scale', metavar="TRUE or FALSE", type = "integer", 
                    default=0, help="Scale matrix?")
parser$add_argument('--AddIntercept', metavar="TRUE or FALSE", type = "integer", 
                    default=0, help="Make first column a column of 1s if add intercept. Default FALSE")
parser$add_argument('--center', metavar="TRUE or FALSE", type = "integer", 
                    default=0, help="Center matrix?")
parser$add_argument('--byrow', action="store_true", 
                    default=FALSE, help="Also normalize matrix by row")
parser$add_argument("-v", "--verbose", action="store_true", default=TRUE,
                        help="Print extra output [default]")
                                        
# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()

# change int to logical
args$scale <- as.logical(args$scale)
args$center <- as.logical(args$center)
args$AddIntercept <- as.logical(args$AddIntercept)

# print some progress messages to stderr if "quietly" wasn't requested
if ( args$verbose ) { 
    print("Arguments:")
    print(args)
}

print("Reading input...")
dat <- fread(args$infile, header=FALSE)
if (ncol(dat) == 8){
  colnames(dat) <- c("chromo", "start", "end", "motif", "sitecount", "gene", "dist", "peak")
} else if (ncol(dat) == 6){
  print("Detected 6 columns, assume 4th, 5th, 6th columns are gene, motif, sitcount. Gene is 'peak' in this case.")
  colnames(dat) <- c("chromo", "start", "end", "peak", "motif", "sitecount")
}
print("Reading input... done")

print(head(dat))

dat.sum <- dat %>% group_by(peak, motif) %>% summarise(nsites = length(sitecount), sitecount = sum(sitecount))

dat.mat <- as.data.frame(tidyr::spread(subset(dat.sum, select = -c(nsites)), motif, sitecount, fill=0))

Gene.ID <- dat.mat$peak
rownames(dat.mat) <- dat.mat$peak; dat.mat$peak <- NULL


if (args$center == TRUE | args$scale == TRUE){
  dat.mat <- scale(dat.mat, center=args$center, scale=args$scale)
}

if (args$byrow){
  dat.mat <- t(scale(t(dat.mat), center=args$center, scale=args$scale))
}


dat.mat <- as.data.frame(dat.mat)

if (args$AddIntercept){
  xcol <- rep(1, nrow(dat.mat))
  cnames.orig <- colnames(dat.mat)
  dat.mat <- cbind(xcol, dat.mat)
  cnames.new <- c("intercept", cnames.orig)
  colnames(dat.mat) <- cnames.new
}

dat.mat <- cbind(Gene.ID, dat.mat)


print(head(dat.mat))
print(dim(dat.mat))
# write to output
data.table::fwrite(dat.mat, file = args$outfile, sep="\t")

print(Sys.time() - jstart)

