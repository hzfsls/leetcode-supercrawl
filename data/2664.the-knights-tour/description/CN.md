## [2664.巡逻的骑士](https://leetcode.cn/problems/the-knights-tour/)
<p>给定两个正整数 <code>m</code> 和 <code>n</code>&nbsp;，它们是一个 <strong>下标从 0 开始</strong> 的二维数组 <code>board</code> 的高度和宽度。还有一对正整数 <code>(r, c)</code> ，它们是骑士在棋盘上的起始位置。</p>

<p>你的任务是找到一个骑士的移动顺序，使得&nbsp;<code>board</code>&nbsp;中每个单元格都 <strong>恰好</strong> 被访问一次（起始单元格已被访问，<strong>不应</strong> 再次访问）。</p>

<p>返回数组 <code>board</code> ，其中单元格的值显示从 0 开始访问该单元格的顺序（骑士的初始位置为 0）。</p>

<p>注意，如果 <code>0 &lt;= r2 &lt;= m-1 且 0 &lt;= c2 &lt;= n-1</code>&nbsp;，并且 <code>min(abs(r1-r2), abs(c1-c2)) = 1</code> 且 <code>max(abs(r1-r2), abs(c1-c2)) = 2</code>&nbsp;，则骑士可以从单元格 <code>(r1, c1)</code> 移动到单元格 <code>(r2, c2)</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1 ：</strong></p>

<pre>
<b>输入：</b>m = 1, n = 1, r = 0, c = 0
<b>输出：</b>[[0]]
<b>解释</b>只有一个单元格，骑士最初在其中，因此 1x1 网格中只有一个 0。
</pre>

<p><strong>示例 2 ：</strong></p>

<pre>
<strong>输入：</strong>m = 3, n = 4, r = 0, c = 0
<b>输出：</b>[[0,3,6,9],[11,8,1,4],[2,5,10,7]]
<b>解释：</b>按照以下移动顺序，我们可以访问整个棋盘。 
(0,0)-&gt;(1,2)-&gt;(2,0)-&gt;(0,1)-&gt;(1,3)-&gt;(2,1)-&gt;(0,2)-&gt;(2,3)-&gt;(1,1)-&gt;(0,3)-&gt;(2,2)-&gt;(1,0)</pre>

<p>&nbsp;</p>

<p><b>提示：</b></p>

<ul>
	<li><code>1 &lt;= m,&nbsp;n &lt;= 5</code></li>
	<li><code>0 &lt;= r &lt;= m - 1</code></li>
	<li><code>0 &lt;= c &lt;= n - 1</code></li>
	<li>输入的数据保证在给定条件下至少存在一种访问所有单元格的移动顺序。</li>
</ul>
