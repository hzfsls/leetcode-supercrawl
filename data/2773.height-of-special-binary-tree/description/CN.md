## [2773.特殊二叉树的高度](https://leetcode.cn/problems/height-of-special-binary-tree/)
<p>给定一棵具有 <code>n</code> 个节点的 <strong>特殊</strong> 二叉树的根节点 <code>root</code> 。特殊二叉树的节点编号从 <code>1</code> 到 <code>n</code> 。假设这棵树有 <code>k</code> 个叶子，顺序如下：<code>b<sub>1</sub> &lt; b<sub>2</sub> &lt; ... &lt; b<sub>k</sub></code> 。</p>

<p>这棵树的叶子节点有一个 <strong>特殊</strong> 属性 ！对于每个叶子节点 <code>b<sub>i</sub></code> ，满足以下条件：</p>

<ul>
	<li>如果 <code>i &lt; k</code> ，则 <code>b<sub>i</sub></code> 的右子节点为 <code>b<sub>i</sub> + 1</code> ；否则为 <code>b<sub>1</sub></code> 。</li>
	<li>如果 <code>i &gt; 1</code> ，则 <code>b<sub>i</sub></code> 的左子节点为 <code>b<sub>i</sub> - 1</code> ；否则为 <code>b<sub>k</sub></code> 。</li>
</ul>

<p>返回给定树的高度。</p>

<p><strong>注意</strong>：二叉树的高度是指从根节点到任何其他节点的 <strong>最长路径</strong> 的长度。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1;</strong></p>

<pre>
<b>输入：</b>root = [1,2,3,null,null,4,5]
<b>输出：</b>2
<strong>解释：给</strong>定树如下图所示。每个叶子节点的左子节点是它左边的叶子节点（用蓝色边表示）。每个叶子节点的右子节点是它右边的叶子节点（用红色边表示）。我们可以看出，该图的高度为2。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/12/1.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 200px; height: 200px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>root = [1,2]
<b>输出：</b>1
<b>解释：</b>给定树如下图所示。只有一个叶子节点，所以它没有左子节点或右子节点。我们可以看出，该图的高度为 1。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/12/2.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 95px; height: 122px;" /></p>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>root = [1,2,3,null,null,4,null,5,6]
<b>输出：</b>3
<strong>解释：</strong>给定树如下图所示。每个叶子节点的左子节点是它左边的叶子节点（用蓝色边表示）。每个叶子节点的右子节点是它右边的叶子节点（用红色边表示）。我们可以看出，该图的高度为3。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/12/3.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 200px; height: 280px;" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>n 为树中节点的数量</code></li>
	<li><code>2 &lt;= n &lt;= 10<sup>4</sup></code></li>
	<li><code>1 &lt;= node.val &lt;= n</code></li>
	<li>输入保证每个 <code>node.val</code> 的值是唯一的。</li>
</ul>
