[TOC]

## 解决方案

- MySQL

- Pandas

---

### 概述

找出演员与导演合作至少 3 次的所有 `(actor_id，director_id)` 对。

---

### 方法 1：Group By 和 Count

#### MySQL

##### MySQL 思路

在 SQL 中，找到合作至少三次的演员导演对的查询是按照 `actor_id` 和 `director_id` 分组，然后过滤掉计数至少为 3 的对。

##### MySQL 算法

为了巩固算法背后的思想，让我们首先看一个例子：

一开始的 `ActorDirector` 表：

| actor_id | director_id | timestamp |
|----------|-------------|-----------|
| 1        | 1           | 0         |
| 1        | 1           | 1         |
| 1        | 1           | 2         |
| 1        | 2           | 3         |
| 1        | 2           | 4         |
| 2        | 1           | 5         |
| 2        | 1           | 6         |

下表由 `actor_id` 和 `director_id` 组合得到，过滤后只包含至少 3 个的分组。

| actor_id | director_id |
|----------|-------------|
| 1        | 1           |

注意，我们只选择了 `actor_id` 和 `director_id` 列。

##### MySQL 实现

```Sql
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(timestamp) >= 3;
```

#### Pandas

##### Pandas 思路

在 Pandas 中，我们可以对 `'actor_id'` 和 `'director_id'` 列使用 `.groupby` 函数，然后使用 `.size()` 函数统计每组的实例数量。然后，我们筛选出数量至少为 `3` 的组。

##### Pandas 算法

为了巩固算法背后的思想，让我们首先看一个例子：

一开始的 `actor_director` 表：

| actor_id | director_id | timestamp |
|----------|-------------|-----------|
| 1        | 1           | 0         |
| 1        | 1           | 1         |
| 1        | 1           | 2         |
| 1        | 2           | 3         |
| 1        | 2           | 4         |
| 2        | 1           | 5         |
| 2        | 1           | 6         |

下表由 `actor_id` 和 `director_id` 组合得到，过滤后只包含至少有 3 个的分组。

| actor_id | director_id |
|----------|-------------|
| 1        | 1           |

注意返回的 DataFrame 只包含 `actor_id` 和 `director_id` 列。

##### Pandas 实现

```Python3
import pandas as pd

def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    cnts = actor_director.groupby(['actor_id', 'director_id']).size().reset_index(name='counts')
    return cnts[cnts['counts'] >= 3][['actor_id', 'director_id']]
```