## [1241.每个帖子的评论数 中文官方题解](https://leetcode.cn/problems/number-of-comments-per-post/solutions/100000/mei-ge-tie-zi-de-ping-lun-shu-by-leetcode-solution)

#### 方法一：`LEFT JOIN`

**思路**

本题要求 **查找每个帖子的评论数**。首先我们需要找到所有帖子的 `id`，通过题目我们知道所有帖子的 `parent_id` 为 `null`。因此我们可以使用 `WHERE` 查询找到所有的帖子。

```Mysql
-- 因为可能有重复的行，因此需要使用 `DISTINCT` 去重
SELECT DISTINCT sub_id AS post_id FROM Submissions WHERE parent_id is null
```

然后根据找到的帖子的 `post_id` 找到对应的 `sub_id`。我们可以使用 `LEFT JOIN` 同一个表 `Submissions`。 左边是求 `post_id`，右边是求 `sub_id`，即 `Submissions post LEFT JOIN Submissions sub`。用 `post.sub_id` 和 `sub.parent_id` 将两表连接。

```Mysql
SELECT
    DISTINCT post.sub_id AS post_id,
    sub.sub_id AS sub_id
FROM Submissions post
LEFT JOIN Submissions sub
ON post.sub_id = sub.parent_id
WHERE post.parent_id is null
```

将上一步得到的表使用 `GROUP BY` 将所有的 `post_id` 分为一组，使用 `COUNT(sub_id)` 计算数量。

注意最后需要对 `post_id` 进行排序。

**代码**

```mysql [sol-MySQL]
SELECT post_id, COUNT(sub_id) AS number_of_comments
FROM (
    SELECT DISTINCT post.sub_id AS post_id, sub.sub_id AS sub_id
    FROM Submissions post
    LEFT JOIN Submissions sub
    ON post.sub_id = sub.parent_id
    WHERE post.parent_id is null
) T
GROUP BY post_id
ORDER BY post_id ASC
```