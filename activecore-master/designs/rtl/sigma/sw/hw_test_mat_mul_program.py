# -*- coding:utf-8 -*-
from __future__ import division

import sys

sys.path.append('../../udm/sw')
import udm
from udm import *

import sigma
from sigma import *


udm = udm('COM7', 921600)
print("")

sigma = sigma(udm)

# firmware_filename = 'C:/Users/admin/Desktop/activecore-master/designs/rtl/sigma/sw/apps/matrix_mul.riscv'
firmware_filename = 'C:/Users/admin/Desktop/activecore-master/designs/rtl/sigma/sw/apps/mat_mul_coproc_driver.riscv'



verify_data = [24994, 28789, 17417, 24949, 40703, 25665, 27296, 15495, 16750,
               21324, 10940, 15010, 18181, 15905, 19647, 13777, 28427, 29172,
               21017, 27541, 46756, 27605, 28418, 20925, 23519, 29709, 20644,
               19297, 39415, 26864, 26221, 18544, 25603, 26604, 14573, 25544,
               32623, 25146, 25883, 18710, 22844, 24666, 14835, 19035, 35031, 
               23231, 22188, 15153, 20716, 26578, 17000, 17720, 30303, 22788, 
               23657, 17158, 24748, 28998, 23277, 22103, 43312, 26322, 26803, 
               20607]

sigma.hw_test_generic(sigma, "MAT_MUL", firmware_filename, 0.1, verify_data)

print(sigma.tile.udm.rdarr32(0x6000, len(verify_data)),'\n')

udm.disconnect()
