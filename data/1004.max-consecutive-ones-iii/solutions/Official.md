## [1004.最大连续1的个数 III 中文官方题解](https://leetcode.cn/problems/max-consecutive-ones-iii/solutions/100000/zui-da-lian-xu-1de-ge-shu-iii-by-leetcod-hw12)

#### 前言

对于数组 $A$ 的区间 $[\textit{left}, \textit{right}]$ 而言，只要它包含不超过 $k$ 个 $0$，我们就可以根据它构造出一段满足要求，并且长度为 $\textit{right} - \textit{left} + 1$ 的区间。

因此，我们可以将该问题进行如下的转化，即：

> 对于任意的右端点 $\textit{right}$，希望找到最小的左端点 $\textit{left}$，使得 $[\textit{left}, \textit{right}]$ 包含不超过 $k$ 个 $0$。
>
> 只要我们枚举所有可能的右端点，将得到的区间的长度取最大值，即可得到答案。

要想快速判断一个区间内 $0$ 的个数，我们可以考虑将数组 $A$ 中的 $0$ 变成 $1$，$1$ 变成 $0$。此时，我们对数组 $A$ 求出前缀和，记为数组 $P$，那么 $[\textit{left}, \textit{right}]$ 中包含不超过 $k$ 个 $1$（注意这里就不是 $0$ 了），当且仅当二者的前缀和之差：

$$
P[\textit{right}] - P[\textit{left} - 1]
$$

小于等于 $k$。这样一来，我们就可以容易地解决这个问题了。

#### 方法一：二分查找

**思路与算法**

$$
P[\textit{right}] - P[\textit{left} - 1] \leq k
$$

等价于

$$
P[\textit{left} - 1] \geq P[\textit{right}] - k \tag{1}
$$

也就是说，我们需要找到最小的满足 $(1)$ 式的 $\textit{left}$。由于数组 $A$ 中仅包含 $0/1$，因此前缀和数组是一个单调递增的数组，我们就可以使用二分查找的方法得到 $\textit{left}$。

**细节**

注意到 $(1)$ 式的左侧的下标是 $\textit{left}-1$ 而不是 $\textit{left}$，那么我们在构造前缀和数组时，可以将前缀和整体向右移动一位，空出 $P[0]$ 的位置，即：

$$
\begin{cases}
P[0] = 0 \\
P[i] = P[i-1] + (1 - A[i-1])
\end{cases}
$$

