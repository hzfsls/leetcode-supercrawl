## [1484.按日期分组销售产品 中文官方题解](https://leetcode.cn/problems/group-sold-products-by-the-date/solutions/100000/an-ri-qi-fen-zu-xiao-shou-chan-pin-by-le-wsi4)

[TOC]

## 解决方案

---

### 方法：字符串的分组和聚合

#### Pandas

这个问题要求我们根据日期对数据进行分组和聚合。为此，我们首先需要使用 `groupby` 函数通过 `groups = activities.groupby('sell_date')` 将 DataFrame `activities` 按日期分组，这将创建一个新的 DataFrameGroupBy 对象。

然后我们使用 `agg()` 对这个 DataFrameGroupBy 对象中的每个组进行聚合操作，其中我们使用命名聚合指定了两个聚合任务：

- `num_sold=('product', 'nunique')`：这将在输出 DataFrame 中创建一个新列 `num_sold`，表示在每个销售日期售出的唯一产品的数量。‘nunique’ 函数对每个组中 `product` 列中的不同元素进行计数。
- `products=('product', lambda x: ','.join(sorted(set(x))))`：这一行有点复杂，我们被要求对每个组中的所有唯一名称进行排序和联接。然而，没有定义的函数可以处理此任务，但幸运的是，我们可以将其替换为自定义函数 `lambda x: ','.join(sorted(set(x)))`。其中，`x` 表示表示每个组中的列 `product` 的Series。我们将其转换为一个集合，以删除重复项，对唯一的产品名称进行排序，然后将它们连接成带有逗号的单个字符串。

```Python
groups = activities.groupby('sell_date')

stats = groups.agg(
    num_sold=('product', 'nunique'), 
    products=('product', lambda x: ','.join(sorted(set(x))))
    ).reset_index()
```

这将会创建如下的 `stats` DataFrame，

| sell_date  | num_sold | products                     |
| ---------- | -------- | ---------------------------- |
| 2020-05-30 | 3        | Basketball,Headphone,T-Shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |

<br>

接下来，我们需要根据 `sell_date` 列的升序对 `stats` DataFrame 进行排序（最早的日期在前）。参数 `inplace=True` 确保排序直接应用于 DataFrame。

```Python
stats.sort_values('sell_date', inplace=True)
```

我们将通过如下方式获取 DataFrame `answer`（本例中，`stats` DataFrame 在排序前后保持不变。然而，它不一定适用于其他情况。）

| sell_date   | num_sold | products                      |
|-------------|----------|-------------------------------|
| 2020-05-30  | 3        | Basketball, Headphone, T-shirt |
| 2020-06-01  | 2        | Bible, Pencil                 |
| 2020-06-02  | 1        | Mask                          |

<br>

下面是完整的代码：

```Python
import pandas as pd

def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    groups = activities.groupby('sell_date')
    
    stats = groups.agg(
        num_sold=('product', 'nunique'), 
        products=('product', lambda x: ','.join(sorted(set(x))))
        ).reset_index()

    stats.sort_values('sell_date', inplace=True)

    return stats
```

<br>

#### MySQL

我们按照 `sell_date` 列对数据进行分组，为了得到 `num_sold` 列，我们使用 `COUNT(DISTINCT product)` 来统计每个销售日期售出的唯一产品的数量。
最具挑战性的部分是对每个组中所有唯一的名称进行排序和连接，以获得 `products` 列。我们可以使用函数 `GROUP_CONCAT()` 将多行中的多个值组合成一个字符串。下面显示了 `GROUP_CONCAT()` 函数的语法：

```Sql
GROUP_CONCAT(
    DISTINCT expression1
    ORDER BY expression2
    SEPARATOR sep
);
```

关键词 `DISTINCT` 确保了 `expression1` 列中的每个名称在连接的字符串中只包含一次。请注意，我们需要对唯一的名称进行升序排序，这是默认的顺序，因此可以省略参数 `expression2`。关键字 `SEPARATOR` 指定产品名称应以 `sep` 分隔。总而言之，我们使用 `GROUP_CONCAT` 如下。

```Sql
GROUP_CONCAT(
    DISTINCT product
    SEPARATOR ','
);
```

这会将不同的产品名称连接到每个销售日期的单个字符串中。最后，我们根据 `sell_date` 对最终结果进行升序排序。这确保输出表的组织顺序是从最早的销售日期到最晚的销售日期。完整的代码如下：

```Sql
SELECT 
    sell_date,
    COUNT(DISTINCT(product)) AS num_sold, 
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM 
    Activities
GROUP BY 
    sell_date
ORDER BY 
    sell_date ASC
```