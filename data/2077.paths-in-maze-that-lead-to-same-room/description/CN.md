## [2077.殊途同归](https://leetcode.cn/problems/paths-in-maze-that-lead-to-same-room/)
<p>迷宫由 <code>n</code> 个从 <code>1</code> 到 <code>n</code> 的房间组成，有些房间由走廊连接。给定一个二维整数数组 <code>corridors</code>，其中 <code>corridors[i] = [room1<sub>i</sub>, room2<sub>i</sub>]</code>&nbsp;表示有一条走廊连接 <code>room1<sub>i</sub></code> 和<code>room2<sub>i</sub></code>，允许迷宫中的一个人从 <code>room1<sub>i</sub></code> 到 <code>room1<sub>i</sub></code> ，<strong>反之亦然</strong>。</p>

<p>迷宫的设计者想知道迷宫有多让人困惑。迷宫的&nbsp;<strong>混乱分数&nbsp;</strong>是&nbsp;<strong>长度为 3</strong> 的不同的环的数量。</p>

<ul>
	<li>例如, <code>1 → 2 → 3 → 1</code>&nbsp;是长度为 3 的环, 但&nbsp;<code>1 → 2 → 3 → 4</code> 和&nbsp;<code>1 → 2 → 3 → 2 → 1</code> 不是。</li>
</ul>

<p>如果在第一个环中访问的一个或多个房间&nbsp;<strong>不在&nbsp;</strong>第二个环中，则认为两个环是&nbsp;<strong>不同&nbsp;</strong>的。</p>

<p data-group="1-1">返回<em>迷宫的混乱分数</em>。</p>

<p><strong class="example">示例 1:</strong></p>
<img src="https://assets.leetcode.com/uploads/2021/11/14/image-20211114164827-1.png" style="width: 440px; height: 350px;" />
<pre>
<strong>输入:</strong> n = 5, corridors = [[1,2],[5,2],[4,1],[2,4],[3,1],[3,4]]
<strong>输出:</strong> 2
<strong>解释:</strong>
一个长度为 3 的环为 4→1→3→4，用红色表示。
注意，这是与 3→4→1→3 或 1→3→4→1 相同的环，因为房间是相同的。
另一个长度为 3 的环为 1→2→4→1，用蓝色表示。
因此，有两个长度为 3 的不同的环。
</pre>

<p><strong class="example">示例&nbsp;2:</strong></p>
<img src="https://assets.leetcode.com/uploads/2021/11/14/image-20211114164851-2.png" style="width: 329px; height: 250px;" />
<pre>
<strong>输入:</strong> n = 4, corridors = [[1,2],[3,4]]
<strong>输出:</strong> 0
<strong>解释:</strong>
没有长度为 3 的环。</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>2 &lt;= n &lt;= 1000</code></li>
	<li><code>1 &lt;= corridors.length &lt;= 5 * 10<sup>4</sup></code></li>
	<li><code>corridors[i].length == 2</code></li>
	<li><code>1 &lt;= room1<sub>i</sub>, room2<sub>i</sub> &lt;= n</code></li>
	<li><code>room1<sub>i</sub> != room2<sub>i</sub></code></li>
	<li>
	<p data-group="1-1">没有重复的走廊。</p>
	</li>
</ul>
