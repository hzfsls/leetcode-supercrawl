## [1667.修复表中的名字 中文官方题解](https://leetcode.cn/problems/fix-names-in-a-table/solutions/100000/xiu-fu-biao-zhong-de-ming-zi-by-leetcode-vrs5)
[TOC]

## 解决方案

---

### 概述

这项任务基本上归结为更新表中的一列数据。目标是标准化 Users 表中的 name 列，只有第一个字符是大写的，其它的是小写的，并且按 `user_id` 对结果值进行排序。

---

### 方法 1：将第一个字符与其余字符分开

#### 思路

##### SQL 思路

SQL 提供了各种允许我们操作和转换数据的函数。在这里，我们将具体利用以下几点：

1. `SUBSTRING(column_name, start, length)`：这将从列的值中提取一个子字符串，从指定的起始位置开始，直到指定的长度。

2. `UPPER(expression)`：这会将字符串表达式转换为大写。

3. `LOWER(expression)`：这会将字符串表达式转换为小写。

4. `CONCAT(string1, string2, ...)`：这会将两个或多个字符串连接成一个字符串。

这里的核心思想是将名称列的第一个字符与其他字符分开，相应地更改它们的大小写，然后将它们连接在一起。

##### Pandas 思路

Pandas 的思路和 SQL 的是一样的，只是语法不同而已！

Pandas `.str` 访问器方法本质上是 Series 和 Index 对象的矢量化字符串函数。这意味着我们可以将字符串函数应用于 Series 或 Index 中的*每个*元素，而不必单独循环每个元素，从而产生更快、更简洁的代码。欲了解更多信息，请访问[这里](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.str.html)。

警告：当在链式表达式中使用多个 Pandas `.str` 访问器方法时，请确保在每个特定字符串函数之前使用 `.str` 访问器。例如，`users["name"].str[1:].str.lower()` 是正确的，而 `users["name"].str[1:].lower()` 则不正确，因为它缺少 `.lower()` 方法之前的第二个 `.str` 访问器。

#### 算法

1. 提取 name 列的第一个字符并将其转换为大写。
2. 提取 name 列的其余部分（从第二个字符到最后）并将其转换为小写
3. 连接第一个字符的大写和其余部分的小写
4. 把结果按照 user_id 进行排序


#### 实现


**MySQL**

```Sql
SELECT user_id, CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;
```

**Pandas**

```Python3
import pandas as pd

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    users["name"] = users["name"].str[0].str.upper() + users["name"].str[1:].str.lower()
    return users.sort_values("user_id")
```

---

### 方法 2：使用 .title() 字符串方法

#### 思路

我们可以使用 str 访问器中的 `.title()` 方法，而不是手动分隔第一个字符并将其大写，而将其余字符小写。请注意，这只存在于 Python Pandas 中，而不是 MySQL 中。

#### 算法

这种方法将字符串中每个单词的第一个字母大写，并自动将其余单词小写，从而使代码更简洁。

#### 实现

**Pandas**

```Python3
import pandas as pd

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    users["name"] = users["name"].str.title()
    return users.sort_values("user_id")
```