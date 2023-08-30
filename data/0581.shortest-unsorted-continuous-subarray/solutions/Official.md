#### 方法一：排序

**思路与算法**

我们将给定的数组 $\textit{nums}$ 表示为三段子数组拼接的形式，分别记作 $\textit{nums}_A$，$\textit{nums}_B$，$\textit{nums}_C$。当我们对 $\textit{nums}_B$ 进行排序，整个数组将变为有序。换而言之，当我们对整个序列进行排序，$\textit{nums}_A$ 和 $\textit{nums}_C$ 都不会改变。

本题要求我们找到最短的 $\textit{nums}_B$，即找到最大的 $\textit{nums}_A$ 和 $\textit{nums}_C$ 的长度之和。因此我们将原数组 $\textit{nums}$ 排序与原数组进行比较，取最长的相同的前缀为 $\textit{nums}_A$，取最长的相同的后缀为 $\textit{nums}_C$，这样我们就可以取到最短的 $\textit{nums}_B$。

具体地，我们创建数组 $\textit{nums}$ 的拷贝，记作数组 $\textit{numsSorted}$，并对该数组进行排序，然后我们从左向右找到第一个两数组不同的位置，即为 $\textit{nums}_B$ 的左边界。同理也可以找到 $\textit{nums}_B$ 右边界。最后我们输出 $\textit{nums}_B$ 的长度即可。

