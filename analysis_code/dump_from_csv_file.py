#!/usr/bin/env python

import sys
import csv
from math import *

import matplotlib.pyplot as plt
import pylab as pylab
import numpy as np

################################################################################
# Calculate the magnitude of a three-vector
################################################################################
def magnitude_of_3vec(v3):

    magnitude = sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])

    return magnitude

################################################################################
# Calculate the mass of a particle using Classical Physics
################################################################################
def mass_from_classical_physics(v4):

    pmag = magnitude_of_3vec(v4[1:4])

    mass = pmag*pmag/(2.0*v4[0])

    return mass

################################################################################
# Calculate the mass of a particle using Special Relativity
################################################################################
def mass_from_special_relativity(v4):

    pmag = magnitude_of_3vec(v4[1:4])

    mass_squared = v4[0]*v4[0] - pmag*pmag

    if mass_squared>0:
        return sqrt(mass_squared)
    else:
        return -sqrt(abs(mass_squared))

################################################################################
# main
################################################################################
def main():

    filename = sys.argv[1]

    # Open the file, assuming it's a .csv file.
    infile = csv.reader(open(filename, 'rb'), delimiter=',', quotechar='#')

    # Declare some arrays to hold the mass if it is calculated using classical physics
    # or special relativity.
    mass_cp = []
    mass_sr = []

    for row in infile:

        # Skip the first row, which is a header
        if infile.line_num>1:

            # Grab the energy-momentum 4-vector for the first muon.
            energy_0 = float(row[3])
            px_0 = float(row[4])
            py_0 = float(row[5])
            pz_0 = float(row[6])

            muon0 = [energy_0, px_0, py_0, pz_0]

            # Grab the energy-momentum 4-vector for the second muon.
            energy_1 = float(row[11])
            px_1 = float(row[12])
            py_1 = float(row[13])
            pz_1 = float(row[14])

            muon1 = [energy_1, px_1, py_1, pz_1]

            combined_muons = [energy_0+energy_1, px_0+px_1, py_0+py_1, pz_0+pz_1]

            mass0 = mass_from_classical_physics(combined_muons)
            mass1 = mass_from_special_relativity(combined_muons)

            if mass0<1000 and mass1<1000:

                #print mass0
                print mass1


################################################################################
# Top-level script evironment
################################################################################
if __name__ == "__main__":
    main()


