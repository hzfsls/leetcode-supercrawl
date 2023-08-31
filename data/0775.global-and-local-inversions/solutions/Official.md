## [775.全局倒置与局部倒置 中文官方题解](https://leetcode.cn/problems/global-and-local-inversions/solutions/100000/quan-ju-dao-zhi-yu-ju-bu-dao-zhi-by-leet-bmjp)

#### 方法一：维护后缀最小值

**思路与算法**

一个局部倒置一定是一个全局倒置，因此要判断数组中局部倒置的数量是否与全局倒置的数量相等，只需要检查有没有非局部倒置就可以了。这里的非局部倒置指的是 $\textit{nums}[i] \gt \textit{nums}[j]$，其中 $i < j - 1$。

朴素的判断方法需要两层循环，设 $n$ 是 $\textit{nums}$ 的长度，那么该方法的时间复杂度为 $O(n^2)$，无法通过。

进一步的，对于每一个 $\textit{nums}[i]$ 判断是否存在一个 $j~(j \gt i + 1)$ 使得 $\textit{nums}[i] \gt nums[j]$ 即可。这和检查 $\textit{nums}[i] \gt \min(\textit{nums}[i+2],\dots,\textit{nums}[n-1])$ 是否成立是一致的。因此我们维护一个变量 $\textit{minSuffix} = \min(\textit{nums}[i+2],\dots,\textit{nums}[n-1])$，倒序遍历 $[0, n-3]$ 中的每个 $i$, 如有一个 $i$ 使得 $\textit{nums}[i] \gt \textit{minSuffix}$ 成立，返回 $\text{false}$，若结束遍历都没有返回 $\text{false}$，则返回 $\text{true}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def isIdealPermutation(self, nums: List[int]) -> bool:
        min_suf = nums[-1]
        for i in range(len(nums) - 2, 0, -1):
            if nums[i - 1] > min_suf:
                return False
            min_suf = min(min_suf, nums[i])
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool isIdealPermutation(vector<int>& nums) {
        int n = nums.size(), minSuff = nums[n - 1];
        for (int i = n - 3; i >= 0; i--) {
            if (nums[i] > minSuff) {
                return false;
            }
            minSuff = min(minSuff, nums[i + 1]);
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isIdealPermutation(int[] nums) {
        int n = nums.length, minSuff = nums[n - 1];
        for (int i = n - 3; i >= 0; i--) {
            if (nums[i] > minSuff) {
                return false;
            }
            minSuff = Math.min(minSuff, nums[i + 1]);
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsIdealPermutation(int[] nums) {
        int n = nums.Length, minSuff = nums[n - 1];
        for (int i = n - 3; i >= 0; i--) {
            if (nums[i] > minSuff) {
                return false;
            }
            minSuff = Math.Min(minSuff, nums[i + 1]);
        }
        return true;
    }
}
```

```go [sol1-Golang]
func isIdealPermutation(nums []int) bool {
    n := len(nums)
    minSuf := nums[n-1]
    for i := n - 2; i > 0; i-- {
        if nums[i-1] > minSuf {
            return false
        }
        minSuf = min(minSuf, nums[i])
    }
    return true
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var isIdealPermutation = function(nums) {
    let n = nums.length, minSuff = nums[n - 1];
    for (let i = n - 3; i >= 0; i--) {
        if (nums[i] > minSuff) {
            return false;
        }
        minSuff = Math.min(minSuff, nums[i + 1]);
    }
    return true;
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

bool isIdealPermutation(int* nums, int numsSize) {
    int minSuff = nums[numsSize - 1];
    for (int i = numsSize - 3; i >= 0; i--) {
        if (nums[i] > minSuff) {
            return false;
        }
        minSuff = MIN(minSuff, nums[i + 1]);
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$，只使用到常数个变量空间。

#### 方法二：归纳证明

**思路与算法**

$\textit{nums}$ 是一个由 $0\sim n-1$ 组成的排列，设不存在非局部倒置的排列为「理想排列」。由于非局部倒置表示存在一个 $j > i + 1$ 使得 $\textit{nums}[i] > \textit{nums}[j]$ 成立，所以对于最小的元素 $0$ 来说，它的下标不能够大于等于 $2$。所以有：

1. 若 $\textit{nums}[0] = 0$，那么问题转换为 $[1, n - 1]$ 区间的一个子问题。
2. 若 $\textit{nums}[1] = 0$，那么 $\textit{nums}[0]$ 只能为 $1$，因为如果是大于 $1$ 的任何元素，都将会与后面的 $1$ 构成非局部倒置。此时，问题转换为了 $[2, n - 1]$ 区间的一个子问题。

根据上述讨论，不难归纳出「理想排列」的充分必要条件为对于每个元素 $\textit{nums}[i]$ 都满足 $\big| \textit{nums}[i] - i \big| \le 1$。

**代码**

```Python [sol2-Python3]
class Solution:
    def isIdealPermutation(self, nums: List[int]) -> bool:
        return all(abs(x - i) <= 1 for i, x in enumerate(nums))
```

```C++ [sol2-C++]
class Solution {
public:
    bool isIdealPermutation(vector<int>& nums) {
        for (int i = 0; i < nums.size(); i++) {
            if (abs(nums[i] - i) > 1) {
                return false;
            }
        }
        return true;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isIdealPermutation(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            if (Math.abs(nums[i] - i) > 1) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IsIdealPermutation(int[] nums) {
        for (int i = 0; i < nums.Length; i++) {
            if (Math.Abs(nums[i] - i) > 1) {
                return false;
            }
        }
        return true;
    }
}
```

```go [sol2-Golang]
func isIdealPermutation(nums []int) bool {
    for i, x := range nums {
        if abs(x-i) > 1 {
            return false
        }
    }
    return true
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol2-JavaScript]
var isIdealPermutation = function(nums) {
    for (let i = 0; i < nums.length; i++) {
        if (Math.abs(nums[i] - i) > 1) {
            return false;
        }
    }
    return true;
};
```

```C [sol2-C]
bool isIdealPermutation(int* nums, int numsSize){
    for (int i = 0; i < numsSize; i++) {
        if (abs(nums[i] - i) > 1) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$，只使用到常数个变量空间。