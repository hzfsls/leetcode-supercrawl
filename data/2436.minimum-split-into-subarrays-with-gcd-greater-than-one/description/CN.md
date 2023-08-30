## [2436.使子数组最大公约数大于一的最小分割数]
<p>给定一个由正整数组成的数组 <code>nums</code>。</p>

<p>将数组拆分为&nbsp;<strong>一个或多个&nbsp;</strong>不相连的子数组，如下所示:</p>

<ul>
	<li>数组中的每个元素都&nbsp;<strong>只属于一个&nbsp;</strong>子数组，并且</li>
	<li>每个子数组元素的 <strong>最大公约数</strong> 严格大于 <code>1</code>。</li>
</ul>

<p>返回<em>拆分后可获得的子数组的最小数目。</em></p>

<p><b>注意</b>:</p>

<ul>
	<li>子数组的 <strong>最大公约数&nbsp;</strong>是能将子数组中所有元素整除的最大正整数。</li>
	<li>
	<p data-group="1-1"><strong>子数组&nbsp;</strong>是数组的连续部分。</p>
	</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [12,6,3,14,8]
<strong>输出:</strong> 2
<strong>解释:</strong> 我们可以把数组分成子数组:[12,6,3] 和 [14,8]。
- 12、6、3 的最大公约数是 3，严格大于 1。
- 14 和 8 的最大公约数是 2，严格来说大于 1。
可以看出，如果不拆分数组将使最大公约数 = 1。
</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> nums = [4,12,6,14]
<strong>输出:</strong> 1
<strong>解释:</strong> 我们可以将数组拆分为一个子数组，即整个数组。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 2000</code></li>
	<li><code>2 &lt;= nums[i] &lt;= 10<sup>9</sup></code></li>
</ul>
