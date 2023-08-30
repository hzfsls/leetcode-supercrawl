#### 方法一：动态规划

**思路与算法**

首先题目给出一个下标从 $0$ 开始长度为 $n$ 的整数数组 $\textit{nums}$，并给出「平衡数组」的定义：数组中奇数下标元素和与偶数下标元素的和相等。现在我们可以选择一个位置 $i$，$0 \le i < n$ 的元素删除（注意删除后 $i$ 之后的下标可能会因此发生改变）。我们需要求出所有删除该下标元素后的数组为「平衡数组」的下标数目。

我们设 $\textit{preOdd}[i]$ 表示位置 $i$，$0 \le i < n$ 前所有奇数位置元素的和，$\textit{preEven}[i]$ 表示位置 $i$ 前所有偶数位置元素的和，$\textit{sufOdd}[i]$ 表示位置 $i$ 后所有奇数位置元素的和，$\textit{sufEven}[i]$ 表示位置 $i$ 后所有偶数位置元素的和，我们来看如何进行状态转移——

- 当 $i$ 为奇数时：
  - $\textit{preOdd}[i + 1] = \textit{preOdd}[i] + \textit{nums}[i]$，$i + 1 < n$
  - $\textit{sufOdd}[i] = \textit{sufOdd}[i - 1] - \textit{nums}[i]$，$i - 1 \ge 0$
  - $\textit{preEven}[i + 1] = \textit{preEven}[i]$，$i + 1 < n$
  - $\textit{sufEven}[i] = \textit{sufEven}[i - 1]$，$i - 1 \ge 0$
- 当 $i$ 为偶数时：
  - $\textit{preEven}[i + 1] = \textit{preEven}[i] + \textit{nums}[i]$，$i + 1 < n$
  - $\textit{sufEven}[i] = \textit{sufEven}[i - 1] - \textit{nums}[i]$，$i - 1 < n$
  - $\textit{preOdd}[i + 1] = \textit{preOdd}[i]$，$i + 1 < n$
  - $\textit{sufOdd}[i] = \textit{sufOdd}[i - 1]$，$i - 1 \ge 0$

其中边界条件为：当 $i = 0$ 时，$\textit{preOdd}[0] = 0$，$\textit{preEven}[0] = 0$，$\textit{sufOdd}[0] = \sum_{2i + 1}^{n}\textit{nums}[2i + 1]$，$\textit{sufEven}[0] = \sum_{2i}^{n}\textit{nums}[2i]$。

不失一般性，现在我们将下标 $i$ 的元素进行删除，显而易见下标 $i$ 之前的元素下标并不会因此发生改变，而下标 $i$ 之后的原本在 $j$，$j > i$ 下标的数组元素会移动到下标 $j - 1$，即下标 $i$ 之后的奇数下标元素会成为偶数下标元素，偶数下标元素会成为奇数下标元素。所以删除后数组中全部奇数下标元素和为 $\textit{preOdd}[i] + \textit{sufEven}[i]$，全部偶数下标元素和为 $\textit{preEven}[i] + \textit{sufOdd}[i]$，若两者相等则说明删除下标 $i$ 后的数组为「平衡数组」。那么我们尝试删除每一个下标 $i$，$0 \le i < n$，来统计能生成「平衡数组」的下标即可。又因为 $\textit{preOdd}[i]$，$\textit{preEven}[i]$，$\textit{sufOdd}[i]$，$\textit{sufEven}[i]$ 求解都与前一个数有关，因此我们可以用「滚动数组」的技巧来进行空间优化。

**代码**

