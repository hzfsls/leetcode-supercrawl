## [689.三个无重叠子数组的最大和 中文官方题解](https://leetcode.cn/problems/maximum-sum-of-3-non-overlapping-subarrays/solutions/100000/san-ge-wu-zhong-die-zi-shu-zu-de-zui-da-4a8lb)

要计算三个无重叠子数组的最大和，我们可以枚举第三个子数组的位置，同时维护前两个无重叠子数组的最大和及其位置。

要计算两个无重叠子数组的最大和，我们可以枚举第二个子数组的位置，同时维护第一个子数组的最大和及其位置。

因此，我们首先来解决单个子数组的最大和问题，然后解决两个无重叠子数组的最大和问题，最后解决三个无重叠子数组的最大和问题。

#### 前言一：单个子数组的最大和

我们用滑动窗口来解决这一问题。

滑动窗口是数组/字符串问题中常用的抽象概念。**窗口**通常是指在数组/字符串中由开始和结束索引定义的一系列元素的集合，即闭区间 $[i,j]$。而**滑动窗口**是指可以将两个边界向某一方向「滑动」的窗口。例如，我们将 $[i,j]$ 向右滑动 $1$ 个元素，它将变为 $[i+1,j+1]$。

设 $\textit{sum}_1$ 为大小为 $k$ 的窗口的元素和，当窗口从 $[i-k+1,i]$ 向右滑动 $1$ 个元素后，$\textit{sum}_1$ 增加了 $\textit{nums}[i+1]$，减少了 $\textit{nums}[i-k+1]$。据此我们可以 $O(1)$ 地计算出向右滑动 $1$ 个元素后的窗口的元素和。

我们从 $[0,k-1]$ 开始，不断地向右滑动窗口，直至窗口右端点到达数组末尾时停止。统计这一过程中的 $\textit{sum}_1$ 的最大值（记作 $\textit{maxSum}_1$）及其对应位置。

```Python [sol1-Python3]
class Solution:
    def maxSumOfOneSubarray(self, nums: List[int], k: int) -> List[int]:
        ans = []
        sum1, maxSum1 = 0, 0
        for i, num in enumerate(nums):
            sum1 += num
            if i >= k - 1:
                if sum1 > maxSum1:
                    maxSum1 = sum1
                    ans = [i - k + 1]
                sum1 -= nums[i - k + 1]
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> maxSumOfOneSubarray(vector<int> &nums, int k) {
        vector<int> ans;
        int sum1 = 0, maxSum1 = 0;
        for (int i = 0; i < nums.size(); ++i) {
            sum1 += nums[i];
            if (i >= k - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    ans = {i - k + 1};
                }
                sum1 -= nums[i - k + 1];
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] maxSumOfOneSubarray(int[] nums, int k) {
        int[] ans = new int[1];
        int sum1 = 0, maxSum1 = 0;
        for (int i = 0; i < nums.length; ++i) {
            sum1 += nums[i];
            if (i >= k - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    ans[0] = i - k + 1;
                }
                sum1 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] MaxSumOfOneSubarray(int[] nums, int k) {
        int[] ans = new int[1];
        int sum1 = 0, maxSum1 = 0;
        for (int i = 0; i < nums.Length; ++i) {
            sum1 += nums[i];
            if (i >= k - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    ans[0] = i - k + 1;
                }
                sum1 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func maxSumOfOneSubarray(nums []int, k int) (ans []int) {
    var sum1, maxSum1 int
    for i, num := range nums {
        sum1 += num
        if i >= k-1 {
            if sum1 > maxSum1 {
                maxSum1 = sum1
                ans = []int{i - k + 1}
            }
            sum1 -= nums[i-k+1]
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var maxSumOfOneSubarray = function(nums, k) {
    let ans = [];
    let sum1 = 0, maxSum1 = 0;
    for (let i = 0; i < nums.length; ++i) {
        sum1 += nums[i];
        if (i >= k - 1) {
            if (sum1 > maxSum1) {
                maxSum1 = sum1;
                ans = [i - k + 1];
            }
            sum1 -= nums[i - k + 1];
        }
    }
    return ans;
};
```

#### 前言二：两个无重叠子数组的最大和

我们使用两个大小为 $k$ 的滑动窗口。设 $\textit{sum}_1$ 为第一个滑动窗口的元素和，该滑动窗口从 $[0,k-1]$ 开始；$\textit{sum}_2$ 为第二个滑动窗口的元素和，该滑动窗口从 $[k,2k-1]$ 开始。

