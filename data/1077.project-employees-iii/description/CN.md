## [1077.项目员工 III]
<p>项目表&nbsp;<code>Project</code>：</p>

<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) 是这个表的主键（具有唯一值的列的组合）
employee_id 是员工表 Employee 的外键（reference 列）
该表的每一行都表明具有 employee_id 的雇员正在处理具有 project_id 的项目。
</pre>

<p>员工表&nbsp;<code>Employee</code>：</p>

<pre>
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id 是这个表的主键（具有唯一值的列）
该表的每一行都包含一名雇员的信息。
</pre>

<p>&nbsp;</p>

<p>编写解决方案，报告在每一个项目中 <strong>经验最丰富</strong> 的雇员是谁。如果出现经验年数相同的情况，请报告所有具有最大经验年数的员工。</p>

<p>返回结果表 <strong>无顺序要求 。</strong></p>

<p>结果格式如下示例所示。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>
Project 表：
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee 表：
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
<strong>输出：</strong>
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
<strong>解释：</strong>employee_id 为 1 和 3 的员工在 project_id 为 1 的项目中拥有最丰富的经验。在 project_id 为 2 的项目中，employee_id 为 1 的员工拥有最丰富的经验。</pre>