此时，我们在数组 $P$ 上二分查找到的下标即为 $\textit{left}$ 本身，同时我们也避免了原先 $\textit{left}=0$ 时 $\textit{left}-1=-1$ 不在数组合法的下标范围中的边界情况。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int longestOnes(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> P(n + 1);
        for (int i = 1; i <= n; ++i) {
            P[i] = P[i - 1] + (1 - nums[i - 1]);
        }

        int ans = 0;
        for (int right = 0; right < n; ++right) {
            int left = lower_bound(P.begin(), P.end(), P[right + 1] - k) - P.begin();
            ans = max(ans, right - left + 1);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestOnes(int[] nums, int k) {
        int n = nums.length;
        int[] P = new int[n + 1];
        for (int i = 1; i <= n; ++i) {
            P[i] = P[i - 1] + (1 - nums[i - 1]);
        }

        int ans = 0;
        for (int right = 0; right < n; ++right) {
            int left = binarySearch(P, P[right + 1] - k);
            ans = Math.max(ans, right - left + 1);
        }
        return ans;
    }

    public int binarySearch(int[] P, int target) {
        int low = 0, high = P.length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (P[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestOnes(self, nums: List[int], k: int) -> int:
        n = len(nums)
        P = [0]
        for num in nums:
            P.append(P[-1] + (1 - num))
        
        ans = 0
        for right in range(n):
            left = bisect.bisect_left(P, P[right + 1] - k)
            ans = max(ans, right - left + 1)
        
        return ans
```

```JavaScript [sol1-JavaScript]
var longestOnes = function(nums, k) {
    const n = nums.length;
    const P = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; ++i) {
        P[i] = P[i - 1] + (1 - nums[i - 1]);
    }

    let ans = 0;
    for (let right = 0; right < n; ++right) {
        const left = binarySearch(P, P[right + 1] - k);
        ans = Math.max(ans, right - left + 1);
    }
    return ans;
};

const binarySearch = (P, target) => {
    let low = 0, high = P.length - 1;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (P[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
};
```

```go [sol1-Golang]
func longestOnes(nums []int, k int) (ans int) {
    n := len(nums)
    P := make([]int, n+1)
    for i, v := range nums {
        P[i+1] = P[i] + 1 - v
    }
    for right, v := range P {
        left := sort.SearchInts(P, v-k)
        ans = max(ans, right-left)
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

```C [sol1-C]
int binarySearch(int* P, int len, int target) {
    int low = 0, high = len - 1;
    while (low < high) {
        int mid = (high - low) / 2 + low;
        if (P[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

int longestOnes(int* nums, int numsSize, int k) {
    int P[numsSize + 1];
    P[0] = 0;
    for (int i = 1; i <= numsSize; ++i) {
        P[i] = P[i - 1] + (1 - nums[i - 1]);
    }

    int ans = 0;
    for (int right = 0; right < numsSize; ++right) {
        int left = binarySearch(P, numsSize + 1, P[right + 1] - k);
        ans = fmax(ans, right - left + 1);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $A$ 的长度。每一次二分查找的时间复杂度为 $O(\log n)$，我们需要枚举 $\textit{right}$ 进行 $n$ 次二分查找，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为前缀和数组 $P$ 需要的空间。

#### 方法二：滑动窗口

**思路与算法**

我们继续观察 $(1)$ 式，由于前缀和数组 $P$ 是单调递增的，那么 $(1)$ 式的右侧 $P[\textit{right}] - k$ 同样也是单调递增的。因此，我们可以发现：

> 随着 $\textit{right}$ 的增大，满足 $(1)$ 式的最小的 $\textit{left}$ 值是单调递增的。

这样一来，我们就可以使用滑动窗口来实时地维护 $\textit{left}$ 和 $\textit{right}$ 了。在 $\textit{right}$ 向右移动的过程中，我们同步移动 $\textit{left}$，直到 $\textit{left}$ 为首个（即最小的）满足 $(1)$ 式的位置，此时我们就可以使用此区间对答案进行更新了。

**细节**

当我们使用滑动窗口代替二分查找解决本题时，就不需要显式地计算并保存出前缀和数组了。我们只需要知道 $\textit{left}$ 和 $\textit{right}$ 作为下标在前缀和数组中对应的值，因此我们只需要用两个变量 $\textit{lsum}$ 和 $\textit{rsum}$ 记录 $\textit{left}$ 和 $\textit{right}$ 分别对应的前缀和即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int longestOnes(vector<int>& nums, int k) {
        int n = nums.size();
        int left = 0, lsum = 0, rsum = 0;
        int ans = 0;
        for (int right = 0; right < n; ++right) {
            rsum += 1 - nums[right];
            while (lsum < rsum - k) {
                lsum += 1 - nums[left];
                ++left;
            }
            ans = max(ans, right - left + 1);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int longestOnes(int[] nums, int k) {
        int n = nums.length;
        int left = 0, lsum = 0, rsum = 0;
        int ans = 0;
        for (int right = 0; right < n; ++right) {
            rsum += 1 - nums[right];
            while (lsum < rsum - k) {
                lsum += 1 - nums[left];
                ++left;
            }
            ans = Math.max(ans, right - left + 1);
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def longestOnes(self, nums: List[int], k: int) -> int:
        n = len(nums)
        left = lsum = rsum = 0
        ans = 0
        
        for right in range(n):
            rsum += 1 - nums[right]
            while lsum < rsum - k:
                lsum += 1 - nums[left]
                left += 1
            ans = max(ans, right - left + 1)
        
        return ans
```

```JavaScript [sol2-JavaScript]
var longestOnes = function(nums, k) {
    const n = nums.length;
    let left = 0, lsum = 0, rsum = 0;
    let ans = 0;
    for (let right = 0; right < n; ++right) {
        rsum += 1 - nums[right];
        while (lsum < rsum - k) {
            lsum += 1 - nums[left];
            ++left;
        }
        ans = Math.max(ans, right - left + 1);
    }
    return ans;
};
```

```go [sol2-Golang]
func longestOnes(nums []int, k int) (ans int) {
    var left, lsum, rsum int
    for right, v := range nums {
        rsum += 1 - v
        for lsum < rsum-k {
            lsum += 1 - nums[left]
            left++
        }
        ans = max(ans, right-left+1)
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
int longestOnes(int* nums, int numsSize, int k) {
    int left = 0, lsum = 0, rsum = 0;
    int ans = 0;
    for (int right = 0; right < numsSize; ++right) {
        rsum += 1 - nums[right];
        while (lsum < rsum - k) {
            lsum += 1 - nums[left];
            ++left;
        }
        ans = fmax(ans, right - left + 1);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $A$ 的长度。我们至多只需要遍历该数组两次（左右指针各一次）。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。