## [1585.检查字符串是否可以通过排序子字符串得到另一个字符串 中文官方题解](https://leetcode.cn/problems/check-if-string-is-transformable-with-substring-sort-operations/solutions/100000/jian-cha-zi-fu-chuan-shi-fou-ke-yi-tong-guo-pai-2)
#### 方法一：冒泡排序

**思路**

设给定的字符串 $s$ 和 $t$ 的长度均为 $n$。题目描述中允许我们将任意长度的子串进行原地升序排序，这无疑增加了操作的复杂性，我们是否可以将对长度为 $1, 2, \cdots, n$ 的子串进行的操作归纳成少数的几种操作呢？

答案是可以的，当我们操作长度为 $1$ 的子串时，相当于没有进行任何操作，可以忽略；而当我们操作长度等于 $2$ 的子串时，我们是将相邻的两个字符根据它们的大小关系交换位置，类似于「冒泡排序」中的每一个步骤；而当我们操作长度大于等于 $3$ 的子串时，我们是将对应的子串原地升序排序，但它**可以拆分成若干次冒泡排序的步骤**，即**我们对整个子串进行一次完整的冒泡排序，可以得到和题目描述中的操作相同的结果，而冒泡排序中的每一个步骤就是对长度为 $2$ 的子串进行题目描述中的操作**。因此，我们可以得到结论：

> 在任意时刻，我们选择操作的子串只要长度为 $2$ 即可，它与题目描述中的操作是等价的。

有了上述的这个结论，我们就可以直接模拟将 $s$ 变为 $t$ 的整个操作了：

- 首先我们考虑 $t$ 的首个字符 $t[0]$，那么它在 $s$ 中对应的一定就是 $s$ 中的首个与 $t[0]$ 相等的字符，记为 $s[t_0]$。其中的原因很简单，如果 $t[0]$ 在 $s$ 中对应的是另一个字符 $s[t_0']$，那么有 $t_0' > t_0$。由于我们只能根据大小关系交换相邻的两个字符，因此 $s[t_0']$ 想要通过交换到达字符串的首位，必须要「越过」$s[t_0]$，而由于 $s[t_0] = s[t_0']$，因此当 $s[t_0']$ 越过 $s[t_0'-1], s[t_0'-2], \cdots$ 并到达 $s[t_0+1]$ 时，它还是无法越过 $s[t_0]$ 并到达字符串的首位，$s[t_0]$「挡住」了 $s[t_0']$。因此，我们唯一确定了 $t[0]$ 在字符串 $s$ 中的位置 $s[t_0]$；

- 其次我们就需要判断是否可以通过交换操作使得 $s[t_0]$ 能够到达字符串的首位了。显然，当且仅当 $s[0], s[1], \cdots, s[t_0-1]$ 均大于 $s[t_0]$ 时，$s[t_0]$ 才能通过交换操作到达首位。换句话说，**小于 $s[t_0]$ 的所有字符都出现在 $s[t_0]$ 的右侧**。如果这个条件满足，那么 $s[t_0]$ 能够到达字符串的首位。当我们处理完 $t[0]$ 后，我们将 $s[t_0]$ 从字符串中移除；

- 类似地，我们继续考虑 $t$ 的下一个字符 $t[1]$，它也是 $s$ 中的首个与 $t[1]$ 相等的字符，记为 $s[t_1]$。同样地，当且仅当小于 $s[t_1]$ 的所有字符都出现在 $s[t_1]$ 的右侧时，$s[t_1]$ 才能通过交换操作到达第二位，注意这里已经将 $s[t_0]$ 移除。

通过上述的模拟方法，我们遍历字符串 $t$，找出字符串 $s$ 中的 $s[t_i]$，对应于当前遍历到的字符 $t[i]$，并判断 $s[t_i]$ 是否可以向前移动到字符串的第 $i$ 个位置。

**算法**

我们使用 $10$ 个列表，分别按照从小到大的顺序存储字符 $0, 1, \cdots, 9$ 在字符串 $s$ 中的位置。

当我们遍历到字符串 $t$ 中的字符 $t[i]$ 时，如果第 $t[i]$ 个列表为空，说明 $s$ 和 $t$ 的字符数量不匹配，显然无法通过操作将 $s$ 变为 $t$；否则，我们取出第 $t[i]$ 个列表的首个元素，它就是 $s[t_i]$。随后我们判断是否有**小于 $s[t_i]$ 的所有字符都出现在 $s[t_i]$ 右侧**，即遍历第 $0, 1, \cdots, s[t_i]-1$ 个列表，它们必须为空，或者首个元素大于 $s[t_i]$。在判断完成之后，如果满足要求，我们就将 $s[t_i]$ 从第 $t[i]$ 个列表中删除。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isTransformable(string s, string t) {
        int n = s.size();
        vector<queue<int>> pos(10);
        for (int i = 0; i < n; ++i) {
            pos[s[i] - '0'].push(i);
        }
        for (int i = 0; i < n; ++i) {
            int digit = t[i] - '0';
            if (pos[digit].empty()) {
                return false;
            }
            for (int j = 0; j < digit; ++j) {
                if (!pos[j].empty() && pos[j].front() < pos[digit].front()) {
                    return false;
                }
            }
            pos[digit].pop();
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isTransformable(String s, String t) {
        int n = s.length();
        Queue<Integer>[] pos = new Queue[10];
        for (int i = 0; i < 10; ++i) {
            pos[i] = new LinkedList<Integer>();
        }
        for (int i = 0; i < n; ++i) {
            pos[s.charAt(i) - '0'].offer(i);
        }
        for (int i = 0; i < n; ++i) {
            int digit = t.charAt(i) - '0';
            if (pos[digit].isEmpty()) {
                return false;
            }
            for (int j = 0; j < digit; ++j) {
                if (!pos[j].isEmpty() && pos[j].peek() < pos[digit].peek()) {
                    return false;
                }
            }
            pos[digit].poll();
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isTransformable(self, s: str, t: str) -> bool:
        n = len(s)
        pos = {i: collections.deque() for i in range(10)}
        for i, digit in enumerate(s):
            pos[int(digit)].append(i)
        
        for i, digit in enumerate(t):
            d = int(digit)
            if not pos[d]:
                return False
            if any(pos[j] and pos[j][0] < pos[d][0] for j in range(d)):
                return False
            pos[d].popleft()
        
        return True
```

**复杂度分析**

- 时间复杂度：$O(cn)$，其中 $n$ 是字符串 $s$ 和 $t$ 的长度，$c$ 为字符集大小，在本题中字符串只包含 $0 \sim 9$，因此 $c=10$。

- 时间复杂度：$O(n)$，记为存储 $c$ 个列表需要的空间。
