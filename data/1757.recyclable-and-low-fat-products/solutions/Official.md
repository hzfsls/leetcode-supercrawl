[TOC]

## 解决方案

---

### 方法：根据条件选择行

#### Pandas

我们有以下原始 DataFrame `products`：

| product_id | low_fats | recyclable |
| ---------- | -------- | ---------- |
| 0          | Y        | N          |
| 1          | Y        | Y          |
| 2          | N        | Y          |
| 3          | Y        | Y          |
| 4          | N        | N          |

在 Pandas 中，布尔索引允许我们通过使用布尔数组或条件来过滤 DataFrame。这意味着我们可以使用布尔值的 Series 或创建对于 DataFrame 中每一行都评估为 `True` 或 `False` 的条件。通过将这些布尔值或条件应用到 DataFrame 的索引，我们可以选择性地提取满足条件的行。

在这种情况下，我们应该选择 `low_fats` 列的值为"Y"（表示产品为低脂肪产品）且 `recyclable` 列的值为"Y"（表示产品可回收）的行，可以表示为：

```Python
df = products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')]
```

此过滤操作创建了一个新的 DataFrame `df`，其中包含满足上述条件的产品。请注意，`product_id` 等于 0、2 和 4 的行被过滤掉了。

| product_id | low_fats | recyclable |
| ---------- | -------- | ---------- |
| 1          | Y        | Y          |
| 3          | Y        | Y          |


<br>

接下来，我们需要从 `df` 中仅选择 `product_id` 列，使用双方括号。

```Python
df = df[['product_id']]
```

得到的 DataFrame 如下所示：

| product_id |
| ---------- |
| 1          |
| 3          |




完整的代码如下：

```Python
import pandas as pd

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    df = products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')]

    df = df[['product_id']]
    
    return df
```




#### MySQL

关键字 `SELECT` 用于指定我们想要从表 `Products` 中检索的列。在这种情况下，我们想要检索 `product_id` 列。

关键字 `WHERE` 用于根据特定条件过滤表 `Products` 中的行，条件是 `low_fats` 列的值为"Y"（表示低脂肪产品）且 `recyclable` 列的值为"Y"（表示可回收产品）。我们使用逻辑运算符 `AND` 将两个条件组合起来，确保最终结果只包含既是低脂肪产品又是可回收产品的产品ID。


```sql
SELECT
    product_id
FROM
    Products
WHERE
    low_fats = 'Y' AND recyclable = 'Y'
```