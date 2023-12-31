## [1902.给定二叉搜索树的插入顺序求深度](https://leetcode.cn/problems/depth-of-bst-given-insertion-order/)
<p>给定一个<strong>从 0 开始索引</strong>的整数类型数组 <code>order</code> ，其长度为 <code>n</code>，是从 <code>1</code> 到 <code>n</code> 的所有整数的一个排列，表示插入到一棵二叉搜索树的顺序。</p>

<p>二叉搜索树的定义如下：</p>

<ul>
	<li>一个节点的左子树只包含键值<strong>小于</strong>该节点键值的节点。</li>
	<li>一个节点的右子树只包含键值<strong>大于</strong>该节点键值的节点。</li>
	<li>左子树和右子树须均为二叉搜索树。</li>
</ul>

<p>该二叉搜索树的构造方式如下：</p>

<ul>
	<li><code>order[0]</code> 将成为该二叉搜索树的根。</li>
	<li>所有后续的元素均在维持二叉搜索树性质的前提下作为<strong>任何</strong>已存在节点的<strong>子节点</strong>插入。</li>
</ul>

<p>返回该二叉搜索树的<strong>深度</strong>。</p>

<p>一棵二叉树的<strong>深度</strong>是从根节点到最远叶节点的<strong>最长路径</strong>所经<strong>节点</strong>的个数。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/06/15/1.png" style="width: 624px; height: 154px;" />
<pre>
<strong>输入:</strong> order = [2,1,4,3]
<strong>输出:</strong> 3
<strong>解释: </strong>该二叉搜索树的深度为 3，路径为 2-&gt;4-&gt;3。
</pre>

<p><strong>示例 2:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/06/15/2.png" style="width: 624px; height: 146px;" />
<pre>
<strong>输入:</strong> order = [2,1,3,4]
<strong>输出:</strong> 3
<strong>解释: </strong>该二叉搜索树的深度为 3，路径为 2-&gt;3-&gt;4。
</pre>

<p><strong>示例 3:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/06/15/3.png" style="width: 624px; height: 225px;" />
<pre>
<strong>输入:</strong> order = [1,2,3,4]
<strong>输出:</strong> 4
<strong>解释: </strong>该二叉搜索树的深度为 4，路径为 1-&gt;2-&gt;3-&gt;4。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>n == order.length</code></li>
	<li><code>1 &lt;= n &lt;= 10<sup>5</sup></code></li>
	<li><code>order</code> 是从 <code>1</code> 到 <code>n</code> 的整数的一个排列。</li>
</ul>
