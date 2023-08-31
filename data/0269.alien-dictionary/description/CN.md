## [269.火星词典](https://leetcode.cn/problems/alien-dictionary/)
<p>现有一种使用英语字母的火星语言，这门语言的字母顺序对你来说是未知的。</p>

<p>给你一个来自这种外星语言字典的字符串列表 <code>words</code> ，<code>words</code> 中的字符串已经 <strong>按这门新语言的字母顺序进行了排序</strong> 。</p>

<p>如果这种说法是错误的，并且给出的 <code>words</code> 不能对应任何字母的顺序，则返回 <code>""</code> 。</p>

<p>否则，返回一个按新语言规则的&nbsp;<strong>字典递增顺序 </strong>排序的独特字符串。如果有多个解决方案，则返回其中 <strong>任意一个</strong> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>words = ["wrt","wrf","er","ett","rftt"]
<strong>输出：</strong>"wertf"
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>words = ["z","x"]
<strong>输出：</strong>"zx"
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>words = ["z","x","z"]
<strong>输出：</strong>""
<strong>解释：</strong>不存在合法字母顺序，因此返回 <code>"" 。</code>
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= words.length &lt;= 100</code></li>
	<li><code>1 &lt;= words[i].length &lt;= 100</code></li>
	<li><code>words[i]</code> 仅由小写英文字母组成</li>
</ul>
