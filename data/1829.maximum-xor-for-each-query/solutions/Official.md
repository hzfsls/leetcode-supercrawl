#### 方法一：位运算

**提示 $1$**

我们用 $\oplus$ 表示按位异或运算。

根据按位异或运算的性质 $a \oplus b \oplus b = a$，我们可以在 $O(1)$ 的时间，根据上一次询问需要的异或前缀和，得到当前询问需要的异或前缀和。

为了方便叙述，我们将第 $i$ 次询问对应的异或前缀和记为

$$
\textit{xorsum}_i = \textit{nums}[0] \oplus \textit{nums}[1] \oplus \cdots \oplus \textit{nums}[n-1-i]
$$

**提示 $2$**

我们需要挑选一个包含不超过 $\textit{maximumBit}$ 个二进制位的非负整数 $k$，使得 $k \oplus \textit{xorsum}$ 的值最大。由于题目保证了数组 $\textit{nums}$ 中的元素一定小于等于 $2^\textit{maximumBit} - 1$，你是否可以直接构造出 $k$ 值？

**思路与算法**

首先我们可以通过

$$
\textit{xorsum}_{i-1} = \textit{xorsum}_i \oplus \textit{nums}[n-1-i]
$$

在 $O(1)$ 的时间更新每一次询问需要的异或前缀和。

再者，由于数组 $\textit{nums}$ 的元素一定小于等于 $2^\textit{maximumBit} - 1$，而 $2^\textit{maximumBit} - 1$ 是一个二进制表示全部为 $1$ 的数，因此数组 $\textit{nums}$ 中的任意异或前缀和一定也小于等于 $2^\textit{maximumBit} - 1$。这样一来，我们令 $k = \textit{xorsum} \oplus (2^\textit{maximumBit} - 1)$，$k \oplus \textit{xorsum}$ 就可以得到最大值 $2^\textit{maximumBit} - 1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> getMaximumXor(vector<int>& nums, int maximumBit) {
        int n = nums.size();
        int mask = (1 << maximumBit) - 1;
        int xorsum = accumulate(nums.begin(), nums.end(), 0, bit_xor<int>());
        
        vector<int> ans;
        for (int i = n - 1; i >= 0; --i) {
            ans.push_back(xorsum ^ mask);
            xorsum ^= nums[i];
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getMaximumXor(self, nums: List[int], maximumBit: int) -> List[int]:
        n = len(nums)
        mask = (1 << maximumBit) - 1
        xorsum = reduce(xor, nums)
        
        ans = list()
        for i in range(n - 1, -1, -1):
            ans.append(xorsum ^ mask)
            xorsum ^= nums[i]
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。这里不包括存储返回答案需要的空间。