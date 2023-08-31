## [183.从不订购的客户 中文官方题解](https://leetcode.cn/problems/customers-who-never-order/solutions/100000/customers-who-never-order-by-leetcode-so-w44h)
[TOC]

## 解决方案

---

#### 方法 1：使用排除条件过滤数据

**思路**

判断客户是否曾经下过订单的条件是：如果一个客户 ID 在 `orders` 表中不存在，这就意味着他们从未下过订单。

因此，我们可以使用行过滤来移除不满足条件的客户 ID。

> 在 Pandas 中：
>
> -  `isin(values)` 用于基于其值是否在给定集合 `values` 中来过滤和选择行。
> -  `~` 表示逻辑非。
>
> 因此，可以通过`~isin(values)` 来选择它们的值不存在于 `values` 中的行。



**MySQL**

```Sql
select *
from customers
where customers.id not in
(
    select customerid from orders
);
```

**Pandas**

```Python
# Select the rows which `id` is not present in orders['customerId'].
df = customers[~customers['id'].isin(orders['customerId'])]
```

我们将得到以下表格：

| id   | name  |
| ---- | ----- |
| 2    | Henry |
| 4    | Max   |


<br>

请注意，要求只返回满足条件的名称，并将列 `name` 重命名为 `Customers`。

**MySQL**

```Sql
select customers.name as 'Customers'
from customers
where customers.id not in
(
    select customerid from orders
);
```

**Pandas**

```Python
# 创建一个只包含 name 列的数据框架
# 并将列 name 重命名为 Customers。
df = df[['name']].rename(columns={'name': 'Customers'})
```

这是结果表格：

| Customers |
| --------- |
| Henry     |
| Max       |



<br>

综上所述，完整的答案如下：


**MySQL**

```Sql
select customers.name as 'Customers'
from customers
where customers.id not in
(
    select customerid from orders
);
```

**Pandas**

```Python
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    # 选择 orders['customerId'] 中 'id' 不存在的行。
    df = customers[~customers['id'].isin(orders['customerId'])]

    # 创建一个只包含 name 列的数据框架
	# 并将列 name 重命名为 Customers。
    df = df[['name']].rename(columns={'name': 'Customers'})
    return df
```


<br>

---

#### 方法 2：在 `customers` 上进行左连接（Left Join）

思路是基于共同的客户 ID（在 `customers` 表中的 `id` 列和 `orders` 表中的 `customerId` 列），将表 `customers` 与表 `orders` 进行连接。

通过进行左连接，并选择 `customerId` 为 `null` 的记录，我们可以确定哪些客户没有下过订单。

> 我们使用左连接（Left Join）在 `customers` 上，因为我们希望将所有来自 `customers` 的客户都包括进来，无论他们是否下过订单。
> 因此，通过使用左连接，我们可以保留所有来自左表（`customers`）的行，并将它们与右表（`orders`）中基于 `id` 和 `customerId` 进行匹配的相应行分别对应。

**MySQL**

```sql
SELECT * 
FROM Customers c
LEFT JOIN Orders o
ON c.Id = o.CustomerId
```

**Pandas**

```Python
df = customers.merge(orders, left_on='id', right_on='customerId', how='left')
```

该表将如下所示：

| id   | name  | id   | customerId |
| ---- | ----- | ---- | ---------- |
| 1    | Joe   | 2    | 1          |
| 2    | Henry | null | null       |
| 3    | Sam   | 1    | 3          |
| 4    | Max   | null | null       |


<br>

接下来的步骤是通过选择 `customerId` 为 null 的行来过滤连接后的表格，这可以筛选出没有下过订单的客户。

**MySQL**

```Sql
SELECT * 
FROM Customers
LEFT JOIN Orders ON Customers.Id = Orders.CustomerId
WHERE Orders.CustomerId IS NULL
```

**Pandas**

```Python
df = df[result['customerId'].isna()]
```

该表将如下所示：

| id   | name  | id   | customerId |
| ---- | ----- | ---- | ---------- |
| 2    | Henry | null | null       |
| 4    | Max   | null | null       |

<br>

类似地，我们只返回满足条件的行的名称，并将列 `name` 重命名为 `Customers`。

**MySQL**

```Sql
SELECT name AS 'Customers'
FROM Customers
LEFT JOIN Orders ON Customers.Id = Orders.CustomerId
WHERE Orders.CustomerId IS NULL
```

**Pandas**

```Python
df = df[['name']].rename(columns={'name': 'Customers'})
```

这是结果表格：

| Customers |
| --------- |
| Henry     |
| Max       |


<br>

综上所述，完整的答案如下：

**MySQL**

```Sql
SELECT name AS 'Customers'
FROM Customers
LEFT JOIN Orders ON Customers.Id = Orders.CustomerId
WHERE Orders.CustomerId IS NULL
```

**Pandas**
```Python
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    df = customers.merge(orders, left_on='id', right_on='customerId', how='left')
    df = df[df['customerId'].isna()]
    df = df[['name']].rename(columns={'name': 'Customers'})
    return df
```