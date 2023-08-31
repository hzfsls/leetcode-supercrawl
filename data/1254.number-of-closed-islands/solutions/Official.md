## [1254.统计封闭岛屿的数目 中文官方题解](https://leetcode.cn/problems/number-of-closed-islands/solutions/100000/tong-ji-feng-bi-dao-yu-de-shu-mu-by-leet-ofh3)

#### 方法一：广度优先搜索

**思路与算法**

本题为「[200. 岛屿数量](https://leetcode.cn/problems/number-of-islands/solutions/13103/dao-yu-shu-liang-by-leetcode/)」的变形题目，解法几乎一样，本质是均为遍历图中的连通区域，唯一不同的是本题中的岛屿要求是「封闭」的，根据题意可以知道「封闭岛屿」定义如下：
+ 完全由 $1$ 包围（左、上、右、下）的岛；

我们可以将二维网格看成一个无向图，竖直或水平相邻的 $0$ 之间有边相连。根据「封闭」的定义可知，封闭岛屿」由 $0$ 组成的连通区域，且该区域不能与矩阵的边缘重合。为了求出「封闭岛屿」的数量，可以直接扫描整个二维矩阵，如果一个位置为 $0$，则将其加入队列开始进行广度优先搜索，分别向左、上、右、下四个方向进行扩展。在广度优先搜索的过程中，每个搜索到的 $0$ 都会被重新标记为 $1$，同时还需标记搜索出来的区域 $A$ 是否「封闭」。

设矩阵的行数与列数分别为 $m,n$，假设该区域中存在位置 $(i,j) \in A$，如果满足：
$$(i = 0) \lor (j = 0) \lor (i = m - 1) \lor  (j = n - 1)$$

则认为该连通区域一定不是「封闭岛屿」，否则即为「封闭岛屿」，最终返回「封闭岛屿」的数量即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    static constexpr int dir[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int closedIsland(vector<vector<int>>& grid) {
        int m = grid.size();
        int n = grid[0].size();
        int ans = 0;
                
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    queue<pair<int,int>> qu;
                    grid[i][j] = 1;
                    bool closed = true;

                    qu.push(make_pair(i, j));
                    while (!qu.empty()) {
                        auto [cx, cy] = qu.front();
                        qu.pop();
                        if (cx == 0 || cy == 0 || cx == m - 1 || cy == n - 1) {
                            closed = false;
                        }
                        for (int i = 0; i < 4; i++) {
                            int nx = cx + dir[i][0];
                            int ny = cy + dir[i][1];
                            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == 0) {
                                grid[nx][ny] = 1;
                                qu.emplace(nx, ny);
                            }
                        }
                    }
                    if (closed) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static int[][] dir = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int closedIsland(int[][] grid) {
        int m = grid.length;
        int n = grid[0].length;
        int ans = 0;
                
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    Queue<int[]> qu = new ArrayDeque<int[]>();
                    grid[i][j] = 1;
                    boolean closed = true;

                    qu.offer(new int[]{i, j});
                    while (!qu.isEmpty()) {
                        int[] arr = qu.poll();
                        int cx = arr[0], cy = arr[1];
                        if (cx == 0 || cy == 0 || cx == m - 1 || cy == n - 1) {
                            closed = false;
                        }
                        for (int d = 0; d < 4; d++) {
                            int nx = cx + dir[d][0];
                            int ny = cy + dir[d][1];
                            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == 0) {
                                grid[nx][ny] = 1;
                                qu.offer(new int[]{nx, ny});
                            }
                        }
                    }
                    if (closed) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dir = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int ClosedIsland(int[][] grid) {
        int m = grid.Length;
        int n = grid[0].Length;
        int ans = 0;
                
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    Queue<Tuple<int, int>> qu = new Queue<Tuple<int, int>>();
                    grid[i][j] = 1;
                    bool closed = true;

                    qu.Enqueue(new Tuple<int, int>(i, j));
                    while (qu.Count > 0) {
                        Tuple<int, int> tuple = qu.Dequeue();
                        int cx = tuple.Item1, cy = tuple.Item2;
                        if (cx == 0 || cy == 0 || cx == m - 1 || cy == n - 1) {
                            closed = false;
                        }
                        for (int d = 0; d < 4; d++) {
                            int nx = cx + dir[d][0];
                            int ny = cy + dir[d][1];
                            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == 0) {
                                grid[nx][ny] = 1;
                                qu.Enqueue(new Tuple<int, int>(nx, ny));
                            }
                        }
                    }
                    if (closed) {
                        ans++;
                    }
                }
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
const int dir[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize;
    int n = gridColSize[0];
    int ans = 0;
    int queue[m * n][2];
            
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) {
                grid[i][j] = 1;
                bool closed = true;
                int head = 0, tail = 0;
                queue[tail][0] = i;
                queue[tail][1] = j;
                tail++;
                while (head != tail) {
                    int cx = queue[head][0];
                    int cy = queue[head][1];
                    head++;
                    if (cx == 0 || cy == 0 || cx == m - 1 || cy == n - 1) {
                        closed = false;
                    }
                    for (int i = 0; i < 4; i++) {
                        int nx = cx + dir[i][0];
                        int ny = cy + dir[i][1];
                        if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == 0) {
                            grid[nx][ny] = 1;
                            queue[tail][0] = nx;
                            queue[tail][1] = ny;
                            tail++;
                        }
                    }
                }
                if (closed) {
                    ans++;
                }
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
const dir = [[-1, 0], [1, 0], [0, -1], [0, 1]];
var closedIsland = function(grid) {
    const m = grid.length;
    const n = grid[0].length;
    let ans = 0;
            
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) {
                const qu = [];
                grid[i][j] = 1;
                let closed = true;

                qu.push([i, j]);
                while (qu.length) {
                    const arr = qu.shift();
                    let cx = arr[0], cy = arr[1];
                    if (cx === 0 || cy === 0 || cx === m - 1 || cy === n - 1) {
                        closed = false;
                    }
                    for (let d = 0; d < 4; d++) {
                        let nx = cx + dir[d][0];
                        let ny = cy + dir[d][1];
                        if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] === 0) {
                            grid[nx][ny] = 1;
                            qu.push([nx, ny]);
                        }
                    }
                }
                if (closed) {
                    ans++;
                }
            }
        }
    }
    return ans;
};
```

```Python [sol1-Python3]
class Solution:
    def closedIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        ans = 0

        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    qu = deque([(i, j)])
                    grid[i][j] = 1
                    closed = True

                    while qu:
                        cx, cy = qu.popleft()
                        if cx == 0 or cy == 0 or cx == m - 1 or cy == n - 1:
                            closed = False
                        for nx, ny in [(cx - 1, cy), (cx + 1, cy), (cx, cy - 1), (cx, cy + 1)]:
                            if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] == 0:
                                grid[nx][ny] = 1
                                qu.append((nx, ny))
                    if closed:
                        ans += 1
        
        return ans
