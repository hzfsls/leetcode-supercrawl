[TOC]

## 解决方案

---

#### 方法：分组

**Pandas**

我们需要找到下了最多订单的客户，这涉及到计算每个客户的订单数量。可以通过将订单按照每个唯一客户进行分组来完成。因此，我们将 DataFrame `orders` 按列 `customer_number` 进行分组，并应用 `size()` 方法来计算 `customer_number` 中每个唯一值的出现次数，这表示每个客户下的订单数量。

`reset_index(name='count')` 用于给结果列指定一个新名称 `count`，这一步确保结果 DataFrame `df` 有两列：`customer_number` 和 `count`。


```Python
df = orders.groupby('customer_number').size().reset_index(name='count')
```

我们将得到以下 DataFrame `df`：

| customer_number | count |
| --------------- | ----- |
| 1               | 1     |
| 2               | 1     |
| 3               | 2     |


<br>

一旦我们获得了每个客户的订单数量，我们可以按照 `count` 列进行降序排序。

```Python
df.sort_values(by='count', ascending = False, inplace=True)
```

| customer_number | count |
| --------------- | ----- |
| 3               | 2     |
| 1               | 1     |
| 2               | 1     |


<br>

接下来，我们返回第一行中的 `customer_number`，这表示下了最多订单的客户。完整的代码如下：


```Python
import pandas as pd

def largest_orders(orders: pd.DataFrame) -> pd.DataFrame:
    # 如果 orders 为空，返回一个空的 DataFrame。
    if orders.empty:
        return pd.DataFrame({'customer_number': []})

    df = orders.groupby('customer_number').size().reset_index(name='count')
    df.sort_values(by='count', ascending = False, inplace=True)
    return df[['customer_number']][0:1]
```

我们将得到以下 DataFrame：

| customer_number |
| --------------- |
| 3               |


<br>

**MySQL**

首先，我们可以使用 `GROUP BY` 选择 `customer_number` 以及相应的订单数量。

```Sql
SELECT
    customer_number, COUNT(*)
FROM
    orders
GROUP BY customer_number
```

| customer_number | COUNT(*) |
| --------------- | -------- |
| 1               | 1        |
| 2               | 1        |
| 3               | 2        |



然后，通过按订单数量降序排序它们，第一行的 **customer_number** 就是结果。

| customer_number | COUNT(*) |
| --------------- | -------- |
| 3               | 2        |



在 MySQL 中，[LIMIT](https://dev.mysql.com/doc/refman/5.7/en/select.html) 子句可用于限制 SELECT 语句返回的行数。它接受一个或两个非负数值参数，第一个指定要返回的第一行的偏移量，第二个指定要返回的最大行数。初始行的偏移量为 0（不是 1）。

它可以与一个参数一起使用，该参数指定从结果集的开始返回的行数。因此，`LIMIT 1` 将返回第一条记录。


```Sql
SELECT
    customer_number
FROM
    orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1
;
```