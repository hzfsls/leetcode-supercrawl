## [2500.删除每行中的最大值 中文官方题解](https://leetcode.cn/problems/delete-greatest-value-in-each-row/solutions/100000/shan-chu-mei-xing-zhong-de-zui-da-zhi-by-6fh9)

#### 方法一：排序

**思路与算法**

我们将题目给出大小为 $m \times n$ 的矩阵 $\textit{grid}$ 每一行从小到大排序，那么题目等价于每次删除矩阵的末尾列，得分为该列的最大值。那么最后的答案就是每一列的最大值之和。

**代码**

```Python [sol1-Python3]
class Solution:
    def deleteGreatestValue(self, grid: List[List[int]]) -> int:
        for i in grid:
            i.sort()
        return sum([max(i) for i in zip(*grid)])
```

```Java [sol1-Java]
class Solution {
    public int deleteGreatestValue(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        for (int i = 0; i < m; i++) {
            Arrays.sort(grid[i]);
        }
        int res = 0;
        for (int j = 0; j < n; j++) {
            int mx = 0;
            for (int i = 0; i < m; i++) {
                mx = Math.max(mx, grid[i][j]);
            }
            res += mx;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int deleteGreatestValue(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        for (int i = 0; i < m; i++) {
            sort(grid[i].begin(), grid[i].end());
        }
        int res = 0;
        for (int j = 0; j < n; j++) {
            int mx = 0;
            for (int i = 0; i < m; i++) {
                mx = max(mx, grid[i][j]);
            }
            res += mx;
        }
        return res;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int DeleteGreatestValue(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        for (int i = 0; i < m; i++) {
            Array.Sort(grid[i]);
        }
        int res = 0;
        for (int j = 0; j < n; j++) {
            int mx = 0;
            for (int i = 0; i < m; i++) {
                mx = Math.Max(mx, grid[i][j]);
            }
            res += mx;
        }
        return res;
    }
}
```

```Go [sol1-Go]
func deleteGreatestValue(grid [][]int) int {
    m := len(grid)
    n := len(grid[0])
    for i := 0; i < m; i++ {
        sort.Ints(grid[i])
    }
    res := 0
    for j := 0; j < n; j++ {
        mx := 0
        for i := 0; i < m; i++ {
            mx = max(mx, grid[i][j])
        }
        res += mx
    }
    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var deleteGreatestValue = function(grid) {
    const m = grid.length, n = grid[0].length;
    for (let i = 0; i < m; i++) {
        grid[i].sort((a, b) => a - b);
    }
    let res = 0;
    for (let j = 0; j < n; j++) {
        let mx = 0;
        for (let i = 0; i < m; i++) {
            mx = Math.max(mx, grid[i][j]);
        }
        res += mx;
    }
    return res;
};
```

```C [sol1-C]
int cmp(void const* a, void const* b) {
    return *(int*)a - *(int*)b;
}

int deleteGreatestValue(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = *gridColSize;
    for (int i = 0; i < m; ++i) {
        qsort(grid[i], n, 4U, cmp);
    }
    int res = 0;
    for (int j = 0; j < n; j++) {
        int mx = 0;
        for (int i = 0; i < m; ++i) {
            if (grid[i][j] > mx) {
                mx = grid[i][j];
            }
        }
        res += mx;
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times \log n)$，其中 $m$，$n$ 分别为矩阵 $\textit{grid}$ 的行列数，对矩阵 $\textit{grid}$ 的每一行排序的时间复杂度为 $n \times \log n$，共有 $m$ 行，所以总的时间复杂度为 $O(m \times n \times \log n)$。
- 空间复杂度：$O(\log n)$，排序需要的栈开销。