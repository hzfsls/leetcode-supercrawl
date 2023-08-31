## [1986.完成任务的最少工作时间段 中文官方题解](https://leetcode.cn/problems/minimum-number-of-work-sessions-to-finish-the-tasks/solutions/100000/wan-cheng-ren-wu-de-zui-shao-gong-zuo-sh-tl0p)
#### 方法一：枚举子集的动态规划

**思路与算法**

我们用 $f[\textit{mask}]$ 表示当选择任务的状态为 $\textit{mask}$ 时，最少需要的工作时间段。其中 $\textit{mask}$ 是一个长度为 $n$ 的二进制表示，$\textit{mask}$ 从低到高的第 $i$ 位为 $1$ 表示第 $i$ 个任务已经完成，$0$ 表示第 $i$ 个任务未完成。

在进行状态转移时，我们可以枚举最后一个工作时间段完成了哪些任务。显然，这些任务对应的状态 $\textit{subset}$ 一定是 $\textit{mask}$ 的一个子集。

> 这里「子集」的含义为：$\textit{subset}$ 是 $\textit{mask}$ 的一个子集，当且仅当 $\textit{subset}$ 中任意的 $1$ 在 $\textit{mask}$ 中的对应位置均为 $1$。

这样一来，我们就可以写出状态转移方程：

$$
f[\textit{mask}] = \min_{\textit{subset} \subset \textit{mask}} \{ f[\textit{mask} \backslash \textit{subset}] + 1 \}
$$

其中 $\textit{mask} \backslash \textit{subset}$ 表示将 $\textit{subset}$ 中的所有 $1$ 从 $\textit{mask}$ 中移除后的二进制表示，可以使用按位异或运算求出。

需要注意的是，$\textit{subset}$ 中包含的任务的工作时间总和不能大于 $\textit{sessionTime}$。因此在动态规划之前，我们可以进行预处理，即在 $[1, 2^n)$ 的范围内枚举每一个二进制表示 $\textit{mask}$，计算其如果包含的任务的工作时间总和。如果其小于等于 $\textit{sessionTime}$，那么将 $\textit{valid}[\textit{mask}]$ 标记为 $\text{True}$，否则标记为 $\text{False}$。这样在动态规划时，我们就不需要再计算 $\textit{subset}$ 是否满足要求了。

动态规划的边界条件为 $f[0] = 0$，最终的答案即为 $f[2^n - 1]$。

**细节**

枚举 $\textit{mask}$ 的子集有一个经典的小技巧，对应的伪代码如下：

```
subset = mask
while subset != 0 do
    // subset 是 mask 的一个子集，可以用其进行状态转移
    ...
    // 使用按位与运算在 O(1) 的时间快速得到下一个（即更小的）mask 的子集
    subset = (subset - 1) & mask
end while
```

使用该技巧的动态规划的时间复杂度为 $O(3^n)$。由于长度为 $n$ 且包含 $k$ 个 $1$ 的二进制表示有 $\dbinom{n}{k}$ 个，其有 $2^k$ 个子集。动态规划的时间复杂度即为每个二进制表示的子集个数之和：

$$
\sum_{k=0}^n \binom{n}{k} 2^k
$$

它就是 $3^n$ 的二项式展开：

$$
3^n = (2+1)^n = \sum_{k=0}^n \binom{n}{k} 2^k 1^{n-k}
$$

