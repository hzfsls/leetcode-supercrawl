## [1734.解码异或后的排列 中文官方题解](https://leetcode.cn/problems/decode-xored-permutation/solutions/100000/jie-ma-yi-huo-hou-de-pai-lie-by-leetcode-9gw4)

#### 方法一：利用异或运算解码

这道题规定了数组 $\textit{perm}$ 是前 $n$ 个正整数的排列，其中 $n$ 是**奇数**，只有充分利用给定的条件，才能得到答案。

为了得到原始数组 $\textit{perm}$，应首先得到数组 $\textit{perm}$ 的第一个元素（即下标为 $0$ 的元素），这也是最容易得到的。如果能得到数组 $\textit{perm}$ 的全部元素的异或运算结果，以及数组 $\textit{perm}$ 除了 $\textit{perm}[0]$ 以外的全部元素的异或运算结果，即可得到 $\textit{perm}[0]$ 的值。

由于数组 $\textit{perm}$ 是前 $n$ 个正整数的排列，因此数组 $\textit{perm}$ 的全部元素的异或运算结果即为从 $1$ 到 $n$ 的全部正整数的异或运算结果。用 $\textit{total}$ 表示数组 $\textit{perm}$ 的全部元素的异或运算结果，则有

$$
\begin{aligned}
\textit{total} &= 1 \oplus 2 \oplus \ldots \oplus n \\
&= \textit{perm}[0] \oplus \textit{perm}[1] \oplus \ldots \oplus \textit{perm}[n-1]
\end{aligned}
$$

其中 $\oplus$ 是异或运算符。

如何得到数组 $\textit{perm}$ 除了 $\textit{perm}[0]$ 以外的全部元素的异或运算结果？由于 $n$ 是奇数，除了 $\textit{perm}[0]$ 以外，数组 $\textit{perm}$ 还有 $n-1$ 个其他元素，$n-1$ 是偶数，又由于数组 $\textit{encoded}$ 的每个元素都是数组 $\textit{perm}$ 的两个元素异或运算的结果，因此数组 $\textit{encoded}$ 中存在 $\frac{n-1}{2}$ 个元素，这些元素的异或运算的结果为数组 $\textit{perm}$ 除了 $\textit{perm}[0]$ 以外的全部元素的异或运算结果。

具体而言，数组 $\textit{encoded}$ 的所有下标为奇数的元素的异或运算结果即为数组 $\textit{perm}$ 除了 $\textit{perm}[0]$ 以外的全部元素的异或运算结果。用 $\textit{odd}$ 表示数组 $\textit{encoded}$ 的所有下标为奇数的元素的异或运算结果，则有

$$
\begin{aligned}
\textit{odd} &= \textit{encoded}[1] \oplus \textit{encoded}[3] \oplus \ldots \oplus \textit{encoded}[n-2] \\
&= \textit{perm}[1] \oplus \textit{perm}[2] \oplus \ldots \oplus \textit{perm}[n]
\end{aligned}
$$

根据 $\textit{total}$ 和 $\textit{odd}$ 的值，即可计算得到 $\textit{perm}[0]$ 的值：

$$
\begin{aligned}
\textit{perm}[0] &= (\textit{perm}[0] \oplus \ldots \oplus \textit{perm}[n]) \oplus (\textit{perm}[1] \oplus \ldots \oplus \textit{perm}[n]) \\
&= \textit{total} \oplus \textit{odd}
\end{aligned}
$$

