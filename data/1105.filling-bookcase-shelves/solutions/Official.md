## [1105.填充书架 中文官方题解](https://leetcode.cn/problems/filling-bookcase-shelves/solutions/100000/tian-chong-shu-jia-by-leetcode-solution-b7py)
#### 方法一：动态规划

**思路与算法**

根据题意，按顺序将这些书摆放到总宽度为 $\textit{shelfWidth}$ 的书架上。先选几本书放在书架上，然后再建一层书架。重复这个过程，直到把所有的书都放在书架上。

考虑用「动态规划」来解决这个问题，$\textit{dp}[i]$ 来表示放下前 $i$ 本书所用的最小高度。 因为最多 $1000$ 本书， 每本书高度最大 $1000$，我们可以把 $\textit{dp}[i]$ 初始化为 $1000000$， 初始化 $\textit{dp}[0]$ 为零，表示没有书是高度为零。

当我们要放置前 $i$ 本书时候，假定前 $j$ 本书放在上面的书架上，其中 $j < i$, 前 $j$ 本书放好后剩余的书放在最后一层书架上, 这一层书架的高度是这部分书的高度最大值，由此得到如此递推公式：
$$\textit{dp}[i] = \min(\textit{dp}[j] + \max(\textit{books}[k]))$$
其中满足
$$0 \le j \le k < i \le n, \sum \textit{books}[k] \le \textit{shelfWidth}$$

我们循环遍历 $i$, 求出 $\textit{dp}[i]$ 的值，最后返回  $\textit{dp}[n]$ 为最终答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minHeightShelves(vector<vector<int>>& books, int shelfWidth) {
        int n = books.size();
        vector<int> dp(n + 1, 1000000);
        dp[0] = 0;
        for (int i = 0; i < n; ++i) {
            int maxHeight = 0, curWidth = 0;
            for (int j = i; j >= 0; --j) {
                curWidth += books[j][0];
                if (curWidth > shelfWidth) {
                    break;
                }
                maxHeight = max(maxHeight, books[j][1]);
                dp[i + 1] = min(dp[i + 1], dp[j] + maxHeight);
            }
        }
        return dp[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minHeightShelves(int[][] books, int shelfWidth) {
        int n = books.length;
        int[] dp = new int[n + 1];
        Arrays.fill(dp, 1000000);
        dp[0] = 0;
        for (int i = 0; i < n; ++i) {
            int maxHeight = 0, curWidth = 0;
            for (int j = i; j >= 0; --j) {
                curWidth += books[j][0];
                if (curWidth > shelfWidth) {
                    break;
                }
                maxHeight = Math.max(maxHeight, books[j][1]);
                dp[i + 1] = Math.min(dp[i + 1], dp[j] + maxHeight);
            }
        }
        return dp[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minHeightShelves(self, books: List[List[int]], shelfWidth: int) -> int:
        n = len(books)
        dp = [inf] * (n + 1)
        dp[0] = 0
        for i, b in enumerate(books):
            curWidth = 0
            maxHeight = 0
            j = i
            while j >= 0:
                curWidth += books[j][0]
                if curWidth > shelfWidth:
                    break
                maxHeight = max(maxHeight, books[j][1])
                dp[i + 1] = min(dp[i + 1], dp[j] + maxHeight)
                j -= 1
        return dp[n]
```

```Go [sol1-Go]
func minHeightShelves(books [][]int, shelfWidth int) int {
    n := len(books)
    dp := make([]int, n + 1)
    for i := 1; i <= n; i++ {
        dp[i] = 1000000
    }
    dp[0] = 0
    for i := 0; i < n; i++ {
        maxHeight, curWidth := 0, 0
        for j := i; j >= 0; j-- {
            curWidth += books[j][0]
            if curWidth > shelfWidth {
                break
            }
            maxHeight = max(maxHeight, books[j][1])
            dp[i + 1] = min(dp[i+1], dp[j] + maxHeight)
        }
    }
    return dp[n]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C# [sol1-C#]
public class Solution {
    public int MinHeightShelves(int[][] books, int shelfWidth) {
        int n = books.Length;
        int[] dp = new int[n + 1];
        Array.Fill(dp, 1000000);
        dp[0] = 0;
        for (int i = 0; i < n; ++i) {
            int maxHeight = 0, curWidth = 0;
            for (int j = i; j >= 0; --j) {
                curWidth += books[j][0];
                if (curWidth > shelfWidth) {
                    break;
                }
                maxHeight = Math.Max(maxHeight, books[j][1]);
                dp[i + 1] = Math.Min(dp[i + 1], dp[j] + maxHeight);
            }
        }
        return dp[n];
    }
}
```

```C [sol1-C]
int minHeightShelves(int** books, int booksSize, int* booksColSize, int shelfWidth) {
    int n = booksSize;
    int* dp = (int*)malloc((n + 1) * sizeof(int));
    for (int i = 0; i <= n; ++i) {
        dp[i] = 1000000;
    }
    dp[0] = 0;
    for (int i = 0; i < n; ++i) {
        int maxHeight = 0, curWidth = 0;
        for (int j = i; j >= 0; --j) {
            curWidth += books[j][0];
            if (curWidth > shelfWidth) {
                break;
            }
            maxHeight = fmax(maxHeight, books[j][1]);
            dp[i + 1] = fmin(dp[i + 1], dp[j] + maxHeight);
        }
    }
    return dp[n];
}
```

```JavaScript [sol1-JavaScript]
var minHeightShelves = function(books, shelfWidth) {
    const n = books.length;
    const dp = new Array(n + 1).fill(1000000);
    dp[0] = 0;
    for (let i = 0; i < n; i++) {
        let maxHeight = 0, curWidth = 0;
        for (let j = i; j >= 0; j--) {
            curWidth += books[j][0];
            if (curWidth > shelfWidth) {
                break;
            }
            maxHeight = Math.max(maxHeight, books[j][1]);
            dp[i + 1] = Math.min(dp[i + 1], dp[j] + maxHeight);
        }
    }
    return dp[n];
};
```

**复杂度分析**

- 时间复杂度：$O(n ^ 2)$，其中 $n$ 是 $\textit{books}$ 的长度。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{books}$ 的长度。