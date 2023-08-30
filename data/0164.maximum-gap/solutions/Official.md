#### 方法一：基数排序

**思路与算法**

一种最简单的思路是将数组排序后再找出最大间距，但传统的基于比较的排序算法（快速排序、归并排序等）均需要 $O(N\log N)$ 的时间复杂度。如果要将时间复杂度降到 $O(N)$，我们就必须使用其他的排序算法。例如，[基数排序](https://baike.baidu.com/item/%E5%9F%BA%E6%95%B0%E6%8E%92%E5%BA%8F)可以在 $O(N)$ 的时间内完成整数之间的排序。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumGap(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return 0;
        }
        int exp = 1;
        vector<int> buf(n);
        int maxVal = *max_element(nums.begin(), nums.end());

        while (maxVal >= exp) {
            vector<int> cnt(10);
            for (int i = 0; i < n; i++) {
                int digit = (nums[i] / exp) % 10;
                cnt[digit]++;
            }
            for (int i = 1; i < 10; i++) {
                cnt[i] += cnt[i - 1];
            }
            for (int i = n - 1; i >= 0; i--) {
                int digit = (nums[i] / exp) % 10;
                buf[cnt[digit] - 1] = nums[i];
                cnt[digit]--;
            }
            copy(buf.begin(), buf.end(), nums.begin());
            exp *= 10;
        }

        int ret = 0;
        for (int i = 1; i < n; i++) {
            ret = max(ret, nums[i] - nums[i - 1]);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumGap(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return 0;
        }
        long exp = 1;
        int[] buf = new int[n];
        int maxVal = Arrays.stream(nums).max().getAsInt();

        while (maxVal >= exp) {
            int[] cnt = new int[10];
            for (int i = 0; i < n; i++) {
                int digit = (nums[i] / (int) exp) % 10;
                cnt[digit]++;
            }
            for (int i = 1; i < 10; i++) {
                cnt[i] += cnt[i - 1];
            }
            for (int i = n - 1; i >= 0; i--) {
                int digit = (nums[i] / (int) exp) % 10;
                buf[cnt[digit] - 1] = nums[i];
                cnt[digit]--;
            }
            System.arraycopy(buf, 0, nums, 0, n);
            exp *= 10;
        }

        int ret = 0;
        for (int i = 1; i < n; i++) {
            ret = Math.max(ret, nums[i] - nums[i - 1]);
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var maximumGap = function(nums) {
    const n = nums.length;
    if (n < 2) {
        return 0;
    }
    let exp = 1;
    const buf = new Array(n).fill(0);
    const maxVal = Math.max(...nums);

    while (maxVal >= exp) {
        const cnt = new Array(10).fill(0);
        for (let i = 0; i < n; i++) {
            let digit = Math.floor(nums[i] / exp) % 10;
            cnt[digit]++;
        }
        for (let i = 1; i < 10; i++) {
            cnt[i] += cnt[i - 1];
        }
        for (let i = n - 1; i >= 0; i--) {
            let digit = Math.floor(nums[i] / exp) % 10;
            buf[cnt[digit] - 1] = nums[i];
            cnt[digit]--;
        }
        nums.splice(0, n, ...buf);
        exp *= 10;
    }
    
    let ret = 0;
    for (let i = 1; i < n; i++) {
        ret = Math.max(ret, nums[i] - nums[i - 1]);
    }
    return ret;
};
```

```Golang [sol1-Golang]
func maximumGap(nums []int) (ans int) {
    n := len(nums)
    if n < 2 {
        return
    }

    buf := make([]int, n)
    maxVal := max(nums...)
    for exp := 1; exp <= maxVal; exp *= 10 {
        cnt := [10]int{}
        for _, v := range nums {
            digit := v / exp % 10
            cnt[digit]++
        }
        for i := 1; i < 10; i++ {
            cnt[i] += cnt[i-1]
        }
        for i := n - 1; i >= 0; i-- {
            digit := nums[i] / exp % 10
            buf[cnt[digit]-1] = nums[i]
            cnt[digit]--
        }
        copy(nums, buf)
    }

    for i := 1; i < n; i++ {
        ans = max(ans, nums[i]-nums[i-1])
    }
    return
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

```C [sol1-C]
int maximumGap(int* nums, int numsSize) {
    if (numsSize < 2) {
        return 0;
    }
    int exp = 1;
    int buf[numsSize];
    memset(buf, 0, sizeof(buf));
    int maxVal = INT_MIN;
    for (int i = 0; i < numsSize; ++i) {
        maxVal = fmax(maxVal, nums[i]);
    }

    while (maxVal >= exp) {
        int cnt[10];
        memset(cnt, 0, sizeof(cnt));
        for (int i = 0; i < numsSize; i++) {
            int digit = (nums[i] / exp) % 10;
            cnt[digit]++;
        }
        for (int i = 1; i < 10; i++) {
            cnt[i] += cnt[i - 1];
        }
        for (int i = numsSize - 1; i >= 0; i--) {
            int digit = (nums[i] / exp) % 10;
            buf[cnt[digit] - 1] = nums[i];
            cnt[digit]--;
        }
        memcpy(nums, buf, sizeof(int) * numsSize);
        exp *= 10;
    }

    int ret = 0;
    for (int i = 1; i < numsSize; i++) {
        ret = fmax(ret, nums[i] - nums[i - 1]);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。

- 空间复杂度：$O(N)$，其中 $N$ 是数组的长度。

#### 方法二：基于桶的算法

**思路与算法**

设长度为 $N$ 的数组中最大值为 $\textit{max,min}$，则不难发现相邻数字的最大间距不会小于 $\lceil (\textit{max}-\textit{min}) / (N-1) \rceil$。

为了说明这一点，我们使用反证法：假设相邻数字的间距都小于 $\lceil (\textit{max}-\textit{min}) / (N-1)  \rceil$，并记数组排序后从小到大的数字依次为 $A_1, A_2, ..., A_N$，则有

$$
\begin{aligned}
A_N - A_1&=(A_N - A_{N-1})+(A_{N-1}-A_{N-2})+ ... + (A_2 - A_1) \\
&< \lceil (\textit{max}-\textit{min}) / (N-1)  \rceil + \lceil (\textit{max}-\textit{min}) / (N-1)  \rceil + ... + \lceil (\textit{max}-\textit{min}) / (N-1)  \rceil \\
&< (N-1) \cdot \lceil (\textit{max}-\textit{min}) / (N-1)  \rceil= \textit{max}-\textit{min}
\end{aligned}
$$

但根据 $A_1, A_N$ 的定义，一定有 $A_1=\textit{min}$，且 $A_N=\textit{max}$，故上式会导出矛盾。

因此，我们可以选取整数 $d = \lfloor (\textit{max}-\textit{min}) / (N-1) \rfloor < \lceil (\textit{max}-\textit{min}) / (N-1) \rceil$。随后，我们将整个区间划分为若干个大小为 $d$ 的桶，并找出每个整数所在的桶。根据前面的结论，能够知道，元素之间的最大间距一定不会出现在某个桶的内部，而一定会出现在不同桶当中。

因此，在找出每个元素所在的桶之后，我们可以维护每个桶内元素的最大值与最小值。随后，只需从前到后不断比较相邻的桶，用后一个桶的最小值与前一个桶的最大值之差作为两个桶的间距，最终就能得到所求的答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maximumGap(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return 0;
        }
        int minVal = *min_element(nums.begin(), nums.end());
        int maxVal = *max_element(nums.begin(), nums.end());
        int d = max(1, (maxVal - minVal) / (n - 1));
        int bucketSize = (maxVal - minVal) / d + 1;

        vector<pair<int, int>> bucket(bucketSize, {-1, -1});  // 存储 (桶内最小值，桶内最大值) 对，(-1, -1) 表示该桶是空的
        for (int i = 0; i < n; i++) {
            int idx = (nums[i] - minVal) / d;
            if (bucket[idx].first == -1) {
                bucket[idx].first = bucket[idx].second = nums[i];
            } else {
                bucket[idx].first = min(bucket[idx].first, nums[i]);
                bucket[idx].second = max(bucket[idx].second, nums[i]);
            }
        }

        int ret = 0;
        int prev = -1;
        for (int i = 0; i < bucketSize; i++) {
            if (bucket[i].first == -1) continue;
            if (prev != -1) {
                ret = max(ret, bucket[i].first - bucket[prev].second);
            }
            prev = i;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximumGap(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return 0;
        }
        int minVal = Arrays.stream(nums).min().getAsInt();
        int maxVal = Arrays.stream(nums).max().getAsInt();
        int d = Math.max(1, (maxVal - minVal) / (n - 1));
        int bucketSize = (maxVal - minVal) / d + 1;

        int[][] bucket = new int[bucketSize][2];
        for (int i = 0; i < bucketSize; ++i) {
            Arrays.fill(bucket[i], -1); // 存储 (桶内最小值，桶内最大值) 对， (-1, -1) 表示该桶是空的
        }
        for (int i = 0; i < n; i++) {
            int idx = (nums[i] - minVal) / d;
            if (bucket[idx][0] == -1) {
                bucket[idx][0] = bucket[idx][1] = nums[i];
            } else {
                bucket[idx][0] = Math.min(bucket[idx][0], nums[i]);
                bucket[idx][1] = Math.max(bucket[idx][1], nums[i]);
            }
        }

        int ret = 0;
        int prev = -1;
        for (int i = 0; i < bucketSize; i++) {
            if (bucket[i][0] == -1) {
                continue;
            }
            if (prev != -1) {
                ret = Math.max(ret, bucket[i][0] - bucket[prev][1]);
            }
            prev = i;
        }
        return ret;
    }
}
```

```JavaScript [sol2-JavaScript]
var maximumGap = function(nums) {
    const n = nums.length;
    if (n < 2) {
        return 0;
    }
    const minVal = Math.min(...nums);
    const maxVal = Math.max(...nums);
    const d = Math.max(1, Math.floor(maxVal - minVal) / (n - 1));
    const bucketSize = Math.floor((maxVal - minVal) / d) + 1;

    const bucket = new Array(bucketSize).fill(0).map(x => new Array(2).fill(0));
    for (let i = 0; i < bucketSize; ++i) {
        bucket[i].fill(-1);
    }
    for (let i = 0; i < n; i++) {
        const idx = Math.floor((nums[i] - minVal) / d);
        if (bucket[idx][0] === -1) {
            bucket[idx][0] = bucket[idx][1] = nums[i];
        } else {
            bucket[idx][0] = Math.min(bucket[idx][0], nums[i]);
            bucket[idx][1] = Math.max(bucket[idx][1], nums[i]);
        }
    }

    let ret = 0;
    let prev = -1;
    for (let i = 0; i < bucketSize; i++) {
        if (bucket[i][0] == -1) {
            continue;
        }
        if (prev != -1) {
            ret = Math.max(ret, bucket[i][0] - bucket[prev][1]);
        }
        prev = i;
    }
    return ret;
};
```

```Golang [sol2-Golang]
type pair struct{ min, max int }

func maximumGap(nums []int) (ans int) {
    n := len(nums)
    if n < 2 {
        return
    }

    minVal := min(nums...)
    maxVal := max(nums...)
    d := max(1, (maxVal-minVal)/(n-1))
    bucketSize := (maxVal-minVal)/d + 1

    // 存储 (桶内最小值，桶内最大值) 对，(-1, -1) 表示该桶是空的
    buckets := make([]pair, bucketSize)
    for i := range buckets {
        buckets[i] = pair{-1, -1}
    }
    for _, v := range nums {
        bid := (v - minVal) / d
        if buckets[bid].min == -1 {
            buckets[bid].min = v
            buckets[bid].max = v
        } else {
            buckets[bid].min = min(buckets[bid].min, v)
            buckets[bid].max = max(buckets[bid].max, v)
        }
    }

    prev := -1
    for i, b := range buckets {
        if b.min == -1 {
            continue
        }
        if prev != -1 {
            ans = max(ans, b.min-buckets[prev].max)
        }
        prev = i
    }
    return
}

func min(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v < res {
            res = v
        }
    }
    return res
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

```C [sol2-C]
int maximumGap(int* nums, int numsSize) {
    if (numsSize < 2) {
        return 0;
    }
    int maxVal = INT_MIN, minVal = INT_MAX;
    for (int i = 0; i < numsSize; ++i) {
        maxVal = fmax(maxVal, nums[i]);
        minVal = fmin(minVal, nums[i]);
    }
    int d = fmax(1, (maxVal - minVal) / (numsSize - 1));
    int bucketSize = (maxVal - minVal) / d + 1;

    int bucket[bucketSize][2];
    memset(bucket, -1, sizeof(bucket));  // 存储 (桶内最小值，桶内最大值) 对，(-1, -1) 表示该桶是空的
    for (int i = 0; i < numsSize; i++) {
        int idx = (nums[i] - minVal) / d;
        if (bucket[idx][0] == -1) {
            bucket[idx][0] = bucket[idx][1] = nums[i];
        } else {
            bucket[idx][0] = fmin(bucket[idx][0], nums[i]);
            bucket[idx][1] = fmax(bucket[idx][1], nums[i]);
        }
    }

    int ret = 0;
    int prev = -1;
    for (int i = 0; i < bucketSize; i++) {
        if (bucket[i][0] == -1) continue;
        if (prev != -1) {
            ret = fmax(ret, bucket[i][0] - bucket[prev][1]);
        }
        prev = i;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。注意到桶的数量为 $(\textit{max}-\textit{min})/d \approx N - 1 =O(N)$。

- 空间复杂度：$O(N)$，其中 $N$ 是数组的长度。我们开辟的空间大小取决于桶的数量。