## [2727.判断对象是否为空](https://leetcode.cn/problems/is-object-empty/)
<p>给定一个对象或数组，判断它是否为空。</p>

<ul>
	<li>一个空对象不包含任何键值对。</li>
	<li>一个空数组不包含任何元素。</li>
</ul>

<p>你可以假设对象或数组是通过 <code>JSON.parse</code> 解析得到的。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>obj = {"x": 5, "y": 42}
<b>输出：</b>false
<b>解释：</b>The object has 2 key-value pairs so it is not empty.
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>obj = {}
<b>输出：</b>true
<b>解释：</b>The object doesn't have any key-value pairs so it is empty.
</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>obj = [null, false, 0]
<b>输出：</b>false
<b>解释：</b>The array has 3 elements so it is not empty.
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>&nbsp;<code>2 &lt;= JSON.stringify(obj).length &lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>
<strong>你可以在 O(1) 时间复杂度内解决这个问题吗？</strong>