## [255.验证前序遍历序列二叉搜索树]
<p>给定一个&nbsp;<b>无重复元素</b>&nbsp;的整数数组&nbsp;<code>preorder</code>&nbsp;，&nbsp;<em>如果它是以二叉搜索树的<strong>先序遍历</strong>排列</em><em>&nbsp;</em>，返回 <code>true</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/03/12/preorder-tree.jpg" /></p>

<pre>
<strong>输入: </strong>preorder = [5,2,1,3,6]
<strong>输出: </strong>true</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入: </strong>preorder = [5,2,6,1,3]
<strong>输出: </strong>false</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= preorder.length &lt;= 10<sup>4</sup></code></li>
	<li><code>1 &lt;= preorder[i] &lt;= 10<sup>4</sup></code></li>
	<li><code>preorder</code>&nbsp;中&nbsp;<strong>无重复元素</strong></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>您能否使用恒定的空间复杂度来完成此题？</p>
