## [2174.通过翻转行或列来去除所有的 1 II]
<p>给定&nbsp;<strong>下标从 0 开始&nbsp;</strong>的 <code>m x n</code> <strong>二进制&nbsp;</strong>矩阵 <code>grid</code>。</p>

<p>在一次操作中，可以选择满足以下条件的任意 <code>i</code> 和 <code>j</code>:</p>

<ul>
	<li><code>0 &lt;= i &lt; m</code></li>
	<li><code>0 &lt;= j &lt; n</code></li>
	<li><code>grid[i][j] == 1</code></li>
</ul>

<p>并将第 <code>i</code> 行和第 <code>j</code> 列中的&nbsp;<strong>所有&nbsp;</strong>单元格的值更改为零。</p>

<p>返回<em>从&nbsp;</em><code>grid</code><em> 中删除所有 <code>1</code> 所需的最小操作数。</em></p>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/13/image-20220213162716-1.png" style="width: 709px; height: 200px;" />
<pre>
<strong>输入:</strong> grid = [[1,1,1],[1,1,1],[0,1,0]]
<strong>输出:</strong> 2
<strong>解释:</strong>
在第一个操作中，将第 1 行和第 1 列的所有单元格值更改为 0。
在第二个操作中，将第 0 行和第 0 列的所有单元格值更改为 0。
</pre>

<p><strong class="example">示例 2:</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/13/image-20220213162737-2.png" style="width: 734px; height: 200px;" />
<pre>
<strong>输入:</strong> grid = [[0,1,0],[1,0,1],[0,1,0]]
<strong>输出:</strong> 2
<strong>解释:</strong>
在第一个操作中，将第 1 行和第 0 列的所有单元格值更改为 0。
在第二个操作中，将第 2 行和第 1 列的所有单元格值更改为 0。
注意，我们不能使用行 1 和列 1 执行操作，因为 grid[1][1]!= 1。
</pre>

<p><strong class="example">示例 3:</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/13/image-20220213162752-3.png" style="width: 156px; height: 150px;" />
<pre>
<strong>输入:</strong> grid = [[0,0],[0,0]]
<strong>输出:</strong> 0
<strong>解释:</strong>
没有 1 可以移除，所以返回0。</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 15</code></li>
	<li><code>1 &lt;= m * n &lt;= 15</code></li>
	<li><code>grid[i][j]</code> 为&nbsp;<code>0</code>&nbsp;或&nbsp;<code>1</code>。</li>
</ul>
