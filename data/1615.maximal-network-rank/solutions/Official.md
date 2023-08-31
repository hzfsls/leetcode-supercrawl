## [1615.最大网络秩 中文官方题解](https://leetcode.cn/problems/maximal-network-rank/solutions/100000/zui-da-wang-luo-zhi-by-leetcode-solution-x4gx)

#### 方法一：枚举

**思路与算法**

根据题意可知，两座不同城市构成的城市对的网络秩定义为：与这两座城市直接相连的道路总数，这两座城市之间的道路只计算一次。假设城市 $x$ 的度数为 $\textit{degree}[x]$，则此时我们可以知道城市对 $(i,j)$ 的网络秩为如下：
+ 如果 $i$ 与 $j$ 之间没有道路连接，则此时 $(i,j)$ 的网络秩为 $\textit{degree}[i] + \textit{degree}[j]$；
+ 如果 $i$ 与 $j$ 之间存在道路连接，则此时 $(i,j)$ 的网络秩为 $\textit{degree}[i] + \textit{degree}[j] - 1$；

根据以上求网络秩的方法，我们首先求出所有城市在图中的度数，然后枚举所有可能的城市对 $(i,j)$，求出城市对 $(i,j)$ 的网络秩，即可找到最大的网络秩。

**代码**

```Python [sol1-Python3]
class Solution:
    def maximalNetworkRank(self, n: int, roads: List[List[int]]) -> int:
        connect = [[False] * n for _ in range(n)]
        degree = [0] * n
        for a, b in roads:
            connect[a][b] = True
            connect[b][a] = True
            degree[a] += 1
            degree[b] += 1

        maxRank = 0
        for i in range(n):
            for j in range(i + 1, n):
                rank = degree[i] + degree[j] - connect[i][j]
                maxRank = max(maxRank, rank)
        return maxRank
```

```C++ [sol1-C++]
class Solution {
public:
    int maximalNetworkRank(int n, vector<vector<int>>& roads) {
        vector<vector<bool>> connect(n, vector<bool>(n, false));
        vector<int> degree(n, 0);
        for (auto v : roads) {
            connect[v[0]][v[1]] = true;
            connect[v[1]][v[0]] = true;
            degree[v[0]]++;
            degree[v[1]]++;
        }

        int maxRank = 0;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int rank = degree[i] + degree[j] - (connect[i][j] ? 1 : 0);
                maxRank = max(maxRank, rank);
            }
        }
        return maxRank;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximalNetworkRank(int n, int[][] roads) {
        boolean[][] connect = new boolean[n][n];
        int[] degree = new int[n];
        for (int[] v : roads) {
            connect[v[0]][v[1]] = true;
            connect[v[1]][v[0]] = true;
            degree[v[0]]++;
            degree[v[1]]++;
        }

        int maxRank = 0;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int rank = degree[i] + degree[j] - (connect[i][j] ? 1 : 0);
                maxRank = Math.max(maxRank, rank);
            }
        }
        return maxRank;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximalNetworkRank(int n, int[][] roads) {
        bool[][] connect = new bool[n][];
        for (int i = 0; i < n; i++) {
            connect[i] = new bool[n];
        }
        int[] degree = new int[n];
        foreach (int[] v in roads) {
            connect[v[0]][v[1]] = true;
            connect[v[1]][v[0]] = true;
            degree[v[0]]++;
            degree[v[1]]++;
        }

        int maxRank = 0;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int rank = degree[i] + degree[j] - (connect[i][j] ? 1 : 0);
                maxRank = Math.Max(maxRank, rank);
            }
        }
        return maxRank;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maximalNetworkRank(int n, int** roads, int roadsSize, int* roadsColSize) {
    bool connect[n][n];
    int degree[n];
    memset(connect, 0, sizeof(connect));
    memset(degree, 0, sizeof(degree));
    for (int i = 0; i < roadsSize; i++) {
        int x = roads[i][0], y = roads[i][1];
        connect[x][y] = true;
        connect[y][x] = true;
        degree[x]++;
        degree[y]++;
    }

    int maxRank = 0;
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            int rank = degree[i] + degree[j] - (connect[i][j] ? 1 : 0);
            maxRank = MAX(maxRank, rank);
        }
    }
    return maxRank;
}
```

