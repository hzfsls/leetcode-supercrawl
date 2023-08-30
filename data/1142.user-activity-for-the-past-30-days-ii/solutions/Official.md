#### 预备知识

本题使用到的 `mysql` 函数的说明：
- `ROUND(x, d)`： 四舍五入保留 `x` 的 `d` 位小数。
- `IFNULL(x1, x2)` ：如果 `x1` 为 `NULL`， 返回 `x2`。

#### 方法一：`COUNT` 和 `DATEDIFF`

**思路**

本题的重点就是要理解**每个用户的平均会话数**。用户即为 `user_id`，无论什么时候永远不会变。会话是对应的 `session_id`，用户的 `session_id` 会在特定的情况下改变，比如 `end_session` 后再 `open_session`。所以我们只需要统计总的会话数和总的用户数，相除就是平均数，即：
```mysql
COUNT(session_id) / COUNT(user_id)
```

这个数字还需要加工处理：
1. 由于表里面可能有重复的数据，所以需要使用 `DISTINCT` 去重。
2. 使用 `ROUND()` 保留两位有效数字。
3. 使用 `IFNULL` 处理返回结果为 `null` 的情况。
4. 只需要查找截至 2019-07-27 日（含）的 30 天内的数据，有两种办法（注意是**截至**不是**截止**）：
    1. 计算出第一天，使用 `BETWEEN` ：`WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'`。
    2. 使用 `datediff()` 函数，计算当天与最后一天的差值：`WHERE datediff('2019-07-27',activity_date) < 30`。

**代码**

```Mysql [ ]
SELECT IFNULL(ROUND(COUNT(DISTINCT session_id) / COUNT(DISTINCT user_id), 2), 0) AS average_sessions_per_user
FROM Activity
WHERE DATEDIFF('2019-07-27', activity_date) < 30
-- WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
```