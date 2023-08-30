## [2728.计算一个环形街道上的房屋数量]
<p>给定一个代表环形街道的类 <code>Street</code> 和一个正整数 <code>k</code>，表示街道上房屋的最大数量（也就是说房屋数量不超过 <code>k</code>&nbsp;）。每个房屋的门初始时可以是开着的也可以是关着的。</p>

<p>刚开始，你站在一座房子的门前。你的任务是计算街道上的房屋数量。</p>

<p><code>Street</code> 类包含以下函数：</p>

<ul>
	<li><code>void openDoor()</code> ：打开当前房屋的门。</li>
	<li><code>void closeDoor()</code> ：关闭当前房屋的门。</li>
	<li><code>boolean isDoorOpen()</code> ：如果当前房屋的门是开着的返回 <code>true</code> ，否则返回 <code>false</code> 。</li>
	<li><code>void moveRight()</code> ：向右移动到下一座房屋。</li>
	<li><code>void moveLeft()</code> ：向左移动到上一座房屋。</li>
</ul>

<p>返回 <code>ans</code>，它表示街道上的房屋数量。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>street = [0,0,0,0], k = 10
<b>输出：</b>4
<b>解释：</b>街道上有 4 座房屋，它们的门都是关着的。
房屋数量小于 k，即 10。</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>street = [1,0,1,1,0], k = 5
<b>输出：</b>5
<b>解释：</b>街道上有 5 座房屋，向右移动时第 1、3 和 4 座房屋的门是开着的，其余的门都是关着的。房屋数量等于 k，即 5。
</pre>

<p>&nbsp;</p>

<p><strong>解释：</strong></p>

<ul>
	<li><code>n&nbsp; 是房屋数量</code></li>
	<li><code>1 &lt;= n &lt;= k &lt;= 10<sup>3</sup></code></li>
</ul>
