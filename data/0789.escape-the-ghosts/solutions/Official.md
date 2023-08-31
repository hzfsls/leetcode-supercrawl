## [789.逃脱阻碍者 中文官方题解](https://leetcode.cn/problems/escape-the-ghosts/solutions/100000/tao-tuo-zu-ai-zhe-by-leetcode-solution-gjga)
#### 方法一：曼哈顿距离

为了逃脱阻碍者，玩家应按照最短路径向目的地移动。阻碍者为了抓住玩家，也会按照最短路径向目的地移动。由于每次移动为向四个方向之一移动一个单位，因此对于玩家和阻碍者而言，到达目的地的最短路径的距离为当前所在位置和目的地的曼哈顿距离。

用 $\text{dist}(A, B)$ 表示 $A$ 点和 $B$ 点的曼哈顿距离，曼哈顿距离的计算方法如下：

$$
\text{dist}(A, B) = \big| x_A - x_B \big| + \big| y_A - y_B \big|
$$

如果有一个阻碍者和目的地的曼哈顿距离小于玩家和目的地的曼哈顿距离，则该阻碍者可以在玩家之前到达目的地，然后停在目的地，玩家无法逃脱。

如果有一个阻碍者和目的地的曼哈顿距离等于玩家和目的地的曼哈顿距离，则该阻碍者可以和玩家同时到达目的地，玩家也无法逃脱。

如果所有的阻碍者和目的地的曼哈顿距离都大于玩家和目的地的曼哈顿距离，则玩家可以在阻碍者之前到达目的地。

如果玩家可以在阻碍者之前到达目的地，是否可能出现阻碍者在玩家前往目的地的中途拦截？答案是否定的，证明如下。

> 假设目的地是 $T$，初始时玩家位于 $S$，阻碍者位于 $G$，阻碍者在 $X$ 点拦截玩家。
>
> 由于阻碍者和目的地的曼哈顿距离大于玩家和目的地的曼哈顿距离，因此 $\text{dist}(G, T) > \text{dist}(S, T)$。
>
> 由于玩家会按照最短路径向目的地移动，因此如果阻碍者在 $X$ 点拦截玩家，则 $X$ 点一定在玩家前往目的地的最短路径上，满足 $\text{dist}(S, X) + \text{dist}(X, T) = \text{dist}(S, T)$。
>
> 由于 $X$ 点是拦截点，因此阻碍者到达 $X$ 点的时间早于或等于玩家到达 $X$ 点的时间，即 $\text{dist}(G, X) \le \text{dist}(S, X)$。
>
> 因此有：
>
> $$
> \begin{aligned}
> \text{dist}(G, X) &\le \text{dist}(S, X) \\
> \text{dist}(G, X) + \text{dist}(X, T) &\le \text{dist}(S, X) + \text{dist}(X, T) \\
> \text{dist}(G, X) + \text{dist}(X, T) &\le \text{dist}(S, T)
> \end{aligned}
> $$
>
> 由于阻碍者到目的地的最短路径长度是 $\text{dist}(G, T)$，因此有
>
> $$
> \text{dist}(G, T) \le \text{dist}(G, X) + \text{dist}(X, T) \le \text{dist}(S, T)
> $$
>
> 和条件 $\text{dist}(G, T) > \text{dist}(S, T)$ 矛盾。
> 
> 因此当 $\text{dist}(G, T) > \text{dist}(S, T)$ 时，阻碍者不可能在玩家前往目的地的中途拦截，玩家可以成功逃脱。

基于上述分析，问题简化为计算玩家和目的地的曼哈顿距离以及每个阻碍者和目的地的曼哈顿距离，判断玩家是否可以在阻碍者之前到达目的地。

- 如果存在至少一个阻碍者和目的地的曼哈顿距离小于或等于玩家和目的地的曼哈顿距离，返回 $\text{false}$；

