## [673.最长递增子序列的个数 中文官方题解](https://leetcode.cn/problems/number-of-longest-increasing-subsequence/solutions/100000/zui-chang-di-zeng-zi-xu-lie-de-ge-shu-by-w12f)
#### 前言

本题是「[300. 最长递增子序列](https://leetcode-cn.com/problems/longest-increasing-subsequence/)」的进阶版本，建议读者在掌握该题做法后继续阅读。

#### 方法一：动态规划

**思路与算法**

定义 $\textit{dp}[i]$ 表示以 $\textit{nums}[i]$ 结尾的最长上升子序列的长度，$\textit{cnt}[i]$ 表示以 $\textit{nums}[i]$ 结尾的最长上升子序列的个数。设 $\textit{nums}$ 的最长上升子序列的长度为 $\textit{maxLen}$，那么答案为所有满足 $\textit{dp}[i]=\textit{maxLen}$ 的 $i$ 所对应的 $\textit{cnt}[i]$ 之和。

我们从小到大计算 $\textit{dp}$ 数组的值，在计算 $\textit{dp}[i]$ 之前，我们已经计算出 $\textit{dp}[0 \ldots i-1]$ 的值，则状态转移方程为：

$$
\textit{dp}[i] = \max(\textit{dp}[j]) + 1, \text{其中} \, 0 \leq j < i \, \text{且} \, \textit{num}[j]<\textit{num}[i]
$$

即考虑往 $\textit{dp}[0 \ldots i-1]$ 中最长的上升子序列后面再加一个 $\textit{nums}[i]$。由于 $\textit{dp}[j]$ 代表 $\textit{nums}[0 \ldots j]$ 中以 $\textit{nums}[j]$ 结尾的最长上升子序列，所以如果能从 $\textit{dp}[j]$ 这个状态转移过来，那么 $\textit{nums}[i]$ 必然要大于 $\textit{nums}[j]$，才能将 $\textit{nums}[i]$ 放在 $\textit{nums}[j]$ 后面以形成更长的上升子序列。

对于 $\textit{cnt}[i]$，其等于所有满足 $\textit{dp}[j]+1=\textit{dp}[i]$ 的 $\textit{cnt}[j]$ 之和。在代码实现时，我们可以在计算 $\textit{dp}[i]$ 的同时统计 $\textit{cnt}[i]$ 的值。

```Python [sol1-Python3]
class Solution:
    def findNumberOfLIS(self, nums: List[int]) -> int:
        n, max_len, ans = len(nums), 0, 0
        dp = [0] * n
        cnt = [0] * n
        for i, x in enumerate(nums):
            dp[i] = 1
            cnt[i] = 1
            for j in range(i):
                if x > nums[j]:
                    if dp[j] + 1 > dp[i]:
                        dp[i] = dp[j] + 1
                        cnt[i] = cnt[j]  # 重置计数
                    elif dp[j] + 1 == dp[i]:
                        cnt[i] += cnt[j]
            if dp[i] > max_len:
                max_len = dp[i]
                ans = cnt[i]  # 重置计数
            elif dp[i] == max_len:
                ans += cnt[i]
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int findNumberOfLIS(vector<int> &nums) {
        int n = nums.size(), maxLen = 0, ans = 0;
        vector<int> dp(n), cnt(n);
        for (int i = 0; i < n; ++i) {
            dp[i] = 1;
            cnt[i] = 1;
            for (int j = 0; j < i; ++j) {
                if (nums[i] > nums[j]) {
                    if (dp[j] + 1 > dp[i]) {
                        dp[i] = dp[j] + 1;
                        cnt[i] = cnt[j]; // 重置计数
                    } else if (dp[j] + 1 == dp[i]) {
                        cnt[i] += cnt[j];
                    }
                }
            }
            if (dp[i] > maxLen) {
                maxLen = dp[i];
                ans = cnt[i]; // 重置计数
            } else if (dp[i] == maxLen) {
                ans += cnt[i];
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findNumberOfLIS(int[] nums) {
        int n = nums.length, maxLen = 0, ans = 0;
        int[] dp = new int[n];
        int[] cnt = new int[n];
        for (int i = 0; i < n; ++i) {
            dp[i] = 1;
            cnt[i] = 1;
            for (int j = 0; j < i; ++j) {
                if (nums[i] > nums[j]) {
                    if (dp[j] + 1 > dp[i]) {
                        dp[i] = dp[j] + 1;
                        cnt[i] = cnt[j]; // 重置计数
                    } else if (dp[j] + 1 == dp[i]) {
                        cnt[i] += cnt[j];
                    }
                }
            }
            if (dp[i] > maxLen) {
                maxLen = dp[i];
                ans = cnt[i]; // 重置计数
            } else if (dp[i] == maxLen) {
                ans += cnt[i];
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindNumberOfLIS(int[] nums) {
        int n = nums.Length, maxLen = 0, ans = 0;
        int[] dp = new int[n];
        int[] cnt = new int[n];
        for (int i = 0; i < n; ++i) {
            dp[i] = 1;
            cnt[i] = 1;
            for (int j = 0; j < i; ++j) {
                if (nums[i] > nums[j]) {
                    if (dp[j] + 1 > dp[i]) {
                        dp[i] = dp[j] + 1;
                        cnt[i] = cnt[j]; // 重置计数
                    } else if (dp[j] + 1 == dp[i]) {
                        cnt[i] += cnt[j];
                    }
                }
            }
            if (dp[i] > maxLen) {
                maxLen = dp[i];
                ans = cnt[i]; // 重置计数
            } else if (dp[i] == maxLen) {
                ans += cnt[i];
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func findNumberOfLIS(nums []int) (ans int) {
    maxLen := 0
    n := len(nums)
    dp := make([]int, n)
    cnt := make([]int, n)
    for i, x := range nums {
        dp[i] = 1
        cnt[i] = 1
        for j, y := range nums[:i] {
            if x > y {
                if dp[j]+1 > dp[i] {
                    dp[i] = dp[j] + 1
                    cnt[i] = cnt[j] // 重置计数
                } else if dp[j]+1 == dp[i] {
                    cnt[i] += cnt[j]
                }
            }
        }
        if dp[i] > maxLen {
            maxLen = dp[i]
            ans = cnt[i] // 重置计数
        } else if dp[i] == maxLen {
            ans += cnt[i]
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findNumberOfLIS = function(nums) {
    let n = nums.length, maxLen = 0, ans = 0;
    const dp = new Array(n).fill(0);
    const cnt = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        dp[i] = 1;
        cnt[i] = 1;
        for (let j = 0; j < i; ++j) {
            if (nums[i] > nums[j]) {
                if (dp[j] + 1 > dp[i]) {
                    dp[i] = dp[j] + 1;
                    cnt[i] = cnt[j]; // 重置计数
                } else if (dp[j] + 1 === dp[i]) {
                    cnt[i] += cnt[j];
                }
            }
        }
        if (dp[i] > maxLen) {
            maxLen = dp[i];
            ans = cnt[i]; // 重置计数
        } else if (dp[i] === maxLen) {
            ans += cnt[i];
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。

#### 方法二：贪心 + 前缀和 + 二分查找

下文在「[300. 最长递增子序列的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)」的方法二上进行扩展，请读者在了解该方法后继续阅读。

我们将数组 $d$ 扩展成一个二维数组，其中 $d[i]$ 数组表示所有能成为长度为 $i$ 的最长上升子序列的末尾元素的值。具体地，我们将更新 $d[i]=\textit{nums}[j]$ 这一操作替换成将 $\textit{nums}[j]$ 置于 $d[i]$ 数组末尾。这样 $d[i]$ 中就保留了历史信息，且 $d[i]$ 中的元素是有序的（单调非增）。

类似地，我们也可以定义一个二维数组 $\textit{cnt}$，其中 $\textit{cnt}[i][j]$ 记录了以 $d[i][j]$ 为结尾的最长上升子序列的个数。为了计算 $\textit{cnt}[i][j]$，我们可以考察 $d[i-1]$ 和 $\textit{cnt}[i-1]$，将所有满足 $d[i-1][k]<d[i][j]$ 的 $\textit{cnt}[i-1][k]$ 累加到 $\textit{cnt}[i][j]$，这样最终答案就是 $\textit{cnt}[\textit{maxLen}]$ 的所有元素之和。

在代码实现时，由于 $d[i]$ 中的元素是有序的，我们可以二分得到最小的满足 $d[i-1][k]<d[i][j]$ 的下标 $k$。另一处优化是将 $\textit{cnt}$ 改为其前缀和，并在开头填上 $0$，此时 $d[i][j]$ 对应的最长上升子序列的个数就是 $\textit{cnt}[i-1][-1]-\textit{cnt}[i-1][k]$，这里 $[-1]$ 表示数组的最后一个元素。

```Python [sol2-Python3]
class Solution:
    def findNumberOfLIS(self, nums: List[int]) -> int:
        d, cnt = [], []
        for v in nums:
            i = bisect(len(d), lambda i: d[i][-1] >= v)
            c = 1
            if i > 0:
                k = bisect(len(d[i - 1]), lambda k: d[i - 1][k] < v)
                c = cnt[i - 1][-1] - cnt[i - 1][k]
            if i == len(d):
                d.append([v])
                cnt.append([0, c])
            else:
                d[i].append(v)
                cnt[i].append(cnt[i][-1] + c)
        return cnt[-1][-1]

def bisect(n: int, f: Callable[[int], bool]) -> int:
    l, r = 0, n
    while l < r:
        mid = (l + r) // 2
        if f(mid):
            r = mid
        else:
            l = mid + 1
    return l
```

```C++ [sol2-C++]
class Solution {
    int binarySearch(int n, function<bool(int)> f) {
        int l = 0, r = n;
        while (l < r) {
            int mid = (l + r) / 2;
            if (f(mid)) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }

public:
    int findNumberOfLIS(vector<int> &nums) {
        vector<vector<int>> d, cnt;
        for (int v : nums) {
            int i = binarySearch(d.size(), [&](int i) { return d[i].back() >= v; });
            int c = 1;
            if (i > 0) {
                int k = binarySearch(d[i - 1].size(), [&](int k) { return d[i - 1][k] < v; });
                c = cnt[i - 1].back() - cnt[i - 1][k];
            }
            if (i == d.size()) {
                d.push_back({v});
                cnt.push_back({0, c});
            } else {
                d[i].push_back(v);
                cnt[i].push_back(cnt[i].back() + c);
            }
        }
        return cnt.back().back();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int findNumberOfLIS(int[] nums) {
        List<List<Integer>> d = new ArrayList<List<Integer>>();
        List<List<Integer>> cnt = new ArrayList<List<Integer>>();
        for (int v : nums) {
            int i = binarySearch1(d.size(), d, v);
            int c = 1;
            if (i > 0) {
                int k = binarySearch2(d.get(i - 1).size(), d.get(i - 1), v);
                c = cnt.get(i - 1).get(cnt.get(i - 1).size() - 1) - cnt.get(i - 1).get(k);
            }
            if (i == d.size()) {
                List<Integer> dList = new ArrayList<Integer>();
                dList.add(v);
                d.add(dList);
                List<Integer> cntList = new ArrayList<Integer>();
                cntList.add(0);
                cntList.add(c);
                cnt.add(cntList);
            } else {
                d.get(i).add(v);
                int cntSize = cnt.get(i).size();
                cnt.get(i).add(cnt.get(i).get(cntSize - 1) + c);
            }
        }

        int size1 = cnt.size(), size2 = cnt.get(size1 - 1).size();
        return cnt.get(size1 - 1).get(size2 - 1);
    }

    public int binarySearch1(int n, List<List<Integer>> d, int target) {
        int l = 0, r = n;
        while (l < r) {
            int mid = (l + r) / 2;
            List<Integer> list = d.get(mid);
            if (list.get(list.size() - 1) >= target) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }

    public int binarySearch2(int n, List<Integer> list, int target) {
        int l = 0, r = n;
        while (l < r) {
            int mid = (l + r) / 2;
            if (list.get(mid) < target) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindNumberOfLIS(int[] nums) {
        IList<IList<int>> d = new List<IList<int>>();
        IList<IList<int>> cnt = new List<IList<int>>();
        foreach (int v in nums) {
            int i = BinarySearch1(d.Count, d, v);
            int c = 1;
            if (i > 0) {
                int k = BinarySearch2(d[i - 1].Count, d[i - 1], v);
                c = cnt[i - 1][cnt[i - 1].Count - 1] - cnt[i - 1][k];
            }
            if (i == d.Count) {
                IList<int> dIList = new List<int>();
                dIList.Add(v);
                d.Add(dIList);
                IList<int> cntIList = new List<int>();
                cntIList.Add(0);
                cntIList.Add(c);
                cnt.Add(cntIList);
            } else {
                d[i].Add(v);
                int cntSize = cnt[i].Count;
                cnt[i].Add(cnt[i][cntSize - 1] + c);
            }
        }

        int count1 = cnt.Count, count2 = cnt[count1 - 1].Count;
        return cnt[count1 - 1][count2 - 1];
    }

    public int BinarySearch1(int n, IList<IList<int>> d, int target) {
        int l = 0, r = n;
        while (l < r) {
            int mid = (l + r) / 2;
            IList<int> list = d[mid];
            if (list[list.Count - 1] >= target) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }

    public int BinarySearch2(int n, IList<int> list, int target) {
        int l = 0, r = n;
        while (l < r) {
            int mid = (l + r) / 2;
            if (list[mid] < target) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }
}
```

```go [sol2-Golang]
func findNumberOfLIS(nums []int) int {
    d := [][]int{}
    cnt := [][]int{}
    for _, v := range nums {
        i := sort.Search(len(d), func(i int) bool { return d[i][len(d[i])-1] >= v })
        c := 1
        if i > 0 {
            k := sort.Search(len(d[i-1]), func(k int) bool { return d[i-1][k] < v })
            c = cnt[i-1][len(cnt[i-1])-1] - cnt[i-1][k]
        }
        if i == len(d) {
            d = append(d, []int{v})
            cnt = append(cnt, []int{0, c})
        } else {
            d[i] = append(d[i], v)
            cnt[i] = append(cnt[i], cnt[i][len(cnt[i])-1]+c)
        }
    }
    c := cnt[len(cnt)-1]
    return c[len(c)-1]
}
```

```JavaScript [sol2-JavaScript]
var findNumberOfLIS = function(nums) {
    const d = [];
    const cnt = [];
    for (const v of nums) {
        const i = binarySearch1(d.length, d, v);
        let c = 1;
        if (i > 0) {
            const k = binarySearch2(d[i - 1].length, d[i - 1], v);
            c = cnt[i - 1][cnt[i - 1].length - 1] - cnt[i - 1][k];
            
            // console.log(cnt, i)
        }
        if (i === d.length) {
            const dList = [];
            dList.push(v);
            d.push(dList);
            const cntList = [];
            cntList.push(0);
            cntList.push(c);
            cnt.push(cntList);
        } else {
            d[i].push(v);
            const cntSize = cnt[i].length;
            cnt[i].push(cnt[i][cntSize - 1] + c);
        }
    }

    const size1 = cnt.length, size2 = cnt[size1 - 1].length;
    return cnt[size1 - 1][size2 - 1];
}

const binarySearch1 = (n, d, target) => {
    let l = 0, r = n;
    while (l < r) {
        const mid = Math.floor((l + r) / 2);
        const list = d[mid];
        if (list[list.length - 1] >= target) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
}

const binarySearch2 = (n, list, target) => {
    let l = 0, r = n;
    while (l < r) {
        const mid = Math.floor((l + r) / 2);
        if (list[mid] < target) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。对 $\textit{nums}$ 中的每个元素我们需要执行至多两次二分查找，每次耗时 $O(\log n)$，因此时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(n)$。