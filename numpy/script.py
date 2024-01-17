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
g = np.empty((2, 3)) # random

# Sequences of numbers with arange
h = np.arange(10, 30 , 5)

# With floats it's difficult to predict number of elements obtained
# Better to use linspace

i = np.linspace(0, 2, 9)

# Printing arrays
a = np.arange(6)
print(a)

b = np.arange(12).reshape(4, 3)
print(b)

c = np.arange(24).reshape(2, 3, 4)
print(c)

# Basic operations

# Arithmetic operators on arrays apply elementwise

a = np.array([20, 30, 40, 50])
b = np.arange(4)

c = a - b

b ** 2

10 * np.sin(a)

a < 35


# * is elementwise, for matrix product use @ or dot (which is better?)

A = np.array([[1, 1], [0, 1]])
B = np.array([[2, 0], [3, 4]])

A * B
A @ B
A.dot(B)

# The operations += and *= act in place

rg = np.random.default_rng(1)
a = np.ones((2, 3), dtype = int)
b = rg.random((2, 3))

a *= 3
a

b += a

a += b

# If you work with arrays of different types, the resulting array will be of the more general (upcast)
