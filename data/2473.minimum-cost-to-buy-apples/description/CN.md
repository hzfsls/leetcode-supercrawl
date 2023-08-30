## [2473.购买苹果的最低成本]
<p>给你一个正整数&nbsp; <code>n</code>，表示从 <code>1</code> 到 <code>n</code> 的 <code>n</code> 个城市。还给你一个&nbsp;<strong>二维&nbsp;</strong>数组 <code>roads</code>，其中 <code>roads[i] = [a<sub>i</sub>, b<sub>i</sub>, cost<sub>i</sub>]</code> 表示在城市 <code>a<sub>i</sub></code> 和 <code>b<sub>i</sub></code> 之间有一条双向道路，其旅行成本等于 <code>cost<sub>i</sub></code>。</p>

<p>&nbsp;</p>

<p>你可以在&nbsp;<strong>任何&nbsp;</strong>城市买到苹果，但是有些城市买苹果的费用不同。给定数组 <code>appleCost</code> ，其中 <code>appleCost[i]</code>&nbsp;是从城市 <code>i</code> 购买一个苹果的成本。</p>

<p>你从某个城市开始，穿越各种道路，最终从&nbsp;<strong>任何一个&nbsp;</strong>城市买&nbsp;<strong>一个&nbsp;</strong>苹果。在你买了那个苹果之后，你必须回到你&nbsp;<strong>开始的&nbsp;</strong>城市，但现在所有道路的成本将&nbsp;<strong>乘以&nbsp;</strong>一个给定的因子 <code>k</code>。</p>

<p>给定整数 <code>k</code>，返回<em>一个大小为 <code>n</code> 的数组 <code>answer</code>，其中 <code>answer[i]</code>&nbsp;是从城市 <code>i</code> 开始购买一个苹果的&nbsp;<strong>最小&nbsp;</strong>总成本。</em></p>

<p>&nbsp;</p>

<p><strong class="example">示例 1:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/11/15/graph55.png" style="width: 241px; height: 309px;" />
<pre>
<strong>输入:</strong> n = 4, roads = [[1,2,4],[2,3,2],[2,4,5],[3,4,1],[1,3,4]], appleCost = [56,42,102,301], k = 2
<strong>输出:</strong> [54,42,48,51]
<strong>解释:</strong> 每个起始城市的最低费用如下:
- 从城市 1 开始:你走路径 1 -&gt; 2，在城市 2 买一个苹果，最后走路径 2 -&gt; 1。总成本是 4 + 42 + 4 * 2 = 54。
- 从城市 2 开始:你直接在城市 2 买一个苹果。总费用是 42。
- 从城市 3 开始:你走路径 3 -&gt; 2，在城市 2 买一个苹果，最后走路径 2 -&gt; 3。总成本是 2 + 42 + 2 * 2 = 48。
- 从城市 4 开始:你走路径 4 -&gt; 3 -&gt; 2，然后你在城市 2 购买，最后走路径 2 -&gt; 3 -&gt; 4。总成本是 1 + 2 + 42 + 1 * 2 + 2 * 2 = 51。
</pre>

<p><strong class="example">示例 2:</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/11/15/graph4.png" style="width: 167px; height: 309px;" />
<pre>
<strong>输入:</strong> n = 3, roads = [[1,2,5],[2,3,1],[3,1,2]], appleCost = [2,3,1], k = 3
<strong>输出:</strong> [2,3,1]
<strong>解释:</strong> 在起始城市买苹果总是最优的。</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>2 &lt;= n &lt;= 1000</code></li>
	<li><code>1 &lt;= roads.length &lt;= 1000</code></li>
	<li><code>1 &lt;= a<sub>i</sub>, b<sub>i</sub> &lt;= n</code></li>
	<li><code>a<sub>i</sub> != b<sub>i</sub></code></li>
	<li><code>1 &lt;= cost<sub>i</sub> &lt;= 10<sup>5</sup></code></li>
	<li><code>appleCost.length == n</code></li>
	<li><code>1 &lt;= appleCost[i] &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= k &lt;= 100</code></li>
	<li>
	<p data-group="1-1">没有重复的边。</p>
	</li>
</ul>
