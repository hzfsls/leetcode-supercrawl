## [827.最大人工岛 中文官方题解](https://leetcode.cn/problems/making-a-large-island/solutions/100000/zui-da-ren-gong-dao-by-leetcode-solution-lehy)
#### 方法一：标记岛屿 + 合并

我们给每个岛屿进行标记，标记值与岛屿的某个 $\textit{grid}[i][j]$ 有关，即 $t = i \times n + j + 1$，$t$ 唯一。使用 $\textit{tag}$ 记录每个点所属的岛屿的标记，并且使用哈希表 $\textit{area}$ 保存每个岛屿的面积。岛屿的面积可以使用深度优先搜索或广度优先搜索计算。

对于每个 $\textit{grid}[i][j] = 0$，我们计算将它变为 $1$ 后，新合并的岛屿的面积 $\textit{z}$（$z$ 的初始值为 $1$，对应该点的面积）：使用集合 $\textit{connected}$ 保存与 $\textit{grid}[i][j]$ 相连的岛屿，遍历与 $\textit{grid}[i][j]$ 相邻的四个点，如果该点的值为 $1$，且它所在的岛屿并不在集合中，我们将 $z$ 加上该点所在的岛屿面积，并且将该岛屿加入集合中。所有这些新合并岛屿以及原来的岛屿的面积的最大值就是最大的岛屿面积。

```Python [sol1-Python3]
class Solution:
    def largestIsland(self, grid: List[List[int]]) -> int:
        n = len(grid)
        tag = [[0] * n for _ in range(n)]
        area = Counter()
        def dfs(i: int, j: int) -> None:
            tag[i][j] = t
            area[t] += 1
            for x, y in (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1):  # 四个方向
                if 0 <= x < n and 0 <= y < n and grid[x][y] and tag[x][y] == 0:
                    dfs(x, y)
        for i, row in enumerate(grid):
            for j, x in enumerate(row):
                if x and tag[i][j] == 0:  # 枚举没有访问过的陆地
                    t = i * n + j + 1
                    dfs(i, j)
        ans = max(area.values(), default=0)

        for i, row in enumerate(grid):
            for j, x in enumerate(row):
                if x == 0:  # 枚举可以添加陆地的位置
                    new_area = 1
                    connected = {0}
                    for x, y in (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1):  # 四个方向
                        if 0 <= x < n and 0 <= y < n and tag[x][y] not in connected:
                            new_area += area[tag[x][y]]
                            connected.add(tag[x][y])
                    ans = max(ans, new_area)
        return ans
```

