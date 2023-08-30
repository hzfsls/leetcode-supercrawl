## [2340.生成有效数组的最少交换次数]
<p>给定一个<strong>&nbsp;下标从 0 开始</strong>&nbsp;的整数数组 <code>nums</code>。</p>

<p><code>nums</code>&nbsp;上的&nbsp;<strong>相邻&nbsp;</strong>元素可以进行&nbsp;<strong>交换</strong>。</p>

<p data-group="1-1">一个&nbsp;<strong>有效&nbsp;</strong>的数组必须满足以下条件:</p>

<ul>
	<li>最大的元素 (如果有多个，则为最大元素中的任何一个) 位于数组中最右边的位置。</li>
	<li>最小的元素 (如果有多个，则为最小的任何一个元素) 位于数组的最左侧。</li>
</ul>

<p>返回<em>使 </em><code>nums</code><em> </em><em>成为有效数组所需的最少交换次数。</em></p>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [3,4,5,5,3,1]
<strong>输出:</strong> 6
<strong>解释:</strong> 进行以下交换:
- 交换 1:交换第 3 和第 4 个元素，然后 nums 是 [3,4,5,<u><strong>3</strong></u>,<u><strong>5</strong></u>,1].
- 交换 2:交换第 4 和第 5 个元素，然后 nums 是 [3,4,5,3,<u><strong>1</strong></u>,<u><strong>5</strong></u>].
- 交换 3:交换第 3 和第 4 个元素，然后 nums 是  [3,4,5,<u><strong>1</strong></u>,<u><strong>3</strong></u>,5].
- 交换 4:交换第 2 和第 3 个元素，然后 nums 是  [3,4,<u><strong>1</strong></u>,<u><strong>5</strong></u>,3,5].
- 交换 5:交换第 1 和第 2 个元素，然后 nums 是  [3,<u><strong>1</strong></u>,<u><strong>4</strong></u>,5,3,5].
- 交换 6:交换第 0 和第 1 个元素，然后 nums 是  [<u><strong>1</strong></u>,<u><strong>3</strong></u>,4,5,3,5].
可以证明，6 次交换是组成一个有效数组所需的最少交换次数。
</pre>
<strong class="example">示例 2:</strong>

<pre>
<strong>输入:</strong> nums = [9]
<strong>输出:</strong> 0
<strong>解释:</strong> 该数组已经有效，因此返回 0。</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>