```

```Go [sol1-Go]
func closedIsland(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	ans := 0

	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == 0 {
				qu := [][]int{{i, j}}
				grid[i][j] = 1
				closed := true

				for len(qu) > 0 {
					cx, cy := qu[0][0], qu[0][1]
					qu = qu[1:]

					if cx == 0 || cy == 0 || cx == m-1 || cy == n-1 {
						closed = false
					}

					directions := [][]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
					for _, dir := range directions {
						nx, ny := cx+dir[0], cy+dir[1]
						if 0 <= nx && nx < m && 0 <= ny && ny < n && grid[nx][ny] == 0 {
							grid[nx][ny] = 1
							qu = append(qu, []int{nx, ny})
						}
					}
				}

				if closed {
					ans++
				}
			}
		}
	}

	return ans
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m,n$ 分别为矩阵的行数与列数。利用深度优先搜索只需对整个矩阵遍历一遍即可，因此时间复杂度为 $O(mn)$。

- 空间复杂度：$O(1)$。直接在原矩阵中进行标记即可，不需要额外的空间。

#### 方法二：深度优先搜索

**思路与算法**

同样地，我们也可以使用深度度优先搜索代替广度度优先搜索。为了求出「封闭岛屿」的数量，可以直接扫描整个二维矩阵，如果一个位置为 $0$，则以其为起始节点开始进行深度优先搜索，分别向左、上、右、下四个方向进行扩展。在深度优先搜索的过程中，每个搜索到的 $0$ 都会被重新标记为 $1$，同时还需检测搜索出来的区域 $A$ 是否「封闭」。

