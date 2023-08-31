## [1225.报告系统状态的连续日期 中文官方题解](https://leetcode.cn/problems/report-contiguous-dates/solutions/100000/bao-gao-xi-tong-zhuang-tai-de-lian-xu-ri-qi-by-lee)

#### 方法一：变量法

**思路**

本题最关键的一步是要找到**同状态连续的时间记录**，也就是要将连续的时间分到同一个组内，然后只需要在组内找到最小和最大的时间即可。

首先处理 `Succeeded` 表，一个比较简单的想法是给所有的记录分配一个 `id`，连续的时间 `id` 相同。使用 `pre_date` 表示上一条记录的时间，如果当前时间和 `pre_date` 的时间相差为 1，那么他们是连续的时间，`id` 相同，否则，当前记录的 `id` 要和上一个记录 `id` 不同，这里可以使用 `id + 1` 表示。
1. 使用 `DATEDIFF` 计算两条记录的时间差。并将 `pre_date` 设置为当前时间，供下一次计算使用。
    `DATEDIFF(@pre_date, @pre_date := success_date)`
2. 使用 `IF` 判断当前记录的 `id`。
    `IF(DATEDIFF(@pre_date, @pre_date := success_date) = -1, @id, @id := @id+1)`

使用上面的方法我们可以给 `Succeeded` 表的每一条记录添加一个 `id`。然后我们就可以使用 `GROUP BY` 将 `id` 相同的分到一组，计算最小和最大时间。

```Mysql
SELECT MIN(date) as start_date, MAX(date) as end_date
FROM (
    SELECT
        success_date AS date,
        IF(DATEDIFF(@pre_date, @pre_date := success_date) = -1, @id, @id := @id+1) AS id 
        FROM Succeeded, (SELECT @id := 0, @pre_date := NULL) AS temp
) T
GROUP BY T.id
```

对于 `Failed` 表也是一样的操作，这里我们需要加一个 `period_state` 区分两个表的状态。

对于两个表，我们可以使用 `UNION` 将添加完 `id` 的记录合并。并使用 `WHERE` 查询过滤不符合要求的记录 `WHERE date BETWEEN "2019-01-01" AND "2019-12-31"`。

最后将合并后的记录进行 `GROUP BY` 和 `ORDER BY`。

**代码**

```MySQL []
SELECT period_state, MIN(date) as start_date, MAX(date) as end_date
FROM (
    SELECT
        success_date AS date,
        "succeeded" AS period_state,
        IF(DATEDIFF(@pre_date, @pre_date := success_date) = -1, @id, @id := @id+1) AS id 
    FROM Succeeded, (SELECT @id := 0, @pre_date := NULL) AS temp
    UNION
    SELECT
        fail_date AS date,
        "failed" AS period_state,
        IF(DATEDIFF(@pre_date, @pre_date := fail_date) = -1, @id, @id := @id+1) AS id 
    FROM Failed, (SELECT @id := 0, @pre_date := NULL) AS temp
) T  WHERE date BETWEEN "2019-01-01" AND "2019-12-31"
GROUP BY T.id
ORDER BY start_date ASC
```