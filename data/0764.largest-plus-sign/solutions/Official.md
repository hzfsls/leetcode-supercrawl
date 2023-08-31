## [764.最大加号标志 中文官方题解](https://leetcode.cn/problems/largest-plus-sign/solutions/100000/zui-da-jia-hao-biao-zhi-by-leetcode-solu-jirt)

#### 方法一：动态规划

**思路与算法**

对于每个中心点坐标 $(i, j)$，分别从上下左右四个方向计算从 $(i, j)$ 开始最长连续 $1$ 的个数。设 $\textit{dp}[i][j][k]$ 表示以 $(i, j)$ 为起点在方向 $k$ 上的连续 $1$ 的最大数目：
+ 如果 $\textit{grid}[i][j]$ 为 $0$，那么此时该方向的连续 $1$ 的最大数目为 $0$；
+ 如果 $\textit{grid}[i][j]$ 为 $1$, 那么此时该方向的连续 $1$ 的最大数目为该方向上前一个单元为起点的最大数目加 $1$；

假设当前 $k = 0,1,2,3$ 时，分别表示方向为左、右、上、下，则我们可以得到递推公式如下：
$$
\textit{dp}[i][j][0] =
\begin{cases}
0, & \textit{grid}[i][j] = 0 \\
\textit{dp}[i][j-1][0] + 1 , &  \textit{grid}[i][j] = 1 \\
\end{cases} 
\\
\textit{dp}[i][j][1] =
\begin{cases}
0, & \textit{grid}[i][j] = 0 \\
\textit{dp}[i][j+1][1] + 1 , &  \textit{grid}[i][j] = 1 \\
\end{cases} 
\\
\textit{dp}[i][j][2] =
\begin{cases}
0, & \textit{grid}[i][j] = 0 \\
\textit{dp}[i-1][j][2] + 1 , &  \textit{grid}[i][j] = 1 \\
\end{cases} 
\\
\textit{dp}[i][j][3] =
\begin{cases}
0, & \textit{grid}[i][j] = 0 \\
\textit{dp}[i+1][j][3] + 1 , &  \textit{grid}[i][j] = 1 \\
\end{cases} 
\\
$$

假设网格中有一行为 $\texttt{01110110}$，当前方向为向左，那么对应的连续 $1$ 的个数就是 $012301201$。以每个点为 $(i,j)$ 为中心的四个方向中最小连续 $1$ 的个数即为以其为中心构成的加号标志的最大阶数，我们用公式表示 $L = \min\limits_{k=0}^{3}\textit{dp}[i][j][k]$。在实际计算时，我们为了方便计算只用 $\textit{dp}[i][j]$ 保存四个方向中最小的连续 $1$ 的个数即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def orderOfLargestPlusSign(self, n: int, mines: List[List[int]]) -> int:
        dp = [[n] * n for _ in range(n)]
        banned = set(map(tuple, mines))
        for i in range(n):
            # left
            count = 0
            for j in range(n):
                count = 0 if (i, j) in banned else count + 1
                dp[i][j] = min(dp[i][j], count)
            # right
            count = 0
            for j in range(n - 1, -1, -1):
                count = 0 if (i, j) in banned else count + 1
                dp[i][j] = min(dp[i][j], count)
        for j in range(n):
            # up
            count = 0
            for i in range(n):
                count = 0 if (i, j) in banned else count + 1
                dp[i][j] = min(dp[i][j], count)
            # down
            count = 0
            for i in range(n - 1, -1, -1):
                count = 0 if (i, j) in banned else count + 1
                dp[i][j] = min(dp[i][j], count)
        return max(map(max, dp))
