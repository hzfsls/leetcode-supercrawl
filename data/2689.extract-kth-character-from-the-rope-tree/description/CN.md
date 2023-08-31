## [2689.从 Rope 树中提取第 K 个字符](https://leetcode.cn/problems/extract-kth-character-from-the-rope-tree/)
<p>给定一个二叉树的根节点 <code>root</code> 和整数 <code>k</code>。除了左右孩子之外，该树的每个节点还有另外两个属性：一个仅包含小写英文字母（可能为空）的 <strong>字符串</strong> <code>node.val</code> 和一个非负整数 <code>node.len</code>。这棵树中有两种类型的节点：</p>

<ul>
	<li><strong>叶子节点</strong>：这些节点没有子节点，<code>node.len = 0</code>，<code>node.val</code> 是一个 <strong>非空</strong> 字符串。</li>
	<li><strong>内部节点</strong>：这些节点至少有一个子节点（最多两个子节点），<code>node.len &gt; 0</code>，<code>node.val</code> 是一个 <strong>空</strong> 字符串。</li>
</ul>

<p>上述描述的树被称为 Rope 二叉树。现在我们用以下递归方式定义 <code>S[node]</code>：</p>

<ul>
	<li>如果 <code>node</code> 是一个叶子节点，则 <code>S[node] = node.val</code>，</li>
	<li>否则，如果 <code>node</code> 是一个内部节点，则 <code>S[node] = concat(S[node.left], S[node.right])</code>，且 <code>S[node].length = node.len</code>。</li>
</ul>

<p>返回字符串 <code>S[root]</code> 的第 <code>k</code> 个字符。</p>

<p><strong>注意</strong>：如果 <code>s</code> 和 <code>p</code> 是两个字符串，则 <code>concat(s, p)</code> 是将字符串 <code>p</code> 连接到 <code>s</code> 后面的字符串。例如，<code>concat("ab", "zz") = "abzz"</code>。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>root = [10,4,"abcpoe","g","rta"], k = 6
<b>输出：</b>"b"
<b>解释：</b>在下面的图片中，我们在内部节点上放置一个表示 <code>node.len</code> 的整数，在叶子节点上放置一个表示 <code>node.val</code> 的字符串。 你可以看到，<code>S[root] = concat(concat("g", "rta"), "abcpoe") = "grtaabcpoe"</code>。因此，<code>S[root][5]</code>，表示它的第6个字符，等于 "b"。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/14/example1.png" style="width: 300px; height: 213px; margin-left: 280px; margin-right: 280px;" /></p>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>root = [12,6,6,"abc","efg","hij","klm"], k = 3
<b>输出：</b>"c"
<b>解释：</b>在下面的图片中，我们在内部节点上放置一个表示 <code>node.len</code> 的整数，在叶子节点上放置一个表示 <code>node.val</code> 的字符串。 你可以看到，<code>S[root] = concat(concat("abc", "efg"), concat("hij", "klm")) = "abcefghijklm"</code>。因此，<code>S[root][2]</code>，表示它的第3个字符，等于 "c"。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/14/example2.png" style="width: 400px; height: 232px; margin-left: 255px; margin-right: 255px;" /></p>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>root = ["ropetree"], k = 8
<b>输出：</b>"e"
<b>解释：</b>在下面的图片中，我们在内部节点上放置一个表示 <code>node.len</code> 的整数，在叶子节点上放置一个表示 <code>node.val</code> 的字符串。 你可以看到，<code>S[root] = "ropetree"</code>。因此，<code>S[root][7]</code>，表示它的第8个字符，等于 "e"。
</pre>

<p><img alt="" src="https://assets.leetcode.com/uploads/2023/05/14/example3.png" style="width: 80px; height: 78px; margin-left: 400px; margin-right: 400px;" /></p>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>这棵树的节点数量在区间&nbsp;<code>[1, 10<sup>3</sup>]</code></li>
	<li><code>node.val</code> 仅包含小写英文字母</li>
	<li><code>0 &lt;= node.val.length &lt;= 50</code></li>
	<li><code>0 &lt;= node.len &lt;= 10<sup>4</sup></code></li>
	<li>对于叶子节点， <code>node.len = 0</code> 且&nbsp;<code>node.val</code> 是非空的</li>
	<li>对于内部节点， <code>node.len &gt; 0 </code>&nbsp;且&nbsp;<code>node.val</code> 为空</li>
	<li><code>1 &lt;= k &lt;= S[root].length</code></li>
</ul>
