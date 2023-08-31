## [1987.不同的好子序列数目 中文官方题解](https://leetcode.cn/problems/number-of-unique-good-subsequences/solutions/100000/bu-tong-de-hao-zi-xu-lie-shu-mu-by-leetc-ej2n)

#### 方法一：动态规划

**思路与算法**

我们用 $f[i][0]$ 和 $f[i][1]$ 分别表示使用字符串 $\textit{binary}$ 的第 $0, 1, \cdots, i$ 个字符，可以构造出的以 $0/1$ 结尾的不同的好子序列的数目。由于「好子序列」不能包含前导 $0$，但本身可以为 $0$，那么我们可以规定「好子序列」必须以 $1$ 开始并求出答案，如果 $\textit{binary}$ 中包含 $0$ 就再对答案增加 $1$。这样做可以避免处理复杂的前导 $0$ 规则。

在进行状态转移时，我们可以考虑第 $i$ 个字符是 $0$ 还是 $1$：

- 如果第 $i$ 个字符是 $1$，那么以 $0$ 结尾的不同的好子序列的数目不会改变，即：

    $$
    f[i][0] = f[i - 1][0]
    $$

    难点在于如何通过已经求得结果的状态求出 $f[i][1]$ 的值。我们可以将以 $0/1$ 结尾的不同的好子序列的数目分成三类，使用容斥原理进行计算：

    - 用 $\textit{binary}$ 的第 $0, 1, \cdots, i-1$ 个字符可以构造出的以 $1$ 结尾的不同好子序列，记为 $A$ 类。显然，$A$ 类的方案数是 $f[i-1][1]$；

    - 用 $\textit{binary}$ 的第 $0, 1, \cdots, i$ 个字符可以构造出的以 $1$ 结尾的不同好子序列，且必须使用第 $i$ 个字符 $1$，记为 $B$ 类，由于我们必须使用第 $i$ 个字符，那么如果倒数第二个字符选择 $0$，方案数为 $f[i-1][0]$；倒数第二个字符选择 $1$，方案数为 $f[i-1][1]$；仅有唯一的字符 $1$，方案数为 $1$。因此，$B$ 类的方案数是 $f[i-1][0] + f[i-1][1] + 1$。

    如果我们简单地将 $A$ 类和 $B$ 类的方案数进行累加，那么我们并不会得到真正的 $f[i][1]$ 的值，这是因为虽然 $A$ 类和 $B$ 类的「内部」没有重复的子序列，但它们「之间」会有重复的子序列。我们设重复的这一部分为 $C$，如果能计算出 $C$ 的方案数，那么通过 $|A| + |B| - |C|$ 就能得到 $f[i][1]$ 的值（其中 $|A|$ 表示 $A$ 类的方案数）。

    如何求出 $C$ 类的方案数呢？可以发现，对于任意一个 $A$ 类中的子序列，它的最后一个元素一定为 $1$，并且属于第 $0, 1, \cdots, i-1$ 个字符。如果我们将该元素变为第 $i$ 个字符 $1$，那么就将该 $A$ 类子序列「转换」为了 $B$ 类子序列。因此，每一个 $A$ 类子序列都唯一地对应着一个 $B$ 类子序列，说明 $A$ 是 $B$ 的子集，那么 $A$ 和 $B$ 的交集 $C$ 就是 $A$ 本身，$f[i][1]$ 的值就是 $|B|$，即：

    $$
    f[i][1] = f[i - 1][0] + f[i - 1][1] + 1
    $$

- 如果第 $i$ 个字符是 $0$，那么类似地有：

    $$
    \begin{cases}
    f[i][0] = f[i - 1][0] + f[i - 1][1] \\
    f[i][1] = f[i - 1][1]
    \end{cases}
    $$

    读者可以使用上面的方法进行相同的推导，这里不再赘述。

最终的答案即为 $f[n - 1][0] + f[n - 1][1]$，其中 $n$ 是字符串 $\textit{binary}$ 的长度。如果 $\textit{binary}$ 中包含 $0$，那么答案额外增加 $1$。

**细节**

上述状态转移方程中的 $f[i][0]$ 和 $f[i][1]$ 均只会从 $f[i - 1][0]$ 和 $f[i - 1][1]$ 转移而来，因此可以使用两个变量 $\textit{even}$ 和 $\textit{odd}$ 代替数组进行状态转移。

- 当第 $i$ 个字符为 $1$ 时，$\textit{even}$ 的值不变，$\textit{odd}$ 的值变为 $\textit{even} + \textit{odd} + 1$；

- 当第 $i$ 个字符为 $0$ 时，$\textit{odd}$ 的值不变，$\textit{even}$ 的值变为 $\textit{even} + \textit{odd}$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int numberOfUniqueGoodSubsequences(string binary) {
        int even = 0, odd = 0;
        for (char ch: binary) {
            if (ch == '0') {
                even = (even + odd) % mod;
            }
            else {
                odd = (even + odd + 1) % mod;
            }
        }

        int ans = (even + odd + (binary.find('0') != string::npos)) % mod;
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfUniqueGoodSubsequences(self, binary: str) -> int:
        mod = 10**9 + 7

        even = odd = 0
        for ch in binary:
            if ch == "0":
                even = (even + odd) % mod
            else:
                odd = (even + odd + 1) % mod
        
        ans = (even + odd + ("0" in binary)) % mod
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{binary}$ 的长度。

- 空间复杂度：$O(1)$。