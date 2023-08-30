#### 预备知识

本题使用到的 `MySQL` 函数的说明：

- `ifnull(x1, x2)` ：如果 `x1` 为 `NULL`， 返回 `x2`，否则返回 `x1`。

#### 方法一：`left join` 和 `group by`

**思路**

首先根据 `Orders` 表计算每个用户的订单数，通过 `buyer_id` 和 `Users` 表的 `user_id` 将两份数据结合，找到所有用户的注册时间和订单的数量。

**注意**：用户订单的数量可能会 `0`，需要使用 `ifnull` 函数特殊处理这种数据。

**算法**

1. 使用 `Orders` 表计算每个用户的产品数。使用 `group by` 聚合每个用户的购买记录。使用 `between` 筛选出时间为 `2019` 年的数据。使用 `count(order_id)` 计算出每个用户的订单数。
```Mysql [ ]
select buyer_id, count(order_id) cnt 
from Orders
where order_date between '2019-01-01' and '2019-12-31'
group by buyer_id
```
2. 使用 `Users` 表得到所有用户及其注册时间。并使用 `left join`，通过 `user_id` 和第一步的数据连接，求每个用户的订单数。 如果一个用户没有任何订单，那么第一步的数据中不会有这个用户的数据，最后的 `orders_in_2019` 会显示为 `null`，所以我们还需要使用 `ifnull`，如果数据为 `null`，将其改为 `0`。

**代码**

```Mysql [ ]
select Users.user_id as buyer_id, join_date, ifnull(UserBuy.cnt, 0) as orders_in_2019
from Users
left join (
    select buyer_id, count(order_id) cnt 
    from Orders
    where order_date between '2019-01-01' and '2019-12-31'
    group by buyer_id
) UserBuy
on Users.user_id = UserBuy.buyer_id
```