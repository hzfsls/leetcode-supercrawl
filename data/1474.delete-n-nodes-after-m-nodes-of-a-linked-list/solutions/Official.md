## [1474.删除链表 M 个节点之后的 N 个节点 中文官方题解](https://leetcode.cn/problems/delete-n-nodes-after-m-nodes-of-a-linked-list/solutions/100000/shan-chu-lian-biao-m-ge-jie-dian-zhi-hou-93uk)
[TOC]

## 解决方案

---

#### 概述

这个问题相当直白。给定一个单链表，我们必须遍历这个链表，并在每个 $n$ 个节点后删除 $m$ 个节点。这个链表是单链表，因此我们必须一个一个地遍历链表节点，迭代前 $m$ 个节点，然后删除 $n$ 个节点，并继续这个过程，直到遍历完整个链表。和数组不一样的是，链表的存储并不是连续的内存位置。因此，我们可以很容易地在原地删除节点，只需改变链表节点的指针即可。

让我们详细地看一下这个算法。

---

#### 方法 1：遍历链表并原地删除

 **概述**

 我们可以从头节点开始线性遍历单链表。因为我们必须在每 $m$ 个节点后删除 $n$ 个节点，所以我们必须遍历前 $m$ 个节点，存储第 $m$ 个节点，然后删除下一个 $n$ 个节点。为了删除那 $n$ 个节点，我们必须让第 $m$ 个节点指向第 $n$ 个节点之后的节点。
 **算法**

 1. 将 `currentNode` 初始化为链表的 `head`。`currentNode` 是用于线性遍历链表的每一个节点。
 2. 迭代地在每 $m$ 个节点后删除 $n$ 个节点，直到我们到达链表的末尾。

    - 首先迭代 $m$ 个节点。在 `currentNode` 遍历每个节点时，我们保持一个指向 `currentNode` 的前驱的 `lastMNode` 指针。在 $m$ 次迭代后， `lastMNode` 指向了 $m$ 节点。  
    - 现在，继续迭代 $n$ 个节点。在 $n$ 次迭代后，我们必须删除 `lastMNode` 和 `currentNode` 之间的节点。
    - 为了删除 $n$ 个节点，我们可以简单地修改 `lastMNode` 的下一个指针，使其指向 `currentNode`。

 该算法可以通过以下例子来说明
![素材库 摘录_00.png](https://pic.leetcode.cn/1692173662-XTtERk-%E7%B4%A0%E6%9D%90%E5%BA%93%20%E6%91%98%E5%BD%95_00.png){:width=800}
 **实现**

 ```C++ [slu1]
 class Solution {
public:
    ListNode* deleteNodes(ListNode* head, int m, int n) {
        ListNode* currentNode = head;
        ListNode* lastMNode = head;
        while (currentNode != nullptr) {
            // 将 mCount 初始化为 m，将 nCount 初始化为 n
            int mCount = m, nCount = n;
            // 遍历 m 个节点
            while (currentNode != nullptr && mCount != 0) {
                lastMNode = currentNode;
                currentNode = currentNode->next;
                mCount--;
            }
            // 遍历 n 个节点
            while (currentNode != nullptr && nCount != 0) {
                currentNode = currentNode->next;
                nCount--;
            }
            // 删除 n 个节点
            lastMNode->next = currentNode;
        }
        return head;    
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public ListNode deleteNodes(ListNode head, int m, int n) {
        ListNode currentNode = head;
        ListNode lastMNode = head;
        while (currentNode != null) {
            // 将 mCount 初始化为 m，将 nCount 初始化为 n
            int mCount = m, nCount = n;
            // 遍历 m 个节点
            while (currentNode != null && mCount != 0) {
                lastMNode = currentNode;
                currentNode = currentNode.next;
                mCount--;
            }
            // 遍历 n 个节点
            while (currentNode != null && nCount != 0) {
                currentNode = currentNode.next;
                nCount--;
            }
            // 删除 n 个节点
            lastMNode.next = currentNode;
        }
        return head;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$\mathcal{O}(N)$。这里，N 是 `head` 指向的链表的长度。我们只遍历一次链表。
 * 空间复杂度：$\mathcal{O}(1)$。我们使用了恒定的额外空间来存储 `lastMNode` 和 `currentNode` 这样的指针。