## [2823.深度对象筛选]
<p>给定一个对象 <code>obj</code> 和一个函数 <code>fn</code>，返回一个经过筛选的对象 <code>filteredObject</code>。</p>

<p>函数 <code>deepFilter</code> 应该在对象 <code>obj</code> 上执行深度筛选操作。深度筛选操作应该移除筛选函数 <code>fn</code> 输出为 <code>false</code> 的属性，以及在键被移除后仍然存在的任何空对象或数组。</p>

<p>如果深度筛选操作导致对象或数组为空，没有剩余属性，<code>deepFilter</code> 应该返回 <code>undefined</code>，表示在 <code>filteredObject</code> 中没有有效数据。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>
obj = [-5, -4, -3, -2, -1, 0, 1], 
fn = (x) =&gt; x &gt; 0
<strong>输出：</strong>[1]
<b>解释：</b>所有不大于 0 的值都被移除。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>
obj = {"a": 1, "b": "2", "c": 3, "d": "4", "e": 5, "f": 6, "g": {"a": 1}}, 
fn = (x) =&gt; typeof x === "string"
<b>输出：</b>{"b":"2","d":"4"}
<b>解释：</b>所有值不是字符串的键都被移除。在筛选过程中移除键后，任何导致为空的对象也被移除。</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>
obj = [-1, [-1, -1, 5, -1, 10], -1, [-1], [-5]], 
fn = (x) =&gt; x &gt; 0
<b>输出：</b>[[5,10]]
<b>解释：</b>所有不大于 0 的值都被移除。在筛选过程中移除值后，任何导致为空的数组也被移除。</pre>

<p><strong class="example">示例 4：</strong></p>

<pre>
<b>输入：</b>
obj = [[[[5]]]], 
fn = (x) =&gt; Array.isArray(x)
<b>输出：</b>undefined
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>fn</code> 是一个返回布尔值的函数</li>
	<li><code>obj</code> 是一个有效的 JSON 对象</li>
	<li><code>2 &lt;= JSON.stringify(obj).length &lt;= 10**5</code></li>
</ul>
