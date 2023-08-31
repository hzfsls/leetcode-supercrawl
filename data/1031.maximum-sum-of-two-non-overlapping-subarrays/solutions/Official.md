## [1031.两个非重叠子数组的最大和 中文官方题解](https://leetcode.cn/problems/maximum-sum-of-two-non-overlapping-subarrays/solutions/100000/liang-ge-fei-zhong-die-zi-shu-zu-de-zui-ih3n2)
#### 方法一：动态规划 + 滑动窗口

**思路与算法**

首先题目给出一个长度为 $n$ 的数组 $\textit{nums}$。现在我们需要返回两个长度分别为 $\textit{firstLen}$ 和 $\textit{secondLen}$ 的非重叠的子数组的最大和，$\textit{firstLen} + \textit{secondLen} \le n$，其中这两段子数组的前后顺序没有要求。

由于两段子数组的前后顺序没有区别，所以现在不妨设长度为 $\textit{firstLen}$ 的子数组在长度为 $\textit{secondLen}$ 的子数组前来计算此时的两段子数组的最大和。首先我们用 $\textit{nums}[i,j]$ 来表示 $\textit{nums}[i],\textit{nums}[i+1],\dots,\textit{nums}[j-1]$ 这一段子数组，并记 $sum(\textit{nums}[l, r])$ 表示子数组 $\textit{nums}[l, r]$ 的和，$\textit{dp}[i]$ 为 $\textit{nums}[0,i + 1]$ 中长度为 $\textit{firstLen}$ 的最大子数组和，若不存在长度为 $\textit{firstLen}$ 的子数组则为 $0$。那么对于某一段长度为 $\textit{secondLen}$ 的子数组 $\textit{nums}[j,j+\textit{secondLen}]$，$0 \le j < j + \textit{secondLen} \le n$，所以此时的两个数组的最大和为

$$dp[j-1]+sum(\textit{nums}[j, j + \textit{secondLen}])$$ 

又因为

$$\textit{dp}[i] = \max\{\textit{dp}[i-1], sum(\textit{nums}[i+1-\textit{firstLen}, i+1])\}$$

由于现在长度为 $\textit{secondLen}$ 在长度为 $\textit{firstLen}$ 的后面，所以用两个大小为 $\textit{firstLen}$ 和 $\textit{secondLen}$ 的滑动窗口分别从位置 $0$ 和 $\textit{firstLen}$ 同时开始从左往右滑动，并在过程中维护窗口中的和。因为对于 $\forall i < \textit{firstLen} - 1$，有 $\textit{dp}[i] = 0$，并当 $i = \textit{firstLen} - 1$ 时为初始第一个窗口的和。那么在两个窗口从左到右移动的过程中，通过移动第一个窗口来更新 $\textit{dp}$ 值，通过第二个窗口来计算此时的最大和，并记录移动过程中的最大值即可。

