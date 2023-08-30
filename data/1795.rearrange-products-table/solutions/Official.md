[TOC]

## 解决方案

---

### 方法 1：合并表格

#### Pandas

输出 DataFrame 中的 `price` 列似乎是输入 DataFrame  `products` 中的三列 `store1`、`store2` 和 `store3` 的组合。为了实现这一点，一个简单的策略是创建三个单独的 DataFrame，分别表示每个商店，然后将它们连接成一个 DataFrame。

首先从 `store1` 开始，我们通过从 `products` DataFrame 中选择 `store1` 列不为空的行来创建一个新的 DataFrame `a`。我们使用 `notna()` 方法创建一个布尔掩码，用于过滤掉 `store1` 列中包含空值的行。然后使用 `loc` 方法选择过滤后的行的 `product_id` 和 `store1` 列。这样得到的 DataFrame `a` 将只包含 `store1` 列中的有效值的行。

```Python
# 过滤掉 `store1` 列中有空值的行，并选择 `product_id` 和 `store1` 列。
a = products.loc[products['store1'].notnull(), ['product_id', 'store1']]
```

我们将获得以下过滤后的 DataFrame `a`：

| product_id | store1 |
| ---------- | ------ |
| 0          | 95     |
| 1          | 70     |

<br>

在下一步中，我们对 `a` 进行修改，添加一个新列 `store`，并将 `store1` 列重命名为 `price`。

- `a['store'] = "store1"`：我们在 DataFrame `a` 中创建一个新列 `store`，并将所有值设置为字符串 "store1" 。

- `a.rename(columns={'store1':'price'}, inplace=True)`：我们将 `store1` 列重命名为 `price`。

```Python
a['store'] = "store1"
a.rename(columns={'store1':'price'}, inplace=True)
```

经过这两个操作，DataFrame `a` 将有三列：`product_id`、`price` 和 `store`。

| product_id | price | store  |
| ---------- | ----- | ------ |
| 0          | 95    | store1 |
| 1          | 70    | store1 |

<br>

由于列的顺序可能不符合预期的顺序，最后一步是重新排列列的顺序。现在，`store` 和 `price` 列的顺序已经重新排列以匹配预期的输出。

```Python
a = a[['product_id', 'store', 'price']]
```

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store1 | 95    |
| 1          | store1 | 70    |

<br>

上述过程在所有三个商店上重复，得到如下所示的 DataFrame ：

`b`

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store2 | 100   |

<br>

`c`

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store3 | 105   |
| 1          | store3 | 80    |

<br>

最后，我们使用 `concat()` 函数将三个 DataFrame `a`、`b` 和 `c` 连接在一起。我们沿着列轴堆叠它们，这由在 `concat()` 函数中将参数 `axis` 设置为 1 来指示。由于三个 DataFrame 具有匹配的列名和顺序，因此我们可以将它们连接起来。结果就是我们得到了期望的输出 `answer`。完整的代码如下。

```Python
import pandas as pd

def rearrange_products_table(products: pd. DataFrame ) -> pd. DataFrame : 
    a = products.loc[products['store1'].notna(), ['product_id', 'store1']]
    a['store'] = "store1"
    a.rename(columns={'store1':'price'}, inplace=True)
    a = a[['product_id', 'store', 'price']]

    b = products.loc[products['store2'].notna(), ['product_id', 'store2']]
    b['store'] = "store2"
    b.rename(columns={'store2':'price'}, inplace=True)
    b = b[['product_id', 'store', 'price']]
    
    c = products.loc[products['store3'].notna(), ['product_id', 'store3']]
    c['store'] = "store3"
    c.rename(columns={'store3':'price'}, inplace=True)
    c = c[['product_id', 'store', 'price']]
      
    answer = pd.concat([a, b, c])
    return answer
```

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store1 | 95    |
| 1          | store1 | 70    |
| 0          | store2 | 100   |
| 0          | store3 | 105   |
| 1          | store3 | 80    |



