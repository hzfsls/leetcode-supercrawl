## [1187.使数组严格递增 中文官方题解](https://leetcode.cn/problems/make-array-strictly-increasing/solutions/100000/shi-shu-zu-yan-ge-di-zeng-by-leetcode-so-6p94)
#### 方法一：动态规划

**思路与算法**

此题为经典的「[300. 最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/description/)」问题的变形题目，我们可以参考类似的题目解法。首先我们思考一下，由于要求数组严格递增，因此数组中不可能存在相同的元素，对于数组 $\textit{arr}_2$ 来说，可以不需要考虑数组中的重复元素，可以预处理去除 $\textit{arr}_2$ 的重复元素，假设数组 $\textit{arr}_1$ 的长度为 $n$，数组 $\textit{arr}_2$ 的长度为 $m$，此时可以知道最多可以替换的次数为 $\min(n,m)$。如何才能定义动态规划的递推公式，这就需要进行思考。我们设 $\textit{dp}[i][j]$ 表示数组 $\textit{arr}_1$ 中的前 $i$ 个元素进行了 $j$ 次替换后组成严格递增子数组末尾元素的最小值。当我们遍历 $\textit{arr}_1$ 的第 $i$ 个元素时，此时 $\textit{arr}_1[i]$ 要么进行替换，要么进行保留，实际可以分类进行讨论:
+ 此时如果 $\textit{arr}_1[i]$ 需要进行保留，则 $\textit{arr}_1[i]$ 一定严格大于前 $i-1$ 个元素替换后组成的严格递增子数组最末尾的元素。假设前 $i-1$ 个元素经过了 $j$ 次变换后得到的递增子数组的末尾元素的最小值为 $\textit{dp}[i-1][j]$，如果满足 $\textit{arr}_1[i] > \textit{dp}[i-1][j]$，则此时 $\textit{arr}_1[i]$ 可以保留加入到该子数组中且构成的数组严格递增；
+ 此时如果 $\textit{arr}_1[i]$ 需要进行替换，则替换后的元素一定严格大于前 $i-1$ 个元素替换后组成的严格递增子数组最末尾的元素。假设前 $i-1$ 个元素经过了 $j-1$ 次变换后得到的递增子数组的末尾元素的最小值为 $\textit{dp}[i-1][j-1]$，此时我们从 $\textit{arr}_2$ 找到严格大于 $\textit{dp}[i-1][j-1]$ 的最小元素 $\textit{arr}_2[k]$，则此时将 $\textit{arr}_2[k]$ 加入到该子数组中且构成数组严格递增；
+ 综上可知，每个元素在替换时只有两种选择，要么选择保留当前元素 $arr_1$，要么从 $arr_2$ 中选择一个满足条件的最小元素加入到数组中，最少替换方案一定包含在上述替换方法中。我们可以得到以下递推关系：
$$
\begin{cases}
\textit{dp}[i][j] = \min(\textit{dp}[i][j],\textit{arr}_1[i]), \quad & \textbf{if} \ \textit{arr}_1[i] > \textit{dp}[i-1][j] \\
\textit{dp}[i][j] = \min(\textit{dp}[i][j],\textit{arr}_2[k]), \quad & \textbf{if} \ \textit{arr}_2[k] > \textit{dp}[i-1][j-1]
\end{cases}
$$

为了便于计算，我们将 $\textit{dp}[i][j]$ 的初始值都设为 $\infty$，为了便于计算在最开始加一个哨兵，此时令 $\textit{dp}[0][0] = -1$ 表示最小值。实际计算过程如下:
+ 为了方便计算，需要对 $\textit{arr}_2$ 进行预处理，去掉其中的重复元素，为了快速找到数组 $\textit{arr}_2$ 中的最小元素，还需要对 $\textit{arr}_2$ 进行排序；
+ 依次尝试计算前 $i$ 个元素在满足 $j$ 次替换时的最小元素：
  + 如果当前元素 $\textit{arr}_1[i]$ 大于 $\textit{dp}[i][j-1]$，此时可以尝试将 $\textit{arr}_1[i]$ 替换为 $\textit{dp}[i][j]$，即此时 $\textit{dp}[i][j] = \min(\textit{dp}[i][j],\textit{arr}_1[i])$。
  + 如果前 $i-1$ 个元素可以满足 $j-1$ 次替换后成为严格递增数组，即满足 $\textit{dp}[i-1][j-1] \neq \infty$，可以尝试在第 $j$ 次替换掉 $\textit{arr}_1[i]$，此时根据贪心原则，利用二分查找可以快速的找到严格大于 $\textit{dp}[i-1][j-1]$ 的最小值进行替换即可。
