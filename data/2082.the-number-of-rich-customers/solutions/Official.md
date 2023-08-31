## [2082.富有客户的数量 中文官方题解](https://leetcode.cn/problems/the-number-of-rich-customers/solutions/100000/fu-you-ke-hu-de-shu-liang-by-leetcode-so-ac3n)

[TOC]

## 解决方案

---

### 方法：计数不同的值

#### Pandas

要初始化该过程，金额超过 500 的票据将被过滤掉。随后，对生成的账单集进行处理以提取唯一的客户 ID。这是通过应用 Boolean Indexing 实现的，能够过滤满足条件 `amount > 500` 的行。

```Python
rich_customers = store[store['amount'] > 500]
```

这将创建一个新的 DataFrame `rich_customers`，方法是过滤 `store` DataFrame，并只选择那些 `amount` 列严格大于 500 的行。

|   bill_id |   customer_id |   amount |
|----------:|--------------:|---------:|
|         6 |             1 |      549 |
|         8 |             1 |      834 |
|        11 |             3 |      657 |

<br>

在 DataFrame `rich_customers` 中，可能存在一些重复的客户 ID。要计算 `customer_id` 列中唯一客户 ID 的数量，我们可以使用多种方法。例如，一种更“Pythonic”的方法涉及计算 `customer_id` 列中的值集合中的元素数量：

```Python
count = len(set(rich_customers['customer_id']))

# count = 2
```

或者，我们可以通过将 `nunique()` 方法应用于 Series `store['customer_id']`来计算不同的客户 ID 的数量，方法如下：

```Python
count = rich_customers['customer_id'].nunique()

# count = 2
```

<br>

最后，我们创建一个新的 DataFrame `answer` 作为最终输出。它包含一个名为 `rich_count` 的列，该列中的值是有钱客户的计数。

```Python
answer = pd.DataFrame({'rich_count': [count]})
```
| rich_count |
|------------|
| 2          |

<br>

下面是完整代码：

```Python
import pandas as pd

def count_rich_customers(store: pd.DataFrame) -> pd.DataFrame:
    rich_customers = store[store['amount'] > 500]
    
    count = rich_customers['customer_id'].nunique()

    answer = pd.DataFrame({'rich_count':[count]})

    return answer
```

<br>

#### MySQL

`Store` 表中的行根据 `amount>500` 条件进行过滤。计算时将只考虑 `amount` 列包含的值大于 500 的行。
在 SQL 中，聚合函数 `COUNT(DISTINCT ...)` 用于计算表中指定列的不同值的个数。它提供了一种聚合数据并检索数据集中特定属性的唯一出现次数的方法。因此，我们可以应用聚合函数 `COUNT(DISTINCT customer_id)` 来统计 `customer_id` 列中不同值的个数。完整的代码如下：


```Sql
SELECT 
    COUNT(DISTINCT customer_id) AS rich_count 
FROM 
    Store 
WHERE 
    amount > 500
```