## [2805.自定义间隔](https://leetcode.cn/problems/custom-interval/)
<p><strong>函数</strong>&nbsp;<code>customInterval</code></p>

<p>给定一个函数 <code>fn</code>、一个数字 <code>delay</code> 和一个数字 <code>period</code>，返回一个数字 <code>id</code>。<code>customInterval</code> 是一个函数，它应该根据公式 <code>delay + period * count</code> 在间隔中执行提供的函数 <code>fn</code>，公式中的 <code>count</code> 表示从初始值 0 开始执行间隔的次数。</p>

<p><strong>函数</strong> <code>customClearInterval</code></p>

<p>给定 <code>id</code>。<code>id</code> 是从函数 <code>customInterval</code> 返回的值。<code>customClearInterval</code> 应该停止在间隔中执行提供的函数 <code>fn</code>。</p>

<p>&nbsp;</p>

<p><b>示例 1：</b></p>

<pre>
<b>输入：</b>delay = 50, period = 20, stopTime = 225
<b>输出：</b>[50,120,210]
<b>解释：</b>
const t = performance.now()&nbsp;&nbsp;
const result = []
&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
const fn = () =&gt; {
    result.push(Math.floor(performance.now() - t))
}
const id = customInterval(fn, delay, period)
        
setTimeout(() =&gt; {
    customClearInterval(id)
}, 225)

50 + 20 * 0 = 50 // 50ms - 第一个函数调用
50 + 20&nbsp;* 1 = 70 // 50ms + 70ms = 120ms - 第二个函数调用
50 + 20 * 2 = 90 // 50ms + 70ms + 90ms = 210ms - 第三个函数调用
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>delay = 20, period = 20, stopTime = 150
<b>输出：</b>[20,60,120]
<b>解释：</b>
20 + 20 * 0 = 20 // 20ms - 第一个函数调用
20 + 20&nbsp;* 1 = 40 // 20ms + 40ms = 60ms - 第二个函数调用
20 + 20 * 2 = 60 // 20ms + 40ms + 60ms = 120ms - 第三个函数调用
</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>delay = 100, period = 200, stopTime = 500
<b>输出：</b>[100,400]
<b>解释：</b>
100 + 200 * 0 = 100 // 100ms - 第一个函数调用
100 + 200&nbsp;* 1 = 300 // 100ms + 300ms = 400ms - 第二个函数调用
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>20 &lt;= delay, period &lt;= 250</code></li>
	<li><code>20 &lt;= stopTime &lt;= 1000</code></li>
</ul>
