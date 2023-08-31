## [1691.堆叠长方体的最大高度 中文官方题解](https://leetcode.cn/problems/maximum-height-by-stacking-cuboids/solutions/100000/dui-die-chang-fang-ti-de-zui-da-gao-du-b-17qg)
#### 方法一：动态规划

**思路与算法**

由于题目要求长方体的高度最大，由此很容易想到将每个长方体的最长边做为高度是最优的，但这种堆叠方法是否正确需要进一步思考。假设两个长方体 $r_1, r_2$ 的长宽高分别为 $(w_1,l_1,h_1)$ 与 $(w_2,l_2,h_2)$，且满足 $w_1 \le w_2,l_1 \le l_2,h_1 \le h_2$，此时长方体 $r_1$ 一定可以堆叠在长方体 $r_2$ 之上，此时得到的高度为 $h_1 + h_2$。我们将长方体 $r_1, r_2$ 的长宽高按照从小到大的顺序重新进行排列为 $(w_1',l_1',h_1')$ 与 $(w_2',l_2',h_2')$，且满足 $w_1' \le l_1' \le h_1',w_2' \le l_2' \le h_2'$。此时我们只需要证明 $w_1' \le w_2',l_1' \le l_2',h_1' \le h_2'$，即可满足堆叠条件。证明如下：
+ 根据之前的结论可知道 $r_1$ 中的最大值一定小于等于 $r_2$ 中的最大值，$r_1$ 中的最小值一定小于等于 $r_2$ 中的最小值，否则一定不会出现 $w_1 \le w_2,l_1 \le l_2,h_1 \le h_2$，此时一定可以推出 $w_1' \le w_2', h_1' \le h_2'$。此时我们假设 $l_1' > l_2'$，则此时可以推出 $w_1' \le w_2' \le l_2' < l_1' \le w_1' \le w_2'$。按照之前的推论可知 $r_1$ 中一定存在一个元素小于 $w_2'$，存在另外一个元素小于 $l_2'$，而此时小于等于 $w_2',l_2'$ 的元素只有一个，与上述结论相矛盾，因此我们一定可以得出结论 $l_1' \le l_2'$。因此 $w_1' \le w_2',l_1' \le l_2',h_1' \le h_2'$ 结论成立。

当按照长方体的三条边从小到大进行排序后，此时长方体的高度即对应了三条边中的最大值，那么整个长方体的堆叠高度之和一定不会大于每个长方体的最大边之和，因此最优的堆叠方法一定是基于最长边作为高度的。

