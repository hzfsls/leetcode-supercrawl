## [1818.绝对差值和 中文官方题解](https://leetcode.cn/problems/minimum-absolute-sum-difference/solutions/100000/jue-dui-chai-zhi-he-by-leetcode-solution-gv78)

#### 方法一：排序 + 二分查找

**思路及算法**

本题中单个二元组 $\{\textit{nums}_1[i],\textit{nums}_2[i]\}$ 对答案的贡献为 $\Big |\textit{nums}_1[i]-\textit{nums}_2[i]\Big |$。假设我们用元素 $\textit{nums}_1[j]$ 替换了元素 $\textit{nums}_1[i]$，那么此时该二元组对答案的贡献为 $\Big |\textit{nums}_1[j]-\textit{nums}_2[i]\Big |$。改变前后的差值为：

$$
\Big |\textit{nums}_1[i]-\textit{nums}_2[i]\Big | - \Big |\textit{nums}_1[j]-\textit{nums}_2[i]\Big |
$$

我们希望能最大化该差值，这样可以使得答案尽可能小。因为我们只能修改一个位置，所以我们需要检查每一个 $i$ 对应的差值的最大值。当 $i$ 确定时，该式的前半部分的值即可确定，而后半部分的值取决于 $j$ 的选择。观察该式，我们只需要找到和 $\textit{nums}_2[i]$ 尽可能接近的 $\textit{nums}_1[j]$ 即可。

为了优化查找的时间复杂度，我们可以使用辅助数组 $\textit{rec}$ 记录 $\textit{nums}_1$ 中所有的元素并排序。这样我们就可以使用二分查找的方法快速找到 $\textit{nums}_1$ 数组中尽可能接近 $\textit{nums}_2[i]$ 的元素。需要注意的是，该元素既可能大于等于 $\textit{nums}_2[i]$，也可能小于 $\textit{nums}_2[i]$，因此我们需要各检查一次。

