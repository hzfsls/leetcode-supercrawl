## [511.游戏玩法分析 I 中文官方题解](https://leetcode.cn/problems/game-play-analysis-i/solutions/100000/you-xi-wan-fa-fen-xi-i-by-leetcode-solut-ngvq)

[TOC]

## 解决方案

---

### 概述

> **问题参考：** 报告每个玩家的第一个登录日期。以任意顺序返回结果表。

这个问题的难点在于如何访问和报告每个玩家的极值（即第一个登录日期）。我们如何将所有行按玩家分组，并报告每个玩家的“最小”日期（即最早发生的日期）？

下面的方法 1 重点介绍了可能是最普遍的解决方案，即使用 `GROUP BY` 结合 `MIN()`。方法 2 突出了更高级的替代解决方案，它使用了窗口函数。

---

### 方法 1：分组并提取最小值

#### 思路

1. 通过 `GROUP BY player_id` 将行分组为每个玩家的子组。
2. 通过 `MIN()` 找到每个子组内的 *最早* `event_date`。
3. 返回结果集，不需要特定的顺序（这里不需要 `ORDER BY`）。

#### 实现

**Pandas**

我们可以使用 `groupby()` 函数来按 `activity` 中的 `player_id` 列分组数据，这使得我们可以根据唯一的玩家ID对数据进行分析。一旦按 `player_id` 分组数据，我们选择 `event_date` 列并对该列应用 `min()` 函数，从而找到每个 `player_id` 组内的最小（最早）日期。这将给我们每个玩家的第一个登录日期。

```Python
df = activity.groupby('player_id')['event_date'].min().reset_index()
```

我们将得到以下DataFrame `df`，其中每个 `event_date` 是对应玩家的第一个登录日期：

| player_id | event_date |
| --------- | ---------- |
| 1         | 2016-03-01 |
| 2         | 2017-06-25 |
| 3         | 2016-03-02 |



<br>

注意，最终输出是一个包含两列的 DataFrame：`player_id` 和 `first_login`。因此，我们需要将列名 `event_date` 改为 `first_login`。完整的代码如下：

```Python
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    df = activity.groupby('player_id')['event_date'].min().reset_index()

    return df.rename(columns = {'event_date':'first_login'})
```

我们将得到以下 DataFrame：

| player_id | first_login |
| --------- | ----------- |
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |


<br>



**MySQL**

如果您第一次使用带有类似 `MIN()` 的 `GROUP BY`，那么考虑一下从以下查询中可以获取什么样的聚合信息：

```Sql
SELECT
  A.player_id
FROM
  Activity A
GROUP BY
  A.player_id;
```

这个查询的结果可能一开始并不令人兴奋：

```
+-----------+
| player_id |
+-----------+
|         1 |
|         2 |
|         3 |
+-----------+
```

但是，使用问题描述中的示例，一旦将行按 `player_id` 分组，实际上我们对于每个组（即每个 `player_id`）有以下信息：

- `1`:
  + `device_id`: `2`, `2`
  + `event_date`: `2016-03-01`, `2016-05-02`
  + `games_played`: `5`, `6`
- `2`:
  + `device_id`: `3`
  + `event_date`: `2017-06-25`
  + `games_played`: `1`
- `3`:
  + `device_id`: `1`, `4`
  + `event_date`: `2016-03-02`, `2018-07-03`
  + `games_played`: `0`, `5`

上面的拆分使得很清楚我们总共有三个组（每个不同的 `player_id` 对应一个组）。对于 `player_id` 值为 `1`、`2` 和 `3` 的玩家，我们分别有 2、1 和 2 个子组。我们使用的聚合函数将应用于每个组的子组值。由于我们对每个玩家的第一个登录日期感兴趣，所以我们将使用 `MIN()` 聚合函数来扫描每个组的 `event_date` 子组值，以找到最小的日期。每个组的最小值将作为报告的 `first_login` 值：