同理我们可以得到当 $\textit{secondLen}$ 的子数组在长度为 $\textit{firstLen}$ 的子数组前时，两段子数组的最大和，两种情况取较大值即为最终的答案。由于 $\textit{dp}[i]$ 的求解只与 $\textit{dp}[i-1]$ 有关，所以在实现的过程中我们可以通过「滚动数组」来进行空间优化。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int help(vector<int>& nums, int firstLen, int secondLen) {
        int suml = accumulate(nums.begin(), nums.begin() + firstLen, 0);
        int maxSumL = suml;
        int sumr = accumulate(nums.begin() + firstLen, nums.begin() + firstLen + secondLen, 0);
        int res = maxSumL + sumr;
        for (int i = firstLen + secondLen, j = firstLen; i < nums.size(); ++i, ++j) {
            suml += nums[j] - nums[j - firstLen];
            maxSumL = max(maxSumL, suml);
            sumr += nums[i] - nums[i - secondLen];
            res = max(res, maxSumL + sumr);
        }
        return res;
    }

    int maxSumTwoNoOverlap(vector<int>& nums, int firstLen, int secondLen) {
        return max(help(nums, firstLen, secondLen), help(nums, secondLen, firstLen));
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSumTwoNoOverlap(int[] nums, int firstLen, int secondLen) {
        return Math.max(help(nums, firstLen, secondLen), help(nums, secondLen, firstLen));
    }

    public int help(int[] nums, int firstLen, int secondLen) {
        int suml = 0;
        for (int i = 0; i < firstLen; ++i) {
            suml += nums[i];
        }
        int maxSumL = suml;
        int sumr = 0;
        for (int i = firstLen; i < firstLen + secondLen; ++i) {
            sumr += nums[i];
        }
        int res = maxSumL + sumr;
        for (int i = firstLen + secondLen, j = firstLen; i < nums.length; ++i, ++j) {
            suml += nums[j] - nums[j - firstLen];
            maxSumL = Math.max(maxSumL, suml);
            sumr += nums[i] - nums[i - secondLen];
            res = Math.max(res, maxSumL + sumr);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxSumTwoNoOverlap(self, nums: List[int], firstLen: int, secondLen: int) -> int:
        return max(self.help(nums, firstLen, secondLen), self.help(nums, secondLen, firstLen))

    def help(self, nums, firstLen, secondLen):
        suml = 0
        for i in range(0, firstLen):
            suml += nums[i]
        maxSumL = suml
        sumr = 0
        for i in range(firstLen, firstLen + secondLen):
            sumr += nums[i]
        res = maxSumL + sumr
        j = firstLen
        for i in range(firstLen + secondLen, len(nums)):
            suml += nums[j] - nums[j - firstLen]
            maxSumL = max(maxSumL, suml)
            sumr += nums[i] - nums[i - secondLen]
            res = max(res, maxSumL + sumr)
            j += 1
        return res
```

```Go [sol1-Go]
func help(nums []int, firstLen int, secondLen int) int {
    suml := 0
    for i := 0; i < firstLen; i++ {
        suml += nums[i]
    }
    maxSumL := suml
    sumr := 0
    for i := firstLen; i < firstLen+secondLen; i++ {
        sumr += nums[i]
    }
    res := maxSumL + sumr
    for i, j := firstLen+secondLen, firstLen; i < len(nums); i, j = i + 1, j + 1 {
        suml += nums[j] - nums[j - firstLen]
        maxSumL = max(maxSumL, suml)
        sumr += nums[i] - nums[i - secondLen]
        res = max(res, maxSumL + sumr)
    }
    return res
}

func maxSumTwoNoOverlap(nums []int, firstLen int, secondLen int) int {
    return max(help(nums, firstLen, secondLen), help(nums, secondLen, firstLen))
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxSumTwoNoOverlap = function(nums, firstLen, secondLen) {
    return Math.max(help(nums, firstLen, secondLen), help(nums, secondLen, firstLen));
};

function help(nums, firstLen, secondLen) {
    let suml = nums.slice(0, firstLen).reduce((acc, val) => acc + val, 0);
    let maxSumL = suml;
    let sumr = nums.slice(firstLen, firstLen + secondLen).reduce((acc, val) => acc + val, 0);
    let res = maxSumL + sumr;
    for (let i = firstLen + secondLen, j = firstLen; i < nums.length; i++, j++) {
        suml += nums[j] - nums[j - firstLen];
        maxSumL = Math.max(maxSumL, suml);
        sumr += nums[i] - nums[i - secondLen];
        res = Math.max(res, maxSumL + sumr);
    }
    return res;
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxSumTwoNoOverlap(int[] nums, int firstLen, int secondLen) {
        return Math.Max(Help(nums, firstLen, secondLen), Help(nums, secondLen, firstLen));
    }

    public int Help(int[] nums, int firstLen, int secondLen) {
        int suml = 0;
        for (int i = 0; i < firstLen; ++i) {
            suml += nums[i];
        }
        int maxSumL = suml;
        int sumr = 0;
        for (int i = firstLen; i < firstLen + secondLen; ++i) {
            sumr += nums[i];
        }
        int res = maxSumL + sumr;
        for (int i = firstLen + secondLen, j = firstLen; i < nums.Length; ++i, ++j) {
            suml += nums[j] - nums[j - firstLen];
            maxSumL = Math.Max(maxSumL, suml);
            sumr += nums[i] - nums[i - secondLen];
            res = Math.Max(res, maxSumL + sumr);
        }
        return res;
    }
}
```

```C [sol1-C]
inline int max(int a, int b) {
    return a > b ? a : b;
}

int help(const int* nums, int numsSize, int firstLen, int secondLen) {
    int suml = 0;
    for (int i = 0; i < firstLen; i++) {
        suml += nums[i];
    }
    int maxSumL = suml;
    int sumr = 0;
    for (int i = firstLen; i < firstLen + secondLen; i++) {
        sumr += nums[i];
    }
    int res = maxSumL + sumr;
    for (int i = firstLen + secondLen, j = firstLen; i < numsSize; ++i, ++j) {
        suml += nums[j] - nums[j - firstLen];
        maxSumL = max(maxSumL, suml);
        sumr += nums[i] - nums[i - secondLen];
        res = max(res, maxSumL + sumr);
    }
    return res;
}

int maxSumTwoNoOverlap(int* nums, int numsSize, int firstLen, int secondLen) {
    return max(help(nums, numsSize, firstLen, secondLen), help(nums, numsSize, secondLen, firstLen));
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。