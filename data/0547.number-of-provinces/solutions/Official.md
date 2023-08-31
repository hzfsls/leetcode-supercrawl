## [547.省份数量 中文官方题解](https://leetcode.cn/problems/number-of-provinces/solutions/100000/sheng-fen-shu-liang-by-leetcode-solution-eyk0)

#### 前言

可以把 $n$ 个城市和它们之间的相连关系看成图，城市是图中的节点，相连关系是图中的边，给定的矩阵 $\textit{isConnected}$ 即为图的邻接矩阵，省份即为图中的连通分量。

计算省份总数，等价于计算图中的连通分量数，可以通过深度优先搜索或广度优先搜索实现，也可以通过并查集实现。

#### 方法一：深度优先搜索

深度优先搜索的思路是很直观的。遍历所有城市，对于每个城市，如果该城市尚未被访问过，则从该城市开始深度优先搜索，通过矩阵 $\textit{isConnected}$ 得到与该城市直接相连的城市有哪些，这些城市和该城市属于同一个连通分量，然后对这些城市继续深度优先搜索，直到同一个连通分量的所有城市都被访问到，即可得到一个省份。遍历完全部城市以后，即可得到连通分量的总数，即省份的总数。

```Java [sol1-Java]
class Solution {
    public int findCircleNum(int[][] isConnected) {
        int cities = isConnected.length;
        boolean[] visited = new boolean[cities];
        int provinces = 0;
        for (int i = 0; i < cities; i++) {
            if (!visited[i]) {
                dfs(isConnected, visited, cities, i);
                provinces++;
            }
        }
        return provinces;
    }

    public void dfs(int[][] isConnected, boolean[] visited, int cities, int i) {
        for (int j = 0; j < cities; j++) {
            if (isConnected[i][j] == 1 && !visited[j]) {
                visited[j] = true;
                dfs(isConnected, visited, cities, j);
            }
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var findCircleNum = function(isConnected) {
    const cities = isConnected.length;
    const visited = new Set();
    let provinces = 0;
    for (let i = 0; i < cities; i++) {
        if (!visited.has(i)) {
            dfs(isConnected, visited, cities, i);
            provinces++;
        }
    }
    return provinces;
};

const dfs = (isConnected, visited, cities, i) => {
    for (let j = 0; j < cities; j++) {
        if (isConnected[i][j] == 1 && !visited.has(j)) {
            visited.add(j);
            dfs(isConnected, visited, cities, j);
        }
    }
};
```

```C++ [sol1-C++]
class Solution {
public:
    void dfs(vector<vector<int>>& isConnected, vector<int>& visited, int cities, int i) {
        for (int j = 0; j < cities; j++) {
            if (isConnected[i][j] == 1 && !visited[j]) {
                visited[j] = 1;
                dfs(isConnected, visited, cities, j);
            }
        }
    }

    int findCircleNum(vector<vector<int>>& isConnected) {
        int cities = isConnected.size();
        vector<int> visited(cities);
        int provinces = 0;
        for (int i = 0; i < cities; i++) {
            if (!visited[i]) {
                dfs(isConnected, visited, cities, i);
                provinces++;
            }
        }
        return provinces;
    }
};
```

```go [sol1-Golang]
func findCircleNum(isConnected [][]int) (ans int) {
    vis := make([]bool, len(isConnected))
    var dfs func(int)
    dfs = func(from int) {
        vis[from] = true
        for to, conn := range isConnected[from] {
            if conn == 1 && !vis[to] {
                dfs(to)
            }
        }
    }
    for i, v := range vis {
        if !v {
            ans++
            dfs(i)
        }
    }
    return
}
```

```C [sol1-C]
void dfs(int** isConnected, int* visited, int cities, int i) {
    for (int j = 0; j < cities; j++) {
        if (isConnected[i][j] == 1 && !visited[j]) {
            visited[j] = 1;
            dfs(isConnected, visited, cities, j);
        }
    }
}

int findCircleNum(int** isConnected, int isConnectedSize, int* isConnectedColSize) {
    int cities = isConnectedSize;
    int visited[cities];
    memset(visited, 0, sizeof(visited));
    int provinces = 0;
    for (int i = 0; i < cities; i++) {
        if (!visited[i]) {
            dfs(isConnected, visited, cities, i);
            provinces++;
        }
    }
    return provinces;
}
```

