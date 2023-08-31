## [184.部门工资最高的员工 中文官方题解](https://leetcode.cn/problems/department-highest-salary/solutions/100000/bu-men-gong-zi-zui-gao-de-yuan-gong-by-l-jo1i)
[TOC]

## 解决方案

---

#### 方法：左连接（Left Join）

**Pandas**

首先，我们通过合并两个表来获取所有的部门名称、员工名称和薪水。

```Python
df = employee.merge(department, left_on='departmentId', right_on='id', how='left')
```

| id_x | name_x | salary | departmentId | id_y | name_y |
| ---- | ------ | ------ | ------------ | ---- | ------ |
| 1    | Joe    | 70000  | 1            | 1    | IT     |
| 2    | Jim    | 90000  | 1            | 1    | IT     |
| 3    | Henry  | 80000  | 2            | 2    | Sales  |
| 4    | Sam    | 60000  | 2            | 2    | Sales  |
| 5    | Max    | 90000  | 1            | 1    | IT     |

> 注意，在合并后，原始表中具有相同名称的列（例如 `name`）会被重命名（作为 `name_x` 和 `name_y`），因此我们需要进行列重命名。

```Python
df.rename(columns={'name_x': 'Employee', 'name_y': 'Department', 'salary': 'Salary'}, inplace=True)
```

得到的 `df` 将如下所示。

| id_x | Employee | Salary | departmentId | id_y | Department |
| ---- | -------- | ------ | ------------ | ---- | ---------- |
| 1    | Joe      | 70000  | 1            | 1    | IT         |
| 2    | Jim      | 90000  | 1            | 1    | IT         |
| 3    | Henry    | 80000  | 2            | 2    | Sales      |
| 4    | Sam      | 60000  | 2            | 2    | Sales      |
| 5    | Max      | 90000  | 1            | 1    | IT         |

接下来，我们根据 `Department` 列对 `df` 进行分组，并对 `Salary` 列应用 `transform('max')` 函数，这将为每个部门计算最高薪水，并返回一个与原 DataFrame 长度相同的 Series，其中每个值都是对应部门的最高薪水（它不一定是对应员工的薪水）。

```Python
max_salary = df.groupby('Department')['Salary'].transform('max')
```

```
0    90000
1    90000
2    80000
3    80000
4    90000
Name: Salary, dtype: int64
```

因此，通过使用 `df[df['salary'] == max_salary]`，我们可以选择所有薪水等于各自部门最高薪水的员工。

```Python
df = df[df['Salary'] == max_salary]
```

我们将得到以下 DataFrame `df`：

| id_x | Employee | Salary | departmentId | id_y | Department |
| ---- | -------- | ------ | ------------ | ---- | ---------- |
| 1    | Jim      | 90000  | 1            | 1    | IT         |
| 2    | Henry    | 80000  | 2            | 2    | Sales      |
| 4    | Max      | 90000  | 1            | 1    | IT         |

最后一步是返回只包含所需列的 DataFrame，完整的代码如下。

**Pandas**

```Python
import pandas as pd

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    # 合并表以及重命名
    df = employee.merge(department, left_on='departmentId', right_on='id', how='left')
    df.rename(columns={'name_x': 'Employee', 'name_y': 'Department', 'salary': 'Salary'}, inplace=True)
    
    # 选择工资等于部门最高工资的员工
    max_salary = df.groupby('Department')['Salary'].transform('max')
    df = df[df['Salary'] == max_salary]
    
    return df[['Department', 'Employee', 'Salary']]
```

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |

<br>

**SQL**

由于 **Employee** 表中包含 *Salary* 和 *DepartmentId* 信息，我们可以查询每个部门的最高薪水。

```Sql
SELECT
    DepartmentId, MAX(Salary)
FROM
    Employee
GROUP BY DepartmentId;
```

> 注意：可能有多名员工拥有相同的最高薪水，因此在这个查询中没有包含员工名称信息是更严谨的。

| DepartmentId | MAX(Salary) |
| ------------ | ----------- |
| 1            | 90000       |
| 2            | 80000       |

然后，我们可以连接 **Employee** 表和 **Department** 表，并使用 `IN` 语句查询 (DepartmentId, Salary) 在临时表中的结果，如下所示。

**MySQL**

```Sql
SELECT
    Department.name AS 'Department',
    Employee.name AS '

Employee',
    Salary
FROM
    Employee
        JOIN
    Department ON Employee.DepartmentId = Department.Id
WHERE
    (Employee.DepartmentId , Salary) IN
    (   SELECT
            DepartmentId, MAX(Salary)
        FROM
            Employee
        GROUP BY DepartmentId
    )
;
```

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |