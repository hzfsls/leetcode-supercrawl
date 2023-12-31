## [2604.吃掉所有谷子的最短时间](https://leetcode.cn/problems/minimum-time-to-eat-all-grains/)
<p>一条线上有 <code>n</code> 只母鸡和 <code>m</code> 颗谷子。给定两个整数数组 <code>hens</code> 和 <code>grains</code> ，它们的大小分别为 <code>n</code> 和 <code>m</code> ，表示母鸡和谷子的初始位置。</p>

<p>如果一只母鸡和一颗谷子在同一个位置，那么这只母鸡可以吃掉这颗谷子。吃掉一颗谷子的时间可以忽略不计。一只母鸡也可以吃掉多颗谷子。</p>

<p>在 <code>1</code> 秒钟内，一只母鸡可以向左或向右移动 <code>1</code> 个单位。母鸡可以同时且独立地移动。</p>

<p>如果母鸡行动得当，返回吃掉所有谷子的 <strong>最短</strong> 时间。</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1 ：</strong></p>

<pre>
<b>输入：</b>hens = [3,6,7], grains = [2,4,7,9]
<b>输出：</b>2
<b>解释：</b>
母鸡吃掉所有谷子的一种方法如下：
- 第一只母鸡在 1 秒钟内吃掉位置 2 处的谷子。
- 第二只母鸡在 2 秒钟内吃掉位置 4 处的谷子。
- 第三只母鸡在 2 秒钟内吃掉位置 7 和 9 处的谷子。 
所以，需要的最长时间为2秒。 
可以证明，在2秒钟之前，母鸡不能吃掉所有谷子。</pre>

<p><strong class="example">示例 2 ：</strong></p>

<pre>
<b>输入：</b>hens = [4,6,109,111,213,215], grains = [5,110,214]
<b>输出：</b>1
<b>解释：</b>
母鸡吃掉所有谷子的一种方法如下：
- 第一只母鸡在 1 秒钟内吃掉位置 5 处的谷子。
- 第四只母鸡在 1 秒钟内吃掉位置 110 处的谷子。
- 第六只母鸡在 1 秒钟内吃掉位置 214 处的谷子。
- 其他母鸡不动。 
所以，需要的最长时间为 1 秒。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= hens.length, grains.length &lt;= 2*10<sup>4</sup></code></li>
	<li><code>0 &lt;= hens[i], grains[j] &lt;= 10<sup>9</sup></code></li>
</ul>