```Python [sol1-Python3]
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        def dfs(i: int):
            for j in range(cities):
                if isConnected[i][j] == 1 and j not in visited:
                    visited.add(j)
                    dfs(j)
        
        cities = len(isConnected)
        visited = set()
        provinces = 0

        for i in range(cities):
            if i not in visited:
                dfs(i)
                provinces += 1
        
        return provinces
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是城市的数量。需要遍历矩阵 $n$ 中的每个元素。

- 空间复杂度：$O(n)$，其中 $n$ 是城市的数量。需要使用数组 $\textit{visited}$ 记录每个城市是否被访问过，数组长度是 $n$，递归调用栈的深度不会超过 $n$。

#### 方法二：广度优先搜索

也可以通过广度优先搜索的方法得到省份的总数。对于每个城市，如果该城市尚未被访问过，则从该城市开始广度优先搜索，直到同一个连通分量中的所有城市都被访问到，即可得到一个省份。

```Java [sol2-Java]
class Solution {
    public int findCircleNum(int[][] isConnected) {
        int cities = isConnected.length;
        boolean[] visited = new boolean[cities];
        int provinces = 0;
        Queue<Integer> queue = new LinkedList<Integer>();
        for (int i = 0; i < cities; i++) {
            if (!visited[i]) {
                queue.offer(i);
                while (!queue.isEmpty()) {
                    int j = queue.poll();
                    visited[j] = true;
                    for (int k = 0; k < cities; k++) {
                        if (isConnected[j][k] == 1 && !visited[k]) {
                            queue.offer(k);
                        }
                    }
                }
                provinces++;
            }
        }
        return provinces;
    }
}
```

```JavaScript [sol2-JavaScript]
var findCircleNum = function(isConnected) {
    const cities = isConnected.length;
    const visited = new Set();
    let provinces = 0;
    const queue = new Array();
    for (let i = 0; i < cities; i++) {
        if (!visited.has(i)) {
            queue.push(i);
            while (queue.length) {
                const j = queue.shift();
                visited.add(j);
                for (let k = 0; k < cities; k++) {
                    if (isConnected[j][k] === 1 && !visited.has(k)) {
                        queue.push(k);
                    }
                }
            }
            provinces++;
        }
    }
    return provinces;
};
```

```C++ [sol2-C++]
class Solution {
public:
    int findCircleNum(vector<vector<int>>& isConnected) {
        int cities = isConnected.size();
        vector<int> visited(cities);
        int provinces = 0;
        queue<int> Q;
        for (int i = 0; i < cities; i++) {
            if (!visited[i]) {
                Q.push(i);
                while (!Q.empty()) {
                    int j = Q.front(); Q.pop();
                    visited[j] = 1;
                    for (int k = 0; k < cities; k++) {
                        if (isConnected[j][k] == 1 && !visited[k]) {
                            Q.push(k);
                        }
                    }
                }
                provinces++;
            }
        }
        return provinces;
    }
};
```

```go [sol2-Golang]
func findCircleNum(isConnected [][]int) (ans int) {
    vis := make([]bool, len(isConnected))
    for i, v := range vis {
        if !v {
            ans++
            queue := []int{i}
            for len(queue) > 0 {
                from := queue[0]
                queue = queue[1:]
                vis[from] = true
                for to, conn := range isConnected[from] {
                    if conn == 1 && !vis[to] {
                        queue = append(queue, to)
                    }
                }
            }
        }
    }
    return
}
```

```C [sol2-C]
int findCircleNum(int** isConnected, int isConnectedSize, int* isConnectedColSize) {
    int cities = isConnectedSize;
    int visited[cities];
    memset(visited, 0, sizeof(visited));
    int provinces = 0;
    int que[cities * cities];
    int left = 0, right = 0;
    for (int i = 0; i < cities; i++) {
        if (!visited[i]) {
            que[right++] = i;
            while (left < right) {
                int j = que[left++];
                visited[j] = true;
                for (int k = 0; k < cities; k++) {
                    if (isConnected[j][k] == 1 && !visited[k]) {
                        que[right++] = k;
                    }
                }
            }
            provinces++;
        }
    }
    return provinces;
}
```

```Python [sol2-Python3]
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        cities = len(isConnected)
        visited = set()
        provinces = 0
        
        for i in range(cities):
            if i not in visited:
                Q = collections.deque([i])
                while Q:
                    j = Q.popleft()
                    visited.add(j)
                    for k in range(cities):
                        if isConnected[j][k] == 1 and k not in visited:
                            Q.append(k)
                provinces += 1
        
        return provinces
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是城市的数量。需要遍历矩阵 $\textit{isConnected}$ 中的每个元素。

- 空间复杂度：$O(n)$，其中 $n$ 是城市的数量。需要使用数组 $\textit{visited}$ 记录每个城市是否被访问过，数组长度是 $n$，广度优先搜索使用的队列的元素个数不会超过 $n$。

#### 方法三：并查集

计算连通分量数的另一个方法是使用并查集。初始时，每个城市都属于不同的连通分量。遍历矩阵 $\textit{isConnected}$，如果两个城市之间有相连关系，则它们属于同一个连通分量，对它们进行合并。

遍历矩阵 $\textit{isConnected}$ 的全部元素之后，计算连通分量的总数，即为省份的总数。

```Java [sol3-Java]
class Solution {
    public int findCircleNum(int[][] isConnected) {
        int cities = isConnected.length;
        int[] parent = new int[cities];
        for (int i = 0; i < cities; i++) {
            parent[i] = i;
        }
        for (int i = 0; i < cities; i++) {
            for (int j = i + 1; j < cities; j++) {
                if (isConnected[i][j] == 1) {
                    union(parent, i, j);
                }
            }
        }
        int provinces = 0;
        for (int i = 0; i < cities; i++) {
            if (parent[i] == i) {
                provinces++;
            }
        }
        return provinces;
    }

    public void union(int[] parent, int index1, int index2) {
        parent[find(parent, index1)] = find(parent, index2);
    }

    public int find(int[] parent, int index) {
        if (parent[index] != index) {
            parent[index] = find(parent, parent[index]);
        }
        return parent[index];
    }
}
```

