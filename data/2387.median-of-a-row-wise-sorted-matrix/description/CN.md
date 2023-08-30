## [2387.行排序矩阵的中位数]
<p>给定一个包含&nbsp;<strong>奇数&nbsp;</strong>个整数的&nbsp;<code>m x n</code> 矩阵&nbsp;<code>grid</code>，其中每一行按 <strong>非递减 </strong>的顺序排序，返回矩阵的&nbsp;<strong>中位数</strong>。</p>

<p>你必须以 <code>O(m * log(n))</code> 的时间复杂度来解决这个问题。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> grid = [[1,1,2],[2,3,3],[1,3,4]]
<strong>输出:</strong> 2
<strong>解释:</strong> 矩阵的元素按顺序排列为 1,1,1,2,<u>2</u>,3,3,3,4。中位数是 2。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> grid = [[1,1,3,3,4]]
<strong>输出:</strong> 3
<strong>解释:</strong> 矩阵的元素按顺序排列为 1,1,<u>3</u>,3,4。中位数是 3。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 500</code></li>
	<li><code>m</code> 和&nbsp;<code>n</code>&nbsp;都是奇数。</li>
	<li><code>1 &lt;= grid[i][j] &lt;= 10<sup>6</sup></code></li>
	<li><code>grid[i]</code> 按非递减顺序排序</li>
</ul>
