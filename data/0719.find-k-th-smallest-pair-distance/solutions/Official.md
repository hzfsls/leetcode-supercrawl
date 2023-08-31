## [719.找出第 K 小的数对距离 中文官方题解](https://leetcode.cn/problems/find-k-th-smallest-pair-distance/solutions/100000/zhao-chu-di-k-xiao-de-shu-dui-ju-chi-by-xwfgf)

#### 方法一：排序 + 二分查找

先将数组 $\textit{nums}$ 从小到大进行排序。因为第 $k$ 小的数对距离必然在区间 $[0, \max (\textit{nums}) - \min(\textit{nums})]$ 内，令 $\textit{left} = 0$，$\textit{right} = \max (\textit{nums}) - \min(\textit{nums})$，我们在区间 $[\textit{left}, \textit{right}]$ 上进行二分。

对于当前搜索的距离 $\textit{mid}$，计算所有距离小于等于 $\textit{mid}$ 的数对数目 $\textit{cnt}$，如果 $\textit{cnt} \ge k$，那么 $\textit{right} = \textit{mid} - 1$，否则 $\textit{left} = \textit{mid} + 1$。当 $\textit{left} \gt \textit{right}$ 时，终止搜索，那么第 $k$ 小的数对距离为 $\textit{left}$。

给定距离 $\textit{mid}$，计算所有距离小于等于 $\textit{mid}$ 的数对数目 $\textit{cnt}$ 可以使用二分查找：枚举所有数对的右端点 $j$，二分查找大于等于 $\textit{nums}[j] - \textit{mid}$ 的最小值的下标 $i$，那么右端点为 $j$ 且距离小于等于 $\textit{mid}$ 的数对数目为 $j - i$，计算这些数目之和。

```Python [sol1-Python3]
class Solution:
    def smallestDistancePair(self, nums: List[int], k: int) -> int:
        def count(mid: int) -> int:
            cnt = 0
            for j, num in enumerate(nums):
                i = bisect_left(nums, num - mid, 0, j)
                cnt += j - i
            return cnt

        nums.sort()
        return bisect_left(range(nums[-1] - nums[0]), k, key=count)
```

```C++ [sol1-C++]
class Solution {
public:
    int smallestDistancePair(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        int n = nums.size(), left = 0, right = nums.back() - nums.front();
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                int i = lower_bound(nums.begin(), nums.begin() + j, nums[j] - mid) - nums.begin();
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int smallestDistancePair(int[] nums, int k) {
        Arrays.sort(nums);
        int n = nums.length, left = 0, right = nums[n - 1] - nums[0];
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                int i = binarySearch(nums, j, nums[j] - mid);
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }

    public int binarySearch(int[] nums, int end, int target) {
        int left = 0, right = end;
        while (left < right) {
            int mid = (left + right) / 2;
            if (nums[mid] < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SmallestDistancePair(int[] nums, int k) {
        Array.Sort(nums);
        int n = nums.Length, left = 0, right = nums[n - 1] - nums[0];
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                int i = BinarySearch(nums, j, nums[j] - mid);
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }

    public int BinarySearch(int[] nums, int end, int target) {
        int left = 0, right = end;
        while (left < right) {
            int mid = (left + right) / 2;
            if (nums[mid] < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }
}
```

```C [sol1-C]
int cmp(const void* pa, const void* pb) {
    return *(int *)pa - *(int *)pb;
}

int binarySearch(int* nums, int end, int target) {
    int left = 0, right = end - 1;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (nums[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return left;
}

int smallestDistancePair(int* nums, int numsSize, int k) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int left = 0, right = nums[numsSize - 1] - nums[0];
    while (left <= right) {
        int mid = (left + right) / 2;
        int cnt = 0;
        for (int j = 0; j < numsSize; j++) {
            int i = binarySearch(nums, j, nums[j] - mid);
            cnt += j - i;
        }
        if (cnt >= k) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

```go [sol1-Golang]
func smallestDistancePair(nums []int, k int) int {
    sort.Ints(nums)
    return sort.Search(nums[len(nums)-1]-nums[0], func(mid int) bool {
        cnt := 0
        for j, num := range nums {
            i := sort.SearchInts(nums[:j], num-mid)
            cnt += j - i
        }
        return cnt >= k
    })
}
```

```JavaScript [sol1-JavaScript]
var smallestDistancePair = function(nums, k) {
    nums.sort((a, b) => a - b);
    let n = nums.length, left = 0, right = nums[n - 1] - nums[0];
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        let cnt = 0;
        for (let j = 0; j < n; j++) {
            const i = binarySearch(nums, j, nums[j] - mid);
            cnt += j - i;
        }
        if (cnt >= k) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return left;
};

