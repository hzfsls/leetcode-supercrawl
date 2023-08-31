## [1706.球会落何处 中文官方题解](https://leetcode.cn/problems/where-will-the-ball-fall/solutions/100000/qiu-hui-luo-he-chu-by-leetcode-solution-xqop)

#### 方法一：模拟

**思路**

我们依次判断每个球的最终位置。对于每个球，从上至下判断球位置的移动方向。在对应的位置，如果挡板向右偏，则球会往右移动；如果挡板往左偏，则球会往左移动。若移动过程中碰到侧边或者 $\text{V}$ 型，则球会停止移动，卡在箱子里。如果可以完成本层的移动，则继续判断下一层的移动方向，直到落出箱子或者卡住。

**代码**

```Python [sol1-Python3]
class Solution:
    def findBall(self, grid: List[List[int]]) -> List[int]:
        n = len(grid[0])
        ans = [-1] * n
        for j in range(n):
            col = j  # 球的初始列
            for row in grid:
                dir = row[col]
                col += dir  # 移动球
                if col < 0 or col == n or row[col] != dir:  # 到达侧边或 V 形
                    break
            else:  # 成功到达底部
                ans[j] = col
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findBall(vector<vector<int>> &grid) {
        int n = grid[0].size();
        vector<int> ans(n);
        for (int j = 0; j < n; ++j) {
            int col = j; // 球的初始列
            for (auto &row : grid) {
                int dir = row[col];
                col += dir; // 移动球
                if (col < 0 || col == n || row[col] != dir) { // 到达侧边或 V 形
                    col = -1;
                    break;
                }
            }
            ans[j] = col; // col >= 0 为成功到达底部
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] findBall(int[][] grid) {
        int n = grid[0].length;
        int[] ans = new int[n];
        for (int j = 0; j < n; j++) {
            int col = j;  // 球的初始列
            for (int[] row : grid) {
                int dir = row[col];
                col += dir;  // 移动球
                if (col < 0 || col == n || row[col] != dir) {  // 到达侧边或 V 形
                    col = -1;
                    break;
                }
            }
            ans[j] = col;  // col >= 0 为成功到达底部
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] FindBall(int[][] grid) {
        int n = grid[0].Length;
        int[] ans = new int[n];
        for (int j = 0; j < n; j++) {
            int col = j;  // 球的初始列
            foreach (int[] row in grid) {
                int dir = row[col];
                col += dir;  // 移动球
                if (col < 0 || col == n || row[col] != dir) {  // 到达侧边或 V 形
                    col = -1;
                    break;
                }
            }
            ans[j] = col;  // col >= 0 为成功到达底部
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func findBall(grid [][]int) []int {
    n := len(grid[0])
    ans := make([]int, n)
    for j := range ans {
        col := j // 球的初始列
        for _, row := range grid {
            dir := row[col]
            col += dir // 移动球
            if col < 0 || col == n || row[col] != dir { // 到达侧边或 V 形
                col = -1
                break
            }
        }
        ans[j] = col // col >= 0 为成功到达底部
    }
    return ans
}
```

```C [sol1-C]
int* findBall(int** grid, int gridSize, int* gridColSize, int* returnSize) {
    int n = gridColSize[0];
    int * ans = (int *)malloc(sizeof(int) * n);
    for (int j = 0; j < n; ++j) {
        int col = j; // 球的初始列
        for (int i = 0; i < gridSize; i++) {
            int dir = grid[i][col];
            col += dir; // 移动球
            if (col < 0 || col == n || grid[i][col] != dir) { // 到达侧边或 V 形
                col = -1;
                break;
            }
        }
        ans[j] = col; // col >= 0 为成功到达底部
    }
    *returnSize = n; 
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var findBall = function(grid) {
    const n = grid[0].length;
    const ans = new Array(n);
    for (let j = 0; j < n; j++) {
        let col = j; // 球的初始列
        for (const row of grid) {
            const dir = row[col];
            col += dir; // 移动球
            if (col < 0 || col === n || row[col] !== dir) { // 到达侧边或 V 形
                col = -1;
                break;
            }
        }
        ans[j] = col;  // col >= 0 为成功到达底部
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 和 $n$ 是网格的行数和列数。外循环消耗 $O(n)$，内循环消耗 $O(m)$。

- 空间复杂度：$O(1)$。返回值不计入空间。