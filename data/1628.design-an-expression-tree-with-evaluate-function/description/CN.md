## [1628.设计带解析函数的表达式树]
<p>给定一个算术表达式的后缀表示法的标记（token）&nbsp;<code>postfix</code>&nbsp;，构造并返回该表达式对应的二叉表达式树。</p>

<p><b>后缀</b>表示法是一种将操作数写在运算符之前的表示法。例如，表达式&nbsp;<code>4*(5-(2+7))</code>&nbsp;的后缀表示法表示为数组&nbsp;<code>postfix = ["4","5","7","2","+","-","*"]</code>&nbsp;。</p>

<p>抽象类&nbsp;<code>Node</code>&nbsp;需要用于实现二叉表达式树。我们将通过&nbsp;<code>evaluate</code>&nbsp;函数来测试返回的树是否能够解析树中的值。你不可以移除 <code>Node</code> 类，但你可以按需修改此类，也可以定义其他类来实现它。</p>

<p><a href="https://en.wikipedia.org/wiki/Binary_expression_tree"><strong>二叉表达式树</strong></a>是一种表达算术表达式的二叉树。二叉表达式树中的每一个节点都有零个或两个子节点。&nbsp;叶节点（有 0 个子节点的节点）表示操作数，非叶节点（有 2 个子节点的节点）表示运算符：&nbsp;<code>'+'</code>&nbsp;（加）、&nbsp;<code>'-'</code> （减）、&nbsp;<code>'*'</code> （乘）和&nbsp;<code>'/'</code> （除）。</p>

<p>我们保证任何子树对应值的绝对值不超过&nbsp;<code>10<sup>9</sup></code>&nbsp;，且所有操作都是有效的（即没有除以零的操作）</p>

<p><b>进阶：</b>&nbsp;你可以将表达式树设计得更模块化吗？例如，你的设计能够不修改现有的&nbsp;<code>evaluate</code>&nbsp;的实现就能支持更多的操作符吗？</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<p><strong><img alt="" src="https://assets.leetcode.com/uploads/2020/10/15/untitled-diagram.png" style="width: 242px; height: 241px;" /></strong></p>

<pre>
<b>输入：</b> s = ["3","4","+","2","*","7","/"]
<b>输出：</b> 2
<b>解释：</b> 此表达式可解析为上述二叉树，其对应表达式为 (<code>(3+4)*2)/7) = 14/7 = 2.</code>
</pre>

<p><strong>示例 2:</strong></p>

<p><strong><img alt="" src="https://assets.leetcode.com/uploads/2020/10/15/untitled-diagram2.png" style="width: 222px; height: 232px;" /></strong></p>

<pre>
<strong>输入:</strong> s = ["4","5","7","2","+","-","*"]
<strong>输出:</strong> -16
<strong>解释:</strong> 此表达式可解析为上述二叉树，其对应表达式为 4*(5-<code>(2+7)) = 4*(-4) = -16.</code>
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt; 100</code></li>
	<li><code>s.length</code>&nbsp;是奇数。</li>
	<li><code>s</code>&nbsp;包含数字和字符&nbsp;<code>'+'</code>&nbsp;、&nbsp;<code>'-'</code>&nbsp;、&nbsp;<code>'*'</code>&nbsp;以及&nbsp;<code>'/'</code>&nbsp;。</li>
	<li>如果&nbsp;<code>s[i]</code>&nbsp;是数，则对应的整数不超过&nbsp;<code>10<sup>5</sup></code>&nbsp;。</li>
	<li><code>s</code>&nbsp;保证是一个有效的表达式。</li>
	<li>结果值和所有过程值的绝对值均不超过&nbsp;<code>10<sup>9</sup></code>&nbsp;。</li>
	<li>保证表达式不包含除以零的操作。</li>
</ul>