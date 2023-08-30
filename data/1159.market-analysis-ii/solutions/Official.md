#### 预备知识

1. MySQL 中，使用 `@` 来定义一个变量。比如：`@a`。
2. MySQL 中，使用 `:=` 来给变量赋值。比如： `@a := 123`，表示变量 `a` 的值为 `123`。
3. MySQL 中，`if(A, B, C)` 表示如果 `A` 成立， 那么执行并返回 `B`，否则执行并返回 `C`。

#### 方法一：变量 和 `left join`

**思路**

本题最重要的就是**找到每一个用户按日期顺序卖出的第二件商品的品牌**，很显然这里需要使用排序找到第二件商品，并且需要找到对应商品的品牌。找到对应的品牌后再去和用户表比较，是否为用户喜欢的品牌，最后得出结果。

**算法**
1. 找到每一个用户按日期顺序卖出的第二件商品的品牌。因为 MySQL 中没有 `rank()` 函数，所以需要自己实现排序。我们可以使用 `order by` 和 变量的方法给数据排序。
    1. 根据 `seller_id` 和 `order_date` 对 `order` 表排序。这样每个用户的数据都是连续的，并且按照时间排序好的。
    2. 使用 `if` 判断 `seller_id`，如果 `seller_id` 相等，排名加一，并使用变量记录每一行的排名。这样就可以得到每个用户卖出商品的排名。
 ```Mysql [ ]
select 
    @rk := if (@seller = a.seller_id, @rk + 1, 1) as rank, -- 计算排名
    @seller := a.seller_id as seller_id, 
    a.item_id
from (
    select seller_id, item_id
    from orders 
    order by seller_id, order_date -- 排序
) a, (select @seller := -1, @rk := 0) b -- 初始化变量
 ```
2. 得到每个用户按日期顺序卖出商品的排名后，将得到的数据命名为 `r1`，我们需要获取第二件商品的品牌，即 `r1.rank = 2` 对应的记录。再使用 `join` 将排名表和 `items` 表根据`item_id`连接，得到每个用户对应第二件商品的品牌。
```Mysql [ ]
select r1.seller_id, items.item_brand from r1
join items 
on r1.item_id = items.item_id
where r1.rank = 2
```
3. 第二步得到数据记为 `r2`。得到用户卖出的第二件商品的品牌后需要和用户最爱的品牌比较。注意，因为用户卖出的数量有可能小于 2，这种情况下，第二步的结果中是没有这个用户的记录。所以需要使用左连接 `left join` 输出所有的用户。当 `r2.item_brand` 为空或者 `r2.item_brand != users.favorite_brand` 时，需要输出 `no`。我们可以使用 `if()` 函数处理这部分逻辑。

**代码**

```Mysql [ ]
select user_id as seller_id, if (r2.item_brand is null || r2.item_brand != favorite_brand, "no", "yes") as 2nd_item_fav_brand
from users
left join (
    select r1.seller_id, items.item_brand from (
        select 
            @rk := if (@seller = a.seller_id, @rk + 1, 1) as rank,
            @seller := a.seller_id as seller_id, 
            a.item_id
        from (
            select seller_id, item_id
            from orders 
            order by seller_id, order_date
        ) a, (select @seller := -1, @rk := 0) b) r1
    join items 
    on r1.item_id = items.item_id
    where r1.rank = 2
) r2 on user_id = r2.seller_id;
```