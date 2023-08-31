## [1860.增长的内存泄露 中文官方题解](https://leetcode.cn/problems/incremental-memory-leak/solutions/100000/zeng-chang-de-nei-cun-xie-lu-by-leetcode-qqjd)

#### 方法一：模拟

**提示 $1$**

模拟程序消耗内存的过程。

**思路与算法**

我们用 $t$ 表示当前时刻，同时也是当前时刻程序会额外消耗内存的位数。为了模拟分配内存的过程，在 $t$ 时刻，我们首先判断是否有内存条可以满足当前的额外内存需求。此时有两种情况：

- 如果不存在，那么程序将意外退出，同时按要求返回对应的值组成的数组；

- 如果存在，我们按照要求寻找剩余内存较多的内存条（相同时则选择内存条 $1$），并将对应的 $\textit{memory}_1$ 或 $\textit{memory}_2$ 减去 $t$。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> memLeak(int memory1, int memory2) {
        int t = 1;
        while (t <= max(memory1, memory2)){   // 是否可分配
            if (memory1 < memory2){   // 分配给 2
                memory2 -= t;
            }
            else {   // 分配给 1
                memory1 -= t;
            }
            ++t;
        }
        return {t, memory1, memory2};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def memLeak(self, memory1: int, memory2: int) -> List[int]:
        t = 1
        while t <= max(memory1, memory2):   # 是否可分配
            if memory1 < memory2:   # 分配给 2
                memory2 -= t
            else:   # 分配给 1
                memory1 -= t
            t += 1
        return [t, memory1, memory2]
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{\textit{memory}_1 + \textit{memory}_2})$。

    假设 $t$ 为意外退出的时刻，那么两个内存条一定可以容纳 $t - 1$ 时刻及以前消耗的内存。因此我们有：

    $$
    \sum_{i = 1}^{t-1} i = \frac{t(t - 1)}{2} \le \textit{memory}_1 + \textit{memory}_2.
    $$

    亦即循环最多会进行 $O(\sqrt{\textit{memory}_1 + \textit{memory}_2})$ 次，而每次执行循环的时间复杂度为 $O(1)$。

- 空间复杂度：$O(1)$。