我们同时向右滑动这两个窗口，并维护 $\textit{sum}_1$ 的最大值 $\textit{maxSum}_1$ 及其对应位置。每次滑动时，计算当前 $\textit{maxSum}_1$ 与 $\textit{sum}_2$ 之和。统计这一过程中的 $\textit{maxSum}_1+\textit{sum}_2$ 的最大值（记作 $\textit{maxSum}_{12}$）及其对应位置。

```Python [sol2-Python3]
class Solution:
    def maxSumOfTwoSubarrays(self, nums: List[int], k: int) -> List[int]:
        ans = []
        sum1, maxSum1, maxSum1Idx = 0, 0, 0
        sum2, maxSum12 = 0, 0
        for i in range(k, len(nums)):
            sum1 += nums[i - k]
            sum2 += nums[i]
            if i >= k * 2 - 1:
                if sum1 > maxSum1:
                    maxSum1 = sum1
                    maxSum1Idx = i - k * 2 + 1
                if maxSum1 + sum2 > maxSum12:
                    maxSum12 = maxSum1 + sum2
                    ans = [maxSum1Idx, i - k + 1]
                sum1 -= nums[i - k * 2 + 1]
                sum2 -= nums[i - k + 1]
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> maxSumOfTwoSubarrays(vector<int> &nums, int k) {
        vector<int> ans;
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0;
        for (int i = k; i < nums.size(); ++i) {
            sum1 += nums[i - k];
            sum2 += nums[i];
            if (i >= k * 2 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 2 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    ans = {maxSum1Idx, i - k + 1};
                }
                sum1 -= nums[i - k * 2 + 1];
                sum2 -= nums[i - k + 1];
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] maxSumOfTwoSubarrays(int[] nums, int k) {
        int[] ans = new int[2];
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0;
        for (int i = k; i < nums.length; ++i) {
            sum1 += nums[i - k];
            sum2 += nums[i];
            if (i >= k * 2 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 2 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    ans[0] = maxSum1Idx;
                    ans[1] = i - k + 1;
                }
                sum1 -= nums[i - k * 2 + 1];
                sum2 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] MaxSumOfTwoSubarrays(int[] nums, int k) {
        int[] ans = new int[2];
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0;
        for (int i = k; i < nums.Length; ++i) {
            sum1 += nums[i - k];
            sum2 += nums[i];
            if (i >= k * 2 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 2 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    ans[0] = maxSum1Idx;
                    ans[1] = i - k + 1;
                }
                sum1 -= nums[i - k * 2 + 1];
                sum2 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func maxSumOfTwoSubarrays(nums []int, k int) (ans []int) {
    var sum1, maxSum1, maxSum1Idx int
    var sum2, maxSum12 int
    for i := k; i < len(nums); i++ {
        sum1 += nums[i-k]
        sum2 += nums[i]
        if i >= k*2-1 {
            if sum1 > maxSum1 {
                maxSum1 = sum1
                maxSum1Idx = i - k*2 + 1
            }
            if maxSum1+sum2 > maxSum12 {
                maxSum12 = maxSum1 + sum2
                ans = []int{maxSum1Idx, i - k + 1}
            }
            sum1 -= nums[i-k*2+1]
            sum2 -= nums[i-k+1]
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
const maxSumOfTwoSubarrays = (nums, k) => {
    const ans = [0, 0];
    let sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
    let sum2 = 0, maxSum12 = 0;
    for (let i = k; i < nums.length; ++i) {
        sum1 += nums[i - k];
        sum2 += nums[i];
        if (i >= k * 2 - 1) {
            if (sum1 > maxSum1) {
                maxSum1 = sum1;
                maxSum1Idx = i - k * 2 + 1;
            }
            if (maxSum1 + sum2 > maxSum12) {
                maxSum12 = maxSum1 + sum2;
                ans[0] = maxSum1Idx;
                ans[1] = i - k + 1;
            }
            sum1 -= nums[i - k * 2 + 1];
            sum2 -= nums[i - k + 1];
        }
    }
    return ans;
}
```

#### 方法一：滑动窗口