因此时间复杂度为 $O(3^n)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSessions(vector<int>& tasks, int sessionTime) {
        int n = tasks.size();
        vector<int> valid(1 << n);
        for (int mask = 1; mask < (1 << n); ++mask) {
            int needTime = 0;
            for (int i = 0; i < n; ++i) {
                if (mask & (1 << i)) {
                    needTime += tasks[i];
                }
            }
            if (needTime <= sessionTime) {
                valid[mask] = true;
            }
        }

        vector<int> f(1 << n, INT_MAX / 2);
        f[0] = 0;
        for (int mask = 1; mask < (1 << n); ++mask) {
            for (int subset = mask; subset; subset = (subset - 1) & mask) {
                if (valid[subset]) {
                    f[mask] = min(f[mask], f[mask ^ subset] + 1);
                }
            }
        }
        return f[(1 << n) - 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSessions(self, tasks: List[int], sessionTime: int) -> int:
        n = len(tasks)
        valid = [False] * (1 << n)
        for mask in range(1, 1 << n):
            needTime = 0
            for i in range(n):
                if mask & (1 << i):
                    needTime += tasks[i]
            if needTime <= sessionTime:
                valid[mask] = True

        f = [float("inf")] * (1 << n)
        f[0] = 0
        for mask in range(1, 1 << n):
            subset = mask
            while subset:
                if valid[subset]:
                    f[mask] = min(f[mask], f[mask ^ subset] + 1)
                subset = (subset - 1) & mask
        
        return f[(1 << n) - 1]
```

**复杂度分析**

- 时间复杂度：$O(3^n)$。

- 空间复杂度：$O(2^n)$，即为预处理的数组 $\textit{valid}$ 以及动态规划的数组 $f$ 需要使用的空间。

#### 方法二：存储两个值的动态规划

**思路与算法**

我们也可以无需枚举子集，使用普通的状态压缩动态规划解决本题。

我们用 $f[\textit{mask}]$ 存储两个值 $(\textit{segment}, \textit{current})$，其中 $\textit{segment}$ 表示我们使用了 $\textit{segment}$ 个工作时间段，$\textit{current}$ 表示最后一个工作时间段已经使用的时间为 $\textit{current}$。

此时，在进行状态转移时，我们只需要枚举 $\textit{mask}$ 中的某一个任务即可。这个任务 $i$ 作为最后一个执行的任务，并且根据 $f[\textit{mask} \backslash i]$ 中存储的两个值，决定「沿用最后一个工作时间段」还是「开始一个新的工作时间段」，状态转移方程为：

$$
f[\textit{mask}] = \min_{i \in \textit{mask}} \{ f[\textit{mask} \backslash i] + \textit{tasks}[i] \}
$$

对于上述的状态转移方程，我们需要解决两个问题：

- 如何计算 $f[\textit{mask} \backslash i] + \textit{tasks}[i]$；

- 如何定义 $\min$。

对于第一个问题，记 $f[\textit{mask} \backslash i] = (\textit{segment}_i, \textit{current}_i)$：

- 如果 $\textit{current}_i + \textit{tasks}[i] \leq \textit{sessionTime}$，那么第 $i$ 个任务可以沿用最后一个工作时间段，即：

    $$
    f[\textit{mask} \backslash i] + \textit{tasks}[i] = (\textit{segment}_i, \textit{current}_i + \textit{tasks}[i])
    $$

- 如果 $\textit{current}_i + \textit{tasks}[i] > \textit{sessionTime}$，那么第 $i$ 个任务可以必须开始一个新的工作时间段，即：

    $$
    f[\textit{mask} \backslash i] + \textit{tasks}[i] = (\textit{segment}_i + 1, \textit{tasks}[i])
    $$

对于第二个问题，显然 $\textit{segment}$ 越小越优，当 $\textit{segment}$ 相同时，$\textit{current}$ 越小越优，因此我们按照 $\textit{segment}$ 为第一关键字，$\textit{current}$ 为第二关键字取最小值即可。

动态规划的边界条件为 $f[0] = (1, 0)$，最终的答案即为 $f[2^n - 1]$ 中的 $\textit{segment}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minSessions(vector<int>& tasks, int sessionTime) {
        int n = tasks.size();
        vector<pair<int, int>> f(1 << n, {INT_MAX, INT_MAX});
        f[0] = {1, 0};
        
        auto add = [&](const pair<int, int>& o, int x) -> pair<int, int> {
            if (o.second + x <= sessionTime) {
                return {o.first, o.second + x};
            }
            return {o.first + 1, x};
        };
        
        for (int mask = 1; mask < (1 << n); ++mask) {
            for (int i = 0; i < n; ++i) {
                if (mask & (1 << i)) {
                    f[mask] = min(f[mask], add(f[mask ^ (1 << i)], tasks[i]));
                }
            }
        }
        return f[(1 << n) - 1].first;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def minSessions(self, tasks: List[int], sessionTime: int) -> int:
        n = len(tasks)
        f = [(float("inf"), float("inf"))] * (1 << n)
        f[0] = (1, 0)

        def add(o: Tuple[int, int], x: int) -> Tuple[int, int]:
            if o[1] + x <= sessionTime:
                return o[0], o[1] + x
            return o[0] + 1, x
        
        for mask in range(1, 1 << n):
            for i in range(n):
                if mask & (1 << i):
                    f[mask] = min(f[mask], add(f[mask ^ (1 << i)], tasks[i]))
        
        return f[(1 << n) - 1][0]
```

**复杂度分析**

- 时间复杂度：$O(n \cdot 2^n)$。状态的数量为 $2^n$，对于每一个状态，我们需要 $O(n)$ 的时间进行转移。

- 空间复杂度：$O(2^n)$，即为动态规划的数组 $f$ 需要使用的空间。