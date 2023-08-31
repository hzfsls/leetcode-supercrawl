## [1290.二进制链表转整数 中文官方题解](https://leetcode.cn/problems/convert-binary-number-in-a-linked-list-to-integer/solutions/100000/er-jin-zhi-lian-biao-zhuan-zheng-shu-by-leetcode-s)

### 方法一：模拟

由于链表中从高位到低位存放了数字的二进制表示，因此我们可以使用二进制转十进制的方法，在遍历一遍链表的同时得到数字的十进制值。

以示例 1 中给出的二进制链表为例：

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2019/12/15/graph-1.png)

以下用 $(n)_2$ 表示 $n$ 是二进制整数。

$$
(101)_2 = 1 \times 2^2 + 0 \times 2^1 + 1 \times 2^0
$$

链表的第 1 个节点的值是 $1$，这个 $1$ 是二进制的最高位，在十进制分解中，$1$ 作为系数对应的 $2^2$ 的指数是 $2$，这是因为链表的长度为 $3$。我们是不是有必要一定要先知道链表的长度，才可以确定指数 $2$ 呢？答案是不必要的。

+ 每读取链表的一个节点值，可以认为读到的节点值是当前二进制数的最低位；
+ 当读到下一个节点值的时候，**需要将已经读到的结果乘以 $2$**，再将新读到的节点值当作当前二进制数的最低位；
+ 如此进行下去，直到读到了链表的末尾。


```C++ [sol1-C++]
class Solution {
public:
    int getDecimalValue(ListNode* head) {
        ListNode* cur = head;
        int ans = 0;
        while (cur != nullptr) {
            ans = ans * 2 + cur->val;
            cur = cur->next;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getDecimalValue(ListNode head) {
        ListNode curNode = head;
        int ans = 0;
        while (curNode != null) {
            ans = ans * 2 + curNode.val;
            curNode = curNode.next;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getDecimalValue(self, head: ListNode) -> int:
        cur = head
        ans = 0
        while cur:
            ans = ans * 2 + cur.val
            cur = cur.next
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是链表中的节点个数。

- 空间复杂度：$O(1)$。