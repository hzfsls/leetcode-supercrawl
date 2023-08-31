## [596.超过5名学生的课 中文官方题解](https://leetcode.cn/problems/classes-more-than-5-students/solutions/100000/chao-guo-5ming-xue-sheng-de-ke-by-leetco-l4es)

[TOC]

## 解决方案

---

#### 方法 1：分组

**Pandas**

我们需要统计每个唯一班级的人数，所以我们可以使用函数 `groupby('class')` 将 DataFrame `courses` 按 `class` 列进行分组。然后，我们使用函数 `size()` 来计算每个唯一班级的出现次数，这给我们了每个班级的学生数。我们使用 `reset_index(name='count')` 将该列命名为 `count`。

结果 DataFrame `df` 包含两列：`class` 和 `count`。


```Python
df = courses.groupby('class').size().reset_index(name='count')
```

我们将得到以下 DataFrame `df`：

| class    | count |
| -------- | ----- |
| Biology  | 1     |
| Computer | 1     |
| English  | 1     |
| Math     | 6     |

<br>

接下来，我们在 `df` 中过滤，只选择 `count` 列大于或等于 5 的行，这有助于我们识别有超过 5 名学生的班级。 

```Python
df = df[df['count'] >= 5]
```

| class | count |
| ----- | ----- |
| Math  | 6     |


<br>

我们需要返回所需的列 `class`，因此完整的代码如下：


```Python
import pandas as pd

def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    df = courses.groupby('class').size().reset_index(name='count')

    df = df[df['count'] >= 5]

    return df[['class']]
```

我们将得到以下 DataFrame：

| class |
| ----- |
| Math  |




<br>

**MySQL**

首先，我们可以统计每个班级的学生数量。然后选择学生数大于 5 的班级。

要获得每个班级的学生数，我们可以使用 `GROUP BY` 和 `COUNT`，这在根据表中的某些字符进行统计时非常常用。

```Sql
SELECT
    class, COUNT(student)
FROM
    courses
GROUP BY class
;
```

| class    | COUNT(student) |
| -------- | -------------- |
| Biology  | 1              |
| Computer | 1              |
| English  | 1              |
| Math     | 6              |


<br>

为了继续，我们可以通过将上面的查询作为子查询来过滤班级。

```Sql
SELECT
    class
FROM
    (SELECT
        class, COUNT(student) AS num
    FROM
        courses
    GROUP BY class) AS temp_table
WHERE
    num >= 5
;
```

>注意：给 `COUNT(student)` 添加一个别名 (在这里是'num') ，这样您可以在 `WHERE` 子句中使用它，因为它不能直接在那里使用。

<br>

#### 方法2：使用 `GROUP BY` 和 `HAVING` 条件

**思路**

使用子查询是在 `GROUP BY` 子句中添加一些条件的一种方法，然而，使用 [`HAVING`](https://dev.mysql.com/doc/refman/5.7/en/group-by-handling.html) 是另一种更简单和自然的方法。所以我们可以将上面的解决方案改写如下。

**MySQL**

```Sql
SELECT
    class
FROM
    courses
GROUP BY class
HAVING COUNT(student) >= 5
;
```