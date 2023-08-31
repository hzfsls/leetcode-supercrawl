## [1775.通过最少操作次数使数组的和相等 中文官方题解](https://leetcode.cn/problems/equal-sum-arrays-with-minimum-number-of-operations/solutions/100000/tong-guo-zui-shao-cao-zuo-ci-shu-shi-shu-e3o1)

#### 方法一：贪心 + 哈希表

**思路与算法**

题目给出长度分别为 $n$ 和 $m$ 的两个数组 $\textit{nums}_1$ 和 $\textit{nums}_2$，两个数组中所有值都在 $1$ 到 $6$ 之间（包含 $1$ 和 $6$），我们每次操作都可以选择任意数组中的任意一个整数将它变成 $1$ 到 $6$ 之间的任意的值（包含 $1$ 和 $6$）。现在我们需要求使 $\textit{nums}_1$ 中所有数之和与 $\textit{nums}_2$ 中所有数之和相等的最少操作次数。

首先我们设 $\textit{nums}_1$ 的和为 $\textit{sum}_1$，$\textit{nums}_2$ 的和为 $\textit{sum}_2$，为了不失一般性，不妨设 $\textit{sum}_1 > \textit{sum}_2$，并设 $\textit{diff} = \textit{sum}_1 - \textit{sum}_2$。现在我们需要修改最少的 $\textit{nums}_1$ 和 $\textit{nums}_2$ 中的数字来使 $\textit{diff}$ 变为 $0$。又因为对于数组中的数的每次修改对于 $\textit{diff}$ 的影响是相互独立的，我们对 $\textit{nums}_1$ 和 $\textit{nums}_2$ 中的数单独来进行分析——对于 $\textit{nums}_1$ 中的某一个数 $x$，为了使 $\textit{diff}$ 更快的变小，将 $x$ 变成 $\max\{1, x - \textit{diff}\}$ 对于 $x$ 来说一定是最优的选择，此时能贡献的 $\textit{diff}$ 减小量为 $x - \max\{1, x - \textit{diff}\}$。同理对于 $\textit{nums}_2$ 中的某一个数 $y$，将 $y$ 变成 $\min\{6, y + \textit{diff}\}$ 对于 $y$ 来说一定是最优的选择，此时能贡献的 $\textit{diff}$ 减小量为 $6 - \min\{6, y + \textit{diff}\}$。由于每一个数能贡献 $\textit{diff}$ 的减少量是独立的，所以我们对于 $\textit{nums}_1$ 和 $\textit{nums}_2$ 中的每一个数从对 $\textit{diff}$ 的减少量从大到小来进行操作使 $\textit{diff}$ 减少到 $0$ 即可。为了避免每一次只减一个数的贡献值，我们可以对于每一个数的 $\textit{diff}$ 的贡献值用「哈希表」来进行存储，然后对于贡献值从大到小来快速减少 $\textit{diff}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def help(self, h1: List[int], h2: List[int], diff: int) -> int:
        h = [0] * 7
        for i in range(1, 7):
            h[6 - i] += h1[i]
            h[i - 1] += h2[i]
        res = 0
        for i in range(5, 0, -1):
            if diff <= 0: break
            t = min((diff + i - 1) // i, h[i])
            res += t
            diff -= t * i
        return res

    def minOperations(self, nums1: List[int], nums2: List[int]) -> int:
        n, m = len(nums1), len(nums2)
        if 6 * n < m or 6 * m < n:
            return -1
        cnt1 = [0] * 7
        cnt2 = [0] * 7
        diff = 0
        for i in nums1:
            cnt1[i] += 1
            diff += i
        for i in nums2:
            cnt2[i] += 1
            diff -= i
        if diff == 0:
            return 0
        if diff > 0:
            return self.help(cnt2, cnt1, diff)
        return self.help(cnt1, cnt2, -diff)
```

```C++ [sol1-C++]
class Solution {
public:
    int help(vector<int>& h1, vector<int>& h2, int diff) {
        vector<int> h(7, 0);
        for (int i = 1; i < 7; ++i) {
            h[6 - i] += h1[i];
            h[i - 1] += h2[i];
        }
        int res = 0;
        for (int i = 5; i && diff > 0; --i) {
            int t = min((diff + i - 1) / i, h[i]);
            res += t;
            diff -= t * i;
        }
        return res;
    }

    int minOperations(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size(), m = nums2.size();
        if (6 * n < m || 6 * m < n) {
            return -1;
        }
        vector<int> cnt1(7, 0), cnt2(7, 0);
        int diff = 0;
        for (auto& i : nums1) {
            ++cnt1[i];
            diff += i;
        }
        for (auto& i : nums2) {
            ++cnt2[i];
            diff -= i;
        }
        if (!diff) {
            return 0;
        }
        if (diff > 0) {
            return help(cnt2, cnt1, diff);
        }
        return help(cnt1, cnt2, -diff);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minOperations(int[] nums1, int[] nums2) {
        int n = nums1.length, m = nums2.length;
        if (6 * n < m || 6 * m < n) {
            return -1;
        }
        int[] cnt1 = new int[7];
        int[] cnt2 = new int[7];
        int diff = 0;
        for (int i : nums1) {
            ++cnt1[i];
            diff += i;
        }
        for (int i : nums2) {
            ++cnt2[i];
            diff -= i;
        }
        if (diff == 0) {
            return 0;
        }
        if (diff > 0) {
            return help(cnt2, cnt1, diff);
        }
        return help(cnt1, cnt2, -diff);
    }

    public int help(int[] h1, int[] h2, int diff) {
        int[] h = new int[7];
        for (int i = 1; i < 7; ++i) {
            h[6 - i] += h1[i];
            h[i - 1] += h2[i];
        }
        int res = 0;
        for (int i = 5; i > 0 && diff > 0; --i) {
            int t = Math.min((diff + i - 1) / i, h[i]);
            res += t;
            diff -= t * i;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperations(int[] nums1, int[] nums2) {
        int n = nums1.Length, m = nums2.Length;
        if (6 * n < m || 6 * m < n) {
            return -1;
        }
        int[] cnt1 = new int[7];
        int[] cnt2 = new int[7];
        int diff = 0;
        foreach (int i in nums1) {
            ++cnt1[i];
            diff += i;
        }
        foreach (int i in nums2) {
            ++cnt2[i];
            diff -= i;
        }
        if (diff == 0) {
            return 0;
        }
        if (diff > 0) {
            return Help(cnt2, cnt1, diff);
        }
        return Help(cnt1, cnt2, -diff);
    }

    public int Help(int[] h1, int[] h2, int diff) {
        int[] h = new int[7];
        for (int i = 1; i < 7; ++i) {
            h[6 - i] += h1[i];
            h[i - 1] += h2[i];
        }
        int res = 0;
        for (int i = 5; i > 0 && diff > 0; --i) {
            int t = Math.Min((diff + i - 1) / i, h[i]);
            res += t;
            diff -= t * i;
        }
        return res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int help(const int *h1, const int *h2, int diff) {
    int h[7];
    memset(h, 0, sizeof(h));
    for (int i = 1; i < 7; ++i) {
        h[6 - i] += h1[i];
        h[i - 1] += h2[i];
    }
    int res = 0;
    for (int i = 5; i && diff > 0; --i) {
        int t = MIN((diff + i - 1) / i, h[i]);
        res += t;
        diff -= t * i;
    }
    return res;
}

int minOperations(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    if (6 * nums1Size < nums2Size || 6 * nums2Size < nums1Size) {
        return -1;
    }
    int cnt1[7], cnt2[7];
    memset(cnt1, 0, sizeof(cnt1));
    memset(cnt2, 0, sizeof(cnt2));
    int diff = 0;
    for (int i = 0; i < nums1Size; i++) {
        ++cnt1[nums1[i]];
        diff += nums1[i];
    }
    for (int i = 0; i < nums2Size; i++) {
        ++cnt2[nums2[i]];
        diff -= nums2[i];
    }
    if (!diff) {
        return 0;
    }
    if (diff > 0) {
        return help(cnt2, cnt1, diff);
    }
    return help(cnt1, cnt2, -diff);
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(nums1, nums2) {
    const n = nums1.length, m = nums2.length;
    if (6 * n < m || 6 * m < n) {
        return -1;
    }
    const cnt1 = new Array(7).fill(0);
    const cnt2 = new Array(7).fill(0);
    let diff = 0;
    for (const i of nums1) {
        ++cnt1[i];
        diff += i;
    }
    for (const i of nums2) {
        ++cnt2[i];
        diff -= i;
    }
    if (diff === 0) {
        return 0;
    }
    if (diff > 0) {
        return help(cnt2, cnt1, diff);
    }
    return help(cnt1, cnt2, -diff);
}

const help = (h1, h2, diff) => {
    const h = new Array(7).fill(0);
    for (let i = 1; i < 7; ++i) {
        h[6 - i] += h1[i];
        h[i - 1] += h2[i];
    }
    let res = 0;
    for (let i = 5; i > 0 && diff > 0; --i) {
        let t = Math.min(Math.floor((diff + i - 1) / i), h[i]);
        res += t;
        diff -= t * i;
    }
    return res;
};
```

```go [sol1-Golang]
func help(h1 [7]int, h2 [7]int, diff int) (res int) {
    h := [7]int{}
    for i := 1; i < 7; i++ {
        h[6-i] += h1[i]
        h[i-1] += h2[i]
    }
    for i := 5; i > 0 && diff > 0; i-- {
        t := min((diff+i-1)/i, h[i])
        res += t
        diff -= t * i
    }
    return res
}

func minOperations(nums1 []int, nums2 []int) (ans int) {
    n, m := len(nums1), len(nums2)
    if 6*n < m || 6*m < n {
        return -1
    }
    var cnt1, cnt2 [7]int
    diff := 0
    for _, i := range nums1 {
        cnt1[i]++
        diff += i
    }
    for _, i := range nums2 {
        cnt2[i]++
        diff -= i
    }
    if diff == 0 {
        return 0
    }
    if diff > 0 {
        return help(cnt2, cnt1, diff)
    }
    return help(cnt1, cnt2, -diff)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$，$m$ 分别为数组 $\textit{nums}_1$，$\textit{nums}_2$ 的长度。
- 空间复杂度：$O(C)$，其中 $C$ 为数组 $\textit{nums}_1$，$\textit{nums}_2$ 中元素值的取值空间，主要为用数组来模拟「哈希表」的空间开销。