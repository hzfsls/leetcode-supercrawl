## [2464.有效分割中的最少子数组数目](https://leetcode.cn/problems/minimum-subarrays-in-a-valid-split/)
<p>给定一个整数数组 <code>nums</code>。</p>

<p>如果要将整数数组 <code>nums</code> 拆分为&nbsp;<strong>子数组&nbsp;</strong>后是&nbsp;<strong>有效的</strong>，则必须满足:</p>

<ul>
	<li>每个子数组的第一个和最后一个元素的最大公约数&nbsp;<strong>大于</strong> <code>1</code>，且</li>
	<li><code>nums</code> 的每个元素只属于一个子数组。</li>
</ul>

<p>返回 <code>nums</code>&nbsp;的&nbsp;<strong>有效&nbsp;</strong>子数组拆分中的&nbsp;<strong>最少&nbsp;</strong>子数组数目。如果不能进行有效的子数组拆分，则返回 <code>-1</code>。</p>

<p><b>注意</b>:</p>

<ul>
	<li>两个数的&nbsp;<strong>最大公约数&nbsp;</strong>是能整除两个数的最大正整数。</li>
	<li><strong>子数组&nbsp;</strong>是数组中连续的非空部分。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [2,6,3,4,3]
<strong>输出:</strong> 2
<strong>解释:</strong> 我们可以通过以下方式创建一个有效的分割: [2,6] | [3,4,3].
- 第一个子数组的起始元素是 2，结束元素是 6。它们的最大公约数是 2，大于 1。
- 第二个子数组的起始元素是 3，结束元素是 3。它们的最大公约数是 3，大于 1。
可以证明，2 是我们在有效分割中可以获得的最少子数组数。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [3,5]
<strong>输出:</strong> 2
<strong>解释:</strong> 我们可以通过以下方式创建一个有效的分割: [3] | [5].
- 第一个子数组的起始元素是 3，结束元素是 3。它们的最大公约数是 3，大于 1。
- 第二个子数组的起始元素是 5，结束元素是 5。它们的最大公约数是 5，大于 1。
可以证明，2 是我们在有效分割中可以获得的最少子数组数。
</pre>

<p><strong>示例&nbsp;3:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,2,1]
<strong>输出:</strong> -1
<strong>解释:</strong> 不可能创建有效的分割。</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 1000</code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>
