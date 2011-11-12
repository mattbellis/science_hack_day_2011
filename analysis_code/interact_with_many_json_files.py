#!/usr/bin/env python

import sys
import json

################################################################################
# main
################################################################################
def main():

    ############################################################################
    # Get a list of all the files on the command line.
    # Note we index at 1, to not read in this python script
    ############################################################################
    files = sys.argv[1:-1]

    # If only one JSON file was read in, make sure we put it in a list.
    if len(sys.argv)==2:
        files = [sys.argv[1]]

    # Loop over all the files
    for filename in files:

        #print filename
        f = open(filename)
        x = json.load(f)

        # Add up the total energy in all the jets for a given
        # event.
        jets = x["Collections"]["Jets_V1"]
        total = 0
        for j in jets:
            total += j[0] # First entry is the energy of the jet.
            print "energy: %f" % (j[0])
        print "Total: %f" % (total)

################################################################################
# Top-level script evironment
################################################################################
if __name__ == "__main__":
    main()

