import numpy as np

# Overview of arrays in NumPy
# An array can be n-dimensional (n >= 2)
# Goals:
# Understand the difference between one-, two- and n-dimensional arrays in NumPy;
# Understand how to apply some linear algebra operations to n-dimensional arrays without using for-loops;
# Understand axis and shape properties for n-dimensional arrays.

# The array class in NumPy is called ndarray

a = np.arange(15).reshape(3, 5)

# Dimensions of the array
a.shape

# Name of the type of elements in the array
a.dtype.name

# Product of the dimensions
a.size

# Why is this type() rather than .type?
type(a)

b = np.array([1.2, 3.5, 5.1])
type(b)
b.dtype

c = np.array([[1, 2], [3, 4]], dtype = complex)
c.dtype

# You can make arrays filled with placeholders so that you don't have to grow arrays

e = np.zeros((3, 4))
f = np.ones((2, 3, 4), dtype = np.int16)