+ 设当前数组 $\textit{arr}_1[i]$ 的长度为 $n$，如果前 $n$ 个元素满足 $j$ 次替换后成为严格递增数组，此时我们找到最小的 $j$ 返回即可。

**代码**

```C++ [sol1-C++]
constexpr int INF = 0x3f3f3f3f;

class Solution {
public:
    int makeArrayIncreasing(vector<int>& arr1, vector<int>& arr2) {
        sort(arr2.begin(), arr2.end());
        arr2.erase(unique(arr2.begin(), arr2.end()), arr2.end());
        int n = arr1.size();
        int m = arr2.size();
        vector<vector<int>> dp(n + 1, vector<int>(min(m, n) + 1, INF));
        dp[0][0] = -1;
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= min(i, m); j++) {
                /* 如果当前元素大于序列的最后一个元素 */
                if (arr1[i - 1] > dp[i - 1][j]) {
                    dp[i][j] = arr1[i - 1];
                }
                if (j > 0 && dp[i - 1][j - 1] != INF) {
                    /* 查找严格大于 dp[i - 1][j - 1] 的最小元素 */
                    auto it = upper_bound(arr2.begin() + j - 1, arr2.end(), dp[i - 1][j - 1]);
                    if (it != arr2.end()) {
                        dp[i][j] = min(dp[i][j], *it);
                    }
                }
                if (i == n && dp[i][j] != INF) {
                    return j;
                }
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;

    public int makeArrayIncreasing(int[] arr1, int[] arr2) {
        Arrays.sort(arr2);
        List<Integer> list = new ArrayList<Integer>();
        int prev = -1;
        for (int num : arr2) {
            if (num != prev) {
                list.add(num);
                prev = num;
            }
        }
        int n = arr1.length;
        int m = list.size();
        int[][] dp = new int[n + 1][Math.min(m, n) + 1];
        for (int i = 0; i <= n; i++) {
            Arrays.fill(dp[i], INF);
        }
        dp[0][0] = -1;
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= Math.min(i, m); j++) {
                /* 如果当前元素大于序列的最后一个元素 */
                if (arr1[i - 1] > dp[i - 1][j]) {
                    dp[i][j] = arr1[i - 1];
                }
                if (j > 0 && dp[i - 1][j - 1] != INF) {
                    /* 查找严格大于 dp[i - 1][j - 1] 的最小元素 */
                    int idx = binarySearch(list, j - 1, dp[i - 1][j - 1]);
                    if (idx != list.size()) {
                        dp[i][j] = Math.min(dp[i][j], list.get(idx));
                    }
                }
                if (i == n && dp[i][j] != INF) {
                    return j;
                }
            }
        }
        return -1;
    }

    public int binarySearch(List<Integer> list, int low, int target) {
        int high = list.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list.get(mid) > target) {
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
    const int INF = 0x3f3f3f3f;

    public int MakeArrayIncreasing(int[] arr1, int[] arr2) {
        Array.Sort(arr2);
        IList<int> list = new List<int>();
        int prev = -1;
        foreach (int num in arr2) {
            if (num != prev) {
                list.Add(num);
                prev = num;
            }
        }
        int n = arr1.Length;
        int m = list.Count;
        int[][] dp = new int[n + 1][];
        for (int i = 0; i <= n; i++) {
            dp[i] = new int[Math.Min(m, n) + 1];
            Array.Fill(dp[i], INF);
        }
        dp[0][0] = -1;
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= Math.Min(i, m); j++) {
                /* 如果当前元素大于序列的最后一个元素 */
                if (arr1[i - 1] > dp[i - 1][j]) {
                    dp[i][j] = arr1[i - 1];
                }
                if (j > 0 && dp[i - 1][j - 1] != INF) {
                    /* 查找严格大于 dp[i - 1][j - 1] 的最小元素 */
                    int idx = BinarySearch(list, j - 1, dp[i - 1][j - 1]);
                    if (idx != list.Count) {
                        dp[i][j] = Math.Min(dp[i][j], list[idx]);
                    }
                }
                if (i == n && dp[i][j] != INF) {
                    return j;
                }
            }
        }
        return -1;
    }

    public int BinarySearch(IList<int> list, int low, int target) {
        int high = list.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def makeArrayIncreasing(self, arr1: List[int], arr2: List[int]) -> int:
        arr2 = sorted(set(arr2))
        n = len(arr1)
        m = len(arr2)
        dp = [[inf] *(min(m, n)+1) for _ in range(n + 1)]
        dp[0][0] = -1
        for i in range(1, n + 1):
            for j in range(min(i, m) + 1):
                if arr1[i - 1] > dp[i - 1][j]:
                    dp[i][j] = arr1[i - 1]
                if j and dp[i - 1][j - 1] != inf:
                    k = bisect_right(arr2, dp[i - 1][j - 1], j - 1)
                    if k < m:
                        dp[i][j] = min(dp[i][j], arr2[k])
                if i == n and dp[i][j] != inf:
                    return j
        return -1
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int binarySearch(int *arr, int left, int right, int val) {
    int ret = right + 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] > val) {
            ret = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ret;
}

int min(int a, int b) {
    return a < b ? a : b;
}

int makeArrayIncreasing(int* arr1, int arr1Size, int* arr2, int arr2Size) {
    qsort(arr2, arr2Size, sizeof(int), cmp);
    int m = 0;
    for (int i = 0; i < arr2Size; i++) {
        if (i == 0 || arr2[i] != arr2[i - 1]) {
            arr2[m++] = arr2[i];
        }
    }
    int n = arr1Size;
    int dp[n + 1][min(n, m) + 1];
    memset(dp, 0x3f, sizeof(dp));
    dp[0][0] = -1;
    for (int i = 1; i <= n; i++) {
        for (int j = 0; j <= min(i, m); j++) {
            /* 如果当前元素大于序列的最后一个元素 */
            if (arr1[i - 1] > dp[i - 1][j]) {
                dp[i][j] = arr1[i - 1];
            }
            if (j > 0 && dp[i - 1][j - 1] != INF) {
                /* 二分查找严格大于 dp[i - 1][j - 1] 的最小元素 */
                int index = binarySearch(arr2, j - 1, m - 1, dp[i - 1][j - 1]);
                if (index != m) {
                    dp[i][j] = MIN(dp[i][j], arr2[index]);
                }
            }  
            if (i == n && dp[i][j] != INF) {
                return j;
            }
        }
    }
    return -1;
}
```