```C++ [sol1-C++]
const vector<int> d = {0, -1, 0, 1, 0};

class Solution {
public:
    bool valid(int n, int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < n;
    }

    int dfs(const vector<vector<int>> &grid, int x, int y, vector<vector<int>> &tag, int t) {
        int n = grid.size(), res = 1;
        tag[x][y] = t;
        for (int i = 0; i < 4; i++) {
            int x1 = x + d[i], y1 = y + d[i + 1];
            if (valid(n, x1, y1) && grid[x1][y1] == 1 && tag[x1][y1] == 0) {
                res += dfs(grid, x1, y1, tag, t);
            }
        }
        return res;
    }

    int largestIsland(vector<vector<int>>& grid) {
        int n = grid.size(), res = 0;
        vector<vector<int>> tag(n, vector<int>(n));
        unordered_map<int, int> area;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1 && tag[i][j] == 0) {
                    int t = i * n + j + 1;
                    area[t] = dfs(grid, i, j, tag, t);
                    res = max(res, area[t]);
                }
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    int z = 1;
                    unordered_set<int> connected;
                    for (int k = 0; k < 4; k++) {
                        int x = i + d[k], y = j + d[k + 1];
                        if (!valid(n, x, y) || tag[x][y] == 0 || connected.count(tag[x][y]) > 0) {
                            continue;
                        }
                        z += area[tag[x][y]];
                        connected.insert(tag[x][y]);
                    }
                    res = max(res, z);
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    static int[] d = {0, -1, 0, 1, 0};

    public int largestIsland(int[][] grid) {
        int n = grid.length, res = 0;
        int[][] tag = new int[n][n];
        Map<Integer, Integer> area = new HashMap<Integer, Integer>();
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1 && tag[i][j] == 0) {
                    int t = i * n + j + 1;
                    area.put(t, dfs(grid, i, j, tag, t));
                    res = Math.max(res, area.get(t));
                }
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    int z = 1;
                    Set<Integer> connected = new HashSet<Integer>();
                    for (int k = 0; k < 4; k++) {
                        int x = i + d[k], y = j + d[k + 1];
                        if (!valid(n, x, y) || tag[x][y] == 0 || connected.contains(tag[x][y])) {
                            continue;
                        }
                        z += area.get(tag[x][y]);
                        connected.add(tag[x][y]);
                    }
                    res = Math.max(res, z);
                }
            }
        }
        return res;
    }

    public int dfs(int[][] grid, int x, int y, int[][] tag, int t) {
        int n = grid.length, res = 1;
        tag[x][y] = t;
        for (int i = 0; i < 4; i++) {
            int x1 = x + d[i], y1 = y + d[i + 1];
            if (valid(n, x1, y1) && grid[x1][y1] == 1 && tag[x1][y1] == 0) {
                res += dfs(grid, x1, y1, tag, t);
            }
        }
        return res;
    }

    public boolean valid(int n, int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < n;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[] d = {0, -1, 0, 1, 0};

    public int LargestIsland(int[][] grid) {
        int n = grid.Length, res = 0;
        int[][] tag = new int[n][];
        for (int i = 0; i < n; i++) {
            tag[i] = new int[n];
        }
        Dictionary<int, int> area = new Dictionary<int, int>();
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1 && tag[i][j] == 0) {
                    int t = i * n + j + 1;
                    area.Add(t, DFS(grid, i, j, tag, t));
                    res = Math.Max(res, area[t]);
                }
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    int z = 1;
                    ISet<int> connected = new HashSet<int>();
                    for (int k = 0; k < 4; k++) {
                        int x = i + d[k], y = j + d[k + 1];
                        if (!Valid(n, x, y) || tag[x][y] == 0 || connected.Contains(tag[x][y])) {
                            continue;
                        }
                        z += area[tag[x][y]];
                        connected.Add(tag[x][y]);
                    }
                    res = Math.Max(res, z);
                }
            }
        }
        return res;
    }

    public int DFS(int[][] grid, int x, int y, int[][] tag, int t) {
        int n = grid.Length, res = 1;
        tag[x][y] = t;
        for (int i = 0; i < 4; i++) {
            int x1 = x + d[i], y1 = y + d[i + 1];
            if (Valid(n, x1, y1) && grid[x1][y1] == 1 && tag[x1][y1] == 0) {
                res += DFS(grid, x1, y1, tag, t);
            }
        }
        return res;
    }

    public bool Valid(int n, int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < n;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

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

static inline bool valid(int n, int x, int y) {
    return x >= 0 && x < n && y >= 0 && y < n;
}

const int d[5] = {0, -1, 0, 1, 0};

static int dfs(const int** grid, int n, int x, int y, int** tag, int t) {
    int res = 1;
    tag[x][y] = t;
    for (int i = 0; i < 4; i++) {
        int x1 = x + d[i], y1 = y + d[i + 1];
        if (valid(n, x1, y1) && grid[x1][y1] == 1 && tag[x1][y1] == 0) {
            res += dfs(grid, n, x1, y1, tag, t);
        }
    }
    return res;
}

int largestIsland(int** grid, int gridSize, int* gridColSize){
    int n = gridSize, res = 0;
    int **tag = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; i++) {
        tag[i] = (int *)malloc(sizeof(int) * n);
        memset(tag[i], 0, sizeof(int) * n);
    }
    int *area = (int *)malloc(sizeof(int) * (n * n + 1));
    memset(area, 0, sizeof(int) * (n * n + 1));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 1 && tag[i][j] == 0) {
                int t = i * n + j + 1;
                area[t] = dfs(grid, n, i, j, tag, t);
                res = MAX(res, area[t]);
            }
        }
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) {
                int z = 1;
                HashItem *connected = NULL;
                for (int k = 0; k < 4; k++) {
                    int x = i + d[k], y = j + d[k + 1];
                    if (!valid(n, x, y) || tag[x][y] == 0 || hashFindItem(&connected, tag[x][y])) {
                        continue;
                    }
                    z += area[tag[x][y]];
                    hashAddItem(&connected, tag[x][y]);
                }
                res = MAX(res, z);
                hashFree(&connected);
            }
        }
    }
    free(area);
    for (int i = 0; i < n; i++) {
        free(tag[i]);
    }
    free(tag);
    return res;
}
```

