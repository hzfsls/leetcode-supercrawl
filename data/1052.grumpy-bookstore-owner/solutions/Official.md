## [1052.爱生气的书店老板 中文官方题解](https://leetcode.cn/problems/grumpy-bookstore-owner/solutions/100000/ai-sheng-qi-de-shu-dian-lao-ban-by-leetc-dloq)

#### 方法一：滑动窗口

假设数组 $\textit{customers}$ 和 $\textit{grumpy}$ 的长度是 $n$，不使用秘密技巧时，满意的顾客数量是 $\textit{total}$，则 $\textit{total}$ 的值为：

$$
\textit{total}=\sum\limits_{i=0}^{n-1} \textit{customers}[i] \times \mathbb{I}(\textit{grumpy}[i]=0)
$$

其中 $\mathbb{I}(\textit{grumpy}[i]=0)$ 为示性函数，当 $\textit{grumpy}[i]=0$ 时 $\mathbb{I}(\textit{grumpy}[i]=0)=1$，当 $\textit{grumpy}[i]=1$ 时 $\mathbb{I}(\textit{grumpy}[i]=0)=0$。

秘密技巧的效果是，找到数组 $\textit{grumpy}$ 的一个长度为 $\textit{minutes}$ 的子数组，使得该子数组中的元素都变成 $0$，数组 $\textit{customers}$ 的对应下标范围的子数组中的所有顾客都变成满意的。如果对下标范围 $[i-\textit{minutes}+1,i]$ 的子数组使用秘密技巧时（其中 $i \ge \textit{minutes}-1$），增加的满意顾客的数量是 $\textit{increase}_i$，则 $\textit{increase}_i$ 的值为：

$$
\textit{increase}_i=\sum\limits_{j=i-\textit{minutes}+1}^i \textit{customers}[j] \times \mathbb{I}(\textit{grumpy}[j]=1)
$$

其中 $\mathbb{I}(\textit{grumpy}[j]=1)$ 为示性函数，当 $\textit{grumpy}[j]=1$ 时 $\mathbb{I}(\textit{grumpy}[j]=1)=1$，当 $\textit{grumpy}[j]=0$ 时 $\mathbb{I}(\textit{grumpy}[j]=1)=0$。由于 $\textit{grumpy}[j]$ 的值只能是 $1$ 或 $0$，因此 $\mathbb{I}(\textit{grumpy}[j]=1)=\textit{grumpy}[j]$，$\textit{increase}_i$ 的值可以表示成如下形式：

$$
\textit{increase}_i=\sum\limits_{j=i-\textit{minutes}+1}^i \textit{customers}[j] \times \textit{grumpy}[j]
$$

为了让满意的顾客数量最大化，应该找到满足 $\textit{minutes}-1 \le i<n$ 的下标 $i$，使得 $\textit{increase}_i$ 的值最大。

注意到当 $i>\textit{minutes}-1$ 时，将 $i$ 替换成 $i-1$，可以得到 $\textit{increase}_{i-1}$ 的值为：

$$
\textit{increase}_{i-1}=\sum\limits_{j=i-\textit{minutes}}^{i-1} \textit{customers}[j] \times \textit{grumpy}[j]
$$

将 $\textit{increase}_i$ 和 $\textit{increase}_{i-1}$ 相减，可以得到如下关系：

$$
\begin{aligned}
&\quad \ \textit{increase}_i-\textit{increase}_{i-1} \\
&= \textit{customers}[i] \times \textit{grumpy}[i]-\textit{customers}[i-\textit{minutes}] \times \textit{grumpy}[i-\textit{minutes}]
\end{aligned}
$$

整理得到：

$$
\begin{aligned}
&\quad \ \textit{increase}_i \\
&=\textit{increase}_{i-1}-\textit{customers}[i-\textit{minutes}] \times \textit{grumpy}[i-\textit{minutes}]+\textit{customers}[i] \times \textit{grumpy}[i]
\end{aligned}
$$

上述过程可以看成维护一个长度为 $\textit{minutes}$ 的滑动窗口。当滑动窗口从下标范围 $[i-\textit{minutes},i-1]$ 移动到下标范围 $[i-\textit{minutes}+1,i]$ 时，下标 $i-\textit{minutes}$ 从窗口中移出，下标 $i$ 进入到窗口内。

利用上述关系，可以在 $O(1)$ 的时间内通过 $\textit{increase}_{i-1}$ 得到 $\textit{increase}_i$。

由于长度为 $\textit{minutes}$ 的子数组的最小结束下标是 $\textit{minutes}-1$，因此第一个长度为 $\textit{minutes}$ 的子数组对应的 $\textit{increase}$ 的值为 $\textit{increase}_{\textit{minutes}-1}$，需要通过遍历数组 $\textit{customers}$ 和 $\textit{grumpy}$ 的前 $\textit{minutes}$ 个元素计算得到。从 $\textit{increase}_\textit{minutes}$ 到 $\textit{increase}_{n-1}$ 的值则可利用上述关系快速计算得到。只需要遍历数组 $\textit{customers}$ 和 $\textit{grumpy}$ 各一次即可得到 $\textit{minutes} \le i<n$ 的每个 $\textit{increase}_i$ 的值，时间复杂度是 $O(n)$。

