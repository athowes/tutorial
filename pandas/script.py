import numpy as np
import pandas as pd

# Two basic classes for handling data:
# * Series
# * DataFrame

s = pd.Series([1, 3, 5, np.nan, 6, 8])
s

dates = pd.date_range("20130101", periods = 6)
dates

df = pd.DataFrame(np.random.randn(6, 4), index = dates, columns = list("ABCD"))
df

df2 = pd.DataFrame(
  {
    "A": 1.0,
    "B": pd.Timestamp("20130102"),
    "C": pd.Series(1, index = list(range(4)), dtype = "float32"),
    "D": np.array([3] * 4, dtype = "int32"),
    "E": pd.Categorical(["test", "train", "test", "train"]),
    "F": "foo",
  }
)

df2.dtypes

df.head()
df.tail(3)

# What is the index of a df?
df.index

df.columns

# DataFrames have one dtype per column, whereas NumPy arrays have just on dtype
# Conversion will involve changing dtype to something quite general e.g. object
df.to_numpy()
df2.to_numpy()

df.describe()

# Why doesn't this have a ()?
df.T

# What does the axis here mean?
df.sort_index(axis = 1)

df.sort_values(by = "B")

# Standard Python and NumPy expressions work for selecting and setting
# For production code, they recommend optimised pandas data access methods

df.A
df["A"]

# Single labels look like they do columns
df[0:3]
df["20130102":"20130104"]

# Selection by label
df.loc[dates[0]]

# So this works a bit similar to R with the [ , ]
df.loc[:, ["A", "B"]]

df.loc["20130102":"20130104", ["A", "B"]]

df.loc[dates[0], "A"]
df.at[dates[0], "A"]

# Can also select by postion (using zero indexing)
df.iloc[3]
df.iloc[3:5, 0:2]
df.iloc[[1, 2, 4], [0, 2]]
df.iloc[1:3]
df.iloc[1:3, :] # Equivalent to the above
df.iloc[:, 1:3]







