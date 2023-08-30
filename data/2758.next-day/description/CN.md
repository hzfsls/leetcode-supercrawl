## [2758.下一天]
<p>请你编写一个有关日期对象的方法，使得任何日期对象都可以调用 <code>date.nextDay()</code> 方法，然后返回调用日期对象的下一天，格式为 YYYY-MM-DD 。</p>

<p>&nbsp;</p>

<p><b>示例 1：</b></p>

<pre>
<b>输入：</b>date = "2014-06-20"
<b>输出：</b>"2014-06-21"
<b>解释：</b>
const date = new Date("2014-06-20");
date.nextDay(); // "2014-06-21"
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>date = "2017-10-31"
<strong>输出：</strong>"2017-11-01"
<b>解释：</b>日期 2017-10-31 的下一天是 2017-11-01.
</pre>

<p>&nbsp;</p>

<p><strong>Constraints:</strong></p>

<ul>
	<li><code>new Date(date) 是一个有效的日期对象</code></li>
</ul>
