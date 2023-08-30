#### 方法一：猜测结论 + 构造答案

**提示 $1$**

记 $\textit{cnt}[i]$ 表示字符串 $s[0..i]$ 的前缀和，其中左括号 $[$ 记为 $1$，右括号 $]$ 记为 $-1$。

如果所有的前缀和均大于等于 $0$，那么字符串 $s$ 就是平衡的。

**提示 $1$ 解释**

我们可以将求前缀和的过程看成使用栈处理字符串 $s$ 的过程。

我们对 $s$ 进行一次遍历，如果遍历到左括号，那么将其入栈。如果遍历到右括号，那么将栈顶的一个左括号与其匹配并弹出。

如果栈始终是合法的（即不会有遍历到右括号但栈顶没有左括号的情况），那么 $s$ 就是平衡的。如果遇到了不合法的情况，那么可以可能栈「欠了」一个左括号。所以 $\textit{cnt}$ 中每一个正数（以及 $0$）记录了遍历到当前位置的栈中包含的左括号数量，每一个负数记录了遍历到当前位置的栈欠着的左括号的个数的相反数。

因此，如果 $\textit{cnt}$ 中的所有元素均大于 $0$，说明栈没有欠过左括号，即字符串 $s$ 是平衡的。

**提示 $2$**

我们可以猜测一个结论：

> 设 $\textit{cnt}$ 中的最小值为 $\textit{cnt}[i]$，那么最少需要交换的次数为： 
>
> $$
> \lceil \frac{-\textit{cnt}[i]}{2} \rceil
> $$

其中 $\lceil x \rceil$ 表示将 $x$ 向上取整。

猜测这个结论的缘由是比较直观的：$\textit{cnt}[i]$ 表示遍历的过程中，栈最多欠了 $-\textit{cnt}[i]$ 个左括号。为了使得 $s$ 平衡，我们需要在此之前补上一些左括号，而补括号的唯一方法是将前面的右括号与后面的左括号进行交换，一次交换会使得 $\textit{cnt}[i]$ 的值增加 $2$（原先是右括号权值为 $-1$，现在是左括号权值为 $1$，变化量为 $2$），因此至少需要交换 $\lceil \dfrac{-\textit{cnt}[i]}{2} \rceil$ 次。

那么我们能否构造出一种交换 $\lceil \dfrac{-\textit{cnt}[i]}{2} \rceil$ 次的方法呢？由于我们希望每交换一次，$-\textit{cnt}[i]$ 的值减少 $2$，因此可以考虑使用数学归纳法：

- 当 $-\textit{cnt}[i] = 0$ 时，字符串 $s$ 是平衡的，需要交换的次数为 $0$；

- 假设当 $-\textit{cnt}[i] = k$ 时需要交换的次数与我们的猜测相符，那么当 $-\textit{cnt}[i] = k+2$ 时：

    - 我们记 $\textit{cnt}$ 中第一个负数的出现位置为 $\textit{first}$，那么 $s[\textit{first}]$ 一定是一个右括号；

    - 我们记 $\textit{cnt}$ 中最后一个负数的出现位置为 $\textit{last}$，那么 $\textit{last}$ 一定不为 $n-1$（因为 $s$ 中左右括号数量相同），并且 $s[\textit{last} + 1]$ 一定是一个左括号；

    - 我们交换 $s[\textit{first}]$ 与 $s[\textit{last} + 1]$。对于所有在 $[0, \textit{first} - 1] \cup [\textit{last} + 1, n-1)$ 范围内的下标，它们对应的 $\textit{cnt}$ 值均为不变（且均为非负数），对于所有在 $[\textit{first}, \textit{last}]$ 范围内的下标，它们对应的 $\textit{cnt}$ 值均增加了 $2$。由于所有的负数都在 $[\textit{first}, \textit{last}]$ 范围内，因此 $\textit{cnt}[i]$ 也会增加 $2$，那么我们通过一次交换就归纳到了 $-\textit{cnt}[i] = k$ 的情况。

- 需要注意的是，$-\textit{cnt}[i] = 1$ 的情况也会归纳到 $-\textit{cnt}[i] = 0$（而不是 $-\textit{cnt}[i] = -1$），这也是答案中包含上取整的来由。

我们通过数学归纳法给出了一种交换的构造，因此最少的交换次数即为 $\lceil \dfrac{-\textit{cnt}[i]}{2} \rceil$ 中的最小值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSwaps(string s) {
        int cnt = 0, mincnt = 0;
        for (char ch: s) {
            if (ch == '[') {
                cnt += 1;
            }
            else {
                cnt -= 1;
                mincnt = min(mincnt, cnt);
            }
        }
        return (-mincnt + 1) / 2;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSwaps(self, s: str) -> int:
        cnt = mincnt = 0
        for ch in s:
            if ch == '[':
                cnt += 1
            else:
                cnt -= 1
                mincnt = min(mincnt, cnt)
        return (-mincnt + 1) // 2
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。