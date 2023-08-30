[TOC]

## 解决方案

#### 方法 1：DENSE_RANK

**简述**

理想情况下，我们可以根据 `score` 值对行进行分组，为每个组的成员/行分配相同的排名，然后按排名降序返回所有行。但是传统的聚合函数使用依赖于将查询行分组到*单个*结果行中，这不是我们在这个问题中想要做的。我们需要以*所有*行的排名方式返回结果，而不仅仅是按降序排列的不同或分组的 `score` 值。

例如，对于示例输入，传统的聚合函数会给我们以下结果集：

| score | rank |
| ----- | ---- |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.50  | 4    |



但我们需要*所有*行：

| score | rank |
| ----- | ---- |
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |


**Pandas**

Pandas 提供了函数 `rank()` 来帮助计算沿轴的数值数据排名，我们可以将方法参数 `method` 设置为 `dense` 来分配密集排名。密集排名意味着当存在并列的值时，下一个排名不会跳过。相反，所有并列的分数都被分配相同的排名，并且下一个排名递增一。这确保排名没有间隙，并且每个分数获得唯一的排名，这也正是问题所需的。

因此，我们对 `score` 列应用密集排名，

```Python
# 按照降序对 'score' 列进行密集排名。
scores['rank'] = scores['score'].rank(method='dense', ascending=False)
```

我们将得到以下 DataFrame：

| id   | score | rank |
| ---- | ----- | ---- |
| 1    | 3.50  | 4    |
| 2    | 3.65  | 3    |
| 3    | 4.00  | 1    |
| 4    | 3.85  | 2    |
| 5    | 4.00  | 1    |
| 6    | 3.65  | 3    |

接下来，我们需要返回所需的列，按 `score` 升序排列，完整的代码如下：

```Python
import pandas as pd

def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    scores['rank'] = scores['score'].rank(method='dense', ascending=False)
    return scores[['score', 'rank']].sort_values('score', ascending=False)
```

得到的 DataFrame 将如下所示：

| score | rank |
| ----- | ---- |
| 4     | 1    |
| 4     | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.5   | 4    |




<br>




**MySQL**

对于 SQL 用户，熟悉 [窗口函数](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html) 在这里是有用的（对于大多数更高级的 SQL 问题也是如此）：

> 窗口函数对一组查询行执行类似于聚合的操作。但是，聚合操作将查询行分组为一个单独的结果行，而窗口函数为每个查询行生成一个结果。


[`DENSE_RANK()`](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_dense-rank) 窗口函数恰好是我们在这个问题中需要的：

> 返回当前行在其分区中的排名，没有间隙。对等项被视为并列并获得相同的排名。此函数为对等组分配连续的排名；结果是大于一的组不产生不连续的排名号码。

看起来我们可以在这个问题中很好地使用 `DENSE_RANK()` 窗口函数。



**MySQL**

```Sql
SELECT
  S.score,
  DENSE_RANK() OVER (
    ORDER BY
      S.score DESC
  ) AS 'rank'
FROM
  Scores S;
```

