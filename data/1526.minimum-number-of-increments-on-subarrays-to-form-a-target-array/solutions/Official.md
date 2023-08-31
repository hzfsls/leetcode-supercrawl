## [1526.形成目标数组的子数组最少增加次数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-increments-on-subarrays-to-form-a-target-array/solutions/100000/xing-cheng-mu-biao-shu-zu-de-zi-shu-zu-zui-shao-ze)

#### 前言

相信看过本题各种参考代码的读者都会抱着复杂的心情：本题是第 31 场双周赛的最后一题，难度为 $\red{困难}$，但只需要五行代码，即：

> 求出数组 $\textit{target}$ 中相邻两元素的差值，保留大于 $0$ 的部分，累加即为答案。

**但如何证明这样做是正确的呢**？一种较为直观的证明方法，是通过类似「单调栈」的思路，从左向右考虑数组 $\textit{target}$ 中的每个数。对于 $\textit{target}[0]$，它最少需要操作的次数就为 $\textit{target}[0]$；而对于两个相邻的数 $\textit{target}[i]$ 和 $\textit{target}[i+1]$：

- 如果 $\textit{target}[i] \geq \textit{target}[i+1]$，那么在给 $\textit{target}[i]$ 增加 $1$ 时，可以顺便给 $\textit{target}[i+1]$ 增加 $1$，这样 $\textit{target}[i+1]$ 不会占用额外的操作次数；

- 如果 $\textit{target}[i] < \textit{target}[i+1]$，那么即使在给 $\textit{target}[i]$ 增加 $1$ 的同时顺便给 $\textit{target}[i+1]$ 增加 $1$，那么还需要 $\textit{target}[i+1] - \textit{target}[i]$ 次操作才能得到正确的结果。

这样我们可以得到最少的操作次数为：

$$
\textit{target}[0] + \sum_{i=0}^{n-2} \max \big\{ \textit{target}[i+1] - \textit{target}[i], 0 \big\}
$$

就完成了本题。

但对于本题来说，有一种非常严谨且可以得出操作方案的证明方法，即「差分数组」。下面从零开始对这种方法进行讲解。

#### 方法一：差分数组

**思路**

为了方便叙述，我们转记本题中的数组 $\textit{target}$ 为数组 $a$。

长度为 $n$ 的数组 $a[0 .. n-1]$ 的「差分数组」$d[0 .. n-1]$ 为：

$$
d[i] = \begin{cases}
a[i], & i = 0 \\
a[i] - a[i-1], & i > 0
\end{cases}
$$

例如当 $a = [1, 2, 3, 2, 1]$ 时，差分数组 $d = [1, 1, 1, -1, -1]$。

> **结论一**：数组 $d$ 的任意非空前缀和均大于等于零。
>
> **证明**：「差分数组」和「前缀和」数组有着密切的关系。事实上，「差分」和「前缀和」互为逆运算，即数组 $d$ 的前缀和数组就是数组 $a$：
> 
> $$
\begin{aligned}
a[i] &= (a[i] - a[i-1]) + (a[i-1] - a[i-2]) + \cdots + (a[1] - a[0]) + a[0] \\
&= d[i] + d[i-1] + \cdots + d[1] + d[0] \\
&= \sum_{k=0}^i d[k]
\end{aligned}
> $$
> 由于本题中数组 $a$ 中的元素都是正整数，因此结论得证。

> **推论一**：数组 $d$ 的元素之和大于等于零。
>
> **证明**：取 $i=n-1$ 即得证。

本题要求我们将一个初始元素均为零的数组进行若干次操作，得到数组 $a$，其中每一次操作可以将一个连续的子数组中的元素增加 $1$。显然，这个要求等价于从数组 $a$ 开始进行若干次操作，得到一个元素均为零的数组，每一次操作可以将一个连续的子数组中的元素减少 $1$。

在数组 $a$ 上进行操作时，会对它的差分数组 $d$ 产生什么影响呢？假设我们选择的子数组范围为 $[L, R]$，那么根据 $d$ 的定义：

- 若 $L=0$，由于 $a[0]$ 减少了 $1$，我们需要将 $d[0]$ 减少 $1$；

- 若 $L>0$，由于 $a[L]$ 减少了 $1$ 而 $a[L-1]$ 不变，我们需要将 $d[L]$ 减少 $1$；

- 若 $R+1 < n$，由于 $a[R]$ 减少了 $1$ 而 $a[R+1]$ 保持不变，我们需要将 $d[R+1]$ 增加 $1$；

