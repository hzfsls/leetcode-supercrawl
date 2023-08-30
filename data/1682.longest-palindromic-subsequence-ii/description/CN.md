## [1682.最长回文子序列 II]
<p>字符串&nbsp;<code>s</code>&nbsp;的某个子序列符合下列条件时，称为“<strong>好的回文子序列</strong>”：</p>

<ul>
	<li>它是&nbsp;<code>s</code>&nbsp;的子序列。</li>
	<li>它是回文序列（反转后与原序列相等）。</li>
	<li>长度为<strong>偶数</strong>。</li>
	<li>除中间的两个字符外，其余任意两个连续字符不相等。</li>
</ul>

<p>例如，若&nbsp;<code>s = "abcabcabb"</code>，则&nbsp;<code>"abba"</code>&nbsp;可称为“好的回文子序列”，而&nbsp;<code>"bcb"</code>&nbsp;（长度不是偶数）和&nbsp;<code>"bbbb"</code>&nbsp;（含有相等的连续字符）不能称为“好的回文子序列”。</p>

<p>给定一个字符串&nbsp;<code>s</code>， 返回<em>&nbsp;</em><code>s</code>&nbsp;的<strong>最长“好的回文子序列”</strong>的<strong>长度</strong>。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> s = "bbabab"
<strong>输出:</strong> 4
<strong>解释:</strong> s 的最长“好的回文子序列”是 "baab"。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> s = "dcbccacdb"
<strong>输出:</strong> 4
<strong>解释:</strong> s 的最长“好的回文子序列”是 "dccd"。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 250</code></li>
	<li><code>s</code>&nbsp;包含小写英文字母。</li>
</ul>
