## [1280.学生们参加各科测试的次数 中文官方题解](https://leetcode.cn/problems/students-and-examinations/solutions/100000/students-and-examinations-by-leetcode-so-3oup)
[TOC]

## 解决方案

---

### 方法：Group by 与 Cross join

#### Pandas

此问题涉及多个 DataFrame，因此让我们将其分解为子问题，以使其更直观、更易于理解。

首先，这道题要求我们找出每个学生参加每门课的考试次数。我们可以通过对每个 `(student_id,subject_name)` 对使用 `groupby` 方法，然后计算每个组的出现次数来实现这一点。请注意，我们在 `groupby` 中添加了两列。根据要求，我们将该列的统计命名为 `attended_exam`。

```Python
grouped = examinations.groupby(['student_id', 'subject_name']).size().reset_index(name='attended_exams')
```

生成的 DataFrame `grouped` 看起来像这样：

|   student_id  | subject_name | attended_exams |
|:------------:|:------------:|:-------------:|
|      1       |    Math      |       3       |
|      1       |   Physics    |       2       |
|      1       | Programming  |       1       |
|      2       |    Math      |       1       |
|      2       | Programming  |       1       |
|     13       |    Math      |       1       |
|     13       |   Physics    |       1       |
|     13       | Programming  |       1       |

然而，这个 DataFrame 和预期的输出不同：

- 它缺少 `student_name` 列。
- 它只统计出现**至少一次**的 `(student_id，subject_name)` 的组合，但我们需要所有可能的组合。

让我们把这个 DataFrame 放在一边，考虑一下如何获得所有的组合：`student` DataFrame 包含所有的 ID，而 `subjects` DataFrame 包含所有的主题名称。因此，要获得 `(student_id，subject_name)` 的所有组合，需要进行交叉联接。

```Python
all_id_subjects = pd.merge(students, subjects, how='cross')
```

生成的 DataFrame `all_id_subjects` 现在包括所有可能的组合，但它不包含有关考试次数的信息。

| student_id | student_name | subject_name |
|:----------:|:------------:|:------------:|
|      1     |    Alice     |     Math     |
|      1     |    Alice     |   Physics    |
|      1     |    Alice     | Programming |
|      2     |     Bob      |     Math     |
|      2     |     Bob      |   Physics    |
|      2     |     Bob      | Programming |
|     13     |     John     |     Math     |
|     13     |     John     |   Physics    |
|     13     |     John     | Programming |
|      6     |     Alex     |     Math     |
|      6     |     Alex     |   Physics    |
|      6     |     Alex     | Programming |

当然，我们可以将 DataFrame `all_id_subjects` 与我们从第一步获得的 `grouped` 组合在一起，后者包含每个学生参加每门课程的考试次数。为此，我们可以在两个 DataFrame 上执行左连接，这将确保保留交叉连接中的 `student_id` 和 `subject_name` 的所有组合。
如果 DataFrame `grouped` 中不存在组合(即，没有计算该特定组合的考试)，则 `attended_exam` 列在那一行将保存值 `NA` ，表示没有参加任何考试。

```Python
id_subjects_count = pd.merge(all_id_subjects, grouped, on=['student_id', 'subject_name'], how='left')
```

我们将获得如下的 DataFrame `id_subjects_count`：

| student_id | student_name | subject_name | attended_exams |
|:----------:|:------------:|:------------:|:--------------:|
|      1     |    Alice     |     Math     |      3.0       |
|      1     |    Alice     |   Physics    |      2.0       |
|      1     |    Alice     | Programming |      1.0       |
|      2     |     Bob      |     Math     |      1.0       |
|      2     |     Bob      |   Physics    |      NaN       |
|      2     |     Bob      | Programming |      1.0       |
|     13     |     John     |     Math     |      1.0       |
|     13     |     John     |   Physics    |      1.0       |
|     13     |     John     | Programming |      1.0       |
|      6     |     Alex     |     Math     |      NaN       |
|      6     |     Alex     |   Physics    |      NaN       |
|      6     |     Alex     | Programming |      NaN       |

