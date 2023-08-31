## [1267.统计参与通信的服务器 中文官方题解](https://leetcode.cn/problems/count-servers-that-communicate/solutions/100000/tong-ji-can-yu-tong-xin-de-fu-wu-qi-by-leetcode-so)

#### 方法一：两次遍历 + 哈希表

**思路与算法**

我们可以使用两次遍历解决本题。

在第一次遍历中，我们遍历数组 $\textit{grid}$，如果 $\textit{grid}[i, j]$ 的值为 $1$，说明位置 $(i, j)$ 有一台服务器，我们可以将第 $i$ 行服务器的数量，以及第 $j$ 列服务器的数量，均加上 $1$。为了维护行列中服务器的数量，我们可以使用两个哈希映射 $\textit{row}$ 和 $\textit{col}$，$\textit{row}$ 中存储行的编号以及每一行服务器的数量，$\textit{col}$ 存储列的编号以及每一列服务器的数量。

在第二次遍历中，我们就可以根据 $\textit{row}$ 和 $\textit{col}$ 来判断每一台服务器是否能与至少其它一台服务器进行通信了。如果 $\textit{grid}(i, j)$ 的值为 $1$，并且 $\textit{row}[i]$ 和 $\textit{col}[j]$ 中至少有一个严格大于 $1$，就说明位置 $(i, j)$ 的服务器能与同一行或者同一列的另一台服务器进行通信，答案加 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countServers(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        unordered_map<int, int> rows, cols;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1) {
                    ++rows[i];
                    ++cols[j];
                }
            }
        }
        int ans = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1 && (rows[i] > 1 || cols[j] > 1)) {
                    ++ans;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countServers(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        Map<Integer, Integer> rows = new HashMap<Integer, Integer>();
        Map<Integer, Integer> cols = new HashMap<Integer, Integer>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1) {
                    rows.put(i, rows.getOrDefault(i, 0) + 1);
                    cols.put(j, cols.getOrDefault(j, 0) + 1);
                }
            }
        }
        int ans = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1 && (rows.get(i) > 1 || cols.get(j) > 1)) {
                    ++ans;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountServers(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        IDictionary<int, int> rows = new Dictionary<int, int>();
        IDictionary<int, int> cols = new Dictionary<int, int>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1) {
                    rows.TryAdd(i, 0);
                    ++rows[i];
                    cols.TryAdd(j, 0);
                    ++cols[j];
                }
            }
        }
        int ans = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1 && (rows[i] > 1 || cols[j] > 1)) {
                    ++ans;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countServers(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        rows, cols = Counter(), Counter()
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    rows[i] += 1
                    cols[j] += 1
        
        ans = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1 and (rows[i] > 1 or cols[j] > 1):
                    ans += 1
        
        return ans
```

```C [sol1-C]
int countServers(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int rows[m], cols[n];
    memset(rows, 0, sizeof(rows));
    memset(cols, 0, sizeof(cols));
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (grid[i][j] == 1) {
                ++rows[i];
                ++cols[j];
            }
        }
    }
    int ans = 0;
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (grid[i][j] == 1 && (rows[i] > 1 || cols[j] > 1)) {
                ++ans;
            }
        }
    }
    return ans;
}
```

```Go [sol1-Go]
func countServers(grid [][]int) int {
    m := len(grid)
    n := len(grid[0])
    rows := make(map[int]int)
    cols := make(map[int]int)
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 {
                rows[i] = rows[i] + 1
                cols[j] = cols[j] + 1
            }
        }
    }
    ans := 0
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid[i][j] == 1 && (rows[i] > 1 || cols[j] > 1) {
                ans++
            }
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var countServers = function(grid) {
    const m = grid.length, n = grid[0].length;
    const rows = new Map();
    const cols = new Map();
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (grid[i][j] == 1) {
                rows.set(i, (rows.get(i) || 0) + 1);
                cols.set(j, (cols.get(j) || 0) + 1);
            }
        }
    }
    let ans = 0;
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (grid[i][j] == 1 && ((rows.get(i) || 0) > 1 || (cols.get(j) || 0) > 1)) {
                ++ans;
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(m+n)$，即为哈希映射需要使用的空间。