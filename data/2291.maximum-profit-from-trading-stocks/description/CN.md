## [2291.最大股票收益](https://leetcode.cn/problems/maximum-profit-from-trading-stocks/)
<p>给你两个下标从 <strong>0</strong>&nbsp;开始的数组 <code>present</code> 和 <code>future</code> ，<code>present[i]</code> 和 <code>future[i]</code> 分别代表第 <code>i</code> 支股票现在和将来的价格。每支股票你最多购买 <strong>一次</strong> ，你的预算为 <code>budget</code> 。</p>

<p>求最大的收益。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>present = [5,4,6,2,3], future = [8,5,4,3,5], budget = 10
<strong>输出：</strong>6
<strong>解释：</strong>你可以选择购买第 0,3,4 支股票获得最大收益：6 。总开销为：5 + 2 + 3 = 10 , 总收益是: 8 + 3 + 5 - 10 = 6 。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>present = [2,2,5], future = [3,4,10], budget = 6
<strong>输出：</strong>5
<strong>解释：</strong>你可以选择购买第 2 支股票获得最大收益：5 。总开销为：5 , 总收益是: 10 - 5 = 5 。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>present = [3,3,12], future = [0,3,15], budget = 10
<strong>输出：</strong>0
<strong>解释：</strong>你无法购买唯一一支正收益股票 2 ，因此你的收益是 0 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>n == present.length == future.length</code></li>
	<li><code>1 &lt;= n &lt;= 1000</code></li>
	<li><code>0 &lt;= present[i], future[i] &lt;= 100</code></li>
	<li><code>0 &lt;= budget &lt;= 1000</code></li>
</ul>
