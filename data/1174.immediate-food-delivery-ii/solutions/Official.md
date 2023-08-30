#### 方法一：`where` 子查询 和 `group by`

**思路**

本题是 [1173. 即时食物配送 I](https://leetcode-cn.com/problems/immediate-food-delivery-i/) 的进阶。本题需要求出**即时订单在所有用户的首次订单中的比例**，在上一题的基础上，我们只需要查询出所有用户的首单数据，然后利用上一题的思路处理新的数据即可，详见 [1173. 即时食物配送 I 官方题解](https://leetcode-cn.com/problems/immediate-food-delivery-i/solution/ji-shi-shi-wu-pei-song-i-by-leetcode-solution/)。

因此，本题最重要的就是求每一个用户的首单数据：我们使用 `group by` 聚合每个用户的数据，再使用 `min` 函数求出首单的时间。将 `(customer_id, order_date)` 作为查询条件，使用 `where in` 便可查出具体的数据。

**代码**

``` Mysql [ ]
select round (
    sum(order_date = customer_pref_delivery_date) * 100 /
    count(*),
    2
) as immediate_percentage
from Delivery
where (customer_id, order_date) in (
    select customer_id, min(order_date)
    from delivery
    group by customer_id
)
```