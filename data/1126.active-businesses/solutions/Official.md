### 方法一：`JOIN` 和 `GROUP BY`

#### 思路

首先根据题目，必须要知道**所有业务中的平均发生次数**。所以需要计算每个业务的平均值，可以使用 `AVG` 函数和 `GROUP BY` 计算每个 `event_type` 的平均值。
```Mysql []
SELECT event_type, AVG(occurences) AS eventAvg
FROM Events
GROUP BY event_type
```

拿到平均值后使用 `JOIN` 将新的数据和老数据根据 `event_type` 联合在一起。判断老数据的 `occurences` 是否大于平均值。
```Mysql []
SELECT business_id
FROM Events AS e
JOIN (
    SELECT event_type, AVG(occurences) AS eventAvg
    FROM Events
    GROUP BY event_type
) AS e1 
ON e.event_type = e1.event_type
WHERE e.occurences > e1.eventAvg
```

题目最后还要求**至少有两个这样的事件类型**，所以需要再用一次 `GROUP BY` 将每一个业务聚合并判断事件类型的数量。

#### 代码

```Mysql []
SELECT business_id
FROM Events AS e
JOIN (
    SELECT event_type, AVG(occurences) AS eventAvg
    FROM Events
    GROUP BY event_type
) AS e1 
ON e.event_type = e1.event_type
WHERE e.occurences > e1.eventAvg
GROUP BY business_id
HAVING COUNT(*) >= 2
```