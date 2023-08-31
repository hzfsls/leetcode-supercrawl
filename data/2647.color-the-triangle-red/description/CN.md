## [2647.把三角形染成红色](https://leetcode.cn/problems/color-the-triangle-red/)
<p>现给定你一个整数 <code>n</code> 。考虑一个边长为 <code>n</code> 的等边三角形，被分成 <code>n<sup>2</sup></code> 个单位等边三角形。这个三角形有 <code>n</code> 个 <strong>从 1 开始编号</strong> 的行，其中第 <code>i</code> 行有 <code>2i - 1</code> 个单位等边三角形。</p>

<p>第 <code>i</code> 行的三角形也是&nbsp;<strong>从 1 开始编号&nbsp;</strong>的，其坐标从 <code>(i, 1)</code> 到 <code>(i, 2i - 1)</code>&nbsp;。下面的图像显示了一个边长为 <code>4</code> 的三角形及其三角形的索引。</p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/09/01/triangle4.jpg" style="width: 402px; height: 242px;" />
<p>如果两个三角形 <strong>共享一条边</strong> ，则它们是 <strong>相邻</strong> 的。例如：</p>

<ul>
	<li>三角形 <code>(1,1)</code> 和 <code>(2,2)</code> 是相邻的。</li>
	<li>三角形 <code>(3,2)</code> 和 <code>(3,3)</code> 是相邻的。</li>
	<li>三角形 <code>(2,2)</code> 和 <code>(3,3)</code> 不相邻，因为它们没有共享任何边。</li>
</ul>

<p>初始时，所有单位三角形都是 <strong>白色</strong> 的。你想选择 <code>k</code> 个三角形并将它们涂成 <strong>红色</strong> 。然后我们将运行以下算法：</p>

<ol>
	<li>选择一个 <strong>至少有两个</strong> 红色相邻三角形的白色三角形。

	<ul>
		<li>如果没有这样的三角形，请停止算法。</li>
	</ul>
	</li>
	<li>将该三角形涂成 <strong>红色</strong> 。</li>
	<li>回到步骤 1。</li>
</ol>

<p>选择最小的 <code>k</code> 并在运行此算法之前将 <code>k</code> 个三角形涂成红色，使得在算法停止后，所有单元三角形都被涂成红色。</p>

<p>返回一个二维列表，其中包含你要最初涂成红色的三角形的坐标。答案必须尽可能小。如果有多个有效的解决方案，请返回其中任意一个。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/09/01/example1.jpg" style="width: 500px; height: 263px;" />
<pre>
<b>输入：</b>n = 3
<b>输出：</b>[[1,1],[2,1],[2,3],[3,1],[3,5]]
<b>解释：</b>初始时，我们选择展示的5个三角形染成红色。然后，我们运行以下算法：
- 选择(2,2)，它有三个红色相邻的三角形，并将其染成红色。
- 选择(3,2)，它有两个红色相邻的三角形，并将其染成红色。
- 选择(3,4)，它有三个红色相邻的三角形，并将其染成红色。
- 选择(3,3)，它有三个红色相邻的三角形，并将其染成红色。 
可以证明，选择任何4个三角形并运行算法都无法将所有三角形都染成红色。</pre>

<p><strong class="example">示例 2 ：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2022/09/01/example2.jpg" style="width: 300px; height: 101px;" />
<pre>
<b>输入：</b>n = 2
<b>输出：</b>[[1,1],[2,1],[2,3]]
<b>解释：</b>初始时，我们选择图中所示的 3 个三角形为红色。然后，我们运行以下算法： 
-选择有三个红色相邻的 (2,2) 三角形并将其染成红色。 
可以证明，选择任意 2 个三角形并运行该算法都不能使所有三角形变为红色。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 1000</code></li>
</ul>
