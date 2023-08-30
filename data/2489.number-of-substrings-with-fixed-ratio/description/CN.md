## [2489.固定比率的子字符串数]
<p>给定一个二进制字符串 <code>s</code>&nbsp;和两个整数 <code>num1</code> 和 <code>num2</code>。<code>num1</code> 和 <code>num2</code> 为互质。</p>

<p><strong>比率子串&nbsp;</strong>是 s 的子串，其中子串中 <code>0</code> 的数量与 <code>1</code>&nbsp;的数量之比正好是&nbsp;<code>num1 : num2</code>。</p>

<ul>
	<li>例如，如果 <code>num1 = 2</code>&nbsp;和 <code>num2 = 3</code>，那么 <code>"01011"</code>&nbsp;和 <code>"1110000111"</code>&nbsp;是比率子串，而 <code>"11000"</code>&nbsp;不是。</li>
</ul>

<p>返回 <em><code>s</code> 的&nbsp;<strong>非空&nbsp;</strong>比率子串的个数。</em></p>

<p><b>注意</b>:</p>

<ul>
	<li><strong>子串&nbsp;</strong>是字符串中连续的字符序列。</li>
	<li>如果 <code>gcd(x, y) == 1</code>，则 <code>x</code> 和 <code>y</code> 为&nbsp;<strong>互质</strong>，其中 <code>gcd(x, y)</code>&nbsp;为 <code>x</code>&nbsp;和 <code>y</code> 的最大公约数。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> s = "0110011", num1 = 1, num2 = 2
<strong>输出:</strong> 4
<strong>解释:</strong> 有 4 个非空的比率子串。
- 子字符串 s[0..2]: "<u>011</u>0011"。它包含一个 0 和两个 1。比例是 1:2。
- 子字符串 s[1..4]: "0<u>110</u>011"。它包含一个 0 和两个 1。比例是 1:2。
- 子字符串 s[4..6]: "0110<u>011</u>"。它包含一个 0 和两个 1。比例是 1:2。
- 子字符串 s[1..6]: "0<u>110011</u>"。它包含两个 0 和四个 1。比例是 2:4 == 1:2。
它可以显示没有更多的比率子串。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> s = "10101", num1 = 3, num2 = 1
<strong>输出:</strong> 0
<strong>解释:</strong> s 没有比率子串，返回 0。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= num1, num2 &lt;= s.length</code></li>
	<li><code>num1</code> 和&nbsp;<code>num2</code> 互质。</li>
</ul>
