## [2737.找到最近的标记节点]
<p>给定一个正整数 <code>n</code> ，表示一个 <strong>索引从 0 开始的有向加权</strong> 图的节点数量，以及一个 <strong>索引从 0 开始的二维数组</strong> <code>edges</code> ，其中 <code>edges[i] = [u<sub>i</sub>, v<sub>i</sub>, w<sub>i</sub>]</code> 表示从节点 <code>u<sub>i</sub></code> 到节点 <code>v<sub>i</sub></code> 的一条权重为 <code>w<sub>i</sub></code> 的边。</p>

<p>并给定一个节点 <code>s</code> 和一个节点数组 <code>marked</code> ；你的任务是找到从 <code>s</code> 到 <code>marked</code> 中 <strong>任何</strong> 节点的 <strong>最短</strong> 距离。</p>

<p>返回一个整数，表示从 <code>s</code> 到 <code>marked</code> 中任何节点的最短距离，如果从 s 到任何标记节点没有路径，则返回 <code>-1</code>&nbsp;。</p>

<p>&nbsp;</p>

<p><b>示例 1：</b></p>

<pre>
<b>输入：</b>n = 4, edges = [[0,1,1],[1,2,3],[2,3,2],[0,3,4]], s = 0, marked = [2,3]
<b>输出：</b>4
<b>解释：</b>从节点 0（绿色节点）到节点 2（红色节点）有一条路径，即 0-&gt;1-&gt;2，距离为 1 + 3 = 4。 
从节点 0 到节点 3（红色节点）有两条路径，即 0-&gt;1-&gt;2-&gt;3 和 0-&gt;3，分别距离为 1 + 3 + 2 = 6 和 4。 
它们中的最小值是 4。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/06/13/image_2023-06-13_16-34-38.png" style="width: 185px; height: 180px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>n = 5, edges = [[0,1,2],[0,2,4],[1,3,1],[2,3,3],[3,4,2]], s = 1, marked = [0,4]
<b>输出：</b>3
<b>解释：</b>从节点 1（绿色节点）到节点 0（红色节点）没有路径。 
从节点 1 到节点 4（红色节点）有一条路径，即 1-&gt;3-&gt;4，距离为 1 + 2 = 3。 
因此答案是 3。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/06/13/image_2023-06-13_16-35-13.png" style="width: 300px; height: 285px;" /></p>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>n = 4, edges = [[0,1,1],[1,2,3],[2,3,2]], s = 3, marked = [0,1]
<b>输出：</b>-1
<b>解释：</b>从节点 3（绿色节点）到任何一个标记节点（红色节点）都没有路径，因此答案是 -1。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/06/13/image_2023-06-13_16-35-47.png" style="width: 420px; height: 80px;" /></p>

<p>&nbsp;</p>

<p><b>提示：</b></p>

<ul>
	<li><code>2 &lt;= n &lt;= 500</code></li>
	<li><code>1 &lt;= edges.length &lt;= 10<sup>4</sup></code></li>
	<li><code>edges[i].length = 3</code></li>
	<li><code>0 &lt;= edges[i][0], edges[i][1] &lt;= n - 1</code></li>
	<li><code>1 &lt;= edges[i][2] &lt;=&nbsp;10<sup>6</sup></code></li>
	<li><code>1 &lt;= marked.length&nbsp;&lt;= n - 1</code></li>
	<li><code>0 &lt;= s, marked[i]&nbsp;&lt;= n - 1</code></li>
	<li><code>s != marked[i]</code></li>
	<li>如果&nbsp;<code>i != j</code>&nbsp;则&nbsp;<code>marked[i] != marked[j]</code></li>
	<li>图中可能有 <strong>重复的边 。</strong></li>
	<li>图的生成不会出现 <strong>自环</strong> 。</li>
</ul>
