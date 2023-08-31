## [1051.高度检查器 中文官方题解](https://leetcode.cn/problems/height-checker/solutions/100000/gao-du-jian-cha-qi-by-leetcode-solution-jeb0)

#### 方法一：基于比较的排序

**思路与算法**

我们可以直接将数组 $\textit{heights}$ 复制一份（记为 $\textit{expected}$），并对数组 $\textit{expected}$ 进行排序。

待排序完成后，我们统计 $\textit{heights}[i] \neq \textit{expected}[i]$ 的下标数量即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int heightChecker(vector<int>& heights) {
        vector<int> expected(heights);
        sort(expected.begin(), expected.end());
        int n = heights.size(), ans = 0;
        for (int i = 0; i < n; ++i) {
            if (heights[i] != expected[i]) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int heightChecker(int[] heights) {
        int n = heights.length, ans = 0;
        int[] expected = new int[n];
        System.arraycopy(heights, 0, expected, 0, n);
        Arrays.sort(expected);
        for (int i = 0; i < n; ++i) {
            if (heights[i] != expected[i]) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int HeightChecker(int[] heights) {
        int n = heights.Length, ans = 0;
        int[] expected = new int[n];
        Array.Copy(heights, 0, expected, 0, n);
        Array.Sort(expected);
        for (int i = 0; i < n; ++i) {
            if (heights[i] != expected[i]) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def heightChecker(self, heights: List[int]) -> int:
        expected = sorted(heights)
        return sum(1 for x, y in zip(heights, expected) if x != y)
```

```C [sol1-C]
static inline cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int heightChecker(int* heights, int heightsSize) {
    int *expected = (int *)malloc(sizeof(int) * heightsSize);
    memcpy(expected, heights, sizeof(int) * heightsSize);
    qsort(expected, heightsSize, sizeof(int), cmp);
    int ans = 0;
    for (int i = 0; i < heightsSize; ++i) {
        if (heights[i] != expected[i]) {
            ++ans;
        }
    }
    free(expected);
    return ans;
}
```

```go [sol1-Golang]
func heightChecker(heights []int) (ans int) {
    sorted := append([]int{}, heights...)
    sort.Ints(sorted)
    for i, v := range heights {
        if v != sorted[i] {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var heightChecker = function(heights) {
    let n = heights.length, ans = 0;
    const expected = new Array(n).fill(0);
    expected.splice(0, n, ...heights);
    expected.sort((a, b) => a - b);
    for (let i = 0; i < n; ++i) {
        if (heights[i] !== expected[i]) {
            ++ans;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{heights}$ 的长度。即为排序需要的时间。

- 空间复杂度：$O(n)$，即为数组 $\textit{expected}$ 需要的空间。

#### 方法二：计数排序

**思路与算法**

注意到本题中学生的高度小于等于 $100$，因此可以使用计数排序。

**细节**

在进行计数排序时，我们可以直接使用一个长度为 $101$ 的数组，也可以先对数组 $\textit{heights}$ 进行一次遍历，找出最大值 $m$，从而使用一个长度为 $m+1$ 的数组。

当计数排序完成后，我们可以再使用一个长度为 $n$ 的数组，显式地存储排序后的结果。为了节省空间，我们也直接在计数排序的数组上进行遍历，具体可以参考下面的代码。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int heightChecker(vector<int>& heights) {
        int m = *max_element(heights.begin(), heights.end());
        vector<int> cnt(m + 1);
        for (int h: heights) {
            ++cnt[h];
        }

        int idx = 0, ans = 0;
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= cnt[i]; ++j) {
                if (heights[idx] != i) {
                    ++ans;
                }
                ++idx;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int heightChecker(int[] heights) {
        int m = Arrays.stream(heights).max().getAsInt();
        int[] cnt = new int[m + 1];
        for (int h : heights) {
            ++cnt[h];
        }

        int idx = 0, ans = 0;
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= cnt[i]; ++j) {
                if (heights[idx] != i) {
                    ++ans;
                }
                ++idx;
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int HeightChecker(int[] heights) {
        int m = heights.Max();
        int[] cnt = new int[m + 1];
        foreach (int h in heights) {
            ++cnt[h];
        }

        int idx = 0, ans = 0;
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= cnt[i]; ++j) {
                if (heights[idx] != i) {
                    ++ans;
                }
                ++idx;
            }
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def heightChecker(self, heights: List[int]) -> int:
        m = max(heights)
        cnt = [0] * (m + 1)

        for h in heights:
            cnt[h] += 1
        
        idx = ans = 0
        for i in range(1, m + 1):
            for j in range(cnt[i]):
                if heights[idx] != i:
                    ans += 1
                idx += 1
        
        return ans
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int heightChecker(int* heights, int heightsSize) {
    int m = 0;
    for (int i = 0; i < heightsSize; i++) {
        m = MAX(m, heights[i]);
    }
    int *cnt = (int *)malloc(sizeof(int) * (m + 1));
    memset(cnt, 0, sizeof(int) * (m + 1));
    for (int i = 0; i < heightsSize; i++) {
        ++cnt[heights[i]];
    }
    int idx = 0, ans = 0;
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= cnt[i]; ++j) {
            if (heights[idx] != i) {
                ++ans;
            }
            ++idx;
        }
    }
    free(cnt);
    return ans;
}
```

```go [sol2-Golang]
func heightChecker(heights []int) (ans int) {
    cnt := [101]int{}
    for _, v := range heights {
        cnt[v]++
    }

    idx := 0
    for i, c := range cnt {
        for ; c > 0; c-- {
            if heights[idx] != i {
                ans++
            }
            idx++
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var heightChecker = function(heights) {
    const m = parseInt(_.max(heights));
    const cnt = new Array(m + 1).fill(0);
    for (const h of heights) {
        ++cnt[h];
    }

    let idx = 0, ans = 0;
    for (let i = 1; i <= m; ++i) {
        for (let j = 1; j <= cnt[i]; ++j) {
            if (heights[idx] !== i) {
                ++ans;
            }
            ++idx;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $n$ 是数组 $\textit{heights}$ 的长度，$C$ 是数组 $\textit{heights}$ 中的最大值。即为计数排序需要的时间。

- 空间复杂度：$O(C)$，即为计数排序需要的空间。