## [2702.使数字变为非正数的最小操作次数](https://leetcode.cn/problems/minimum-operations-to-make-numbers-non-positive/)
<p>给定一个 <strong>下标从0开始</strong> 的整数数组 <code>nums</code>，以及两个整数 <code>x</code> 和 <code>y</code>。在每一次操作中，你需要选择一个满足条件 <code>0 &lt;= i &lt; nums.length</code> 的下标 <code>i</code>&nbsp;，并执行以下操作：</p>

<ul>
	<li>将 <code>nums[i]</code> 减去 <code>x</code>。</li>
	<li>将除了下标为 <code>i</code> 的位置外，其他位置的值都减去 <code>y</code>。</li>
</ul>

<p>返回使得 <code>nums</code> 中的所有整数都 <strong>小于等于零&nbsp;</strong>所需的最小操作次数。</p>

<p>&nbsp;</p>

<p><b>示例 1：</b></p>

<pre>
<b>输入：</b>nums = [3,4,1,7,6], x = 4, y = 2
<b>输出：</b>3
<b>解释：</b>你需要进行三次操作。其中一种最优操作序列如下：
操作 1: 选择 i = 3。 然后, nums = [1,2,-1,3,4]. 
操作 2: 选择 i = 3。 然后, nums = [-1,0,-3,-1,2].
操作 3: 选择 i = 4。 然后, nums = [-3,-2,-5,-3,-2].
现在，<code>nums</code> 中的所有数字都是非正数。因此，返回 3。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>nums = [1,2,1], x = 2, y = 1
<b>输出：</b>1
<b>解释：</b>我们可以在 <code>i = 1</code> 处执行一次操作，得到 <code>nums = [0,0,0]</code>。所有正数都被移除，因此返回 1。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>9</sup></code></li>
	<li><code>1 &lt;= y &lt; x &lt;= 10<sup>9</sup></code></li>
</ul>
