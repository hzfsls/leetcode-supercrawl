## [2613.美数对](https://leetcode.cn/problems/beautiful-pairs/)
<p>给定两个长度相同的 <strong>下标从 0 开始</strong> 的整数数组 <code>nums1</code> 和 <code>nums2</code>&nbsp;，如果 <code>|nums1[i] - nums1[j]| + |nums2[i] - nums2[j]|</code> 在所有可能的下标对中是最小的，其中 <code>i &lt; j</code> ，则称下标对 <code>(i,j)</code> 为 <strong>美</strong> 数对，</p>

<p>返回美数对。如果有多个美数对，则返回字典序最小的美数对。</p>

<p>注意：</p>

<ul>
	<li><code>|x|</code> 表示 <code>x</code> 的绝对值。</li>
	<li>一对索引 <code>(i1, j1)</code> 在字典序意义下小于 <code>(i2, j2)</code> ，当且仅当 <code>i1 &lt; i2</code> 或 <code>i1 == i2</code> 且 <code>j1 &lt; j2</code>&nbsp;。</li>
</ul>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<b>输入：</b>nums1 = [1,2,3,2,4], nums2 = [2,3,1,2,3]
<b>输出：</b>[0,3]
<b>解释：</b>取下标为 0 和下标为 3 的数对，计算出 |nums1[0]-nums1[3]| + |nums2[0]-nums2[3]| 的值为 1 ，这是我们能够得到的最小值。
</pre>

<p><strong class="example">示例 2 ：</strong></p>

<pre>
<b>输入：</b>nums1 = [1,2,4,3,2,5], nums2 = [1,4,2,3,5,1]
<b>输出：</b>[1,4]
<b>解释：</b>取下标为 1 和下标为 4 的数对，计算出 |nums1[1]-nums1[4]| + |nums2[1]-nums2[4]| 的值为 1，这是我们可以达到的最小值。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= nums1.length, nums2.length &lt;= 10<sup>5</sup></code></li>
	<li><code>nums1.length == nums2.length</code></li>
	<li><code>0 &lt;= nums1<sub>i</sub><sub>&nbsp;</sub>&lt;= nums1.length</code></li>
	<li><code>0 &lt;= nums2<sub>i</sub>&nbsp;&lt;= nums2.length</code></li>
</ul>