```Python [sol1-Python3]
class Solution:
    def waysToMakeFair(self, nums: List[int]) -> int:
        res = odd1 = even1 = odd2 = even2 = 0
        for i, num in enumerate(nums):
            if i & 1:
                odd2 += num
            else:
                even2 += num
        for i, num in enumerate(nums):
            if i & 1:
                odd2 -= num
            else:
                even2 -= num
            if odd1 + even2 == odd2 + even1:
                res += 1
            if i & 1:
                odd1 += num
            else:
                even1 += num
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int waysToMakeFair(vector<int>& nums) {
        int odd1 = 0, even1 = 0;
        int odd2 = 0, even2 = 0;
        for (int i = 0; i < nums.size(); ++i) {
            if (i & 1) {
                odd2 += nums[i];
            } else {
                even2 += nums[i];
            }
        }
        int res = 0;
        for (int i = 0; i < nums.size(); ++i) {
            if (i & 1) {
                odd2 -= nums[i];
            } else {
                even2 -= nums[i];
            }
            if (odd1 + even2 == odd2 + even1) {
                ++res;
            }
            if (i & 1) {
                odd1 += nums[i];
            } else {
                even1 += nums[i];
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int waysToMakeFair(int[] nums) {
        int odd1 = 0, even1 = 0;
        int odd2 = 0, even2 = 0;
        for (int i = 0; i < nums.length; ++i) {
            if ((i & 1) != 0) {
                odd2 += nums[i];
            } else {
                even2 += nums[i];
            }
        }
        int res = 0;
        for (int i = 0; i < nums.length; ++i) {
            if ((i & 1) != 0) {
                odd2 -= nums[i];
            } else {
                even2 -= nums[i];
            }
            if (odd1 + even2 == odd2 + even1) {
                ++res;
            }
            if ((i & 1) != 0) {
                odd1 += nums[i];
            } else {
                even1 += nums[i];
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int WaysToMakeFair(int[] nums) {
        int odd1 = 0, even1 = 0;
        int odd2 = 0, even2 = 0;
        for (int i = 0; i < nums.Length; ++i) {
            if ((i & 1) != 0) {
                odd2 += nums[i];
            } else {
                even2 += nums[i];
            }
        }
        int res = 0;
        for (int i = 0; i < nums.Length; ++i) {
            if ((i & 1) != 0) {
                odd2 -= nums[i];
            } else {
                even2 -= nums[i];
            }
            if (odd1 + even2 == odd2 + even1) {
                ++res;
            }
            if ((i & 1) != 0) {
                odd1 += nums[i];
            } else {
                even1 += nums[i];
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int waysToMakeFair(int* nums, int numsSize) {
    int odd1 = 0, even1 = 0;
    int odd2 = 0, even2 = 0;
    for (int i = 0; i < numsSize; ++i) {
        if (i & 1) {
            odd2 += nums[i];
        } else {
            even2 += nums[i];
        }
    }
    int res = 0;
    for (int i = 0; i < numsSize; ++i) {
        if (i & 1) {
            odd2 -= nums[i];
        } else {
            even2 -= nums[i];
        }
        if (odd1 + even2 == odd2 + even1) {
            ++res;
        }
        if (i & 1) {
            odd1 += nums[i];
        } else {
            even1 += nums[i];
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var waysToMakeFair = function(nums) {
    let odd1 = 0, even1 = 0;
    let odd2 = 0, even2 = 0;
    for (let i = 0; i < nums.length; ++i) {
        if ((i & 1) !== 0) {
            odd2 += nums[i];
        } else {
            even2 += nums[i];
        }
    }
    let res = 0;
    for (let i = 0; i < nums.length; ++i) {
        if ((i & 1) != 0) {
            odd2 -= nums[i];
        } else {
            even2 -= nums[i];
        }
        if (odd1 + even2 === odd2 + even1) {
            ++res;
        }
        if ((i & 1) !== 0) {
            odd1 += nums[i];
        } else {
            even1 += nums[i];
        }
    }
    return res;
};
```

```go [sol1-Golang]
func waysToMakeFair(nums []int) (res int) {
    var odd1, even1, odd2, even2 int
    for i, num := range nums {
        if i&1 > 0 {
            odd2 += num
        } else {
            even2 += num
        }
    }
    for i, num := range nums {
        if i&1 > 0 {
            odd2 -= num
        } else {
            even2 -= num
        }
        if odd1+even2 == odd2+even1 {
            res++
        }
        if i&1 > 0 {
            odd1 += num
        } else {
            even1 += num
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。