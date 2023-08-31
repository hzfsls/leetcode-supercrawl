## [570.至少有5名直接下属的经理 中文官方题解](https://leetcode.cn/problems/managers-with-at-least-5-direct-reports/solutions/100000/zhi-shao-you-5ming-zhi-jie-xia-shu-de-ji-syvu)

[TOC]

## 解决方案

---

#### 方法 1：分组和连接

**Pandas**

我们需要找到拥有超过 5 名直接下属的经理，这涉及到计算每个经理ID的下属人数。可以通过将员工表按照每个唯一的经理ID进行分组来实现。因此，我们将 DataFrame `Employee` 按列 `managerId` 进行分组，并应用 `size()` 方法来计算 `managerId` 中每个唯一值的出现次数，这表示每个经理手下的员工数量。

`reset_index(name='count')` 用于给结果列指定一个新名称 `count`，这一步确保结果 DataFrame `df` 有两列：`managerId` 和 `count`。


```Python
df = employee.groupby('managerId').size().reset_index(name='count')
```

我们将得到以下 DataFrame `df`：

| managerId | count |
| --------- | ----- |
| 101       | 5     |


<br>

接下来，我们筛选出 `count` 等于或多于 5 的行，这些行代表拥有 5 名或更多直接下属的经理。

```Python
df = df[df['count'] >= 5]
```

| managerId | count |
| --------- | ----- |
| 101       | 5     |


<br>

然后，我们可以通过将 `df` 与 `employee` 在共同的列（`df` 中的 `managerId` 和 `employee` 中的 `id`）上进行连接来获得这些经理的名字。请注意，我们将连接方法设置为 `how='inner'`，这将选择在两个 DataFrame 中都具有匹配值的经理。因此，我们不会选择一个不是有效经理的员工，也不会选择一个不在 `employee` 中的经理。


完整的代码如下：

```Python
import pandas as pd

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    df = employee.groupby('managerId').size().reset_index(name='count')
    df = df[df['count'] >= 5]
    managers_info = pd.merge(df, employee, left_on='managerId', right_on='id', how='inner')
    return managers_info[['name']]
```


我们将得到以下表格作为答案：

| name |
| ---- |
| John |




<br>


**MySQL**

子查询从 `employee` 表中选择经理的 ID，并根据他们拥有的下属数量进行分组。`HAVING` 子句用于筛选拥有 5 个或更多下属的 `managerId`。

```Sql
SELECT 
    ManagerId
FROM 
    Employee
GROUP BY ManagerId
HAVING COUNT(ManagerId) >= 5
```

接下来，我们在子查询得到的表和 `employee` 表之间执行内连接 `JOIN`，以获得所有拥有至少 5 名下属的经理的名字。

```Sql
SELECT
    Name
FROM
    Employee AS t1 
JOIN
    (SELECT 
        ManagerId
    FROM 
        Employee
    GROUP BY ManagerId
    HAVING COUNT(ManagerId) >= 5) AS t2
ON 
    t1.Id = t2.ManagerId
;
```


---

#### 方法 2：使用 `IN` 子查询

**MySQL**

我们还可以使用 `IN` 子句与子查询相结合。

类似于前面的方法，子查询从 `employee` 表中选择经理的 ID，并根据他们拥有的下属数量进行分组。然后，使用 `HAVING` 子句来筛选拥有 5 个或更多下属的 `managerId`。

```Sql
SELECT 
    ManagerId
FROM 
    Employee
GROUP BY ManagerId
HAVING COUNT(ManagerId) >= 5
```

接下来，我们从 `employee` 表中选择名字，其中 `ManagerId` 存在于通过 `IN` 关键字从子查询得到的表中。通过这种方式，我们可以检索到拥有至少 5 名下属的经理的名字。

```Sql
SELECT
    name
FROM
    employee
WHERE
    id IN (
        SELECT
            managerId
        FROM
            employee
        GROUP BY
            managerId
        HAVING COUNT(*) >= 5
    );
```