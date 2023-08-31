## [1873.计算特殊奖金 中文官方题解](https://leetcode.cn/problems/calculate-special-bonus/solutions/100000/ji-suan-te-shu-jiang-jin-by-leetcode-sol-ipj4)

[TOC]

## 解决方案

---

### 方法：使用 if-else 条件语句

#### Pandas

让我们来看看奖金计算条件：只有当员工的 ID 是奇数且他的名字不以字母 `M` 开头时，奖金等于工资。否则，奖金设置为 0。这可以用简单的 `if-else` 语句表示：

```Python
bonus = salary if (id % 2 and not name.startwith('M')) else 0
```

我们如何将此表达式应用于 DataFrame `employee` 的每一行？

要完成此任务，我们可以使用循环逐一迭代 DataFrame 行。然而，Python 提供了一种更优雅且更高效的方法，称为"向量化"，它使用 `apply()` 方法。向量化利用 Pandas 中的底层优化，使我们能够一次对整个列或行应用操作，从而实现更快、更简洁的代码。

在这种情况下，使用 `apply()` 允许我们避免编写显式循环，并更简洁地处理操作。通过定义一个自定义函数来根据条件计算奖金，并利用带有 `axis=1` 参数的 `apply()`，我们可以轻松处理每一行并计算相应的奖金。自定义函数如下所示：

```Python
lambda x: x['salary'] if x['employee_id'] % 2 and not x['name'].startswith('M') else 0
```

它通过根据员工 ID 和他们名字的首字母检查条件来实现我们的 `if-else` 逻辑语句，并返回相应的奖金值。我们将 `apply()` 的第一个参数设置为此 lambda 函数，并将参数 `axis` 设置为 1，表示函数应该沿着行应用。

```Python
employees['bonus'] = employees.apply(
    lambda x: x['salary'] if x['employee_id'] % 2 and not x['name'].startswith('M') else 0, 
    axis=1
)
```

上面的代码创建了一个新的列 `bonus`：

| employee_id | name    | salary | bonus |
| ----------- | ------- | ------ | ----- |
| 0           | Meir    | 3000   | 0     |
| 1           | Michael | 3800   | 0     |
| 2           | Addilyn | 7400   | 7400  |
| 3           | Juan    | 6100   | 0     |
| 4           | Kannon  | 7700   | 7700  |

<br>

接下来，我们选择所需的列 `employee_id` 和 `bonus`，并按照 `employee_id` 的升序对 DataFrame `df` 进行排序。

```Python
df = employees[['employee_id', 'bonus']].sort_values('employee_id')
```

我们将获得以下 `df`：

| employee_id | bonus |
| ----------- | ----- |
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |

<br>

完整的代码如下所示：

```Python
import pandas as pd

def calculate_special_bonus(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees.apply(
        lambda x: x['salary'] if x['employee_id'] % 2 and not x['name'].startswith('M') else 0, 
        axis=1
    )

    df = employees[['employee_id', 'bonus']].sort_values('employee_id')
    return df
```

<br>
<br>


#### MySQL

在 SQL 中，我们使用条件函数 IF 来执行条件检查，并根据条件的结果返回不同的值。IF 函数的语法如下：

```Sql
IF(condition, value_if_true, value_if_false)
```

`condition` 由两部分组成，用关键字 AND 分隔：

- `employee_id % 2 = 1`：这个条件检查 `employee_id` 是否为奇数。
- `name NOT REGEXP '^M'`：我们使用关键字 REGEXP 进行正则表达式模式匹配，它检查名字是否**不以**字母 "M" 开头（`^M` 表示一个正则表达式模式，匹配任何不以 "M" 开头的名字）。

因此，在我们的情况下，IF 函数如下所示：

```Sql
IF(employee_id % 2 = 1 AND name NOT REGEXP '^M', salary, 0)
```

AS子句用于给上面计算的列一个别名 `bonus`。如果两个条件都满足，则 `bonus` 将设置为员工的工资。否则，它将设置为0。然后，结果集根据 `employee_id` 列按升序排序。完整的代码如下所示：


```Sql
SELECT 
    employee_id,
    IF(employee_id % 2 = 1 AND name NOT REGEXP '^M', salary, 0) AS bonus 
FROM 
    employees 
ORDER BY 
    employee_id
```

| employee_id | bonus |
| ----------- | ----- |
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |