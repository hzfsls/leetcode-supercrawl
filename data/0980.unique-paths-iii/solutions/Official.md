#### 方法一：回溯

**思路**

按照要求，假设矩阵中有 $n$ 个 $0$，那么一条合格的路径，是长度为 $(n+1)$，由 $1$ 起始，结束于 $2$，不经过 $-1$，且每个点只经过一次的路径。要求出所有的合格的路径，可以采用回溯法，定义函数 $\textit{dfs}$，表示当前 $\textit{grid}$ 状态下，从点 $(i,j)$ 出发，还要经过 $n$ 个点，走到终点的路径条数。到达一个点时，如果当前的点为终点，且已经经过了 $(n+1)$ 个点，那么就构成了一条合格的路径，否则就不构成。如果当前的点不为终点，则将当前的点标记为 $-1$，表示这条路径以后不能再经过这个点，然后继续在这个点往四个方向扩展，如果不超过边界且下一个点的值为 $0$ 或者 $2$，则表示这条路径可以继续扩展。探测完四个方向后，需要将当前的点的值改为原来的值。将四个方向的合格路径求和，即为当前状态下合格路径的条数。最终需要返回的是，$\textit{grid}$ 在初始状态下，从起点出发，需要经过 $(n+1)$ 个点的路径条数。

**代码**

```Python [sol1-Python3]
class Solution:
    def uniquePathsIII(self, grid: List[List[int]]) -> int:
        r, c = len(grid), len(grid[0])
        si, sj, n = 0, 0, 0
        for i in range(r):
            for j in range(c):
                if grid[i][j] == 0:
                    n += 1
                elif grid[i][j] == 1:
                    n += 1
                    si, sj = i, j

        def dfs(i: int, j: int, n: int) -> int:
            if grid[i][j] == 2:
                if n == 0:
                    return 1
                return 0
            t = grid[i][j]
            grid[i][j] = -1
            res = 0
            for di, dj in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
                ni, nj = i + di, j + dj
                if 0 <= ni < r and 0 <= nj < c and grid[ni][nj] in [0, 2]:
                    res += dfs(ni, nj, n - 1)
            grid[i][j] = t
            return res

        return dfs(si, sj, n)
```

```Java [sol1-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int uniquePathsIII(int[][] grid) {
        int r = grid.length, c = grid[0].length;
        int si = 0, sj = 0, n = 0;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0) {
                    n++;
                } else if (grid[i][j] == 1) {
                    n++;
                    si = i;
                    sj = j;
                }
            }
        }
        return dfs(grid, si, sj, n);
    }

    public int dfs(int[][] grid, int i, int j, int n) {
        if (grid[i][j] == 2) {
            return n == 0 ? 1 : 0;
        }
        int r = grid.length, c = grid[0].length;
        int t = grid[i][j];
        grid[i][j] = -1;
        int res = 0;
        for (int[] dir : dirs) {
            int ni = i + dir[0], nj = j + dir[1];
            if (ni >= 0 && ni < r && nj >= 0 && nj < c && (grid[ni][nj] == 0 || grid[ni][nj] == 2)) {
                res += dfs(grid, ni, nj, n - 1);
            }
        }
        grid[i][j] = t;
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int UniquePathsIII(int[][] grid) {
        int r = grid.Length, c = grid[0].Length;
        int si = 0, sj = 0, n = 0;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0) {
                    n++;
                } else if (grid[i][j] == 1) {
                    n++;
                    si = i;
                    sj = j;
                }
            }
        }
        return DFS(grid, si, sj, n);
    }

    public int DFS(int[][] grid, int i, int j, int n) {
        if (grid[i][j] == 2) {
            return n == 0 ? 1 : 0;
        }
        int r = grid.Length, c = grid[0].Length;
        int t = grid[i][j];
        grid[i][j] = -1;
        int res = 0;
        foreach (int[] dir in dirs) {
            int ni = i + dir[0], nj = j + dir[1];
            if (ni >= 0 && ni < r && nj >= 0 && nj < c && (grid[ni][nj] == 0 || grid[ni][nj] == 2)) {
                res += DFS(grid, ni, nj, n - 1);
            }
        }
        grid[i][j] = t;
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int uniquePathsIII(vector<vector<int>>& grid) {
        int r = grid.size(), c = grid[0].size();
        int si = 0, sj = 0, n = 0;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0) {
                    n++;
                 } else if (grid[i][j] == 1) {
                    n++;
                    si = i;
                    sj = j;
                 }
            }
        }

        function<int(int, int, int)> dfs = [&](int i, int j, int n) -> int {
            if (grid[i][j] == 2) {
                if (n == 0) {
                    return 1;
                }
                return 0;
            }

            int t = grid[i][j], res = 0;
            grid[i][j] = -1;
            vector<array<int, 2>> dir({{-1, 0}, {1, 0}, {0, -1}, {0, 1}});
            for (auto &[di, dj] : dir) {
                int ni = i + di;
                int nj = j + dj;
                if (ni >= 0 && ni < r && nj >= 0 && nj < c && \
                   (grid[ni][nj] == 0 || grid[ni][nj] == 2)) {
                    res += dfs(ni, nj, n - 1);
                }
            }
            grid[i][j] = t;
            return res;
        };
        return dfs(si, sj, n);
    }
};
```

```C [sol1-C]
int dfs(int i, int j, int n, int** grid, int r, int c) {
    if (grid[i][j] == 2) {
        if (n == 0) {
            return 1;
        }
        return 0;
    }

    int t = grid[i][j], res = 0;
    grid[i][j] = -1;
    int dir[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    for (int k = 0; k < 4; k++) {
        int ni = i + dir[k][0];
        int nj = j + dir[k][1];
        if (ni >= 0 && ni < r && nj >= 0 && nj < c && \
            (grid[ni][nj] == 0 || grid[ni][nj] == 2)) {
            res += dfs(ni, nj, n - 1, grid, r, c);
        }
    }
    grid[i][j] = t;
    return res;
}

int uniquePathsIII(int** grid, int gridSize, int* gridColSize) {
    int r = gridSize, c = gridColSize[0];
    int si = 0, sj = 0, n = 0;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if (grid[i][j] == 0) {
                n++;
            } else if (grid[i][j] == 1) {
                n++;
                si = i;
                sj = j;
            }
        }
    }
    return dfs(si, sj, n, grid, r, c);
}
```

```JavaScript [sol1-JavaScript]
const dirs = [[-1, 0],[1, 0],[0, -1],[0, 1]];

var uniquePathsIII = function(grid) {
    const r = grid.length, c = grid[0].length;
    let si = 0, sj = 0, n = 0;
    for (let i = 0; i < r; i++) {
        for (let j = 0; j < c; j++) {
            if (grid[i][j] === 0) {
                n++;
            } else if (grid[i][j] === 1) {
                n++;
                si = i;
                sj = j;
            }
        }
    }
    return dfs(grid, si, sj, n);
};

function dfs(grid, i, j, n) {
    if (grid[i][j] === 2) {
        return n === 0 ? 1 : 0;
    }
    const r = grid.length, c = grid[0].length, t = grid[i][j];
    grid[i][j] = -1;
    let res = 0;
    for (const dir of dirs) {
        const ni = i + dir[0], nj = j + dir[1];
        if (ni >= 0 && ni < r && nj >= 0 && nj < c && (grid[ni][nj] === 0 || grid[ni][nj] === 2)) {
            res += dfs(grid, ni, nj, n - 1);
        }
    }
    grid[i][j] = t;
    return res;
}
```

```Go [sol1-Go]
var dir = [4][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

func uniquePathsIII(grid [][]int) int {
    r, c := len(grid), len(grid[0])
    si, sj, n := 0, 0, 0
    for i := 0; i < r; i++ {
        for j := 0; j < c; j++ {
            if grid[i][j] == 0 {
                n++
            } else if grid[i][j] == 1 {
                n++
                si, sj = i, j
            }
        }
    }
    var dfs func(i int, j int, n int) int
    dfs = func(i int, j int, n int) int {
		if grid[i][j] == 2 {
            if n == 0 {
                return 1
            }
            return 0
        }
        t, res := grid[i][j], 0
        grid[i][j] = -1
        for k := 0; k < 4; k++ {
            ni, nj := i + dir[k][0], j + dir[k][1]
            if ni >= 0 && ni < r && nj >= 0 && nj < c &&
                (grid[ni][nj] == 0 || grid[ni][nj] == 2) {
                res += dfs(ni, nj, n - 1)
            }
        }
        grid[i][j] = t
        return res
	}
    return dfs(si, sj, n)
}
```

**复杂度分析**

- 时间复杂度：$O(4^{r\times c})$，其中 $r$ 和 $c$ 分别是 $\textit{grid}$ 的行数和列数。

- 空间复杂度：$O(r\times c)$，是回溯的深度。

#### 方法二：记忆化搜索 + 状态压缩

**思路**

方法一的回溯函数，即使在 $i, j, n$ 都相同的情况下，函数的返回值也会不同，因为路径经过的点不同，导致当前情况下 $\textit{grid}$ 的状态也不同。因此，我们可以将$\textit{grid}$ 的状态放入函数的输入参数，从而用记忆化搜索来降低时间复杂度。

用一个二进制数字 $\textit{st}$ 来表示路径还未经过的点（初始状态下为所有值为 $0$ 的点和终点），点的坐标需要和二进制数字的位一一对应。定义函数 $\textit{dp}$，输入参数为当前坐标 $i,j$ 和未经过的点的二进制集合 $\textit{st}$，返回值即为从点 $(i,j)$ 出发，经过 $\textit{st}$ 代表的点的集合，最终到达终点的路径的条数。如果当前点为终点且剩下没有未经过的点，那么当前的返回值即为 $1$，否则为 $0$。如果当前的点不为终点，则需要探索四个方向，如果接下来的点在边界内且还未经过（用按位和操作判断），则需要走到那个点并且将那个点的坐标从未经过的点的集合中去掉（用按位异或操作）。将四个方向的合格路径求和，即为当前状态下合格路径的条数。最终需要返回的是，从起点出发，为经过的点的集合为所有值为 $0$ 的点和终点的路径条数。函数调用过程中采用了记忆化搜索，每个状态最多只会被计算一次。

**代码**

```Python [sol2-Python3]
class Solution:
    def uniquePathsIII(self, grid: List[List[int]]) -> int:
        r, c = len(grid), len(grid[0])
        si, sj, st = 0, 0, 0
        for i in range(r):
            for j in range(c):
                if grid[i][j] in [0, 2]:
                    st |= (1 << (i * c + j))
                elif grid[i][j] == 1:
                    si, sj = i, j

        @lru_cache(None)
        def dp(i: int, j: int, st: int) -> int:
            if grid[i][j] == 2:
                if st == 0:
                    return 1
                return 0
            res = 0
            for di, dj in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
                ni, nj = i + di, j + dj
                if 0 <= ni < r and 0 <= nj < c and (st & (1 << (ni * c + nj))) > 0:
                    res += dp(ni, nj, st ^ (1 << (ni * c + nj)))
            return res

        return dp(si, sj, st)
```

```Java [sol2-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    Map<Integer, Integer> memo = new HashMap<Integer, Integer>();

    public int uniquePathsIII(int[][] grid) {
        int r = grid.length, c = grid[0].length;
        int si = 0, sj = 0, st = 0;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0 || grid[i][j] == 2) {
                    st |= 1 << (i * c + j);
                } else if (grid[i][j] == 1) {
                    si = i;
                    sj = j;
                }
            }
        }
        return dp(grid, si, sj, st);
    }

    public int dp(int[][] grid, int i, int j, int st) {
        if (grid[i][j] == 2) {
            return st == 0 ? 1 : 0;
        }
        int r = grid.length, c = grid[0].length;
        int key = ((i * c + j) << (r * c)) + st;
        if (!memo.containsKey(key)) {
            int res = 0;
            for (int[] dir : dirs) {
                int ni = i + dir[0], nj = j + dir[1];
                if (ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0) {
                    res += dp(grid, ni, nj, st ^ (1 << (ni * c + nj)));
                }
            }
            memo.put(key, res);
        }
        return memo.get(key);
    }
}
```

```C# [sol2-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};
    IDictionary<int, int> memo = new Dictionary<int, int>();

    public int UniquePathsIII(int[][] grid) {
        int r = grid.Length, c = grid[0].Length;
        int si = 0, sj = 0, st = 0;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0 || grid[i][j] == 2) {
                    st |= 1 << (i * c + j);
                } else if (grid[i][j] == 1) {
                    si = i;
                    sj = j;
                }
            }
        }
        return DP(grid, si, sj, st);
    }

    public int DP(int[][] grid, int i, int j, int st) {
        if (grid[i][j] == 2) {
            return st == 0 ? 1 : 0;
        }
        int r = grid.Length, c = grid[0].Length;
        int key = ((i * c + j) << (r * c)) + st;
        if (!memo.ContainsKey(key)) {
            int res = 0;
            foreach (int[] dir in dirs) {
                int ni = i + dir[0], nj = j + dir[1];
                if (ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0) {
                    res += DP(grid, ni, nj, st ^ (1 << (ni * c + nj)));
                }
            }
            memo.Add(key, res);
        }
        return memo[key];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int uniquePathsIII(vector<vector<int>>& grid) {
        int r = grid.size(), c = grid[0].size();
        int si = 0, sj = 0, st = 0;
        unordered_map<int, int> memo;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (grid[i][j] == 0 || grid[i][j] == 2) {
                    st |= (1 << (i * c + j));
                } else if (grid[i][j] == 1) {
                    si = i, sj = j;
                }
            }
        }

        function<int(int ,int, int)> dp = [&](int i, int j, int st) -> int {
            if (grid[i][j] == 2) {
                if (st == 0) {
                    return 1;
                }
                return 0;
            }
            int key = ((i * c + j) << (r * c)) + st;
            if (!memo.count(key)) {
                int res = 0;
                vector<array<int, 2>> dir({{-1, 0}, {1, 0}, {0, -1}, {0, 1}});
                for (auto &[di, dj] : dir) {
                    int ni = i + di, nj = j + dj;
                    if (ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0) {
                        res += dp(ni, nj, st ^ (1 << (ni * c + nj)));
                    }
                }
                memo[key] = res;
            }
            return memo[key];
        };
        return dp(si, sj, st);
    }
};
```

```C [sol2-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

const static int dir[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int dp(int i, int j, int st, int** grid, int r, int c, HashItem **memo) {
    if (grid[i][j] == 2) {
        if (st == 0) {
            return 1;
        }
        return 0;
    }
    int key = ((i * c + j) << (r * c)) + st;
    if (!hashFindItem(memo, key)) {
        int res = 0;
        for (int k = 0; k < 4; k++) {
            int ni = i + dir[k][0], nj = j + dir[k][1];
            if (ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0) {
                res += dp(ni, nj, st ^ (1 << (ni * c + nj)), grid, r, c, memo);
            }
        }
        hashAddItem(memo, key, res);
    }
    return hashGetItem(memo, key, 0);
}

int uniquePathsIII(int** grid, int gridSize, int* gridColSize) {
    int r = gridSize, c = gridColSize[0];
    int si = 0, sj = 0, st = 0;
    HashItem *memo = NULL;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if (grid[i][j] == 0 || grid[i][j] == 2) {
                st |= (1 << (i * c + j));
            } else if (grid[i][j] == 1) {
                si = i, sj = j;
            }
        }
    }
    int ret = dp(si, sj, st, grid, r, c, &memo);
    hashFree(&memo);
    return ret;
}
```

```JavaScript [sol2-JavaScript]
const dirs = [[-1, 0],[1, 0],[0, -1],[0, 1]];
const memo = new Map();

var uniquePathsIII = function(grid) {
    memo.clear()
    const r = grid.length, c = grid[0].length;
    let si = 0, sj = 0, st = 0;
    for (let i = 0; i < r; i++) {
        for (let j = 0; j < c; j++) {
            if (grid[i][j] === 0 || grid[i][j] === 2) {
                st |= 1 << (i * c + j);
            } else if (grid[i][j] === 1) {
                si = i;
                sj = j;
            }
        }
    }
    return dp(grid, si, sj, st);
}

function dp(grid, i, j, st) {
    if (grid[i][j] === 2) {
        return st === 0 ? 1 : 0;
    }
    const r = grid.length, c = grid[0].length;
    const key = ((i * c + j) << (r * c)) + st;
    if (!memo.has(key)) {
        let res = 0;
        for (const dir of dirs) {
            const ni = i + dir[0],
                nj = j + dir[1];
            if (ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0) {
                res += dp(grid, ni, nj, st ^ (1 << (ni * c + nj)));
            }
        }
        memo.set(key, res);
    }
    return memo.get(key);
}
```

```Go [sol2-Go]
var dir = [4][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

func uniquePathsIII(grid [][]int) int {
    r, c := len(grid), len(grid[0])
    si, sj, st := 0, 0, 0
    memo := map[int]int{}
    for i := 0; i < r; i++ {
        for j := 0; j < c; j++ {
            if grid[i][j] == 0 || grid[i][j] == 2 {
                st |= (1 << (i * c + j))
            } else if grid[i][j] == 1 {
                si, sj = i, j
            }
        }
    }

    var dp func(i int, j int, st int) int
    dp = func(i int, j int, st int) int {
		if grid[i][j] == 2 {
            if st == 0 {
                return 1
            }
            return 0
        }
        key := ((i * c + j) << (r * c)) + st
        res, ok := memo[key]
        if !ok {
            res = 0
            for k := 0; k < 4; k++ {
                ni, nj := i + dir[k][0], j + dir[k][1]
                if ni >= 0 && ni < r && nj >= 0 && nj < c && (st & (1 << (ni * c + nj))) > 0 {
                    res += dp(ni, nj, st ^ (1 << (ni * c + nj)))
                }
            }
            memo[key] = res
        }
        return res
	}
    return dp(si, sj, st)
}
```

**复杂度分析**

- 时间复杂度：$O(r\times c \times 2^{r\times c})$，其中 $r$ 和 $c$ 分别是 $\textit{grid}$ 的行数和列数。$O(r\times c \times 2^{r\times c})$ 是状态数，每个状态只会被计算一次，计算一个状态的时间复杂度为 $O(1)$。

- 空间复杂度：$O(r\times c \times 2^{r\times c})$，是状态数。