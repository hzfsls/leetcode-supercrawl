#### 方法一：贪心 + 正向思维

我们把数组中的数分成三部分 $a, b, c$，它们分别包含所有被 $3$ 除余 $0, 1, 2$ 的数。显然，我们可以选取 $a$ 中所有的数，而对于 $b$ 和 $c$ 中的数，我们需要根据不同的情况选取不同数量的数。

假设我们在 $b$ 中选取了 $\textit{cnt}_b$ 个数，$c$ 中选取了 $\textit{cnt}_c$ 个数，那么这些数的和被 $3$ 除的余数为：

$$
(\textit{cnt}_b + 2 \times \textit{cnt}_c) \bmod 3 = (\textit{cnt}_b - \textit{cnt}_c) \bmod 3
$$

我们希望上式的值为 $0$，那么 $\textit{cnt}_b$ 和 $\textit{cnt}_c$ 模 $3$ 同余。并且我们可以发现，$\textit{cnt}_b$ 一定至少为 $|b| - 2$，其中 $|b|$ 是数组 $b$ 中的元素个数。这是因为如果 $\textit{cnt}_b \leq |b| - 3$，我们可以继续在 $b$ 中选择 $3$ 个数，使得 $\textit{cnt}_b$ 和 $\textit{cnt}_c$ 仍然模 $3$ 同余。同理，$\textit{cnt}_c$ 一定至少为 $|c| - 2$。

因此，$\textit{cnt}_b$ 的选择范围一定在 $\{ |b|-2, |b|-1, |b| \}$ 中，$\textit{cnt}_c$ 的选择范围一定在 $\{ |c|-2, |c|-1, |c| \}$ 中。我们只需要使用两重循环，枚举最多 $3 \times 3 = 9$ 种情况。在从 $b$ 或 $c$ 中选取数时，我们可以贪心地从大到小选取数，因此需要对 $b$ 和 $c$ 进行排序。

```C++ [sol1-C++]
class Solution {
public:
    int maxSumDivThree(vector<int>& nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        vector<int> v[3];
        for (int num: nums) {
            v[num % 3].push_back(num);
        }
        sort(v[1].begin(), v[1].end(), greater<int>());
        sort(v[2].begin(), v[2].end(), greater<int>());

        int ans = 0;
        int lb = v[1].size(), lc = v[2].size();
        for (int cntb = lb - 2; cntb <= lb; ++cntb) {
            if (cntb >= 0) {
                for (int cntc = lc - 2; cntc <= lc; ++cntc) {
                    if (cntc >= 0 && (cntb - cntc) % 3 == 0) {
                        ans = max(ans, accumulate(v[1].begin(), v[1].begin() + cntb, 0) + accumulate(v[2].begin(), v[2].begin() + cntc, 0));
                    }
                }
            }
        }
        return ans + accumulate(v[0].begin(), v[0].end(), 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSumDivThree(int[] nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        List<Integer>[] v = new List[3];
        for (int i = 0; i < 3; ++i) {
            v[i] = new ArrayList<Integer>();
        }
        for (int num : nums) {
            v[num % 3].add(num);
        }
        Collections.sort(v[1], (a, b) -> b - a);
        Collections.sort(v[2], (a, b) -> b - a);

        int ans = 0;
        int lb = v[1].size(), lc = v[2].size();
        for (int cntb = lb - 2; cntb <= lb; ++cntb) {
            if (cntb >= 0) {
                for (int cntc = lc - 2; cntc <= lc; ++cntc) {
                    if (cntc >= 0 && (cntb - cntc) % 3 == 0) {
                        ans = Math.max(ans, getSum(v[1], 0, cntb) + getSum(v[2], 0, cntc));
                    }
                }
            }
        }
        return ans + getSum(v[0], 0, v[0].size());
    }

    public int getSum(List<Integer> list, int start, int end) {
        int sum = 0;
        for (int i = start; i < end; ++i) {
            sum += list.get(i);
        }
        return sum;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxSumDivThree(int[] nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        IList<int>[] v = new IList<int>[3];
        for (int i = 0; i < 3; ++i) {
            v[i] = new List<int>();
        }
        foreach (int num in nums) {
            v[num % 3].Add(num);
        }
        ((List<int>) v[1]).Sort((a, b) => b - a);
        ((List<int>) v[2]).Sort((a, b) => b - a);

        int ans = 0;
        int lb = v[1].Count, lc = v[2].Count;
        for (int cntb = lb - 2; cntb <= lb; ++cntb) {
            if (cntb >= 0) {
                for (int cntc = lc - 2; cntc <= lc; ++cntc) {
                    if (cntc >= 0 && (cntb - cntc) % 3 == 0) {
                        ans = Math.Max(ans, GetSum(v[1], 0, cntb) + GetSum(v[2], 0, cntc));
                    }
                }
            }
        }
        return ans + GetSum(v[0], 0, v[0].Count);
    }

    public int GetSum(IList<int> list, int start, int end) {
        int sum = 0;
        for (int i = start; i < end; ++i) {
            sum += list[i];
        }
        return sum;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxSumDivThree(self, nums: List[int]) -> int:
        a = [x for x in nums if x % 3 == 0]
        b = sorted([x for x in nums if x % 3 == 1], reverse=True)
        c = sorted([x for x in nums if x % 3 == 2], reverse=True)

        ans = 0
        lb, lc = len(b), len(c)
        for cntb in [lb - 2, lb - 1, lb]:
            if cntb >= 0:
                for cntc in [lc - 2, lc - 1, lc]:
                    if cntc >= 0 and (cntb - cntc) % 3 == 0:
                        ans = max(ans, sum(b[:cntb]) + sum(c[:cntc]))
        return ans + sum(a)
```