```JavaScript [sol1-JavaScript]
const INF = 0x3f3f3f3f;
var makeArrayIncreasing = function(arr1, arr2) {
    arr2.sort((a, b) => a - b);
    const list = [];
    let prev = -1;
    for (const num of arr2) {
        if (num !== prev) {
            list.push(num);
            prev = num;
        }
    }
    const n = arr1.length;
    const m = list.length;
    const dp = new Array(n + 1).fill(0).map(() => new Array(Math.min(m, n) + 1).fill(INF));
    dp[0][0] = -1;
    for (let i = 1; i <= n; i++) {
        for (let j = 0; j <= Math.min(i, m); j++) {
            /* 如果当前元素大于序列的最后一个元素 */
            if (arr1[i - 1] > dp[i - 1][j]) {
                dp[i][j] = arr1[i - 1];
            }
            if (j > 0 && dp[i - 1][j - 1] !== INF) {
                /* 查找严格大于 dp[i - 1][j - 1] 的最小元素 */
                const idx = binarySearch(list, j - 1, dp[i - 1][j - 1]);
                if (idx !== list.length) {
                    dp[i][j] = Math.min(dp[i][j], list[idx]);
                }
            }
            if (i === n && dp[i][j] !== INF) {
                return j;
            }
        }
    }
    return -1;
}

const binarySearch = (list, low, target) => {
    let high = list.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (list[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
};
```

