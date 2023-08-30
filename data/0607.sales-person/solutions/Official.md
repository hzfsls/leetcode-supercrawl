[TOC]

## 解决方案

---

#### 方法：连接表并使用 "NOT IN" 进行排除

如果我们知道所有在 'RED' 这家公司有销售记录的销售员，那么得知没有的销售员也就很容易了。

**Pandas**

我们通过将 DataFrame `orders` 和 `company` 进行连接，并选取具有 `name` 为 `'RED'` 的订单来获得与公司 **"RED"** 相关联的销售员。这样可以只保留与公司 **"RED"** 相关联的订单。

```Python
df = pd.merge(orders, company, on='com_id')

red_orders = df[df['name'] == 'RED']
```

我们将得到以下 DataFrame `red_orders`：

```
| order_id | date     | com_id | sales_id | amount | com_id | name | city   |
|----------|----------|--------|----------|--------|--------|------|--------|
| 3        | 3/1/2014 | 1      | 1        | 50000  | 1      | RED  | Boston |
| 4        | 4/1/2014 | 1      | 4        | 25000  | 1      | RED  | Boston |
```

<br>

接下来，我们使用 `red_orders.sales_id.unique()` 获取 `red_orders` 中所有唯一的销售员 ID。这些是每个销售员的标识符，并将帮助我们筛选出 "无效" 的销售员。我们将这些唯一的销售员 ID 存储在一个名为 `invalid_ids` 的变量中。在接下来的步骤中，我们将使用 `invalid_ids` 来筛选出与这些销售员 ID 中至少有一个匹配的 "无效" 的销售员，并关注与这些销售员 ID 无关的 "有效" 的销售员。

```Python
invalid_ids = red_orders.sales_id.unique()
```

我们将获得 `invalid_ids`：

```
[1 4]
```

<br>

接下来，我们将检查每个销售员的销售 ID 是否出现在 `invalid_ids` 中，这是唯一无效的销售员 ID 集合。这一步是为了选择那些销售员，他们的销售 ID 不在 `invalid_ids` 中。请注意，符号 `~` 取反条件，这意味着它保留那些销售员，他们的销售 ID 不在 `invalid_ids` 中。换句话说，我们检索与 "无效" 销售员 ID 无关的销售员。

```Python
valid_sales_person = sales_person[~sales_person['sales_id'].isin(invalid_ids)]
```

我们将得到以下 DataFrame `valid_sales_person`：

| sales_id | name | salary | commission_rate | hire_date  |
| -------- | ---- | ------ | --------------- | ---------- |
| 2        | Amy  | 12000  | 5               | 2010-05-01 |
| 3        | Mark | 65000  | 12              | 2008-12-25 |
| 5        | Alex | 5000   | 10              | 2007-02-03 |



<br>


请注意，根据问题要求，我们需要仅返回 `name` 列。因此完整的代码如下：

```Python
import pandas as pd

def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    df = pd.merge(orders, company, on='com_id')

    red_orders = df[df['name'] == 'RED']

    invalid_ids = red_orders.sales_id.unique()

    valid_sales_person = sales_person[~sales_person['sales_id'].isin(invalid_ids)]    

    return valid_sales_person[['name']]
```

| name |
| ---- |
| Amy  |
| Mark |
| Alex |




<br>

**MySQL**

首先，我们可以查询公司 'RED' 的销售信息，并将其作为临时表。然后尝试将这个表与 **salesperson** 表建立连接，因为它有销售员的名字信息。

```Sql
SELECT
    *
FROM
    orders o
        LEFT JOIN
    company c ON o.com_id = c.com_id
WHERE
    c.name = 'RED'
;
```

>注意："LEFT OUTER JOIN" 可以写为 "LEFT JOIN"。

```
| order_id | date     | com_id | sales_id | amount | com_id | name | city   |
|----------|----------|--------|----------|--------|--------|------|--------|
| 3        | 3/1/2014 | 1      | 1        | 50000  | 1      | RED  | Boston |
| 4        | 4/1/2014 | 1      | 4        | 25000  | 1      | RED  | Boston |
```

显然，表中的 *sales_id* 列存在于 **salesperson** 表中，所以我们可以将其作为子查询的条件，然后使用 [`NOT IN`](https://dev.mysql.com/doc/refman/5.7/en/any-in-some-subqueries.html) 条件来获取目标数据。

**MySQL**

```Sql
SELECT
    s.name
FROM
    salesperson s
WHERE
    s.sales_id NOT IN (SELECT
            o.sales_id
        FROM
            orders o
                LEFT JOIN
            company c ON o.com_id = c.com_id
        WHERE
            c.name = 'RED')
;
```