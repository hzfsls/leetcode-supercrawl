#### 算法
首先需要知道每个员工的奖金数量，因此需要首先将 `Employee` 表与 `Bonus` 表连接。注意需要使用外连接，以处理员工没有出现在 `Bonus` 表上的情况。这里因为不存在员工只出现在 `Bonus` 表中的情况，所以只需要使用左外连接（`left join` 或 `left outer join`）。
```MySQL [-MySQL]
select name, bonus
from Employee left join Bonus
on Employee.EmpId = Bonus.EmpId
```
对于题目中的样例，上面的代码运行可以得到如下输出：
```
| name   | bonus |
|--------|-------|
| Dan    | 500   |
| Thomas | 2000  |
| Brad   |       |
| John   |       |
```
其中 `Brad` 和 `John` 的 `bonus` 值为空，空值在数据库中的表示为 `null`。我们使用 `bonus is null`（而不是 `bonus = null`）判断奖金是否为 `null`。随后即可用 `where` 子句筛选奖金小于 1000 或者为空的员工。
```MySQL [-MySQL]
select name, bonus
from Employee left join Bonus
on Employee.EmpId = Bonus.EmpId
where bonus is null or bonus < 1000
```