又由于计算初始的 $\textit{total}$ 的值需要遍历数组 $\textit{customers}$ 和 $\textit{grumpy}$ 各一次，因此整个过程只需要遍历数组 $\textit{customers}$ 和 $\textit{grumpy}$ 各两次，时间复杂度是 $O(n)$。

在上述过程中维护增加的满意顾客的最大数量，记为 $\textit{maxIncrease}$，则满意顾客的最大总数是 $\textit{total}+\textit{maxIncrease}$。

<![ppt1](https://assets.leetcode-cn.com/solution-static/1052/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/1052/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/1052/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/1052/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/1052/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/1052/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/1052/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/1052/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/1052/9.png)>

```Java [sol1-Java]
class Solution {
    public int maxSatisfied(int[] customers, int[] grumpy, int minutes) {
        int total = 0;
        int n = customers.length;
        for (int i = 0; i < n; i++) {
            if (grumpy[i] == 0) {
                total += customers[i];
            }
        }
        int increase = 0;
        for (int i = 0; i < minutes; i++) {
            increase += customers[i] * grumpy[i];
        }
        int maxIncrease = increase;
        for (int i = minutes; i < n; i++) {
            increase = increase - customers[i - minutes] * grumpy[i - minutes] + customers[i] * grumpy[i];
            maxIncrease = Math.max(maxIncrease, increase);
        }
        return total + maxIncrease;
    }
}
```

```JavaScript [sol1-JavaScript]
var maxSatisfied = function(customers, grumpy, minutes) {
    let total = 0;
    const n = customers.length;
    for (let i = 0; i < n; i++) {
        if (grumpy[i] === 0) {
            total += customers[i];
        }
    }
    let increase = 0;
    for (let i = 0; i < minutes; i++) {
        increase += customers[i] * grumpy[i];
    }
    let maxIncrease = increase;
    for (let i = minutes; i < n; i++) {
        increase = increase - customers[i - minutes] * grumpy[i - minutes] + customers[i] * grumpy[i];
        maxIncrease = Math.max(maxIncrease, increase);
    }
    return total + maxIncrease;
};
```

```go [sol1-Golang]
func maxSatisfied(customers []int, grumpy []int, minutes int) int {
    total := 0
    n := len(customers)
    for i := 0; i < n; i++ {
        if grumpy[i] == 0 {
            total += customers[i]
        }
    }
    increase := 0
    for i := 0; i < minutes; i++ {
        increase += customers[i] * grumpy[i]
    }
    maxIncrease := increase
    for i := minutes; i < n; i++ {
        increase = increase - customers[i-minutes]*grumpy[i-minutes] + customers[i]*grumpy[i]
        maxIncrease = max(maxIncrease, increase)
    }
    return total + maxIncrease
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def maxSatisfied(self, customers: List[int], grumpy: List[int], minutes: int) -> int:
        n = len(customers)
        total = sum(c for c, g in zip(customers, grumpy) if g == 0)
        maxIncrease = increase = sum(c * g for c, g in zip(customers[:minutes], grumpy[:minutes]))
        for i in range(minutes, n):
            increase += customers[i] * grumpy[i] - customers[i - minutes] * grumpy[i - minutes]
            maxIncrease = max(maxIncrease, increase)
        return total + maxIncrease
```

```C++ [sol1-C++]
class Solution {
public:
    int maxSatisfied(vector<int>& customers, vector<int>& grumpy, int minutes) {
        int total = 0;
        int n = customers.size();
        for (int i = 0; i < n; i++) {
            if (grumpy[i] == 0) {
                total += customers[i];
            }
        }
        int increase = 0;
        for (int i = 0; i < minutes; i++) {
            increase += customers[i] * grumpy[i];
        }
        int maxIncrease = increase;
        for (int i = minutes; i < n; i++) {
            increase = increase - customers[i - minutes] * grumpy[i - minutes] + customers[i] * grumpy[i];
            maxIncrease = max(maxIncrease, increase);
        }
        return total + maxIncrease;
    }
};
```

```C [sol1-C]
int maxSatisfied(int* customers, int customersSize, int* grumpy, int grumpySize, int minutes) {
    int total = 0;
    int n = customersSize;
    for (int i = 0; i < n; i++) {
        if (grumpy[i] == 0) {
            total += customers[i];
        }
    }
    int increase = 0;
    for (int i = 0; i < minutes; i++) {
        increase += customers[i] * grumpy[i];
    }
    int maxIncrease = increase;
    for (int i = minutes; i < n; i++) {
        increase = increase - customers[i - minutes] * grumpy[i - minutes] + customers[i] * grumpy[i];
        maxIncrease = fmax(maxIncrease, increase);
    }
    return total + maxIncrease;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{customers}$ 和 $\textit{grumpy}$ 的长度。需要对两个数组各遍历两次。

- 空间复杂度：$O(1)$。