请注意，`attended_exams` 列的数据类型从整型变为浮点型，这通常是由于 Pandas `NaN` (不是数字)的性质造成的。`NaN` 是一种特殊的浮点类型，在 Pandas 中，如果整型列包含 `NaN` 值，则整列的数据类型将被推断为 float。这是因为 DataFrame 中的整型列不能包含 `NaN` 值，因此整列被转换为 float 数据类型以容纳 `NaN`。为了解决这个问题，我们可以首先将该列中的 `NaN` 值填充为 0 ，然后通过以下方式将整列的数据类型转换为整数：

```
id_subjects_count['attended_exams'] = id_subjects_count['attended_exams'].fillna(0).astype(int)
```

| student_id | student_name | subject_name | attended_exams |
|------------|--------------|--------------|----------------|
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |

最后，我们需要对`id_subjects_count`按照`studend_id`和`subject_name`列进行升序排序，完整代码如下：

```Python
import pandas as pd

def students_and_examinations(students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame) -> pd.DataFrame:
    # 按 id 和科目分组，并计算考试次数。
    grouped = examinations.groupby(['student_id', 'subject_name']).size().reset_index(name='attended_exams')

    # 获取 (id, subject) 的所有组合
    all_id_subjects = pd.merge(students, subjects, how='cross')

    # 左连接以保留所有组合。
    id_subjects_count = pd.merge(all_id_subjects, grouped, on=['student_id', 'subject_name'], how='left')
    
    # 数据清理
    id_subjects_count['attended_exams'] = id_subjects_count['attended_exams'].fillna(0).astype(int)
    
    # 根据'student_id'，'Subject_name'以升序对 DataFrame 进行排序。
    id_subjects_count.sort_values(['student_id', 'subject_name'], inplace=True)

    return id_subjects_count[['student_id', 'student_name', 'subject_name', 'attended_exams']]
```

#### MySQL

我们通过一个子查询创建了表 `grouped`，它统计每个学生参加每个科目的考试次数。

```sql
SELECT 
    student_id, subject_name, COUNT(*) AS attended_exams
FROM 
    Examinations
GROUP BY 
    student_id, subject_name
```

| student_id | subject_name | attended_exams |
|------------|--------------|----------------|
| 1          | Math         | 3              |
| 1          | Physics      | 2              |
| 1          | Programming  | 1              |
| 2          | Programming  | 1              |
| 13         | Math         | 1              |
| 13         | Programming  | 1              |
| 13         | Physics      | 1              |
| 2          | Math         | 1              |

为了获得 `(student_id，subject_name)` 的所有组合，我们使用交叉联接将表 `Student` 中的每一行与表 `Subject` 中的每一行组合在一起，从而得到两个表中的 `student_id` 和 `subject_name` 的所有可能组合。

```sql
SELECT 
    *
FROM
    Students s
CROSS JOIN
    Subjects sub
```

| student_id | student_name | subject_name |
|------------|--------------|--------------|
| 1          | Alice        | Programming  |
| 1          | Alice        | Physics      |
| 1          | Alice        | Math         |
| 2          | Bob          | Programming  |
| 2          | Bob          | Physics      |
| 2          | Bob          | Math         |
| 13         | John         | Programming  |
| 13         | John         | Physics      |
| 13         | John         | Math         |
| 6          | Alex         | Programming  |
| 6          | Alex         | Physics      |
| 6          | Alex         | Math         |

接下来，我们对上面的表与表 `grouped` 执行左连接，使用 `(student_id，subject_name)` 对作为标识符来保留所有组合，同时合并两个表。类似地，在左连接之后， `grouped.attended_exams` 列可能有 `null` 值，我们使用 `IFNULL()` 函数将其替换为0。

下面是完整代码：

```sql
SELECT 
    s.student_id, s.student_name, sub.subject_name, IFNULL(grouped.attended_exams, 0) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN (
    SELECT student_id, subject_name, COUNT(*) AS attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
) grouped 
ON s.student_id = grouped.student_id AND sub.subject_name = grouped.subject_name
ORDER BY s.student_id, sub.subject_name;
```