```Sql
SELECT
  A.player_id,
  MIN(A.event_date) AS first_login
FROM
  Activity A
GROUP BY
  A.player_id;
```

---

### 方法 2：窗口函数

#### 思路

以下解决方案使用窗口函数，应该被视为一个简单问题的中级解决方案。应该指出，仅仅因为您 *可以* 使用窗口函数，并不意味着您 *应该* 使用窗口函数。

#### 实现

##### MySQL

可以在内联视图中使用 `RANK()`、`DENSE_RANK()` 或 `ROW_NUMBER()` 与之结合使用。选择不会影响结果，因为 `(player_id, event_date)` 是 `Activity` 表的主键（即我们不必担心有多个行具有 `rnk` 值为 `1` 的可能性，因为分区是由 `player_id` 创建的，行是按 `event_date` 排序的，从而保证了唯一的 `rnk` 值）：

```Sql
SELECT
  X.player_id,
  X.event_date AS first_login
FROM
  (
    SELECT
      A.player_id,
      A.event_date,
      RANK() OVER (
        PARTITION BY
          A.player_id
        ORDER BY
          A.event_date
      ) AS rnk
    FROM
      Activity A
  ) X
WHERE
  X.rnk = 1;
```

##### MySQL

合适地说，可以使用 `FIRST_VALUE()`

 窗口函数来构建此问题的解决方案：

```Sql
SELECT DISTINCT
  A.player_id,
  FIRST_VALUE(A.event_date) OVER (
    PARTITION BY
      A.player_id
    ORDER BY
      A.event_date
  ) AS first_login
FROM
  Activity A;
```

**注意：** 使用 `DISTINCT` 是必要的，因为窗口函数的工作方式。如果我们不使用 `DISTINCT`，那么根据问题描述中的示例，我们将得到以下（不正确）的结果集：

```
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
|         1 | 2016-03-01  |
|         1 | 2016-03-01  |
|         2 | 2017-06-25  |
|         3 | 2016-03-02  |
|         3 | 2016-03-02  |
+-----------+-------------+
```

##### MySQL

对于那些好奇的人，还可以使用 `LAST_VALUE()` 窗口函数来构建此问题的解决方案，但必须注意有效地定义 [窗口函数框架规范](https://dev.mysql.com/doc/refman/8.0/en/window-functions-frames.html)。如果我们没有提供框架规范，那么根据问题描述中的示例，我们将得到以下（不正确）的结果集：

```
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
|         1 | 2016-05-02  |
|         1 | 2016-03-01  |
|         2 | 2017-06-25  |
|         3 | 2018-07-03  |
|         3 | 2016-03-02  |
+-----------+-------------+
```

正如 [MySQL文档](https://dev.mysql.com/doc/refman/8.0/en/window-functions-frames.html) 中所述，使用窗口函数内的 `ORDER BY` 将得到以下默认框架规范：

```Sql
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

如果未指定 `ORDER BY`，则默认框架规范如下：

```Sql
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

因此，当使用 `LAST_VALUE()` 时，适当的框架规范将如下所示：

```Sql
SELECT DISTINCT
  A.player_id,
  LAST_VALUE(A.event_date) OVER (
    PARTITION BY
      A.player_id
    ORDER BY
      A.event_date DESC RANGE BETWEEN UNBOUNDED PRECEDING
      AND UNBOUNDED FOLLOWING
  ) AS first_login
FROM
  Activity A;
```

---

### 结论

我们推荐使用方法 1 ，因为它很简单。

方法 2 非常有用，因为它突出了许多替代解决方案，这些解决方案在面试中值得注意。如果您在面试中遇到了这个问题，那么方法1应该足够了。但是，使用方法 2 中的任何解决方案仍然会给面试官留下良好的印象，因为它暗示您可以用多种方式找到问题的解决方案，无论这种方式有多复杂。