- 若 $R+1 = n$，我们不需要进行任何操作。

这是因为 $[L, R]$ 外的元素保持不变，对应的差分值不变；$[L, R]$ 内的元素全部减少 $1$，对应的差分值也不变。变化的差分值只存在于边界处，**因此数组 $d$ 最多只会有两个元素的值发生变化**，其中一个减少 $1$，另一个增加 $1$。我们将其进行统一：

- $d[L]$ 减少 $1$；

- $d[R+1]$ 增加 $1$。当 $R+1=n$ 时，$d[n]$ 是一个我们「虚拟」出的数组元素，它相当于一个黑洞，会吸收所有的增加 $1$ 操作。

还是拿 $a = [1, 2, 3, 2, 1]$，$d = [1, 1, 1, -1, -1]$ 作为例子。当 $[L, R] = [1, 3]$ 时，数组 $a$ 和 $d$ 变为：

- $a = [1, 1, 2, 1, 1]$
- $d = [1, 0, 1, -1, 0]$

即 $d[L]=d[1]$ 减少 $1$，$d[R+1]=d[4]$ 增加 $1$。

而当 $[L, R] = [2, 4]$ 时，数组 $a$ 和 $d$ 变为：

- $a = [1, 2, 2, 1, 0]$
- $d = [1, 1, 0, -1, -1]$

即 $d[L]=d[2]$ 减少 $1$，$d[R+1]=d[5]$ 这个黑洞吸收了增加 $1$。

此时，**我们就将数组 $a$ 上对连续子数组的操作，完美转化成了数组 $d$ 上对两个元素的操作**。由于每一次操作中，我们最多只能将 $d$ 中的一个元素减少 $1$，而目标是将 $d$ 中的元素全部变成 $0$，因此我们至少需要将所有值为正的元素变成 $0$，也就是说，**操作次数的下界，等于数组 $d$ 中所有值为正的元素的和**：

$$
T = \sum_{i=0}^{n-1} \max \big\{ d[i], 0 \big\}
$$

这个下界是可以取到的吗？我们可以尝试构造出一种方法，使得恰好通过 $T$ 次操作，将数组 $d$ 的所有元素变成 $0$。

> **结论二**：如果数组 $d$ 中有值为负的元素 $d[R+1]$，那么一定存在 $0 \leq L \leq R$，使得 $d[L]$ 的值为正。
>
> **证明**：使用反证法，如果对于 $0 \leq L \leq R$ 均有 $d[L] \leq 0$，那么前缀和 $\sum\limits_{k=0}^{R+1} d[k] < 0$，与**结论一**相矛盾。

这样一来，我们可以进行若干次操作，每次操作可以找出一个满足 $d[R+1] < 0$ 的位置 $R+1$，以及一个满足 $d[L] > 0$ 且 $L \leq R$ 的位置 $L$，将 $d[L]$ 减少 $1$ 并将 $d[R+1]$ 增加 $1$，直到数组 $d$ 中没有值为负的元素。

根据**推论一**，此时数组 $d$ 中还剩下一些值为正的元素。我们继续进行若干次操作，每次操作可以找出一个满足 $d[L] > 0$ 的位置 $L$，并取 $R+1=n$，将 $d[L]$ 减少 $1$ 并将 $d[n]$ 这个黑洞增加 $1$，直到数组 $d$ 中没有值为正的元素。

此时，数组 $d$ 中所有的元素均为零。由于每次操作中，我们都将一个整数减少 $1$，因此操作次数恰好为 $T$。因此，最少的操作次数就等于

$$
\text{ans} = \sum_{i=0}^{n-1} \max \big\{ d[i], 0 \big\}
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minNumberOperations(vector<int>& target) {
        int n = target.size();
        int ans = target[0];
        for (int i = 1; i < n; ++i) {
            ans += max(target[i] - target[i - 1], 0);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minNumberOperations(int[] target) {
        int n = target.length;
        int ans = target[0];
        for (int i = 1; i < n; ++i) {
            ans += Math.max(target[i] - target[i - 1], 0);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minNumberOperations(self, target: List[int]) -> int:
        n = len(target)
        ans = target[0]
        for i in range(1, n):
            ans += max(target[i] - target[i - 1], 0)
        return ans
```

```C [sol1-C]
int minNumberOperations(int* target, int targetSize) {
    int ans = target[0];
    for (int i = 1; i < targetSize; ++i) {
        ans += fmax(target[i] - target[i - 1], 0);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{target}$ 的长度。

- 空间复杂度：$O(1)$。