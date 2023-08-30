#### 方法一：`UNION ALL`

**思路**

本题要求 **每组的获胜者是在组内得分最高的选手**，那么肯定要求出每个选手的总得分。每个选手的得分可能是 `first_score` 或者 `second_score`，我们需要将两个分数相加。

我们可以使用 `GROUP BY` 和 `SUM()` 函数，求出每个用户的 `first_score` 的和。 
```Mysql [] 
SELECT player_id, SUM(first_score) AS score
FROM Matches
GROUP BY player_id
```

因为需要知道每个选手的 `group_id`，可以使用 `JOIN` 将 `Players` 表 和 `Matches` 表通过 `player_id` 关联来获取 `group_id`。
```Mysql [] 
SELECT Players.group_id, Players.player_id, SUM(Matches.first_score) AS score
FROM Players JOIN Matches ON Players.player_id = Matches.first_player
GROUP BY Players.player_id
```
同样的方法我们可以计算出每个用户总的 `second_score`。

得到每个选手两个分数的总和后将两个分数相加，得到每个用户的总得分。我们可以使用 `UNION ALL` 将这两个结果集合并。将这些数据看作数据表，使用 `FROM` 子句和 `GROUP BY`。
```Mysql []
SELECT group_id, player_id, SUM(score) AS score
FROM (
    SELECT Players.group_id, Players.player_id, SUM(Matches.first_score) AS score
    FROM Players JOIN Matches ON Players.player_id = Matches.first_player
    GROUP BY Players.player_id

    UNION ALL

    SELECT Players.group_id, Players.player_id, SUM(Matches.second_score) AS score
    FROM Players JOIN Matches ON Players.player_id = Matches.second_player
    GROUP BY Players.player_id
) s
GROUP BY player_id
```

得到每个用户的总分后，需要找到组内得分最高的选手。那么我们可以使用 `ORDER BY`，先根据得分倒序排列。如果平局，`player_id` 最小的选手获胜，那么只要再根据 `player_id` 正序排。
```Mysql [ ]
ORDER BY score DESC, player_id
```

最后只需要再使用一次 `FROM` 子句和 `GROUP BY` 取出每个组的第一条数据即可。

**代码**

```Mysql [ ]
SELECT group_id, player_id
FROM (
    SELECT group_id, player_id, SUM(score) AS score
    FROM (
        -- 每个用户总的 first_score
        SELECT Players.group_id, Players.player_id, SUM(Matches.first_score) AS score
        FROM Players JOIN Matches ON Players.player_id = Matches.first_player
        GROUP BY Players.player_id

        UNION ALL

        -- 每个用户总的 second_score
        SELECT Players.group_id, Players.player_id, SUM(Matches.second_score) AS score
        FROM Players JOIN Matches ON Players.player_id = Matches.second_player
        GROUP BY Players.player_id
    ) s
    GROUP BY player_id
    ORDER BY score DESC, player_id
) result
GROUP BY group_id
```