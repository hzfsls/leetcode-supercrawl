## [2674.拆分循环链表](https://leetcode.cn/problems/split-a-circular-linked-list/)
<p>现给定一个由正整数组成的 <strong>循环链表</strong> <code>list</code> ，你的任务是将其拆分为 2 个 <strong>循环链表</strong> ，使得第一个链表包含 <code>list</code> <strong>前半部分&nbsp;</strong>的节点（即 <code>ceil(list.length / 2)</code> 个节点），顺序与 list 中的顺序相同，而第二个链表包含 <code>list</code> 中 <strong>剩余</strong> 的节点，顺序也与 <code>list</code> 中的顺序相同。</p>

<p>返回一个长度为 2 的数组，其中第一个元素是表示 <strong>前半部分</strong> 链表的<strong> 循环链表</strong> ，第二个元素是表示 <strong>后半部分</strong> 链表的 <strong>循环链表</strong> 。</p>

<p><strong>循环链表</strong> 是一个普通的链表，唯一的区别是最后一个节点的下一个节点是头节点。</p>

<p>&nbsp;</p>

<p><strong class="example">示例 1：</strong></p>

<pre>
<b>输入：</b>nums = [1,5,7]
<b>输出：</b>[[1,5],[7]]
<b>解释：</b>初始链表有3个节点，因此前半部分是前两个元素，剩下的 1 个节点在后半部分。
</pre>

<p><strong class="example">示例 2：</strong></p>

<pre>
<b>输入：</b>nums = [2,6,1,5]
<b>输出：</b>[[2,6],[1,5]]
<b>解释：</b>初始链表有4个节点，因此前半部分是前两个元素，剩下的 2 个节点在后半部分。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>list</code> 中的节点数范围为 <code>[2, 105]</code></li>
	<li><code>0 &lt;= Node.val &lt;= 10<sup>9</sup></code></li>
	<li><code>LastNode.next = FirstNode</code> ，其中 <code>LastNode</code> 是链表的最后一个节点，<code>FirstNode</code> 是第一个节点。</li>
</ul>
