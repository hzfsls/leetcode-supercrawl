## [549.二叉树中最长的连续序列]
<p>给定二叉树的根&nbsp;<code>root</code>&nbsp;，返回树中<strong>最长连续路径</strong>的长度。<br />
<strong>连续路径</strong>是路径中相邻节点的值相差 <code>1</code> 的路径。此路径可以是增加或减少。</p>

<ul>
	<li>例如，&nbsp;<code>[1,2,3,4]</code> 和 <code>[4,3,2,1]</code> 都被认为有效，但路径 <code>[1,2,4,3]</code> 无效。</li>
</ul>

<p>另一方面，路径可以是子-父-子顺序，不一定是父子顺序。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/03/14/consec2-1-tree.jpg" /></p>

<pre>
<strong>输入: </strong>root = [1,2,3]
<strong>输出:</strong> 2
<strong>解释:</strong> 最长的连续路径是 [1, 2] 或者 [2, 1]。
</pre>

<p>&nbsp;</p>

<p><strong>示例 2:</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/03/14/consec2-2-tree.jpg" /></p>

<pre>
<strong>输入: </strong>root = [2,1,3]
<strong>输出:</strong> 3
<strong>解释:</strong> 最长的连续路径是 [1, 2, 3] 或者 [3, 2, 1]。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>树上所有节点的值都在&nbsp;<code>[1, 3 * 10<sup>4</sup>]</code>&nbsp;范围内。</li>
	<li><code>-3 * 10<sup>4</sup>&nbsp;&lt;= Node.val &lt;= 3 * 10<sup>4</sup></code></li>
</ul>
