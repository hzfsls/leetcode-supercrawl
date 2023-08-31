## [1907.按分类统计薪水 中文官方题解](https://leetcode.cn/problems/count-salary-categories/solutions/100000/an-fen-lei-tong-ji-xin-shui-by-leetcode-wr0c5)
[TOC]

## 解决方案

---

### 方法：过滤行

#### Pandas

让我们依次统计每一类的数量，要过滤工资较低的行，可以使用 `accounts['income'] < 20000`，它会检查 DataFrame `accounts` 的 `income` 列中的每个值，以确定它是否小于 20000。

```Python
accounts['income'] < 20000
```

它通过将 `income` 列中的每个值与 20000 进行比较来创建一个 Boolean Series ，工资小于 20000 的为 `True`，其它的为 `False`。

```
0    False
1     True
2    False
3    False
Name: income, dtype: bool
```
<br>

接下来，我们可以使用 `sum()` 方法统计 `True` 值的个数，`sum()` 将 `True` 视为 1，将 `False` 视为 0。因此，count 表示该系列中 `True` 的数量，它对应于低工资的账号数量。

```Python
low_count = (accounts['income'] < 20000).sum()
```

或者，我们可以使用这个 Boolean Series 作为索引来过滤 DataFrame `accounts`，它返回一个新的 DataFrame，它只包含 `income` 值小于 20000 的行。然后，我们可以使用 `len()` 函数来获取匹配条件的行数。

```Python
low_count = len(accounts[accounts['income'] < 20000])
```

这两种方法都会产生相同的答案。

<br>

我们使用此方法确定三个类别中的每一个类别中的行数。

```Python
low_count = (accounts['income'] < 20000).sum()
average_count = ((accounts['income'] >= 20000) & (accounts['income'] <= 50000)).sum()
high_count = (accounts['income'] > 50000).sum()
```

<br>

最后，让我们创建一个新的 DataFrame `ans` 来存储结果。预期的输出 DataFrame 有两列：`category` 和 `accounts_count`。对于 `category` 列，我们分配三个类别的名称。在 `accounts_count` 列中，我们用前面计算的相应计数填充它。

```Python
ans = pd.DataFrame({
    'category': ['Low Salary', 'Average Salary', 'High Salary'],
    'accounts_count': [low_count, average_count, high_count]
})
```

我们将会得到下面的 DataFrame `ans`：

| category       | accounts_count |
| -------------- | -------------- |
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |

<br>

下面是完整的代码：

```Python
import pandas as pd

def count_salary_categories(accounts: pd.DataFrame) -> pd.DataFrame:
    low_count = (accounts['income'] < 20000).sum()
    average_count = ((accounts['income'] >= 20000) & (accounts['income'] <= 50000)).sum()
    high_count = (accounts['income'] > 50000).sum()

    ans = pd.DataFrame({
        'category': ['Low Salary', 'Average Salary', 'High Salary'],
        'accounts_count': [low_count, average_count, high_count]
    })

    return ans
```

<br>

#### MySQL

首先，我们对 `Low Salary` 类别执行以下步骤：

- 选择 `Low Salary` 作为该类别的 `category` 标签。
- 使用 `SUM` 函数和 `CASE` 表达式来统计 `Low Salary` 类别的账号数量。

SQL 中 `CASE WHEN` 语句的语法如下

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE resultN
END
```
<br>

我们将执行上面的表达式来计算 `Accounts` 表中的每一行。如果 `income` 值小于 20000，则返回 1（表示属于 `Low Salary` 类别）；否则，返回 0。然后，`SUM` 函数计算落入 `Low Salary` 类别的帐户总数。

```sql
SELECT 
    'Low Salary' AS category,
    SUM(CASE WHEN income < 20000 THEN 1 ELSE 0 END) AS accounts_count
FROM 
    Accounts
```

| category   | accounts_count |
| ---------- | -------------- |
| Low Salary | 1              |

<br>

接下来，我们对 `Average Salary` 和 `High Salary` 分类执行类似的步骤。

```sql
SELECT  
    'Average Salary' category,
    SUM(CASE WHEN income >= 20000 AND income <= 50000 THEN 1 ELSE 0 END) 
    AS accounts_count
FROM 
    Accounts
```

| category       | accounts_count |
| -------------- | -------------- |
| Average Salary | 0              |

<br>

```sql
SELECT 
    'High Salary' category,
    SUM(CASE WHEN income > 50000 THEN 1 ELSE 0 END) AS accounts_count
FROM 
    Accounts
```

| category    | accounts_count |
| ----------- | -------------- |
| High Salary | 3              |

<br>

最后，我们使用 `UNION` 运算符将这三个单独查询的结果组合在一起。这使我们能够获得一个合并的摘要，其中包括每个薪资类别的帐户计数。结果将是一个包含两个必需列的表： `category`（工资类别标签）和 `account_count`（每个类别的帐户计数）。完整的代码如下：

```sql
SELECT 
    'Low Salary' AS category,
    SUM(CASE WHEN income < 20000 THEN 1 ELSE 0 END) AS accounts_count
FROM 
    Accounts
    
UNION
SELECT  
    'Average Salary' category,
    SUM(CASE WHEN income >= 20000 AND income <= 50000 THEN 1 ELSE 0 END) 
    AS accounts_count
FROM 
    Accounts

UNION
SELECT 
    'High Salary' category,
    SUM(CASE WHEN income > 50000 THEN 1 ELSE 0 END) AS accounts_count
FROM 
    Accounts
```

> 在 SQL 中使用 `UNION` 运算符时，有几点需要注意，比如确保 `UNION` 的每个部分都具有相同的数据类型，顺序相同，列数必须相同。幸运的是，我们希望联合的所有三个表都满足这些条件。