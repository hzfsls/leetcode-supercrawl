## [2822.对象反转](https://leetcode.cn/problems/inversion-of-object/)
<p>给定一个对象 <code>obj</code>，返回一个反转的对象 <code>invertedObj</code>。</p>

<p><code>invertedObj</code> 应该以 <code>obj</code> 的键作为值，以 <code>obj</code> 的值作为键。题目保证 <code>obj</code> 中的值仅为字符串。该函数应该处理重复值，也就是说，如果在 <code>obj</code> 中有多个具有相同值的键，那么 <code>invertedObj</code> 应该将该值映射到一个包含所有相应键的数组中。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>obj = {"a": "1", "b": "2", "c": "3", "d": "4"}
<b>输出：</b>invertedObj = {"1": "a", "2": "b", "3": "c", "4": "d"}
<b>解释：</b>The keys from obj become the values in invertedObj, and the values from obj become the keys in invertedObj.
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>obj = {"a": "1", "b": "2", "c": "2", "d": "4"}
<b>输出：</b>invertedObj = {"1": "a", "2": ["b", "c"], "4": "d"}
<b>解释：</b>There are two keys in&nbsp;obj&nbsp;with the same value, the&nbsp;invertedObj mapped the value to an array containing all corresponding keys.</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>obj = ["1", "2", "3", "4"]
<b>输出：</b>invertedObj = {"1": "0", "2": "1", "3": "2", "4": "3"}
<b>解释：</b>Arrays are also objects therefore array has changed to an object and the keys (indices) from obj become the values in invertedObj, and the values from obj become the keys in invertedObj.
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>obj</code> 是一个有效的 JSON 对象</li>
	<li><code>typeof obj[key] === "string"</code></li>
	<li><code>2 &lt;= JSON.stringify(obj).length &lt;= 10**5</code></li>
</ul>
