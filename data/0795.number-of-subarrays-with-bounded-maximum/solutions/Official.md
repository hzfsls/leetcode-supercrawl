## [795.区间子数组个数 中文官方题解](https://leetcode.cn/problems/number-of-subarrays-with-bounded-maximum/solutions/100000/qu-jian-zi-shu-zu-ge-shu-by-leetcode-sol-7it1)
#### 方法一：一次遍历

**思路与算法**

一个子数组的最大值范围在 $[\textit{left}, \textit{right}]$ 表示子数组中不能含有大于 $\textit{right}$ 的元素，且至少含有一个处于 $[\textit{left}, \textit{right}]$ 区间的元素。

我们可以将数组中的元素分为三类，并分别用 $0$, $1$, $2$ 来表示：

- 小于 $\textit{left}$，用 $0$ 表示；
- 大于等于 $\textit{left}$ 且小于等于 $\textit{right}$，用 $1$ 表示；
- 大于 $\textit{right}$，用 $2$ 表示。

那么本题可以转换为求解不包含 $2$，且至少包含一个 $1$ 的子数组数目。我们遍历 $i$，并将右端点固定在 $i$，求解有多少合法的子区间。过程中需要维护两个变量：

1. $\textit{last}_1$，表示上一次 $1$ 出现的位置，如果不存在则为 $-1$；
2. $\textit{last}_2$，表示上一次 $2$ 出现的位置，如果不存在则为 $-1$。

如果 $\textit{last}_1 \neq -1$，那么子数组若以 $i$ 为右端点，合法的左端点可以落在 $(\textit{last}_2, \textit{last}_1]$ 之间。这样的左端点共有 $\textit{last}_1 - \textit{last}_2$ 个。

因此，我们遍历 $i$：

1. 如果 $\textit{left} \le \textit{nums}[i] \le \textit{right}$，令 $\textit{last}_1 = i$；
2. 否则如果 $\textit{nums}[i] \gt \textit{right}$，令 $\textit{last}_2 = i$，$\textit{last}_1 = -1$。

然后将 $\textit{last}_1 - \textit{last}_2$ 累加到答案中即可。最后的总和即为题目所求。

**代码**

```Python [sol1-Python3]
class Solution:
    def numSubarrayBoundedMax(self, nums: List[int], left: int, right: int) -> int:
        res = 0
        last2 = last1 = -1
        for i, x in enumerate(nums):
            if left <= x <= right:
                last1 = i
            elif x > right:
                last2 = i
                last1 = -1
            if last1 != -1:
                res += last1 - last2
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int numSubarrayBoundedMax(vector<int>& nums, int left, int right) {
        int res = 0, last2 = -1, last1 = -1;
        for (int i = 0; i < nums.size(); i++) {
            if (nums[i] >= left && nums[i] <= right) {
                last1 = i;
            } else if (nums[i] > right) {
                last2 = i;
                last1 = -1;
            }
            if (last1 != -1) {
                res += last1 - last2;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSubarrayBoundedMax(int[] nums, int left, int right) {
        int res = 0, last2 = -1, last1 = -1;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] >= left && nums[i] <= right) {
                last1 = i;
            } else if (nums[i] > right) {
                last2 = i;
                last1 = -1;
            }
            if (last1 != -1) {
                res += last1 - last2;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumSubarrayBoundedMax(int[] nums, int left, int right) {
        int res = 0, last2 = -1, last1 = -1;
        for (int i = 0; i < nums.Length; i++) {
            if (nums[i] >= left && nums[i] <= right) {
                last1 = i;
            } else if (nums[i] > right) {
                last2 = i;
                last1 = -1;
            }
            if (last1 != -1) {
                res += last1 - last2;
            }
        }
        return res;
    }
}
```

```go [sol1-Golang]
func numSubarrayBoundedMax(nums []int, left int, right int) (res int) {
    last2, last1 := -1, -1
    for i, x := range nums {
        if left <= x && x <= right {
            last1 = i
        } else if x > right {
            last2 = i
            last1 = -1
        }
        if last1 != -1 {
            res += last1 - last2
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numSubarrayBoundedMax = function(nums, left, right) {
    let res = 0, last2 = -1, last1 = -1;
    for (let i = 0; i < nums.length; i++) {
        if (nums[i] >= left && nums[i] <= right) {
            last1 = i;
        } else if (nums[i] > right) {
            last2 = i;
            last1 = -1;
        }
        if (last1 !== -1) {
            res += last1 - last2;
        }
    }
    return res;
};  
```