特别地，当原数组有序时，$\textit{nums}_B$ 的长度为 $0$，我们可以直接返回结果。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findUnsortedSubarray(vector<int>& nums) {
        if (is_sorted(nums.begin(), nums.end())) {
            return 0;
        }
        vector<int> numsSorted(nums);
        sort(numsSorted.begin(), numsSorted.end());
        int left = 0;
        while (nums[left] == numsSorted[left]) {
            left++;
        }
        int right = nums.size() - 1;
        while (nums[right] == numsSorted[right]) {
            right--;
        }
        return right - left + 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findUnsortedSubarray(int[] nums) {
        if (isSorted(nums)) {
            return 0;
        }
        int[] numsSorted = new int[nums.length];
        System.arraycopy(nums, 0, numsSorted, 0, nums.length);
        Arrays.sort(numsSorted);
        int left = 0;
        while (nums[left] == numsSorted[left]) {
            left++;
        }
        int right = nums.length - 1;
        while (nums[right] == numsSorted[right]) {
            right--;
        }
        return right - left + 1;
    }

    public boolean isSorted(int[] nums) {
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] < nums[i - 1]) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindUnsortedSubarray(int[] nums) {
        if (IsSorted(nums)) {
            return 0;
        }
        int[] numsSorted = new int[nums.Length];
        Array.Copy(nums, numsSorted, nums.Length);
        Array.Sort(numsSorted);
        int left = 0;
        while (nums[left] == numsSorted[left]) {
            left++;
        }
        int right = nums.Length - 1;
        while (nums[right] == numsSorted[right]) {
            right--;
        }
        return right - left + 1;
    }

    public bool IsSorted(int[] nums) {
        for (int i = 1; i < nums.Length; i++) {
            if (nums[i] < nums[i - 1]) {
                return false;
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findUnsortedSubarray(self, nums: List[int]) -> int:
        n = len(nums)

        def isSorted() -> bool:
            for i in range(1, n):
                if nums[i - 1] > nums[i]:
                    return False
            return True
        
        if isSorted():
            return 0
        
        numsSorted = sorted(nums)
        left = 0
        while nums[left] == numsSorted[left]:
            left += 1

        right = n - 1
        while nums[right] == numsSorted[right]:
            right -= 1
        
        return right - left + 1
```

```JavaScript [sol1-JavaScript]
var findUnsortedSubarray = function(nums) {
    if (isSorted(nums)) {
        return 0;
    }
    const numsSorted = [...nums].sort((a, b) => a - b);
    let left = 0;
    while (nums[left] === numsSorted[left]) {
        left++;
    }
    let right = nums.length - 1;
    while (nums[right] == numsSorted[right]) {
        right--;
    }
    return right - left + 1;
};

const isSorted = (nums) => {
    for (let i = 1; i < nums.length; i++) {
        if (nums[i] < nums[i - 1]) {
            return false;
        }
    }
    return true;
}
```

```go [sol1-Golang]
func findUnsortedSubarray(nums []int) int {
    if sort.IntsAreSorted(nums) {
        return 0
    }
    numsSorted := append([]int(nil), nums...)
    sort.Ints(numsSorted)
    left, right := 0, len(nums)-1
    for nums[left] == numsSorted[left] {
        left++
    }
    for nums[right] == numsSorted[right] {
        right--
    }
    return right - left + 1
}
```

```C [sol1-C]
bool is_sorted(int* arr, int arrSize) {
    for (int i = 1; i < arrSize; i++) {
        if (arr[i - 1] > arr[i]) {
            return false;
        }
    }
    return true;
}

int cmp(int* a, int* b) {
    return *a - *b;
}

int findUnsortedSubarray(int* nums, int numsSize) {
    if (is_sorted(nums, numsSize)) {
        return 0;
    }
    int numsSorted[numsSize];
    memcpy(numsSorted, nums, sizeof(int) * numsSize);
    qsort(numsSorted, numsSize, sizeof(int), cmp);
    int left = 0;
    while (nums[left] == numsSorted[left]) {
        left++;
    }
    int right = numsSize - 1;
    while (nums[right] == numsSorted[right]) {
        right--;
    }
    return right - left + 1;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为给定数组的长度。我们需要 $O(n \log n)$ 的时间进行排序，以及 $O(n)$ 的时间遍历数组，因此总时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为给定数组的长度。我们需要额外的一个数组保存排序后的数组 $\textit{numsSorted}$。

#### 方法二：一次遍历

**思路与算法**

假设 $\textit{nums}_B$ 在 $\textit{nums}$ 中对应区间为 $[\textit{left},\textit{right}]$。

注意到 $\textit{nums}_B$ 和 $\textit{nums}_C$ 中任意一个数都大于等于 $\textit{nums}_A$ 中任意一个数。因此有 $\textit{nums}_A$ 中每一个数 $\textit{nums}_i$ 都满足：

$$
\textit{nums}_i \leq \min_{j=i+1}^{n-1} \textit{nums}_j
$$

我们可以从大到小枚举 $i$，用一个变量 $\textit{minn}$ 记录 $\min_{j=i+1}^{n-1} \textit{nums}_j$。每次移动 $i$，都可以 $O(1)$ 地更新 $\textit{minn}$。这样最后一个使得不等式不成立的 $i$ 即为 $\textit{left}$。$\textit{left}$ 左侧即为 $\textit{nums}_A$ 能取得的最大范围。

同理，我们可以用类似的方法确定 $\textit{right}$。在实际代码中，我们可以在一次循环中同时完成左右边界的计算。

特别地，我们需要特判 $\textit{nums}$ 有序的情况，此时 $\textit{nums}_B$ 的长度为 $0$。当我们计算完成左右边界，即可返回 $\textit{nums}_B$ 的长度。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int findUnsortedSubarray(vector<int>& nums) {
        int n = nums.size();
        int maxn = INT_MIN, right = -1;
        int minn = INT_MAX, left = -1;
        for (int i = 0; i < n; i++) {
            if (maxn > nums[i]) {
                right = i;
            } else {
                maxn = nums[i];
            }
            if (minn < nums[n - i - 1]) {
                left = n - i - 1;
            } else {
                minn = nums[n - i - 1];
            }
        }
        return right == -1 ? 0 : right - left + 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int findUnsortedSubarray(int[] nums) {
        int n = nums.length;
        int maxn = Integer.MIN_VALUE, right = -1;
        int minn = Integer.MAX_VALUE, left = -1;
        for (int i = 0; i < n; i++) {
            if (maxn > nums[i]) {
                right = i;
            } else {
                maxn = nums[i];
            }
            if (minn < nums[n - i - 1]) {
                left = n - i - 1;
            } else {
                minn = nums[n - i - 1];
            }
        }
        return right == -1 ? 0 : right - left + 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindUnsortedSubarray(int[] nums) {
        int n = nums.Length;
        int maxn = int.MinValue, right = -1;
        int minn = int.MaxValue, left = -1;
        for (int i = 0; i < n; i++) {
            if (maxn > nums[i]) {
                right = i;
            } else {
                maxn = nums[i];
            }
            if (minn < nums[n - i - 1]) {
                left = n - i - 1;
            } else {
                minn = nums[n - i - 1];
            }
        }
        return right == -1 ? 0 : right - left + 1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def findUnsortedSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        maxn, right = float("-inf"), -1
        minn, left = float("inf"), -1

        for i in range(n):
            if maxn > nums[i]:
                right = i
            else:
                maxn = nums[i]
            
            if minn < nums[n - i - 1]:
                left = n - i - 1
            else:
                minn = nums[n - i - 1]
        
        return 0 if right == -1 else right - left + 1
```

```JavaScript [sol2-JavaScript]
var findUnsortedSubarray = function(nums) {
    const n = nums.length;
    let maxn = -Number.MAX_VALUE, right = -1;
    let minn = Number.MAX_VALUE, left = -1;
    for (let i = 0; i < n; i++) {
        if (maxn > nums[i]) {
            right = i;
        } else {
            maxn = nums[i];
        }
        if (minn < nums[n - i - 1]) {
            left = n - i - 1;
        } else {
            minn = nums[n - i - 1];
        }
    }
    return right === -1 ? 0 : right - left + 1;
};
```

```go [sol2-Golang]
func findUnsortedSubarray(nums []int) int {
    n := len(nums)
    minn, maxn := math.MaxInt64, math.MinInt64
    left, right := -1, -1
    for i, num := range nums {
        if maxn > num {
            right = i
        } else {
            maxn = num
        }
        if minn < nums[n-i-1] {
            left = n - i - 1
        } else {
            minn = nums[n-i-1]
        }
    }
    if right == -1 {
        return 0
    }
    return right - left + 1
}
```

```C [sol2-C]
int findUnsortedSubarray(int* nums, int numsSize) {
    int n = numsSize;
    int maxn = INT_MIN, right = -1;
    int minn = INT_MAX, left = -1;
    for (int i = 0; i < n; i++) {
        if (maxn > nums[i]) {
            right = i;
        } else {
            maxn = nums[i];
        }
        if (minn < nums[n - i - 1]) {
            left = n - i - 1;
        } else {
            minn = nums[n - i - 1];
        }
    }
    return right == -1 ? 0 : right - left + 1;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定数组的长度，我们仅需要遍历该数组一次。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。