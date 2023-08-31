## [1018.可被 5 整除的二进制前缀 中文官方题解](https://leetcode.cn/problems/binary-prefix-divisible-by-5/solutions/100000/ke-bei-5-zheng-chu-de-er-jin-zhi-qian-zh-asih)

#### 方法一：遍历

令 $\textit{num}_i$ 为数组 $\textit{nums}$ 从下标 $0$ 到下标 $i$ 的前缀表示的二进制数，则有 $\textit{num}_0=\textit{nums}[0]$。当 $i>0$ 时，有 $\textit{num}_i=\textit{num}_{i-1} \times 2+\textit{nums}[i]$。令 $n$ 为数组 $\textit{nums}$ 的长度，则对于 $0 \le i<n$，可以依次计算每个 $\textit{num}_i$ 的值。对于每个 $\textit{num}_i$ 的值，判断其是否可以被 $5$ 整除，即可得到答案。

考虑到数组 $\textit{nums}$ 可能很长，如果每次都保留 $\textit{num}_i$ 的值，则可能导致溢出。由于只需要知道每个 $\textit{num}_i$ 是否可以被 $5$ 整除，因此在计算过程中只需要保留余数即可。

令 $\textit{remain}_i$ 表示计算到下标 $i$ 时的除以 $5$ 的余数，则有 $\textit{remain}_0=\textit{nums}[0]$（显然 $\textit{nums}[0]$ 一定小于 $5$），当 $i>0$ 时，有 $\textit{remain}_i=(\textit{remain}_{i-1} \times 2+\textit{nums}[i])\bmod 5$，判断每个 $\textit{remain}_i$ 是否为 $0$ 即可。由于 $\textit{remain}_i$ 一定小于 $5$，因此不会溢出。

如何证明判断 $\textit{remain}_i$ 是否为 $0$ 可以得到正确的结果？可以通过数学归纳法证明。

当 $i=0$ 时，由于 $\textit{num}_0=\textit{nums}[0]<5$，因此 $\textit{remain}_0=\textit{num}_0$，$\textit{remain}_0=\textit{num}_0\bmod 5$ 成立。

当 $i>0$ 时，假设 $\textit{remain}_{i-1}=\textit{num}_{i-1}\bmod 5$ 成立，考虑 $\textit{num}_i\bmod 5$ 和 $\textit{remain}_i$ 的值：

$$
\begin{aligned}
\textit{num}_i\bmod 5=&(\textit{num}_{i-1} \times 2+\textit{nums}[i])\bmod 5 \\
=&(\textit{num}_{i-1} \times 2)\bmod 5+\textit{nums}[i]\bmod 5 \\
\\
\textit{remain}_i=&(\textit{remain}_{i-1} \times 2+\textit{nums}[i])\bmod 5 \\
=&(\textit{num}_{i-1}\bmod 5 \times 2+\textit{nums}[i])\bmod 5 \\
=&(\textit{num}_{i-1}\bmod 5 \times 2)\bmod 5+\textit{nums}[i]\bmod 5 \\
=&(\textit{num}_{i-1} \times 2)\bmod 5+\textit{nums}[i]\bmod 5
\end{aligned}
$$

因此有 $\textit{remain}_i=\textit{num}_i\bmod 5$ 成立。

由此可得，对任意 $0 \le i<n$，都有 $\textit{remain}_i=\textit{num}_i\bmod 5$，因此计算 $\textit{remain}_i$ 即可得到正确的结果。

```Java [sol1-Java]
class Solution {
    public List<Boolean> prefixesDivBy5(int[] nums) {
        List<Boolean> answer = new ArrayList<Boolean>();
        int prefix = 0;
        int length = nums.length;
        for (int i = 0; i < length; i++) {
            prefix = ((prefix << 1) + nums[i]) % 5;
            answer.add(prefix == 0);
        }
        return answer;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<bool> prefixesDivBy5(vector<int>& nums) {
        vector<bool> answer;
        int prefix = 0;
        int length = nums.size();
        for (int i = 0; i < length; i++) {
            prefix = ((prefix << 1) + nums[i]) % 5;
            answer.emplace_back(prefix == 0);
        }
        return answer;
    }
};
```

```JavaScript [sol1-JavaScript]
var prefixesDivBy5 = function(nums) {
    const answer = [];
    let prefix = 0;
    const length = nums.length;
    for (let i = 0; i < length; i++) {
        prefix = ((prefix << 1) + nums[i]) % 5;
        answer.push(prefix === 0);
    }
    return answer;
};
```

```Python [sol1-Python]
class Solution:
    def prefixesDivBy5(self, nums: List[int]) -> List[bool]:
        answer = list()
        prefix = 0
        for num in nums:
            prefix = ((prefix << 1) + num) % 5
            answer.append(prefix == 0)
        return answer
```

```go [sol1-Golang]
func prefixesDivBy5(nums []int) []bool {
    ans := make([]bool, len(nums))
    x := 0
    for i, v := range nums {
        x = (x<<1 | v) % 5
        ans[i] = x == 0
    }
    return ans
}
```

```C [sol1-C]
bool* prefixesDivBy5(int* nums, int numsSize, int* returnSize) {
    *returnSize = numsSize;
    bool* answer = malloc(sizeof(bool) * numsSize);
    int prefix = 0;
    for (int i = 0; i < numsSize; i++) {
        prefix = ((prefix << 1) + nums[i]) % 5;
        answer[i] = prefix == 0;
    }
    return answer;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次并计算前缀。

- 空间复杂度：$O(1)$。除了返回值以外，额外使用的空间为常数。