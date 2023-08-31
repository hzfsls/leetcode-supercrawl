## [2058.找出临界点之间的最小和最大距离 中文官方题解](https://leetcode.cn/problems/find-the-minimum-and-maximum-number-of-nodes-between-critical-points/solutions/100000/zhao-chu-lin-jie-dian-zhi-jian-de-zui-xi-b08v)

#### 方法一：维护上一个和第一个临界点的位置

**思路与算法**

我们可以对链表进行一次遍历。

当我们遍历到节点 $\textit{cur}$ 时，可以记 $\textit{cur}$ 的值、$\textit{cur}$ 后一个节点的值、$\textit{cur}$ 后两个节点的值，分别为 $x, y, z$。如果 $y$ 严格大于 $x$ 和 $z$，或者 $y$ 严格小于 $x$ 和 $z$，那么 $\textit{cur}$ 的后一个节点就是临界点。

由于我们需要得到任意两个临界点之间的最小距离和最大距离，而我们可以发现：

- 最小距离一定出现在两个相邻的临界点之间；

- 最大距离一定出现在第一个和最后一个临界点之间。

因此，在遍历的过程中，我们可以维护上一个临界点的位置以及第一个临界点的位置。这样一来，每当我们找到一个临界点，就可以更新最小距离和最大距离。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> nodesBetweenCriticalPoints(ListNode* head) {
        int minDist = -1, maxDist = -1;
        int first = -1, last = -1, pos = 0;
        ListNode* cur = head;
        while (cur->next->next) {
            // 获取连续的三个节点的值
            int x = cur->val;
            int y = cur->next->val;
            int z = cur->next->next->val;
            // 如果 y 是临界点
            if (y > max(x, z) || y < min(x, z)) {
                if (last != -1) {
                    // 用相邻临界点的距离更新最小值
                    minDist = (minDist == -1 ? pos - last : min(minDist, pos - last));
                    // 用到第一个临界点的距离更新最大值
                    maxDist = max(maxDist, pos - first);
                }
                if (first == -1) {
                    first = pos;
                }
                // 更新上一个临界点
                last = pos;
            }
            cur = cur->next;
            ++pos;
        }
        return {minDist, maxDist};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def nodesBetweenCriticalPoints(self, head: Optional[ListNode]) -> List[int]:
        minDist = maxDist = -1
        first = last = -1
        pos = 0

        cur = head
        while cur.next.next:
            # 获取连续的三个节点的值
            x, y, z = cur.val, cur.next.val, cur.next.next.val
            # 如果 y 是临界点
            if y > max(x, z) or y < min(x, z):
                if last != -1:
                    # 用相邻临界点的距离更新最小值
                    minDist = (pos - last if minDist == -1 else min(minDist, pos - last))
                    # 用到第一个临界点的距离更新最大值
                    maxDist = max(maxDist, pos - first)
                if first == -1:
                    first = pos
                # 更新上一个临界点
                last = pos
            cur = cur.next
            pos += 1
        
        return [minDist, maxDist]
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定的链表的长度。

- 空间复杂度：$O(1)$。