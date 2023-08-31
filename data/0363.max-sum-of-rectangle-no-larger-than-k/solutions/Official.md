## [363.矩形区域不超过 K 的最大数值和 中文官方题解](https://leetcode.cn/problems/max-sum-of-rectangle-no-larger-than-k/solutions/100000/ju-xing-qu-yu-bu-chao-guo-k-de-zui-da-sh-70q2)

#### 方法一：有序集合

**思路**

我们枚举矩形的上下边界，并计算出该边界内每列的元素和，则原问题转换成了如下一维问题：

> 给定一个整数数组和一个整数 $k$，计算该数组的最大区间和，要求区间和不超过 $k$。

定义长度为 $n$ 的数组 $a$ 的前缀和

$$
S_i =
\begin{cases} 
0&i=0\\
a_0+a_1+\cdots+a_{i-1}&1\le i\le n
\end{cases}
$$

则区间 $[l,r)$ 的区间和 $a_l+a_{l+1}+\cdots+a_{r-1}$ 可以表示为 $S_r-S_l$。

枚举 $r$，上述问题的约束 $S_r-S_l\le k$ 可以转换为 $S_l\ge S_r-k$。要使 $S_r-S_l$ 尽可能大，则需要寻找最小的满足 $S_l\ge S_r-k$ 的 $S_l$。我们可以在枚举 $r$ 的同时维护一个存储 $S_i\ (i<r)$ 的有序集合，则可以在 $O(\log n)$ 的时间内二分找到符合要求的 $S_l$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>> &matrix, int k) {
        int ans = INT_MIN;
        int m = matrix.size(), n = matrix[0].size();
        for (int i = 0; i < m; ++i) { // 枚举上边界
            vector<int> sum(n);
            for (int j = i; j < m; ++j) { // 枚举下边界
                for (int c = 0; c < n; ++c) {
                    sum[c] += matrix[j][c]; // 更新每列的元素和
                }
                set<int> sumSet{0};
                int s = 0;
                for (int v : sum) {
                    s += v;
                    auto lb = sumSet.lower_bound(s - k);
                    if (lb != sumSet.end()) {
                        ans = max(ans, s - *lb);
                    }
                    sumSet.insert(s);
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSumSubmatrix(int[][] matrix, int k) {
        int ans = Integer.MIN_VALUE;
        int m = matrix.length, n = matrix[0].length;
        for (int i = 0; i < m; ++i) { // 枚举上边界
            int[] sum = new int[n];
            for (int j = i; j < m; ++j) { // 枚举下边界
                for (int c = 0; c < n; ++c) {
                    sum[c] += matrix[j][c]; // 更新每列的元素和
                }
                TreeSet<Integer> sumSet = new TreeSet<Integer>();
                sumSet.add(0);
                int s = 0;
                for (int v : sum) {
                    s += v;
                    Integer ceil = sumSet.ceiling(s - k);
                    if (ceil != null) {
                        ans = Math.max(ans, s - ceil);
                    }
                    sumSet.add(s);
                }
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
import "math/rand"

type node struct {
    ch       [2]*node
    priority int
    val      int
}

func (o *node) cmp(b int) int {
    switch {
    case b < o.val:
        return 0
    case b > o.val:
        return 1
    default:
        return -1
    }
}

func (o *node) rotate(d int) *node {
    x := o.ch[d^1]
    o.ch[d^1] = x.ch[d]
    x.ch[d] = o
    return x
}

type treap struct {
    root *node
}

func (t *treap) _put(o *node, val int) *node {
    if o == nil {
        return &node{priority: rand.Int(), val: val}
    }
    if d := o.cmp(val); d >= 0 {
        o.ch[d] = t._put(o.ch[d], val)
        if o.ch[d].priority > o.priority {
            o = o.rotate(d ^ 1)
        }
    }
    return o
}

func (t *treap) put(val int) {
    t.root = t._put(t.root, val)
}

func (t *treap) lowerBound(val int) (lb *node) {
    for o := t.root; o != nil; {
        switch c := o.cmp(val); {
        case c == 0:
            lb = o
            o = o.ch[0]
        case c > 0:
            o = o.ch[1]
        default:
            return o
        }
    }
    return
}

func maxSumSubmatrix(matrix [][]int, k int) int {
    ans := math.MinInt64
    for i := range matrix { // 枚举上边界
        sum := make([]int, len(matrix[0]))
        for _, row := range matrix[i:] { // 枚举下边界
            for c, v := range row {
                sum[c] += v // 更新每列的元素和
            }
            t := &treap{}
            t.put(0)
            s := 0
            for _, v := range sum {
                s += v
                if lb := t.lowerBound(s - k); lb != nil {
                    ans = max(ans, s-lb.val)
                }
                t.put(s)
            }
        }
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
from sortedcontainers import SortedList

class Solution:
    def maxSumSubmatrix(self, matrix: List[List[int]], k: int) -> int:
        ans = float("-inf")
        m, n = len(matrix), len(matrix[0])

        for i in range(m):   # 枚举上边界
            total = [0] * n
            for j in range(i, m):   # 枚举下边界
                for c in range(n):
                    total[c] += matrix[j][c]   # 更新每列的元素和
                
                totalSet = SortedList([0])
                s = 0
                for v in total:
                    s += v
                    lb = totalSet.bisect_left(s - k)
                    if lb != len(totalSet):
                        ans = max(ans, s - totalSet[lb])
                    totalSet.add(s)

        return ans
```

**复杂度分析**

- 时间复杂度：$O(m^2n\log n)$。其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。

- 空间复杂度：$O(n)$。

#### 进阶问题

对于行数远大于列数的情况，枚举矩形的左右边界更优，对应的时间复杂度为 $O(n^2m\log m)$。

总之，根据 $m$ 和 $n$ 的大小来细化枚举策略，我们可以做到 $O(\min(m,n)^2\max(m,n)\log\max(m,n))$ 的时间复杂度。

---
# [📚 好读书？读好书！让时间更有价值| 世界读书日](https://leetcode-cn.com/circle/discuss/12QtuI/)
4 月 22 日至 4 月 28 日，进入「[学习](https://leetcode-cn.com/leetbook/)」，完成页面右上角的「让时间更有价值」限时阅读任务，可获得「2021 读书日纪念勋章」。更多活动详情戳上方标题了解更多👆
#### 今日学习任务：
- 理解多态的概念
[完成阅读 2.4 多态让消息的发送方法通用](https://leetcode-cn.com/leetbook/read/how-objects-work/o1dk4g/)
- 理解结构化编程
[完成阅读 3.5 重视易懂性的结构化编程](https://leetcode-cn.com/leetbook/read/how-objects-work/oy2zle/)

