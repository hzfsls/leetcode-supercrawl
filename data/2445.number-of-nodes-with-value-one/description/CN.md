## [2445.值为 1 的节点数](https://leetcode.cn/problems/number-of-nodes-with-value-one/)
<p>有一个&nbsp;<strong>无向&nbsp;</strong>树，有 <code>n</code> 个节点，节点标记为从 <code>1</code> 到 <code>n</code>&nbsp;，还有&nbsp;<code>n - 1</code> 条边。给定整数 <code>n</code>。标记为 <code>v</code> 的节点的父节点是标记为&nbsp;<code>floor (v / 2)</code>&nbsp;的节点。树的根节点是标记为 <code>1</code> 的节点。</p>

<ul>
	<li>例如，如果 <code>n = 7</code>，那么标记为 <code>3</code> 的节点将标记&nbsp;<code>floor(3 / 2) = 1</code> 的节点作为其父节点，标记为 <code>7</code> 的节点将标记&nbsp;<code>floor(7 / 2) = 3</code> 的节点作为其父节点。</li>
</ul>

<p>你还得到一个整数数组 <code>queries</code>。最初，每个节点的值都是 <code>0</code>。对于每个查询 <code>queries[i]</code>，您应该翻转节点标记为&nbsp;<code>queries[i]</code> 的子树中的所有值。</p>

<p>在&nbsp;<strong>处理完所有查询后</strong>，返回<em>值为 <code>1</code> 的节点总数。</em></p>

<p><b>注意</b>:</p>

<ul>
	<li>翻转节点的值意味着值为 <code>0</code> 的节点变为 <code>1</code>，反之亦然。</li>
	<li><code>floor(x)</code>&nbsp;相当于将 <code>x</code> 舍入到最接近的整数。</li>
</ul>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/10/19/ex1.jpg" style="width: 600px; height: 297px;" />
<pre>
<strong>输入:</strong> n = 5 , queries = [1,2,5]
<strong>输出:</strong> 3
<strong>解释:</strong> 上图显示了执行查询后的树结构及其状态。蓝色节点表示值 0，红色节点表示值 1。
在处理查询之后，有三个红色节点 (值为 1 的节点): 1、3、5。
</pre>

<p><strong class="example">示例 2:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/10/19/ex2.jpg" style="width: 650px; height: 88px;" />
<pre>
<strong>输入:</strong> n = 3, queries = [2,3,3]
<strong>输出:</strong> 1
<strong>解释:</strong> 上图显示了执行查询后的树结构及其状态。蓝色节点表示值 0，红色节点表示值 1。
在处理查询之后，有一个红色节点 (值为 1 的节点): 2。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= queries.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= queries[i] &lt;= n</code></li>
</ul>