回到本题，我们使用三个大小为 $k$ 的滑动窗口。设 $\textit{sum}_1$ 为第一个滑动窗口的元素和，该滑动窗口从 $[0,k-1]$ 开始；$\textit{sum}_2$ 为第二个滑动窗口的元素和，该滑动窗口从 $[k,2k-1]$ 开始；$\textit{sum}_3$ 为第三个滑动窗口的元素和，该滑动窗口从 $[2k,3k-1]$ 开始。

我们同时向右滑动这三个窗口，按照前言二的方法并维护 $\textit{maxSum}_{12}$ 及其对应位置。每次滑动时，计算当前 $\textit{maxSum}_{12}$ 与 $\textit{sum}_3$ 之和。统计这一过程中的 $\textit{maxSum}_{12}+\textit{sum}_3$ 的最大值及其对应位置。

对于题目要求的最小字典序，由于我们是从左向右遍历的，并且仅当元素和超过最大元素和时才修改最大元素和，从而保证求出来的下标列表是字典序最小的。

```Python [sol3-Python3]
class Solution:
    def maxSumOfThreeSubarrays(self, nums: List[int], k: int) -> List[int]:
        ans = []
        sum1, maxSum1, maxSum1Idx = 0, 0, 0
        sum2, maxSum12, maxSum12Idx = 0, 0, ()
        sum3, maxTotal = 0, 0
        for i in range(k * 2, len(nums)):
            sum1 += nums[i - k * 2]
            sum2 += nums[i - k]
            sum3 += nums[i]
            if i >= k * 3 - 1:
                if sum1 > maxSum1:
                    maxSum1 = sum1
                    maxSum1Idx = i - k * 3 + 1
                if maxSum1 + sum2 > maxSum12:
                    maxSum12 = maxSum1 + sum2
                    maxSum12Idx = (maxSum1Idx, i - k * 2 + 1)
                if maxSum12 + sum3 > maxTotal:
                    maxTotal = maxSum12 + sum3
                    ans = [*maxSum12Idx, i - k + 1]
                sum1 -= nums[i - k * 3 + 1]
                sum2 -= nums[i - k * 2 + 1]
                sum3 -= nums[i - k + 1]
        return ans
```

```C++ [sol3-C++]
class Solution {
public:
    vector<int> maxSumOfThreeSubarrays(vector<int> &nums, int k) {
        vector<int> ans;
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0, maxSum12Idx1 = 0, maxSum12Idx2 = 0;
        int sum3 = 0, maxTotal = 0;
        for (int i = k * 2; i < nums.size(); ++i) {
            sum1 += nums[i - k * 2];
            sum2 += nums[i - k];
            sum3 += nums[i];
            if (i >= k * 3 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 3 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    maxSum12Idx1 = maxSum1Idx;
                    maxSum12Idx2 = i - k * 2 + 1;
                }
                if (maxSum12 + sum3 > maxTotal) {
                    maxTotal = maxSum12 + sum3;
                    ans = {maxSum12Idx1, maxSum12Idx2, i - k + 1};
                }
                sum1 -= nums[i - k * 3 + 1];
                sum2 -= nums[i - k * 2 + 1];
                sum3 -= nums[i - k + 1];
            }
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] maxSumOfThreeSubarrays(int[] nums, int k) {
        int[] ans = new int[3];
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0, maxSum12Idx1 = 0, maxSum12Idx2 = 0;
        int sum3 = 0, maxTotal = 0;
        for (int i = k * 2; i < nums.length; ++i) {
            sum1 += nums[i - k * 2];
            sum2 += nums[i - k];
            sum3 += nums[i];
            if (i >= k * 3 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 3 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    maxSum12Idx1 = maxSum1Idx;
                    maxSum12Idx2 = i - k * 2 + 1;
                }
                if (maxSum12 + sum3 > maxTotal) {
                    maxTotal = maxSum12 + sum3;
                    ans[0] = maxSum12Idx1;
                    ans[1] = maxSum12Idx2;
                    ans[2] = i - k + 1;
                }
                sum1 -= nums[i - k * 3 + 1];
                sum2 -= nums[i - k * 2 + 1];
                sum3 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int[] MaxSumOfThreeSubarrays(int[] nums, int k) {
        int[] ans = new int[3];
        int sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
        int sum2 = 0, maxSum12 = 0, maxSum12Idx1 = 0, maxSum12Idx2 = 0;
        int sum3 = 0, maxTotal = 0;
        for (int i = k * 2; i < nums.Length; ++i) {
            sum1 += nums[i - k * 2];
            sum2 += nums[i - k];
            sum3 += nums[i];
            if (i >= k * 3 - 1) {
                if (sum1 > maxSum1) {
                    maxSum1 = sum1;
                    maxSum1Idx = i - k * 3 + 1;
                }
                if (maxSum1 + sum2 > maxSum12) {
                    maxSum12 = maxSum1 + sum2;
                    maxSum12Idx1 = maxSum1Idx;
                    maxSum12Idx2 = i - k * 2 + 1;
                }
                if (maxSum12 + sum3 > maxTotal) {
                    maxTotal = maxSum12 + sum3;
                    ans[0] = maxSum12Idx1;
                    ans[1] = maxSum12Idx2;
                    ans[2] = i - k + 1;
                }
                sum1 -= nums[i - k * 3 + 1];
                sum2 -= nums[i - k * 2 + 1];
                sum3 -= nums[i - k + 1];
            }
        }
        return ans;
    }
}
```

```go [sol3-Golang]
func maxSumOfThreeSubarrays(nums []int, k int) (ans []int) {
    var sum1, maxSum1, maxSum1Idx int
    var sum2, maxSum12, maxSum12Idx1, maxSum12Idx2 int
    var sum3, maxTotal int
    for i := k * 2; i < len(nums); i++ {
        sum1 += nums[i-k*2]
        sum2 += nums[i-k]
        sum3 += nums[i]
        if i >= k*3-1 {
            if sum1 > maxSum1 {
                maxSum1 = sum1
                maxSum1Idx = i - k*3 + 1
            }
            if maxSum1+sum2 > maxSum12 {
                maxSum12 = maxSum1 + sum2
                maxSum12Idx1, maxSum12Idx2 = maxSum1Idx, i-k*2+1
            }
            if maxSum12+sum3 > maxTotal {
                maxTotal = maxSum12 + sum3
                ans = []int{maxSum12Idx1, maxSum12Idx2, i - k + 1}
            }
            sum1 -= nums[i-k*3+1]
            sum2 -= nums[i-k*2+1]
            sum3 -= nums[i-k+1]
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
const maxSumOfThreeSubarrays = (nums, k) => {
    const ans = [0, 0, 0];
    let sum1 = 0, maxSum1 = 0, maxSum1Idx = 0;
    let sum2 = 0, maxSum12 = 0, maxSum12Idx1 = 0, maxSum12Idx2 = 0;
    let sum3 = 0, maxTotal = 0;
    for (let i = k * 2; i < nums.length; ++i) {
        sum1 += nums[i - k * 2];
        sum2 += nums[i - k];
        sum3 += nums[i];
        if (i >= k * 3 - 1) {
            if (sum1 > maxSum1) {
                maxSum1 = sum1;
                maxSum1Idx = i - k * 3 + 1;
            }
            if (maxSum1 + sum2 > maxSum12) {
                maxSum12 = maxSum1 + sum2;
                maxSum12Idx1 = maxSum1Idx;
                maxSum12Idx2 = i - k * 2 + 1;
            }
            if (maxSum12 + sum3 > maxTotal) {
                maxTotal = maxSum12 + sum3;
                ans[0] = maxSum12Idx1;
                ans[1] = maxSum12Idx2;
                ans[2] = i - k + 1;
            }
            sum1 -= nums[i - k * 3 + 1];
            sum2 -= nums[i - k * 2 + 1];
            sum3 -= nums[i - k + 1];
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。我们只需要常数空间来存放若干变量。

#### 结语

此题也可以用动态规划求解，总体思路是我们用 $\textit{dp}[i][j]$​ 表示到数组第 $j$​ 个元素为止，前 $i$​ 个互不重叠的子数组的最大值。对于当前第 $j$​ 个元素所对应的值，我们有不取和取两种选择，选择不取该元素，则值为到 $j-1$​ 个元素时前 $i$​ 个互不重叠的子数组的最大值，即 $\textit{dp}[i][j-1]$​ ，选择取该元素，则值为到 $j-k$​ 个元素时前 $i-1$​ 个互不重叠的子数组的最大值 $\textit{dp}[i-1][j-k]$​ 加上最后一段子数组的和，我们选择这两种情况下较大值即可，可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = 
\max(\textit{dp}[i][j-1],\textit{dp}[i-1][j-k]+\textit{sum}[j]-\textit{sum}[j-k])
$$

其中，$\textit{sum}$ 为前缀和数组。

感兴趣的读者可以自行尝试。