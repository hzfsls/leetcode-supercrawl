## [2198.单因数三元组]
<p>给定一个下标从 <strong>0</strong> 开始的正整数数组 <code>nums</code>。由三个&nbsp;<strong>不同&nbsp;</strong>索引&nbsp;<code>(i, j, k)</code> 组成的三元组，如果 <code>nums[i] + nums[j] + nums[k]</code> 能被 <code>nums[i]</code>、<code>nums[j]</code>&nbsp;或 <code>nums[k]</code> 中的&nbsp;<strong>一个&nbsp;</strong>整除，则称为 <code>nums</code> 的&nbsp;<strong>单因数三元组</strong>。</p>

<p>返回 <em><code>nums</code> 的单因数三元组</em>。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [4,6,7,3,2]
<strong>输出:</strong> 12
<strong>解释:
</strong>三元组索引 (0, 3, 4), (0, 4, 3), (3, 0, 4), (3, 4, 0), (4, 0, 3), 和 (4, 3, 0) 的值为 [4, 3, 2] (或者说排列为 [4, 3, 2]).
4 + 3 + 2 = 9 只能被 3 整除，所以所有的三元组都是单因数三元组。
三元组索引 (0, 2, 3), (0, 3, 2), (2, 0, 3), (2, 3, 0), (3, 0, 2), 和 (3, 2, 0) 的值为 [4, 7, 3]  (或者说排列为 [4, 7, 3]).
4 + 7 + 3 = 14 只能被 7 整除，所以所有的三元组都是单因数三元组。
一共有 12 个单因数三元组。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,2,2]
<strong>输出:</strong> 6
<strong>提示:</strong>
三元组索引 (0, 1, 2), (0, 2, 1), (1, 0, 2), (1, 2, 0), (2, 0, 1), 和 (2, 1, 0) 的值为 [1, 2, 2] (或者说排列为 [1, 2, 2]).
1 + 2 + 2 = 5 只能被 1 整除，所以所有的三元组都是单因数三元组。
一共有6个单因数三元组。</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,1,1]
<strong>输出:</strong> 0
<strong>提示:</strong>
没有单因数三元组。
注意 (0, 1, 2) 不是单因数三元组。 因为 nums[0] + nums[1] + nums[2] = 3，3 可以被 nums[0], nums[1], nums[2] 整除。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>3 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 100</code></li>
</ul>
