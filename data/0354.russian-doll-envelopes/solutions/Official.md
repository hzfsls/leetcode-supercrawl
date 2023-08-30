#### 前言

根据题目的要求，如果我们选择了 $k$ 个信封，它们的的宽度依次为 $w_0, w_1, \cdots, w_{k-1}$，高度依次为 $h_0, h_1, \cdots, h_{k-1}$，那么需要满足：

$$
\begin{cases}
w_0 < w_1 < \cdots < w_{k-1} \\
h_0 < h_1 < \cdots < h_{k-1}
\end{cases}
$$

同时控制 $w$ 和 $h$ 两个维度并不是那么容易，因此我们考虑固定一个维度，再在另一个维度上进行选择。例如，我们固定 $w$ 维度，那么我们将数组 $\textit{envelopes}$ 中的所有信封按照 $w$ 升序排序。这样一来，我们只要按照信封在数组中的出现顺序依次进行选取，就一定保证满足：

$$
w_0 \leq w_1 \leq \cdots \leq w_{k-1}
$$

了。然而小于等于 $\leq$ 和小于 $<$ 还是有区别的，但我们不妨首先考虑一个简化版本的问题：

> 如果我们保证所有信封的 $w$ 值互不相同，那么我们可以设计出一种得到答案的方法吗？

在 $w$ 值互不相同的前提下，小于等于 $\leq$ 和小于 $<$ 是等价的，那么我们在排序后，就可以**完全忽略** $w$ 维度，只需要考虑 $h$ 维度了。此时，我们需要解决的问题即为：

> 给定一个序列，我们需要找到一个最长的子序列，使得这个子序列中的元素严格单调递增，即上面要求的：
>   $$
>   h_0 < h_1 < \cdots < h_{k-1}
>   $$