```go [sol1-Golang]
func makeArrayIncreasing(arr1 []int, arr2 []int) int {
    sort.Ints(arr2)
    n := len(arr1)
    m := len(arr2)
    dp := make([][]int, n+1)
    for i := range dp {
        dp[i] = make([]int, min(m, n)+1)
        for j := range dp[i] {
            dp[i][j] = math.MaxInt
        }
    }
    dp[0][0] = -1
    for i := 1; i <= len(arr1); i++ {
        for j := 0; j <= min(i, m); j++ {
            if arr1[i-1] > dp[i-1][j] {
                dp[i][j] = arr1[i-1]
            }
            if j > 0 && dp[i-1][j-1] != math.MaxInt {
                k := j - 1 + sort.SearchInts(arr2[j-1:], dp[i-1][j-1]+1)
                if k < m {
                    dp[i][j] = min(dp[i][j], arr2[k])
                }
            }
            if i == n && dp[i][j] != math.MaxInt {
                return j
            }
        }
    }
    return -1
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \min(m,n) \times \log m)$，其中 $n$ 表示数组 $\textit{arr}_1$ 的长度，$m$ 表示数组 $\textit{arr}_2$ 的长度。每次替换时，我们都需利用二分查找找到最小的元素，此时需要的时间为 $O(\log m)$，最多需要尝试 $n \times \min(m,n)$ 种替换方案，因此总的时间复杂度为 $O(n \times \min(m,n) \times \log m)$。

- 空间复杂度：$O(n \times \min(m,n))$，其中 $n$ 表示数组 $\textit{arr}_1$ 的长度，$m$ 表示数组 $\textit{arr}_2$ 的长度。我们需要保存每个子数组中替换次数下的末尾元素的最大值，一共最多有 $n$ 个子数组，每个子数组替换替换的次数最多为 $\min(n,m)$ 次数，因此空间复杂度为 $O(n \times \min(m,n))$。

#### 方法二：动态规划二  

**思路与算法**

根据方法一的提示，我们可以变换一种动态规划的思路。我们可以观察到实际在替换时，假设当前数组 $\textit{arr}_1$ 前 $i$ 个元素最少经过 $j$ 次替换成为严格递增数组，实际情况替换如下：
+ 前 $i-1$ 个元素进行了 $j$ 次替换，此时 ${arr}_1[i]$ 保留；
+ 前 $i-1$ 个元素进行了 $j-1$ 次替换，此时 ${arr}_1[i]$ 被替换；

根据以上想法，定义 $\textit{dp}[i]$ 为使数组 ${arr}_1[i]$ 的前 $i$ 项递增，且保留 ${arr}_1[i]$ 的情况下的最小替换次数。
> 为什么只考虑不替换 $\textit{arr}_1[i]$ 的状态，因为如果替该元素，那么到底替换成哪个元素，此时需要另加一个状态维护。根据上述分析由于数组 ${arr}_1$ 中的每个元素都可能被替换，${arr}_1$ 的最后一项也可能被替换，此时我们可以在数组最后增加一个非常大的数，而保证这个数不替换即可，这样即可保证当前的子状态中一定包含最优解。

首先为了方便计算我们对数组进行预处理，对于数组 $\textit{arr}_2$ 来说，可以不需要考虑数组中的重复元素，可以预处理去除 $\textit{arr}_2$ 的重复元素，假设数组 $\textit{arr}_1$ 的长度为 $n$，数组 $\textit{arr}_2$ 的长度为 $m$，此时可以知道最多可以替换的次数为 $\min(n,m)$。

**状态转移**
> 对于第 $i$ 个元素考虑 $\textit{dp}[i]$，由于我们不能替换 $\textit{arr}_1[i]$，假设 $i$ 之前上一个被保留的元素为 $\textit{arr}_1[k]$，则此时 $[k+1,i-1]$ 之间的元素均被替换，即此时 $\textit{arr}_1[k+1],\textit{arr}_1[k+2],\cdots,\textit{arr}_1[i]$ 连续的 $i-k-1$ 个元素均被替换，此时需要的最小的替换次数可能为 $\textit{dp}[k] + i - k + 1$。由于可能存在 $i$ 之前所有的元素均被替换的情形，此时我们可以在数组前面增加一个非常小的数，而保证这个数一定不被替换。

根据以上分析可知，我们需要尝试替换 $i$ 之前的连续 $j$ 个元素，分为以下两种情形讨论:
+ $\textit{arr}_1[i]$ 之前替换的元素为 $0$ 个，即此时保留 $\textit{arr}_1[i-1]$。如果要保留 $\textit{arr}_1[i-1]$，则此时一定满足 $\textit{arr}_1[i-1] < \textit{arr}_1[i]$，此时递推公式为：
$$
\textit{dp}[i] = \min(\textit{dp}[i],\textit{dp}[i-1])
$$
+ $\textit{arr}_1[i]$ 之前替换的元素为 $j$ 个，此时 $j > 0$，此时 $\textit{arr}_1[i]，\textit{arr}_1[i-j-1]$ 均被保留，此时 $\textit{arr}_1[i-j],\textit{arr}_1[i-j+1],\cdots,\textit{arr}_1[i-1]$ 连续的 $j$ 个元素被替换。如何上述替换才能一定能成立呢？此时最优选择肯定是我们在 $\textit{arr}_2$ 中也找到连续的 $j$ 个元素来替换他们即可。假设替换的 $j$ 个元素为 $\textit{arr}_2[k],\textit{arr}_2[k+1],\cdots,\textit{arr}_2[k+j-1]$，由于 $\textit{arr}_2$ 已经是有序的，此时一定满足 $\textit{arr}_2[k] < \textit{arr}_2[k+1] < \cdots < \textit{arr}_2[k+j-1]$，则这 $j$ 个元素需要满足如下条件即可进行替换：
  + 最小的元素 $\textit{arr}_2[k]$ 一定需要大于 $\textit{arr}_1[i-j-1]$；
  + 最大的元素 $\textit{arr}_2[k+j-1]$ 一定需要小于 $\textit{arr}_1[i]$；
  + 上述情形下的此时递推公式即为：
$$
\begin{aligned}
\textit{dp}[i] &= \min(\textit{dp}[i],\textit{dp}[i-j+1] + j) \\
& \mathbf{if\ exist}\ {arr}_2[k] > \textit{arr}_1[i-j-1], \textit{arr}_2[k+j-1] < \textit{arr}_1[i]
\end{aligned}
$$

根据以上分析可以知道题目难点在于如何找到连续替换的元素，给定 $\textit{arr}_1$ 的第 $i$ 个元素，此时需要替换 $\textit{arr}_1$ 前面的 $j$ 个元素，是否可以在 $\textit{arr}_2$ 中找到连续的 $j$ 个元素，其中最小的元素满足大于 $\textit{arr}_1[i-j-1]$，最大的元素满足小于 $\textit{arr}_1[i]$，此时根据贪心原则，我们可以用以下两种办法均可：
+ 查找替换元素的左侧起点：通过二分查找可以在 $O(\log m)$ 时间复杂度内找到严格大于 $\textit{arr}_1[i-j-1]$ 的最小元素 $\textit{arr}_2[k]$。由于我们需要替换 $j$ 个元素，再检测替换的最大元素 $\textit{arr}_2[k + i - j]$ 是否小于 $\textit{arr}_1[i]$ 即可；
+ 查找替换元素的右侧终点：通过二分查找可以在 $O(\log m)$ 时间复杂度内找到严格小于 $\textit{arr}_1[i]$ 的最大元素 $\textit{arr}_2[k]$。由于我们需要替换 $j$ 个元素，再检测替换的最小元素 $\textit{arr}_2[k - j + 1]$ 是否大于 $\textit{arr}_1[i-j-1]$ 即可；
  
由于数组 $\textit{arr}_1[i]$ 起点与终点的「哨兵」一定不会被替换的，因此添加「哨兵」不影响最终结果，最终返回 $\textit{dp}[n]$ 即可。

**代码**

```C++ [sol2.1-C++]
constexpr int INF = 0x3f3f3f3f;

