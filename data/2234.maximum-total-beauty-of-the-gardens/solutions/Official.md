## [2234.花园的最大总美丽值 中文官方题解](https://leetcode.cn/problems/maximum-total-beauty-of-the-gardens/solutions/100000/hua-yuan-de-zui-da-zong-mei-li-zhi-by-le-18d8)

#### 方法一：枚举「完善」和「不完善」的分界线

**思路与算法**

从贪心的角度，我们首先可以发现，最优的方案一定具有如下的形式：

> 我们选择数组 $\textit{flowers}$ 中最大的若干个元素，将它们加到至少 $\textit{target}$ 朵花，成为「完善」的花园；对于剩余的花朵，我们将它们加入 $\textit{flowers}$ 剩余的元素中，使得最终最小的元素尽可能大。

证明的方法也很简单，假设数组 $\textit{flowers}$ 中有两个元素 $x, y$ 满足 $x > y$，我们一定是优先将 $x$ 加到 $\textit{target}$ 的。这里可以使用反正 + 构造法，如果我们优先将 $y$ 加到 $\textit{target}$，那么添加的花朵数 $\textit{target} - y$ 可以拆分成 $\textit{target} - x$ 以及 $x - y$ 这两部分之和，我们将前者添加到 $x$ 中，后者添加到 $y$ 中，这样最终同样得到了 $\textit{target}$ 和 $x$。因此优先将更大的元素加到 $\textit{target}$ 一定是优的。

因此我们可以将 $\textit{flowers}$ 首先进行降序排序。记其长度为 $n$，这样一来，我们可以枚举「完善」和「不完善」的分界线 $i$，表示将 $[0, i)$ 变成完善的花园，$[i, n)$ 为不完善的花园。

对于完善的部分，我们需要添加的花朵数量为：

$$
\textit{target} \cdot i - \sum_{k=0}^{i-1} \textit{flowers}[k] \tag{1}
$$

这个值需要小于等于 $\textit{newFlowers}$。如果我们递增枚举 $i$，那么 $(1)$ 式中的求和部分就是一个前缀和，我们可以很方便地进行维护。

记剩余可以添加的花的数目为 $\textit{rest}$，有 $\textit{rest} = \textit{newFlowers} - (1)$。我们需要找到一个严格小于 $\textit{target}$ 的值，使得将所有剩余的花园的花的数量添加到至少为这个值时，添加的花朵总数小于等于 $\textit{rest}$。我们可以将寻找这个值的过程分成两部分：第一步我们保证这个值一定在 $\textit{flowers}[i .. n-1]$ 中出现，第二步我们再在这个值的基础上继续添加花朵。也就是说，我们需要找到一个下标 $j$ 满足：

$$
\textit{flowers}[j] \cdot (n-j) - \sum_{k=j}^{n-1} \textit{flower}[k] \leq \textit{rest} \tag{2}
$$

并且：

$$
\textit{flowers}[j-1] \cdot (n-j+1) - \sum_{k=j-1}^{n-1} \textit{flower}[k] > \textit{rest}
$$

即我们需要找出的这个值在 $\big[\textit{flowers}[j], \textit{flowers}[j-1]\big)$ 的范围内，因此我们就可以首先保证所有剩余的花园的花的数量都至少为 $\textit{flowers}[j]$，再继续对下标为 $[j, n)$ 的花园平均地添加花朵，直到所有的花朵用完。在这一步中，下标为 $[i, j)$ 的花园是不变的。

当我们递增地枚举 $i$ 时，$\textit{rest}$ 是单调递减的，因此我们可以使用一个不断向右移动的指针来维护 $j$：即当 $i$ 递增后，我们需要不断增加 $j$，直到 $(2)$ 成立。在 $j$ 递增的过程中，$(2)$ 式中的求和部分是一个后缀和，我们可以很方便地进行维护。

当我们得到了当前的 $i$ 对应的 $j$ 之后，我们需要将 $\textit{rest}$ 减去 $(2)$ 式左侧的值。下标为 $[j, n)$ 的花园的数量为 $n-j$，因此我们还可以给每个花园添加 $\lfloor \dfrac{\textit{rest}}{n-j} \rfloor$ 朵花，其中 $\lfloor \cdot \rfloor$ 表示向下取整。

此时我们就能计算美丽值了。即为：

$$
\textit{full} \cdot i + \textit{partial} \cdot \left( \min\left\{ \textit{flowers}[j] + \lfloor \frac{\textit{rest}}{n-j} \rfloor, \textit{target} - 1 \right\} \right)
$$

**细节**

本题中没有规定 $\textit{flowers}$ 中的元素初始时一定小于等于 $\textit{target}$，因此我们可以在一开始对其进行一次遍历，把所有大于 $\textit{target}$ 的元素都减小为 $\textit{target}$。这样做也是合理的，显然我们没有必要给已经完善的花园再添加花朵。

同时在枚举 $i$ 时，我们需要保证 $[i, n)$ 对应的元素都严格小于 $\textit{target}$，否则它们就不是不完善的了。由于数组已经按照降序排序，我们只需要验证是否有 $\textit{flowers}[i] \neq \textit{target}$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long maximumBeauty(vector<int>& flowers, long long newFlowers, int target, int full, int partial) {
        int n = flowers.size();
        for (int& x: flowers) {
            x = min(x, target);
        }
        sort(flowers.begin(), flowers.end(), greater<int>());
        long long sum = accumulate(flowers.begin(), flowers.end(), 0LL);
        long long ans = 0;
        if (static_cast<long long>(target) * n - sum <= newFlowers) {
            ans = static_cast<long long>(full) * n;
        }

        long long pre = 0;
        int ptr = 0;
        for (int i = 0; i < n; ++i) {
            if (i != 0) {
                pre += flowers[i - 1];
            }
            if (flowers[i] == target) {
                continue;
            }
            long long rest = newFlowers - (static_cast<long long>(target) * i - pre);
            if (rest < 0) {
                break;
            }
            while (!(ptr >= i && static_cast<long long>(flowers[ptr]) * (n - ptr) - sum <= rest)) {
                sum -= flowers[ptr];
                ++ptr;
            }
            rest -= static_cast<long long>(flowers[ptr]) * (n - ptr) - sum;
            ans = max(ans, static_cast<long long>(full) * i + static_cast<long long>(partial) * (min(flowers[ptr] + rest / (n - ptr), static_cast<long long>(target) - 1)));
        }

        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximumBeauty(self, flowers: List[int], newFlowers: int, target: int, full: int, partial: int) -> int:
        n = len(flowers)
        flowers = sorted([min(x, target) for x in flowers], reverse=True)
        total = sum(flowers)
        ans = 0
        
        if target * n - total <= newFlowers:
            ans = full * n
        
        pre = ptr = 0
        for i in range(n):
            if i != 0:
                pre += flowers[i - 1]
            if flowers[i] == target:
                continue
            
            rest = newFlowers - (target * i - pre)
            if rest < 0:
                break
            
            while not (ptr >= i and flowers[ptr] * (n - ptr) - total <= rest):
                total -= flowers[ptr]
                ptr += 1
            
            rest -= flowers[ptr] * (n - ptr) - total
            ans = max(ans, full * i + partial * (min(flowers[ptr] + rest // (n - ptr), target - 1)))
    
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。

- 空间复杂度：$O(\log n)$，即为排序需要的栈空间。