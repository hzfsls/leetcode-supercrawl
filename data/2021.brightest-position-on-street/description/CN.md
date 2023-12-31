## [2021.街上最亮的位置](https://leetcode.cn/problems/brightest-position-on-street/)
<p>一条街上有很多的路灯，路灯的坐标由数组&nbsp;<code>lights&nbsp;</code>的形式给出。&nbsp;每个&nbsp;<code>lights[i] = [position<sub>i</sub>, range<sub>i</sub>]</code>&nbsp;代表坐标为&nbsp;<code>position<sub>i</sub></code>&nbsp;的路灯照亮的范围为&nbsp;<code>[position<sub>i</sub> - range<sub>i</sub>, position<sub>i</sub> + range<sub>i</sub>]</code>&nbsp;<strong>（包括顶点）。</strong></p>

<p>位置&nbsp;<code>p</code>&nbsp;的亮度由能够照到&nbsp;<code>p</code>的路灯的数量来决定的。</p>

<p>给出&nbsp;<code>lights</code>, 返回<strong>最亮</strong>的位置&nbsp;。如果有很多，返回坐标最小的。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>
<img src="https://assets.leetcode.com/uploads/2021/09/28/image-20210928155140-1.png" style="width: 700px; height: 165px;">
<pre><strong>输入:</strong> lights = [[-3,2],[1,2],[3,3]]
<strong>输出:</strong> -1
<strong>解释:</strong>
第一个路灯照亮的范围是[(-3) - 2, (-3) + 2] = [-5, -1].
第二个路灯照亮的范围是 [1 - 2, 1 + 2] = [-1, 3].
第三个路灯照亮的范围是 [3 - 3, 3 + 3] = [0, 6].

坐标-1被第一个和第二个路灯照亮，亮度为2
坐标0，1，2都被第二个和第三个路灯照亮，亮度为2.
对于以上坐标，-1最小，所以返回-1</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入:</strong> lights = [[1,0],[0,1]]
<strong>输出:</strong> 1
</pre>

<p><strong>示例 3：</strong></p>

<pre><strong>输入:</strong> lights = [[1,2]]
<strong>输出:</strong> -1
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= lights.length &lt;= 10<sup>5</sup></code></li>
	<li><code>lights[i].length == 2</code></li>
	<li><code>-10<sup>8</sup> &lt;= position<sub>i</sub> &lt;= 10<sup>8</sup></code></li>
	<li><code>0 &lt;= range<sub>i</sub> &lt;= 10<sup>8</sup></code></li>
</ul>