```JavaScript [sol1-JavaScript]
var maximalNetworkRank = function(n, roads) {
    const connect = new Array(n).fill(0).map(() => new Array(n).fill(0));
    const degree = new Array(n).fill(0);
    for (const v of roads) {
        connect[v[0]][v[1]] = true;
        connect[v[1]][v[0]] = true;
        degree[v[0]]++;
        degree[v[1]]++;
    }

    let maxRank = 0;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            let rank = degree[i] + degree[j] - (connect[i][j] ? 1 : 0);
            maxRank = Math.max(maxRank, rank);
        }
    }
    return maxRank;
};
```

```go [sol1-Golang]
func maximalNetworkRank(n int, roads [][]int) int {
    connect := make([][]int, n)
    for i := range connect {
        connect[i] = make([]int, n)
    }
    degree := make([]int, n)
    for _, v := range roads {
        connect[v[0]][v[1]] = 1
        connect[v[1]][v[0]] = 1
        degree[v[0]]++
        degree[v[1]]++
    }

    maxRank := 0
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            rank := degree[i] + degree[j] - connect[i][j]
            maxRank = max(maxRank, rank)
        }
    }
    return maxRank
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示给城市的数目。我们需要枚举所有可能的城市对，最多有 $n^2$ 个城市对。

- 空间复杂度：$O(n^2)$。需要记录图中所有的城市之间的连通关系，需要的空间为 $O(n^2)$。如果用邻接表存储连通关系，空间复杂度可以优化到 $O(n + m)$，其中 $m$ 表示 $\textit{roads}$ 的长度。

#### 方法二：贪心

**思路与算法**

我们可以对解法一中的方法继续优化。设 $\textit{first}$ 表示所有节点中度数的最大值，$\textit{second}$ 表示所有节点中度数的次大值，实际我们只需要考虑度数为最大值与次大值的城市即可，其余即可城市可以无须考虑，原因如下：
+ 已知最大值 $\textit{first}$ 与次大值 $\textit{second}$，则此时可以知道当前最差的情况下，假设这两城市存在连接，则最大的网络秩为 $\textit{first} + \textit{second} - 1$；
+ 假设存在度数比 $\textit{second}$ 小的城市 $x$，则此时 $\textit{degree}[x] < \textit{second}$，此时含有 $x$ 构成的城市对的最大网络秩不超过 $\textit{degree}[x] + \textit{first}$，此时一定满足$\textit{degree}[x] + \textit{first} \le \textit{second} + \textit{first}$；

综上可以得出结论选择最大或者次大度数的城市一定是最优的。我们可以求出度数为 $\textit{first}$ 的城市集合 $\textit{firstArr}$，同时求出度数为 $\textit{second}$ 的城市集合 $\textit{secondArr}$。设城市的总数量为 $n$，道路的总数量为 $m$，集合 $\textit{firstArr}$ 的数量为 $x$，则此时该集合可以构造的城市对数量为 $\dfrac{x(x-1)}{2}$，分以下几种情况来讨论:
+ 如果 $x = 1$，此时我们必须选择 $\textit{firstArr}$ 中唯一的城市，另一个城市只能在 $\textit{secondArr}$ 中选择，枚举 $\textit{secondArr}$ 中的每个城市，找到最大的网络秩即可，此时需要的时间复杂度为 $O(n)$；
+ 如果 $x > 1$ 时，分类讨论如下：
  + 如果满足 $\binom{x}{2} > m$ 时，此时集合 $\textit{firstArr}$ 一定存在一对城市，他们之间没有道路连接，此时最大的网络秩即为 $2 \times \textit{first}$；
  + 如果满足 $\binom{x}{2} \le m$ 时，此时枚举集合 $\textit{firstArr}$ 中所有不同的城市对即可，此时不需要再考虑次大的城市集合 $\textit{secondArr}$，因为此时一定满足 $2 \times \textit{first} - 1 \ge \textit{first} + \textit{second} > 2 \times \textit{second}$ ，此时时间复杂度不超过 $O(m)$；

因此通过以上分析，上述解法的时间复杂度为 $O(n + m)$。

```C++ [sol2-C++]
class Solution {
public:
    int maximalNetworkRank(int n, vector<vector<int>>& roads) {
        vector<vector<bool>> connect(n, vector<bool>(n, false));
        vector<int> degree(n);
        for (auto road : roads) {
            int x = road[0], y = road[1];
            connect[x][y] = true;
            connect[y][x] = true;
            degree[x]++;
            degree[y]++;
        }

        int first = -1, second = -2;
        vector<int> firstArr, secondArr;
        for (int i = 0; i < n; ++i) {
            if (degree[i] > first) {
                second = first;
                secondArr = firstArr;
                first = degree[i];
                firstArr.clear();
                firstArr.emplace_back(i);
            } else if (degree[i] == first) {
                firstArr.emplace_back(i);
            } else if (degree[i] > second){
                secondArr.clear();
                second = degree[i];
                secondArr.emplace_back(i);
            } else if (degree[i] == second) {
                secondArr.emplace_back(i);
            }
        }
        if (firstArr.size() == 1) {
            int u = firstArr[0];
            for (int v : secondArr) {
                if (!connect[u][v]) {
                    return first + second;
                }
            }
            return first + second - 1;
        } else {
            int m = roads.size();
            if (firstArr.size() * (firstArr.size() - 1) / 2 > m) {
                return first * 2;
            }
            for (int u: firstArr) {
                for (int v: firstArr) {
                    if (u != v && !connect[u][v]) {
                        return first * 2;
                    }
                }
            }
            return first * 2 - 1;
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximalNetworkRank(int n, int[][] roads) {
        boolean[][] connect = new boolean[n][n];
        int[] degree = new int[n];
        for (int[] road : roads) {
            int x = road[0], y = road[1];
            connect[x][y] = true;
            connect[y][x] = true;
            degree[x]++;
            degree[y]++;
        }

        int first = -1, second = -2;
        List<Integer> firstArr = new ArrayList<Integer>();
        List<Integer> secondArr = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (degree[i] > first) {
                second = first;
                secondArr = new ArrayList<Integer>(firstArr);
                first = degree[i];
                firstArr.clear();
                firstArr.add(i);
            } else if (degree[i] == first) {
                firstArr.add(i);
            } else if (degree[i] > second){
                secondArr.clear();
                second = degree[i];
                secondArr.add(i);
            } else if (degree[i] == second) {
                secondArr.add(i);
            }
        }
        if (firstArr.size() == 1) {
            int u = firstArr.get(0);
            for (int v : secondArr) {
                if (!connect[u][v]) {
                    return first + second;
                }
            }
            return first + second - 1;
        } else {
            int m = roads.length;
            if (firstArr.size() * (firstArr.size() - 1) / 2 > m) {
                return first * 2;
            }
            for (int u : firstArr) {
                for (int v : firstArr) {
                    if (u != v && !connect[u][v]) {
                        return first * 2;
                    }
                }
            }
            return first * 2 - 1;
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaximalNetworkRank(int n, int[][] roads) {
        bool[][] connect = new bool[n][];
        for (int i = 0; i < n; i++) {
            connect[i] = new bool[n];
        }
        int[] degree = new int[n];
        foreach (int[] road in roads) {
            int x = road[0], y = road[1];
            connect[x][y] = true;
            connect[y][x] = true;
            degree[x]++;
            degree[y]++;
        }

        int first = -1, second = -2;
        IList<int> firstArr = new List<int>();
        IList<int> secondArr = new List<int>();
        for (int i = 0; i < n; ++i) {
            if (degree[i] > first) {
                second = first;
                secondArr = new List<int>(firstArr);
                first = degree[i];
                firstArr.Clear();
                firstArr.Add(i);
            } else if (degree[i] == first) {
                firstArr.Add(i);
            } else if (degree[i] > second){
                secondArr.Clear();
                second = degree[i];
                secondArr.Add(i);
            } else if (degree[i] == second) {
                secondArr.Add(i);
            }
        }
        if (firstArr.Count == 1) {
            int u = firstArr[0];
            foreach (int v in secondArr) {
                if (!connect[u][v]) {
                    return first + second;
                }
            }
            return first + second - 1;
        } else {
            int m = roads.Length;
            if (firstArr.Count * (firstArr.Count - 1) / 2 > m) {
                return first * 2;
            }
            foreach (int u in firstArr) {
                foreach (int v in firstArr) {
                    if (u != v && !connect[u][v]) {
                        return first * 2;
                    }
                }
            }
            return first * 2 - 1;
        }
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maximalNetworkRank(int n, int** roads, int roadsSize, int* roadsColSize) {
    bool connect[n][n];
    int degree[n];
    memset(connect, 0, sizeof(connect));
    memset(degree, 0, sizeof(degree));
    for (int i = 0; i < roadsSize; i++) {
        int x = roads[i][0], y = roads[i][1];
        connect[x][y] = true;
        connect[y][x] = true;
        degree[x]++;
        degree[y]++;
    }

    int first = -1, second = -2;
    int firstArr[n], secondArr[n];
    int firstArrSize = 0, secondArrSize = 0;
    for (int i = 0; i < n; ++i) {
        if (degree[i] > first) {
            second = first;
            secondArrSize = firstArrSize;
            memcpy(secondArr, firstArr, sizeof(int) * firstArrSize);
            first = degree[i];
            firstArrSize = 0;
            firstArr[firstArrSize++] = i;
        } else if (degree[i] == first) {
            firstArr[firstArrSize++] = i;
        } else if (degree[i] > second){
            secondArrSize = 0;
            second = degree[i];
            secondArr[secondArrSize++] = i;
        } else if (degree[i] == second) {
            secondArr[secondArrSize++] = i;
        }
    }
    if (firstArrSize == 1) {
        int u = firstArr[0];
        for (int i = 0; i < secondArrSize; i++) {
            int v = secondArr[i];
            if (!connect[u][v]) {
                return first + second;
            }
        }
        return first + second - 1;
    } else {
        if (firstArrSize * (firstArrSize - 1) / 2 > roadsSize) {
            return first * 2;
        }
        for (int i = 0; i < firstArrSize; i++) {
            int u = firstArr[i];
            for (int j = i + 1; j < firstArrSize; j++) {
                int v = firstArr[j];
                if (!connect[u][v]) {
                    return first * 2;
                }
            }
        }
        return first * 2 - 1;
    }        
}
```

```JavaScript [sol2-JavaScript]
var maximalNetworkRank = function(n, roads) {
    const connect = new Array(n).fill(0).map(() => new Array(n).fill(0));
    const degree = new Array(n).fill(0);
    for (const road of roads) {
        let x = road[0], y = road[1];
        connect[x][y] = true;
        connect[y][x] = true;
        degree[x]++;
        degree[y]++;
    }

    let first = -1, second = -2;
    let firstArr = [];
    let secondArr = [];
    for (let i = 0; i < n; ++i) {
        if (degree[i] > first) {
            second = first;
            secondArr = [...firstArr];
            first = degree[i];
            firstArr = [i];
        } else if (degree[i] === first) {
            firstArr.push(i);
        } else if (degree[i] > second){
            secondArr = [];
            second = degree[i];
            secondArr.push(i);
        } else if (degree[i] === second) {
            secondArr.push(i);
        }
    }
    if (firstArr.length === 1) {
        const u = firstArr[0];
        for (const v of secondArr) {
            if (!connect[u][v]) {
                return first + second;
            }
        }
        return first + second - 1;
    } else {
        const m = roads.length;
        if (firstArr.length * (firstArr.length - 1) / 2 > m) {
            return first * 2;
        }
        for (const u of firstArr) {
            for (const v of firstArr) {
                if (u !== v && !connect[u][v]) {
                    return first * 2;
                }
            }
        }
        return first * 2 - 1;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 表示给定的数字 $n$，$m$ 表示城市之间的道路总数。计算城市的度数需要的时间为 $O(m)$，找到城市中最大度数和次大度数城市集合需要的时间为 $O(n)$，计算城市对中最大的网络秩需要的时间为 $O(m)$，因此总的时间复杂度为 $O(m + n)$。

- 空间复杂度：$O(n^2)$。需要记录图中所有的城市之间的联通关系，需要的空间为 $O(n^2)$，记录所有节点的度需要的空间为 $O(n)$，记录最大度数与次大度数的城市集合需要的空间为 $O(n)$，因此总的空间复杂度为 $O(n^2)$。如果用邻接表存储连通关系，空间复杂度可以优化到 $O(n + m)$，其中 $m$ 表示 $\textit{roads}$ 的长度。