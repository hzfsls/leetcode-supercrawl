## [2158.每天绘制新区域的数量](https://leetcode.cn/problems/amount-of-new-area-painted-each-day/)
<p>有一幅细长的画，可以用数轴来表示。 给你一个长度为 <code>n</code> 、下标从 <strong>0</strong> 开始的二维整数数组 <code>paint</code> ，其中 <code>paint[i] = [start<sub>i</sub>, end<sub>i</sub>]</code> 表示在第 <code>i</code> 天你需要绘制 <code>start<sub>i</sub></code>&nbsp;和 <code>end<sub>i</sub></code>&nbsp;之间的区域。</p>

<p>多次绘制同一区域会导致不均匀，因此每个区域最多只能绘制 <strong>一次 </strong>。</p>

<p>返回一个长度为 <code>n</code> 的整数数组 <code>worklog</code>，其中 <code>worklog[i]</code> 是你在第 <code>i</code> 天绘制的<strong> 新 </strong>区域的数量。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/01/screenshot-2022-02-01-at-17-16-16-diagram-drawio-diagrams-net.png" style="height: 300px; width: 620px;" />
<pre>
<strong>输入：</strong>paint = [[1,4],[4,7],[5,8]]
<strong>输出：</strong>[3,3,1]
<strong>解释：
</strong>在第 0 天，绘制 1 到 4 之间的所有内容。
第 0 天绘制的新区域数量为 4 - 1 = 3 。
在第 1 天，绘制 4 到 7 之间的所有内容。
第 1 天绘制的新区域数量为 7 - 4 = 3 。
在第 2 天，绘制 7 到 8 之间的所有内容。
5 到 7 之间的所有内容都已在第 1 天绘制完毕。
第 2 天绘制的新区域数量为 8 - 7 = 1 。
</pre>

<p><strong>示例&nbsp;2：</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/01/screenshot-2022-02-01-at-17-17-45-diagram-drawio-diagrams-net.png" style="width: 604px; height: 300px;" />
<pre>
<strong>输入：</strong>paint = [[1,4],[5,8],[4,7]]
<strong>输出：</strong>[3,3,1]
<strong>解释：</strong>
在第 0 天，绘制 1 到 4 之间的所有内容。
第 0 天绘制的新区域数量为 4 - 1 = 3 。
第 1 天，绘制 5 到 8 之间的所有内容。
第 1 天绘制的新区域数量为 8 - 5 = 3 。
在第 2 天，绘制 4 到 5 之间的所有内容。
5 到 7 之间的所有内容都已在第 1 天绘制完毕。
第 2 天绘制的新区域数量为 5 - 4 = 1 。
</pre>

<p><strong>示例&nbsp;3：</strong></p>
<img src="https://assets.leetcode.com/uploads/2022/02/01/screenshot-2022-02-01-at-17-19-49-diagram-drawio-diagrams-net.png" style="width: 423px; height: 275px;" />
<pre>
<strong>输入：</strong>paint = [[1,5],[2,4]]
<strong>输出：</strong>[4,0]
<strong>解释：</strong>
在第 0 天，绘制 1 到 5 之间的所有内容。
第 0 天绘制的新区域数量为 5 - 1 = 4 。
在第 1 天，什么都不画，因为第 0 天已经画了 2 到 4 之间的所有内容。
第 1 天绘制的新区域数量为 0 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= paint.length &lt;= 10<sup>5</sup></code></li>
	<li><code>paint[i].length == 2</code></li>
	<li><code>0 &lt;= start<sub>i</sub> &lt; end<sub>i</sub> &lt;= 5 * 10<sup>4</sup></code></li>
</ul>
