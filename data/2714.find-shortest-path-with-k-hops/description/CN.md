## [2714.找到最短路径的 K 次跨越](https://leetcode.cn/problems/find-shortest-path-with-k-hops/)
<p>现给定一个正整数 n ，它表示一个<strong>&nbsp;索引从 0 开始的无向带权连接图</strong> 的节点数，以及一个&nbsp;<strong>索引从 0 开始的二维数组&nbsp;</strong><code>edges</code> ，其中 <code>edges[i] = [ui, vi, wi]</code> 表示节点 <code>ui</code> 和 <code>vi</code> 之间存在权重为 <code>wi</code> 的边。</p>

<p>还给定两个节点 <code>s</code> 和 <code>d</code> ，以及一个正整数 <code>k</code> ，你的任务是找到从 s 到 d 的 <strong>最短 </strong>路径，但你可以 <strong>最多</strong> 跨越 <code>k</code> 条边。换句话说，将 <strong>最多</strong> <code>k</code> 条边的权重设为 <code>0</code>，然后找到从 <code>s</code> 到 <code>d</code> 的 <strong>最短</strong> 路径。</p>

<p>返回满足给定条件的从 <code>s</code> 到 <code>d</code> 的 <strong>最短</strong> 路径的长度。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>n = 4, edges = [[0,1,4],[0,2,2],[2,3,6]], s = 1, d = 3, k = 2
<b>输出：</b>2
<b>解释：</b>在这个例子中，只有一条从节点1（绿色节点）到节点3（红色节点）的路径，即（1-&gt;0-&gt;2-&gt;3），其长度为4 + 2 + 6 = 12。现在我们可以将两条边的权重设为 0，即将蓝色边的权重设为 0，那么路径的长度就变为 0 + 2 + 0 = 2。可以证明 2 是我们在给定条件下能够达到的最小路径长度。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/30/1.jpg" style="width: 170px; height: 171px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>n = 7, edges = [[3,1,9],[3,2,4],[4,0,9],[0,5,6],[3,6,2],[6,0,4],[1,2,4]], s = 4, d = 1, k = 2
<b>输出：</b>6
<b>解释：</b>在这个例子中，有两条从节点4（绿色节点）到节点1（红色节点）的路径，分别是（4-&gt;0-&gt;6-&gt;3-&gt;2-&gt;1）和（4-&gt;0-&gt;6-&gt;3-&gt;1）。第一条路径的长度为 9 + 4 + 2 + 4 + 4 = 23，第二条路径的长度为 9 + 4 + 2 + 9 = 24。现在，如果我们将蓝色边的权重设为 0，那么最短路径的长度就变为 0 + 4 + 2 + 0 = 6。可以证明 6 是我们在给定条件下能够达到的最小路径长度。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/30/2.jpg" style="width: 400px; height: 171px;" /></p>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>n = 5, edges = [[0,4,2],[0,1,3],[0,2,1],[2,1,4],[1,3,4],[3,4,7]], s = 2, d = 3, k = 1
<b>输出：</b>3
<b>解释：</b>在这个例子中，从节点2（绿色节点）到节点3（红色节点）有4条路径，分别是（2-&gt;1-&gt;3）、（2-&gt;0-&gt;1-&gt;3）、（2-&gt;1-&gt;0-&gt;4-&gt;3）和（2-&gt;0-&gt;4-&gt;3）。前两条路径的长度为4 + 4 = 1 + 3 + 4 = 8，第三条路径的长度为4 + 3 + 2 + 7 = 16，最后一条路径的长度为1 + 2 + 7 = 10。现在，如果我们将蓝色边的权重设为 0，那么最短路径的长度就为1 + 2 + 0 = 3。可以证明在给定条件下，3 是我们能够达到的最小路径长度。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/30/3.jpg" style="width: 300px; height: 296px;" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= n &lt;= 500</code></li>
	<li><code>n - 1 &lt;= edges.length &lt;= n * (n - 1) / 2</code></li>
	<li><code>edges[i].length = 3</code></li>
	<li><code>0 &lt;= edges[i][0], edges[i][1] &lt;= n - 1</code></li>
	<li><code>1 &lt;= edges[i][2] &lt;=&nbsp;10<sup>6</sup></code></li>
	<li><code>0 &lt;= s, d, k&nbsp;&lt;= n - 1</code></li>
	<li><code>s != d</code></li>
	<li>输入的生成确保图是 <strong>连通</strong> 的，并且没有 <strong>重复的边</strong> 或 <strong>自环</strong>。</li>
</ul>
