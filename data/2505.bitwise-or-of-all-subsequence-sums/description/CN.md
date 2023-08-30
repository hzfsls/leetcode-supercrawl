## [2505.所有子序列和的按位或]
<p>给你一个整数数组 <code>nums</code> ，返回对数组中所有可能的 <strong>子序列</strong> 之和进行按位 <strong>或</strong> 运算后得到的值。</p>

<p>数组的<strong> 子序列 </strong>是从数组中删除零个或多个元素且不改变剩余元素的顺序得到的序列。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<b>输入：</b>nums = [2,1,0,3]
<b>输出：</b>7
<strong>解释：</strong>所有可能的子序列的和包括：0、1、2、3、4、5、6 。
由于 0 OR 1 OR 2 OR 3 OR 4 OR 5 OR 6 = 7，所以返回 7 。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<b>输入：</b>nums = [0,0,0]
<b>输出：</b>0
<strong>解释：</strong>0 是唯一可能的子序列的和，所以返回 0 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>0 &lt;= nums[i] &lt;= 10<sup>9</sup></code></li>
</ul>
