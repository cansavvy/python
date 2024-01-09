# How to Tidy Data

So far we've discussed what tidy and untidy data are. We've (hopefully) convinced you that tidy data are the right type of data to work with. And, more than that, hopefully we've explained that data are not always the tidiest when they come to you at the start of a project. An incredibly important skill of a data scientist is to be able to take data from an untidy format and get it into a tidy format. We've started to discuss how to do this in the last lesson where we learned to reshape data. In this lesson, we'll discuss a number of other ways in which data can be tidied and the necessary tools to **tidy data**.

These skills are often referred to as **data wrangling**. They are skills that allow you to wrangle data from the format they're currently in into the format you actually want them in.

As this is an incredibly important topic, this will be a long lesson covering a number of packages and topics. Take your time working through it and be sure to understand all of the examples!

![data wrangling example](https://docs.google.com/presentation/d/1Z1pukaF-HrZHEwSfr3SV8N2Slo2rMEJxpgl1qJv-QL4/export/png?id=1Z1pukaF-HrZHEwSfr3SV8N2Slo2rMEJxpgl1qJv-QL4&pageid=g38bb68a535_0_1)

In R, you used a range of packages like `dplyr`, `tidyr`, `janitor`, and `skimr`. In Python, we'll use only one library: `pandas`.


## Exploring Data

We'll be using a dataset from the `ggplot2` package called [`msleep`](https://ggplot2.tidyverse.org/reference/msleep.html). This dataset includes sleep times and weights from a number of different mammals. It has 83 rows, with each row including information about a different type of animal, and 11 variables. As each row is a different animal and each column includes information about that animal, this is a **wide** dataset.

To get an idea of what variables are included in this data frame, you can use the [`info`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.info.html) method. This method summarizes how many rows there are (observations) and how many columns there are (variables). Additionally, it gives you a glimpse into the type of data contained in each column. Specifically, in this data set, we know that the first column is `name` and that it contains objects (strings, in this case). `info` also tells you how many non-null (or non-missing) entries there are in each column. For example, there are no missing values in the `name` columns (83 non-null out of a total of 83 rows), but there are 51 missing values (32 non-null out of a total of 83 rows) in the `sleep_cycle` column.

```python
import pandas as pd


# Download and read the dataset into a pandas data frame.
url = "https://raw.githubusercontent.com/tidyverse/ggplot2/main/data-raw/msleep.csv"
msleep = pd.read_csv(url)
msleep.info()
```

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 83 entries, 0 to 82
Data columns (total 11 columns):
 #   Column        Non-Null Count  Dtype  
---  ------        --------------  -----  
 0   name          83 non-null     object 
 1   genus         83 non-null     object 
 2   vore          76 non-null     object 
 3   order         83 non-null     object 
 4   conservation  54 non-null     object 
 5   sleep_total   83 non-null     float64
 6   sleep_rem     61 non-null     float64
 7   sleep_cycle   32 non-null     float64
 8   awake         83 non-null     float64
 9   brainwt       56 non-null     float64
 10  bodywt        83 non-null     float64
dtypes: float64(6), object(5)
memory usage: 7.3+ KB
```

Another method to get a glimpse of your data is [`head`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.head.html) which returns the first few rows of the data frame.

```python
msleep.head()
```

|    | name                       | genus      | vore   | order        | conservation   |   sleep_total |   sleep_rem |   sleep_cycle |   awake |   brainwt |   bodywt |
|---:|:---------------------------|:-----------|:-------|:-------------|:---------------|--------------:|------------:|--------------:|--------:|----------:|---------:|
|  0 | Cheetah                    | Acinonyx   | carni  | Carnivora    | lc             |          12.1 |       nan   |    nan        |    11.9 | nan       |   50     |
|  1 | Owl monkey                 | Aotus      | omni   | Primates     | nan            |          17   |         1.8 |    nan        |     7   |   0.0155  |    0.48  |
|  2 | Mountain beaver            | Aplodontia | herbi  | Rodentia     | nt             |          14.4 |         2.4 |    nan        |     9.6 | nan       |    1.35  |
|  3 | Greater short-tailed shrew | Blarina    | omni   | Soricomorpha | lc             |          14.9 |         2.3 |      0.133333 |     9.1 |   0.00029 |    0.019 |
|  4 | Cow                        | Bos        | herbi  | Artiodactyla | domesticated   |           4   |         0.7 |      0.666667 |    20   |   0.423   |  600     |

Similarly, [`tail`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.tail.html) returns the last few rows. You can pass an integer `k` to both methods to show the first or last `k` rows.


## Filtering Data

When working with a large dataset, you're often interested in only working with a portion of the data at any one time. For example, if you had data on people from ages 0 to 100 years old, but you wanted to ask a question that only pertained to children, you would likely want to only work with data from those individuals who were less than 18 years old. To do this, you would want to **filter** your dataset to only include data from these select individuals. Filtering can be done by row or by column, and we'll discuss the syntax for both[^1].


### Filtering Rows

If you were only interested in learning more about the sleep times of `Primates`, we could filter this dataset to include only data about those mammals that are also Primates. As we can see from `head`, this information is contained within the `order` variable. Using `pandas`, we filter the data as follows.

```python
primates = msleep[msleep.order == "Primates"]
primates.head()
```

|    | name         | genus         | vore   | order    | conservation   |   sleep_total |   sleep_rem |   sleep_cycle |   awake |   brainwt |   bodywt |
|---:|:-------------|:--------------|:-------|:---------|:---------------|--------------:|------------:|--------------:|--------:|----------:|---------:|
|  1 | Owl monkey   | Aotus         | omni   | Primates | nan            |          17   |         1.8 |        nan    |     7   |    0.0155 |     0.48 |
| 12 | Grivet       | Cercopithecus | omni   | Primates | lc             |          10   |         0.7 |        nan    |    14   |  nan      |     4.75 |
| 25 | Patas monkey | Erythrocebus  | omni   | Primates | lc             |          10.9 |         1.1 |        nan    |    13.1 |    0.115  |    10    |
| 28 | Galago       | Galago        | omni   | Primates | nan            |           9.8 |         1.1 |          0.55 |    14.2 |    0.005  |     0.2  |
| 33 | Human        | Homo          | omni   | Primates | nan            |           8   |         1.9 |          1.5  |    16   |    1.32   |    62    |

Note that we are using the equality `==` comparison operator that you learned about in the previous course rather than the assignment operator `=`. This is an important distinction. So what's happening here? Remember than indexing an object with `[...]` selects some of its items. Here, we select all items that satisfy the condition that `order` is `Primates`.

We now have a smaller dataset of only 12 mammals (as opposed to the original 83) and we can see that the `order` variable column only includes `Primates`.

But, what if we were only interested in Primates who sleep more than 10 hours total per night? This information is in the `sleep_total` column. To accomplish this, you would use the following syntax, combining the two conditions using the `&` operator. This operator is the logical `AND`. In other words, both `order == "Primates"` *and* `sleep_total > 10` need to be satisfied for the animal to be included.

```python
sleepy_primates = msleep[(msleep.order == "Primates") & (msleep.sleep_total > 10)]
sleepy_primates
```

|    | name         | genus        | vore   | order    | conservation   |   sleep_total |   sleep_rem |   sleep_cycle |   awake |   brainwt |   bodywt |
|---:|:-------------|:-------------|:-------|:---------|:---------------|--------------:|------------:|--------------:|--------:|----------:|---------:|
|  1 | Owl monkey   | Aotus        | omni   | Primates | nan            |          17   |         1.8 |        nan    |     7   |    0.0155 |     0.48 |
| 25 | Patas monkey | Erythrocebus | omni   | Primates | lc             |          10.9 |         1.1 |        nan    |    13.1 |    0.115  |    10    |
| 37 | Macaque      | Macaca       | omni   | Primates | nan            |          10.1 |         1.2 |          0.75 |    13.9 |    0.179  |     6.8  |
| 44 | Slow loris   | Nyctibeus    | carni  | Primates | nan            |          11   |       nan   |        nan    |    13   |    0.0125 |     1.4  |
| 55 | Potto        | Perodicticus | omni   | Primates | lc             |          11   |       nan   |        nan    |    13   |  nan      |     1.1  |

Now, we have a dataset focused in on only 5 mammals, all of which are primates who sleep for more than 10 hours a night total. The number of columns hasn't changed. All 11 variables are still shown in columns because the function `filter()` filters on rows, not columns.

If you wanted to select animals that are primates *or* sleep more than ten hours, you'd use the `|` operator to combine the two conditions like so.

```python
sleepy_or_primates = msleep[(msleep.order == "Primates") | (msleep.sleep_total > 10)]
sleepy_or_primates.head()
```

|    | name                       | genus      | vore   | order        | conservation   |   sleep_total |   sleep_rem |   sleep_cycle |   awake |   brainwt |   bodywt |
|---:|:---------------------------|:-----------|:-------|:-------------|:---------------|--------------:|------------:|--------------:|--------:|----------:|---------:|
|  0 | Cheetah                    | Acinonyx   | carni  | Carnivora    | lc             |          12.1 |       nan   |    nan        |    11.9 | nan       |   50     |
|  1 | Owl monkey                 | Aotus      | omni   | Primates     | nan            |          17   |         1.8 |    nan        |     7   |   0.0155  |    0.48  |
|  2 | Mountain beaver            | Aplodontia | herbi  | Rodentia     | nt             |          14.4 |         2.4 |    nan        |     9.6 | nan       |    1.35  |
|  3 | Greater short-tailed shrew | Blarina    | omni   | Soricomorpha | lc             |          14.9 |         2.3 |      0.133333 |     9.1 |   0.00029 |    0.019 |
|  5 | Three-toed sloth           | Bradypus   | herbi  | Pilosa       | nan            |          14.4 |         2.2 |      0.766667 |     9.6 | nan       |    3.85  |


### Selecting Columns

While indexing with `[...]` typically operates on rows, it can also filter your dataset to only include the columns you're interested in. To select columns so that your dataset only includes variables you're interested in, you simply index the data frame with a list of column names.

Let's start with the code we just wrote to only include primates who sleep a lot. What if we only want to include the first column (the name of the mammal) and the sleep information (included in the columns `sleep_total`, `sleep_rem`, and `sleep_cycle`)?

```python
subset = sleepy_primates[["name", "sleep_total", "sleep_rem", "sleep_cycle"]]
subset.head()
```

|    | name         |   sleep_total |   sleep_rem |   sleep_cycle |
|---:|:-------------|--------------:|------------:|--------------:|
|  1 | Owl monkey   |          17   |         1.8 |        nan    |
| 25 | Patas monkey |          10.9 |         1.1 |        nan    |
| 37 | Macaque      |          10.1 |         1.2 |          0.75 |
| 44 | Slow loris   |          11   |       nan   |        nan    |
| 55 | Potto        |          11   |       nan   |        nan    |

After indexing with the column names, we see that we still have the five rows we filtered to before, but we only have the four desired columns.


### Renaming Columns

You can use the [`rename`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.rename.html) method to change column names. In the following example, we remove the `sleep_` from the beginning of column names.

```python
subset.rename({"total": "sleep_total", "rem": "sleep_rem", "cycle": "sleep_cycle"})
```

|    | name         |   sleep_total |   sleep_rem |   sleep_cycle |
|---:|:-------------|--------------:|------------:|--------------:|
|  1 | Owl monkey   |          17   |         1.8 |        nan    |
| 25 | Patas monkey |          10.9 |         1.1 |        nan    |
| 37 | Macaque      |          10.1 |         1.2 |          0.75 |
| 44 | Slow loris   |          11   |       nan   |        nan    |
| 55 | Potto        |          11   |       nan   |        nan    |

The data remain unchanged, however. Treat renaming columns with caution because having different names for the same data in different parts of your code can be confusing. Using `rename` will only change the column names, but it will not filter out any columns.


## Reordering

In addition to filtering rows and columns, often, you'll want the data arranged in a particular order. It may order the columns in a logical way, or it could be to sort the data so that the data are sorted by value, with those having the smallest value in the first row and the largest value in the last row. All of this can be achieved with a few simple functions.

### Reordering Columns

Using our example from above, if you wanted `sleep_rem` to be the first sleep column and `sleep_total` to be the last column, all you have to do is reorder the column names in the list.

```python
reordered_columns = sleepy_primates[["name", "sleep_rem", "sleep_cycle", "sleep_total"]]
reordered_columns.head()
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |
|---:|:-------------|------------:|--------------:|--------------:|
|  1 | Owl monkey   |         1.8 |        nan    |          17   |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |
| 44 | Slow loris   |       nan   |        nan    |          11   |
| 55 | Potto        |       nan   |        nan    |          11   |

Here we see that `name` is displayed first followed by `sleep_rem`, `sleep_cycle`, and `sleep_total`, just as it was specified in the list of column names.


### Reordering Rows

Rows can also be reordered. To reorder a variable in ascending order (from smallest to largest), you'll want to use the [`sort_values`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.sort_values.html) method. Continuing on from our example above, to now sort our rows by the amount of total sleep each mammal gets, we would use the following syntax.

```python
reordered_columns.sort_values("sleep_total")
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |
|---:|:-------------|------------:|--------------:|--------------:|
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |
| 44 | Slow loris   |       nan   |        nan    |          11   |
| 55 | Potto        |       nan   |        nan    |          11   |
|  1 | Owl monkey   |         1.8 |        nan    |          17   |

To instead sort the data in descending (largest to smallest) order, simply pass the argument `ascending=False` to the `sort_values` method like so.

```python
reordered_columns.sort_values("sleep_total", ascending=False)
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |
|---:|:-------------|------------:|--------------:|--------------:|
|  1 | Owl monkey   |         1.8 |        nan    |          17   |
| 44 | Slow loris   |       nan   |        nan    |          11   |
| 55 | Potto        |       nan   |        nan    |          11   |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |

`sort_values` can also be used to order non-numeric variables. For example, `sort_values` will sort character vectors alphabetically.

```python
reordered_columns.sort_values("name")
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |
|---:|:-------------|------------:|--------------:|--------------:|
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |
|  1 | Owl monkey   |         1.8 |        nan    |          17   |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |
| 55 | Potto        |       nan   |        nan    |          11   |
| 44 | Slow loris   |       nan   |        nan    |          11   |

If you would like to reorder rows based on information in multiple columns, you can specify them as a list of column names. This is useful if you have repeated labels in one column and want to sort within a category based on information in another column. In the example here, if there were repeated primates, this would sort the repeats based on their total sleep.

```python
reordered_columns.sort_values(["name", "sleep_total"])
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |
|---:|:-------------|------------:|--------------:|--------------:|
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |
|  1 | Owl monkey   |         1.8 |        nan    |          17   |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |
| 55 | Potto        |       nan   |        nan    |          11   |
| 44 | Slow loris   |       nan   |        nan    |          11   |


## Creating new columns

You will often find when working with data that you need an additional column. For example, if you had two datasets you wanted to combine, you may want to make a new column in each dataset called `dataset`. In one dataset you may put `datasetA` in each row. In the second dataset, you could put `datasetB`. This way, once you combined the data, you would be able to keep track of which dataset each row came from originally. More often, however, you'll likely want to create a new column that calculates a new variable based on information in a column you already have. For example, in our mammal sleep dataset, `sleep_total` is in hours. What if you wanted to have that information in minutes? You could create a new column with this very information! 

Returning to our `msleep` dataset, after filtering and re-ordering, we can create a new column. We will calculate the number of minutes each mammal sleeps by multiplying the number of hours each animal sleeps by 60 minutes. A new column can be created by indexing the data frame with a column name and assigning to it.

```python
reordered_columns["sleep_total_min"] = reordered_columns.sleep_total * 60
reordered_columns
```

|    | name         |   sleep_rem |   sleep_cycle |   sleep_total |   sleep_total_min |
|---:|:-------------|------------:|--------------:|--------------:|------------------:|
|  1 | Owl monkey   |         1.8 |        nan    |          17   |              1020 |
| 25 | Patas monkey |         1.1 |        nan    |          10.9 |               654 |
| 37 | Macaque      |         1.2 |          0.75 |          10.1 |               606 |
| 44 | Slow loris   |       nan   |        nan    |          11   |               660 |
| 55 | Potto        |       nan   |        nan    |          11   |               660 |

Importantly, creating a new column in this way will change or *mutate* the data frame. In contrast, all the previous methods like `sort_values`, `rename`, and indexing with column names to select a subset created a *new* data frame each time. The original data frame was unchanged. For example, the data frame `msleep` we started with still contains 83 rows and 11 columns.


## Separating Columns

Sometimes multiple pieces of information are merged within a single column even though it would be more useful during analysis to have those pieces of information in separate columns. To demonstrate, we'll now move from the `msleep` dataset to talking about another dataset [`conservation_explanation.csv`](https://raw.githubusercontent.com/suzanbaert/Dplyr_Tutorials/master/conservation_explanation.csv) that includes information about conservation abbreviations in a single column.

```python
# Download and read the data.
url = "https://raw.githubusercontent.com/suzanbaert/Dplyr_Tutorials/master/conservation_explanation.csv"
conservation = pd.read_csv(url)

# Inspect the first few rows.
conservation.head()
```

|    | conservation abbreviation   |
|---:|:----------------------------|
|  0 | EX = Extinct                |
|  1 | EW = Extinct in the wild    |
|  2 | CR = Critically Endangered  |
|  3 | EN = Endangered             |
|  4 | VU = Vulnerable             |

In this dataset, we see that there is a single column that includes *both* the abbreviation for the conservation term as well as what that abbreviation means. Recall that this violates one of the tidy data principles covered in the first lesson: Put just one thing in a cell. To work with these data, you could imagine that you may want these two pieces of information (the abbreviation and the description) in two different columns. We'll use the [`str.split`](https://pandas.pydata.org/docs/reference/api/pandas.Series.str.split.html) method of the column to separate the abbrevation and description.

```python
separated = conservation["conservation abbreviation"].str.split(" = ", expand=True)
separated.head()
```

|    | 0   | 1                     |
|---:|:----|:----------------------|
|  0 | EX  | Extinct               |
|  1 | EW  | Extinct in the wild   |
|  2 | CR  | Critically Endangered |
|  3 | EN  | Endangered            |
|  4 | VU  | Vulnerable            |

We selected the column using indexing notation `[...]` instead of simply writing `conservation.conservation abbrevation` because the column name contains a space. This is another violation of tidy data! Variable names should have underscores, not spaces! The `str.split` method requires the characters that currently separate the pieces of information ` = ` as its first argument. Setting `expand=True` tells `str.split` to expand the results of splitting into separate columns. You'll learn more about working with strings in a [later section](05-working-with-strings.md).

However, the separated data frame does not have sensible column names. We can fix that by explicitly setting the column names.

```python
separated.columns = ["abbreviation", "conservation"]
separated.head()
```

|    | abbreviation   | conservation          |
|---:|:---------------|:----------------------|
|  0 | EX             | Extinct               |
|  1 | EW             | Extinct in the wild   |
|  2 | CR             | Critically Endangered |
|  3 | EN             | Endangered            |
|  4 | VU             | Vulnerable            |


## Merging Columns

The opposite of `split` is to concatenate values from different columns which you can achieve using the `+` operator. Using the code forming the two separate columns above, we can add on an extra line of code to re-join these separate columns, returning what we started with.

```python
separated["conservation_abbrevation"] = separated.abbreviation + " = " + separated.conservation
separated.head()
```

|    | abbreviation   | conservation          | conservation_abbrevation   |
|---:|:---------------|:----------------------|:---------------------------|
|  0 | EX             | Extinct               | EX = Extinct               |
|  1 | EW             | Extinct in the wild   | EW = Extinct in the wild   |
|  2 | CR             | Critically Endangered | CR = Critically Endangered |
|  3 | EN             | Endangered            | EN = Endangered            |
|  4 | VU             | Vulnerable            | VU = Vulnerable            |

Because one of the principles of tidy data is to only ever have one thing in each column, you'll rarely use concatenation in practice.

```python
print(_.to_markdown())
```

## Combining data across data frames

There is often information stored in two separate data frames that you'll want in a single data frame. There are *many* different ways to join separate data frames. They are discussed in more detail in [this tutorial](https://pandas.pydata.org/docs/user_guide/merging.html). Here, we'll demonstrate how to use the [`merge`](https://pandas.pydata.org/docs/reference/api/pandas.merge.html) function to perform a "left join", as this is used frequently.

Let's try to combine the information from the two different datasets we've used in this lesson. We have `msleep` and `separated`. `msleep` contains a column called `conservation`. This column includes lowercase abbreviations that overlap with the uppercase abbreviations in the `abbreviation` column in the `separated` dataset. To handle the fact that in one dataset the abbreviations are lowercase and the other they are uppercase, we'll use [`str.upper`](https://pandas.pydata.org/docs/reference/api/pandas.Series.str.upper.html) to take all the lowercase abbreviations to uppercase abbreviations.

We'll then use `merge` to perform a left join which takes all of the rows in the first dataset `msleep` and incorporates information from the second dataset `separated` if information in the second dataset is available. The `left_on` and `right_on` arguments specify the columns to use in the `left` (`msleep`) and `right` datasets (`separated`) to merge or join the two datasets. Setting `how="left"` tells `merge` to perform a `left` join. This means if there is no information in the `right` dataset, the result will have `NA` where data are not available. Specifically, for rows where conservation is "DOMESTICATED" below, the `description` column will have NA because "DOMESTICATED"" is not an abbreviation in the `conserve` dataset.

```python
# Convert conservation abbreviation to upper case.
msleep.conservation = msleep.conservation.str.upper()
# Merge the data.
merged = pd.merge(msleep, separated, left_on="conservation", right_on="abbreviation", how="left")
merged.head()
```

|    | name                       | genus      | vore   | order        | conservation_x   |   sleep_total |   sleep_rem |   sleep_cycle |   awake |   brainwt |   bodywt | abbreviation   | conservation_y   | conservation_abbrevation   |
|---:|:---------------------------|:-----------|:-------|:-------------|:-----------------|--------------:|------------:|--------------:|--------:|----------:|---------:|:---------------|:-----------------|:---------------------------|
|  0 | Cheetah                    | Acinonyx   | carni  | Carnivora    | LC               |          12.1 |       nan   |    nan        |    11.9 | nan       |   50     | LC             | Least Concern    | LC = Least Concern         |
|  1 | Owl monkey                 | Aotus      | omni   | Primates     | nan              |          17   |         1.8 |    nan        |     7   |   0.0155  |    0.48  | nan            | nan              | nan                        |
|  2 | Mountain beaver            | Aplodontia | herbi  | Rodentia     | NT               |          14.4 |         2.4 |    nan        |     9.6 | nan       |    1.35  | NT             | Near Threatened  | NT = Near Threatened       |
|  3 | Greater short-tailed shrew | Blarina    | omni   | Soricomorpha | LC               |          14.9 |         2.3 |      0.133333 |     9.1 |   0.00029 |    0.019 | LC             | Least Concern    | LC = Least Concern         |
|  4 | Cow                        | Bos        | herbi  | Artiodactyla | DOMESTICATED     |           4   |         0.7 |      0.666667 |    20   |   0.423   |  600     | nan            | nan              | nan                        |

It's important to note that there are many other ways to join data, which are covered in more detail in this [tutorial](https://pandas.pydata.org/docs/user_guide/merging.html). For now, it's important to know that joining datasets is done easily using `merge`. As you join data frames in your own work, it's a good idea to refer back to this tutorial for assistance.


## Summarizing Data

### [`describe`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html)

The `describe` method is similar to `info`. But instead of telling you about the *type* of data in the data frame, it provides summary statistics for columns containing numbers.

```python
msleep.describe()
```

|       |   sleep_total |   sleep_rem |   sleep_cycle |    awake |   brainwt |   bodywt |
|:------|--------------:|------------:|--------------:|---------:|----------:|---------:|
| count |      83       |    61       |     32        | 83       | 56        |   83     |
| mean  |      10.4337  |     1.87541 |      0.439583 | 13.5675  |  0.281581 |  166.136 |
| std   |       4.45036 |     1.29829 |      0.35868  |  4.45209 |  0.976414 |  786.84  |
| min   |       1.9     |     0.1     |      0.116667 |  4.1     |  0.00014  |    0.005 |
| 25%   |       7.85    |     0.9     |      0.183333 | 10.25    |  0.0029   |    0.174 |
| 50%   |      10.1     |     1.5     |      0.333333 | 13.9     |  0.0124   |    1.67  |
| 75%   |      13.75    |     2.4     |      0.579167 | 16.15    |  0.1255   |   41.75  |
| max   |      19.9     |     6.6     |      1.5      | 22.1     |  5.712    | 6654     |

If you want to learn about non-numeric data, pass `include="object"` to the describe method.

```python
msleep.describe(include="object")
```

|        | name    | genus    | vore   | order    | conservation   |
|:-------|:--------|:---------|:-------|:---------|:---------------|
| count  | 83      | 83       | 76     | 83       | 54             |
| unique | 83      | 77       | 4      | 19       | 6              |
| top    | Cheetah | Panthera | herbi  | Rodentia | LC             |
| freq   | 1       | 3        | 32     | 22       | 27             |

The output will tell you about the number of non-null values (`count`), the number of unique values (`unique`), the most frequent value (`top`), and the number of times the most frequent value appeared in the dataset (`freq`). If there is a tie between the most frequent values, a random value will be returned (`Cheetah` in this case for the `name` column).

If you are interested in the frequency of values in a particular column, you can use [`value_counts`](https://pandas.pydata.org/docs/reference/api/pandas.Series.value_counts.html) to learn more.

```python
msleep.order.value_counts()
```

| order           |   count |
|:----------------|--------:|
| Rodentia        |      22 |
| Carnivora       |      12 |
| Primates        |      12 |
| Artiodactyla    |       6 |
| Soricomorpha    |       5 |
| Perissodactyla  |       3 |
| Cetacea         |       3 |
| Hyracoidea      |       3 |
| Diprotodontia   |       2 |
| Erinaceomorpha  |       2 |
| Proboscidea     |       2 |
| Chiroptera      |       2 |
| Didelphimorphia |       2 |
| Cingulata       |       2 |
| Lagomorpha      |       1 |
| Pilosa          |       1 |
| Monotremata     |       1 |
| Afrosoricida    |       1 |
| Scandentia      |       1 |

In this example, the order `Rodentia` appears 22 times and is the most frequently occurring order in the dataset. If you want percentages rather than counts, pass `normalize=True` to `value_counts`.


## Grouping Data

Often, data scientists will want to summarize information in their dataset. You may want to know how many animals are in a dataset. However, more often, you'll want to know how many animals there are within a group in your dataset. For example, you may want to know how many primates and how many carnivores there are. To do this, grouping your data is necessary. Rather than looking at the total number of individuals, to accomplish this, you first have to group the data by the order of the animals. Then, you count within those groups. Grouping by variables is straightforward using the [`groupby`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.groupby.html) method.

### [`groupby`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.groupby.html)

`group_by` groups a dataset by one or more variables. 

```python
groups = msleep.groupby("order")
groups
```

```
<pandas.core.groupby.generic.DataFrameGroupBy object at 0x1356e1600>
```

This doesn't seem very useful at first sight, but we can extract information about the different groups using further methods.

```python
groups.order.count()
```

```
order
Afrosoricida        1
Artiodactyla        6
Carnivora          12
Cetacea             3
Chiroptera          2
Cingulata           2
Didelphimorphia     2
Diprotodontia       2
Erinaceomorpha      2
Hyracoidea          3
Lagomorpha          1
Monotremata         1
Perissodactyla      3
Pilosa              1
Primates           12
Proboscidea         2
Rodentia           22
Scandentia          1
Soricomorpha        5
Name: order, dtype: int64
```

This code counts the number of non-null values in the `order` column within each group. The results may differ slightly if you use a different column. For example, there are quite a few values missing in the `sleep_cycle` column.

```python
groups.sleep_cycle.count()
```

```
order
Afrosoricida       0
Artiodactyla       2
Carnivora          4
Cetacea            0
Chiroptera         2
Cingulata          1
Didelphimorphia    1
Diprotodontia      0
Erinaceomorpha     1
Hyracoidea         0
Lagomorpha         1
Monotremata        0
Perissodactyla     2
Pilosa             1
Primates           5
Proboscidea        0
Rodentia           7
Scandentia         1
Soricomorpha       4
Name: sleep_cycle, dtype: int64
```

There are other ways in which the data can be summarized using `groupby`. In addition to using to `count` the number of samples within a group, you can also summarize using other helpful functions, such as `mean`, `median`, `min`, or `max`. For example, if we wanted to calculate the average (mean) total sleep each order of mammal got, we could use the following code.

```python
groups.sleep_total.mean()
```

```
order
Afrosoricida       15.600000
Artiodactyla        4.516667
Carnivora          10.116667
Cetacea             4.500000
Chiroptera         19.800000
Cingulata          17.750000
Didelphimorphia    18.700000
Diprotodontia      12.400000
Erinaceomorpha     10.200000
Hyracoidea          5.666667
Lagomorpha          8.400000
Monotremata         8.600000
Perissodactyla      3.466667
Pilosa             14.400000
Primates           10.500000
Proboscidea         3.600000
Rodentia           12.468182
Scandentia          8.900000
Soricomorpha       11.100000
Name: sleep_total, dtype: float64
```


## Conclusion

We have gone through a number of ways to work with data in this lesson. Mastering the skills in this lesson will provide you with a number of critical data science skills. Thus, running the examples in this lesson and practicing on your own with other data sets will be essential to succeeding as a data scientist.


[^1]: The examples in this lesson and the organization for this lesson were adapted from [Suzan Baert's](https://suzan.rbind.io/) wonderful `dplyr` tutorials.
