## [2819.购买巧克力后的最小相对损失](https://leetcode.cn/problems/minimum-relative-loss-after-buying-chocolates/)
<p>现给定一个整数数组 <code>prices</code>，表示巧克力的价格；以及一个二维整数数组 <code>queries</code>，其中 <code>queries[i] = [ki, mi]</code>。</p>

<p>Alice 和 Bob 去买巧克力，Alice 提出了一种付款方式，而 Bob 同意了。</p>

<p>对于每个 <code>queries[i]</code> ，它的条件如下：</p>

<ul>
	<li>如果一块巧克力的价格 <strong>小于等于</strong> <code>ki</code>，那么 Bob 为它付款。</li>
	<li>否则，Bob 为其中 <code>ki</code> 部分付款，而 Alice 为 <strong>剩余</strong> 部分付款。</li>
</ul>

<p>Bob 想要选择 <strong>恰好</strong> <code>mi</code> 块巧克力，使得他的 <strong>相对损失最小</strong> 。更具体地说，如果总共 Alice 付款了 <code>ai</code>，Bob 付款了 <code>bi</code>，那么 Bob 希望最小化 <code>bi - ai</code>。</p>

<p>返回一个整数数组 <code>ans</code>，其中 <code>ans[i]</code> 是 Bob 在&nbsp;<code>queries[i]</code> 中可能的 <strong>最小相对损失</strong> 。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>prices = [1,9,22,10,19], queries = [[18,4],[5,2]]
<b>输出：</b>[34,-21]
<b>解释：</b>对于第一个 query，Bob 选择价格为 [1,9,10,22] 的巧克力。他付了 1 + 9 + 10 + 18 = 38，Alice 付了 0 + 0 + 0 + 4 = 4。因此，Bob 的相对损失是 38 - 4 = 34。
对于第二个 query，Bob 选择价格为 [19,22] 的巧克力。他付了 5 + 5 = 10，Alice 付了 14 + 17 = 31。因此，Bob 的相对损失是 10 - 31 = -21。
可以证明这些是可能的最小相对损失。</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>prices = [1,5,4,3,7,11,9], queries = [[5,4],[5,7],[7,3],[4,5]]
<b>输出：</b>[4,16,7,1]
<b>解释：</b>对于第一个 query，Bob 选择价格为 [1,3,9,11] 的巧克力。他付了 1 + 3 + 5 + 5 = 14，Alice 付了 0 + 0 + 4 + 6 = 10。因此，Bob 的相对损失是 14 - 10 = 4。
对于第二个 query，Bob 必须选择所有的巧克力。他付了 1 + 5 + 4 + 3 + 5 + 5 + 5 = 28，Alice 付了 0 + 0 + 0 + 0 + 2 + 6 + 4 = 12。因此，Bob 的相对损失是 28 - 12 = 16。
对于第三个 query，Bob 选择价格为 [1,3,11] 的巧克力。他付了 1 + 3 + 7 = 11，Alice 付了 0 + 0 + 4 = 4。因此，Bob 的相对损失是 11 - 4 = 7。
对于第四个 query，Bob 选择价格为 [1,3,7,9,11] 的巧克力。他付了 1 + 3 + 4 + 4 + 4 = 16，Alice 付了 0 + 0 + 3 + 5 + 7 = 15。因此，Bob 的相对损失是 16 - 15 = 1。
可以证明这些是可能的最小相对损失。
</pre>

<p><strong class="example">示例 3：</strong></p>

<pre>
<b>输入：</b>prices = [5,6,7], queries = [[10,1],[5,3],[3,3]]
<b>输出：</b>[5,12,0]
<b>解释：</b>对于第一个 query，Bob 选择价格为 5 的巧克力。他付了 5，Alice 付了 0。因此，Bob 的相对损失是 5 - 0 = 5。
对于第二个 query，Bob 必须选择所有的巧克力。他付了 5 + 5 + 5 = 15，Alice 付了 0 + 1 + 2 = 3。因此，Bob 的相对损失是 15 - 3 = 12。
对于第三个 query，Bob 必须选择所有的巧克力。他付了 3 + 3 + 3 = 9，Alice 付了 2 + 3 + 4 = 9。因此，Bob 的相对损失是 9 - 9 = 0。
可以证明这些是可能的最小相对损失。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= prices.length == n &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= prices[i] &lt;= 10<sup>9</sup></code></li>
	<li><code>1 &lt;= queries.length &lt;= 10<sup>5</sup></code></li>
	<li><code>queries[i].length == 2</code></li>
	<li><code>1 &lt;= k<sub>i</sub> &lt;= 10<sup>9</sup></code></li>
	<li><code>1 &lt;= m<sub>i</sub> &lt;= n</code></li>
</ul>
