## [2479.两个不重叠子树的最大异或值]
<p>有一个无向树，有 <code>n</code> 个节点，节点标记为从 <code>0</code> 到 <code>n - 1</code>。给定整数 <code>n</code> 和一个长度为 <code>n - 1</code> 的 2 维整数数组 <code>edges</code>，其中 <code>edges[i] = [a<sub>i</sub>, b<sub>i</sub>]</code> 表示在树中的节点 <code>a<sub>i</sub></code> 和 <code>b<sub>i</sub></code> 之间有一条边。树的根节点是标记为 <code>0</code> 的节点。</p>

<p data-group="1-1">每个节点都有一个相关联的 <strong>值</strong>。给定一个长度为 n 的数组 <code>values</code>，其中 <code>values[i]</code> 是第 <code>i</code> 个节点的&nbsp;<strong>值</strong>。</p>

<p>选择任意两个&nbsp;<strong>不重叠&nbsp;</strong>的子树。你的&nbsp;<strong>分数&nbsp;</strong>是这些子树中值的和的逐位异或。</p>

<p>返回<em>你能达到的最大分数</em>。<em>如果不可能找到两个不重叠的子树</em>，则返回 <code>0</code>。</p>

<p><strong>注意</strong>：</p>

<ul>
	<li>节点的&nbsp;<strong>子树&nbsp;</strong>是由该节点及其所有子节点组成的树。</li>
	<li>如果两个子树不共享&nbsp;<strong>任何公共&nbsp;</strong>节点，则它们是&nbsp;<strong>不重叠&nbsp;</strong>的。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/11/22/treemaxxor.png" style="width: 346px; height: 249px;" />
<pre>
<strong>输入:</strong> n = 6, edges = [[0,1],[0,2],[1,3],[1,4],[2,5]], values = [2,8,3,6,2,5]
<strong>输出:</strong> 24
<strong>解释:</strong> 节点 1 的子树的和值为 16，而节点 2 的子树的和值为 8，因此选择这些节点将得到 16 XOR 8 = 24 的分数。可以证明，这是我们能得到的最大可能分数。
</pre>

<p><strong>示例 2：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/11/22/tree3drawio.png" style="width: 240px; height: 261px;" />
<pre>
<strong>输入:</strong> n = 3, edges = [[0,1],[1,2]], values = [4,6,1]
<strong>输出:</strong> 0
<strong>解释:</strong> 不可能选择两个不重叠的子树，所以我们只返回 0。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= n &lt;= 5 * 10<sup>4</sup></code></li>
	<li><code>edges.length == n - 1</code></li>
	<li><code>0 &lt;= a<sub>i</sub>, b<sub>i</sub> &lt; n</code></li>
	<li><code>values.length == n</code></li>
	<li><code>1 &lt;= values[i] &lt;= 10<sup>9</sup></code></li>
	<li>保证 <code>edges</code> 代表一个有效的树。</li>
</ul>
