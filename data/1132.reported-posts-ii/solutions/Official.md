### 预备知识

本题使用到的 `mysql` 函数的说明：

- `ROUND(x, d)`： 四舍五入保留 `x` 的 `d` 位小数。
- `AVG()`： 计算平均值 。
- `IFNULL(x1, x2)` ：如果 `x1` 为 `NULL`， 返回 `x2`。

### 方法一：`LEFT JOIN` 、 `GROUP BY` 和 `FROM` 子查询

#### 思路

主要思想：先计算出每一天被移除的帖子的占比，最后求平均值。

既然要求占比，肯定要求出分子和分母。根据题意可以知道 `removals` 表中的数据是分子，`actions` 表中的数据是分母。两个表根据 `post_id` 可以对应起来。所以可以使用 `LEFT JOIN` 将两个表结合起来。因为题目要的是每天的数据，所以还需要使用 `GROUP BY` 将相同日期的数据聚合。最后统计分子和分母的值相除得出结果。

这里还有两个需要注意的点：

1. 因为表中可能存在重复的行，所以有可能同一天有相同的 `post_id`，但是只需要统计一次，所以要用 `DISTINCT` 去重。

2. 因为 `actions` 表是真正需要查询的数据，所以需要使用左连接。

```Mysql [ ]
SELECT actions.action_date, COUNT(DISTINCT removals.post_id)/COUNT(DISTINCT actions.post_id) AS proportion
FROM actions
LEFT JOIN removals
ON actions.post_id = removals.post_id
WHERE extra = 'spam' 
GROUP BY actions.action_date
```

拿到每一天的占比后，只需要用 `FROM` 子查询，将所有的结果求平均值并且四舍五入保留两位有效数字即可。

#### 代码

```mysql []
SELECT ROUND(AVG(proportion) * 100, 2) AS average_daily_percent  
FROM (
    SELECT actions.action_date, COUNT(DISTINCT removals.post_id)/COUNT(DISTINCT actions.post_id) AS proportion
    FROM actions
    LEFT JOIN removals
    ON actions.post_id = removals.post_id
    WHERE extra = 'spam' 
    GROUP BY actions.action_date
) a
```

### 方法二：`LEFT JOIN` 和 `GROUP BY`

#### 思路

主要思想：方法一是直接求出占比的集合，此方法是先求出分子和分母各自的集合，再进行计算并求平均值。
先求出分子的集合：
```mysql []
SELECT action_date, COUNT(DISTINCT post_id) AS cnt
FROM actions
WHERE extra = 'spam' AND post_id IN (SELECT post_id FROM Removals)
GROUP BY action_date
```

再求出分母的集合：
```mysql []
SELECT action_date, COUNT(DISTINCT post_id) AS cnt
FROM actions
WHERE extra = 'spam'
GROUP BY action_date
```
使用 `LEFT JOIN` 将两个结果根据日期结合计算平均值。

#### 代码

```mysql []
SELECT ROUND(AVG(IFNULL(remove.cnt, 0)/total.cnt) * 100, 2) AS average_daily_percent
FROM (
    SELECT action_date, COUNT(DISTINCT post_id) AS cnt
    FROM actions
    WHERE extra = 'spam'
    GROUP BY action_date
) total
LEFT JOIN (
    SELECT action_date, COUNT(DISTINCT post_id) AS cnt
    FROM actions
    WHERE extra = 'spam' AND post_id IN (SELECT post_id FROM Removals)
    GROUP BY action_date
) remove 
ON total.action_date = remove.action_date
```