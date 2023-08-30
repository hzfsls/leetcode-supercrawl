## [2703.返回传递的参数的长度]
请你编写一个函数 <code>argumentsLength</code>，返回传递给该函数的参数数量。
<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>argsArr = [5]
<b>输出：</b>1
<strong>解释：</strong>
argumentsLength(5); // 1

只传递了一个值给函数，因此它应返回 1。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>argsArr = [{}, null, "3"]
<b>输出：</b>3
<b>解释：</b>
argumentsLength({}, null, "3"); // 3

传递了三个值给函数，因此它应返回 3。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>argsArr 是一个有效的 JSON 数组</code></li>
	<li><code>0 &lt;= argsArr.length &lt;= 100</code></li>
</ul>