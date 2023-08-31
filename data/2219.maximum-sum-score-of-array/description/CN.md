## [2219.数组的最大总分](https://leetcode.cn/problems/maximum-sum-score-of-array/)
<p>给你一个下标从 <strong>0</strong> 开始的整数数组 <code>nums</code> ，数组长度为 <code>n</code> 。</p>

<p><code>nums</code> 在下标 <code>i</code> （<code>0 &lt;= i &lt; n</code>）处的 <strong>总分</strong> 等于下面两个分数中的 <strong>最大值</strong> ：</p>

<ul>
	<li><code>nums</code><strong> 前</strong> <code>i + 1</code> 个元素的总和</li>
	<li><code>nums</code> <strong>后</strong> <code>n - i</code> 个元素的总和</li>
</ul>

<p>返回数组 <code>nums</code> 在任一下标处能取得的 <strong>最大总分</strong> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [4,3,-2,5]
<strong>输出：</strong>10
<strong>解释：</strong>
下标 0 处的最大总分是 max(4, 4 + 3 + -2 + 5) = max(4, 10) = 10 。
下标 1 处的最大总分是 max(4 + 3, 3 + -2 + 5) = max(7, 6) = 7 。
下标 2 处的最大总分是 max(4 + 3 + -2, -2 + 5) = max(5, 3) = 5 。
下标 3 处的最大总分是 max(4 + 3 + -2 + 5, 5) = max(10, 5) = 10 。
nums 可取得的最大总分是 10 。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [-3,-5]
<strong>输出：</strong>-3
<strong>解释：</strong>
下标 0 处的最大总分是 max(-3, -3 + -5) = max(-3, -8) = -3 。
下标 1 处的最大总分是 max(-3 + -5, -5) = max(-8, -5) = -5 。
nums 可取得的最大总分是 -3 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>n == nums.length</code></li>
	<li><code>1 &lt;= n &lt;= 10<sup>5</sup></code></li>
	<li><code>-10<sup>5</sup> &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>
