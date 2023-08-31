## [2393.严格递增的子数组个数](https://leetcode.cn/problems/count-strictly-increasing-subarrays/)
<p>给定一个由&nbsp;<strong>正整数&nbsp;</strong>组成的数组 <code>nums</code> 。</p>

<p>返回&nbsp;<em><strong>严格递增&nbsp;</strong>顺序的 </em><code>nums</code><em>&nbsp;<strong>子数组&nbsp;</strong>的数目。</em></p>

<p data-group="1-1"><strong>子数组&nbsp;</strong>是数组的一部分，且是&nbsp;<strong>连续 </strong>的。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,3,5,4,4,6]
<strong>输出:</strong> 10
<strong>解释:</strong> 严格递增的子数组如下:
- 长度为 1 的子数组: [1], [3], [5], [4], [4], [6]。
- 长度为 2 的子数组: [1,3], [3,5], [4,6]。
- 长度为 3 的子数组: [1,3,5]。
子数组的总数是 6 + 3 + 1 = 10。
</pre>

<p><strong class="example">示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,2,3,4,5]
<strong>输出:</strong> 15
<strong>解释:</strong> 每个子数组都严格递增。我们可以取 15 个子数组。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>6</sup></code></li>
</ul>
