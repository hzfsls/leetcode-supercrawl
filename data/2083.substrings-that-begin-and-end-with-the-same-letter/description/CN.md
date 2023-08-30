## [2083.求以相同字母开头和结尾的子串总数]
<p>给你一个仅由小写英文字母组成的，&nbsp; 下标从 <code>0</code> 开始的字符串 <code>s</code> 。返回 <code>s</code> 中以相同字符开头和结尾的子字符串总数。</p>

<p>子字符串是字符串中连续的非空字符序列。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = "abcba"
<strong>输出：</strong>7
<strong>解释：</strong>
以相同字母开头和结尾的长度为 1 的子串是："a"、"b"、"c"、"b" 和 "a" 。
以相同字母开头和结尾的长度为 3 的子串是："bcb" 。
以相同字母开头和结尾的长度为 5 的子串是："abcba" 。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = "abacad"
<strong>输出：</strong>9
<strong>解释：</strong>
以相同字母开头和结尾的长度为 1 的子串是："a"、"b"、"a"、"c"、"a" 和 "d" 。
以相同字母开头和结尾的长度为 3 的子串是："aba" 和 "aca" 。
以相同字母开头和结尾的长度为 5 的子串是："abaca" 。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = "a"
<strong>输出：</strong>1
<strong>解释：</strong>
只有一个，以相同字母开头和结尾的长度为 1 的子串是："a"。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 10<sup>5</sup></code></li>
	<li><code>s</code> 仅包含小写英文字母。</li>
</ul>