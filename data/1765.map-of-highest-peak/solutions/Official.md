## [1765.地图中的最高点 中文官方题解](https://leetcode.cn/problems/map-of-highest-peak/solutions/100000/di-tu-zhong-de-zui-gao-dian-by-leetcode-jdkzr)

#### 方法一：多源广度优先搜索

题目要求让矩阵中的最高高度最大，我们可以通过最大化每个格子的高度来做到这一点。由于任意相邻的格子高度差至多为 $1$，这意味着对于每个格子，其高度至多比其相邻格子中的最小高度多 $1$。

题目要求水域的高度必须为 $0$，因此水域的高度是已经确定的值，我们可以从水域出发，推导出其余格子的高度：

- 首先，计算与水域相邻的格子的高度。对于这些格子来说，其相邻格子中的最小高度即为水域的高度 $0$，因此这些格子的高度为 $1$。
- 然后，计算与高度为 $1$ 的格子相邻的、尚未被计算过的格子的高度。对于这些格子来说，其相邻格子中的最小高度为 $1$，因此这些格子的高度为 $2$。
- 以此类推，计算出所有格子的高度。

上述过程中，对于每一轮，我们考虑的是与上一轮格子相邻的、未被计算过的格子 $x$，其高度必然比上一轮的格子高度多 $1$。反证之：如果格子 $x$ 的高度小于或等于上一轮的格子高度，那么 $x$ 必然会在更早的轮数被计算出来，矛盾。因此 $x$ 的高度必然比上一轮的格子高度高，同时由于题目要求任意相邻的格子高度差至多为 $1$，因此 $x$ 的高度必然比上一轮格子的高度多 $1$。

可以发现，上述过程就是从水域出发，执行广度优先搜索的过程。因此，记录下所有水域的位置，然后执行广度优先搜索，计算出所有陆地格子的高度，即为答案。

```Python [sol1-Python3]
class Solution:
    def highestPeak(self, isWater: List[List[int]]) -> List[List[int]]:
        m, n = len(isWater), len(isWater[0])
        ans = [[water - 1 for water in row] for row in isWater]
        q = deque((i, j) for i, row in enumerate(isWater) for j, water in enumerate(row) if water)  # 将所有水域入队
        while q:
            i, j = q.popleft()
            for x, y in ((i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)):
                if 0 <= x < m and 0 <= y < n and ans[x][y] == -1:
                    ans[x][y] = ans[i][j] + 1
                    q.append((x, y))
        return ans
```

```C++ [sol1-C++]
int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

class Solution {
public:
    vector<vector<int>> highestPeak(vector<vector<int>> &isWater) {
        int m = isWater.size(), n = isWater[0].size();
        vector<vector<int>> ans(m, vector<int>(n, -1)); // -1 表示该格子尚未被访问过
        queue<pair<int, int>> q;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (isWater[i][j]) {
                    ans[i][j] = 0;
                    q.emplace(i, j); // 将所有水域入队
                }
            }
        }
        while (!q.empty()) {
            auto &p = q.front();
            for (auto &dir : dirs) {
                int x = p.first + dir[0], y = p.second + dir[1];
                if (0 <= x && x < m && 0 <= y && y < n && ans[x][y] == -1) {
                    ans[x][y] = ans[p.first][p.second] + 1;
                    q.emplace(x, y);
                }
            }
            q.pop();
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int[][] highestPeak(int[][] isWater) {
        int m = isWater.length, n = isWater[0].length;
        int[][] ans = new int[m][n];
        for (int i = 0; i < m; ++i) {
            Arrays.fill(ans[i], -1); // -1 表示该格子尚未被访问过
        }
        Queue<int[]> queue = new ArrayDeque<int[]>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (isWater[i][j] == 1) {
                    ans[i][j] = 0;
                    queue.offer(new int[]{i, j}); // 将所有水域入队
                }
            }
        }
        while (!queue.isEmpty()) {
            int[] p = queue.poll();
            for (int[] dir : dirs) {
                int x = p[0] + dir[0], y = p[1] + dir[1];
                if (0 <= x && x < m && 0 <= y && y < n && ans[x][y] == -1) {
                    ans[x][y] = ans[p[0]][p[1]] + 1;
                    queue.offer(new int[]{x, y});
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int[][] HighestPeak(int[][] isWater) {
        int m = isWater.Length, n = isWater[0].Length;
        int[][] ans = new int[m][];
        for (int i = 0; i < m; ++i) {
            ans[i] = new int[n];
            Array.Fill(ans[i], -1); // -1 表示该格子尚未被访问过
        }
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (isWater[i][j] == 1) {
                    ans[i][j] = 0;
                    queue.Enqueue(new Tuple<int, int>(i, j)); // 将所有水域入队
                }
            }
        }
        while (queue.Count > 0) {
            Tuple<int, int> p = queue.Dequeue();
            foreach (int[] dir in dirs) {
                int x = p.Item1 + dir[0], y = p.Item2 + dir[1];
                if (0 <= x && x < m && 0 <= y && y < n && ans[x][y] == -1) {
                    ans[x][y] = ans[p.Item1][p.Item2] + 1;
                    queue.Enqueue(new Tuple<int, int>(x, y));
                }
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func highestPeak(isWater [][]int) [][]int {
    m, n := len(isWater), len(isWater[0])
    ans := make([][]int, m)
    for i := range ans {
        ans[i] = make([]int, n)
        for j := range ans[i] {
            ans[i][j] = -1 // -1 表示该格子尚未被访问过
        }
    }
    q := []pair{}
    for i, row := range isWater {
        for j, water := range row {
            if water == 1 { // 将所有水域入队
                ans[i][j] = 0
                q = append(q, pair{i, j})
            }
        }
    }
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        for _, d := range dirs {
            if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < m && 0 <= y && y < n && ans[x][y] == -1 {
                ans[x][y] = ans[p.x][p.y] + 1
                q = append(q, pair{x, y})
            }
        }
    }
    return ans
}
```

```C [sol1-C]
typedef struct {
    int x;
    int y;
} Pair; 

int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int** highestPeak(int** isWater, int isWaterSize, int* isWaterColSize, int* returnSize, int** returnColumnSizes){
    int m = isWaterSize, n = isWaterColSize[0];
    int ** ans = (int **)malloc(sizeof(int *) * m);
    for (int i = 0; i < m; ++i) {
        ans[i] = (int *)malloc(sizeof(int) * n);
        memset(ans[i], -1, sizeof(int) * n);
    }
    Pair * queue = (Pair *)malloc(sizeof(Pair) * m * n);
    int head = 0;
    int tail = 0;
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (isWater[i][j]) {
                ans[i][j] = 0;
                queue[tail].x = i; // 将所有水域入队
                queue[tail].y = j;
                ++tail; 
            }
        }
    }
    while (head != tail) {
        int px = queue[head].x, py = queue[head].y;
        for (int i = 0; i < 4; ++i) {
            int x = px + dirs[i][0], y = py + dirs[i][1];
            if (0 <= x && x < m && 0 <= y && y < n && ans[x][y] == -1) {
                ans[x][y] = ans[px][py] + 1;
                queue[tail].x = x;
                queue[tail].y = y;
                ++tail;
            }
        }
        ++head;
    }
    free(queue);
    *returnSize = m;
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    memcpy(*returnColumnSizes, isWaterColSize, sizeof(int) * m);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$。$m$ 和 $n$ 的含义同题目中的定义。

- 空间复杂度：$O(mn)$。最坏情况下整个矩阵都是水域，我们需要将所有水域入队。