那么这个问题就是经典的「最长严格递增子序列」问题了，读者可以参考力扣平台的 [300. 最长递增子序列](https://leetcode-cn.com/problems/longest-increasing-subsequence/) 及其 [官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)。最长严格递增子序列的详细解决方法属于解决本题的前置知识点，不是本文分析的重点，因此这里不再赘述，会在方法一和方法二中简单提及。

当我们解决了简化版本的问题之后，我们来想一想使用上面的方法解决原问题，会产生什么错误。当 $w$ 值相同时，如果我们不规定 $h$ 值的排序顺序，那么可能会有如下的情况：

> 排完序的结果为 $[(w, h)] = [(1, 1), (1, 2), (1, 3), (1, 4)]$，由于这些信封的 $w$ 值都相同，不存在一个信封可以装下另一个信封，那么我们只能在其中选择 $1$ 个信封。然而如果我们完全忽略 $w$ 维度，剩下的 $h$ 维度为 $[1, 2, 3, 4]$，这是一个严格递增的序列，那么我们就可以选择所有的 $4$ 个信封了，这就产生了错误。

因此，我们必须要保证**对于每一种 $w$ 值，我们最多只能选择 $1$ 个信封**。

我们可以将 $h$ 值作为排序的第二关键字进行降序排序，这样一来，对于每一种 $w$ 值，其对应的信封在排序后的数组中是按照 $h$ 值递减的顺序出现的，那么**这些 $h$ 值不可能组成长度超过 $1$ 的严格递增的序列**，这就从根本上杜绝了错误的出现。

因此我们就可以得到解决本题需要的方法：

- 首先我们将所有的信封按照 $w$ 值第一关键字升序、$h$ 值第二关键字降序进行排序；

- 随后我们就可以忽略 $w$ 维度，求出 $h$ 维度的最长严格递增子序列，其长度即为答案。

下面简单提及两种计算最长严格递增子序列的方法，更详细的请参考上文提到的题目以及对应的官方题解。

#### 方法一：动态规划

**思路与算法**

设 $f[i]$ 表示 $h$ 的前 $i$ 个元素可以组成的最长严格递增子序列的长度，并且我们必须选择第 $i$ 个元素 $h_i$。在进行状态转移时，我们可以考虑倒数第二个选择的元素 $h_j$，必须满足 $h_j < h_i$ 且 $j < i$，因此可以写出状态转移方程：

$$
f[i] = \max_{j<i ~\wedge~ h_j<h_i } \{ f[j] \} + 1
$$

如果不存在比 $h_i$ 小的元素 $h_j$，那么 $f[i]$ 的值为 $1$，即只选择了唯一的第 $i$ 个元素。

在计算完所有的 $f$ 值之后，其中的最大值即为最长严格递增子序列的长度。

**代码**

由于方法一的时间复杂度较高，一些语言对应的代码可能会超出时间限制。

```C++ [sol1-C++]
class Solution {
public:
    int maxEnvelopes(vector<vector<int>>& envelopes) {
        if (envelopes.empty()) {
            return 0;
        }
        
        int n = envelopes.size();
        sort(envelopes.begin(), envelopes.end(), [](const auto& e1, const auto& e2) {
            return e1[0] < e2[0] || (e1[0] == e2[0] && e1[1] > e2[1]);
        });

        vector<int> f(n, 1);
        for (int i = 1; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                if (envelopes[j][1] < envelopes[i][1]) {
                    f[i] = max(f[i], f[j] + 1);
                }
            }
        }
        return *max_element(f.begin(), f.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxEnvelopes(int[][] envelopes) {
        if (envelopes.length == 0) {
            return 0;
        }
        
        int n = envelopes.length;
        Arrays.sort(envelopes, new Comparator<int[]>() {
            public int compare(int[] e1, int[] e2) {
                if (e1[0] != e2[0]) {
                    return e1[0] - e2[0];
                } else {
                    return e2[1] - e1[1];
                }
            }
        });

        int[] f = new int[n];
        Arrays.fill(f, 1);
        int ans = 1;
        for (int i = 1; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                if (envelopes[j][1] < envelopes[i][1]) {
                    f[i] = Math.max(f[i], f[j] + 1);
                }
            }
            ans = Math.max(ans, f[i]);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxEnvelopes(self, envelopes: List[List[int]]) -> int:
        if not envelopes:
            return 0
        
        n = len(envelopes)
        envelopes.sort(key=lambda x: (x[0], -x[1]))

        f = [1] * n
        for i in range(n):
            for j in range(i):
                if envelopes[j][1] < envelopes[i][1]:
                    f[i] = max(f[i], f[j] + 1)
        
        return max(f)
```

```JavaScript [sol1-JavaScript]
var maxEnvelopes = function(envelopes) {
    if (envelopes.length === 0) {
        return 0;
    }
    
    const n = envelopes.length;
    envelopes.sort((e1, e2) => {
        if (e1[0] !== e2[0]) {
            return e1[0] - e2[0];
        } else {
            return e2[1] - e1[1];
        }
    })

    const f = new Array(n).fill(1);
    let ans = 1;
    for (let i = 1; i < n; ++i) {
        for (let j = 0; j < i; ++j) {
            if (envelopes[j][1] < envelopes[i][1]) {
                f[i] = Math.max(f[i], f[j] + 1);
            }
        }
        ans = Math.max(ans, f[i]);
    }
    return ans;
};
```

```go [sol1-Golang]
func maxEnvelopes(envelopes [][]int) int {
    n := len(envelopes)
    if n == 0 {
        return 0
    }

    sort.Slice(envelopes, func(i, j int) bool {
        a, b := envelopes[i], envelopes[j]
        return a[0] < b[0] || a[0] == b[0] && a[1] > b[1]
    })

    f := make([]int, n)
    for i := range f {
        f[i] = 1
    }
    for i := 1; i < n; i++ {
        for j := 0; j < i; j++ {
            if envelopes[j][1] < envelopes[i][1] {
                f[i] = max(f[i], f[j]+1)
            }
        }
    }
    return max(f...)
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
int cmp(int** a, int** b) {
    return (*a)[0] == (*b)[0] ? (*b)[1] - (*a)[1] : (*a)[0] - (*b)[0];
}

int maxEnvelopes(int** envelopes, int envelopesSize, int* envelopesColSize) {
    if (envelopesSize == 0) {
        return 0;
    }

    qsort(envelopes, envelopesSize, sizeof(int*), cmp);

    int n = envelopesSize;
    int f[n];
    for (int i = 0; i < n; i++) {
        f[i] = 1;
    }
    int ret = 1;
    for (int i = 1; i < n; ++i) {
        for (int j = 0; j < i; ++j) {
            if (envelopes[j][1] < envelopes[i][1]) {
                f[i] = fmax(f[i], f[j] + 1);
            }
        }
        ret = fmax(ret, f[i]);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{envelopes}$ 的长度，排序需要的时间复杂度为 $O(n \log n)$，动态规划需要的时间复杂度为 $O(n^2)$，前者在渐近意义下小于后者，可以忽略。

- 空间复杂度：$O(n)$，即为数组 $f$ 需要的空间。

#### 方法二：基于二分查找的动态规划

**思路与算法**

设 $f[j]$ 表示 $h$ 的前 $i$ 个元素可以组成的长度为 $j$ 的最长严格递增子序列的末尾元素的最小值，如果不存在长度为 $j$ 的最长严格递增子序列，对应的 $f$ 值无定义。在定义范围内，可以看出 $f$ 值是严格单调递增的，因为越长的子序列的末尾元素显然越大。

在进行状态转移时，我们考虑当前的元素 $h_i$：

- 如果 $h_i$ 大于 $f$ 中的最大值，那么 $h_i$ 就可以接在 $f$ 中的最大值之后，形成一个长度更长的严格递增子序列；

- 否则我们找出 $f$ 中比 $h_i$ 严格小的最大的元素 $f[j_0]$，即 $f[j_0] < h_i \leq f[j_0+1]$，那么 $h_i$ 可以接在 $f[j_0]$ 之后，形成一个长度为 $j_0+1$ 的严格递增子序列，因此需要对 $f[j_0+1]$ 进行更新：

    $$
    f[j_0+1] = h_i
    $$

    我们可以在 $f$ 上进行二分查找，找出满足要求的 $j_0$。

在遍历所有的 $h_i$ 之后，$f$ 中最后一个有定义的元素的下标增加 $1$（下标从 $0$ 开始）即为最长严格递增子序列的长度。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maxEnvelopes(vector<vector<int>>& envelopes) {
        if (envelopes.empty()) {
            return 0;
        }
        
        int n = envelopes.size();
        sort(envelopes.begin(), envelopes.end(), [](const auto& e1, const auto& e2) {
            return e1[0] < e2[0] || (e1[0] == e2[0] && e1[1] > e2[1]);
        });

        vector<int> f = {envelopes[0][1]};
        for (int i = 1; i < n; ++i) {
            if (int num = envelopes[i][1]; num > f.back()) {
                f.push_back(num);
            }
            else {
                auto it = lower_bound(f.begin(), f.end(), num);
                *it = num;
            }
        }
        return f.size();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxEnvelopes(int[][] envelopes) {
        if (envelopes.length == 0) {
            return 0;
        }
        
        int n = envelopes.length;
        Arrays.sort(envelopes, new Comparator<int[]>() {
            public int compare(int[] e1, int[] e2) {
                if (e1[0] != e2[0]) {
                    return e1[0] - e2[0];
                } else {
                    return e2[1] - e1[1];
                }
            }
        });

        List<Integer> f = new ArrayList<Integer>();
        f.add(envelopes[0][1]);
        for (int i = 1; i < n; ++i) {
            int num = envelopes[i][1];
            if (num > f.get(f.size() - 1)) {
                f.add(num);
            } else {
                int index = binarySearch(f, num);
                f.set(index, num);
            }
        }
        return f.size();
    }

    public int binarySearch(List<Integer> f, int target) {
        int low = 0, high = f.size() - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (f.get(mid) < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxEnvelopes(self, envelopes: List[List[int]]) -> int:
        if not envelopes:
            return 0
        
        n = len(envelopes)
        envelopes.sort(key=lambda x: (x[0], -x[1]))

        f = [envelopes[0][1]]
        for i in range(1, n):
            if (num := envelopes[i][1]) > f[-1]:
                f.append(num)
            else:
                index = bisect.bisect_left(f, num)
                f[index] = num
        
        return len(f)
```

```JavaScript [sol2-JavaScript]
var maxEnvelopes = function(envelopes) {
    if (envelopes.length === 0) {
        return 0;
    }
    
    const n = envelopes.length;
    envelopes.sort((e1, e2) => {
        if (e1[0] - e2[0]) {
            return e1[0] - e2[0];
        } else {
            return e2[1] - e1[1];
        }
    })

    const f = [envelopes[0][1]];
    for (let i = 1; i < n; ++i) {
        const num = envelopes[i][1];
        if (num > f[f.length - 1]) {
            f.push(num);
        } else {
            const index = binarySearch(f, num);
            f[index] = num;
        }
    }
    return f.length;
}

const binarySearch = (f, target) => {
    let low = 0, high = f.length - 1;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (f[mid] < target) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
};
```

```go [sol2-Golang]
func maxEnvelopes(envelopes [][]int) int {
    sort.Slice(envelopes, func(i, j int) bool {
        a, b := envelopes[i], envelopes[j]
        return a[0] < b[0] || a[0] == b[0] && a[1] > b[1]
    })

    f := []int{}
    for _, e := range envelopes {
        h := e[1]
        if i := sort.SearchInts(f, h); i < len(f) {
            f[i] = h
        } else {
            f = append(f, h)
        }
    }
    return len(f)
}
```

```C [sol2-C]
int cmp(int** a, int** b) {
    return (*a)[0] == (*b)[0] ? (*b)[1] - (*a)[1] : (*a)[0] - (*b)[0];
}

int lower_bound(int* arr, int arrSize, int val) {
    int left = 0, right = arrSize - 1;
    while (left <= right) {
        int mid = (left + right) >> 1;
        if (val < arr[mid]) {
            right = mid - 1;
        } else if (val > arr[mid]) {
            left = mid + 1;
        } else {
            return mid;
        }
    }
    if (arr[left] >= val) {
        return left;
    }
    return -1;
}

int maxEnvelopes(int** envelopes, int envelopesSize, int* envelopesColSize) {
    if (envelopesSize == 0) {
        return 0;
    }

    qsort(envelopes, envelopesSize, sizeof(int*), cmp);

    int n = envelopesSize;
    int f[n], fSize = 0;
    f[fSize++] = envelopes[0][1];
    for (int i = 1; i < n; ++i) {
        int num = envelopes[i][1];
        if (num > f[fSize - 1]) {
            f[fSize++] = num;
        } else {
            f[lower_bound(f, fSize, num)] = num;
        }
    }
    return fSize;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{envelopes}$ 的长度，排序需要的时间复杂度为 $O(n \log n)$，动态规划需要的时间复杂度同样为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为数组 $f$ 需要的空间。