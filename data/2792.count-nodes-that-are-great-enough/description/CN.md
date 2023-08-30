## [2792.计算满足条件的节点数]
<p>给定一棵二叉树的根节点 <code>root</code> 和一个整数 <code>k</code> 。如果一个节点满足以下条件，则称其为 <strong>足够大</strong>&nbsp;：</p>

<ul>
	<li>它的子树中 <strong>至少</strong> 有 <code>k</code> 个节点。</li>
	<li>它的值 <strong>大于</strong> 其子树中 <strong>至少</strong> <code>k</code> 个节点的值。</li>
</ul>

<p>返回满足条件的节点数。</p>

<p>如果 <code>u == v</code> 或者 <code>v</code> 是 <code>u</code> 的祖先，则节点 <code>u</code> 在节点 <code>v</code> 的 <strong>子树</strong> 中。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>root = [7,6,5,4,3,2,1], k = 2
<b>输出：</b>3
<b>解释：</b>节点编号从 1 到 7。 
节点 1 的子树中的值：{1,2,3,4,5,6,7}。由于节点的值等于 7，有 6 个节点的值小于它的值，因此它是“足够大”的。 
节点 2 的子树中的值：{3,4,6}。由于节点的值等于 6，有 2 个节点的值小于它的值，因此它是“足够大”的。 
节点 3 的子树中的值：{1,2,5}。由于节点的值等于 5，有 2 个节点的值小于它的值，因此它是“足够大”的。 
其他节点不满足条件。 
参考下面的图片可以帮助你得到更好的理解。</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/25/1.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 300px; height: 167px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>root = [1,2,3], k = 1
<b>输出：</b>0
<strong>解释：</strong>节点编号从 1 到 3。 
节点 1 的子树中的值：{1,2,3}。由于节点的值等于 1，没有节点的值小于它的值，因此它不是“足够大”的。 
节点 2 的子树中的值：{2}。由于节点的值等于 2，没有节点的值小于它的值，因此它不是“足够大”的。 
节点 3 的子树中的值：{3}。由于节点的值等于 3，没有节点的值小于它的值，因此它不是“足够大”的。 
参考下面的图片可以帮助你得到更好的理解。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/25/2.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 123px; height: 101px;" /></p>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>root = [3,2,2], k = 2
<b>输出：</b>1
<strong>解释：</strong>节点编号从 1 到 3。 
节点 1 的子树中的值：{2,2,3}。
由于节点的值等于 3，有 2 个节点的值小于它的值，因此它是“足够大”的。 
节点 2 的子树中的值：{2}。由于节点的值等于 2，没有节点的值小于它的值，因此它不是“足够大”的。 
节点 3 的子树中的值：{2}。由于节点的值等于 2，没有节点的值小于它的值，因此它不是“足够大”的。 
参考下面的图片可以帮助你得到更好的理解。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/25/3.png" style="padding: 10px; background: rgb(255, 255, 255); border-radius: 0.5rem; width: 123px; height: 101px;" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>树中的节点数在范围&nbsp;<code>[1, 10<sup>4</sup>]</code> 内。<span style="display: none;">&nbsp;</span></li>
	<li><code>1 &lt;= Node.val &lt;= 10<sup>4</sup></code></li>
	<li><code>1 &lt;= k &lt;= 10</code></li>
</ul>