```C [sol1-C]
int numSubarrayBoundedMax(int* nums, int numsSize, int left, int right) {
    int res = 0, last2 = -1, last1 = -1;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] >= left && nums[i] <= right) {
            last1 = i;
        } else if (nums[i] > right) {
            last2 = i;
            last1 = -1;
        }
        if (last1 != -1) {
            res += last1 - last2;
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。整个过程只需要遍历一次 $\textit{nums}$。

- 空间复杂度：$O(1)$。只使用到常数个变量。

#### 方法二：计数

**思路与算法**

方法一提到，我们要计算的合法子区间不包含 $2$ 且至少包含一个 $1$。所以，我们可以先求出只包含 $0$ 或 $1$ 的子区间数目，再减去只包括 $0$ 的子区间数目。

设函数 $\textit{count}(\textit{nums}, \textit{lower})$ 可以求出数组 $\textit{nums}$ 中所有元素小于等于 $lower$ 的子数组数目，那么题目所求就是 $\textit{count}(\textit{nums}, \textit{right}) - \textit{count}(\textit{nums}, \textit{left})$。

关于 $\textit{count}(\textit{nums}, \textit{lower})$ 的实现，我们用 $i$ 遍历 $\textit{nums}[i]$，$cur$ 表示 $i$ 左侧有多少个连续的元素小于等于 $\textit{lower}$：

1. 如果 $\textit{nums}[i] \le \textit{lower}$，令 $\textit{cur} = \textit{cur} + 1$；
2. 否则，令 $\textit{cur} = 0$。

每次将 $cur$ 加到答案中，最终的和即为 $\textit{count}$ 函数返回值。

**代码**

```Python [sol2-Python3]
class Solution:
    def numSubarrayBoundedMax(self, nums: List[int], left: int, right: int) -> int:
        def count(lower: int) -> int:
            res = cur = 0
            for x in nums:
                if x <= lower:
                    cur += 1
                else:
                    cur = 0
                res += cur
            return res
        return count(right) - count(left - 1)
```

```C++ [sol2-C++]
class Solution {
public:
    int numSubarrayBoundedMax(vector<int>& nums, int left, int right) {
        return count(nums, right) - count(nums, left - 1);
    }

    int count(vector<int>& nums, int lower) {
        int res = 0, cur = 0;
        for (auto x : nums) {
            cur = x <= lower ? cur + 1 : 0;
            res += cur;
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numSubarrayBoundedMax(int[] nums, int left, int right) {
        return count(nums, right) - count(nums, left - 1);
    }

    public int count(int[] nums, int lower) {
        int res = 0, cur = 0;
        for (int x : nums) {
            cur = x <= lower ? cur + 1 : 0;
            res += cur;
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumSubarrayBoundedMax(int[] nums, int left, int right) {
        return Count(nums, right) - Count(nums, left - 1);
    }

    public int Count(int[] nums, int lower) {
        int res = 0, cur = 0;
        foreach (int x in nums) {
            cur = x <= lower ? cur + 1 : 0;
            res += cur;
        }
        return res;
    }
}
```

```go [sol2-Golang]
func numSubarrayBoundedMax(nums []int, left int, right int) int {
    count := func(lower int) (res int) {
        cur := 0
        for _, x := range nums {
            if x <= lower {
                cur++
            } else {
                cur = 0
            }
            res += cur
        }
        return
    }
    return count(right) - count(left-1)
}
```

```JavaScript [sol2-JavaScript]
var numSubarrayBoundedMax = function(nums, left, right) {
    return count(nums, right) - count(nums, left - 1);
}

const count = (nums, lower) => {
    let res = 0, cur = 0;
    for (const x of nums) {
        cur = x <= lower ? cur + 1 : 0;
        res += cur;
    }
    return res;
};  
```

```C [sol2-C]
int count(const int *nums, int numsSize, int lower) {
    int res = 0, cur = 0;
    for (int i = 0; i < numsSize; i++) {
        cur = nums[i] <= lower ? cur + 1 : 0;
        res += cur;
    }
    return res;
}

int numSubarrayBoundedMax(int* nums, int numsSize, int left, int right) {
    return count(nums, numsSize, right) - count(nums, numsSize, left - 1);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。整个求解过程需要遍历两次 $\textit{nums}$。

- 空间复杂度：$O(1)$。只使用到常数个变量。