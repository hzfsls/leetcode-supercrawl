## [611.有效三角形的个数 中文官方题解](https://leetcode.cn/problems/valid-triangle-number/solutions/100000/you-xiao-san-jiao-xing-de-ge-shu-by-leet-t2td)

#### 方法一：排序 + 二分查找

**思路与算法**

对于正整数 $a, b, c$，它们可以作为三角形的三条边，当且仅当：

$$
\begin{cases}
a + b > c \\
a + c > b \\
b + c > a
\end{cases}
$$

均成立。如果我们将三条边进行升序排序，使它们满足 $a \leq b \leq c$，那么 $a + c > b$ 和 $b + c > a$ 使一定成立的，我们只需要保证 $a + b > c$。

因此，我们可以将数组 $\textit{nums}$ 进行升序排序，随后使用二重循环枚举 $a$ 和 $b$。设 $a = \textit{nums}[i], b = \textit{nums}[j]$，为了防止重复统计答案，我们需要保证 $i < j$。剩余的边 $c$ 需要满足 $c < \textit{nums}[i] + \textit{nums}[j]$，我们可以在 $[j + 1, n - 1]$ 的下标范围内使用二分查找（其中 $n$ 是数组 $\textit{nums}$ 的长度），找出最大的满足 $\textit{nums}[k] < \textit{nums}[i] + \textit{nums}[j]$ 的下标 $k$，这样一来，在 $[j + 1, k]$ 范围内的下标都可以作为边 $c$ 的下标，我们将该范围的长度 $k - j$ 累加入答案。

当枚举完成后，我们返回累加的答案即可。

**细节**