```

```C++ [sol1-C++]
class Solution {
public:
    int orderOfLargestPlusSign(int n, vector<vector<int>>& mines) {
        vector<vector<int>> dp(n, vector<int>(n, n));
        unordered_set<int> banned;
        for (auto &&vec : mines) {
            banned.emplace(vec[0] * n + vec[1]);
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* left */
            for (int j = 0; j < n; j++) {
                if (banned.count(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = min(dp[i][j], count);
            }
            count = 0;
            /* right */ 
            for (int j = n - 1; j >= 0; j--) {
                if (banned.count(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = min(dp[i][j], count);
            }
        }
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* up */
            for (int j = 0; j < n; j++) {
                if (banned.count(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = min(dp[j][i], count);
            }
            count = 0;
            /* down */
            for (int j = n - 1; j >= 0; j--) {
                if (banned.count(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = min(dp[j][i], count);
                ans = max(ans, dp[j][i]);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int orderOfLargestPlusSign(int n, int[][] mines) {
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            Arrays.fill(dp[i], n);
        }
        Set<Integer> banned = new HashSet<Integer>();
        for (int[] vec : mines) {
            banned.add(vec[0] * n + vec[1]);
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* left */
            for (int j = 0; j < n; j++) {
                if (banned.contains(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = Math.min(dp[i][j], count);
            }
            count = 0;
            /* right */ 
            for (int j = n - 1; j >= 0; j--) {
                if (banned.contains(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = Math.min(dp[i][j], count);
            }
        }
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* up */
            for (int j = 0; j < n; j++) {
                if (banned.contains(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = Math.min(dp[j][i], count);
            }
            count = 0;
            /* down */
            for (int j = n - 1; j >= 0; j--) {
                if (banned.contains(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = Math.min(dp[j][i], count);
                ans = Math.max(ans, dp[j][i]);
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int OrderOfLargestPlusSign(int n, int[][] mines) {
        int[][] dp = new int[n][];
        for (int i = 0; i < n; i++) {
            dp[i] = new int[n];
            Array.Fill(dp[i], n);
        }
        ISet<int> banned = new HashSet<int>();
        foreach (int[] vec in mines) {
            banned.Add(vec[0] * n + vec[1]);
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* left */
            for (int j = 0; j < n; j++) {
                if (banned.Contains(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = Math.Min(dp[i][j], count);
            }
            count = 0;
            /* right */ 
            for (int j = n - 1; j >= 0; j--) {
                if (banned.Contains(i * n + j)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[i][j] = Math.Min(dp[i][j], count);
            }
        }
        for (int i = 0; i < n; i++) {
            int count = 0;
            /* up */
            for (int j = 0; j < n; j++) {
                if (banned.Contains(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = Math.Min(dp[j][i], count);
            }
            count = 0;
            /* down */
            for (int j = n - 1; j >= 0; j--) {
                if (banned.Contains(j * n + i)) {
                    count = 0;
                } else {
                    count++;
                }
                dp[j][i] = Math.Min(dp[j][i], count);
                ans = Math.Max(ans, dp[j][i]);
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

int orderOfLargestPlusSign(int n, int** mines, int minesSize, int* minesColSize) {
    int dp[n][n];
    HashItem *banned = NULL;
    for (int i = 0; i < minesSize; i++) {
        hashAddItem(&banned, mines[i][0] * n + mines[i][1]);
    }
    int ans = 0;
    for (int i = 0; i < n; i++) {
        int count = 0;
        /* left */
        for (int j = 0; j < n; j++) {
            dp[i][j] = n;
            if (hashFindItem(&banned, i * n + j)) {
                count = 0;
            } else {
                count++;
            }
            dp[i][j] = MIN(dp[i][j], count);
        }
        count = 0;
        /* right */
        for (int j = n - 1; j >= 0; j--) {
            if (hashFindItem(&banned, i * n + j)) {
                count = 0;
            } else {
                count++;
            }
            dp[i][j] = MIN(dp[i][j], count);
        }
    }
    for (int i = 0; i < n; i++) {
        int count = 0;
        /* up */
        for (int j = 0; j < n; j++) {
            if (hashFindItem(&banned, j * n + i)) {
                count = 0;
            } else {
                count++;
            }
            dp[j][i] = MIN(dp[j][i], count);
        }
        count = 0;
        /* down */
        for (int j = n - 1; j >= 0; j--) {
            if (hashFindItem(&banned, j * n + i)) {
                count = 0;
            } else {
                count++;
            }
            dp[j][i] = MIN(dp[j][i], count);
            ans = MAX(ans, dp[j][i]);
        }
    }
    hashFree(&banned);
    return ans;
}
```

```go [sol1-Golang]
func orderOfLargestPlusSign(n int, mines [][]int) (ans int) {
    dp := make([][]int, n)
    for i := range dp {
        dp[i] = make([]int, n)
        for j := range dp[i] {
            dp[i][j] = n
        }
    }
    banned := map[int]bool{}
    for _, p := range mines {
        banned[p[0]*n+p[1]] = true
    }
    for i := 0; i < n; i++ {
        count := 0
        /* left */
        for j := 0; j < n; j++ {
            if banned[i*n+j] {
                count = 0
            } else {
                count++
            }
            dp[i][j] = min(dp[i][j], count)
        }
        count = 0
        /* right */
        for j := n - 1; j >= 0; j-- {
            if banned[i*n+j] {
                count = 0
            } else {
                count++
            }
            dp[i][j] = min(dp[i][j], count)
        }
    }
    for i := 0; i < n; i++ {
        count := 0
        /* up */
        for j := 0; j < n; j++ {
            if banned[j*n+i] {
                count = 0
            } else {
                count++
            }
            dp[j][i] = min(dp[j][i], count)
        }
        count = 0
        /* down */
        for j := n - 1; j >= 0; j-- {
            if banned[j*n+i] {
                count = 0
            } else {
                count++
            }
            dp[j][i] = min(dp[j][i], count)
            ans = max(ans, dp[j][i])
        }
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
/**
 * @param {number} n
 * @param {number[][]} mines
 * @return {number}
 */
var orderOfLargestPlusSign = function(n, mines) {
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(n));
    const banned = new Set();
    for (const vec of mines) {
        banned.add(vec[0] * n + vec[1]);
    }
    let ans = 0;
    for (let i = 0; i < n; i++) {
        let count = 0;
        /* left */
        for (let j = 0; j < n; j++) {
            if (banned.has(i * n + j)) {
                count = 0;
            } else {
                count++;
            }
            dp[i][j] = Math.min(dp[i][j], count);
        }
        count = 0;
        /* right */ 
        for (let j = n - 1; j >= 0; j--) {
            if (banned.has(i * n + j)) {
                count = 0;
            } else {
                count++;
            }
            dp[i][j] = Math.min(dp[i][j], count);
        }
    }
    for (let i = 0; i < n; i++) {
        let count = 0;
        /* up */
        for (let j = 0; j < n; j++) {
            if (banned.has(j * n + i)) {
                count = 0;
            } else {
                count++;
            }
            dp[j][i] = Math.min(dp[j][i], count);
        }
        count = 0;
        /* down */
        for (let j = n - 1; j >= 0; j--) {
            if (banned.has(j * n + i)) {
                count = 0;
            } else {
                count++;
            }
            dp[j][i] = Math.min(dp[j][i], count);
            ans = Math.max(ans, dp[j][i]);
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示矩阵的行数。我们最多需要遍历 $4$ 次即可计算出每个点上的 $4$ 方向上连续 $1$ 的最大数目，因此需要的时间为 $O(n^2)$。

- 空间复杂度：$O(n^2)$。我们需要保存每个点上的 $4$ 方向上连续 $1$ 的最小数目即可，需要的空间为 $O(n^2)$。