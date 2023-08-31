## [579.查询员工的累计薪水 中文官方题解](https://leetcode.cn/problems/find-cumulative-salary-of-an-employee/solutions/100000/cha-xun-yuan-gong-de-lei-ji-xin-shui-by-leetcode-s)
#### 方法一：先求最近 2 个月薪资

**想法**

分两步解决这个问题。第一步是求得一个员工最近 3 个月的累积薪资，然后把最近一个月薪资从包含它的数据中去除。

**算法**

如果你觉得求一个员工 3 个月的累积薪资有难度，可以从 2 个月的累积薪资开始考虑。通过把 **Employee** 表与它自己做一个连接，你可以得到每个员工 2 个月的薪资表。

```sql [-Sql]
SELECT *
FROM
    Employee E1
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
ORDER BY E1.id ASC , E1. month DESC
```

| Id | Month | Salary | Id | Month | Salary |
|----|-------|--------|----|-------|--------|
| 1  | 4     | 60     | 1  | 3     | 40     |
| 1  | 3     | 40     | 1  | 2     | 30     |
| 1  | 2     | 30     | 1  | 1     | 20     |
| 1  | 1     | 20     |    |       |        |
| 2  | 2     | 30     | 2  | 1     | 20     |
| 2  | 1     | 20     |    |       |        |
| 3  | 4     | 70     | 3  | 3     | 60     |
| 3  | 3     | 60     | 3  | 2     | 40     |
| 3  | 2     | 40     |    |       |        |
>注意：
> - 上表中空白的值在数据库中实际上是 `NULL` 。
> - 上表中前三列来自 E1 ，其余列来自 E2 。

然后我们求得 2 个月的累积薪资。

```sql [-Sql]
SELECT
    E1.id,
    E1.month,
    (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0)) AS Salary
FROM
    Employee E1
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
ORDER BY E1.id ASC , E1.month DESC
```
```
| id | month | Salary |
|----|-------|--------|
| 1  | 4     | 100    |
| 1  | 3     | 70     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 2     | 50     |
| 2  | 1     | 20     |
| 3  | 4     | 130    |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
```

类似的，你可以将此表再次连接来求得 3 个月的累计薪资。

```sql [-Sql]
SELECT
    E1.id,
    E1.month,
    (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary, 0)) AS Salary
FROM
    Employee E1
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
        LEFT JOIN
    Employee E3 ON (E3.id = E1.id
        AND E3.month = E1.month - 2)
ORDER BY E1.id ASC , E1.month DESC
;
```
```
| id | month | Salary |
|----|-------|--------|
| 1  | 4     | 130    |
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 2     | 50     |
| 2  | 1     | 20     |
| 3  | 4     | 170    |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
```
除此以外，我们还需要按要求去除最近一个月薪资的影响。如果我们有一个包含了每个 id 和该员工最近一个月是几月的临时表，我们就可以很轻易地把每个员工最近一个月的工资去除。
```
| id | month |
|----|-------|
| 1  | 4     |
| 2  | 2     |
| 3  | 4     |
```

下面是生成此表的代码。
```sql [-Sql]
SELECT
    id, MAX(month) AS month
FROM
    Employee
GROUP BY id
HAVING COUNT(*) > 1
;
```

最后，我们把这两张表连接起来得到我们想要的连续 3 个月薪资但不包含最近一个月薪资的结果。

**MySQL**

```sql [-Sql]
SELECT
    E1.id,
    E1.month,
    (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary, 0)) AS Salary
FROM
    (SELECT
        id, MAX(month) AS month
    FROM
        Employee
    GROUP BY id
    HAVING COUNT(*) > 1) AS maxmonth
        LEFT JOIN
    Employee E1 ON (maxmonth.id = E1.id
        AND maxmonth.month > E1.month)
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
        LEFT JOIN
    Employee E3 ON (E3.id = E1.id
        AND E3.month = E1.month - 2)
ORDER BY id ASC , month DESC
;
```

#### 方法二：直接计算所有需要累计的月份

**想法**

我们可以先用一个查询求得对于每个员工来说需要累计的月份，然后将这些月份对应的前两月的工资相加。

**算法**

每个员工需要进行累计的月份是除他的最大月份外的所有月份，按员工分组并用 `max` 聚合函数可以求得每个员工的最大月份。求得最大月份后，再查询对于每个员工来说所有不等于最大月份的月份。这些月份即为需要累计的月份。

```
select Employee.Id as Id, Employee.Month as Month
from Employee, (select Id, max(Month) as Month
    from Employee
    group by Id) as LastMonth
    where Employee.Id = LastMonth.Id and Employee.Month != LastMonth.Month
```

然后对于每个需要累计的月份，记录它的前两个月份，将对应关系记录到一个表中，这样的查询可以通过 `join` 语句实现。

```
select a.Id as Id, a.Month as AccMonth, b.Month as Month, b.Salary as Salary
from 
(
    select Employee.Id as Id, Employee.Month as Month
    from Employee, (select Id, max(Month) as Month
        from Employee
        group by Id) as LastMonth
        where Employee.Id = LastMonth.Id and Employee.Month != LastMonth.Month) as a 
join Employee as b
on a.Id = b.Id and a.Month - b.Month <= 2 and a.Month - b.Month >= 0
```

进行上述查询后，对于题目的输入，可以得到这样一张表（为了方便理解，这里对表进行了排序）：
```
| Id | AccMonth | Month | Salary |
|----|----------|-------|--------|
|  1 |        1 |     1 |     20 |
|  1 |        2 |     1 |     20 |
|  1 |        2 |     2 |     30 |
|  1 |        3 |     1 |     20 |
|  1 |        3 |     2 |     30 |
|  1 |        3 |     3 |     40 |
|  2 |        1 |     1 |     20 |
|  3 |        2 |     2 |     40 |
|  3 |        3 |     2 |     40 |
|  3 |        3 |     3 |     60 |
```

可以看到，`AccMonth` 对应每个需要输出的累计月份，而 `AccMonth` 对应的 `Month` 其前三个月份。所以此时只要按照员工 `Id` 与需要累计的月份 `AccMonth` 分组，并用 `sum` 聚合函数计算累计工资即可。

```
select Id, AccMonth as Month, sum(Salary) as Salary
from
(
    select a.Id as Id, a.Month as AccMonth, b.Month as Month, b.Salary as Salary
    from 
    (
        select Employee.Id as Id, Employee.Month as Month
        from Employee, (select Id, max(Month) as Month
            from Employee
            group by Id) as LastMonth
            where Employee.Id = LastMonth.Id and Employee.Month != LastMonth.Month) as a 
    join Employee as b
    on a.Id = b.Id and a.Month - b.Month <= 2 and a.Month - b.Month >= 0
) as acc
group by Id, AccMonth
order by Id, Month desc
```