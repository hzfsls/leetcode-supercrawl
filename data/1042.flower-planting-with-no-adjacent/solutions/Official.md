## [1042.不邻接植花 中文官方题解](https://leetcode.cn/problems/flower-planting-with-no-adjacent/solutions/100000/bu-lin-jie-zhi-hua-by-leetcode-solution-bv74)

#### 方法一：颜色标记

**思路与算法**

由于每个花园最多有 $3$ 条路径可以进入或离开，这就说明每个花园最多有 $3$ 个花园与之相邻，而每个花园可选的种植种类有 $4$ 种，这就保证一定存在合法的种植方案满足题目要求。花园中种植不同的花可以视为每个花园只能标记为给定的4种颜色为 $1,2,3,4$ 中的一种，初始化时我们可以为每个花园标记为颜色 $0$。对于第 $i$ 个花园，统计其周围的花园已经被标记的颜色，然后从未标记的颜色中选一种颜色给其标记即可。整体标记过程如下：
+ 首先建立整个图的邻接列表 $\textit{adj}$ ；
+ 初始化时，将每个花园节点的颜色全部标记为 $0$；
+ 遍历每个花园，并统计其相邻的花园的颜色标记，并从未被标记的颜色中找到一种颜色给当前的花园进行标记；
+ 返回所有花园的颜色标记方案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> gardenNoAdj(int n, vector<vector<int>>& paths) {
        vector<vector<int>> adj(n);
        for (auto &path : paths) {
            adj[path[0] - 1].emplace_back(path[1] - 1);
            adj[path[1] - 1].emplace_back(path[0] - 1);
        }
        vector<int> ans(n);
        for (int i = 0; i < n; i++) {
            vector<bool> colored(5, false);
            for (auto &vertex : adj[i]) { 
                colored[ans[vertex]] = true;
            }
            for (int j = 1; j <= 4; j++) { 
                if (colored[j] == 0) { 
                    ans[i] = j;
                    break;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] gardenNoAdj(int n, int[][] paths) {
        List<Integer>[] adj = new List[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new ArrayList<Integer>();
        }
        for (int[] path : paths) {
            adj[path[0] - 1].add(path[1] - 1);
            adj[path[1] - 1].add(path[0] - 1);
        }
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            boolean[] colored = new boolean[5];
            for (int vertex : adj[i]) { 
                colored[ans[vertex]] = true;
            }
            for (int j = 1; j <= 4; j++) { 
                if (!colored[j]) { 
                    ans[i] = j;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def gardenNoAdj(self, n: int, paths: List[List[int]]) -> List[int]:
        adj = [[] for i in range(n)]
        for path in paths:
            adj[path[0] - 1].append(path[1] - 1)
            adj[path[1] - 1].append(path[0] - 1)
        ans = [0] * n
        for i in range(n):
            colored = [False] * 5
            for vertex in adj[i]:
                colored[ans[vertex]] = True
            for j in range(1, 5):
                if not colored[j]:
                    ans[i] = j
                    break
        return ans
```

```C# [sol1-C#]
public class Solution {
    public int[] GardenNoAdj(int n, int[][] paths) {
        IList<int>[] adj = new IList<int>[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new List<int>();
        }
        foreach (int[] path in paths) {
            adj[path[0] - 1].Add(path[1] - 1);
            adj[path[1] - 1].Add(path[0] - 1);
        }
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            bool[] colored = new bool[5];
            foreach (int vertex in adj[i]) { 
                colored[ans[vertex]] = true;
            }
            for (int j = 1; j <= 4; j++) { 
                if (!colored[j]) { 
                    ans[i] = j;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int* gardenNoAdj(int n, int** paths, int pathsSize, int* pathsColSize, int* returnSize) {
    int adj[n][3], adjSize[n];
    memset(adjSize, 0, sizeof(adjSize));
    for (int i = 0; i < pathsSize; i++) {
        int x = paths[i][0] - 1;
        int y = paths[i][1] - 1;
        adj[x][adjSize[x]++] = y;
        adj[y][adjSize[y]++] = x;
    }
    int *ans = (int *)calloc(sizeof(int), n);
    for (int i = 0; i < n; i++) {
        bool colored[5];
        memset(colored, 0, sizeof(colored));
        for (int j = 0; j < adjSize[i]; j++) { 
            int vertex = adj[i][j];
            colored[ans[vertex]] = true;
        }
        for (int j = 1; j <= 4; j++) { 
            if (colored[j] == 0) { 
                ans[i] = j;
                break;
            }
        }
    }
    *returnSize = n;
    return ans;
}
```

```Go [sol1-Go]
func gardenNoAdj(n int, paths [][]int) []int {
    adj := make([][]int, n)
    for i := 0; i < n; i++ {
        adj[i] = []int{}
    }
    for _, path := range paths {
        adj[path[0]-1] = append(adj[path[0]-1], path[1]-1)
        adj[path[1]-1] = append(adj[path[1]-1], path[0]-1)
    }
    ans := make([]int, n)
    for i := 0; i < n; i++ {
        colored := make([]bool, 5)
        for _, vertex := range adj[i] {
            colored[ans[vertex]] = true
        }
        for j := 1; j <= 4; j++ {
            if !colored[j] {
                ans[i] = j
                break
            }
        }
    }
    return ans
}

```

```JavaScript [sol1-JavaScript]
var gardenNoAdj = function(n, paths) {
    let adj = new Array(n).fill(null).map(() => []);
    for (let path of paths) {
        adj[path[0] - 1].push(path[1] - 1);
        adj[path[1] - 1].push(path[0] - 1);
    }
    let ans = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        let colored = new Array(5).fill(false);
        for (let vertex of adj[i]) {
            colored[ans[vertex]] = true;
        }
        for (let j = 1; j <= 4; j++) {
            if (!colored[j]) {
                ans[i] = j;
                break;
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 表示花园的数目，$m$ 表示 $paths$ 的数目。由于题目中每个花园的邻接节点数目不超过 $3$ 个，因此每个节点的边不超过 $3$ 条，所以遍历所有的节点与所有的边需要的总的时间不超过 $O(m + n)$。

- 空间复杂度：$O(n + m)$，其中 $n$ 表示花园的数目，$m$ 表示 $paths$ 的数目。需要存储每个节点的邻接节点，总共需要的空间为 $O(n + m)$。