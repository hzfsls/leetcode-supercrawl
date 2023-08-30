## [2229.检查数组是否连贯]
<p>给你一个整数数组 <code>nums</code> ，如果 <code>nums</code> 是一个 <strong>连贯数组</strong> ，则返回 <code>true</code> ，否则返回 <code>false</code> 。</p>

<p><span style="">如果数组包含 </span><code>[x, x + n - 1]</code><span style=""> 范围内的所有数字（包括 <code>x</code> 和 <code>x + n - 1</code> ），则该数组为连贯数组；其中</span> <code>x</code><span style=""> 是数组中最小的数，</span><code>n</code> <span style="">是数组的长度。</span></p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,3,4,2]
<strong>输出：</strong>true
<strong>解释：</strong>
最小值是 1 ，数组长度为 4 。
范围 [x, x + n - 1] 中的所有值都出现在 nums 中：[1, 1 + 4 - 1] = [1, 4] = (1, 2, 3, 4) 。
因此，nums 是一个连贯数组。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,3]
<strong>输出：</strong>false
<strong>解释：
</strong>最小值是 1 ，数组长度为 2 。 
范围 [x, x + n - 1] 中的所有值没有都出现在 nums 中：[1, 1 + 2 - 1] = [1, 2] = (1, 2) 。 
因此，nums 不是一个连贯数组。 
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [3,5,4]
<strong>输出：</strong>true
<strong>解释：</strong>
最小值是 3 ，数组长度为 3 。
范围 [x, x + n - 1] 中的所有值都出现在 nums 中：[3, 3 + 3 - 1] = [3, 5] = (3，4，5) 。
因此，nums 是一个连贯数组。
</pre>

<p>&nbsp;</p>
<strong>提示：</strong>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>0 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>
