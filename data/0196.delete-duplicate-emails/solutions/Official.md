## [196.删除重复的电子邮箱 中文官方题解](https://leetcode.cn/problems/delete-duplicate-emails/solutions/100000/shan-chu-zhong-fu-de-dian-zi-you-xiang-b-8e7p)
[TOC]

## 解决方案

---

### Pandas

#### 方法 1：分组

要求是保留每个唯一电子邮件地址对应的最小 `id`。自然地，我们可以考虑使用 `groupby` 方法来实现这一点。`Person.groupby('email')` 将根据 `email` 列中的唯一值对 `Person` 进行分组。我们根据 `email` 列中的唯一值将 `Person` 分成多个组。这种分组允许我们将具有相同 `email` 的行分组在一起，以便我们可以分别对每个组进行操作。

我们想要找到每个组内的最小 `id` 值，以保留具有最小 `id` 的行。为了实现这一点，我们使用 `transform('min')` 方法为每个组生成一个新的Series，其中包含各自组内 `id` 列中的最小值。

```Python
min_id = person.groupby('email')['id'].transform('min')
```

这将给我们一个 Series，其长度与原始 DataFrame `Person` 相同，其中每个值代表其对应组内的最小 `id` 值。

```
0    1
1    2
2    1
Name: id, dtype: int64
```

<br>

接下来，我们可以选择 `id` 不是其对应组内最小 `id` 的行：

```Python
removed_person = person[person['id'] != min_id]
```

我们将得到以下 DataFrame `removed_person`：

| id   | email            |
| ---- | ---------------- |
| 3    | john@example.com |


<br>

注意，我们被要求在原地修改 `Person`。因此，我们可以使用带有 `inplace=True` 的 `drop` 方法，根据 `removed_person.index` 提供的索引值来删除所有行。完整的代码如下：

```Python
import pandas as pd

def delete_duplicate_emails(person: pd.DataFrame) -> None:
    min_id = person.groupby('email')['id'].transform('min')
    removed_person = person[person['id'] != min_id] 
    person.drop(removed_person.index, inplace=True)
    return
```

我们可以期望得到的 `person` 像这样。

| id   | email            |
| ---- | ---------------- |
| 1    | john@example.com |
| 2    | bob@example.com  |



<br>


---

### SQL


#### 方法 2：使用 `DELETE` 和 `WHERE` 子句

**实现**

通过将此表与自身在 *Email* 列上连接，我们可以得到以下代码。

```Sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email
;
```



然后，我们需要找到具有相同电子邮件地址的其他记录中较大的 `id`。因此，我们可以在 `WHERE` 子句中添加一个新条件，如下所示。

```Sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
;
```

因为我们已经得到了要删除的记录，所以我们可以将这个语句改为 `DELETE`。

**MySQL**

```Sql
DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
```