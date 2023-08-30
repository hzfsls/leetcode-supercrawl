## 解决方案

---

 #### 概述.

 "加一" 是 "添加数字" 问题集中的一个子集, 它们的解决方法是一样的。

 所有这些问题都可以在线性时间内解决， 问题在于如何在不使用加法运算或 如何适应恒定空间复杂度的情况下解决。

 算法的选择应基于输入格式：

 1. 整数。 这种情况通常不允许使用加法运算。 使用位操作法。 这里有一个例子：[添加二进制](https://leetcode.cn/problems/add-binary/solutions/299667/er-jin-zhi-qiu-he-by-leetcode-solution/)。
 2. 字符串。 使用逐位的计算。 注意，对于有不可变字符串的语言，例如 Java 和 Python，无法适应恒定的空间。 这里有一个例子：[添加二进制](https://leetcode.cn/problems/add-binary/solutions/299667/er-jin-zhi-qiu-he-by-leetcode-solution/)。
 3. 数组。 同样的标准加法。 这里有一个例子：[添加到整数的数组形式](https://leetcode.cn/problems/add-to-array-form-of-integer/solutions/570434/shu-zu-xing-shi-de-zheng-shu-jia-fa-by-l-jljp/)。
 4. 链表，当前问题。 哨兵节点+标准加法。
 注意，将所有内容转换为整数然后使用加法可能对 Java 面试来说有风险，因为可能有溢出问题，[这里有更详细的说明](https://leetcode.cn/problems/add-binary/solutions/299667/er-jin-zhi-qiu-he-by-leetcode-solution/)。 

---

#### 方法 1: 哨兵头节点加标准加法

 **标准加法**
 让我们找出最右边不等于九的数字，并将该数字加一。所有以下的九都应设为零。
 这是最简单的用例，运行正常。
 ![image.png](https://pic.leetcode.cn/1691735239-htYlHI-image.png){:width=600}
 这是更加困难的情况，依然可以通过。
 ![image.png](https://pic.leetcode.cn/1691735320-TdkkRf-image.png){:width=600}
 而这个情况将导致一切破裂。
 ![image.png](https://pic.leetcode.cn/1691735379-ygMylf-image.png){:width=600}
 **哨兵节点**
 为了处理最后一个用例，需要所谓的哨兵节点。 哨兵节点广泛用于树和链表作为伪头，伪尾，等等。他们是功能性的，通常不携带任何数据。 他们的主要目的是标准化情况，以避免处理边缘情况。
 例如，这里可以添加一个值为零的伪头， 因此总是会有非九的节点。
 ![image.png](https://pic.leetcode.cn/1691735575-ptzZaj-image.png){:width=600}

 **算法步骤**

 - 初始化哨兵节点为 `ListNode(0)` 并将其设置为新的头节点：`sentinel.next = head`。
 - 找到最右边的不等于九的数字。
 - 将该数字加一。
 - 将所有后面的九都设为零。
 - 如果哨兵节点被设置为1，则返回哨兵节点， 否则返回头 `sentinel.next`。

**实现**

 ```C++ [slu1]
class Solution {
public:
    ListNode* plusOne(ListNode* head) {
        // 哨兵头节点
        ListNode* sentinel = new ListNode(0);
        sentinel->next = head;
        ListNode* notNine = sentinel;

        // 找出最右边的非九位数
        while (head != nullptr) {
            if (head->val != 9) notNine = head;
            head = head->next;
        }
        // 最右边的非九位数加 1
        notNine->val++;
        notNine = notNine->next;
        // 将所有 9 设置为 0
        while (notNine != nullptr) {
            notNine->val = 0;
            notNine = notNine->next;
        }

        delete notNine;
        return sentinel->val != 0 ? sentinel : sentinel->next;
    }
};
 ```

```Java [slu1]
class Solution {
    public ListNode plusOne(ListNode head) {
        // 哨兵头节点
        ListNode sentinel = new ListNode(0);
        sentinel.next = head;
        ListNode notNine = sentinel;

        // 找出最右边的非九位数
        while (head != null) {
            if (head.val != 9) {
                notNine = head;
            }
            head = head.next;
        }

        // 最右边的非九位数加 1
        notNine.val++;
        notNine = notNine.next;

        // 将所有 9 设置为 0
        while (notNine != null) {
            notNine.val = 0;
            notNine = notNine.next;
        }

    return sentinel.val != 0 ? sentinel : sentinel.next;
  }
}
```

```Python3 [slu1]
class Solution:
    def plusOne(self, head: ListNode) -> ListNode:
        # 哨兵头节点
        sentinel = ListNode(0)
        sentinel.next = head
        not_nine = sentinel

        # 找出最右边的非九位数
        while head:
            if head.val != 9:
                not_nine = head
            head = head.next

        # 最右边的非九位数加 1
        not_nine.val += 1
        not_nine = not_nine.next

        # 将所有 9 设置为 0
        while not_nine:
            not_nine.val = 0
            not_nine = not_nine.next

        return sentinel if sentinel.val else sentinel.next
```


 **复杂度分析**

 * 时间复杂度：因为最多只需遍历两次输入列表，所以时间复杂度为 $\mathcal{O}(N)$。
 * 空间复杂度：$\mathcal{O}(1)$。