## [177.第N高的薪水 中文官方题解](https://leetcode.cn/problems/nth-highest-salary/solutions/100000/di-n-gao-de-xin-shui-by-leetcode-solutio-anro)

[TOC]

## 解决方案

- MySQl

- Pandas

---

### 概述

从 `Employee` 表中检索第 n 高的薪资。如果没有第 n 高的薪资，我们将会返回 `null` 。

---

### 方法 1：排序与限制

#### MySQL

##### MySQL 思路

在 SQL 中，查找第 n 高薪资的查询涉及按降序对不同的薪资进行排序，并将结果限制在第 n 行。这里我们从 N 减去 1，因为 SQL 索引从 0 开始。

##### MySQL 算法

这个任务需要从 Employee 表中查找第 n 高薪资。如果没有第 n 高薪资，则查询应返回 null。这意味着我们必须按降序对 salary 列进行排序，并选择第 n 个条目。

以下是一个帮助巩固该算法背后的思路的例子：

初始的 `employee` 表并且 `N = 2`：

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
| 4  | 500    |
| 5  | 500    |

通过 `SELECT DISTINCT` 去重后的子表格：

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
| 4  | 500    |

通过 `ORDER BY salary DESC` 降序排序后的子表格：

| id | salary |
|----|--------|
| 4  | 500    |
| 3  | 300    |
| 2  | 200    |
| 1  | 100    |

并且第 2 高的薪资是 `300`，可以在降序表的第二行找到！我们使用 `LIMIT M, 1` 来实现这一点，它从第 `M` 行开始取下一个第 `1` 行（从 0 开始索引）。

请注意在 SQL 中，查询中子句的执行顺序通常如下：

1. FROM 子句：指定从中检索数据的表。
2. WHERE 子句：根据指定的条件筛选行。
3. GROUP BY 子句：根据指定的列或表达式对行进行分组。
4. HAVING 子句：根据条件筛选分组的行。
5. SELECT 子句：选择将在结果集中返回的列或表达式。
6. ORDER BY 子句：根据指定的列或表达式对结果集进行排序。
7. LIMIT/OFFSET 子句：限制结果集中返回的行数。

注意：你的 DBMS 可能会以等价但 *不同* 的顺序执行一个查询。

##### MySQL 实现

```Sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT; 
    SET M = N-1; 
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT M, 1
  );
END
```

#### Pandas

使用 Python 的 Pandas 库，我们可以通过按降序对不同的薪水进行排序，然后选择第 n 个薪水来实现这一点。

##### Pandas 算法

以下是一个帮助巩固该算法背后的思想的例子：

初始的 `employee` 表并且 `N = 2`：

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
| 4  | 500    |
| 5  | 500    |

通过 `employee [["salary"]]` 只选中薪水列后的表：

| salary |
|--------|
| 100    |
| 200    |
| 300    |
| 500    |
| 500    |

通过 `.drop_duplicates()` 去重后的表：

| salary |
|--------|
| 100    |
| 200    |
| 300    |
| 500    |

通过 `.sort_values("salary", ascending=False)` 降序排序后的表。 请注意，我们必须设置 `ascending=False` 因为 `sort_values()` 方法的默认顺序是 `ascending=True`：

| salary |
|--------|
| 500    |
| 300    |
| 200    |
| 100    |

通过 `.head(N)` 并且 `N = 2` 获取最高 2 个后的表：

| salary |
|--------|
| 500    |
| 300    |

通过 `.tail(1)` 获取最后一个后的表：

| salary |
|--------|
| 300    |

第 2 高的工资是 `300`。

##### Pandas 实现

```Python3
import pandas as pd

def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    df = employee[["salary"]].drop_duplicates()
    if len(df) < N:
        return pd.DataFrame({'getNthHighestSalary(2)': [None]})
    return df.sort_values("salary", ascending=False).head(N).tail(1)
```