设矩阵的行数与列数分别为 $m,n$，假设当前位置扩展出了矩阵的有效范围，则可以知道该区域一定存在没有被 $1$ 包围的区域，此时则认为该连通区域一定不是「封闭岛屿」，否则即为「封闭岛屿」，最终返回「封闭岛屿」的数量即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int closedIsland(vector<vector<int>>& grid) {
        int ans = 0;
        int m = grid.size();
        int n = grid[0].size();

        function<bool(int, int)> dfs = [&](int x, int y) -> bool {
            if (x < 0 || y < 0 || x >= m || y >= n) {
                return false;
            }
            if (grid[x][y] != 0) {
                return true;
            }
            grid[x][y] = -1;
            bool ret1 = dfs(x - 1, y);
            bool ret2 = dfs(x + 1, y);
            bool ret3 = dfs(x, y - 1);
            bool ret4 = dfs(x, y + 1);
            return ret1 && ret2 && ret3 && ret4;
        };

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 && dfs(i, j)) {
                    ans++;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int closedIsland(int[][] grid) {
        int ans = 0;
        int m = grid.length;
        int n = grid[0].length;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 && dfs(i, j, grid, m, n)) {
                    ans++;
                }
            }
        }
        return ans;
    }

    public boolean dfs(int x, int y, int[][] grid, int m, int n) {
        if (x < 0 || y < 0 || x >= m || y >= n) {
            return false;
        }
        if (grid[x][y] != 0) {
            return true;
        }
        grid[x][y] = -1;
        boolean ret1 = dfs(x - 1, y, grid, m, n);
        boolean ret2 = dfs(x + 1, y, grid, m, n);
        boolean ret3 = dfs(x, y - 1, grid, m, n);
        boolean ret4 = dfs(x, y + 1, grid, m, n);
        return ret1 && ret2 && ret3 && ret4;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ClosedIsland(int[][] grid) {
        int ans = 0;
        int m = grid.Length;
        int n = grid[0].Length;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0 && DFS(i, j, grid, m, n)) {
                    ans++;
                }
            }
        }
        return ans;
    }

    public bool DFS(int x, int y, int[][] grid, int m, int n) {
        if (x < 0 || y < 0 || x >= m || y >= n) {
            return false;
        }
        if (grid[x][y] != 0) {
            return true;
        }
        grid[x][y] = -1;
        bool ret1 = DFS(x - 1, y, grid, m, n);
        bool ret2 = DFS(x + 1, y, grid, m, n);
        bool ret3 = DFS(x, y - 1, grid, m, n);
        bool ret4 = DFS(x, y + 1, grid, m, n);
        return ret1 && ret2 && ret3 && ret4;
    }
}
```

```C [sol2-C]
bool dfs(int x, int y, int** grid, int m, int n) {
    if (x < 0 || y < 0 || x >= m || y >= n) {
        return false;
    }
    if (grid[x][y] != 0) {
        return true;
    }
    grid[x][y] = -1;
    bool ret1 = dfs(x - 1, y, grid, m, n);
    bool ret2 = dfs(x + 1, y, grid, m, n);
    bool ret3 = dfs(x, y - 1, grid, m, n);
    bool ret4 = dfs(x, y + 1, grid, m, n);
    return ret1 && ret2 && ret3 && ret4;
};

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int ans = 0;
    int m = gridSize;
    int n = gridColSize[0];

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0 && dfs(i, j, grid, m, n)) {
                ans++;
            }
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var closedIsland = function(grid) {
    let ans = 0;
    const m = grid.length;
    const n = grid[0].length;

    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0 && dfs(i, j, grid, m, n)) {
                ans++;
            }
        }
    }
    return ans;
}

const dfs = (x, y, grid, m, n) => {
    if (x < 0 || y < 0 || x >= m || y >= n) {
        return false;
    }
    if (grid[x][y] != 0) {
        return true;
    }
    grid[x][y] = -1;
    const ret1 = dfs(x - 1, y, grid, m, n);
    const ret2 = dfs(x + 1, y, grid, m, n);
    const ret3 = dfs(x, y - 1, grid, m, n);
    const ret4 = dfs(x, y + 1, grid, m, n);
    return ret1 && ret2 && ret3 && ret4;
};
```

```Python [sol2-Python3]
class Solution:
    def closedIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        ans = 0

        def dfs(x: int, y: int) -> bool:
            if x < 0 or y < 0 or x >= m or y >= n:
                return False
            if grid[x][y] != 0:
                return True
            
            grid[x][y] = -1
            ret1, ret2, ret3, ret4 = dfs(x - 1, y), dfs(x + 1, y), dfs(x, y - 1), dfs(x, y + 1)
            return ret1 and ret2 and ret3 and ret4
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0 and dfs(i, j):
                    ans += 1
        
        return ans
