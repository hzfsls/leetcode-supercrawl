## [562.矩阵中最长的连续1线段]
<p>给定一个&nbsp;<code>m x n</code>&nbsp;的二进制矩阵 <code>mat</code><b>&nbsp;</b>，返回矩阵中最长的连续1线段。</p>

<p>这条线段可以是水平的、垂直的、对角线的或者反对角线的。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/04/24/long1-grid.jpg" /></p>

<pre>
<strong>输入:</strong>&nbsp;mat = [[0,1,1,0],[0,1,1,0],[0,0,0,1]]
<strong>输出:</strong> 3
</pre>

<p><strong>示例 2:</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2021/04/24/long2-grid.jpg" /></p>

<pre>
<strong>输入:</strong> mat = [[1,1,1,1],[0,1,1,0],[0,0,0,1]]
<strong>输出:</strong> 4
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>m == mat.length</code></li>
	<li><code>n == mat[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 10<sup>4</sup></code></li>
	<li><code>1 &lt;= m * n &lt;= 10<sup>4</sup></code></li>
	<li><code>mat[i][j]</code>&nbsp;不是&nbsp;<code>0</code>&nbsp;就是&nbsp;<code>1</code>.</li>
</ul>
