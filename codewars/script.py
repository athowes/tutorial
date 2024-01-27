# Multiples of 3 or 5

import math
import numpy as np

def solution(number):
    number = number - 0.001
    num_threes = math.floor(number / 3)
    num_fives = math.floor(number / 5)
    num_both = math.floor(number / 15)
    
    threes = np.arange(start = 0, stop = 3 * num_threes + 1, step = 3)
    fives = np.arange(start = 0, stop = 5 * num_fives + 1, step = 5)
    both = np.arange(start = 0, stop = 3 * 5 * num_both + 1, step = 3 * 5)
    
    return(sum(threes) + sum(fives) - sum(both))
