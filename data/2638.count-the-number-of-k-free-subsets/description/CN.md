## [2638.统计 K-Free 子集的总数]
<p>给定一个包含 <strong>无重复</strong> 元素的整数数组 <code>nums</code> 和一个整数 <code>k</code> 。</p>

<p>如果一个子集中 <strong>不</strong> 存在两个差的绝对值等于 <code>k</code> 的元素，则称其为 <strong>k-Free</strong> 子集。注意，空集是一个 <strong>k-Free</strong> 子集。</p>

<p>返回 <code>nums</code> 中 <strong>k-Free</strong> 子集的数量。</p>

<p>一个数组的 <strong>子集</strong> 是该数组中的元素的选择（可能为零个）。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<b>输入：</b>nums = [5,4,6], k = 1
<b>输出：</b>5
<b>解释：</b>有 5 个合法子集：{}, {5}, {4}, {6} 和 {4, 6} 。
</pre>

<p><strong class="example">示例 2 ：</strong></p>

<pre>
<b>输入：</b>nums = [2,3,5,8], k = 5
<b>输出：</b>12
<b>解释：</b>有12个合法子集：{}, {2}, {3}, {5}, {8}, {2, 3}, {2, 3, 5}, {2, 5}, {2, 5, 8}, {2, 8}, {3, 5} 和 {5, 8} 。
</pre>

<p><strong class="example">示例 3 ：</strong></p>

<pre>
<b>输入：</b>nums = [10,5,9,11], k = 20
<b>输出：</b>16
<b>解释：</b>所有的子集都是有效的。由于子集的总数为 24 = 16，因此答案为 16 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 50</code></li>
	<li><code>1 &lt;= nums[i] &lt;= 1000</code></li>
	<li><code>1 &lt;= k &lt;= 1000</code></li>
</ul>
