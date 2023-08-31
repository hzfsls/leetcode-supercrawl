## [1791.找出星型图的中心节点 中文官方题解](https://leetcode.cn/problems/find-center-of-star-graph/solutions/100000/zhao-chu-xing-xing-tu-de-zhong-xin-jie-d-1xzm)

#### 方法一：计算每个节点的度

由 $n$ 个节点组成的星型图中，有一个中心节点，有 $n - 1$ 条边分别连接中心节点和其余的每个节点。因此，中心节点的度是 $n - 1$，其余每个节点的度都是 $1$。一个节点的度的含义是与该节点相连的边数。

遍历 $\textit{edges}$ 中的每条边并计算每个节点的度，度为 $n - 1$ 的节点即为中心节点。

```Python [sol1-Python3]
class Solution:
    def findCenter(self, edges: List[List[int]]) -> int:
        n = len(edges) + 1
        degrees = [0] * (n + 1)
        for x, y in edges:
            degrees[x] += 1
            degrees[y] += 1
        for i, d in enumerate(degrees):
            if d == n - 1:
                return i
```

```Java [sol1-Java]
class Solution {
    public int findCenter(int[][] edges) {
        int n = edges.length + 1;
        int[] degrees = new int[n + 1];
        for (int[] edge : edges) {
            degrees[edge[0]]++;
            degrees[edge[1]]++;
        }
        for (int i = 1; ; i++) {
            if (degrees[i] == n - 1) {
                return i;
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindCenter(int[][] edges) {
        int n = edges.Length + 1;
        int[] degrees = new int[n + 1];
        foreach (int[] edge in edges) {
            degrees[edge[0]]++;
            degrees[edge[1]]++;
        }
        for (int i = 1; ; i++) {
            if (degrees[i] == n - 1) {
                return i;
            }
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findCenter(vector<vector<int>>& edges) {
        int n = edges.size() + 1;
        vector<int> degrees(n + 1);
        for (auto & edge : edges) {
            degrees[edge[0]]++;
            degrees[edge[1]]++;
        }
        for (int i = 1; ; i++) {
            if (degrees[i] == n - 1) {
                return i;
            }
        }
    }
};
```

```C [sol1-C]
int findCenter(int** edges, int edgesSize, int* edgesColSize){
    int n = edgesSize + 1;
    int * degrees = (int *)malloc(sizeof(int) * (n + 1));
    memset(degrees,0,sizeof(int) * (n + 1));
    for (int i = 0; i < edgesSize; i++) {
        degrees[edges[i][0]]++;
        degrees[edges[i][1]]++;
    }
    for (int i = 1; ; i++) {
        if (degrees[i] == n - 1) {
            free(degrees);
            return i;
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var findCenter = function(edges) {
    const n = edges.length + 1;
    const degrees = new Array(n + 1).fill(0);
    for (const edge of edges) {
        degrees[edge[0]]++;
        degrees[edge[1]]++;
    }
    for (let i = 1; ; i++) {
        if (degrees[i] === n - 1) {
            return i;
        }
    }
};
```

```go [sol1-Golang]
func findCenter(edges [][]int) int {
    n := len(edges) + 1
    degrees := make([]int, n+1)
    for _, e := range edges {
        degrees[e[0]]++
        degrees[e[1]]++
    }
    for i, d := range degrees {
        if d == n-1 {
            return i
        }
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是星型图中的节点数量。需要遍历 $n - 1$ 条边计算每个节点的度，然后遍历 $n$ 个节点寻找中心节点。

- 空间复杂度：$O(n)$，其中 $n$ 是星型图中的节点数量。需要创建数组存储每个节点的度。

#### 方法二：寻找出现在两条边中的节点

由于只有星型图的中心节点的度是 $n - 1$，其余每个节点的度都是 $1$，因此只有星型图在所有的边中都出现，其余每个节点分别只在一条边中出现。

根据星型图的上述性质可知，对于星型图中的任意两条边，星型图的中心节点一定同时在这两条边中出现，其余节点一定不会同时在这两条边中出现。因此，可以任选两条边，然后寻找这两条边的公共节点，该节点即为星型图的中心节点。

具体做法是，选择 $\textit{edges}[0]$ 和 $\textit{edges}[1]$ 这两条边，则星型图的中心节点是 $\textit{edges}[0][0]$ 或者 $\textit{edges}[0][1]$。如果 $\textit{edges}[0][0]$ 和 $\textit{edges}[1]$ 的两个节点之一相同则 $\textit{edges}[0][0]$ 是星型图的中心节点，如果 $\textit{edges}[0][0]$ 和 $\textit{edges}[1]$ 的两个节点都不相同则 $\textit{edges}[0][1]$ 是星型图的中心节点。

```Python [sol2-Python3]
class Solution:
    def findCenter(self, edges: List[List[int]]) -> int:
        return edges[0][0] if edges[0][0] == edges[1][0] or edges[0][0] == edges[1][1] else edges[0][1]
```

```Java [sol2-Java]
class Solution {
    public int findCenter(int[][] edges) {
        return edges[0][0] == edges[1][0] || edges[0][0] == edges[1][1] ? edges[0][0] : edges[0][1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindCenter(int[][] edges) {
        return edges[0][0] == edges[1][0] || edges[0][0] == edges[1][1] ? edges[0][0] : edges[0][1];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int findCenter(vector<vector<int>>& edges) {
        return edges[0][0] == edges[1][0] || edges[0][0] == edges[1][1] ? edges[0][0] : edges[0][1];
    }
};
```

```C [sol2-C]
int findCenter(int** edges, int edgesSize, int* edgesColSize){
    return edges[0][0] == edges[1][0] || edges[0][0] == edges[1][1] ? edges[0][0] : edges[0][1];
}
```

```JavaScript [sol2-JavaScript]
var findCenter = function(edges) {
    return edges[0][0] === edges[1][0] || edges[0][0] === edges[1][1] ? edges[0][0] : edges[0][1];
};
```

```go [sol2-Golang]
func findCenter(edges [][]int) int {
    if edges[0][0] == edges[1][0] || edges[0][0] == edges[1][1] {
        return edges[0][0]
    }
    return edges[0][1]
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。