<br>


#### MySQL

我们的任务是重新排列表格，这可以看作是将三个商店列组合成一列，并保留每个 `product_id` 对应的 `price`。为了实现这一点，我们可以使用 UNION 操作将数据连接在一起。

UNION 操作将多个 SELECT 语句的结果合并为一个结果集。我们可以使用三个 SELECT 语句分别获取每个商店列的数据，并使用 UNION 将它们合并。

以第一个表格为例，我们使用 SELECT 语句从表格 `Produce` 中检索数据，其中 `store1` 列的值不为空，将字符串 "store1" 作为 `store` 列的值，并将 `store1` 列重命名为 `price`。

```Sql
SELECT product_id, 'store1' AS store, store1 AS price 
FROM Products 
WHERE store1 IS NOT NULL
```

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store1 | 95    |
| 1          | store1 | 70    |

<br>

最后，三个查询的结果合并成一个具有列 `product_id`、`store` 和 `price` 的单一表格。

```Sql
SELECT product_id, 'store1' AS store, store1 AS price 
FROM Products 
WHERE store1 IS NOT NULL

UNION 
SELECT product_id, 'store2' AS store, store2 AS price 
FROM Products 
WHERE store

2 IS NOT NULL

UNION 
SELECT product_id, 'store3' AS store, store3 AS price 
FROM Products 
WHERE store3 IS NOT NULL
```


---

### 方法 2：透视表

虽然上述方法在处理少数商店时可能有效，但当处理大量列时（假设有从 `store1` 到 `store100` 共 100 列）可能会变得繁琐且低效。

#### Pandas

一种更高效且可扩展的堆叠多个列的方法是使用 Pandas 中的 `melt()` 方法。它可以将 DataFrame 从宽格式（wide format）转换为长格式（long format），并可以选择保留标识符。我们可以指定要堆叠的列及其对应的名称，从而更轻松地处理单个操作中的大量列。

我们的例子中设置的参数如下。`id_vars` 表示用作标识符变量的列，这里是 `product_id`。`value_vars` 表示要进行堆叠的列。`var_name='store'` 表示包含 `value_vars` 的列将被命名为 `store`。`value_name='price'` 表示'值'的列将被命名为 `price`。

```Python
df = products.melt(
    id_vars='product_id', 
    value_vars=['store1', 'store2', 'store3'],
    var_name='store', 
    value_name='price'
    )
```

另外，如果不指定 `value_vars` 参数，它将自动包括所有不在 `id_vars` 中的列（`store1`、`store2` 和 `store3`），这完全符合我们的需求。因此，语法可以更加简洁：

```Python
df = products.melt(
    id_vars='product_id', 
    var_name='store', 
    value_name='price'
    )
```

我们将得到以下转换后的 DataFrame `df`：

| product_id | store  | price |
| ---------- | ------ | ----- |
| 0          | store1 | 95    |
| 1          | store1 | 70    |
| 0          | store2 | 100   |
| 1          | store2 | NA    |
| 0          | store3 | 105   |
| 1          | store3 | 80    |

<br>

我们的目标是保留 `price` 列中有有效值的行，并消除那些包含缺失值的行。为了实现这一点，我们使用 `dropna()` 函数，指定 `axis=0` 表示我们要删除包含空值的行。通过这样做，我们有效地过滤掉了包含缺失价格值的行，得到了一个 DataFrame `df`，它只包含所需的行。

完整的代码如下所示：

```Python
import pandas as pd

def rearrange_products_table(products: pd. DataFrame ) -> pd. DataFrame : 
    df = products.melt(id_vars='product_id', var_name='store', value_name='price')
    df = df.dropna(axis=0)
    return df
```
| product_id | store  | price |
|------------|---------|--------|
| 0          | store1  | 95     |
| 1          | store1  | 70     |
| 0          | store2  | 100    |
| 0          | store3  | 105    |
| 1          | store3  | 80     |

<br>