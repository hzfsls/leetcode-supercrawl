## [2832.每个元素为最大值的最大范围]
<p>现给定一个由 <strong>不同</strong> 整数构成的 <strong>0</strong> 索引数组 <code>nums</code> 。</p>

<p>我们用以下方式定义与 <code>nums</code> 长度相同的 <strong>0</strong> 索引数组 <code>ans</code> ：</p>

<ul>
	<li><code>ans[i]</code> 是子数组 <code>nums[l..r]</code> 的 <strong>最大</strong> 长度，该子数组中的最大元素等于 <code>nums[i]</code> 。</li>
</ul>

<p>返回数组 <code>ans</code> 。</p>

<p><strong>注意</strong>，<strong>子数组</strong> 是数组的连续部分。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>nums = [1,5,4,3,6]
<b>输出：</b>[1,4,2,1,5]
<b>解释：</b>对于 nums[0]，最长的子数组，其中最大值为 1，是 nums[0..0]，所以 ans[0] = 1。 
对于 nums[1]，最长的子数组，是 nums[0..3]，其中最大值为 5，所以 ans[1] = 4。 
对于 nums[2]，最长的子数组，是 nums[2..3]，其中最大值为 4，所以 ans[2] = 2。 
对于 nums[3]，最长的子数组，是 nums[3..3]，其中最大值为 3，所以 ans[3] = 1。 
对于 nums[4]，最长的子数组，是 nums[0..4]，其中最大值为 6，所以 ans[4] = 5。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>nums = [1,2,3,4,5]
<b>输出：</b>[1,2,3,4,5]
<b>解释：</b>对于 nums[i]，最长的子数组，是 nums[0..i]，其中最大值与 nums[i] 相等，所以 ans[i] = i + 1。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
	<li>所有&nbsp;<code>nums</code> 中的元素都是不重复的。</li>
</ul>
