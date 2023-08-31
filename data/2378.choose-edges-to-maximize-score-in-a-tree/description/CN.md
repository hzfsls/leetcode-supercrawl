## [2378.选择边来最大化树的得分](https://leetcode.cn/problems/choose-edges-to-maximize-score-in-a-tree/)
<p>给定一个&nbsp;<strong>加权&nbsp;</strong>树，由 <code>n</code> 个节点组成，从 <code>0</code> 到 <code>n - 1</code>。</p>

<p>该树以节点 0 为&nbsp;<strong>根</strong>，用大小为 <code>n</code> 的二维数组 <code>edges</code> 表示，其中 <code>edges[i] = [par<sub>i</sub>, weight<sub>i</sub>]</code> 表示节点 <code>par<sub>i</sub></code> 是节点 <code>i</code>&nbsp;的&nbsp;<strong>父&nbsp;</strong>节点，它们之间的边的权重等于 <code>weight<sub>i</sub></code>。因为根结点&nbsp;<strong>没有&nbsp;</strong>父结点，所以有 <code>edges[0] = [-1, -1]</code>。</p>

<p>从树中选择一些边，使所选的两条边都不&nbsp;<strong>相邻</strong>，所选边的权值之 <strong>和</strong> 最大。</p>

<p>&nbsp;</p>

<p>返回<em>所选边的&nbsp;<strong>最大&nbsp;</strong>和。</em></p>

<p><strong>注意</strong>:</p>

<ul>
	<li>你可以&nbsp;<strong>不选择&nbsp;</strong>树中的任何边，在这种情况下权值和将为 <code>0</code>。</li>
	<li>如果树中的两条边 <code>Edge<sub>1</sub></code> 和 <code>Edge<sub>2</sub></code> 有一个&nbsp;<strong>公共&nbsp;</strong>节点，它们就是&nbsp;<strong>相邻&nbsp;</strong>的。
	<ul>
		<li>换句话说，如果 <code>Edge<sub>1</sub></code>连接节点 <code>a</code> 和 <code>b</code>, <code>Edge<sub>2</sub></code> 连接节点 <code>b</code> 和 <code>c</code>，它们是相邻的。</li>
	</ul>
	</li>
</ul>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/08/16/treedrawio.png" style="width: 271px; height: 221px;" />
<pre>
<strong>输入:</strong> edges = [[-1,-1],[0,5],[0,10],[2,6],[2,4]]
<strong>输出:</strong> 11
<strong>解释:</strong> 上面的图表显示了我们必须选择红色的边。
总分是 5 + 6 = 11.
可以看出，没有更好的分数可以获得。
</pre>

<p><strong class="example">示例 2:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/08/17/treee1293712983719827.png" style="width: 221px; height: 181px;" />
<pre>
<strong>输入:</strong> edges = [[-1,-1],[0,5],[0,-6],[0,7]]
<strong>输出:</strong> 7
<strong>解释:</strong> 我们选择权值为 7 的边。
注意，我们不能选择一条以上的边，因为所有的边都是彼此相邻的。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>n == edges.length</code></li>
	<li><code>1 &lt;= n &lt;= 10<sup>5</sup></code></li>
	<li><code>edges[i].length == 2</code></li>
	<li><code>par<sub>0</sub> == weight<sub>0</sub> == -1</code></li>
	<li><code>i &gt;= 1</code>&nbsp;时&nbsp;<code>0 &lt;= par<sub>i</sub> &lt;= n - 1</code>&nbsp;。</li>
	<li><code>par<sub>i</sub> != i</code></li>
	<li><code>i &gt;= 1</code>&nbsp;时&nbsp;<code>-10<sup>6</sup> &lt;= weight<sub>i</sub> &lt;= 10<sup>6</sup></code> 。</li>
	<li><code>edges</code> 表示有效的树。</li>
</ul>
