# Reshaping Data

## Data Formats

Tidy data generally exist in two forms: wide data and long data. Both types of data are used and needed in data analysis. Fortunately, there are tools that can take you from wide-to-long and from long-to-wide. This makes it easy to work with any tidy data set. We'll discuss the basics of what wide and long data are and how to go back and forth between the two in Python. Getting data into the right format will be crucial later when summarizing data and visualizing it. To help you visualize data as its being reshaped, we recommend you play around with the [TidyDataTutor](https://tidydatatutor.com/vis.html).

### Wide Data

Wide data has a column for each variable and a row for each observation. Data are often entered and stored in this manner. This is because wide data are often easy to understand at a glance. For example, this is a wide data set.

| ID | LastName | FirstName | HeightInches | WeightLbs | Insulin | Glucose |
| -: | - | - | -: | -: | -: | -: |
| 1004 | Smith | Jane | 65 | 180 | 0.60 | 163 |
| 4587 | Nayef | Mohammed | 75 | 215 | 1.46 | 150 |
| 1727 | Doe | Janice | 62 | 124 | 0.72 | 177 |
| 6879 | Jordan | Alex | 77 | 160 | 1.23 | 205 |

This is a dataset we've looked at in a previous lesson. As discussed previously, it's a rectangular and tidy dataset. Now, we can also state that it is a wide dataset. Here you can clearly see what measurements were taken for each individual and can get a sense of how many individuals are contained in the dataset.

Specifically, each individual is in a different row with each variable in a different column. At a glance we can quickly see that we have information about four different people and that each person was measured in four different ways.

### Long Data

Long data, on the other hand, has one column indicating the type of variable contained in that row and then a separate row for the value for that variable. Each row contains a single observation for a single variable.  Below is an example of a long data set.

| ID | Variable | Value |
| -: | - | - |
| 1004 | LastName     | Smith |
| 1004 | FirstName    | Jane |
| 1004 | HeightInches | 65 |
| 1004 | WeightLbs    | 180 |
| 1004 | Insulin      | 0.60 |
| 1004 | Glucose      | 163 |
| 4587 | LastName     | Nayef |
| 4587 | FirstName    | Mohammed |
| 4587 | HeightInches | 75 |
| 4587 | WeightLbs    | 215 |
| 4587 | Insulin      | 1.46 |
| 4587 | Glucose      | 150 |
| 1727 | LastName     | Doe |
| 1727 | FirstName    | Janice |
| 1727 | HeightInches | 62 |
| 1727 | WeightLbs    | 124 |
| 1727 | Insulin      | 0.72 |
| 1727 | Glucose      | 177 |
| 6879 | LastName     | Jordan |
| 6879 | FirstName    | Alex |
| 6879 | HeightInches | 77 |
| 6879 | WeightLbs    | 160 |
| 6879 | Insulin      | 1.23 |
| 6879 | Glucose      | 205 |

This long dataset includes the exact same information as the previous wide dataset; it is just stored differently. It's harder to see visually how many different measurements were taken and on how many different people, but the same information is there.

While long data formats are less readable than wide data at a glance, they are a lot easier to work with during analysis. Most of the tools we'll be working with use long data. Thus, to go from how data are often stored (wide) to working with the data during analysis (long), we'll need to understand what tools are needed to do this and how to work with them.

### Reshaping data

Converting your data from wide-to-long or from long-to-wide data formats is referred to as **reshaping** your data. You can do this with the [`pandas``](https://pandas.pydata.org) package. In fact, we will use the pandas package for all of our data tidying, wrangling, and reshaping. As with most helpful Python packages, there is more functionality than what is discussed here, so feel free to explore the additional resources at the bottom to learn even more.

For these examples, we'll work with the [`relig_income`](https://tidyr.tidyverse.org/reference/relig_income.html)  dataset available in `tidyr`. The data in this dataset includes the income ranges and religions from the Pew religion and income survey. The following code downloads the data from GitHub and displays the first few rows using the [`head`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.head.html) method of the dataframe.

```python
import pandas as pd


url = "https://raw.githubusercontent.com/tidyverse/tidyr/main/data-raw/relig_income.csv"
relig_income = pd.read_csv(url)
relig_income.head()
```

Again, wide data are easy to decipher at a glance. We can see that we have different income levels but in reality, many of those columns contain the same variable (income) so these data are not tidy.

There are two methods to help you reshape your data.

- [`melt`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.melt.html) to go from wide data to long data.
- [`pivot`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.pivot.html) to go from long data to wide data.

### [`melt`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.melt.html)

As data are often stored in wide formats, you'll likely use `melt` a lot more frequently than you'll use `pivot`. This will allow you to get the data into a long format that will be easy to use for analysis. Here is an example for the `relig_income` data.

```python
long_df = relig_income.melt(id_vars="religion", var_name="income", value_name="count")
long_df.head()
```

We set the argument `id_var` to `religion` which tells pandas that the `religion` variable identifies each observation and should not be included in the transformation from wide to long.


### [`pivot`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.pivot.html)

To return your long data back to its original form, you can use `pivot`. Here you specify two columns: the column that contains the names of what your wide data columns should be (`columns`) and the column that contains the identifier for each observation (`index`). The data frame resulting from `pivot` will have the original information back in the wide format. But the columns may be in a different order). We'll discuss how to rearrange data in the next lesson!

```python
# Use pivot to reshape from long to wide.
wide_df = long_df.pivot(columns="income", index="religion")
# Take a look at the wide data.
wide_df.head()
```

## Transposing data

You may find you need your rows to be columns and your columns to be rows. In other words, you need to transpose your data frame. You can do this by using the [`.T`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.T.html) property of the dataframe or the [`transpose`](https://pandas.pydata.org/docs/reference/api/pandas.transpose.html) method. Let's have a look at our `relig_income` dataset again.

```python
# Use .T to transpose the data (swap rows and columns).
transposed = relig_income.T
# Take a look at the transposed data.
transposed.head()
```

While `relig_income` data had 18 rows and 11 columns, `transposed` has 11 rows and 18 columns. The information in both `relig_income` and `transposed` is the same, it's just in a different shape.


## Additional Resources

* [TidyDataTutor](https://tidydatatutor.com/vis.html).
* [pandas](https://pandas.pydata.org), a library for analyzing, wrangling, and tyding data in Python.
* [pandas tutorial](https://pandas.pydata.org/docs/user_guide/10min.html).
* [pandas cheatsheet](https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf).