class Solution {
public:
    int makeArrayIncreasing(vector<int>& arr1, vector<int>& arr2) {
        sort(arr2.begin(), arr2.end());
        arr2.erase(unique(arr2.begin(), arr2.end()), arr2.end());
        /* 右侧哨兵 inf */
        arr1.push_back(INF); 
        /* 左侧哨兵 -1 */
        arr1.insert(arr1.begin(), -1); 
        int n = arr1.size();
        int m = arr2.size();

        vector<int> dp(n, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = min(dp[i], dp[i - 1]);
            }
            /* 替换 arr1[i] 左边的连续 j 个元素 */
            for (int j = 1; j < i; j++) { 
                /* arr2 的最优替换的起点为大于 arr1[i - j - 1] 的最小元素 */
                int k = upper_bound(arr2.begin(), arr2.end(), arr1[i - j - 1]) - arr2.begin();
                /* arr2 的最优替换的终点必须满足小于 arr1[i] */
                if (k + j - 1 < m && arr2[k + j - 1] < arr1[i]) {
                    dp[i] = min(dp[i], dp[i - j - 1] + j);
                }
            }
            
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }
};
```

```Java [sol2.1-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;

    public int makeArrayIncreasing(int[] arr1, int[] arr2) {
        Arrays.sort(arr2);
        List<Integer> list = new ArrayList<Integer>();
        int prev = -1;
        for (int num : arr2) {
            if (num != prev) {
                list.add(num);
                prev = num;
            }
        }
        int[] temp = new int[arr1.length + 2];
        System.arraycopy(arr1, 0, temp, 1, arr1.length);
        /* 右侧哨兵 inf */
        temp[arr1.length + 1] = INF;
        /* 左侧哨兵 -1 */
        temp[0] = -1;
        arr1 = temp;
        int n = arr1.length;
        int m = list.size();

        int[] dp = new int[n];
        Arrays.fill(dp, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = Math.min(dp[i], dp[i - 1]);
            }
            /* 替换 arr1[i] 左边的连续 j 个元素 */
            for (int j = 1; j < i; j++) { 
                /* arr2 的最优替换的起点为大于 arr1[i - j - 1] 的最小元素 */
                int k = binarySearch(list, arr1[i - j - 1]);
                /* arr2 的最优替换的终点必须满足小于 arr1[i] */
                if (k + j - 1 < m && list.get(k + j - 1) < arr1[i]) {
                    dp[i] = Math.min(dp[i], dp[i - j - 1] + j);
                }
            }
            
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }

    public int binarySearch(List<Integer> list, int target) {
        int low = 0, high = list.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list.get(mid) > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol2.1-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;

    public int MakeArrayIncreasing(int[] arr1, int[] arr2) {
        Array.Sort(arr2);
        IList<int> list = new List<int>();
        int prev = -1;
        foreach (int num in arr2) {
            if (num != prev) {
                list.Add(num);
                prev = num;
            }
        }
        int[] temp = new int[arr1.Length + 2];
        Array.Copy(arr1, 0, temp, 1, arr1.Length);
        /* 右侧哨兵 inf */
        temp[arr1.Length + 1] = INF;
        /* 左侧哨兵 -1 */
        temp[0] = -1;
        arr1 = temp;
        int n = arr1.Length;
        int m = list.Count;

        int[] dp = new int[n];
        Array.Fill(dp, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = Math.Min(dp[i], dp[i - 1]);
            }
            /* 替换 arr1[i] 左边的连续 j 个元素 */
            for (int j = 1; j < i; j++) { 
                /* arr2 的最优替换的起点为大于 arr1[i - j - 1] 的最小元素 */
                int k = BinarySearch(list, arr1[i - j - 1]);
                /* arr2 的最优替换的终点必须满足小于 arr1[i] */
                if (k + j - 1 < m && list[k + j - 1] < arr1[i]) {
                    dp[i] = Math.Min(dp[i], dp[i - j - 1] + j);
                }
            }
            
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }

    public int BinarySearch(IList<int> list, int target) {
        int low = 0, high = list.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C [sol2.1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int binarySearch(int *arr, int left, int right, int val) {
    int ret = right + 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] > val) {
            ret = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ret;
}

int makeArrayIncreasing(int* arr1, int arr1Size, int* arr2, int arr2Size) {
    int n = arr1Size + 2;
    int arr[n];
    memcpy(arr + 1, arr1, sizeof(int) * arr1Size);
    arr1 = arr;
    /* 左侧哨兵 -1 */
    arr1[0] = -1; 
    /* 右侧哨兵 */
    arr1[arr1Size + 1] = INF; 
    qsort(arr2, arr2Size, sizeof(int), cmp);
    int m = 0;
    for (int i = 0, j = 0; i < arr2Size; i++) {
        if (i == 0 || arr2[i] != arr2[i - 1]) {
            arr2[m++] = arr2[i];
        }
    }
    
    int dp[n];
    memset(dp, 0x3f, sizeof(dp));
    dp[0] = 0;
    for (int i = 1; i < n; i++) {
        /* arr1[i] 左侧的元素不进行替换 */
        if (arr1[i - 1] < arr1[i]) {
            dp[i] = MIN(dp[i], dp[i - 1]);
        }
        /* 替换 arr1[i] 左边的连续 j 个元素 */
        for (int j = 1; j < i; j++) { 
            /* arr2 的最优替换的起点为大于 arr1[i - j - 1] 的最小元素 */
            int k = binarySearch(arr2, 0, m - 1, arr1[i - j - 1]);
            /* arr2 的最优替换的终点必须满足小于 arr1[i] */
            if (k + j - 1 < m && arr2[k + j - 1] < arr1[i]) {
                dp[i] = MIN(dp[i], dp[i - j - 1] + j);
            }
        }
    }
    return dp[n - 1] == INF ? -1 : dp[n - 1];
}
```

```JavaScript [sol2.1-JavaScript]
const INF = 0x3f3f3f3f;
var makeArrayIncreasing = function(arr1, arr2) {
    arr2.sort((a, b) => a - b);
    const list = [];
    let prev = -1;
    for (const num of arr2) {
        if (num !== prev) {
            list.push(num);
            prev = num;
        }
    }
    const temp = new Array(arr1.length + 2).fill(0);
    temp.splice(1, arr1.length, ...arr1);
    /* 右侧哨兵 inf */
    temp[arr1.length + 1] = INF;
    /* 左侧哨兵 -1 */
    temp[0] = -1;
    arr1 = temp;
    const n = arr1.length;
    const m = list.length;

    const dp = new Array(n).fill(INF);
    dp[0] = 0;
    for (let i = 1; i < n; i++) {
        /* arr1[i] 左侧的元素不进行替换 */
        if (arr1[i - 1] < arr1[i]) {
            dp[i] = Math.min(dp[i], dp[i - 1]);
        }
        /* 替换 arr1[i] 左边的连续 j 个元素 */
        for (let j = 1; j < i; j++) {
            /* arr2 的最优替换的起点为大于 arr1[i - j - 1] 的最小元素 */
            const k = binarySearch(list, arr1[i - j - 1]);
            /* arr2 的最优替换的终点必须满足小于 arr1[i] */
            if (k + j - 1 < m && list[k + j - 1] < arr1[i]) {
                dp[i] = Math.min(dp[i], dp[i - j - 1] + j);
            }
        }

    }
    return dp[n - 1] === INF ? -1 : dp[n - 1];
}

const binarySearch = (list, target) => {
    let low = 0, high = list.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (list[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
};
```

上述方法我们可以进行进一步优化，首先可以利用二分查找找到替换元素的右侧终点，利用二分查找找到严格小于 $\textit{arr}_1[i]$ 的最大元素 $\textit{arr}_2[k]$，然后从 $k$ 起始依次向前枚举连续替换元素的个数 $j$，即 $[\textit{arr}_1[i-j],\textit{arr}_1[i-j+1],\cdots,\textit{arr}_1[i-1]]$ 连续 $j$ 个元素被替换，此时只需要检测 $\textit{arr}_2[k-j] > \textit{arr}_1[i-j-1]$ 即可，时间复杂度可以进一步优化。 

```C++ [sol2.2-C++]
constexpr int INF = 0x3f3f3f3f;

class Solution {
public:
    int makeArrayIncreasing(vector<int>& arr1, vector<int>& arr2) {
        sort(arr2.begin(), arr2.end());
        arr2.erase(unique(arr2.begin(), arr2.end()), arr2.end());
        /* 右侧哨兵 inf */
        arr1.push_back(INF); 
        /* 左侧哨兵 -1 */
        arr1.insert(arr1.begin(), -1); 
        int n = arr1.size();
        int m = arr2.size();

        vector<int> dp(n, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = min(dp[i], dp[i - 1]);
            }
            /* 固定替换元素的右侧终点 */
            int k = lower_bound(arr2.begin(), arr2.end(), arr1[i]) - arr2.begin();
            /* 枚举从 i 左侧连续替换元素的个数 */
            for (int j = 1; j <= min(i - 1, k); ++j) {
                /* 替换的连续 j 个元素的左侧起点需满足大于 arr1[i - j - 1] */ 
                if (arr1[i - j - 1] < arr2[k - j]) {
                    dp[i] = min(dp[i], dp[i - j - 1] + j);
                }
            }
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }
};
```

```Java [sol2.2-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;

    public int makeArrayIncreasing(int[] arr1, int[] arr2) {
        Arrays.sort(arr2);
        List<Integer> list = new ArrayList<Integer>();
        int prev = -1;
        for (int num : arr2) {
            if (num != prev) {
                list.add(num);
                prev = num;
            }
        }
        int[] temp = new int[arr1.length + 2];
        System.arraycopy(arr1, 0, temp, 1, arr1.length);
        /* 右侧哨兵 inf */
        temp[arr1.length + 1] = INF;
        /* 左侧哨兵 -1 */
        temp[0] = -1;
        arr1 = temp;
        int n = arr1.length;
        int m = list.size();

        int[] dp = new int[n];
        Arrays.fill(dp, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = Math.min(dp[i], dp[i - 1]);
            }
            /* 固定替换元素的右侧终点 */
            int k = binarySearch(list, arr1[i]);
            /* 枚举从 i 左侧连续替换元素的个数 */
            for (int j = 1; j <= Math.min(i - 1, k); ++j) {
                /* 替换的连续 j 个元素的左侧起点需满足大于 arr1[i - j - 1] */ 
                if (arr1[i - j - 1] < list.get(k - j)) {
                    dp[i] = Math.min(dp[i], dp[i - j - 1] + j);
                }
            }
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }

    public int binarySearch(List<Integer> list, int target) {
        int low = 0, high = list.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list.get(mid) >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol2.2-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;

    public int MakeArrayIncreasing(int[] arr1, int[] arr2) {
        Array.Sort(arr2);
        IList<int> list = new List<int>();
        int prev = -1;
        foreach (int num in arr2) {
            if (num != prev) {
                list.Add(num);
                prev = num;
            }
        }
        int[] temp = new int[arr1.Length + 2];
        Array.Copy(arr1, 0, temp, 1, arr1.Length);
        /* 右侧哨兵 inf */
        temp[arr1.Length + 1] = INF;
        /* 左侧哨兵 -1 */
        temp[0] = -1;
        arr1 = temp;
        int n = arr1.Length;
        int m = list.Count;

        int[] dp = new int[n];
        Array.Fill(dp, INF);
        dp[0] = 0;
        for (int i = 1; i < n; i++) {
            /* arr1[i] 左侧的元素不进行替换 */
            if (arr1[i - 1] < arr1[i]) {
                dp[i] = Math.Min(dp[i], dp[i - 1]);
            }
            /* 固定替换元素的右侧终点 */
            int k = BinarySearch(list, arr1[i]);
            /* 枚举从 i 左侧连续替换元素的个数 */
            for (int j = 1; j <= Math.Min(i - 1, k); ++j) {
                /* 替换的连续 j 个元素的左侧起点需满足大于 arr1[i - j - 1] */ 
                if (arr1[i - j - 1] < list[k - j]) {
                    dp[i] = Math.Min(dp[i], dp[i - j - 1] + j);
                }
            }
        }
        return dp[n - 1] == INF ? -1 : dp[n - 1];
    }

    public int BinarySearch(IList<int> list, int target) {
        int low = 0, high = list.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (list[mid] >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C [sol2.2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int binarySearch(int *arr, int left, int right, int val) {
    int ret = right + 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] >= val) {
            ret = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ret;
}

int makeArrayIncreasing(int* arr1, int arr1Size, int* arr2, int arr2Size) {
    int n = arr1Size + 2;
    int arr[n];
    memcpy(arr + 1, arr1, sizeof(int) * arr1Size);
    arr1 = arr;
    arr1[0] = -1;
    arr1[arr1Size + 1] = INF;
    qsort(arr2, arr2Size, sizeof(int), cmp);
    int m = 0;
    for (int i = 0, j = 0; i < arr2Size; i++) {
        if (i == 0 || arr2[i] != arr2[i - 1]) {
            arr2[m++] = arr2[i];
        }
    }
    
    int dp[n];
    memset(dp, 0x3f, sizeof(dp));
    dp[0] = 0;
    for (int i = 1; i < n; i++) {
        /* arr1[i] 左侧的元素不进行替换 */
        if (arr1[i - 1] < arr1[i]) {
            dp[i] = MIN(dp[i], dp[i-1]);
        }
        /* 固定替换元素的右侧终点 */
        int k = binarySearch(arr2, 0, m - 1, arr1[i]);
        /* 枚举从 i 左侧连续替换元素的个数 */
        for (int j = 1; j <= MIN(i - 1, k); ++j) {
            /* 替换的连续 j 个元素的左侧起点需满足大于 arr1[i - j - 1] */ 
            if (arr1[i - j - 1] < arr2[k - j]) {
                dp[i] = MIN(dp[i], dp[i - j - 1] + j);
            }
        }
    }
    return dp[n - 1] == INF ? -1 : dp[n - 1];
}
```

```JavaScript [sol2.2-JavaScript]
const INF = 0x3f3f3f3f;
var makeArrayIncreasing = function(arr1, arr2) {
    arr2.sort((a, b) => a - b);
    const list = [];
    let prev = -1;
    for (const num of arr2) {
        if (num !== prev) {
            list.push(num);
            prev = num;
        }
    }
    const temp = new Array(arr1.length + 2).fill(0);
    temp.splice(1, arr1.length, ...arr1);
    /* 右侧哨兵 inf */
    temp[arr1.length + 1] = INF;
    /* 左侧哨兵 -1 */
    temp[0] = -1;
    arr1 = temp;
    const n = arr1.length;
    const m = list.length;

    const dp = new Array(n).fill(INF);
    dp[0] = 0;
    for (let i = 1; i < n; i++) {
        /* arr1[i] 左侧的元素不进行替换 */
        if (arr1[i - 1] < arr1[i]) {
            dp[i] = Math.min(dp[i], dp[i - 1]);
        }
        /* 固定替换元素的右侧终点 */
        const k = binarySearch(list, arr1[i]);
        /* 枚举从 i 左侧连续替换元素的个数 */
        for (let j = 1; j <= Math.min(i - 1, k); ++j) {
            /* 替换的连续 j 个元素的左侧起点需满足大于 arr1[i - j - 1] */
            if (arr1[i - j - 1] < list[k - j]) {
                dp[i] = Math.min(dp[i], dp[i - j - 1] + j);
            }
        }
    }
    return dp[n - 1] === INF ? -1 : dp[n - 1];
}

const binarySearch = (list, target) => {
    let low = 0, high = list.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (list[mid] >= target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times (\log m + \min(m,n)))$，其中 $n$ 表示数组 $\textit{arr}_1$ 的长度，$m$ 表示数组 $\textit{arr}_2$ 的长度。每次对 $i$ 之前的元素替换时，我们都需利用二分查找找到 $\textit{arr}_2$ 中子数组右侧的终点，需要的时间复杂度为 $O(\log m)$，然后依次枚举子数组的起点，一共最多需要枚举 $\min(m,n)$ 次，因此总的时间复杂度为 $O(n \times (\log m + \min(m,n)))$。

- 空间复杂度：$O(n)$，其中 $n$ 表示数组的长度。根据题目定义最多只有 $n$ 个状态，因此需要的空间为 $O(n)$。