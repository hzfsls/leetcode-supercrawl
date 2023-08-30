## [2557.从一个范围内选择最多整数 II]
<p>给你一个整数数组 <code>banned</code> 和两个整数 <code>n</code> 和 <code>maxSum</code>&nbsp;。你需要按照以下规则选择一些整数：</p>

<ul>
	<li>被选择整数的范围是 <code>[1, n]</code> 。</li>
	<li>每个整数 <strong>至多</strong> 选择 <strong>一次</strong> 。</li>
	<li>被选择整数不能在数组 <code>banned</code> 中。</li>
	<li>被选择整数的和不超过 <code>maxSum</code> 。</li>
</ul>

<p>请你返回按照上述规则 <strong>最多</strong> 可以选择的整数数目。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<strong>输入：</strong>banned = [1,4,6], n = 6, maxSum = 4
<strong>输出：</strong>1
<strong>解释：</strong>你可以选择整数 3 。
3 在范围 [1, 6] 内，且不在 banned 中，所选整数的和为 3 ，也没有超过 maxSum 。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<strong>输入：</strong>banned = [4,3,5,6], n = 7, maxSum = 18
<strong>输出：</strong>3
<strong>解释：</strong>你可以选择整数 1, 2&nbsp;和 7 。
它们都在范围 [1, 7] 中，且都没出现在 banned 中，所选整数的和为 10 ，没有超过 maxSum 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= banned.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= banned[i] &lt;= n &lt;= 10<sup>9</sup></code></li>
	<li><code>1 &lt;= maxSum &lt;= 10<sup>15</sup></code></li>
</ul>
