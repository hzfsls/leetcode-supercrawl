## [2159.分别排序两列](https://leetcode.cn/problems/order-two-columns-independently/)
<p>表：<code>Data</code></p>

<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
该表没有主键且可能包含重复数据。
</pre>

<p>&nbsp;</p>

<p>请你编写 SQL 使：</p>

<ul>
	<li><code>first_col</code> 按照<strong> 升序 </strong>排列。</li>
	<li><code>second_col</code> 按照 <strong>降序 </strong>排列。</li>
</ul>

<p>查询返回的结果格式如下。</p>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入：</strong>
Data 表：
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
<strong>输出：</strong>
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+
</pre>
