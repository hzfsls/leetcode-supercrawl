## [1204.最后一个能进入巴士的人 中文官方题解](https://leetcode.cn/problems/last-person-to-fit-in-the-bus/solutions/100000/zui-hou-yi-ge-neng-jin-ru-dian-ti-de-ren-by-leetco)
#### 方法一：自连接

**思路**

我们需要根据 `turn` 排序， 并累加 `weight`，找到最后一个使得总和小于等于 1000 的 `person_name`。

参照题目中的例子：
```
true = 1, weight = 250, sum = 250
true = 2, weight = 350, sum = 600
true = 3, weight = 400, sum = 1000
```
我们只需要计算出每个人进去后的总和，找到总和小于等于 1000 的最后一个人即可。

我们可以使用自连接的方法计算直到当前人的重量的总和，即：
```Mysql [ ]
SELECT * FROM Queue a, Queue b
```

将 `b` 表中的每一条数据和 `a` 表的每一条数据连接。假设 `Queue` 表有 3 条记录，那么自连接后将会有 9 条数据，分别为 `(a1 b1),(a1 b2),(a1 b3),(a2 b1),(a2 b2),(a2 b3),(a3 b1),(a3 b2),(a3 b3)` 。

接下来对连接后的数据进行处理，我们使用 `a` 表的 `person_id` 表示自身，`b` 表中的数据表示为包括自己在内的所有人。使用 `GROUP BY a.person_id` 处理每个人的数据。因为要计算每个人的 `weight` 加上之前所有人的 `weight`，使用查询条件 `a.turn >= b.turn` 找到所有在他之前以及他自己的重量。再使用 `SUM` 计算总和并过滤掉大于 1000 的数据。

拿到所有满足条件的数据后，只需要再对 `a.turn` 倒序取第一条即可。

**代码**

```Mysql [ ]
SELECT a.person_name
FROM Queue a, Queue b
WHERE a.turn >= b.turn
GROUP BY a.person_id HAVING SUM(b.weight) <= 1000
ORDER BY a.turn DESC
LIMIT 1
```

#### 方法二：自定义变量

**思路**

根据上面的思路，我们还可以使用自定义变量。

将每一条记录的 `weight` 按照 `turn` 的顺序和自定义变量相加并生成新的记录。生成临时表并处理。
```Mysql [ ]
SELECT person_name, @pre := @pre + weight AS weight
FROM Queue, (SELECT @pre := 0) tmp
ORDER BY turn
```

**代码**

```Mysql [ ]
SELECT a.person_name
FROM (
	SELECT person_name, @pre := @pre + weight AS weight
	FROM Queue, (SELECT @pre := 0) tmp
	ORDER BY turn
) a
WHERE a.weight <= 1000
ORDER BY a.weight DESC
LIMIT 1
```