## [1835.所有数对按位与结果的异或和 中文官方题解](https://leetcode.cn/problems/find-xor-sum-of-all-pairs-bitwise-and/solutions/100000/find-xor-sum-of-all-pairs-bitwise-and-by-sok6)
#### 方法一：依次确定答案的每一位

**提示 $1$**

我们需要计算的表达式只包含位运算（即按位与运算以及按位异或运算），那么我们是否可以依次确定答案的二进制表示中的每一位？

**思路与算法**

记 $\textit{und}(i, j) = \textit{arr}_1[i] \wedge \textit{arr}_2[j]$，其中 $\wedge$ 表示按位与运算，那么我们需要求出的答案即为

$$
\underset{\substack{0\leq i < m \\ 0\leq j < n}}{{\LARGE \oplus}} und(i, j)
$$

其中 $\oplus$ 表示按位异或运算，以类似求和 $\Sigma$ 的形式写在左侧，即表示对所有的 $\textit{und}(i, j)$ 按照按位异或运算的要求进行求和。

考虑答案的二进制表示的第 $k$ 位，那么 $und(i, j) = 1$ 当且仅当 $\textit{arr}_1[i]$ 和 $\textit{arr}_2[j]$ 的二进制表示的第 $k$ 位均为 $1$。除此之外，$\textit{und}(i, j) = 0$。

当我们对所有 $\textit{und}(i, j)$ 进行求和时，实际上是对若干个 $1$ 以及若干个 $0$ 进行求和。根据异或运算的性质，一个数与 $0$ 进行异或运算，它的值不改变，因此如果有奇数个 $1$ 进行异或运算，那么最终答案为 $1$，否则为 $0$。

这样一来，我们只要求出数组 $\textit{arr}_1$ 中二进制表示第 $k$ 位为 $1$ 的元素个数 $\textit{cnt}_1[k]$，以及数组 $\textit{arr}_2$ 中二进制表示第 $k$ 位为 $1$ 的元素个数 $\textit{cnt}_2[k]$，那么就会有 $\textit{cnt}_1[k] \times \textit{cnt}_2[k]$ 个 $1$ 进行异或运算，这样就确定了答案的第 $k$ 位。

**细节**

注意 $\textit{cnt}_1[k] \times \textit{cnt}_2[k]$ 可能会溢出 $32$ 位有符号整数的范围。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getXORSum(vector<int>& arr1, vector<int>& arr2) {
        int m = arr1.size();
        int n = arr2.size();
        int ans = 0;
        // 依次确定答案二进制表示中的每一位
        for (int k = 30; k >= 0; --k) {
            int cnt1 = 0;
            for (int num: arr1) {
                if (num & (1 << k)) {
                    ++cnt1;
                }
            }
            int cnt2 = 0;
            for (int num: arr2) {
                if (num & (1 << k)) {
                    ++cnt2;
                }
            }
            // 如果 cnt1 和 cnt2 都是奇数，那么答案的第 k 位为 1
            if (cnt1 % 2 == 1 && cnt2 % 2 == 1) {
                ans |= (1 << k);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getXORSum(self, arr1: List[int], arr2: List[int]) -> int:
        m, n = len(arr1), len(arr2)
        ans = 0
        
        # 依次确定答案二进制表示中的每一位
        for k in range(30, -1, -1):
            cnt1 = sum(1 for num in arr1 if num & (1 << k))
            cnt2 = sum(1 for num in arr2 if num & (1 << k))
            # 如果 cnt1 和 cnt2 都是奇数，那么答案的第 k 位为 1
            if cnt1 % 2 == 1 and cnt2 % 2 == 1:
                ans |= (1 << k)

        return ans
```

**复杂度分析**

- 时间复杂度：$O((m + n) \log C)$，其中 $m$ 和 $n$ 分别是数组 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的长度，$C$ 是数组中的元素范围，在本题中 $C \leq 10^9$。每个数的二进制表示有 $O(\log C)$ 位，需要枚举 $O(\log C)$ 次，每一次枚举的过程中需要对两个数组进行依次遍历，时间复杂度为 $O(m + n)$。

- 空间复杂度：$O(1)$。

#### 方法二：直接确定答案

**提示 $1$**

「且」连接词和按位与运算息息相关。
「奇偶性」和按位异或运算息息相关。

**思路与算法**

我们进行如下的推导：

- 答案的第 $k$ 位为 $1$

等价于

- $\textit{cnt}_1[k]$ 为奇数且 $\textit{cnt}_2[k]$ 为奇数

等价于

- 数组 $\textit{arr}_1$ 中二进制表示第 $k$ 位的异或和为 $1$ 且数组 $\textit{arr}_2$ 中二进制表示第 $k$ 位的异或和为 $1$

等价于

- 数组 $\textit{arr}_1$ 中二进制表示第 $k$ 位的异或和 $\wedge$ 数组 $\textit{arr}_2$ 中二进制表示第 $k$ 位的异或和 $=1$

这样一来，我们将数组 $\textit{arr}_1$ 中的所有元素的异或和记为 $\textit{tot}_1$，将数组 $\textit{arr}_2$ 中的所有元素的异或和记为 $\textit{tot}_2$，答案即为

$$
\textit{tot}_1 \wedge \textit{tot}_2
$$

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int getXORSum(vector<int>& arr1, vector<int>& arr2) {
        int tot1 = accumulate(arr1.begin(), arr1.end(), 0, bit_xor<int>());
        int tot2 = accumulate(arr2.begin(), arr2.end(), 0, bit_xor<int>());
        return tot1 & tot2;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def getXORSum(self, arr1: List[int], arr2: List[int]) -> int:
        tot1 = reduce(xor, arr1)
        tot2 = reduce(xor, arr2)
        return tot1 & tot2
```

**复杂度分析**

- 时间复杂度：$O(m+n)$。

- 空间复杂度：$O(1)$。