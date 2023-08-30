#### 预备知识

本题使用到的 `MySQL` 函数的说明：

- `IFNULL(x1, x2)` ：如果 `x1` 为 `NULL`， 返回 `x2`，否则返回 `x1`。

#### 方法一：`left join` 和 `ifnull`

**思路**

本题的关键点在找到 `2019-08-16` 前所有有改动的产品及其最新价格和没有没有修改过价格的产品。

我们可以先找到所有的产品，再找到所有 `2019-08-16` 前有修改的产品和他们最新的价格，使用 `left join` 将两个查询联合。如果产品没有价格，说明没有修改过，设置为 `10`，如果有价格，设置为最新的价格。

**算法**

1. 找出所有的产品：
```Mysql [ ]
select distinct product_id from products 
```
2. 找到 `2019-08-16` 前所有有改动的产品的最新价格。
    1. 使用 `max` 函数找到产品最新修改的时间。使用 `where` 查询限制时间小于等于 `2019-08-16`：
    
    ```Mysql [ ]
    select product_id, max(change_date)
    from products
    where change_date <= '2019-08-16'
    group by product_id
    ```
    2. 使用 `where` 子查询，根据 `product_id` 和 `change_date` 找到对应的价格：
    
    ```Mysql [ ]
    select product_id, new_price 
    from products
    where (product_id, change_date) in (
        select product_id, max(change_date)
        from products
        where change_date <= '2019-08-16'
        group by product_id
    )
    ```
3. 上面两步已经找到了所有的产品和已经修改过价格的产品。使用 `left join` 得到所有产品的最新价格，如果没有设置为 `10`。

**代码**

```Mysql [ ]
select p1.product_id, ifnull(p2.new_price, 10) as price
from (
    select distinct product_id
    from products
) as p1 -- 所有的产品
left join (
    select product_id, new_price 
    from products
    where (product_id, change_date) in (
        select product_id, max(change_date)
        from products
        where change_date <= '2019-08-16'
        group by product_id
    )
) as p2 -- 在 2019-08-16 之前有过修改的产品和最新的价格
on p1.product_id = p2.product_id
```