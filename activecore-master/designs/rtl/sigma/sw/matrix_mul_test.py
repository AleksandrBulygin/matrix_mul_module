# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28 13:20:31 2022

@author: admin
"""

# -*- coding:utf-8 -*-
from __future__ import division

import sys

sys.path.append('../../udm/sw')
import udm
from udm import *

import sigma
from sigma import *



def matrix_test_generic(sigma, test_name, firmware_filename, sleep_secs, verify_data):
    print("#### " + test_name + " TEST STARTED ####");
    
    print("Clearing buffer")
    udm.clr(0xc0000208, 64)
    
    print("Loading test program...")
    sigma.tile.loadelf(firmware_filename)
    print("Test program written!")

    time.sleep(sleep_secs)
    
    print("Reading data buffer...")
    rdarr = sigma.tile.udm.rdarr32(0xc0000208, len(verify_data))
    print("Data buffer read!")

    test_succ_flag = 1
    for i in range(len(verify_data)):
        if (verify_data[i] != rdarr[i]):
            test_succ_flag = 0
            print("Test failed on data ", i, "! Expected: ", hex(verify_data[i]), ", received: ", hex(rdarr[i]))
    
    if (test_succ_flag):
        print("#### " + test_name + " TEST PASSED! ####");
    else:
        print("#### " + test_name + " TEST FAILED! ####")
    
    print("")
    return test_succ_flag




udm = udm('COM11', 921600)
print("")

verify_data = [24994, 28789, 17417, 24949, 40703, 25665, 27296, 15495, 16750,
               21324, 10940, 15010, 18181, 15905, 19647, 13777, 28427, 29172,
               21017, 27541, 46756, 27605, 28418, 20925, 23519, 29709, 20644,
               19297, 39415, 26864, 26221, 18544, 25603, 26604, 14573, 25544,
               32623, 25146, 25883, 18710, 22844, 24666, 14835, 19035, 35031, 
               23231, 22188, 15153, 20716, 26578, 17000, 17720, 30303, 22788, 
               23657, 17158, 24748, 28998, 23277, 22103, 43312, 26322, 26803, 
               20607]

firmware_filename = "C:/Users/admin/Desktop/activecore-master/designs/rtl/sigma/sw/apps/mat_mul_driver.riscv"
sigma = sigma(udm)

matrix_test_generic(sigma,"MAT_MUL", firmware_filename, 0.01, verify_data)

print(sigma.tile.udm.rdarr32(0xc0000208, len(verify_data)))

udm.disconnect()
