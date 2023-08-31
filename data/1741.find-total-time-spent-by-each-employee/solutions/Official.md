## [1741.查找每个员工花费的总时间 中文官方题解](https://leetcode.cn/problems/find-total-time-spent-by-each-employee/solutions/100000/cha-zhao-mei-ge-yuan-gong-hua-fei-de-zon-kyvs)
[TOC]

## 解决方案

- MySQL

- Pandas

---

### 概述

我们被要求计算每个员工每天在办公室的总时间(分钟)。

---

### 方法 1：计算时间和 GROUP BY

#### MySQL

##### MySQL 实现

在 SQL 中，计算每个员工每天在办公室的总时间的查询包括计算 `out_time` 和 `in_time` 的差值，然后按 `emp_id` 和 `event_day` 分组，最后对每组的时间差求和。

##### MySQL 算法

这项任务需要计算每位员工每天在办公室的总时间。这意味着我们首先要计算每个条目的时间差（`out_time-in_time`），然后按 `emp_id` 和 `event_day` 进行分组，最后对每组的时间差进行求和。

以下是一个帮助巩固该算法背后的思想的例子：

一开始的 `Employees` 表：

| emp_id | event_day  | in_time | out_time |
|--------|------------|---------|----------|
| 1      | 2020-11-28 | 4       | 32       |
| 1      | 2020-11-28 | 55      | 200      |
| 1      | 2020-12-03 | 1       | 42       |
| 2      | 2020-11-28 | 3       | 33       |
| 2      | 2020-12-09 | 47      | 74       |

在计算了时间差，按照 `emp_id` 和 `event_day` 分组，并且对时间差求和之后的表：

| day        | emp_id | total_time |
|------------|--------|------------|
| 2020-11-28 | 1      | 173        |
| 2020-11-28 | 2      | 30         |
| 2020-12-03 | 1      | 41         |
| 2020-12-09 | 2      | 27         |

##### MySQL 实现

```Sql
SELECT event_day AS day, emp_id, SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY event_day, emp_id;
```

#### Pandas

##### Pandas 思路

在 Pandas 中，我们可以计算 `out_time` 和 `in_time` 列之间的差值，并将其存储为名为 `Total_time` 的新列。之后，我们可以对 `event_day` 和 `emp_id` 列进行分组操作，并计算出每组的 `total_time` 之和。

##### Pandas 算法

通过新建一列 `total_time` 来捕获 `out_time` 和 `in_time` 的时间差，我们可以继续根据`event_day` 和 `emp_id` 列对数据进行分组。随后，我们计算每个员工每天在办公室花费的总时间，方法是将每个组的 `total_time` 相加。

以下是一个帮助巩固该算法背后的思想的例子：

1. 一开始的 `employees`  DataFrame ：
| emp_id | event_day  | in_time | out_time |
|--------|------------|---------|----------|
| 1      | 2020-11-28 | 4       | 32       |
| 1      | 2020-11-28 | 55      | 200      |
| 1      | 2020-12-03 | 1       | 42       |
| 2      | 2020-11-28 | 3       | 33       |
| 2      | 2020-12-09 | 47      | 74       |

- 请注意，你可以新建 `employee` 表通过：

    ```Python3
    import pandas as pd

    employees = pd.DataFrame({
        'emp_id': [1, 1, 1, 2, 2],
        'event_day': ['2020-11-28', '2020-11-28', '2020-12-03', '2020-11-28', '2020-12-09'],
        'in_time': [4, 55, 1, 3, 47],
        'out_time': [32, 200, 42, 33, 74]
    })
    ```

2. 在创建 `'total_time'` 列之后：

```Python3
employees["total_time"] = employees["out_time"] - employees["in_time"]
```

| emp_id | event_day  | in_time | out_time | total_time |
|--------|------------|---------|----------|------------|
| 1      | 2020-11-28 | 4       | 32       | 28         |
| 1      | 2020-11-28 | 55      | 200      | 145        |
| 1      | 2020-12-03 | 1       | 42       | 41         |
| 2      | 2020-11-28 | 3       | 33       | 30         |
| 2      | 2020-12-09 | 47      | 74       | 27         |

3. 将数据按 `event_day` 和 `emp_id` 分组，然后将每组的 `total_time` 相加，得到下表：

```Python3
employees = employees.groupby(["event_day", "emp_id"])["total_time"].sum().reset_index()
```

| event_day  | emp_id | total_time |
|------------|--------|------------|
| 2020-11-28 | 1      | 173        |
| 2020-11-28 | 2      | 30         |
| 2020-12-03 | 1      | 41         |
| 2020-12-09 | 2      | 27         |

##### Pandas 实现

```Python3
import pandas as pd

def total_time(employees: pd.DataFrame) -> pd.DataFrame:
    employees["total_time"] = employees["out_time"] - employees["in_time"]
    employees = employees.groupby(["event_day", "emp_id"])["total_time"].sum().reset_index()
    employees.rename({"event_day": "day"}, axis=1, inplace=True)
    employees["day"] = employees["day"].astype(str)
    return employees
```