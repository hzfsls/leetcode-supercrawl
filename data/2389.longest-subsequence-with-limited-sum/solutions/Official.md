## [2389.和有限的最长子序列 中文官方题解](https://leetcode.cn/problems/longest-subsequence-with-limited-sum/solutions/100000/he-you-xian-de-zui-chang-zi-xu-lie-by-le-xqox)

#### 方法一：二分查找

由题意可知，$\textit{nums}$ 的元素次序对结果无影响，因此我们对 $\textit{nums}$ 从小到大进行排序。显然和有限的最长子序列由最小的前几个数组成。使用数组 $f$ 保存 $\textit{nums}$ 的前缀和，其中 $f[i]$ 表示前 $i$ 个元素之和（不包括 $\textit{nums}[i]$）。遍历 $\textit{queries}$，假设当前查询值为 $q$，使用二分查找获取满足 $f[i] \gt q$ 的最小的 $i$，那么和小于等于 $q$ 的最长子序列长度为 $i-1$。

```Python [sol1-Python3]
class Solution:
    def answerQueries(self, nums: List[int], queries: List[int]) -> List[int]:
        f = list(accumulate(sorted(nums)))
        return [bisect_right(f, q) for q in queries]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> answerQueries(vector<int>& nums, vector<int>& queries) {
        int n = nums.size(), m = queries.size();
        sort(nums.begin(), nums.end());
        vector<int> f(n + 1);
        for (int i = 0; i < n; i++) {
            f[i + 1] = f[i] + nums[i];
        }
        vector<int> answer(m);
        for (int i = 0; i < m; i++) {
            answer[i] = upper_bound(f.begin(), f.end(), queries[i]) - f.begin() - 1;
        }
        return answer;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] answerQueries(int[] nums, int[] queries) {
        int n = nums.length, m = queries.length;
        Arrays.sort(nums);
        int[] f = new int[n + 1];
        for (int i = 0; i < n; i++) {
            f[i + 1] = f[i] + nums[i];
        }
        int[] answer = new int[m];
        for (int i = 0; i < m; i++) {
            answer[i] = binarySearch(f, queries[i]) - 1;
        }
        return answer;
    }

    public int binarySearch(int[] f, int target) {
        int low = 1, high = f.length;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (f[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] AnswerQueries(int[] nums, int[] queries) {
        int n = nums.Length, m = queries.Length;
        Array.Sort(nums);
        int[] f = new int[n + 1];
        for (int i = 0; i < n; i++) {
            f[i + 1] = f[i] + nums[i];
        }
        int[] answer = new int[m];
        for (int i = 0; i < m; i++) {
            answer[i] = BinarySearch(f, queries[i]) - 1;
        }
        return answer;
    }

    public int BinarySearch(int[] f, int target) {
        int low = 1, high = f.Length;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (f[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int binarySearch(int *arr, int arrSize, int target) {
    int low = 1, high = arrSize;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (arr[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

int* answerQueries(int* nums, int numsSize, int* queries, int queriesSize, int* returnSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int f[numsSize + 1];
    f[0] = 0;
    for (int i = 0; i < numsSize; i++) {
        f[i + 1] = f[i] + nums[i];
    }
    int *answer = (int *)calloc(sizeof(int), queriesSize);
    for (int i = 0; i < queriesSize; i++) {
        answer[i] = binarySearch(f, numsSize + 1, queries[i]) - 1;
    }
    *returnSize = queriesSize;
    return answer;
}
```

```JavaScript [sol1-JavaScript]
var answerQueries = function(nums, queries) {
    const n = nums.length, m = queries.length;
    nums.sort((a, b) => a - b);
    const f = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        f[i + 1] = f[i] + nums[i];
    }
    const answer = new Array(m).fill(0);
    for (let i = 0; i < m; i++) {
        answer[i] = binarySearch(f, queries[i]) - 1;
    }
    return answer;
}

const  binarySearch = (f, target) => {
    let low = 1, high = f.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (f[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
};
```

```go [sol1-Golang]
func answerQueries(nums []int, queries []int) []int {
    sort.Ints(nums)
    n := len(nums)
    f := make([]int, n)
    f[0] = nums[0]
    for i := 1; i < n; i++ {
        f[i] = f[i-1] + nums[i]
    }
    ans := []int{}
    for _, q := range queries {
        idx := sort.SearchInts(f, q+1)
        ans = append(ans, idx)
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O \big ( (n + m) \times \log n \big )$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是数组 $\textit{queries}$ 的长度。对 $\textit{nums}$ 进行排序需要 $O(n \log n)$ 的时间，二分查找需要 $O(\log n)$ 的时间。

+ 空间复杂度：$O(n)$。返回值不计入空间复杂度。