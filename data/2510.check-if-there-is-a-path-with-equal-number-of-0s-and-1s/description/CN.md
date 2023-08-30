## [2510.检查是否有路径经过相同数量的 0 和 1]
<p>给定一个 <strong>下标从 0 开始</strong> 的 <code>m x n</code> 的 <strong>二进制</strong> 矩阵 <code>grid</code> ，从坐标为 <code>(row, col)</code> 的元素可以向右走 <code>(row, col+1)</code> 或向下走 <code>(row+1, col)</code> 。</p>

<p>返回一个布尔值，表示从 <code>(0, 0)</code> 出发是否存在一条路径，经过 <strong>相同</strong> 数量的 <code>0</code> 和 <code>1</code>，到达终点 <code>(m-1, n-1)</code> 。如果存在这样的路径返回 <code>true</code> ，否则返回 <code>false</code> 。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/12/20/yetgriddrawio-4.png" />
<pre>
<b>输入：</b>grid = [[0,1,0,0],[0,1,0,0],[1,0,1,0]]
<b>输出：</b>true
<b>解释：</b>以上图中用蓝色标记的路径是一个有效的路径，因为路径上有 3 个值为 1 的单元格和 3 个值为 0 的单元格。由于存在一个有效的路径，因此返回 true 。
</pre>

<p><strong class="example">示例 2 ：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/12/20/yetgrid2drawio-1.png" style="width: 151px; height: 151px;" />
<pre>
<b>输入：</b>grid = [[1,1,0],[0,0,1],[1,0,0]]
<b>输出：</b>false
<b>解释：</b>这个网格中没有一条路径经过相等数量的0和1。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>2 &lt;= m, n &lt;= 100</code></li>
	<li><code>grid[i][j]</code> 不是&nbsp;<code>0</code> 就是&nbsp;<code>1</code> 。</li>
</ul>
