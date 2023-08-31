## [615.平均工资：部门与公司比较 中文官方题解](https://leetcode.cn/problems/average-salary-departments-vs-company/solutions/100000/ping-jun-gong-zi-bu-men-yu-gong-si-bi-ji-9tv9)
[TOC]

## 解决方案

---

 #### 方法：使用 `avg()`和 `case...when...`

 **简述**

 按照下面三个步骤解决这个问题。

 **步骤**

 1. 计算每个月公司的平均工资。MySQL 有内置函数 avg() 来计算一列数字的平均值。我们还需要格式化 *pay_date* 列以便将来使用。

 ```Sql 
 select avg(amount) as company_avg, date_format(pay_date, '%Y-%m') as pay_month from salary group by date_format(pay_date, '%Y-%m') ;
 ```

| company_avg | pay_month |
| ----------- | --------- |
| 7000.0000   | 2017-02   |
| 8333.3333   | 2017-03   |

 2. 计算每个月每个部门的平均工资。为了做到这一点，我们需要将 **salary** 表和 **employee** 表用条件`salary.employee_id = employee.id`连接起来。

 ```Sql
 select department_id, avg(amount) as department_avg, date_format(pay_date, '%Y-%m') as pay_month from salary join employee on salary.employee_id = employee.employee_id group by department_id, pay_month ;
 ```

| department_id | department_avg | pay_month |
| ------------- | -------------- | --------- |
| 1             | 7000.0000      | 2017-02   |
| 1             | 9000.0000      | 2017-03   |
| 2             | 7000.0000      | 2017-02   |
| 2             | 8000.0000      | 2017-03   |

 3. 比较前面的数字并显示结果 如果你不知道如何使用 MySQL 流控制语句[`case...when...`](https://dev.mysql.com/doc/refman/5.7/en/case.html) ，这一步可能是最困难的。

 MySQL，像其他编程语言一样，也有它的流控制。点击[这个链接](https://dev.mysql.com/doc/refman/5.7/en/flow-control-statements.html)学习一下。

 最后，把上面两个查询合并起来，并且用 `department_salary.pay_month = company_salary.pay_month` 来连接。

 **MySQL**

 ```Sql [slu1]
 select department_salary.pay_month, department_id,
case
  when department_avg>company_avg then 'higher'
  when department_avg<company_avg then 'lower'
  else 'same'
end as comparison
from
(
  select department_id, avg(amount) as department_avg, date_format(pay_date, '%Y-%m') as pay_month
  from salary join employee on salary.employee_id = employee.employee_id
  group by department_id, pay_month
) as department_salary
join
(
  select avg(amount) as company_avg,  date_format(pay_date, '%Y-%m') as pay_month from salary group by date_format(pay_date, '%Y-%m')
) as company_salary
on department_salary.pay_month = company_salary.pay_month
;
 ```