```JavaScript [sol1-JavaScript]
const d = [0, -1, 0, 1, 0];
var largestIsland = function(grid) {
    let n = grid.length, res = 0;
    const tag = new Array(n).fill(0).map(() => new Array(n).fill(0));
    const area = new Map();
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 1 && tag[i][j] === 0) {
                const t = i * n + j + 1;
                area.set(t, dfs(grid, i, j, tag, t));
                res = Math.max(res, area.get(t));
            }
        }
    }
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) {
                let z = 1;
                const connected = new Set();
                for (let k = 0; k < 4; k++) {
                    let x = i + d[k], y = j + d[k + 1];
                    if (!valid(n, x, y) || tag[x][y] == 0 || connected.has(tag[x][y])) {
                        continue;
                    }
                    z += area.get(tag[x][y]);
                    connected.add(tag[x][y]);
                }
                res = Math.max(res, z);
            }
        }
    }
    return res;
}

const dfs = (grid, x, y, tag, t) => {
    let n = grid.length, res = 1;
    tag[x][y] = t;
    for (let i = 0; i < 4; i++) {
        let x1 = x + d[i], y1 = y + d[i + 1];
        if (valid(n, x1, y1) && grid[x1][y1] === 1 && tag[x1][y1] === 0) {
            res += dfs(grid, x1, y1, tag, t);
        }
    }
    return res;
}

const valid = (n, x, y) => {
    return x >= 0 && x < n && y >= 0 && y < n;
};
```

```go [sol1-Golang]
func largestIsland(grid [][]int) (ans int) {
    dir4 := []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    n, t := len(grid), 0
    tag := make([][]int, n)
    for i := range tag {
        tag[i] = make([]int, n)
    }
    area := map[int]int{}
    var dfs func(int, int)
    dfs = func(i, j int) {
        tag[i][j] = t
        area[t]++
        for _, d := range dir4 {
            x, y := i+d.x, j+d.y
            if 0 <= x && x < n && 0 <= y && y < n && grid[x][y] > 0 && tag[x][y] == 0 {
                dfs(x, y)
            }
        }
    }
    for i, row := range grid {
        for j, x := range row {
            if x > 0 && tag[i][j] == 0 { // 枚举没有访问过的陆地
                t = i*n + j + 1
                dfs(i, j)
                ans = max(ans, area[t])
            }
        }
    }

    for i, row := range grid {
        for j, x := range row {
            if x == 0 { // 枚举可以添加陆地的位置
                newArea := 1
                conn := map[int]bool{0: true}
                for _, d := range dir4 {
                    x, y := i+d.x, j+d.y
                    if 0 <= x && x < n && 0 <= y && y < n && !conn[tag[x][y]] {
                        newArea += area[tag[x][y]]
                        conn[tag[x][y]] = true
                    }
                }
                ans = max(ans, newArea)
            }
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是 $\textit{grid}$ 的长与宽。使用深度优先搜索获取岛屿面积时，总共访问不超过 $n^2$ 个点。

+ 空间复杂度：$O(n^2)$。保存 $\textit{tag}$ 与 $\textit{area}$ 需要 $O(n^2)$ 的空间。