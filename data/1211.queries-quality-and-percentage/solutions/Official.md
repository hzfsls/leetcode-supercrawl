## [1211.查询结果的质量和占比 中文官方题解](https://leetcode.cn/problems/queries-quality-and-percentage/solutions/100000/cha-xun-jie-guo-de-zhi-liang-he-zhan-bi-by-leetcod)

#### 方法一：`GROUP BY`

**思路**

本题主要考察在 `MySQL` 内做简单的计算操作，比如求平均值，求和等。在解题前先回顾一下相关的函数。

> `SUM()`：返回某列的和。
> `AVG()`：返回某列的平均值。
> `COUNT()` ：返回某列的行数。
> `MAX()` ：返回某列的最大值。
> `MIN()` ：返回某列的最小值。

根据题意我们需要计算的是每个名称的数据，可以使用 `GROUP BY` 对名称（`query_name`）进行聚合，然后再处理数据。

1. 计算质量 `quality`：

> 各查询结果的评分与其位置之间比率的平均值。

评分与其位置之前的比率为 `rating/position`， 平均值为：

```Mysql
AVG(rating/position)
```

2. 计算劣质查询百分比 `poor_query_percentage`：

> 评分小于 3 的查询结果占全部查询结果的百分比。

评分小于 3 的数量可以使用 `SUM` 和 `IF`，如果 `rating` 小于 3，那么数量加 1。全部查询结果可以直接使用 `COUNT()`。因为要求的是百分比，所以分子需要乘 100。

```Mysql
SUM(IF(rating < 3, 1, 0)) * 100 / COUNT(*)
```

最后不要忘记使用 `ROUND()` 函数将结果**四舍五入到小数点后两位**。

**代码**

```Mysql [ ]
SELECT 
    query_name, 
    ROUND(AVG(rating/position), 2) quality,
    ROUND(SUM(IF(rating < 3, 1, 0)) * 100 / COUNT(*), 2) poor_query_percentage
FROM Queries
GROUP BY query_name
```