当 $1 \le i<n$ 时，有 $\textit{encoded}[i-1]=\textit{perm}[i-1] \oplus \textit{perm}[i]$。在等号两边同时异或 $\textit{perm}[i-1]$，即可得到 $\textit{perm}[i]=\textit{perm}[i-1] \oplus \textit{encoded}[i-1]$。计算过程见「[1720. 解码异或后的数组的官方题解](https://leetcode-cn.com/problems/decode-xored-array/solution/jie-ma-yi-huo-hou-de-shu-zu-by-leetcode-yp0mg/)」。

由于 $\textit{perm}[0]$ 已知，因此对 $i$ 从 $1$ 到 $n-1$ 依次计算 $\textit{perm}[i]$ 的值，即可得到原始数组 $\textit{perm}$。

```Java [sol1-Java]
class Solution {
    public int[] decode(int[] encoded) {
        int n = encoded.length + 1;
        int total = 0;
        for (int i = 1; i <= n; i++) {
            total ^= i;
        }
        int odd = 0;
        for (int i = 1; i < n - 1; i += 2) {
            odd ^= encoded[i];
        }
        int[] perm = new int[n];
        perm[0] = total ^ odd;
        for (int i = 0; i < n - 1; i++) {
            perm[i + 1] = perm[i] ^ encoded[i];
        }
        return perm;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] Decode(int[] encoded) {
        int n = encoded.Length + 1;
        int total = 0;
        for (int i = 1; i <= n; i++) {
            total ^= i;
        }
        int odd = 0;
        for (int i = 1; i < n - 1; i += 2) {
            odd ^= encoded[i];
        }
        int[] perm = new int[n];
        perm[0] = total ^ odd;
        for (int i = 0; i < n - 1; i++) {
            perm[i + 1] = perm[i] ^ encoded[i];
        }
        return perm;
    }
}
```

```JavaScript [sol1-JavaScript]
var decode = function(encoded) {
    const n = encoded.length + 1;
    let total = 0;
    for (let i = 1; i <= n; i++) {
        total ^= i;
    }
    let odd = 0;
    for (let i = 1; i < n - 1; i += 2) {
        odd ^= encoded[i];
    }
    const perm = new Array(n).fill(0);
    perm[0] = total ^ odd;
    for (let i = 0; i < n - 1; i++) {
        perm[i + 1] = perm[i] ^ encoded[i];
    }
    return perm;
};
```

```go [sol1-Golang]
func decode(encoded []int) []int {
    n := len(encoded)
    total := 0
    for i := 1; i <= n+1; i++ {
        total ^= i
    }
    odd := 0
    for i := 1; i < n; i += 2 {
        odd ^= encoded[i]
    }
    perm := make([]int, n+1)
    perm[0] = total ^ odd
    for i, v := range encoded {
        perm[i+1] = perm[i] ^ v
    }
    return perm
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> decode(vector<int>& encoded) {
        int n = encoded.size() + 1;
        int total = 0;
        for (int i = 1; i <= n; i++) {
            total ^= i;
        }
        int odd = 0;
        for (int i = 1; i < n - 1; i += 2) {
            odd ^= encoded[i];
        }
        vector<int> perm(n);
        perm[0] = total ^ odd;
        for (int i = 0; i < n - 1; i++) {
            perm[i + 1] = perm[i] ^ encoded[i];
        }
        return perm;
    }
};
```

```C [sol1-C]
int* decode(int* encoded, int encodedSize, int* returnSize) {
    int n = encodedSize + 1;
    int total = 0;
    for (int i = 1; i <= n; i++) {
        total ^= i;
    }
    int odd = 0;
    for (int i = 1; i < n - 1; i += 2) {
        odd ^= encoded[i];
    }
    int* perm = malloc(sizeof(int) * n);
    *returnSize = n;
    perm[0] = total ^ odd;
    for (int i = 0; i < n - 1; i++) {
        perm[i + 1] = perm[i] ^ encoded[i];
    }
    return perm;
}
```

```Python [sol1-Python3]
class Solution:
    def decode(self, encoded: List[int]) -> List[int]:
        n = len(encoded) + 1
        total = reduce(xor, range(1, n + 1))
        odd = 0
        for i in range(1, n - 1, 2):
            odd ^= encoded[i]
        
        perm = [total ^ odd]
        for i in range(n - 1):
            perm.append(perm[-1] ^ encoded[i])
        
        return perm
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是原始数组 $\textit{perm}$ 的长度。计算 $\textit{total}$ 和 $\textit{odd}$ 各需要遍历长度为 $n-1$ 的数组 $\textit{encoded}$ 一次，计算原数组 $\textit{perm}$ 的每个元素值也需要遍历长度为 $n-1$ 的数组 $\textit{encoded}$ 一次。

- 空间复杂度：$O(1)$。注意空间复杂度不考虑返回值。