## [1264.页面推荐 中文官方题解](https://leetcode.cn/problems/page-recommendations/solutions/100000/ye-mian-tui-jian-by-leetcode-solution)

#### 方法一： `UNION ALL`

**思路**

本题最直观的思路就是找到所有 `user_id = 1` 的朋友，找到他们喜欢的 `page_id`，再去掉 `user_id = 1` 喜欢的 `page_id`。

伪代码如下：
```
SELECT page_id 
FROM Likes WHERE
user_id IN (friends) AND page_id NOT IN (user_id = 1 like page)
```

根据上面的伪代码，我们只需要求出 `friends` 和 `user_id = 1 like page` 就能完成本题。

首先我们求 `friends`。通过 `Friendship` 可以得到所有的朋友。`user_id = 1` 有可能在 `user1_id`，也有可能在 `user2_id`。因此我们需要两个 sql 分别求出朋友。
1. `SELECT user1_id AS user_id FROM Friendship WHERE user2_id = 1`
2. `SELECT user2_id AS user_id FROM Friendship WHERE user1_id = 1`

使用 `UNION ALL` 或者 `UNION` 得到所有的朋友 （`UNION ALL` 和 `UNION` 的区别在于后者会去掉重复的行，前者不会，这里使用前者更高效）。

然后我们再求 `user_id = 1 like page`。这个也很简单，直接对表 `Likes` 使用 `WHERE` 语句即可。

```
SELECT page_id FROM Likes WHERE user_id = 1
```

**代码**

```mysql [sol1-MySQL]
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (
    SELECT user1_id AS user_id FROM Friendship WHERE user2_id = 1
    UNION ALL
    SELECT user2_id AS user_id FROM Friendship WHERE user1_id = 1
) AND page_id NOT IN (
    SELECT page_id FROM Likes WHERE user_id = 1
)
```

#### 方法二： `CASE WHEN`

**思路**

对于方法一的求 `friends`，我们还可以用 `CASE WHEN`。

首先筛选出符合条件的记录：

```mysql
SELECT * FROM Friendship WHERE user1_id = 1 OR user2_id = 1
```

然后使用 `CASE WHEN`，如果 `user1_id = 1`，取 `user2_id`。如果 `user2_id = 1`，则取 `user1_id`。

```mysql
SELECT (
    CASE
    WHEN user1_id = 1 then user2_id
    WHEN user2_id = 1 then user1_id
    END
) AS user_id
FROM Friendship
WHERE user1_id = 1 OR user2_id = 1
```

**代码**

```mysql [sol2-MySQL]
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (
    SELECT (
        CASE
        WHEN user1_id = 1 then user2_id
        WHEN user2_id = 1 then user1_id
        END
    ) AS user_id
    FROM Friendship
    WHERE user1_id = 1 OR user2_id = 1
)  AND page_id NOT IN (
    SELECT page_id FROM Likes WHERE user_id = 1
)
```