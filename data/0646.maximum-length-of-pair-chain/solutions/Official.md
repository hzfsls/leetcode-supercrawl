## [646.最长数对链 中文官方题解](https://leetcode.cn/problems/maximum-length-of-pair-chain/solutions/100000/zui-chang-shu-dui-lian-by-leetcode-solut-ifpn)
#### 前言

这题和「[435. 无重叠区间](https://leetcode.cn/problems/non-overlapping-intervals/)」类似，区别就是：
 1. 此题中，数对链中相邻的数对，前者的第二个数字必须小于后者的第一个数字。而在「[435. 无重叠区间](https://leetcode.cn/problems/non-overlapping-intervals/)」中，相邻的区间，前者的结束时间需小于等于后者的开始时间。
 2. 此题返回最长数对链的长度，而 「[435. 无重叠区间](https://leetcode.cn/problems/non-overlapping-intervals/)」返回形成无重叠区间，最少需要删除多少区间（即原长度减去最长数对链的长度）。

此题解也按照「[435. 无重叠区间的官方题解](https://leetcode.cn/problems/non-overlapping-intervals/solution/wu-zhong-die-qu-jian-by-leetcode-solutio-cpsb/)」进行编写。

#### 方法一：动态规划

**思路**

定义 $\textit{dp}[i]$ 为以 $\textit{pairs}[i]$ 为结尾的最长数对链的长度。计算 $\textit{dp}[i]$ 时，可以先找出所有的满足 $\textit{pairs}[i][0] > \textit{pairs}[j][1]$ 的 $j$，并求出最大的 $\textit{dp}[j]$，$\textit{dp}[i]$ 的值即可赋为这个最大值加一。这种动态规划的思路要求计算 $\textit{dp}[i]$ 时，所有潜在的 $\textit{dp}[j]$ 已经计算完成，可以先将 $\textit{pairs}$ 进行排序来满足这一要求。初始化时，$\textit{dp}$ 需要全部赋值为 $1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def findLongestChain(self, pairs: List[List[int]]) -> int:
        pairs.sort()
        dp = [1] * len(pairs)
        for i in range(len(pairs)):
            for j in range(i):
                if pairs[i][0] > pairs[j][1]:
                    dp[i] = max(dp[i], dp[j] + 1)
        return dp[-1]
```

```C++ [sol1-C++]
class Solution {
public:
    int findLongestChain(vector<vector<int>>& pairs) {
        int n = pairs.size();
        sort(pairs.begin(), pairs.end());
        vector<int> dp(n, 1);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (pairs[i][0] > pairs[j][1]) {
                    dp[i] = max(dp[i], dp[j] + 1);
                }
            }
        }
        return dp[n - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLongestChain(int[][] pairs) {
        int n = pairs.length;
        Arrays.sort(pairs, (a, b) -> a[0] - b[0]);
        int[] dp = new int[n];
        Arrays.fill(dp, 1);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (pairs[i][0] > pairs[j][1]) {
                    dp[i] = Math.max(dp[i], dp[j] + 1);
                }
            }
        }
        return dp[n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindLongestChain(int[][] pairs) {
        int n = pairs.Length;
        Array.Sort(pairs, (a, b) => a[0] - b[0]);
        int[] dp = new int[n];
        Array.Fill(dp, 1);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (pairs[i][0] > pairs[j][1]) {
                    dp[i] = Math.Max(dp[i], dp[j] + 1);
                }
            }
        }
        return dp[n - 1];
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static inline int cmp(const void *pa, const void *pb) {
    if ((*(int **)pa)[0] == (*(int **)pb)[0]) {
        return (*(int **)pa)[1] == (*(int **)pb)[1];
    } 
    return (*(int **)pa)[0] - (*(int **)pb)[0];
}

int findLongestChain(int** pairs, int pairsSize, int* pairsColSize){
    qsort(pairs, pairsSize, sizeof(int *), cmp);
    int *dp = (int *)malloc(sizeof(int) * pairsSize);
    for (int i = 0; i < pairsSize; i++) {
        dp[i] = 1;
    }
    for (int i = 0; i < pairsSize; i++) {
        for (int j = 0; j < i; j++) {
            if (pairs[i][0] > pairs[j][1]) {
                dp[i] = MAX(dp[i], dp[j] + 1);
            }
        }
    }
    int ret = dp[pairsSize - 1];
    free(dp);
    return ret;
}
```

```go [sol1-Golang]
func findLongestChain(pairs [][]int) int {
    sort.Slice(pairs, func(i, j int) bool { return pairs[i][0] < pairs[j][0] })
    n := len(pairs)
    dp := make([]int, n)
    for i, p := range pairs {
        dp[i] = 1
        for j, q := range pairs[:i] {
            if p[0] > q[1] {
                dp[i] = max(dp[i], dp[j]+1)
            }
        }
    }
    return dp[n-1]
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var findLongestChain = function(pairs) {
    const n = pairs.length;
    pairs.sort((a, b) => a[0] - b[0]);
    const dp = new Array(n).fill(1);
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < i; j++) {
            if (pairs[i][0] > pairs[j][1]) {
                dp[i] = Math.max(dp[i], dp[j] + 1);
            }
        }
    }
    return dp[n - 1];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为 $\textit{pairs}$ 的长度。排序的时间复杂度为 $O(n \log n)$，两层 $\texttt{for}$ 循环的时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n)$，数组 $\textit{dp}$ 的空间复杂度为 $O(n)$。

#### 方法二：最长递增子序列

**思路**

方法一实际上是「[300. 最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/)」的动态规划解法，这个解法可以改造为贪心 + 二分查找的形式。用一个数组 $\textit{arr}$ 来记录当前最优情况，$\textit{arr}[i]$ 就表示长度为 $i+1$ 的数对链的末尾可以取得的最小值，遇到一个新数对时，先用二分查找得到这个数对可以放置的位置，再更新 $\textit{arr}$。

**代码**

```Python [sol2-Python3]
class Solution:
    def findLongestChain(self, pairs: List[List[int]]) -> int:
        pairs.sort()
        arr = []
        for x, y in pairs:
            i = bisect_left(arr, x)
            if i < len(arr):
                arr[i] = min(arr[i], y)
            else:
                arr.append(y)
        return len(arr)
```

```C++ [sol2-C++]
class Solution {
public:
    int findLongestChain(vector<vector<int>>& pairs) {
        sort(pairs.begin(), pairs.end());
        vector<int> arr;
        for (auto p : pairs) {
            int x = p[0], y = p[1];
            if (arr.size() == 0 || x > arr.back()) {
                arr.emplace_back(y);
            } else {
                int idx = lower_bound(arr.begin(), arr.end(), x) - arr.begin();
                arr[idx] = min(arr[idx], y);
            }
        }
        return arr.size();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int findLongestChain(int[][] pairs) {
        Arrays.sort(pairs, (a, b) -> a[0] - b[0]);
        List<Integer> arr = new ArrayList<Integer>();
        for (int[] p : pairs) {
            int x = p[0], y = p[1];
            if (arr.isEmpty() || x > arr.get(arr.size() - 1)) {
                arr.add(y);
            } else {
                int idx = binarySearch(arr, x);
                arr.set(idx, Math.min(arr.get(idx), y));
            }
        }
        return arr.size();
    }

    public int binarySearch(List<Integer> arr, int x) {
        int low = 0, high = arr.size() - 1;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (arr.get(mid) >= x) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindLongestChain(int[][] pairs) {
        Array.Sort(pairs, (a, b) => a[0] - b[0]);
        IList<int> arr = new List<int>();
        foreach (int[] p in pairs) {
            int x = p[0], y = p[1];
            if (arr.Count == 0 || x > arr[arr.Count - 1]) {
                arr.Add(y);
            } else {
                int idx = BinarySearch(arr, x);
                arr[idx] = Math.Min(arr[idx], y);
            }
        }
        return arr.Count;
    }

    public int BinarySearch(IList<int> arr, int x) {
        int low = 0, high = arr.Count - 1;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (arr[mid] >= x) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static inline int cmp(const void *pa, const void *pb) {
    if ((*(int **)pa)[0] == (*(int **)pb)[0]) {
        return (*(int **)pa)[1] == (*(int **)pb)[1];
    } 
    return (*(int **)pa)[0] - (*(int **)pb)[0];
}

int lowerbound(const int *arr, int left, int right, int val) {
    int ret = -1;
    while (left <= right) {
        int mid = (left + right) >> 1;
        if (arr[mid] >= val) {
            ret = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ret;
}

int findLongestChain(int** pairs, int pairsSize, int* pairsColSize){
    qsort(pairs, pairsSize, sizeof(int *), cmp);
    int *arr = (int *)malloc(sizeof(int) * pairsSize);
    int pos = 0;
    for (int i = 0; i < pairsSize; i++) {
        int x = pairs[i][0], y = pairs[i][1];
        if (pos == 0 || x > arr[pos - 1]) {
            arr[pos++] = y;
        } else {
            int idx = lowerbound(arr, 0, pos - 1, x);
            arr[idx] = MIN(arr[idx], y);
        }
    }
    free(arr);
    return pos;
}
```

```go [sol2-Golang]
func findLongestChain(pairs [][]int) int {
    sort.Slice(pairs, func(i, j int) bool { return pairs[i][0] < pairs[j][0] })
    arr := []int{}
    for _, p := range pairs {
        i := sort.SearchInts(arr, p[0])
        if i < len(arr) {
            arr[i] = min(arr[i], p[1])
        } else {
            arr = append(arr, p[1])
        }
    }
    return len(arr)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
var findLongestChain = function(pairs) {
    pairs.sort((a, b) => a[0] - b[0]);
    const arr = [];
    for (const p of pairs) {
        let x = p[0], y = p[1];
        if (arr.length === 0 || x > arr[arr.length - 1]) {
            arr.push(y);
        } else {
            const idx = binarySearch(arr, x);
            arr[idx] =  Math.min(arr[idx], y);
        }
    }
    return arr.length;
}

const binarySearch = (arr, x) => {
    let low = 0, high = arr.length - 1;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (arr[mid] >= x) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
};

```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{pairs}$ 的长度。排序的时间复杂度为 $O(n \log n)$，二分查找的时间复杂度为 $O(n \log n)$，二分的次数为 $O(n)$。

- 空间复杂度：$O(n)$，数组 $\textit{arr}$ 的长度最多为 $O(n)$。

#### 方法三：贪心

**思路**

要挑选最长数对链的第一个数对时，最优的选择是挑选第二个数字最小的，这样能给挑选后续的数对留下更多的空间。挑完第一个数对后，要挑第二个数对时，也是按照相同的思路，是在剩下的数对中，第一个数字满足题意的条件下，挑选第二个数字最小的。按照这样的思路，可以先将输入按照第二个数字排序，然后不停地判断第一个数字是否能满足大于前一个数对的第二个数字即可。

**代码**

```Python [sol3-Python3]
class Solution(object):
    def findLongestChain(self, pairs: List[List[int]]) -> int:
        cur, res = -inf, 0
        for x, y in sorted(pairs, key=lambda p: p[1]):
            if cur < x:
                cur = y
                res += 1
        return res
```

```C++ [sol3-C++]
class Solution {
public:
    int findLongestChain(vector<vector<int>>& pairs) {
        int curr = INT_MIN, res = 0;
        sort(pairs.begin(), pairs.end(), [](const vector<int> &a, const vector<int> &b) {
            return a[1] < b[1];
        });
        for (auto &p : pairs) {
            if (curr < p[0]) {
                curr = p[1];
                res++;
            }
        }
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int findLongestChain(int[][] pairs) {
        int curr = Integer.MIN_VALUE, res = 0;
        Arrays.sort(pairs, (a, b) -> a[1] - b[1]);
        for (int[] p : pairs) {
            if (curr < p[0]) {
                curr = p[1];
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int FindLongestChain(int[][] pairs) {
        int curr = int.MinValue, res = 0;
        Array.Sort(pairs, (a, b) => a[1] - b[1]);
        foreach (int[] p in pairs) {
            if (curr < p[0]) {
                curr = p[1];
                res++;
            }
        }
        return res;
    }
}
```

```C [sol3-C]
static inline int cmp(const void *pa, const void *pb) {
    return (*(int **)pa)[1] - (*(int **)pb)[1];
}

int findLongestChain(int** pairs, int pairsSize, int* pairsColSize){
    int curr = INT_MIN, res = 0;
    qsort(pairs, pairsSize, sizeof(int *), cmp);
    for (int i = 0; i < pairsSize; i++) {
        if (curr < pairs[i][0]) {
            curr = pairs[i][1];
            res += 1;
        }
    }
    return res;
}
```

```go [sol3-Golang]
func findLongestChain(pairs [][]int) (ans int) {
    sort.Slice(pairs, func(i, j int) bool { return pairs[i][1] < pairs[j][1] })
    cur := math.MinInt32
    for _, p := range pairs {
        if cur < p[0] {
            cur = p[1]
            ans++
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var findLongestChain = function(pairs) {
    let curr = -Number.MAX_VALUE, res = 0;
    pairs.sort((a, b) => a[1] - b[1]);
    for (const p of pairs) {
        if (curr < p[0]) {
            curr = p[1];
            res++;
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{pairs}$ 的长度。排序的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，为排序的空间复杂度。