```Golang [sol1-Golang]
func accumulate(v []int) int {
    ans := 0
    for _, x := range v {
        ans += x
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func maxSumDivThree(nums []int) int {
    // 使用 v[0], v[1], v[2] 分别表示 a, b, c
    v := make([][]int, 3)
    for _, num := range nums {
        v[num % 3] = append(v[num % 3], num)
    }
    sort.Slice(v[1], func(i, j int) bool {
        return v[1][i] > v[1][j]
    })
    sort.Slice(v[2], func(i, j int) bool {
        return v[2][i] > v[2][j]
    })
    ans, lb, lc := 0, len(v[1]), len(v[2])
    for cntb := max(lb - 2, 0); cntb <= lb; cntb++ {
        for cntc := max(lc - 2, 0); cntc <= lc; cntc++ {
            if (cntb - cntc) % 3 == 0 {
                ans = max(ans, accumulate(v[1][:cntb]) + accumulate(v[2][:cntc]))
            }
        }
    }
    return ans + accumulate(v[0])
}
```

```C [sol1-C]
static int cmp(const void *a, const void *b) {
    return *(int *)b - *(int *)a;
}

int maxSumDivThree(int* nums, int numsSize) {
    // 使用 v[0], v[1], v[2] 分别表示 a, b, c
    int n = numsSize;
    int v[3][n];
    int vColSize[3];
    memset(vColSize, 0, sizeof(vColSize));
    for (int i = 0; i < numsSize; i++) {
        v[nums[i] % 3][vColSize[nums[i] % 3]++] = nums[i];
    }
    qsort(v[1], vColSize[1], sizeof(int), cmp);
    qsort(v[2], vColSize[2], sizeof(int), cmp);

    int ans = 0;
    int lb = vColSize[1], lc = vColSize[2];
    for (int cntb = lb - 2; cntb <= lb; ++cntb) {
        if (cntb >= 0) {
            for (int cntc = lc - 2; cntc <= lc; ++cntc) {
                if (cntc >= 0 && (cntb - cntc) % 3 == 0) {
                    int sum1 = 0, sum2 = 0;
                    for (int i = 0; i < cntb; i++) {
                        sum1 += v[1][i];
                    }
                    for (int i = 0; i < cntc; i++) {
                        sum2 += v[2][i];
                    }
                    ans = fmax(ans, sum1 + sum2);
                }
            }
        }
    }
    for (int i = 0; i < vColSize[0]; i++) {
        ans += v[0][i];
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maxSumDivThree = function(nums) {
    const v = [[], [], []];
    for (const num of nums) {
        v[num % 3].push(num);
    }
    v[1].sort((a, b) => b - a);
    v[2].sort((a, b) => b - a);

    let ans = 0;
    const lb = v[1].length;
    const lc = v[2].length;
    for (let cntb = lb - 2; cntb <= lb; ++cntb) {
        if (cntb >= 0) {
            for (let cntc = lc - 2; cntc <= lc; ++cntc) {
                if (cntc >= 0 && (cntb - cntc) % 3 === 0) {
                    ans = Math.max(ans, getSum(v[1], 0, cntb) + getSum(v[2], 0, cntc));
                }
            }
        }
    }
    return ans + getSum(v[0], 0, v[0].length);
}

const getSum = (list, start, end) => {
    let sum = 0;
    for (let i = start; i < end; ++i) {
        sum += list[i];
    }
    return sum;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。对 $b$ 和 $c$ 进行排序需要 $O(n \log n)$ 的时间。两重循环枚举的 $9$ 种情况可以看作常数，每一种情况需要 $O(n)$ 的时间进行求和。

- 空间复杂度：$O(n)$，即为 $a,b,c$ 需要使用的空间。

#### 方法二：贪心 + 逆向思维

在方法一中，我们使用的是「正向思维」，即枚举 $b$ 和 $c$ 中分别选出了多少个数。我们同样也可以使用「逆向思维」，枚举 $b$ 和 $c$ 中分别丢弃了多少个数。

设 $\textit{tot}$ 是数组 $\textit{nums}$ 中所有元素的和，此时 $\textit{tot}$ 会有三种情况：

- 如果 $\textit{tot}$ 是 $3$ 的倍数，那么我们不需要丢弃任何数；

- 如果 $\textit{tot}$ 模 $3$ 余 $1$，此时我们有两种选择：要么丢弃 $b$ 中最小的 $1$ 个数，要么丢弃 $c$ 中最小的 $2$ 个数；

- 如果 $\textit{tot}$ 模 $3$ 余 $2$，此时我们有两种选择：要么丢弃 $b$ 中最小的 $2$ 个数，要么丢弃 $c$ 中最小的 $1$ 个数。

我们同样可以对 $b$ 和 $c$ 进行排序，根据 $\textit{tot}$ 的情况来选出 $b$ 或 $c$ 中最小的 $1$ 或 $2$ 个数。

下面的代码中使用的是排序的方法。

```C++ [sol2-C++]
class Solution {
public:
    int maxSumDivThree(vector<int>& nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        vector<int> v[3];
        for (int num: nums) {
            v[num % 3].push_back(num);
        }
        sort(v[1].begin(), v[1].end(), greater<int>());
        sort(v[2].begin(), v[2].end(), greater<int>());
        int tot = accumulate(nums.begin(), nums.end(), 0);
        int remove = INT_MAX;

        if (tot % 3 == 0) {
            remove = 0;
        }
        else if (tot % 3 == 1) {
            if (v[1].size() >= 1) {
                remove = min(remove, v[1].end()[-1]);
            }
            if (v[2].size() >= 2) {
                remove = min(remove, v[2].end()[-2] + v[2].end()[-1]);
            }
        }
        else {
            if (v[1].size() >= 2) {
                remove = min(remove, v[1].end()[-2] + v[1].end()[-1]);
            }
            if (v[2].size() >= 1) {
                remove = min(remove, v[2].end()[-1]);
            }
        }

        return tot - remove;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxSumDivThree(int[] nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        List<Integer>[] v = new List[3];
        for (int i = 0; i < 3; ++i) {
            v[i] = new ArrayList<Integer>();
        }
        for (int num : nums) {
            v[num % 3].add(num);
        }
        Collections.sort(v[1], (a, b) -> b - a);
        Collections.sort(v[2], (a, b) -> b - a);

        int tot = Arrays.stream(nums).sum();
        int remove = Integer.MAX_VALUE;

        if (tot % 3 == 0) {
            remove = 0;
        } else if (tot % 3 == 1) {
            if (v[1].size() >= 1) {
                remove = Math.min(remove, v[1].get(v[1].size() - 1));
            }
            if (v[2].size() >= 2) {
                remove = Math.min(remove, v[2].get(v[2].size() - 2) + v[2].get(v[2].size() - 1));
            }
        } else {
            if (v[1].size() >= 2) {
                remove = Math.min(remove, v[1].get(v[1].size() - 2) + v[1].get(v[1].size() - 1));
            }
            if (v[2].size() >= 1) {
                remove = Math.min(remove, v[2].get(v[2].size() - 1));
            }
        }

        return tot - remove;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxSumDivThree(int[] nums) {
        // 使用 v[0], v[1], v[2] 分别表示 a, b, c
        IList<int>[] v = new IList<int>[3];
        for (int i = 0; i < 3; ++i) {
            v[i] = new List<int>();
        }
        foreach (int num in nums) {
            v[num % 3].Add(num);
        }
        ((List<int>) v[1]).Sort((a, b) => b - a);
        ((List<int>) v[2]).Sort((a, b) => b - a);

        int tot = nums.Sum();
        int remove = int.MaxValue;

        if (tot % 3 == 0) {
            remove = 0;
        } else if (tot % 3 == 1) {
            if (v[1].Count >= 1) {
                remove = Math.Min(remove, v[1][v[1].Count - 1]);
            }
            if (v[2].Count >= 2) {
                remove = Math.Min(remove, v[2][v[2].Count - 2] + v[2][v[2].Count - 1]);
            }
        } else {
            if (v[1].Count >= 2) {
                remove = Math.Min(remove, v[1][v[1].Count - 2] + v[1][v[1].Count - 1]);
            }
            if (v[2].Count >= 1) {
                remove = Math.Min(remove, v[2][v[2].Count - 1]);
            }
        }

        return tot - remove;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxSumDivThree(self, nums: List[int]) -> int:
        a = [x for x in nums if x % 3 == 0]
        b = sorted([x for x in nums if x % 3 == 1], reverse=True)
        c = sorted([x for x in nums if x % 3 == 2], reverse=True)
        tot, remove = sum(nums), float("inf")

        if tot % 3 == 0:
            remove = 0
        elif tot % 3 == 1:
            if len(b) >= 1:
                remove = min(remove, b[-1])
            if len(c) >= 2:
                remove = min(remove, c[-2] + c[-1])
        else:
            if len(b) >= 2:
                remove = min(remove, b[-2] + b[-1])
            if len(c) >= 1:
                remove = min(remove, c[-1])
        
        return tot - remove
```

```Golang [sol2-Golang]
func accumulate(v []int) int {
    ans := 0
    for _, x := range v {
        ans += x
    }
    return ans
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func maxSumDivThree(nums []int) int {
    // 使用 v[0], v[1], v[2] 分别表示 a, b, c
    v := make([][]int, 3)
    for _, num := range nums {
        v[num % 3] = append(v[num % 3], num)
    }
    sort.Slice(v[1], func(i, j int) bool {
        return v[1][i] > v[1][j]
    })
    sort.Slice(v[2], func(i, j int) bool {
        return v[2][i] > v[2][j]
    })
    tot, remove := accumulate(nums), 0x3f3f3f3f
    if tot % 3 == 0 {
        remove = 0
    } else if tot % 3 == 1 {
        if len(v[1]) >= 1 {
            remove = min(remove, v[1][len(v[1]) - 1])
        }
        if len(v[2]) >= 2 {
            remove = min(remove, v[2][len(v[2]) - 2] + v[2][len(v[2]) - 1])
        }
    } else {
        if len(v[1]) >= 2 {
            remove = min(remove, v[1][len(v[1]) - 2] + v[1][len(v[1]) - 1])
        }
        if len(v[2]) >= 1 {
            remove = min(remove, v[2][len(v[2]) - 1])
        }
    }
    return tot - remove
}
```

```C [sol2-C]
static int cmp(const void *a, const void *b) {
    return *(int *)b - *(int *)a;
}

int maxSumDivThree(int* nums, int numsSize) {
    // 使用 v[0], v[1], v[2] 分别表示 a, b, c
    int n = numsSize;
    int v[3][n];
    int vColSize[3];
    memset(vColSize, 0, sizeof(vColSize));
    for (int i = 0; i < numsSize; i++) {
        v[nums[i] % 3][vColSize[nums[i] % 3]++] = nums[i];
    }
    qsort(v[1], vColSize[1], sizeof(int), cmp);
    qsort(v[2], vColSize[2], sizeof(int), cmp);
    int tot = 0, remove = INT_MAX;
    for (int i = 0; i < numsSize; i++) {
        tot += nums[i];
    }

    if (tot % 3 == 0) {
            remove = 0;
    } else if (tot % 3 == 1) {
        if (vColSize[1] >= 1) {
            remove = fmin(remove, v[1][vColSize[1] - 1]);
        }
        if (vColSize[2] >= 2) {
            remove = fmin(remove, v[2][vColSize[2] - 2] + v[2][vColSize[2] - 1]);
        }
    } else {
        if (vColSize[1] >= 2) {
            remove = fmin(remove, v[1][vColSize[1] - 2] + v[1][vColSize[1] - 1]);
        }
        if (vColSize[2] >= 1) {
            remove = fmin(remove, v[2][vColSize[2] - 1]);
        }
    }

    return tot - remove;
}
```

```JavaScript [sol2-JavaScript]
var maxSumDivThree = function(nums) {
    const v = [[], [], []];
    for (const num of nums) {
        v[num % 3].push(num);
    }
    v[1].sort((a, b) => b - a);
    v[2].sort((a, b) => b - a);

    const tot = nums.reduce((sum, num) => sum + num, 0);
    let remove = Infinity;

    if (tot % 3 === 0) {
        remove = 0;
    } else if (tot % 3 === 1) {
        if (v[1].length >= 1) {
            remove = Math.min(remove, v[1][v[1].length - 1]);
        }
        if (v[2].length >= 2) {
            remove = Math.min(remove, v[2][v[2].length - 2] + v[2][v[2].length - 1]);
        }
    } else {
        if (v[1].length >= 2) {
            remove = Math.min(remove, v[1][v[1].length - 2] + v[1][v[1].length - 1]);
        }
        if (v[2].length >= 1) {
            remove = Math.min(remove, v[2][v[2].length - 1]);
        }
    }

    return tot - remove;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。对 $b$ 和 $c$ 进行排序需要 $O(n \log n)$ 的时间。也可以不用排序，将时间复杂度优化至 $O(n)$。

- 空间复杂度：$O(n)$，即为 $a,b,c$ 需要使用的空间。如果不排序，可以不显示将 $a,b,c$ 求出来，而是直接对数组 $\textit{nums}$ 进行一次遍历，找出模 $3$ 余 $1$ 和 $2$ 的最小的两个数，将空间复杂度优化至 $O(1)$。

#### 方法三：动态规划

在上面的两种方法中，我们都是基于贪心的思路，要么选择若干个较大的数，要么丢弃若干个较小的数。我们也可以使用动态规划的方法，不需要进行排序或者贪心，直接借助状态转移方程得出解。

记 $f(i, j)$ 表示前 $i~(i \geq 1)$ 个数中选取了若干个数，并且它们的和模 $3$ 余 $j~(0 \leq j < 3)$ 时，这些数的和的最大值。那么对于当前的数 $\textit{nums}[i]$，如果我们选取它，那么就可以通过 $f(i-1, (j-\textit{nums}[i]) \bmod 3)$ 转移得来；如果我们不选取它，就可以通过 $f(i-1, j)$ 转移得来。因此我们可以写出如下的状态转移方程：

$$
f(i, j) = \max\big\{ f(i-1, j), f(i-1, (j-\textit{nums}[i]) \bmod 3) + \textit{nums}[i] \big\}
$$

边界条件为 $f(0, 0) = 0$ 以及 $f(0, 1) = f(0, 2) = -\infty$。表示当我们没有选取任何数时，和为 $0$，并且模 $3$ 的余数为 $0$。对于 $f(0, 1)$ 和 $f(0, 2)$ 这两种不合法的状态，由于我们在状态转移中维护的是最大值，因此可以把它们设定成一个极小值。

在某些语言中，$(j-\textit{nums}[i]) \bmod 3$ 可能会引入负数，因此这道题用递推的形式来实现动态规划较为方便，即：

$$
\begin{cases}
f(i-1, j) \to f(i, j) \\
f(i-1, j) + \textit{nums}[i] \to f(i, (j + \textit{nums}[i]) \bmod 3)
\end{cases}
$$

我们还可以发现，所有的 $f(i, \cdots)$ 只会从 $f(i-1, \cdots)$ 转移得来，因此在动态规划时只需要存储当前第 $i$ 行以及上一行第 $i-1$ 行的结果，减少空间复杂度。

```C++ [sol3-C++]
class Solution {
public:
    int maxSumDivThree(vector<int>& nums) {
        vector<int> f = {0, INT_MIN, INT_MIN};
        for (int num: nums) {
            vector<int> g = f;
            for (int i = 0; i < 3; ++i) {
                g[(i + num % 3) % 3] = max(g[(i + num % 3) % 3], f[i] + num);
            }
            f = move(g);
        }
        return f[0];
    }
};
```

```Java [sol3-Java]
class Solution {
    public int maxSumDivThree(int[] nums) {
        int[] f = {0, Integer.MIN_VALUE, Integer.MIN_VALUE};
        for (int num : nums) {
            int[] g = new int[3];
            System.arraycopy(f, 0, g, 0, 3);
            for (int i = 0; i < 3; ++i) {
                g[(i + num % 3) % 3] = Math.max(g[(i + num % 3) % 3], f[i] + num);
            }
            f = g;
        }
        return f[0];
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int MaxSumDivThree(int[] nums) {
        int[] f = {0, int.MinValue, int.MinValue};
        foreach (int num in nums) {
            int[] g = new int[3];
            Array.Copy(f, 0, g, 0, 3);
            for (int i = 0; i < 3; ++i) {
                g[(i + num % 3) % 3] = Math.Max(g[(i + num % 3) % 3], f[i] + num);
            }
            f = g;
        }
        return f[0];
    }
}
```

```Python [sol3-Python3]
class Solution:
    def maxSumDivThree(self, nums: List[int]) -> int:
        f = [0, -float("inf"), -float("inf")]
        for num in nums:
            g = f[:]
            for i in range(3):
                g[(i + num % 3) % 3] = max(g[(i + num % 3) % 3], f[i] + num)
            f = g
        return f[0]
```

```Golang [sol3-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func maxSumDivThree(nums []int) int {
    f := []int{0, -0x3f3f3f3f, -0x3f3f3f3f}
    for _, num := range nums {
        g := make([]int, 3)
        for i := 0; i < 3; i++ {
            g[(i + num) % 3] = max(f[(i + num) % 3], f[i] + num)
        }
        f = g
    }
    return f[0]
}
```

```C [sol3-C]
int maxSumDivThree(int* nums, int numsSize) {
    int f[3] = {0, INT_MIN, INT_MIN};
    int g[3] = {0};
    for (int j = 0; j < numsSize; j++) {
        memcpy(g, f, sizeof(f));
        for (int i = 0; i < 3; i++) {
            g[(i + nums[j] % 3) % 3] = fmax(g[(i + nums[j] % 3) % 3], f[i] + nums[j]);
        }
        memcpy(f, g, sizeof(f));
    }
    return f[0];
}
```

```JavaScript [sol3-JavaScript]
var maxSumDivThree = function(nums) {
    let f = [0, Number.MIN_SAFE_INTEGER, Number.MIN_SAFE_INTEGER];
    for (const num of nums) {
        const g = [...f];
        for (let i = 0; i < 3; ++i) {
            g[(i + num % 3) % 3] = Math.max(g[(i + num % 3) % 3], f[i] + num);
        }
        f = g;
    }
    return f[0];
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。