## [2743.计算没有重复字符的子字符串数量](https://leetcode.cn/problems/count-substrings-without-repeating-character/)
<p>给定你一个只包含小写英文字母的字符串 <code>s</code> 。如果一个子字符串不包含任何字符至少出现两次（换句话说，它不包含重复字符），则称其为 <strong>特殊</strong> 子字符串。你的任务是计算 <strong>特殊</strong> 子字符串的数量。例如，在字符串 <code>"pop"</code> 中，子串 <code>"po"</code> 是一个特殊子字符串，然而 <code>"pop"</code> 不是 <strong>特殊</strong> 子字符串（因为 <code>'p'</code> 出现了两次）。</p>

<p>返回 <strong>特殊</strong> 子字符串的数量。</p>

<p><strong>子字符串</strong> 是指字符串中连续的字符序列。例如，<code>"abc"</code> 是 <code>"abcd"</code> 的一个子字符串，但 <code>"acd"</code> 不是。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>s = "abcd"
<b>输出：</b>10
<b>解释：</b>由于每个字符只出现一次，每个子串都是特殊子串。长度为 1 的子串有 4 个，长度为 2 的有 3 个，长度为 3 的有 2 个，长度为 4 的有 1 个。所以一共有 4 + 3 + 2 + 1 = 10 个特殊子串。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>s = "ooo"
<b>输出：</b>3
<b>解释：</b>任何长度至少为 2 的子串都包含重复字符。所以我们要计算长度为 1 的子串的数量，即 3 个。
</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>s = "abab"
<b>输出：</b>7
<b>解释：</b>特殊子串如下（按起始位置排序）： 
长度为 1 的特殊子串："a", "b", "a", "b" 
长度为 2 的特殊子串："ab", "ba", "ab" 
并且可以证明没有长度至少为 3 的特殊子串。所以答案是4 + 3 = 7。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 10<sup>5</sup></code></li>
	<li><code>s</code> 只包含小写英文字母。</li>
</ul>