我们下一步计算整个堆叠高度，我们可以设 $\textit{dp}[i]$ 表示以第 $i$ 个长方体 $(w_i',l_i',h_i')$ 为最后一个长方体的最大堆叠高度，可以使用动态规划并写出状态转移方程：
$$
\textit{dp}[i] = \max_{w_j' \le w_i',l_j' \le l_i',h_j' \le h_i'}\{\textit{dp}[j]\} + h_i'
$$

我们需要找到找到所有可以放置到 $i$ 长方体之上的长方体 $j$，长方体 $j$ 需要满足 $w_j' \le w_i',l_j' \le l_i',h_j' \le h_i'$。如果不存在可以堆叠的长方体，此时 $\textit{dp}[i] = h_i'$，最终最大的堆叠高度即为 $\max (\textit{dp}[i])$。

如果想要实现上述的动态规划，必须保证当枚举到第 $i$ 个长方体时，所有可以堆叠在第 $i$ 个长方体之上的长方体都应该枚举过，因此在动态规划之前，我们应保证所有满足可堆叠在第 $i$ 个长方体之上的长方体排在 $i$ 之前，可以利用排序来解决这个问题。这里有非常多的排序方法，只要保证枚举关系的拓扑性即可，例如我们可以使用关键字 $(w_i',l_i',h_i')$、$(w_i' + l_i' + h_i')$、$(w_i' \times l_i' \times h_i')$ 排序，无论采用何种排序方法只需满足当 $w_j' \le w_i',l_j' \le l_i',h_j' \le h_i'$ 时，一定满足 $j \le i$ 即可。


**代码**

```Python [sol1-Python3]
class Solution:
    def maxHeight(self, cuboids: List[List[int]]) -> int:
        n = len(cuboids)
        for c in cuboids:
            c.sort()
        cuboids.sort(key=sum)
        ans = 0
        dp = [0] * n
        for i in range(n):
            dp[i] = cuboids[i][2]
            for j in range(i):
                if cuboids[i][0] >= cuboids[j][0] and cuboids[i][1] >= cuboids[j][1] and cuboids[i][2] >= cuboids[j][2]:
                    dp[i] = max(dp[i], dp[j] + cuboids[i][2])
            ans = max(ans, dp[i])
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxHeight(vector<vector<int>>& cuboids) {
        int n = cuboids.size();
        for (auto & v : cuboids) {
            sort(v.begin(), v.end());
        }
        sort(cuboids.begin(), cuboids.end(), [](const vector<int> & a,const vector<int> & b) {
            return a[0] + a[1] + a[2] < b[0] + b[1] + b[2];
        });
        int ans = 0;
        vector<int> dp(n);
        for (int i = 0; i < n; i++) {
            dp[i] = cuboids[i][2];
            for (int j = 0; j < i; j++) {
                if (cuboids[i][0] >= cuboids[j][0] && 
                    cuboids[i][1] >= cuboids[j][1] && 
                    cuboids[i][2] >= cuboids[j][2]) {
                    dp[i] = max(dp[i], dp[j] + cuboids[i][2]);
                }
            }
            ans = max(ans, dp[i]);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxHeight(int[][] cuboids) {
        int n = cuboids.length;
        for (int[] v : cuboids) {
            Arrays.sort(v);
        }
        Arrays.sort(cuboids, (a, b) -> (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));
        int ans = 0;
        int[] dp = new int[n];
        for (int i = 0; i < n; i++) {
            dp[i] = cuboids[i][2];
            for (int j = 0; j < i; j++) {
                if (cuboids[i][0] >= cuboids[j][0] && 
                    cuboids[i][1] >= cuboids[j][1] && 
                    cuboids[i][2] >= cuboids[j][2]) {
                    dp[i] = Math.max(dp[i], dp[j] + cuboids[i][2]);
                }
            }
            ans = Math.max(ans, dp[i]);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxHeight(int[][] cuboids) {
        int n = cuboids.Length;
        foreach (int[] v in cuboids) {
            Array.Sort(v);
        }
        Array.Sort(cuboids, (a, b) => (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));
        int ans = 0;
        int[] dp = new int[n];
        for (int i = 0; i < n; i++) {
            dp[i] = cuboids[i][2];
            for (int j = 0; j < i; j++) {
                if (cuboids[i][0] >= cuboids[j][0] && 
                    cuboids[i][1] >= cuboids[j][1] && 
                    cuboids[i][2] >= cuboids[j][2]) {
                    dp[i] = Math.Max(dp[i], dp[j] + cuboids[i][2]);
                }
            }
            ans = Math.Max(ans, dp[i]);
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int cmpKey(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int cmpSum(const void *pa, const void *pb) {
    int *a = *(int **)pa;
    int *b = *(int **)pb;
    return (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]);
}

int maxHeight(int** cuboids, int cuboidsSize, int* cuboidsColSize) {
    for (int i = 0; i < cuboidsSize; i++) {
        qsort(cuboids[i], cuboidsColSize[i], sizeof(int), cmpKey);
    }
    qsort(cuboids, cuboidsSize, sizeof(int *), cmpSum);
    int ans = 0;
    int dp[cuboidsSize];
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i < cuboidsSize; i++) {
        dp[i] = cuboids[i][2];
        for (int j = 0; j < i; j++) {
            if (cuboids[i][0] >= cuboids[j][0] && 
                cuboids[i][1] >= cuboids[j][1] && 
                cuboids[i][2] >= cuboids[j][2]) {
                dp[i] = MAX(dp[i], dp[j] + cuboids[i][2]);
            }
        }
        ans = MAX(ans, dp[i]);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maxHeight = function(cuboids) {
    const n = cuboids.length;
    for (const v of cuboids) {
        v.sort((a, b) => a - b);
    }
    cuboids.sort((a, b) => (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));
    let ans = 0;
    const dp = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        dp[i] = cuboids[i][2];
        for (let j = 0; j < i; j++) {
            if (cuboids[i][0] >= cuboids[j][0] && 
                cuboids[i][1] >= cuboids[j][1] && 
                cuboids[i][2] >= cuboids[j][2]) {
                dp[i] = Math.max(dp[i], dp[j] + cuboids[i][2]);
            }
        }
        ans = Math.max(ans, dp[i]);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示长方体的个数。时间复杂度主要取决于排序与动态规划枚举，对每个长方体边的大小进行排序的总时间复杂度为 $O(n)$，对长方体进行排序的时间为 $O(n \log n)$，对于每个长方体我们都需要枚举所有可以堆叠其上的长方体，需要的时间为 $O(n^2)$，因此总的时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示长方体的个数。排序需要的栈空间为 $O(\log n)$，存储每个长方体为底的最大高度需要的空间为 $O(n)$，因此总的空间复杂度为 $O(n)$。

#### 方法二：记忆化搜索

**思路与算法**

与解法一同样的解题思路，我们还可以采用自顶向下的记忆化搜索，与方法一相比会减少无效状态，设 $\textit{memo}[i]$ 表示第 $i$ 个长方体为顶部长方体的最大高度，我们依次尝试是否可以把当前的第 $i$ 个长方体放置到第 $j$ 个长方体的顶部。则此时我们可以得到递推公式如下:
$$
\textit{memo}[i] = \max_{w_j' \ge w_i',l_j' \ge l_i',h_j' \ge h_i'}\{\textit{memo}[j]\} + h_i'
$$

我们求出以每个长方体为顶部的最大高度即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def maxHeight(self, cuboids: List[List[int]]) -> int:
        def check(a: List[int], b: List[int]) -> bool:
            return a[0] <= b[0] and a[1] <= b[1] and a[2] <= b[2]

        n = len(cuboids)
        for c in cuboids:
            c.sort()
        cuboids.sort(key=sum)

        @cache
        def dfs(top: int, index: int) -> int:
            if index == n:
                return 0
            height = dfs(top, index + 1)
            if top == -1 or check(cuboids[top], cuboids[index]):
                height = max(height, cuboids[index][2] + dfs(index, index + 1))
            return height
        return dfs(-1, 0)
```

```C++ [sol2-C++]
class Solution {
public:
    bool check(const vector<int> &a, const vector<int> &b) {
        return a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2];
    }

    int maxHeight(vector<vector<int>>& cuboids) {
        int n = cuboids.size();
        for (auto & v : cuboids) {
            sort(v.begin(), v.end());
        }
        sort(cuboids.begin(), cuboids.end(), [](const vector<int> & a, const vector<int> & b) {
            return a[0] + a[1] + a[2] < b[0] + b[1] + b[2];
        });

        vector<int> memo(n, -1);
        function<int(int, int)> dfs = [&](int top, int index)->int {
            if (index == cuboids.size()) {
                return 0;
            }
            if (top != -1 && memo[top] != -1) {
                return memo[top];
            }
            int height = dfs(top, index + 1);
            if (top == -1 || check(cuboids[top], cuboids[index])) {
                height = max(height, cuboids[index][2] + dfs(index, index + 1));
            }
            if (top != -1) {
                memo[top] = height;
            }
            return height;
        };
        return dfs(-1, 0);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxHeight(int[][] cuboids) {
        int n = cuboids.length;
        for (int[] v : cuboids) {
            Arrays.sort(v);
        }
        Arrays.sort(cuboids, (a, b) -> (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));

        int[] memo = new int[n];
        Arrays.fill(memo, -1);
        return dfs(cuboids, memo, -1, 0);
    }

    public int dfs(int[][] cuboids, int[] memo, int top, int index) {
        if (index == cuboids.length) {
            return 0;
        }
        if (top != -1 && memo[top] != -1) {
            return memo[top];
        }
        int height = dfs(cuboids, memo, top, index + 1);
        if (top == -1 || check(cuboids[top], cuboids[index])) {
            height = Math.max(height, cuboids[index][2] + dfs(cuboids, memo, index, index + 1));
        }
        if (top != -1) {
            memo[top] = height;
        }
        return height;
    }

    public boolean check(int[] a, int[] b) {
        return a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxHeight(int[][] cuboids) {
        int n = cuboids.Length;
        foreach (int[] v in cuboids) {
            Array.Sort(v);
        }
        Array.Sort(cuboids, (a, b) => (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));

        int[] memo = new int[n];
        Array.Fill(memo, -1);
        return DFS(cuboids, memo, -1, 0);
    }

    public int DFS(int[][] cuboids, int[] memo, int top, int index) {
        if (index == cuboids.Length) {
            return 0;
        }
        if (top != -1 && memo[top] != -1) {
            return memo[top];
        }
        int height = DFS(cuboids, memo, top, index + 1);
        if (top == -1 || Check(cuboids[top], cuboids[index])) {
            height = Math.Max(height, cuboids[index][2] + DFS(cuboids, memo, index, index + 1));
        }
        if (top != -1) {
            memo[top] = height;
        }
        return height;
    }

    public bool Check(int[] a, int[] b) {
        return a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2];
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define INVALID_STATE -1

static int cmpKey(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

static int cmpSum(const void *pa, const void *pb) {
    int *a = *(int **)pa;
    int *b = *(int **)pb;
    return (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]);
}

static inline bool check(const int *a, const int *b) {
    return a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2];
}

int dfs(int top, int index, const int** cuboids, int *memo, int cuboidsSize) {
    if (index == cuboidsSize) {
        return 0;
    }
    if (top != -1 && memo[top] != INVALID_STATE) {
        return memo[top];
    }
    int height = dfs(top, index + 1, cuboids, memo, cuboidsSize);
    if (top == -1 || check(cuboids[top], cuboids[index])) {
        height = MAX(height, cuboids[index][2] + \
                             dfs(index, index + 1, cuboids, memo, cuboidsSize));
    }
    if (top != -1) {
        memo[top] = height;
    }
    return height;
}

int maxHeight(int** cuboids, int cuboidsSize, int* cuboidsColSize) {
    for (int i = 0; i < cuboidsSize; i++) {
        qsort(cuboids[i], cuboidsColSize[i], sizeof(int), cmpKey);
    }
    qsort(cuboids, cuboidsSize, sizeof(int *), cmpSum);
    int memo[cuboidsSize];
    for (int i = 0; i < cuboidsSize; i++) {
        memo[i] = INVALID_STATE;
    }
    return dfs(-1, 0, cuboids, memo, cuboidsSize);
}
```

```JavaScript [sol2-JavaScript]
var maxHeight = function(cuboids) {
    const n = cuboids.length;
    for (const v of cuboids) {
        v.sort((a, b) => a - b);
    }
    cuboids.sort((a, b) => (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]));

    const memo = new Array(n).fill(-1)

    const dfs = (cuboids, memo, top, index) => {
        if (index === cuboids.length) {
            return 0;
        }
        if (top !== -1 && memo[top] !== -1) {
            return memo[top];
        }
        let height = dfs(cuboids, memo, top, index + 1);
        if (top === -1 || check(cuboids[top], cuboids[index])) {
            height = Math.max(height, cuboids[index][2] + dfs(cuboids, memo, index, index + 1));
        }
        if (top != -1) {
            memo[top] = height;
        }
        return height;
        }
    return dfs(cuboids, memo, -1, 0);
}

const check = (a, b) => {
    return a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示长方体的个数。时间复杂度主要取决于排序与动态规划枚举，对每个长方体边的大小进行排序的总时间复杂度为 $O(n)$，对长方体进行排序的时间为 $O(n \log n)$，对于每个长方体我们都需要枚举所有可以堆叠在其下方的长方体，需要的时间为 $O(n^2)$，因此总的时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示长方体的个数。排序需要的栈空间为 $O(\log n)$，存储每个长方体为底的最大高度需要的空间为 $O(n)$，递归搜索最大深度为 $O(n)$。因此总的空间复杂度为 $O(n)$。