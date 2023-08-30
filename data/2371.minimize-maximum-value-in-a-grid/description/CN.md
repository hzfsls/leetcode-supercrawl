## [2371.最小化网格中的最大值]
<p>给定一个包含&nbsp;<strong>不同&nbsp;</strong>正整数的 <code>m × n</code> 整数矩阵 <code>grid</code>。</p>

<p>必须将矩阵中的每一个整数替换为正整数，且满足以下条件:</p>

<ul>
	<li>在替换之后，同行或同列中的每两个元素的&nbsp;<strong>相对&nbsp;</strong>顺序应该保持&nbsp;<strong>不变</strong>。</li>
	<li>替换后矩阵中的 <strong>最大</strong> 数目应尽可能 <strong>小</strong>。</li>
</ul>

<p>如果对于原始矩阵中的所有元素对，使&nbsp;<code>grid[r<sub>1</sub>][c<sub>1</sub>] &gt; grid[r<sub>2</sub>][c<sub>2</sub>]</code>，其中要么&nbsp;<code>r<sub>1</sub> == r<sub>2</sub></code> ，要么&nbsp;<code>c<sub>1</sub> == c<sub>2</sub></code>，则相对顺序保持不变。那么在替换之后一定满足&nbsp;<code>grid[r<sub>1</sub>][c<sub>1</sub>] &gt; grid[r<sub>2</sub>][c<sub>2</sub>]</code>。</p>

<p>例如，如果&nbsp;<code>grid = [[2, 4, 5], [7, 3, 9]]</code>，那么一个好的替换可以是 <code>grid = [[1, 2, 3], [2, 1, 4]]</code> 或 <code>grid = [[1, 2, 3], [3, 1, 4]]</code>。</p>

<p>返回&nbsp;<em><strong>结果&nbsp;</strong>矩阵</em>。如果有多个答案，则返回其中&nbsp;<strong>任何&nbsp;</strong>一个。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/08/09/grid2drawio.png" />
<pre>
<strong>输入:</strong> grid = [[3,1],[2,5]]
<strong>输出:</strong> [[2,1],[1,2]]
<strong>解释:</strong> 上面的图显示了一个有效的替换。
矩阵中的最大值是 2。可以证明，不能得到更小的值。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> grid = [[10]]
<strong>输出:</strong> [[1]]
<strong>解释:</strong> 我们将矩阵中唯一的数字替换为 1。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 1000</code></li>
	<li><code>1 &lt;= m * n &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= grid[i][j] &lt;= 10<sup>9</sup></code></li>
	<li><code>grid</code> 由不同的整数组成。</li>
</ul>
