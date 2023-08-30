## [2599.使前缀和数组非负]
<p>给定一个 <strong>下标从0开始</strong> 的整数数组 <code>nums</code> 。你可以任意多次执行以下操作：</p>

<ul>
	<li>从 <code>nums</code> 中选择任意一个元素，并将其放到 <code>nums</code> 的末尾。</li>
</ul>

<p><code>nums</code> 的前缀和数组是一个与 <code>nums</code> 长度相同的数组 <code>prefix</code> ，其中 <code>prefix[i]</code> 是所有整数 <code>nums[j]</code>（其中 <code>j</code> 在包括区间 <code>[0，i]</code> 内）的总和。</p>

<p>返回使前缀和数组不包含负整数的最小操作次数。测试用例的生成方式保证始终可以使前缀和数组非负。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<b>输入：</b>nums = [2,3,-5,4]
<b>输出：</b>0
<b>解释：</b>我们不需要执行任何操作。
给定数组为 [2, 3, -5, 4]，它的前缀和数组是 [2, 5, 0, 4]。
</pre>

<p><strong class="example">示例 2 ：</strong></p>

<pre>
<b>输入：</b>nums = [3,-5,-2,6]
<b>输出：</b>1
<b>解释：</b>我们可以对索引为1的元素执行一次操作。
操作后的数组为 [3, -2, 6, -5]，它的前缀和数组是 [3, 1, 7, 2]。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>-10<sup>9</sup> &lt;= nums[i] &lt;= 10<sup>9</sup></code></li>
</ul>
