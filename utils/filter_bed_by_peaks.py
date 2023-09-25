#!/usr/bin/env python
'''
DESCRIPTION

    Filter bed by peaks

FOR HELP

    python filter_bed_by_peaks.py --help

AUTHOR:      Jake Yeung (jake.yeung@epfl.ch)
LAB:         Computational Systems Biology Lab (http://naef-lab.epfl.ch)
CREATED ON:  2023-06-21
LAST CHANGE: see git log
LICENSE:     MIT License (see: http://opensource.org/licenses/MIT)
'''

import sys, argparse, datetime
import csv


def main():
    parser = argparse.ArgumentParser(description='Filter bed by peaks')
    parser.add_argument('-infile', metavar='INFILE',
                        help='Input bed (not gz)')
    parser.add_argument('-peaklist', metavar='peaklist',
                        help='List of peaks to filter')
    parser.add_argument('-outfile', metavar='OUTFILE',
                        help='Output bed (not gz)')
    parser.add_argument('--quiet', '-q', action='store_true',
                        help='Suppress some print statements')
    args = parser.parse_args()

    # store command line arguments for reproducibility
    CMD_INPUTS = ' '.join(['python'] + sys.argv)    # easy printing later
    # store argparse inputs for reproducibility / debugging purposes
    args_dic = vars(args)
    ARG_INPUTS = ['%s=%s' % (key, val) for key, val in args_dic.items()]
    ARG_INPUTS = ' '.join(ARG_INPUTS)

    # Print arguments supplied by user
    if not args.quiet:
        print(datetime.datetime.now().strftime('Code output on %c'))
        print('Command line inputs:')
        print(CMD_INPUTS)
        print ('Argparse variables:')
        print(ARG_INPUTS)

    peaklist = set()

    with open(args.peaklist, "rt") as pf:
        peakreader = csv.reader(pf, delimiter = "\t")
        for peakrow in peakreader:
            peak = peakrow[0]
            peaklist.add(peak)

    with open(args.infile, "rt") as f, open(args.outfile, "wt") as outf:
        reader = csv.reader(f, delimiter = "\t")
        writer = csv.writer(outf, delimiter = "\t")
        for row in reader:
            peak = row[7]  # chr2:58476894-58477394
            # sitecount = float(row[4]) # 0.412183
            if not peak in peaklist:
                continue
            else:
                writer.writerow(row)

if __name__ == '__main__':
    main()
