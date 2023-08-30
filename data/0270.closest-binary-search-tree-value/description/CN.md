## [270.最接近的二叉搜索树值]
给你二叉搜索树的根节点 <code>root</code> 和一个目标值 <code>target</code> ，请在该二叉搜索树中找到最接近目标值 <code>target</code> 的数值。如果有多个答案，返回最小的那个。
<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/03/12/closest1-1-tree.jpg" style="width: 292px; height: 302px;" />
<pre>
<strong>输入：</strong>root = [4,2,5,1,3], target = 3.714286
<strong>输出：</strong>4
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<strong>输入：</strong>root = [1], target = 4.428571
<strong>输出：</strong>1
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>树中节点的数目在范围 <code>[1, 10<sup>4</sup>]</code> 内</li>
	<li><code>0 &lt;= Node.val &lt;= 10<sup>9</sup></code></li>
	<li><code>-10<sup>9</sup> &lt;= target &lt;= 10<sup>9</sup></code></li>
</ul>