**注意：** MySQL 在 8.0 版本（2018 年 4 月 19 日）之前不支持窗口函数。一般来说，窗口函数直到 SQL:2003 才被引入 SQL，正如 MariaDB 的 [窗口函数概述](https://mariadb.com/kb/en/window-functions-overview/#scope) 文章中所述。

---

#### 方法 2: 使用 `COUNT(DISTINCT ...)` 的相关子查询

**简述**

如果我们能够计算每个分数 `S1.score` 的*不同*分数 `S2.score` 的数量，而这些分数大于或等于此分数，那么这将有效地给我们提供 `S1.score` 的排名。然后我们可以按照 `S1.score` 对结果集进行排序，以符合问题的排名规则。

**实现**

可以使用 [相关子查询](https://dev.mysql.com/doc/refman/8.0/en/correlated-subqueries.html) 来完成上述的计数。

1. 对于来自 `Scores` 表的每个分数，选择在 `Scores` 表中大于或等于此分数的不同分数的数量。
2. 按照 `score` 对结果集进行排序。


**MySQL**

```Sql
SELECT
  S1.score,
  (
    SELECT
      COUNT(DISTINCT S2.score)
    FROM
      Scores S2
    WHERE
      S2.score >= S1.score
  ) AS 'rank'
FROM
  Scores S1
ORDER BY
  S1.score DESC;
```


---


#### 方法 3：使用 `INNER JOIN` 和 `COUNT(DISTINCT...)` 

**简述**

这个方法的基本思想与 方法 2 的相同，但实现方式完全不同。

**实现**

1. 将 `Scores` 表与自身连接，以便我们得到所有分数大于或等于此分数的所有行。
2. 将查询行按 `id` 和 `score` 值进行分组。
3. 计算唯一的分数的数量，它应该大于或等于连接条件中使用的分数（也就是排名）。
4. 按 `score` 值对结果集进行排序。

**MySQL**

```Sql
SELECT
  S.score,
  COUNT(DISTINCT T.score) AS 'rank'
FROM
  Scores S
  INNER JOIN Scores T ON S.score <= T.score
GROUP BY
  S.id,
  S.score
ORDER BY
  S.score DESC;
```

上述解决方案是有效的，因为项目是如何*分组*的--`COUNT()` 聚合函数在分组上工作，从而为我们提供所需的结果。为了更清楚地看到上述查询的工作原理，我们可以检查以下查询的输出结果：

```Sql
SELECT
  S.id AS S_ID,
  S.score AS S_Score,
  T.id AS T_ID,
  T.score AS T_Score
FROM
  Scores S
  INNER JOIN Scores T ON S.score <= T.score
ORDER BY
  S.id,
  T.score;
```

如果我们将这个查询应用于问题描述中给定的示例数据，那么我们将得到以下结果集：

```
+------+---------+------+---------+
| S_ID | S_score | T_ID | T_score |
+------+---------+------+---------+
|    1 |    3.50 |    1 |    3.50 |
|    1 |    3.50 |    2 |    3.65 |
|    1 |    3.50 |    6 |    3.65 |
|    1 |    3.50 |    4 |    3.85 |
|    1 |    3.50 |    3 |    4.00 |
|    1 |    3.50 |    5 |    4.00 |
|    2 |    3.65 |    2 |    3.65 |
|    2 |    3.65 |    6 |    3.65 |
|    2 |    3.65 |    4 |    3.85 |
|    2 |    3.65 |    3 |    4.00 |
|    2 |    3.65 |    5 |    4.00 |
|    3 |    4.00 |    3 |    4.00 |
|    3 |    4.00 |    5 |    4.00 |
|    4 |    3.85 |    4 |    3.85 |
|    4 |    3.85 |    3 |    4.00 |
|    4 |    3.85 |    5 |    4.00 |
|    5 |    4.00 |    3 |    4.00 |
|    5 |    4.00 |    5 |    4.00 |
|    6 |    3.65 |    2 |    3.65 |
|    6 |    3.65 |    6 |    3.65 |
|    6 |    3.65 |    4 |    3.85 |
|    6 |    3.65 |    3 |    4.00 |
|    6 |    3.65 |    5 |    4.00 |
+------+---------+------+---------+
```

请注意，当我们在合适的分组上使用 `COUNT(DISTINCT ...)` 时，这为我们提供了所需的结果集：

```
+-------+---------+
| score | rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 2       |
| 3.65  | 3       |
| 3.65  | 3       |
| 3.50  | 4       |
+-------+---------+
```

- `S_ID = 1`；`S_score = 3.50`：有 `4` 个不同的 `T_score` 值（`3.50`、`3.65`、`3.85` 和 `4.00`）。
- `S_ID = 2`；`S_score = 3.65`：有 `3` 个不同的 `T_score` 值（`3.65`、`3.85` 和 `4.00`）。
- ...


---


#### 结论

出于各种原因，我们更喜欢 方法 1，特别是它的简单性、性能和上下文适用性。很少有问题会要求如此恰当地直接应用 `DENSE_RANK()`。但是，如 方法 1 结尾所述，窗口函数在 SQL 领域的到来相对较新，特别是对于它们在现代开发环境中的使用方式。

在面试环境中，方法 1 是最优的。但如果面试官要求不使用现代 SQL 工具（如窗口函数）来解决问题，使用 方法 2 或 方法 3 也是适当的策略。在这种情况下，方法 2 可能传达对 SQL 查询处理方式的更深入理解，而 方法 3 可能传达解决问题的创造性。无论哪种情况，都传达了一种积极和值得欢迎的特质。