注意到题目描述中 $\textit{nums}$ 包含的元素为**非负整数**，即除了正整数以外，$\textit{nums}$ 还会包含 $0$。但如果我们将 $\textit{nums}$ 进行升序排序，那么在枚举 $a$ 和 $b$ 时出现了 $0$，那么 $\textit{nums}[i]$ 一定为 $0$。此时，边 $c$ 需要满足 $c < \textit{nums}[i] + \textit{nums}[j] = \textit{nums}[j]$，而下标在 $[j + 1, n - 1]$ 范围内的元素一定都是大于等于 $\textit{nums}[j]$ 的，因此二分查找会失败。若二分查找失败，我们可以令 $k = j$，此时对应的范围长度 $k - j = 0$，我们也就保证了答案的正确性。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int triangleNumber(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int left = j + 1, right = n - 1, k = j;
                while (left <= right) {
                    int mid = (left + right) / 2;
                    if (nums[mid] < nums[i] + nums[j]) {
                        k = mid;
                        left = mid + 1;
                    }
                    else {
                        right = mid - 1;
                    }
                }
                ans += k - j;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int triangleNumber(int[] nums) {
        int n = nums.length;
        Arrays.sort(nums);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int left = j + 1, right = n - 1, k = j;
                while (left <= right) {
                    int mid = (left + right) / 2;
                    if (nums[mid] < nums[i] + nums[j]) {
                        k = mid;
                        left = mid + 1;
                    } else {
                        right = mid - 1;
                    }
                }
                ans += k - j;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int TriangleNumber(int[] nums) {
        int n = nums.Length;
        Array.Sort(nums);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int left = j + 1, right = n - 1, k = j;
                while (left <= right) {
                    int mid = (left + right) / 2;
                    if (nums[mid] < nums[i] + nums[j]) {
                        k = mid;
                        left = mid + 1;
                    } else {
                        right = mid - 1;
                    }
                }
                ans += k - j;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def triangleNumber(self, nums: List[int]) -> int:
        n = len(nums)
        nums.sort()
        ans = 0
        for i in range(n):
            for j in range(i + 1, n):
                left, right, k = j + 1, n - 1, j
                while left <= right:
                    mid = (left + right) // 2
                    if nums[mid] < nums[i] + nums[j]:
                        k = mid
                        left = mid + 1
                    else:
                        right = mid - 1
                ans += k - j
        return ans
```

```JavaScript [sol1-JavaScript]
var triangleNumber = function(nums) {
    const n = nums.length;
    nums.sort((a, b) => a - b);
    let ans = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = i + 1; j < n; ++j) {
            let left = j + 1, right = n - 1, k = j;
            while (left <= right) {
                const mid = Math.floor((left + right) / 2);
                if (nums[mid] < nums[i] + nums[j]) {
                    k = mid;
                    left = mid + 1;
                } else {
                    right = mid - 1;
                }
            }
            ans += k - j;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func triangleNumber(nums []int) (ans int) {
    sort.Ints(nums)
    for i, v := range nums {
        for j := i + 1; j < len(nums); j++ {
            ans += sort.SearchInts(nums[j+1:], v+nums[j])
        }
    }
    return
}
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int triangleNumber(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int ans = 0;
    for (int i = 0; i < numsSize; ++i) {
        for (int j = i + 1; j < numsSize; ++j) {
            int left = j + 1, right = numsSize - 1, k = j;
            while (left <= right) {
                int mid = (left + right) / 2;
                if (nums[mid] < nums[i] + nums[j]) {
                    k = mid;
                    left = mid + 1;
                }
                else {
                    right = mid - 1;
                }
            }
            ans += k - j;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。我们需要 $O(n \log n)$ 的时间对数组 $\textit{nums}$ 进行排序，随后需要 $O(n^2 \log n)$ 的时间使用二重循环枚举 $a, b$ 的下标以及使用二分查找得到 $c$ 的下标范围。

- 空间复杂度：$O(\log n)$，即为排序需要的栈空间。

#### 方法二：排序 + 双指针

**思路与算法**

我们可以对方法一进行优化。

我们将当 $a = \textit{nums}[i], b = \textit{nums}[j]$ 时，最大的满足 $\textit{nums}[k] < \textit{nums}[i] + \textit{nums}[j]$ 的下标 $k$ 记为 $k_{i, j}$。可以发现，如果我们固定 $i$，那么随着 $j$ 的递增，不等式右侧 $\textit{nums}[i] + \textit{nums}[j]$ 也是递增的，因此 $k_{i, j}$ 也是递增的。

这样一来，我们就可以将 $j$ 和 $k$ 看成两个同向（递增）移动的指针，将方法一进行如下的优化：

- 我们使用一重循环枚举 $i$。当 $i$ 固定时，我们使用双指针同时维护 $j$ 和 $k$，它们的初始值均为 $i$；

- 我们每一次将 $j$ 向右移动一个位置，即 $j \leftarrow j+1$，并尝试不断向右移动 $k$，使得 $k$ 是最大的满足 $\textit{nums}[k] < \textit{nums}[i] + \textit{nums}[j]$ 的下标。我们将 $\max(k - j, 0)$ 累加入答案。

当枚举完成后，我们返回累加的答案即可。

**细节**

与方法一中「二分查找的失败」类似，方法二的双指针中，也会出现不存在满足 $\textit{nums}[k] < \textit{nums}[i] + \textit{nums}[j]$ 的下标的情况。此时，指针 $k$ 不会出现在指针 $j$ 的右侧，即 $k - j \leq 0$，因此我们需要将 $k - j$ 与 $0$ 中的较大值累加入答案，防止错误的负数出现。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int triangleNumber(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            int k = i;
            for (int j = i + 1; j < n; ++j) {
                while (k + 1 < n && nums[k + 1] < nums[i] + nums[j]) {
                    ++k;
                }
                ans += max(k - j, 0);
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int triangleNumber(int[] nums) {
        int n = nums.length;
        Arrays.sort(nums);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            int k = i;
            for (int j = i + 1; j < n; ++j) {
                while (k + 1 < n && nums[k + 1] < nums[i] + nums[j]) {
                    ++k;
                }
                ans += Math.max(k - j, 0);
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int TriangleNumber(int[] nums) {
        int n = nums.Length;
        Array.Sort(nums);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            int k = i;
            for (int j = i + 1; j < n; ++j) {
                while (k + 1 < n && nums[k + 1] < nums[i] + nums[j]) {
                    ++k;
                }
                ans += Math.Max(k - j, 0);
            }
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def triangleNumber(self, nums: List[int]) -> int:
        n = len(nums)
        nums.sort()
        ans = 0
        for i in range(n):
            k = i
            for j in range(i + 1, n):
                while k + 1 < n and nums[k + 1] < nums[i] + nums[j]:
                    k += 1
                ans += max(k - j, 0)
        return ans
```

```JavaScript [sol2-JavaScript]
var triangleNumber = function(nums) {
    const n = nums.length;
    nums.sort((a, b) => a - b);
    let ans = 0;
    for (let i = 0; i < n; ++i) {
        let k = i;
        for (let j = i + 1; j < n; ++j) {
            while (k + 1 < n && nums[k + 1] < nums[i] + nums[j]) {
                ++k;
            }
            ans += Math.max(k - j, 0);
        }
    }
    return ans;
};
```

```go [sol2-Golang]
func triangleNumber(nums []int) (ans int) {
    n := len(nums)
    sort.Ints(nums)
    for i, v := range nums {
        k := i
        for j := i + 1; j < n; j++ {
            for k+1 < n && nums[k+1] < v+nums[j] {
                k++
            }
            ans += max(k-j, 0)
        }
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int triangleNumber(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int ans = 0;
    for (int i = 0; i < numsSize; ++i) {
        int k = i;
        for (int j = i + 1; j < numsSize; ++j) {
            while (k + 1 < numsSize && nums[k + 1] < nums[i] + nums[j]) {
                ++k;
            }
            ans += fmax(k - j, 0);
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。我们需要 $O(n \log n)$ 的时间对数组 $\textit{nums}$ 进行排序，随后需要 $O(n^2)$ 的时间使用一重循环枚举 $a$ 的下标以及使用双指针维护 $b, c$ 的下标。

- 空间复杂度：$O(\log n)$，即为排序需要的栈空间。