## [2764.数组是否表示某二叉树的前序遍历]
<p>给定一个以 <strong>0</strong> 为起始索引的整数 <strong>二维数组</strong> <code>nodes</code> ，你的任务是确定给定的数组是否表示某个 <strong>二叉</strong> 树的 <strong>前序</strong> 遍历。</p>

<p>对于每个索引 <code>i</code> ，<code>nodes[i] = [id, parentId]</code> ，其中 <code>id</code> 是索引 <code>i</code> 处节点的 id，<code>parentId</code> 是其在树中的父节点 id（如果该节点没有父节点，则 <code>parentId = -1</code> ）。</p>

<p>如果给定的数组表示某个树的前序遍历，则返回 <code>true</code> ，否则返回 <code>false</code> 。</p>

<p><strong>注意</strong>：树的 <strong>前序</strong> 遍历是一种递归的遍历方式，它首先访问当前节点，然后对左子节点进行前序遍历，最后对右子节点进行前序遍历。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>nodes = [[0,-1],[1,0],[2,0],[3,2],[4,2]]
<b>输出：</b>true
<b>解释：</b>给定的 nodes 数组可以构成下面图片中的树。 
我们可以验证这是树的前序遍历，首先访问节点 0，然后对右子节点进行前序遍历，即 [1] ，然后对左子节点进行前序遍历，即 [2,3,4] 。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/04/1.png" style="padding: 10px; background: #fff; border-radius: .5rem; width: 250px; height: 251px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>nodes = [[0,-1],[1,0],[2,0],[3,1],[4,1]]
<b>输出：</b>false
<b>解释：</b>给定的 nodes 数组可以构成下面图片中的树。 
对于前序遍历，首先访问节点 0，然后对右子节点进行前序遍历，即 [1,3,4]，但是我们可以看到在给定的顺序中，2 位于 1 和 3 之间，因此它不是树的前序遍历。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/07/04/2.png" style="padding: 10px; background: #fff; border-radius: .5rem; width: 250px; height: 251px;" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nodes.length &lt;= 10<sup>5</sup></code></li>
	<li><code>nodes[i].length == 2</code></li>
	<li><code>0 &lt;= nodes[i][0] &lt;= 10<sup>5</sup></code></li>
	<li><code>-1 &lt;= nodes[i][1] &lt;= 10<sup>5</sup></code></li>
	<li>生成的输入保证 <code>nodes</code> 可以组成二叉树。</li>
</ul>
