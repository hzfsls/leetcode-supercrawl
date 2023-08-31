## [2782.唯一类别的数量](https://leetcode.cn/problems/number-of-unique-categories/)
<p>现给定一个整数 <code>n</code> 和一个 <code>CategoryHandler</code> 类的对象 <code>categoryHandler</code> 。</p>

<p>有 <code>n</code> 个元素，编号从 <code>0</code> 到 <code>n - 1</code>。每个元素都有一个类别，你的任务是找出唯一类别的数量。</p>

<p><code>CategoryHandler</code> 类包含以下方法，可能对你有帮助：</p>

<ul>
	<li><code>boolean haveSameCategory(integer a, integer b)</code>：如果 <code>a</code> 和 <code>b</code> 属于相同的类别，则返回 <code>true</code>，否则返回 <code>false</code>。同时，如果 <code>a</code> 或 <code>b</code> 不是有效的数字（即大于等于 <code>n</code> 或小于 <code>0</code>），它也会返回 <code>false</code>。</li>
</ul>

<p>返回唯一类别的数量。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>n = 6, catagoryHandler = [1,1,2,2,3,3]
<strong>输出：</strong>3
<b>解释：</b>这个示例中有 6 个元素。前两个元素属于类别 1，接下来两个属于类别 2，最后两个元素属于类别 3。所以有 3 个唯一类别。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>n = 5, catagoryHandler = [1,2,3,4,5]
<b>输出：</b>5
<b>解释：</b>这个示例中有 5 个元素。每个元素属于一个唯一的类别。所以有 5 个唯一类别。
</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>n = 3, catagoryHandler = [1,1,1]
<b>输出：</b>1
<b>解释：</b>这个示例中有 3 个元素。它们全部属于同一个类别。所以只有 1 个唯一类别。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 100</code></li>
</ul>
