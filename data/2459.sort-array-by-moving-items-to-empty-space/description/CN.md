## [2459.通过移动项目到空白区域来排序数组]
<p>给定一个大小为 <code>n</code> 的整数数组 <code>nums</code>，其中包含从 <code>0</code> 到 <code>n - 1</code>&nbsp;(<strong>包含边界</strong>) 的&nbsp;<strong>每个&nbsp;</strong>元素。从 <code>1</code> 到 <code>n - 1</code> 的每一个元素都代表一项目，元素 <code>0</code> 代表一个空白区域。</p>

<p>在一个操作中，您可以将&nbsp;<strong>任何&nbsp;</strong>项目移动到空白区域。如果所有项目的编号都是&nbsp;<strong>升序&nbsp;</strong>的，并且空格在数组的开头或结尾，则认为 <code>nums</code> 已排序。</p>

<p data-group="1-1">例如，如果 <code>n = 4</code>，则 <code>nums</code> 按以下条件排序:</p>

<ul>
	<li><code>nums = [0,1,2,3]</code>&nbsp;或</li>
	<li><code>nums = [1,2,3,0]</code></li>
</ul>

<p>...否则被认为是无序的。</p>

<p>返回<em>排序&nbsp;<code>nums</code> 所需的最小操作数。</em></p>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [4,2,0,3,1]
<strong>输出:</strong> 3
<strong>解释:</strong>
- 将项目 2 移动到空白区域。现在，nums =[4,0,2,3,1]。
- 将项目 1 移动到空白区域。现在，nums =[4,1,2,3,0]。
- 将项目 4 移动到空白区域。现在，nums =[0,1,2,3,4]。
可以证明，3 是所需的最小操作数。
</pre>

<p><strong class="example">示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,2,3,4,0]
<strong>输出:</strong> 0
<strong>解释:</strong> nums 已经排序了，所以返回 0。</pre>

<p><strong class="example">示例 3:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,0,2,4,3]
<strong>输出:</strong> 2
<strong>解释:</strong>
- 将项目 2 移动到空白区域。现在，nums =[1,2,0,4,3]。
- 将项目 3 移动到空白区域。现在，nums =[1,2,3,4,0]。
可以证明，2 是所需的最小操作数。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>n == nums.length</code></li>
	<li><code>2 &lt;= n &lt;= 10<sup>5</sup></code></li>
	<li><code>0 &lt;= nums[i] &lt; n</code></li>
	<li><code>nums</code> 的所有值都是&nbsp;<strong>唯一&nbsp;</strong>的。</li>
</ul>
