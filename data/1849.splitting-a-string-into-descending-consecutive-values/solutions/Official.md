## [1849.将字符串拆分为递减的连续值 中文官方题解](https://leetcode.cn/problems/splitting-a-string-into-descending-consecutive-values/solutions/100000/jiang-zi-fu-chuan-chai-fen-wei-di-jian-d-ggl2)

#### 方法一：枚举第一个子字符串

**提示 $1$**

事实上，如果我们确定了第一个子字符串，那么后续子字符串应有的数值也被唯一确定。

**提示 $2$**

我们用 $s[i:j]$ 表示字符串 $s$ 从位置 $i$ 开始到位置 $j$ 结束（包含位置 $i$ 和 $j$ 的字符）的子字符串。

对于一个子字符串 $s[i:j]$，当 $i$ 固定时，增大 $j$，字符串对应的数值要么变大要么不变。

**提示 $2$ 解释**

假设 $s[i:j]$ 对应的数值为 $x$，$s[j]$ 对应的数值为 $y$，那么 $s[i:j+1]$ 对应的数值为 $10x + y \ge x$。

其中，等号当且仅当 $x = y = 0$ 时取到。

**思路与算法**

基于**提示 $1$**，我们只需要枚举第一个子字符串并计算对应的初始值，然后循环验证后续的子字符串是否可以构成相应的递减数列即可。

同时，基于**提示 $2$**，当我们确定字符串的左边界并增长右边界时，对应子串的数值不会减少。而保持不变的情况当且仅当这些子串全部由 $\texttt{`0'}$ 构成。

我们用 $\textit{start}$ 表示第一个子字符串对应的初始值，在枚举 $\textit{start}$ 后遍历字符串。如果上一个拆分出的字符串对应的数值为 $\textit{pval}$，那么当前拆分出的字符串数值 $\textit{cval}$ 必须满足 $\textit{cval} = \textit{pval} - 1$。根据 $\textit{pval}$ 的值不同，我们需要考虑两种情况：

- 第一种情况，$\textit{pval} > 1$，此时 $\textit{cval} > 0$。根据**提示 $2$**，拆分位置唯一，我们只需要判断拆分位置是否存在即可。

- 第二种情况，$\textit{pval} = 1$，此时 $\textit{cval} = 0$。由于我们无法拆分出负数，因此字符串的剩余部分必须全部由 $\texttt{`0'}$ 构成，否则分割不符合要求。

最后，由于字符串长度上限为 $20$，而对于 $\texttt{C++}$ 等语言，其内置的 $64$ 位整数的上限大约在 $10^{18}$ 左右，如果对初始值不加限制可能会导致溢出 $64$ 位整数的情况发生。实际上，由于字符串至少会被拆分成两个子串，因此在符合要求的情况下，初始值不会超过 $10^{10}$（此时也超过了 $32$ 位整数的上限）。对此，我们在枚举的时候需要对子串数值进行相应的约束。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool splitString(string s) {
        long long start = 0;
        long long INF = 1e10; // 子串对应数值的上限
        int n = s.size();
        // 枚举第一个子字符串对应的初始值
        // 第一个子字符串不能包含整个字符串
        for (int i = 0; i < n - 1 && start < INF; ++i){
            start = start * 10 + (s[i] - '0');
            // 循环验证当前的初始值是否符合要求
            long long pval = start;
            long long cval = 0;
            int cidx = i + 1;
            for (int j = i + 1; j < n && cval < INF; ++j){
                if (pval == 1){
                    // 如果上一个值为 1，那么剩余字符串对应的数值只能为 0
                    if (all_of(s.begin() + cidx, s.end(), [](char c){ return c == '0'; })){
                        return true;
                    }
                    else{
                        break;
                    }
                }
                cval = cval * 10 + (s[j] - '0');
                if (cval > pval - 1){
                    // 不符合要求，提前结束
                    break;
                }
                else if (cval == pval - 1){
                    if (j + 1 == n){
                        // 已经遍历到末尾
                        return true;
                    }
                    pval = cval;
                    cval = 0;
                    cidx = j + 1;
                }
            }
        }
        return false;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def splitString(self, s: str) -> bool:
        n = len(s)
        start = 0
        # 枚举第一个子字符串对应的初始值
        # 第一个子字符串不能包含整个字符串
        for i in range(n - 1):
            start = 10 * start + int(s[i])
            # 循环验证当前的初始值是否符合要求
            pval = start
            cval = 0
            cidx = i + 1
            for j in range(i + 1, n):
                if pval == 1:
                    # 如果上一个值为 1，那么剩余字符串对应的数值只能为 0
                    if all(s[k] == '0' for k in range(cidx, n)):
                        return True
                    else:
                        break
                cval = 10 * cval + int(s[j])
                if cval > pval - 1:
                    # 不符合要求，提前结束
                    break
                elif cval == pval - 1:
                    if j + 1 == n:
                        # 已经遍历到末尾
                        return True
                    pval = cval
                    cval = 0
                    cidx = j + 1     
        return False
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为字符串的长度。我们总共需要枚举的次数为 $O(n)$；每次枚举最坏需要遍历整个字符串，花费 $O(n)$ 的时间。

- 空间复杂度：$O(1)$。