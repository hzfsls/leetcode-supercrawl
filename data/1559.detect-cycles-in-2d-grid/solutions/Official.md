## [1559.二维网格图中探测环 中文官方题解](https://leetcode.cn/problems/detect-cycles-in-2d-grid/solutions/100000/er-wei-wang-ge-tu-zhong-tan-ce-huan-by-leetcode-so)
#### 前言

对于大小为 $m \times n$ 的网格数组 $\textit{grid}$，如果我们将其中的每个位置看成一个节点，任意两个上下左右相邻且值相同的节点之间有一条无向边，那么 $\textit{grid}$ 中的一个环就对应着我们构造出的图中的一个环。因此，我们只需要判断图中是否有环即可。

常用的判断无向图中是否有环的方法有深度优先搜索和广度优先搜索，但这里我们会介绍一种基于并查集的判断方法。

#### 方法一：并查集

**思路与算法**

使用并查集判断无向图中是否有环的方法非常简洁且直观：

- 对于图中的任意一条边 $(x, y)$，我们将 $x$ 和 $y$ 对应的集合合并。如果 $x$ 和 $y$ 已经属于同一集合，那么说明 $x$ 和 $y$ 已经连通，在边 $(x, y)$ 的帮助下，图中会形成一个环。

这样一来，我们只要遍历图中的每一条边并进行上述的操作即可。具体的方法是，我们遍历数组 $\textit{grid}$ 中的每一个位置，如果该位置与其上方或左侧的值相同，那么就有了一条边，并将这两个位置进行合并。这样的方法可以保证每一条边的两个节点只会被合并一次。

由于并查集是一维的数据结构，而数组 $\textit{grid}$ 是二维的。因此对于数组中的每个位置 $(i, j)$，我们可以用 $i \times n + j$ 将其映射至一维空间中：

- $(i, j)$ 上方的位置对应着 $(i - 1) \times n + j$；

- $(i, j)$ 左侧的位置对应着 $i \times n + j - 1$。

**代码**

```C++ [sol1-C++]
class UnionFind {
public:
    vector<int> parent;
    vector<int> size;
    int n;
    int setCount;
    
public:
    UnionFind(int _n): n(_n), setCount(_n), parent(_n), size(_n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int findset(int x) {
        return parent[x] == x ? x : parent[x] = findset(parent[x]);
    }
    
    void unite(int x, int y) {
        if (size[x] < size[y]) {
            swap(x, y);
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
    }
    
    bool findAndUnite(int x, int y) {
        int parentX = findset(x);
        int parentY = findset(y);
        if (parentX != parentY) {
            unite(parentX, parentY);
            return true;
        }
        return false;
    }
};

class Solution {
public:
    bool containsCycle(vector<vector<char>>& grid) {
        int m = grid.size();
        int n = grid[0].size();
        UnionFind uf(m * n);
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i > 0 && grid[i][j] == grid[i - 1][j]) {
                    if (!uf.findAndUnite(i * n + j, (i - 1) * n + j)) {
                        return true;
                    }
                }
                if (j > 0 && grid[i][j] == grid[i][j - 1]) {
                    if (!uf.findAndUnite(i * n + j, i * n + j - 1)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean containsCycle(char[][] grid) {
        int m = grid.length;
        int n = grid[0].length;
        UnionFind uf = new UnionFind(m * n);
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i > 0 && grid[i][j] == grid[i - 1][j]) {
                    if (!uf.findAndUnite(i * n + j, (i - 1) * n + j)) {
                        return true;
                    }
                }
                if (j > 0 && grid[i][j] == grid[i][j - 1]) {
                    if (!uf.findAndUnite(i * n + j, i * n + j - 1)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}

class UnionFind {
    int[] parent;
    int[] size;
    int n;
    int setCount;

    public UnionFind(int n) {
        parent = new int[n];
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
        }
        size = new int[n];
        Arrays.fill(size, 1);
        this.n = n;
        setCount = n;
    }

    public int findset(int x) {
        return parent[x] == x ? x : (parent[x] = findset(parent[x]));
    }

    public void unite(int x, int y) {
        if (size[x] < size[y]) {
            int temp = x;
            x = y;
            y = temp;
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
    }

    public boolean findAndUnite(int x, int y) {
        int parentX = findset(x);
        int parentY = findset(y);
        if (parentX != parentY) {
            unite(parentX, parentY);
            return true;
        }
        return false;
    }
}
```

```Python [sol1-Python3]
class UnionFind:
    def __init__(self, n: int):
        self.n = n
        self.setCount = n
        self.parent = list(range(n))
        self.size = [1] * n
    
    def findset(self, x: int) -> int:
        if self.parent[x] == x:
            return x
        self.parent[x] = self.findset(self.parent[x])
        return self.parent[x]
    
    def unite(self, x: int, y: int):
        if self.size[x] < self.size[y]:
            x, y = y, x
        self.parent[y] = x
        self.size[x] += self.size[y]
        self.setCount -= 1
    
    def findAndUnite(self, x: int, y: int) -> bool:
        parentX, parentY = self.findset(x), self.findset(y)
        if parentX != parentY:
            self.unite(parentX, parentY)
            return True
        return False

class Solution:
    def containsCycle(self, grid: List[List[str]]) -> bool:
        m, n = len(grid), len(grid[0])
        uf = UnionFind(m * n)
        for i in range(m):
            for j in range(n):
                if i > 0 and grid[i][j] == grid[i - 1][j]:
                    if not uf.findAndUnite(i * n + j, (i - 1) * n + j):
                        return True
                if j > 0 and grid[i][j] == grid[i][j - 1]:
                    if not uf.findAndUnite(i * n + j, i * n + j - 1):
                        return True
        return False
```

**复杂度分析**

- 时间复杂度：$O(mn \cdot \alpha(mn))$。上述代码中的并查集使用了路径压缩（path compression）以及按秩合并（union by size/rank）优化，单次合并操作的均摊时间复杂度为 $\alpha(mn)$。每一个位置最多进行两次合并操作，因此总时间复杂度为 $O(mn \cdot \alpha(mn))$。

- 空间复杂度：$O(mn)$，即为并查集使用的空间。