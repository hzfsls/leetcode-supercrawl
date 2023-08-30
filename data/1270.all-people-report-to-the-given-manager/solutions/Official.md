#### 方法一：`UNION ALL`、子查询

**思路**

本题规定**经理之间的间接关系不超过 3 个经理**，那么我们可以分别求出 3 层的人数，最后汇总到一起。

首先第一层是 CEO 的直接汇报人：

```mysql
SELECT employee_id FROM Employees WHERE manager_id = 1
```

很显然第二层的汇报人的 `manager_id` 就是第一层直接向 `CEO` 汇报的人，因此可以使用子查询的方式，求出第二层的人：

```mysql
SELECT employee_id
FROM Employees WHERE manager_id IN (
    SELECT employee_id FROM Employees WHERE manager_id = 1
)
```

同样的，第三层的汇报人就是第二步求出来的人，直接代入到自查询中即可：

```mysql
SELECT employee_id
FROM Employees WHERE manager_id IN (
    SELECT employee_id FROM Employees WHERE manager_id IN (
        SELECT employee_id FROM Employees WHERE manager_id = 1
    )
)
```

至此我们就求出来所有的汇报人，然后只需要使用 `UNION ALL` 将他们汇总到一起输出即可，因为 CEO 的 `manager_id` 也为 1，所以结果集需要过滤掉 `employee_id = 1`。

**代码**

```mysql [sol1-MySQL]
SELECT DISTINCT employee_id FROM (
    SELECT employee_id
    FROM Employees WHERE manager_id = 1
    UNION ALL
    SELECT employee_id
    FROM Employees WHERE manager_id IN (
        SELECT employee_id FROM Employees WHERE manager_id = 1
    )
    UNION ALL
    SELECT employee_id
    FROM Employees WHERE manager_id IN (
        SELECT employee_id FROM Employees WHERE manager_id IN (
            SELECT employee_id FROM Employees WHERE manager_id = 1
        )
    )
) T WHERE employee_id != 1
```


#### 方法二：`JOIN`

**思路**

根据方法一我们知道第一次查询的 `manager_id` 等于第二次查询的 `employee_id`。根据这个规则，我们可以使用 `JOIN` 将两条数据连接。通过 `e2.manager_id = 1` 查询所有需要向 CEO 汇报的人 ，`e1.employee_id` 就是我们要查询的数据。

对于下一层的汇报人，同样的再做一次 `JOIN` 即可。

**代码**

```mysql [sol2-MySQL]
SELECT e1.employee_id
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
JOIN Employees e3 ON e2.manager_id = e3.employee_id
WHERE e1.employee_id != 1 AND e3.manager_id = 1
```