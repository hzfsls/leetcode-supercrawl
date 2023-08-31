## [1378.使用唯一标识码替换员工ID 中文官方题解](https://leetcode.cn/problems/replace-employee-id-with-the-unique-identifier/solutions/100000/shi-yong-wei-yi-biao-shi-ma-ti-huan-yuan-0inw)
[TOC]

## 解决方案

---

### 概述

- Pandas

- SQL

---

### 方法：根据ID进行左连接

#### Pandas

我们可以根据共同的列 `id` 将 `employees` 和 `employee_uni` 进行合并，使员工姓名与其唯一 id 组合并获取来自两个 DataFrame 的相关数据。这可以使用 Pandas 中的 `merge()` 函数来实现。在此之前，请注意，我们需要在 `merge` 中设置一些参数：

- `employees` 和 `employee_uni`：这是我们要合并的两个DataFrame。
- `on='id'`，这指定了将执行合并操作的列。两个 DataFrame 都包含列`id`。
- `how='left'`：这定义了要执行的合并类型。左连接意味着所有来自 `employees`  DataFrame 的行将包含在结果中，并且任何与 `employee_uni` DataFrame中匹配的行也将包含在结果中。因此，没有唯一 id 的员工也将保留，但它们在 `employee_uni` 中对应的列将被填充为 `NaN` （非数字）值。

```Python3
employee_name_uni = pd.merge(employees, employee_uni, on='id', how='left')
```

这样创建了 `employee_name_uni` DataFrame，其中保留了来自 `employees` 的所有行，并且为匹配的 `id` 值包含了来自 `employee_uni` 的额外信息。对于在 `employee_uni` 中没有匹配 `id` 的行，相应的列将填充为 `NaN` 。

| id   | name     | unique_id |
| ---- | -------- | --------- |
| 1    | Alice    | NaN       |
| 7    | Bob      | NaN       |
| 11   | Meir     | 2.0       |
| 90   | Winston  | 3.0       |
| 3    | Jonathan | 1.0       |

<br>

来自两个 DataFrame 的合并信息包含每个员工的 `name` 和 `unique_id` （如果有）。接下来，我们将创建一个只包含所需列 `unique_id` 和 `name` 的新 DataFrame，这可以通过使用双重方括号从 `employee_name_uni` DataFrame中选择列 `unique_id` 和 `name` 来实现。

```Python
answer = employee_name_uni[['unique_id', 'name']]
```

我们将获得以下DataFrame `answer`：

| unique_id | name     |
| --------- | -------- |
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |

<br>

以下是完整的代码：

```Python
import pandas as pd

def replace_employee_id(employees: pd.DataFrame, employee_uni: pd.DataFrame) -> pd.DataFrame:
    employee_name_uni = pd.merge(employees, employee_uni, on='id', how='left')
    answer = employee_name_uni[['unique_id', 'name']]

    return answer
```


<br>



#### MySQL


我们首先执行LEFT JOIN操作，将两个表的数据基于 `id` 列进行组合。同样，我们使用 LEFT JOIN 来确保将所有 `Employees` 表中的行都包含在结果中，即使在 `EmployeeUNI` 表中没有匹配的行。

```Sql
SELECT 
    * 
FROM
    Employees 
LEFT JOIN 
    EmployeeUNI 
ON 
    Employees.id = EmployeeUNI.id;
```


| id   | name     | id   | unique_id |
| ---- | -------- | ---- | --------- |
| 1    | Alice    | null | null      |
| 7    | Bob      | null | null      |
| 11   | Meir     | 11   | 2         |
| 90   | Winston  | 90   | 3         |
| 3    | Jonathan | 3    | 1         |


由于我们想要从组合表中检索列 `unique_id` 和 `name` ，所以我们将从 `EmployeeUNI` 表选择 `unique_id` 列，从 `Employees` 表选择 `name` 列。完整代码如下：

```Sql
SELECT 
    EmployeeUNI.unique_id, Employees.name
FROM 
    Employees
LEFT JOIN 
    EmployeeUNI 
ON 
    Employees.id = EmployeeUNI.id;
```