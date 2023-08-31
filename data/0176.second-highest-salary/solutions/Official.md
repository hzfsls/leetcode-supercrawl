## [176.第二高的薪水 中文官方题解](https://leetcode.cn/problems/second-highest-salary/solutions/100000/di-er-gao-de-xin-shui-by-leetcode-soluti-9gf6)

[TOC]

## 解决方案

---

#### 方法 1：使用 Pandas

**算法**

给定如下的 `employee` 表：

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
| 4  | 200    |

1. 首先我们去除重复的薪资。

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |

2. 然后，如果没有两个不同的薪资，我们处理这种情况。如果少于两个不同薪资，则返回 `np.NaN` 作为第二高薪资。

3. 否则，我们按照薪资对这张表降序排序。

| id | salary |
|----|--------|
| 3  | 300    |
| 2  | 200    |
| 1  | 100    |

4. 然后我们删除 `id` 列。

| salary |
|--------|
| 300    |
| 200    |
| 100    |

5. 将薪资列重命名为 `SecondHighestSalary`

| SecondHighestSalary |
|---------------------|
| 300                 |
| 200                 |
| 100                 |

6. 现在我们得到了最靠前的两行（通过 `.head(2)`）。

| SecondHighestSalary |
|---------------------|
| 300                 |
| 200                 |

7. 其中的最后一行是第二高的薪资（通过 `.tail(1)`）。

| SecondHighestSalary |
|---------------------|
| 200                 |

**Pandas**

```Python3
import pandas as pd

def second_highest_salary(employee: pd.DataFrame) -> pd.DataFrame:
    # 1. 删除所有重复的薪水.
    employee = employee.drop_duplicates(["salary"])
    
    # 2. 如果少于 2 个不同的薪水，返回 `np.NaN`。
    if len(employee["salary"].unique()) < 2:
        return pd.DataFrame({"SecondHighestSalary": [np.NaN]})
    
    # 3. 把表格按 `salary` 降序排序。
    employee = employee.sort_values("salary", ascending=False)
    
    # 4. 删除 `id` 列。
    employee.drop("id", axis=1, inplace=True)
    
    # 5. 重命名 `salary` 列。
    employee.rename({"salary": "SecondHighestSalary"}, axis=1, inplace=True)
    
    # 6, 7. 返回第 2 高的薪水
    return employee.head(2).tail(1)
```

#### 方法 2：使用子查询与 `LIMIT` 子句

**算法**

对不同的薪资进行降序排序，然后利用 [`LIMIT`](https://dev.mysql.com/doc/refman/5.7/en/select.html) 子句来获得第二高的薪资。

```Sql
SELECT DISTINCT
    Salary AS SecondHighestSalary
FROM
    Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1
```

然而，如果没有第 2 高的薪资，即表里可能只有一条记录，这个解答会被评测为  'Wrong Answer' 。为了克服这个问题，我们可以将其作为临时表。

**MySQL**

```Sql
SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary
;
```

#### 方法 3：使用 `IFNULL` 和 `LIMIT` 子句

另一种解决 'NULL' 问题的方式是使用下面的 `IFNULL` 函数。 如果不为  `NULL`，`IFNULL` 函数会返回第一个参数，否则返回第二个参数。
这为我们提供了正确的解决方案，即*一行*包含 `NULL` (如果没有这样的第 2 高薪资)，而不仅仅是一个空表。

**MySQL**

```Sql
SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary
```