const binarySearch = (nums, end, target) => {
    let left = 0, right = end;
    while (left < right) {
        const mid = Math.floor((left + right) / 2);
        if (nums[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n \times \log D)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$D = \max(\textit{nums}) - \min(\textit{nums})$。外层二分查找需要 $O(\log D)$，内层二分查找需要 $O(n \log n)$。

+ 空间复杂度：$O(\log n)$。排序的平均空间复杂度为 $O(\log n)$。

#### 方法二：排序 + 二分查找 + 双指针

给定距离 $\textit{mid}$，计算所有距离小于等于 $\textit{mid}$ 的数对数目 $\textit{cnt}$ 可以使用双指针：初始左端点 $i = 0$，我们从小到大枚举所有数对的右端点 $j$，移动左端点直到 $\textit{nums}[j] - \textit{nums}[i] \le \textit{mid}$，那么右端点为 $j$ 且距离小于等于 $\textit{mid}$ 的数对数目为 $j - i$，计算这些数目之和。

```Python [sol2-Python3]
class Solution:
    def smallestDistancePair(self, nums: List[int], k: int) -> int:
        def count(mid: int) -> int:
            cnt = i = 0
            for j, num in enumerate(nums):
                while num - nums[i] > mid:
                    i += 1
                cnt += j - i
            return cnt

        nums.sort()
        return bisect_left(range(nums[-1] - nums[0]), k, key=count)
```

```C++ [sol2-C++]
class Solution {
public:
    int smallestDistancePair(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        int n = nums.size(), left = 0, right = nums.back() - nums.front();
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int i = 0, j = 0; j < n; j++) {
                while (nums[j] - nums[i] > mid) {
                    i++;
                }
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int smallestDistancePair(int[] nums, int k) {
        Arrays.sort(nums);
        int n = nums.length, left = 0, right = nums[n - 1] - nums[0];
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int i = 0, j = 0; j < n; j++) {
                while (nums[j] - nums[i] > mid) {
                    i++;
                }
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int SmallestDistancePair(int[] nums, int k) {
        Array.Sort(nums);
        int n = nums.Length, left = 0, right = nums[n - 1] - nums[0];
        while (left <= right) {
            int mid = (left + right) / 2;
            int cnt = 0;
            for (int i = 0, j = 0; j < n; j++) {
                while (nums[j] - nums[i] > mid) {
                    i++;
                }
                cnt += j - i;
            }
            if (cnt >= k) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

```C [sol2-C]
int cmp(const void* pa, const void* pb) {
    return *(int *)pa - *(int *)pb;
}

int smallestDistancePair(int* nums, int numsSize, int k) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int left = 0, right = nums[numsSize - 1] - nums[0];
    while (left <= right) {
        int mid = (left + right) / 2;
        int cnt = 0;
        for (int i = 0, j = 0; j < numsSize; j++) {
            while (nums[j] - nums[i] > mid) {
                i++;
            }
            cnt += j - i;
        }
        if (cnt >= k) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

```go [sol2-Golang]
func smallestDistancePair(nums []int, k int) int {
    sort.Ints(nums)
    return sort.Search(nums[len(nums)-1]-nums[0], func(mid int) bool {
        cnt, i := 0, 0
        for j, num := range nums {
            for num-nums[i] > mid {
                i++
            }
            cnt += j - i
        }
        return cnt >= k
    })
}
```

```JavaScript [sol2-JavaScript]
var smallestDistancePair = function(nums, k) {
    nums.sort((a, b) => a - b);
    let n = nums.length, left = 0, right = nums[n - 1] - nums[0];
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        let cnt = 0;
        for (let i = 0, j = 0; j < n; j++) {
            while (nums[j] - nums[i] > mid) {
                i++;
            }
            cnt += j - i;
        }
        if (cnt >= k) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

**复杂度分析**

+ 时间复杂度：$O(n \times (\log n + \log D))$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$D = \max(\textit{nums}) - \min(\textit{nums})$。外层二分查找需要 $O(\log D)$，内层双指针需要 $O(n)$，排序的平均时间复杂度为 $O(n \log n)$。

+ 空间复杂度：$O(\log n)$。排序的平均空间复杂度为 $O(\log n)$。