在实际代码中，我们使用 $\textit{sum}$ 记录所有的差值和，用 $\textit{maxn}$ 记录最大的改变前后的差值，这样答案即为 $\textit{sum}-\textit{maxn}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    static constexpr int mod = 1'000'000'007;

    int minAbsoluteSumDiff(vector<int>& nums1, vector<int>& nums2) {
        vector<int> rec(nums1);
        sort(rec.begin(), rec.end());
        int sum = 0, maxn = 0;
        int n = nums1.size();
        for (int i = 0; i < n; i++) {
            int diff = abs(nums1[i] - nums2[i]);
            sum = (sum + diff) % mod;
            int j = lower_bound(rec.begin(), rec.end(), nums2[i]) - rec.begin();
            if (j < n) {
                maxn = max(maxn, diff - (rec[j] - nums2[i]));
            }
            if (j > 0) {
                maxn = max(maxn, diff - (nums2[i] - rec[j - 1]));
            }
        }
        return (sum - maxn + mod) % mod;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minAbsoluteSumDiff(int[] nums1, int[] nums2) {
        final int MOD = 1000000007;
        int n = nums1.length;
        int[] rec = new int[n];
        System.arraycopy(nums1, 0, rec, 0, n);
        Arrays.sort(rec);
        int sum = 0, maxn = 0;
        for (int i = 0; i < n; i++) {
            int diff = Math.abs(nums1[i] - nums2[i]);
            sum = (sum + diff) % MOD;
            int j = binarySearch(rec, nums2[i]);
            if (j < n) {
                maxn = Math.max(maxn, diff - (rec[j] - nums2[i]));
            }
            if (j > 0) {
                maxn = Math.max(maxn, diff - (nums2[i] - rec[j - 1]));
            }
        }
        return (sum - maxn + MOD) % MOD;
    }

    public int binarySearch(int[] rec, int target) {
        int low = 0, high = rec.length - 1;
        if (rec[high] < target) {
            return high + 1;
        }
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (rec[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinAbsoluteSumDiff(int[] nums1, int[] nums2) {
        const int MOD = 1000000007;
        int n = nums1.Length;
        int[] rec = new int[n];
        Array.Copy(nums1, rec, n);
        Array.Sort(rec);
        int sum = 0, maxn = 0;
        for (int i = 0; i < n; i++) {
            int diff = Math.Abs(nums1[i] - nums2[i]);
            sum = (sum + diff) % MOD;
            int j = BinarySearch(rec, nums2[i]);
            if (j < n) {
                maxn = Math.Max(maxn, diff - (rec[j] - nums2[i]));
            }
            if (j > 0) {
                maxn = Math.Max(maxn, diff - (nums2[i] - rec[j - 1]));
            }
        }
        return (sum - maxn + MOD) % MOD;
    }

    public int BinarySearch(int[] rec, int target) {
        int low = 0, high = rec.Length - 1;
        if (rec[high] < target) {
            return high + 1;
        }
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (rec[mid] < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```JavaScript [sol1-JavaScript]
var minAbsoluteSumDiff = function(nums1, nums2) {
    const MOD = 1000000007;
    const n = nums1.length;
    const rec = [...nums1];
    rec.sort((a, b) => a - b);
    let sum = 0, maxn = 0;
    for (let i = 0; i < n; i++) {
        const diff = Math.abs(nums1[i] - nums2[i]);
        sum = (sum + diff) % MOD;
        const j = binarySearch(rec, nums2[i]);
        if (j < n) {
            maxn = Math.max(maxn, diff - (rec[j] - nums2[i]));
        }
        if (j > 0) {
            maxn = Math.max(maxn, diff - (nums2[i] - rec[j - 1]));
        }
    }
    return (sum - maxn + MOD) % MOD;
};

const binarySearch = (rec, target) => {
    let low = 0, high = rec.length - 1;
    if (rec[high] < target) {
        return high + 1;
    }
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (rec[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}
```

```go [sol1-Golang]
func minAbsoluteSumDiff(nums1, nums2 []int) int {
    rec := append(sort.IntSlice(nil), nums1...)
    rec.Sort()
    sum, maxn, n := 0, 0, len(nums1)
    for i, v := range nums2 {
        diff := abs(nums1[i] - v)
        sum += diff
        j := rec.Search(v)
        if j < n {
            maxn = max(maxn, diff-(rec[j]-v))
        }
        if j > 0 {
            maxn = max(maxn, diff-(v-rec[j-1]))
        }
    }
    return (sum - maxn) % (1e9 + 7)
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int lower_bound(int* a, int n, int x) {
    int l = 0, r = n;
    while (l < r) {
        int mid = (l + r) >> 1;
        if (a[mid] < x) {
            l = mid + 1;
        } else {
            r = mid;
        }
    }
    return l;
}

int cmp(int* a, int* b) {
    return *a - *b;
}

const int mod = 1000000007;

int minAbsoluteSumDiff(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    int n = nums1Size;
    int rec[n];
    memcpy(rec, nums1, sizeof(int) * n);
    qsort(rec, n, sizeof(int), cmp);
    int sum = 0, maxn = 0;
    for (int i = 0; i < n; i++) {
        int diff = abs(nums1[i] - nums2[i]);
        sum = (sum + diff) % mod;
        int j = lower_bound(rec, n, nums2[i]);
        if (j < n) {
            maxn = fmax(maxn, diff - (rec[j] - nums2[i]));
        }
        if (j > 0) {
            maxn = fmax(maxn, diff - (nums2[i] - rec[j - 1]));
        }
    }
    return (sum - maxn + mod) % mod;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。我们需要记录 $\textit{nums}_1$ 中的元素，并进行排序，时间复杂度是 $O(n \log n)$。计算 $\textit{maxn}$ 需要进行 $n$ 次二分查找，每次二分查找的时间为 $O(\log n)$，因此时间复杂度也是 $O(n \log n)$。所以总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。我们需要创建大小为 $n$ 的辅助数组。