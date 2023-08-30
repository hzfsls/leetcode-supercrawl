## [2759.将 JSON 字符串转换为对象]
<p>给定一个字符串 <code>str</code> ，返回 JSON 解析后的 <code>parsedStr</code> 。你可以假设 <code>str</code> 是一个有效的 JSON 字符串，因此它只包含字符串、数字、数组、对象、布尔值和 null。<code>str</code> 不会包含不可见字符和转义字符。JSON 中的字符串值只包含字母数字字符。</p>

<p>请在不使用内置的 <code>JSON.parse</code> 方法的情况下解决此问题。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>str = '{"a":2,"b":[1,2,3]}'
<b>输出：</b>{"a":2,"b":[1,2,3]}
<b>解释：</b>返回由 JSON 字符串表示的对象。</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>str = 'true'
<b>输出：</b>true
<b>解释：</b>原始类型是有效的 JSON。</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>str = '[1,5,"false",{"a":2}]'
<b>输出：</b>[1,5,"false",{"a":2}]
<b>解释：</b>返回由 JSON 字符串表示的数组。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>str 是一个有效的 JSON 字符串</code></li>
	<li><code>1 &lt;= str.length &lt;= 10<sup>5</sup></code></li>
</ul>
