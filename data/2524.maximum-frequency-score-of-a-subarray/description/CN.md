## [2524.子数组的最大频率分数]
<p>给定一个整数数组 <code>nums</code> 和一个 <strong>正</strong> 整数 <code>k</code> 。</p>

<p>数组的 <strong>频率得分</strong> 是数组中 <strong>不同</strong> 值的 <strong>幂次</strong> 之和，并将和对&nbsp;<code>10<sup>9</sup>&nbsp;+ 7</code> <strong>取模</strong>。</p>

<p>例如，数组 <code>[5,4,5,7,4,4]</code> 的频率得分为 <code>(4<sup>3</sup>&nbsp;+ 5<sup>2</sup>&nbsp;+ 7<sup>1</sup>) modulo (10<sup>9</sup>&nbsp;+ 7) = 96</code> 。</p>

<p>返回 <code>nums</code> 中长度为 <code>k</code> 的 <strong>子数组</strong> 的 <strong>最大&nbsp;</strong>频率得分。你需要返回取模后的最大值，而不是实际值。</p>

<p><strong>子数组</strong>&nbsp;是一个数组的连续部分。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<b>输入：</b>nums = [1,1,1,2,1,2], k = 3
<b>输出：</b>5
<b>解释：</b>子数组 [2,1,2] 的频率分数等于 5。可以证明这是我们可以获得的最大频率分数。
</pre>

<p><strong class="example">示例 2 ：</strong></p>

<pre>
<b>输入：</b>nums = [1,1,1,1,1,1], k = 4
<b>输出：</b>1
<b>解释：</b>所有长度为 4 的子数组的频率得分都等于 1。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= k &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>6</sup></code></li>
</ul>
