## [2495.乘积为偶数的子数组数](https://leetcode.cn/problems/number-of-subarrays-having-even-product/)
<p>给定一个整数数组 <code>nums</code>，返回<em>具有偶数乘积的 </em><code>nums</code><em> 子数组的数目</em>。</p>

<p><strong>子数组&nbsp;</strong>是数组中连续的非空元素序列。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [9,6,7,13]
<strong>输出:</strong> 6
<strong>解释:</strong> 有6个子数组的乘积是偶数:
- nums[0..1] = 9 * 6 = 54.
- nums[0..2] = 9 * 6 * 7 = 378.
- nums[0..3] = 9 * 6 * 7 * 13 = 4914.
- nums[1..1] = 6.
- nums[1..2] = 6 * 7 = 42.
- nums[1..3] = 6 * 7 * 13 = 546.
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [7,3,5]
<strong>输出:</strong> 0
<strong>解释:</strong> 没有乘积是偶数的子数组
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>
