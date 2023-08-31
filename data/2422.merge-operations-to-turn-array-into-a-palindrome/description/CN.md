## [2422.使用合并操作将数组转换为回文序列](https://leetcode.cn/problems/merge-operations-to-turn-array-into-a-palindrome/)
<p>给定一个由&nbsp;<strong>正整数&nbsp;</strong>组成的数组 <code>nums</code>。</p>

<p>可以对阵列执行如下操作，<strong>次数不限</strong>:</p>

<ul>
	<li>选择任意两个&nbsp;<strong>相邻&nbsp;</strong>的元素并用它们的&nbsp;<strong>和</strong>&nbsp;<strong>替换&nbsp;</strong>它们。

	<ul>
		<li>例如，如果 <code>nums = [1,<u>2,3</u>,1]</code>，则可以应用一个操作使其变为 <code>[1,5,1]</code>。</li>
	</ul>
	</li>
</ul>

<p>返回<em>将数组转换为&nbsp;<strong>回文序列&nbsp;</strong>所需的&nbsp;<strong>最小&nbsp;</strong>操作数。</em></p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [4,3,2,1,2,3,1]
<strong>输出:</strong> 2
<strong>解释:</strong> 我们可以通过以下 2 个操作将数组转换为回文:
- 在数组的第 4 和第 5 个元素上应用该操作，nums 将等于 [4,3,2,<strong><u>3</u></strong>,3,1].
- 在数组的第 5 和第 6 个元素上应用该操作，nums 将等于 [4,3,2,3,<strong><u>4</u></strong>].
数组 [4,3,2,3,4] 是一个回文序列。
可以证明，2 是所需的最小操作数。
</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,2,3,4]
<strong>输出:</strong> 3
<strong>解释:</strong> 我们在任意位置进行 3 次运算，最后得到数组 [10]，它是一个回文序列。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>6</sup></code></li>
</ul>