- 如果所有阻碍者和目的地的曼哈顿距离都大于玩家和目的地的曼哈顿距离，返回 $\text{true}$。

```Java [sol1-Java]
class Solution {
    public boolean escapeGhosts(int[][] ghosts, int[] target) {
        int[] source = {0, 0};
        int distance = manhattanDistance(source, target);
        for (int[] ghost : ghosts) {
            int ghostDistance = manhattanDistance(ghost, target);
            if (ghostDistance <= distance) {
                return false;
            }
        }
        return true;
    }

    public int manhattanDistance(int[] point1, int[] point2) {
        return Math.abs(point1[0] - point2[0]) + Math.abs(point1[1] - point2[1]);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool EscapeGhosts(int[][] ghosts, int[] target) {
        int[] source = {0, 0};
        int distance = ManhattanDistance(source, target);
        foreach (int[] ghost in ghosts) {
            int ghostDistance = ManhattanDistance(ghost, target);
            if (ghostDistance <= distance) {
                return false;
            }
        }
        return true;
    }

    public int ManhattanDistance(int[] point1, int[] point2) {
        return Math.Abs(point1[0] - point2[0]) + Math.Abs(point1[1] - point2[1]);
    }
}
```

```JavaScript [sol1-JavaScript]
var escapeGhosts = function(ghosts, target) {
    const source = [0, 0];
    const distance = manhattanDistance(source, target);
    for (const ghost of ghosts) {
        const ghostDistance = manhattanDistance(ghost, target);
        if (ghostDistance <= distance) {
            return false;
        }
    }
    return true;
}

const manhattanDistance = (point1, point2) => {
    return Math.abs(point1[0] - point2[0]) + Math.abs(point1[1] - point2[1]);
}
```

```Python [sol1-Python3]
class Solution:
    def escapeGhosts(self, ghosts: List[List[int]], target: List[int]) -> bool:
        source = [0, 0]
        distance = manhattanDistance(source, target)
        return all(manhattanDistance(ghost, target) > distance for ghost in ghosts)

def manhattanDistance(point1: List[int], point2: List[int]) -> int:
    return abs(point1[0] - point2[0]) + abs(point1[1] - point2[1])
```

```go [sol1-Golang]
func escapeGhosts(ghosts [][]int, target []int) bool {
    source := []int{0, 0}
    distance := manhattanDistance(source, target)
    for _, ghost := range ghosts {
        if manhattanDistance(ghost, target) <= distance {
            return false
        }
    }
    return true
}

func manhattanDistance(point1, point2 []int) int {
    return abs(point1[0]-point2[0]) + abs(point1[1]-point2[1])
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```C++ [sol1-C++]
class Solution {
public:
    int manhattanDistance(vector<int>& point1, vector<int>& point2) {
        return abs(point1[0] - point2[0]) + abs(point1[1] - point2[1]);
    }

    bool escapeGhosts(vector<vector<int>>& ghosts, vector<int>& target) {
        vector<int> source(2);
        int distance = manhattanDistance(source, target);
        for (auto& ghost : ghosts) {
            int ghostDistance = manhattanDistance(ghost, target);
            if (ghostDistance <= distance) {
                return false;
            }
        }
        return true;
    }
};
```

```C [sol1-C]
int manhattanDistance(int* point1, int* point2) {
    return abs(point1[0] - point2[0]) + abs(point1[1] - point2[1]);
}

bool escapeGhosts(int** ghosts, int ghostsSize, int* ghostsColSize, int* target, int targetSize) {
    int source[2] = {0, 0};
    int distance = manhattanDistance(source, target);
    for (int i = 0; i < ghostsSize; i++) {
        int ghostDistance = manhattanDistance(ghosts[i], target);
        if (ghostDistance <= distance) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{ghosts}$ 的长度。需要计算玩家和目的地的距离，以及遍历数组 $\textit{ghosts}$ 计算每个阻碍者和目的地的距离。

- 空间复杂度：$O(1)$。