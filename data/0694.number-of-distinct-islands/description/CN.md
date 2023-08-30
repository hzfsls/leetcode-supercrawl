## [694.不同岛屿的数量]
<p>给定一个非空 01 二维数组表示的网格，一个岛屿由四连通（上、下、左、右四个方向）的 <code>1</code> 组成，你可以认为网格的四周被海水包围。</p>

<p>请你计算这个网格中共有多少个形状不同的岛屿。两个岛屿被认为是相同的，当且仅当一个岛屿可以通过平移变换（不可以旋转、翻转）和另一个岛屿重合。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/05/01/distinctisland1-1-grid.jpg" /></p>

<pre>
<strong>输入:</strong> grid = [[1,1,0,0,0],[1,1,0,0,0],[0,0,0,1,1],[0,0,0,1,1]]
<b>输出：</b>1
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入:</strong> grid = [[1,1,0,1,1],[1,0,0,0,0],[0,0,0,0,1],[1,1,0,1,1]]
<b>输出</b><strong>:</strong> 3</pre>

<p><img src="https://assets.leetcode.com/uploads/2021/05/01/distinctisland1-2-grid.jpg" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 50</code></li>
	<li><code>grid[i][j]</code>&nbsp;仅包含&nbsp;<code>0</code>&nbsp;或&nbsp;<code>1</code></li>
</ul>