```

```Go [sol2-Go]
func closedIsland(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	ans := 0

	var dfs func(x, y int) bool
	dfs = func(x, y int) bool {
		if x < 0 || y < 0 || x >= m || y >= n {
			return false
		}
		if grid[x][y] != 0 {
			return true
		}

		grid[x][y] = -1
		ret1, ret2, ret3, ret4 := dfs(x-1, y), dfs(x+1, y), dfs(x, y-1), dfs(x, y+1)
		return ret1 && ret2 && ret3 && ret4
	}

	for i := range grid {
		for j := range grid[i] {
			if grid[i][j] == 0 && dfs(i, j) {
				ans++
			}
		}
	}

	return ans
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m,n$ 分别为矩阵的行数与列数。利用深度优先搜索只需对整个矩阵遍历一遍即可，因此时间复杂度为 $O(mn)$。

- 空间复杂度：$O(1)$。直接在原矩阵中进行标记即可，不需要额外的空间。

#### 方法三：并查集

**思路与算法**

由于岛屿由相邻的陆地连接形成，因此封闭岛屿的数目为不与边界相连的陆地组成的连通分量数，连通性问题可以使用并查集解决。假设可以对每个连通区域进行标记，如果该连通区域与边界连通，则该连通区域一定不是「封闭岛屿」，否则该连通区域为「封闭岛屿」。

并查集初始化时，每个不在边界上的陆地元素分别属于不同的集合，边界上的陆地元素的状态是与边界连通，其余单元格的状态都是不与边界连通，集合个数等于不在边界上的陆地元素个数。为了方便处理，我们将所有在边界上的陆地元素归入同一个集合，称为边界集合，为方便处理初始化时将边界上的为 $0$ 的元素全部纳入到集合 $0$ 中。

初始化之后，遍历每个元素，如果一个位置 $(x, y)$ 是陆地元素且其上边的相邻位置 $(x - 1, y)$ 或左边的相邻位置 $(x, y - 1)$ 是陆地元素，则将两个相邻陆地元素所在的集合做合并。因为所有在边界上的陆地元素都属于边界集合，所以每次合并都会将一个不在边界上的陆地元素合并到边界集合。

遍历结束之后，我们利用哈希表统计所有陆地元素构成的连通集合的数目为 $\textit{total}$，此时还需要检测边界集合 $0$ 是否也包含在 $\textit{total}$ 中，如果 $\textit{total}$ 包含边界集合 $0$ 中，则返回 $\textit{total} - 1$，否则返回 $\textit{total}$。

**代码**

```C++ [sol3-C++]
class UnionFind {
public:
    UnionFind(int n) {
        this->parent = vector<int>(n);
        iota(parent.begin(), parent.end(), 0);
        this->rank = vector<int>(n);
    }

    void uni(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
private:
    vector<int> parent;
    vector<int> rank;
};

class Solution {
public:
    int closedIsland(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        UnionFind uf(m * n);

        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 0) {
                uf.uni(i * n, 0);
            }
            if (grid[i][n - 1] == 0) {
                uf.uni(i * n + n - 1, 0);
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 0) {
                uf.uni(j, 0);
            }
            if (grid[m - 1][j] == 0) {
                uf.uni((m - 1) * n + j, 0);
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    if (i > 0 && grid[i - 1][j] == 0) {
                        uf.uni(i * n + j, (i - 1) * n + j);
                    }
                    if (j > 0 && grid[i][j - 1] == 0) {
                        uf.uni(i * n + j, i * n + j - 1);
                    }
                }
            }
        }

        unordered_set<int> cnt;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    cnt.emplace(uf.find(i * n + j));
                }
            }
        }
        int total = cnt.size();
        if (cnt.count(uf.find(0))) {
            total--;
        }
        return total;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int closedIsland(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        UnionFind uf = new UnionFind(m * n);

        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 0) {
                uf.uni(i * n, 0);
            }
            if (grid[i][n - 1] == 0) {
                uf.uni(i * n + n - 1, 0);
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 0) {
                uf.uni(j, 0);
            }
            if (grid[m - 1][j] == 0) {
                uf.uni((m - 1) * n + j, 0);
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    if (i > 0 && grid[i - 1][j] == 0) {
                        uf.uni(i * n + j, (i - 1) * n + j);
                    }
                    if (j > 0 && grid[i][j - 1] == 0) {
                        uf.uni(i * n + j, i * n + j - 1);
                    }
                }
            }
        }

        Set<Integer> cnt = new HashSet<Integer>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    cnt.add(uf.find(i * n + j));
                }
            }
        }
        int total = cnt.size();
        if (cnt.contains(uf.find(0))) {
            total--;
        }
        return total;
    }
}

class UnionFind {
    private int[] parent;
    private int[] rank;

    public UnionFind(int n) {
        this.parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
        this.rank = new int[n];
    }

    public void uni(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    public int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int ClosedIsland(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        UnionFind uf = new UnionFind(m * n);

        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 0) {
                uf.Uni(i * n, 0);
            }
            if (grid[i][n - 1] == 0) {
                uf.Uni(i * n + n - 1, 0);
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 0) {
                uf.Uni(j, 0);
            }
            if (grid[m - 1][j] == 0) {
                uf.Uni((m - 1) * n + j, 0);
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    if (i > 0 && grid[i - 1][j] == 0) {
                        uf.Uni(i * n + j, (i - 1) * n + j);
                    }
                    if (j > 0 && grid[i][j - 1] == 0) {
                        uf.Uni(i * n + j, i * n + j - 1);
                    }
                }
            }
        }

        ISet<int> cnt = new HashSet<int>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 0) {
                    cnt.Add(uf.Find(i * n + j));
                }
            }
        }
        int total = cnt.Count;
        if (cnt.Contains(uf.Find(0))) {
            total--;
        }
        return total;
    }
}

class UnionFind {
    private int[] parent;
    private int[] rank;

    public UnionFind(int n) {
        this.parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
        this.rank = new int[n];
    }

    public void Uni(int x, int y) {
        int rootx = Find(x);
        int rooty = Find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    public int Find(int x) {
        if (parent[x] != x) {
            parent[x] = Find(parent[x]);
        }
        return parent[x];
    }
}
```

```C [sol3-C]
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

typedef struct UnionFind {
    int *parent;
    int *rank;
} UnionFind;

struct UnionFind* creatUnionFind(int n) {
    UnionFind *obj = (UnionFind *)malloc(sizeof(UnionFind));
    obj->parent = (int *)calloc(n, sizeof(int));
    for (int i = 0; i < n; i++) {
        obj->parent[i] = i;
    }
    obj->rank = (int *)calloc(n, sizeof(int));
    return obj;
}

int find(const UnionFind* obj, int x) {
    if (obj->parent[x] != x) {
        obj->parent[x] = find(obj, obj->parent[x]);
    }
    return obj->parent[x];
}

void freeUnionFind(UnionFind* obj) {
    free(obj->parent);
    free(obj->rank);
    free(obj);
}

void uni(UnionFind* obj, int x, int y) {
    int rootx = find(obj, x);
    int rooty = find(obj, y);
    if (rootx != rooty) {
        if (obj->rank[rootx] > obj->rank[rooty]) {
            obj->parent[rooty] = rootx;
        } else if (obj->rank[rootx] < obj->rank[rooty]) {
            obj->parent[rootx] = rooty;
        } else {
            obj->parent[rooty] = rootx;
            obj->rank[rootx]++;
        }
    }
}

int closedIsland(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    UnionFind *uf = creatUnionFind(m * n);
    
    for (int i = 0; i < m; i++) {
        if (grid[i][0] == 0) {
            uni(uf, i * n, 0);
        }
        if (grid[i][n - 1] == 0) {
            uni(uf, i * n + n - 1, 0);
        }
    }
    for (int j = 1; j < n - 1; j++) {
        if (grid[0][j] == 0) {
            uni(uf, j, 0);
        }
        if (grid[m - 1][j] == 0) {
            uni(uf, (m - 1) * n + j, 0);
        }
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) {
                if (i > 0 && grid[i - 1][j] == 0) {
                    uni(uf, i * n + j, (i - 1) * n + j);
                }
                if (j > 0 && grid[i][j - 1] == 0) {
                    uni(uf, i * n + j, i * n + j - 1);
                }
            }
        }
    }

    HashItem *cnt = NULL;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 0) {
                hashAddItem(&cnt, find(uf, i * n + j));
            }
        }
    }
    int total = HASH_COUNT(cnt);
    if (hashFindItem(&cnt, find(uf, 0))) {
        total--;
    }
    freeUnionFind(uf);
    hashFree(&cnt);
    return total;
}
```

```JavaScript [sol3-JavaScript]
var closedIsland = function(grid) {
    const m = grid.length;
    const n = grid[0].length;
    const uf = new UnionFind(m * n);

    for (let i = 0; i < m; i++) {
        if (grid[i][0] === 0) {
            uf.uni(i * n, 0);
        }
        if (grid[i][n - 1] === 0) {
            uf.uni(i * n + n - 1, 0);
        }
    }
    for (let j = 1; j < n - 1; j++) {
        if (grid[0][j] === 0) {
            uf.uni(j, 0);
        }
        if (grid[m - 1][j] === 0) {
            uf.uni((m - 1) * n + j, 0);
        }
    }
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) {
                if (i > 0 && grid[i - 1][j] === 0) {
                    uf.uni(i * n + j, (i - 1) * n + j);
                }
                if (j > 0 && grid[i][j - 1] === 0) {
                    uf.uni(i * n + j, i * n + j - 1);
                }
            }
        }
    }

    const cnt = new Set();
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) {
                cnt.add(uf.find(i * n + j));
            }
        }
    }
    let total = cnt.size;
    if (cnt.has(uf.find(0))) {
        total--;
    }
    return total;
};

class UnionFind {
    constructor(n) {
        this.parent = new Array(n);
        for (let i = 0; i < n; i++) {
            this.parent[i] = i;
        }
        this.rank = new Array(n).fill(0);
    }

    uni(x, y) {
        const rootx = this.find(x);
        const rooty = this.find(y);
        if (rootx !== rooty) {
            if (this.rank[rootx] > this.rank[rooty]) {
                this.parent[rooty] = rootx;
            } else if (this.rank[rootx] < this.rank[rooty]) {
                this.parent[rootx] = rooty;
            } else {
                this.parent[rooty] = rootx;
                this.rank[rootx]++;
            }
        }
    }

    find(x) {
        if (this.parent[x] !== x) {
            this.parent[x] = this.find(this.parent[x]);
        }
        return this.parent[x];
    }
}
```

```Python [sol3-Python3]
class UnionFind:
    def __init__(self, n: int) -> None:
        self.parent = list(range(n))
        self.rank = [0] * n
    
    def uni(self, x: int, y: int) -> None:
        parent_ = self.parent
        rank_ = self.rank

        rootx, rooty = self.find(x), self.find(y)
        if rootx != rooty:
            if rank_[rootx] > rank_[rooty]:
                parent_[rooty] = rootx
            elif rank_[rootx] < rank_[rooty]:
                parent_[rootx] = rooty
            else:
                parent_[rooty] = rootx
                rank_[rootx] += 1

    def find(self, x: int) -> int:
        parent_ = self.parent

        if parent_[x] != x:
            parent_[x] = self.find(parent_[x])
        return parent_[x]

class Solution:
    def closedIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        uf = UnionFind(m * n)

        for i in range(m):
            if grid[i][0] == 0:
                uf.uni(i * n, 0)
            if grid[i][n - 1] == 0:
                uf.uni(i * n + n - 1, 0)
        
        for j in range(1, n - 1):
            if grid[0][j] == 0:
                uf.uni(j, 0)
            if grid[m - 1][j] == 0:
                uf.uni((m - 1) * n + j, 0)
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    if i > 0 and grid[i - 1][j] == 0:
                        uf.uni(i * n + j, (i - 1) * n + j)
                    if j > 0 and grid[i][j - 1] == 0:
                        uf.uni(i * n + j, i * n + j - 1)

        cnt = set()
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    cnt.add(uf.find(i * n + j))
        
        total = len(cnt)
        if uf.find(0) in cnt:
            total -= 1
        return total
```

**复杂度分析**

- 时间复杂度：时间复杂度：$O(mn \times \alpha(mn))$，其中 $m$ 和 $n$ 分别是矩阵的行数和列数，$\alpha$ 是反阿克曼函数。并查集的初始化需要 $O(m \times n)$ 的时间，然后遍历 $m \times n$ 个元素，最多执行 $m \times n$ 次合并操作，这里的并查集使用了路径压缩和按秩合并，单次操作的时间复杂度是 $O(\alpha(m \times n))$，因此并查集合并的操作的时间复杂度是 $O(mn \times \alpha(mn))$，总时间复杂度是 $O(mn + mn \times \alpha(mn)) = O(mn \times \alpha(mn))$。

- 空间复杂度：$O(mn)$，其中 $m,n$ 分别为矩阵的行数与列数。并查集需要 $O(mn)$ 的空间用来存储集合关系。