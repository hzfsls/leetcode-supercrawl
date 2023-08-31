## [2539.好子序列的个数](https://leetcode.cn/problems/count-the-number-of-good-subsequences/)
<p>如果字符串的某个 <strong>子序列</strong> 不为空，且其中每一个字符出现的频率都相同，就认为该子序列是一个好子序列。</p>

<p>给你一个字符串&nbsp;<code>s</code> ，请你统计并返回它的好子序列的个数。由于答案的值可能非常大，请返回对 <code>10<sup>9</sup> + 7</code> 取余的结果作为答案。</p>

<p>字符串的 <strong>子序列</strong> 是指，通过删除一些（也可以不删除）字符且不改变剩余字符相对位置所组成的新字符串。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = "aabb"
<strong>输出：</strong>11
<strong>解释：</strong>s 的子序列的总数为 <code>2<sup>4 </sup>= 16 。其中，有 5 个子序列不是好子序列，分别是 </code>"<em><strong>aab</strong></em>b"，"a<em><strong>abb</strong></em>"，"<strong><em>a</em></strong>a<em><strong>bb</strong></em>"，"<em><strong>aa</strong></em>b<em><strong>b</strong></em>" 以及空字符串。因此，好子序列的个数为 16 <code>- 5 = 11</code> 。</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = "leet"
<strong>输出：</strong>12
<strong>解释：</strong>s 的子序列的总数为 <code>2<sup>4 </sup>= 16 。</code>其中，<code>有 4 个子序列不是好子序列，分别是 </code>"<em><strong>lee</strong></em>t"，"l<em><strong>eet</strong></em>"，"<em><strong>leet</strong></em>" 以及空字符串。因此，好子序列的个数为 16 <code>- 4 = 12</code> 。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = "abcd"
<strong>输出：</strong>15
<strong>解释：</strong>s 所有非空子序列均为好子序列。因此，好子序列的个数为 16<code> - 1 = 15</code> 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 10<sup>4</sup></code></li>
	<li><code>s</code> 仅由小写英文字母组成</li>
</ul>
