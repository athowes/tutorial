import polars as pl
from datetime import datetime

df = pl.DataFrame({
        "integer": [1, 2, 3],
        "date": [
            datetime(2022, 1, 1),
            datetime(2022, 1, 2),
            datetime(2022, 1, 3),
        ],
        "float": [4.0, 5.0, 6.0],
})

print(df)

# Following
# https://www.emilyriederer.com/post/py-rgo-polars/

df = pl.DataFrame({"a": [1, 1, 2, 2], 
                   "b": [3, 4, 5, 6], 
                   "c": [7, 8, 9, 0]})

df.head()

# with_columns is like dplyr mutate

df.with_columns(
  b_plus_c = pl.sum_horizontal(pl.col("b"), pl.col("c"))
)

import polars.selectors as cs

df = df.with_columns(pl.col("a").cast(pl.Utf8))

# select is like dplyr select

df.select(cs.starts_with("b") | cs.string())

# ~ is for negative rather than -

df.select(~cs.string())
