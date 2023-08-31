## [580.统计各专业学生人数 中文官方题解](https://leetcode.cn/problems/count-student-number-in-departments/solutions/100000/tong-ji-ge-zhuan-ye-xue-sheng-ren-shu-by-zy81)

[TOC]

## 解决方案

---

#### 方法：使用 `OUTER JOIN` 和 `COUNT(expression)`

 **简述**
 使用 `GROUP BY` 函数可以度量一个部门中的学生数量，然后使用 `COUNT` 函数来统计每个部门的记录数量。
 **算法**
 我们可以用`OUTER JOIN`查询所有的部门。这个问题就是要为当前没有学生的部门显示'0'。有些人会使用`COUNT(*)`来编写如下的查询。

 ```Sql
SELECT
    dept_name, COUNT(*) AS student_number
FROM
    department
        LEFT OUTER JOIN
    student ON department.dept_id = student.dept_id
GROUP BY department.dept_name
ORDER BY student_number DESC , department.dept_name
;
 ```

 可惜，对于像 'Law' 这样的没有当前学生的部门，它错误地显示了 '1'。

```
| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Law         | 1              |
| Science     | 1              |
```

相反，可以使用 `COUNT(expression)`，因为它不考虑 `expression is null` 的情况。你可以参考 [MySQL手册](https://dev.mysql.com/doc/refman/5.7/en/counting-rows.html) 了解详细信息。
 因此，在修复了上述问题后，可以得到正确的解决方案。
 **MySQL**

 ```Sql
SELECT
    dept_name, COUNT(student_id) AS student_number
FROM
    department
        LEFT OUTER JOIN
    student ON department.dept_id = student.dept_id
GROUP BY department.dept_name
ORDER BY student_number DESC , department.dept_name
;
 ```