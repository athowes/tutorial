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

# Credit card mask

def maskify(cc):
    mask = "#" * (len(cc) - 4)
    end = cc[-4:]
    return(mask + end)

# Duplicate encoder

def duplicate_encode(word):
    word = str.lower(word)
    out = ""
    for i in range(0, len(word)):
        if(word[i] in word[: i] + word[i + 1:]):
          out = out + ")"
        else:
          out = out + "("
    return(out)

# Playing with digits

def dig_pow(n, p):
    n_str = str(n)
    sum = 0
    for d in n_str:
        sum = sum + int(d)**p
        print(sum)
        p = p + 1
  
    if(sum % n == 0):
        return sum / n
    else:
        return -1

# Sum of two lowest positive integers

def sum_two_smallest_numbers(numbers):
    min_two = sorted(numbers)[0:2]
    return(min_two[0] + min_two[1])

# Regex validate PIN code

def validate_pin(pin):
    if(not len(pin) in [4, 6]):
        return(False)
    try:
        pin_int = int(pin)
    except ValueError:
        return False
    if(pin_int < 0):
        return False
    return(True)
  
# Mumbling

def accum(st):
    out = ""
    i = 1
    for d in st:
      out = out + "-" + d.upper() + d.lower() * (i - 1)
      i = i + 1
    return(out[1:])

# Sort the odd

def sort_array(source_array):
    odd_indices = [i for i, j in enumerate(source_array) if j % 2 == 1]
    sorted_odd = sorted([source_array[i] for i in odd_indices])
    for i, sorted_odd in zip(odd_indices, sorted_odd):
      source_array[i] = sorted_odd
    return(source_array)

# Is this a triangle?

def is_triangle(a, b, c):
    if(a <= 0 or b <= 0 or c <= 0):
      return False
    sides = sorted([a, b, c])
    return sides[0] + sides[1] > sides[2]