```JavaScript [sol3-JavaScript]
var findCircleNum = function(isConnected) {
    const cities = isConnected.length;
    const parent = new Array(cities).fill(0)
                                       .map((element, index) => index);

    for (let i = 0; i < cities; i++) {
        for (let j = i + 1; j < cities; j++) {
            if (isConnected[i][j] == 1) {
                union(parent, i, j);
            }
        }
    }
    let provinces = 0;
    parent.forEach((element, index) => {
        if (element === index) {
            provinces++;
        }
    });

    return provinces;
};

const union = (parent, index1, index2) => {
    parent[find(parent, index1)] = find(parent, index2);
}

const find = (parent, index) => {
    if (parent[index] !== index) {
        parent[index] = find(parent, parent[index]);
    }
    return parent[index];
}
```

```C++ [sol3-C++]
class Solution {
public:
    int Find(vector<int>& parent, int index) {
        if (parent[index] != index) {
            parent[index] = Find(parent, parent[index]);
        }
        return parent[index];
    }

    void Union(vector<int>& parent, int index1, int index2) {
        parent[Find(parent, index1)] = Find(parent, index2);
    }

    int findCircleNum(vector<vector<int>>& isConnected) {
        int cities = isConnected.size();
        vector<int> parent(cities);
        for (int i = 0; i < cities; i++) {
            parent[i] = i;
        }
        for (int i = 0; i < cities; i++) {
            for (int j = i + 1; j < cities; j++) {
                if (isConnected[i][j] == 1) {
                    Union(parent, i, j);
                }
            }
        }
        int provinces = 0;
        for (int i = 0; i < cities; i++) {
            if (parent[i] == i) {
                provinces++;
            }
        }
        return provinces;
    }
};
```

```go [sol3-Golang]
func findCircleNum(isConnected [][]int) (ans int) {
    n := len(isConnected)
    parent := make([]int, n)
    for i := range parent {
        parent[i] = i
    }
    var find func(int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    union := func(from, to int) {
        parent[find(from)] = find(to)
    }

    for i, row := range isConnected {
        for j := i + 1; j < n; j++ {
            if row[j] == 1 {
                union(i, j)
            }
        }
    }
    for i, p := range parent {
        if i == p {
            ans++
        }
    }
    return
}
```

```C [sol3-C]
int Find(int* parent, int index) {
    if (parent[index] != index) {
        parent[index] = Find(parent, parent[index]);
    }
    return parent[index];
}

void Union(int* parent, int index1, int index2) {
    parent[Find(parent, index1)] = Find(parent, index2);
}

int findCircleNum(int** isConnected, int isConnectedSize, int* isConnectedColSize) {
    int cities = isConnectedSize;
    int parent[cities];
    for (int i = 0; i < cities; i++) {
        parent[i] = i;
    }
    for (int i = 0; i < cities; i++) {
        for (int j = i + 1; j < cities; j++) {
            if (isConnected[i][j] == 1) {
                Union(parent, i, j);
            }
        }
    }
    int provinces = 0;
    for (int i = 0; i < cities; i++) {
        if (parent[i] == i) {
            provinces++;
        }
    }
    return provinces;
}
```

```Python [sol3-Python3]
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        def find(index: int) -> int:
            if parent[index] != index:
                parent[index] = find(parent[index])
            return parent[index]
        
        def union(index1: int, index2: int):
            parent[find(index1)] = find(index2)
        
        cities = len(isConnected)
        parent = list(range(cities))
        
        for i in range(cities):
            for j in range(i + 1, cities):
                if isConnected[i][j] == 1:
                    union(i, j)
        
        provinces = sum(parent[i] == i for i in range(cities))
        return provinces
```

**复杂度分析**

- 时间复杂度：$O(n^2 \log n)$，其中 $n$ 是城市的数量。需要遍历矩阵 $\textit{isConnected}$ 中的所有元素，时间复杂度是 $O(n^2)$，如果遇到相连关系，则需要进行 $2$ 次查找和最多 $1$ 次合并，一共需要进行 $2n^2$ 次查找和最多 $n^2$ 次合并，因此总时间复杂度是 $O(2n^2 \log n^2)=O(n^2 \log n)$。这里的并查集使用了路径压缩，但是没有使用按秩合并，最坏情况下的时间复杂度是 $O(n^2 \log n)$，平均情况下的时间复杂度依然是 $O(n^2 \alpha (n))$，其中 $\alpha$ 为阿克曼函数的反函数，$\alpha (n)$ 可以认为是一个很小的常数。

- 空间复杂度：$O(n)$，其中 $n$ 是城市的数量。需要使用数组 $\textit{parent}$ 记录每个城市所属的连通分量的祖先。