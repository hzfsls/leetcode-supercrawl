#### 前言

**博弈知识介绍**

这道题是博弈问题，猫和老鼠都按照最优策略参与游戏。

在阐述具体解法之前，首先介绍博弈问题中的三个概念：必胜状态、必败状态与必和状态。

1. 对于特定状态，如果游戏已经结束，则根据结束时的状态决定必胜状态、必败状态与必和状态。

   - 如果分出胜负，则该特定状态对于获胜方为必胜状态，对于落败方为必败状态。

   - 如果是平局，则该特定状态对于双方都为必和状态。

2. 从特定状态开始，如果存在一种操作将状态变成必败状态，则当前玩家可以选择该操作，将必败状态留给对方玩家，因此该特定状态对于当前玩家为必胜状态。

3. 从特定状态开始，如果所有操作都会将状态变成必胜状态，则无论当前玩家选择哪种操作，都会将必胜状态留给对方玩家，因此该特定状态对于当前玩家为必败状态。

4. 从特定状态开始，如果任何操作都不能将状态变成必败状态，但是存在一种操作将状态变成必和状态，则当前玩家可以选择该操作，将必和状态留给对方玩家，因此该特定状态对于双方玩家都为必和状态。

对于每个玩家，最优策略如下：

1. 争取将必胜状态留给自己，将必败状态留给对方玩家。

2. 在自己无法到达必胜状态的情况下，争取将必和状态留给自己。

**自顶向下动态规划解法介绍**

博弈问题通常可以使用动态规划求解。这道题由于数据规模的原因，动态规划方法不适用，因此只是介绍。

使用三维数组 $\textit{dp}$ 表示状态，$\textit{dp}[\textit{mouse}][\textit{cat}][\textit{turns}]$ 表示从老鼠位于节点 $\textit{mouse}$、猫位于节点 $\textit{cat}$、游戏已经进行了 $\textit{turns}$ 轮的状态开始，猫和老鼠都按照最优策略的情况下的游戏结果。假设图中的节点数是 $n$，则有 $0 \le \textit{mouse}, \textit{cat} < n$。

由于游戏的初始状态是老鼠位于节点 $1$，猫位于节点 $2$，因此 $\textit{dp}[1][2][0]$ 为从初始状态开始的游戏结果。

动态规划的边界条件为可以直接得到游戏结果的状态，包括以下三种状态：

- 如果 $\textit{mouse} = 0$，老鼠躲入洞里，则老鼠获胜，因此对于任意 $\textit{cat}$ 和 $\textit{turns}$ 都有 $\textit{dp}[0][\textit{cat}][\textit{turns}] = 1$，该状态为老鼠的必胜状态，猫的必败状态。

- 如果 $\textit{cat} = \textit{mouse}$，猫和老鼠占据相同的节点，则猫获胜，因此当 $\textit{cat} = \textit{mouse}$ 时，对于任意 $\textit{mouse}$、$\textit{cat}$ 和 $\textit{turns}$ 都有 $\textit{dp}[\textit{mouse}][\textit{cat}][\textit{turns}] = 2$，该状态为老鼠的必败状态，猫的必胜状态。注意猫不能移动到节点 $0$，因此当 $\textit{mouse} = 0$ 时，一定有 $\textit{cat} \ne \textit{mouse}$。

- 如果 $\textit{turns} \ge 2n(n - 1)$，则是平局，该状态为双方的必和状态。

   > 由于游戏中的每个局面由老鼠的位置、猫的位置和轮到移动的一方三个因素确定，老鼠可能的位置数是 $n$，因此猫可能的位置数是 $n - 1$（由于猫不能移动到节点 $0$），轮到移动的一方有 $2$ 种可能，因此游戏中所有可能的局面数是 $2n(n - 1)$。
   >
   > 根据抽屉原理可知，当游戏进行了 $2n(n - 1)$ 轮时，一定存在至少一个猫和老鼠重复经过的局面。由于猫和老鼠都按照最优策略参与游戏，对于同一个局面，游戏结果是相同的。
   >
   > 考虑该重复经过的局面。从该局面开始，双方按照最优策略移动，结果只能回到该局面，任何一方都无法让己方到达必胜状态，让对方到达必败状态，因此该状态对于双方都不是必胜状态，只能是必和状态。
   >
   > 如果该重复经过的局面和初始局面相同，则初始局面即为双方的必和状态。如果该重复经过的局面和初始局面不同，则从初始局面开始，双方按照最优策略移动，结果只能到达双方的必和状态，任何一方都无法让己方到达必胜状态，让对方到达必败状态，因此初始局面对于双方都不是必胜状态，只能是必和状态。
   >
   > 综上所述，如果游戏进行了 $2n(n - 1)$ 轮还没有任何一方获胜，则是平局。

动态规划的状态转移需要考虑当前玩家所有可能的移动，选择最优策略的移动。

由于老鼠先开始移动，猫后开始移动，因此可以根据游戏已经进行的轮数 $\textit{turns}$ 的奇偶性决定当前轮到的玩家，当 $\textit{turns}$ 是偶数时轮到老鼠移动，当 $\textit{turns}$ 是奇数时轮到猫移动。

如果轮到老鼠移动，则对于老鼠从当前节点移动一次之后可能到达的每个节点，进行如下操作：

1. 如果存在一个节点，老鼠到达该节点之后，老鼠可以获胜，则老鼠到达该节点之后的状态为老鼠的必胜状态，猫的必败状态，因此在老鼠移动之前的当前状态为老鼠的必胜状态。

2. 如果老鼠到达任何节点之后的状态都不是老鼠的必胜状态，但是存在一个节点，老鼠到达该节点之后，结果是平局，则老鼠到达该节点之后的状态为双方的必和状态，因此在老鼠移动之前的当前状态为双方的必和状态。

3. 如果老鼠到达任何节点之后的状态都不是老鼠的必胜状态或必和状态，则老鼠到达任何节点之后的状态都为老鼠的必败状态，猫的必胜状态，因此在老鼠移动之前的当前状态为老鼠的必败状态。

如果轮到猫移动，则对于猫从当前节点移动一次之后可能到达的每个节点，进行如下操作：

1. 如果存在一个节点，猫到达该节点之后，猫可以获胜，则猫到达该节点之后的状态为猫的必胜状态，老鼠的必败状态，因此在猫移动之前的当前状态为猫的必胜状态。

2. 如果猫到达任何节点之后的状态都不是猫的必胜状态，但是存在一个节点，猫到达该节点之后，结果是平局，则猫到达该节点之后的状态为双方的必和状态，因此在猫移动之前的当前状态为双方的必和状态。

3. 如果猫到达任何节点之后的状态都不是猫的必胜状态或必和状态，则猫到达任何节点之后的状态都为猫的必败状态，老鼠的必胜状态，因此在猫移动之前的当前状态为猫的必败状态。

实现方面，由于双方移动的策略相似，因此可以使用一个函数实现移动策略，根据游戏已经进行的轮数的奇偶性决定当前轮到的玩家。对于特定玩家的移动，实现方法如下：

1. 如果当前玩家存在一种移动方法到达非必败状态，则用该状态更新游戏结果。

   - 如果该移动方法到达必胜状态，则将当前状态（移动前的状态）设为必胜状态，结束遍历其他可能的移动。

   - 如果该移动方法到达必和状态，则将当前状态（移动前的状态）设为必和状态，继续遍历其他可能的移动，因为可能存在到达必胜状态的移动方法。

2. 如果当前玩家的任何移动方法都到达必败状态，则将当前状态（移动前的状态）设为必败状态。

由于老鼠可能的位置有 $n$ 个，猫可能的位置有 $n - 1$ 个，游戏轮数最大为 $2n(n - 1)$，因此动态规划的状态数是 $O(n^4)$，对于每个状态需要 $O(n)$ 的时间计算状态值，因此总时间复杂度是 $O(n^5)$，该时间复杂度会超出时间限制，因此自顶向下的动态规划不适用于这道题。以下代码为自顶向下的动态规划的实现，仅供读者参考。

```Java [sol0-Java]
class Solution {
    static final int MOUSE_WIN = 1;
    static final int CAT_WIN = 2;
    static final int DRAW = 0;
    int n;
    int[][] graph;
    int[][][] dp;

    public int catMouseGame(int[][] graph) {
        this.n = graph.length;
        this.graph = graph;
        this.dp = new int[n][n][2 * n * (n - 1)];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                Arrays.fill(dp[i][j], -1);
            }
        }
        return getResult(1, 2, 0);
    }

    public int getResult(int mouse, int cat, int turns) {
        if (turns == 2 * n * (n - 1)) {
            return DRAW;
        }
        if (dp[mouse][cat][turns] < 0) {
            if (mouse == 0) {
                dp[mouse][cat][turns] = MOUSE_WIN;
            } else if (cat == mouse) {
                dp[mouse][cat][turns] = CAT_WIN;
            } else {
                getNextResult(mouse, cat, turns);
            }
        }
        return dp[mouse][cat][turns];
    }

    public void getNextResult(int mouse, int cat, int turns) {
        int curMove = turns % 2 == 0 ? mouse : cat;
        int defaultResult = curMove == mouse ? CAT_WIN : MOUSE_WIN;
        int result = defaultResult;
        int[] nextNodes = graph[curMove];
        for (int next : nextNodes) {
            if (curMove == cat && next == 0) {
                continue;
            }
            int nextMouse = curMove == mouse ? next : mouse;
            int nextCat = curMove == cat ? next : cat;
            int nextResult = getResult(nextMouse, nextCat, turns + 1);
            if (nextResult != defaultResult) {
                result = nextResult;
                if (result != DRAW) {
                    break;
                }
            }
        }
        dp[mouse][cat][turns] = result;
    }
}
```

```C# [sol0-C#]
public class Solution {
    const int MOUSE_WIN = 1;
    const int CAT_WIN = 2;
    const int DRAW = 0;
    int n;
    int[][] graph;
    int[,,] dp;

    public int CatMouseGame(int[][] graph) {
        this.n = graph.Length;
        this.graph = graph;
        this.dp = new int[n, n, 2 * n * (n - 1)];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < 2 * n * (n - 1); k++) {
                    dp[i, j, k] = -1;
                }
            }
        }
        return GetResult(1, 2, 0);
    }

    public int GetResult(int mouse, int cat, int turns) {
        if (turns == 2 * n * (n - 1)) {
            return DRAW;
        }
        if (dp[mouse, cat, turns] < 0) {
            if (mouse == 0) {
                dp[mouse, cat, turns] = MOUSE_WIN;
            } else if (cat == mouse) {
                dp[mouse, cat, turns] = CAT_WIN;
            } else {
                GetNextResult(mouse, cat, turns);
            }
        }
        return dp[mouse, cat, turns];
    }

    public void GetNextResult(int mouse, int cat, int turns) {
        int curMove = turns % 2 == 0 ? mouse : cat;
        int defaultResult = curMove == mouse ? CAT_WIN : MOUSE_WIN;
        int result = defaultResult;
        int[] nextNodes = graph[curMove];
        foreach (int next in nextNodes) {
            if (curMove == cat && next == 0) {
                continue;
            }
            int nextMouse = curMove == mouse ? next : mouse;
            int nextCat = curMove == cat ? next : cat;
            int nextResult = GetResult(nextMouse, nextCat, turns + 1);
            if (nextResult != defaultResult) {
                result = nextResult;
                if (result != DRAW) {
                    break;
                }
            }
        }
        dp[mouse, cat, turns] = result;
    }
}
```

```C++ [sol0-C++]
const int MOUSE_WIN = 1;
const int CAT_WIN = 2;
const int DRAW = 0;
const int MAXN = 51;

class Solution {
public:
    int n;
    int dp[MAXN][MAXN][MAXN*(MAXN-1)*2];
    vector<vector<int>> graph;
    
    int catMouseGame(vector<vector<int>>& graph) {
        this->n = graph.size();
        this->graph = graph;
        memset(dp, -1, sizeof(dp));
        return getResult(1, 2, 0);
    }

    int getResult(int mouse, int cat, int turns) {
        if (turns == 2 * n * (n - 1)) {
            return DRAW;
        }
        if (dp[mouse][cat][turns] < 0) {
            if (mouse == 0) {
                dp[mouse][cat][turns] = MOUSE_WIN;
            } else if (cat == mouse) {
                dp[mouse][cat][turns] = CAT_WIN;
            } else {
                getNextResult(mouse, cat, turns);
            }
        }
        return dp[mouse][cat][turns];
    }

    void getNextResult(int mouse, int cat, int turns) {
        int curMove = turns % 2 == 0 ? mouse : cat;
        int defaultResult = curMove == mouse ? CAT_WIN : MOUSE_WIN;
        int result = defaultResult;
        for (int next : graph[curMove]) {
            if (curMove == cat && next == 0) {
                continue;
            }
            int nextMouse = curMove == mouse ? next : mouse;
            int nextCat = curMove == cat ? next : cat;
            int nextResult = getResult(nextMouse, nextCat, turns + 1);
            if (nextResult != defaultResult) {
                result = nextResult;
                if (result != DRAW) {
                    break;
                }
            }
        }
        dp[mouse][cat][turns] = result;
    }
};
```

```Python [sol0-Python3]
DRAW = 0
MOUSE_WIN = 1
CAT_WIN = 2

class Solution:
    def catMouseGame(self, graph: List[List[int]]) -> int:
        n = len(graph)
        dp = [[[-1] * (2 * n * (n - 1)) for _ in range(n)] for _ in range(n)]

        def getResult(mouse: int, cat: int, turns: int) -> int:
            if turns == 2 * n * (n - 1):
                return DRAW
            res = dp[mouse][cat][turns]
            if res != -1:
                return res
            if mouse == 0:
                res = MOUSE_WIN
            elif cat == mouse:
                res = CAT_WIN
            else:
                res = getNextResult(mouse, cat, turns)
            dp[mouse][cat][turns] = res
            return res

        def getNextResult(mouse: int, cat: int, turns: int) -> int:
            curMove = mouse if turns % 2 == 0 else cat
            defaultRes = MOUSE_WIN if curMove != mouse else CAT_WIN
            res = defaultRes
            for next in graph[curMove]:
                if curMove == cat and next == 0:
                    continue
                nextMouse = next if curMove == mouse else mouse
                nextCat = next if curMove == cat else cat
                nextRes = getResult(nextMouse, nextCat, turns + 1)
                if nextRes != defaultRes:
                    res = nextRes
                    if res != DRAW:
                        break
            return res

        return getResult(1, 2, 0)
```

```JavaScript [sol0-JavaScript]
const MOUSE_WIN = 1;
const CAT_WIN = 2;
const DRAW = 0;
var catMouseGame = function(graph) {
    const n = graph.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2 * n * (n - 1)).fill(-1)));
    
    const getResult = (mouse, cat, turns) => {
        if (turns === 2 * n * (n - 1)) {
            return DRAW;
        }
        let res = dp[mouse][cat][turns];
        if (res !== -1) {
            return res;
        }
        if (mouse === 0) {
            res = MOUSE_WIN;
        } else if (cat === mouse) {
            res = CAT_WIN;
        } else {
            res = getNextResult(mouse, cat, turns);
        }
        dp[mouse][cat][turns] = res;
        return res;
    }

    const getNextResult = (mouse, cat, turns) => {
        const curMove = turns % 2 == 0 ? mouse : cat;
        const defaultRes = curMove != mouse ? MOUSE_WIN : CAT_WIN;
        let res = defaultRes;
        for (const next of graph[curMove]) {
            if (curMove === cat && next === 0) {
                continue;
            }
            const nextMouse = curMove === mouse ? next : mouse;
            const nextCat = curMove == cat ? next : cat;
            const nextRes = getResult(nextMouse, nextCat, turns + 1)
            if (nextRes !== defaultRes) {
                res = nextRes;
                if (res !== DRAW) {
                    break;
                }
            } 
        }
        return res;
    }

    return getResult(1, 2, 0);
};
```

```go [sol0-Golang]
const (
    draw     = 0
    mouseWin = 1
    catWin   = 2
)

func catMouseGame(graph [][]int) int {
    n := len(graph)
    dp := make([][][]int, n)
    for i := range dp {
        dp[i] = make([][]int, n)
        for j := range dp[i] {
            dp[i][j] = make([]int, n*(n-1)*2)
            for k := range dp[i][j] {
                dp[i][j][k] = -1
            }
        }
    }

    var getResult, getNextResult func(int, int, int) int
    getResult = func(mouse, cat, turns int) int {
        if turns == n*(n-1)*2 {
            return draw
        }
        res := dp[mouse][cat][turns]
        if res != -1 {
            return res
        }
        if mouse == 0 {
            res = mouseWin
        } else if cat == mouse {
            res = catWin
        } else {
            res = getNextResult(mouse, cat, turns)
        }
        dp[mouse][cat][turns] = res
        return res
    }
    getNextResult = func(mouse, cat, turns int) int {
        curMove := mouse
        if turns%2 == 1 {
            curMove = cat
        }
        defaultRes := mouseWin
        if curMove == mouse {
            defaultRes = catWin
        }
        res := defaultRes
        for _, next := range graph[curMove] {
            if curMove == cat && next == 0 {
                continue
            }
            nextMouse, nextCat := mouse, cat
            if curMove == mouse {
                nextMouse = next
            } else if curMove == cat {
                nextCat = next
            }
            nextRes := getResult(nextMouse, nextCat, turns+1)
            if nextRes != defaultRes {
                res = nextRes
                if res != draw {
                    break
                }
            }
        }
        return res
    }
    return getResult(1, 2, 0)
}
```

```C [sol0-C]
#define MOUSE_WIN 1
#define CAT_WIN 2
#define DRAW 0
#define MAXN 51

int dp[MAXN][MAXN][MAXN*(MAXN-1)*2];

int getResult(int mouse, int cat, int turns, const int** graph, const int graphSize, const int* graphColSize) {
    if (turns == graphSize * (graphSize - 1) * 2) {
        return DRAW;
    }
    if (dp[mouse][cat][turns] < 0) {
        if (mouse == 0) {
            dp[mouse][cat][turns] = MOUSE_WIN;
        } else if (cat == mouse) {
            dp[mouse][cat][turns] = CAT_WIN;
        } else {
            getNextResult(mouse, cat, turns, graph, graphSize, graphColSize);
        }
    }
    return dp[mouse][cat][turns];
}

void getNextResult(int mouse, int cat, int turns, const int** graph, const int graphSize, const int* graphColSize) {
    int curMove = turns % 2 == 0 ? mouse : cat;
    int defaultResult = curMove == mouse ? CAT_WIN : MOUSE_WIN;
    int result = defaultResult;
    int * nextNodes = graph[curMove];
    for (int i = 0; i < graphColSize[curMove]; i++) {
        if (curMove == cat && nextNodes[i] == 0) {
            continue;
        }
        int nextMouse = curMove == mouse ? nextNodes[i] : mouse;
        int nextCat = curMove == cat ? nextNodes[i] : cat;
        int nextResult = getResult(nextMouse, nextCat, turns + 1, graph, graphSize, graphColSize);
        if (nextResult != defaultResult) {
            result = nextResult;
            if (result != DRAW) {
                break;
            }
        }
    }
    dp[mouse][cat][turns] = result;
}

int catMouseGame(int** graph, int graphSize, int* graphColSize){
    memset(dp, -1, sizeof(dp));
    return getResult(1, 2, 0, graph, graphSize, graphColSize);
}
```

#### 方法一：拓扑排序

**思路和算法**

自顶向下的动态规划由于判定平局的标准和轮数有关，因此时间复杂度较高。为了降低时间复杂度，需要使用自底向上的方法实现，消除结果和轮数之间的关系。

使用自底向上的方法实现时，游戏中的状态由老鼠的位置、猫的位置和轮到移动的一方三个因素确定。初始时，只有边界情况的胜负结果已知，其余所有状态的结果都初始化为平局。边界情况为直接确定胜负的情况，包括两类情况：老鼠躲入洞里，无论猫位于哪个节点，都是老鼠获胜；猫和老鼠占据相同的节点，无论占据哪个节点，都是猫获胜。

从边界情况出发遍历其他情况。对于当前状态，可以得到老鼠的位置、猫的位置和轮到移动的一方，根据当前状态可知上一轮的所有可能状态，其中上一轮的移动方和当前的移动方相反，上一轮的移动方在上一轮状态和当前状态所在的节点不同。假设当前状态是老鼠所在节点是 $\textit{mouse}$，猫所在节点是 $\textit{cat}$，则根据当前的移动方，可以得到上一轮的所有可能状态：

- 如果当前的移动方是老鼠，则上一轮的移动方是猫，上一轮状态中老鼠所在节点是 $\textit{mouse}$，猫所在节点可能是 $\textit{graph}[\textit{cat}]$ 中的任意一个节点（除了节点 $0$）；

- 如果当前的移动方是猫，则上一轮的移动方是老鼠，上一轮状态中老鼠所在节点可能是 $\textit{graph}[\textit{mouse}]$ 中的任意一个节点，猫所在节点是 $\textit{cat}$。

对于上一轮的每一种可能的状态，如果该状态的结果已知不是平局，则不需要重复计算该状态的结果，只有对结果是平局的状态，才需要计算该状态的结果。对于上一轮的移动方，只有当可以确定上一轮状态是必胜状态或者必败状态时，才更新上一轮状态的结果。

- 如果上一轮的移动方和当前状态的结果的获胜方相同，由于当前状态为上一轮的移动方的必胜状态，因此上一轮的移动方一定可以移动到当前状态而获胜，上一轮状态为上一轮的移动方的必胜状态。

- 如果上一轮的移动方和当前状态的结果的获胜方不同，则上一轮的移动方需要尝试其他可能的移动，可能有以下三种情况：

   - 如果存在一种移动可以到达上一轮的移动方的必胜状态，则上一轮状态为上一轮的移动方的必胜状态；

   - 如果所有的移动都到达上一轮的移动方的必败状态，则上一轮状态为上一轮的移动方的必败状态；

   - 如果所有的移动都不能到达上一轮的移动方的必胜状态，但是存在一种移动可以到达上一轮的移动方的必和状态，则上一轮状态为上一轮的移动方的必和状态。

其中，对于必败状态与必和状态的判断依据为上一轮的移动方可能的移动是都到达必败状态还是可以到达必和状态。为了实现必败状态与必和状态的判断，需要记录每个状态的度，初始时每个状态的度为当前玩家在当前位置可以移动到的节点数。对于老鼠而言，初始的度为老鼠所在的节点的相邻节点数；对于猫而言，初始的度为猫所在的节点的相邻且非节点 $0$ 的节点数。

遍历过程中，从当前状态出发遍历上一轮的所有可能状态，如果上一轮状态的结果是平局且上一轮的移动方和当前状态的结果的获胜方不同，则将上一轮状态的度减 $1$。如果上一轮状态的度减少到 $0$，则从上一轮状态出发到达的所有状态都是上一轮的移动方的必败状态，因此上一轮状态也是上一轮的移动方的必败状态。

在确定上一轮状态的结果（必胜或必败）之后，即可从上一轮状态出发，遍历其他结果是平局的状态。当没有更多的状态可以确定胜负结果时，遍历结束，此时即可得到初始状态的结果。

细心的读者可以发现，上述遍历的过程其实是拓扑排序。

**证明**

必胜状态和必败状态都符合博弈中的最优策略，需要证明的是必和状态的正确性。

遍历结束之后，如果一个状态的结果是平局，则该状态满足以下两个条件：

- 从该状态出发，任何移动都无法到达该状态的移动方的必胜状态；

- 从该状态出发，存在一种移动可以到达必和状态。

对于标记结果是平局的状态，如果其实际结果是该状态的移动方必胜，则一定存在一个下一轮状态，为当前状态的移动方的必胜状态，在根据下一轮状态的结果标记当前状态的结果时会将当前状态标记为当前状态的移动方的必胜状态，和标记结果是平局矛盾。

对于标记结果是平局的状态，如果其实际结果是该状态的移动方必败，则所有的下一轮状态都为当前状态的移动方的必败状态，在根据下一轮状态的结果标记当前状态的结果时会将当前状态标记为当前状态的移动方的必败状态，和标记结果是平局矛盾。

因此，如果标记的状态是必和状态，则实际结果一定是必和状态。

**代码**

```Java [sol1-Java]
class Solution {
    static final int MOUSE_TURN = 0, CAT_TURN = 1;
    static final int DRAW = 0, MOUSE_WIN = 1, CAT_WIN = 2;
    int[][] graph;
    int[][][] degrees;
    int[][][] results;

    public int catMouseGame(int[][] graph) {
        int n = graph.length;
        this.graph = graph;
        this.degrees = new int[n][n][2];
        this.results = new int[n][n][2];
        Queue<int[]> queue = new ArrayDeque<int[]>();
        for (int i = 0; i < n; i++) {
            for (int j = 1; j < n; j++) {
                degrees[i][j][MOUSE_TURN] = graph[i].length;
                degrees[i][j][CAT_TURN] = graph[j].length;
            }
        }
        for (int node : graph[0]) {
            for (int i = 0; i < n; i++) {
                degrees[i][node][CAT_TURN]--;
            }
        }
        for (int j = 1; j < n; j++) {
            results[0][j][MOUSE_TURN] = MOUSE_WIN;
            results[0][j][CAT_TURN] = MOUSE_WIN;
            queue.offer(new int[]{0, j, MOUSE_TURN});
            queue.offer(new int[]{0, j, CAT_TURN});
        }
        for (int i = 1; i < n; i++) {
            results[i][i][MOUSE_TURN] = CAT_WIN;
            results[i][i][CAT_TURN] = CAT_WIN;
            queue.offer(new int[]{i, i, MOUSE_TURN});
            queue.offer(new int[]{i, i, CAT_TURN});
        }
        while (!queue.isEmpty()) {
            int[] state = queue.poll();
            int mouse = state[0], cat = state[1], turn = state[2];
            int result = results[mouse][cat][turn];
            List<int[]> prevStates = getPrevStates(mouse, cat, turn);
            for (int[] prevState : prevStates) {
                int prevMouse = prevState[0], prevCat = prevState[1], prevTurn = prevState[2];
                if (results[prevMouse][prevCat][prevTurn] == DRAW) {
                    boolean canWin = (result == MOUSE_WIN && prevTurn == MOUSE_TURN) || (result == CAT_WIN && prevTurn == CAT_TURN);
                    if (canWin) {
                        results[prevMouse][prevCat][prevTurn] = result;
                        queue.offer(new int[]{prevMouse, prevCat, prevTurn});
                    } else {
                        degrees[prevMouse][prevCat][prevTurn]--;
                        if (degrees[prevMouse][prevCat][prevTurn] == 0) {
                            int loseResult = prevTurn == MOUSE_TURN ? CAT_WIN : MOUSE_WIN;
                            results[prevMouse][prevCat][prevTurn] = loseResult;
                            queue.offer(new int[]{prevMouse, prevCat, prevTurn});
                        }
                    }
                }
            }
        }
        return results[1][2][MOUSE_TURN];
    }

    public List<int[]> getPrevStates(int mouse, int cat, int turn) {
        List<int[]> prevStates = new ArrayList<int[]>();
        int prevTurn = turn == MOUSE_TURN ? CAT_TURN : MOUSE_TURN;
        if (prevTurn == MOUSE_TURN) {
            for (int prev : graph[mouse]) {
                prevStates.add(new int[]{prev, cat, prevTurn});
            }
        } else {
            for (int prev : graph[cat]) {
                if (prev != 0) {
                    prevStates.add(new int[]{mouse, prev, prevTurn});
                }
            }
        }
        return prevStates;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOUSE_TURN = 0, CAT_TURN = 1;
    const int DRAW = 0, MOUSE_WIN = 1, CAT_WIN = 2;
    int[][] graph;
    int[,,] degrees;
    int[,,] results;

    public int CatMouseGame(int[][] graph) {
        int n = graph.Length;
        this.graph = graph;
        this.degrees = new int[n, n, 2];
        this.results = new int[n, n, 2];
        Queue<Tuple<int, int, int>> queue = new Queue<Tuple<int, int, int>>();
        for (int i = 0; i < n; i++) {
            for (int j = 1; j < n; j++) {
                degrees[i, j, MOUSE_TURN] = graph[i].Length;
                degrees[i, j, CAT_TURN] = graph[j].Length;
            }
        }
        foreach (int node in graph[0]) {
            for (int i = 0; i < n; i++) {
                degrees[i, node, CAT_TURN]--;
            }
        }
        for (int j = 1; j < n; j++) {
            results[0, j, MOUSE_TURN] = MOUSE_WIN;
            results[0, j, CAT_TURN] = MOUSE_WIN;
            queue.Enqueue(new Tuple<int, int, int>(0, j, MOUSE_TURN));
            queue.Enqueue(new Tuple<int, int, int>(0, j, CAT_TURN));
        }
        for (int i = 1; i < n; i++) {
            results[i, i, MOUSE_TURN] = CAT_WIN;
            results[i, i, CAT_TURN] = CAT_WIN;
            queue.Enqueue(new Tuple<int, int, int>(i, i, MOUSE_TURN));
            queue.Enqueue(new Tuple<int, int, int>(i, i, CAT_TURN));
        }
        while (queue.Count > 0) {
            Tuple<int, int, int> state = queue.Dequeue();
            int mouse = state.Item1, cat = state.Item2, turn = state.Item3;
            int result = results[mouse, cat, turn];
            IList<Tuple<int, int, int>> prevStates = GetPrevStates(mouse, cat, turn);
            foreach (Tuple<int, int, int> prevState in prevStates) {
                int prevMouse = prevState.Item1, prevCat = prevState.Item2, prevTurn = prevState.Item3;
                if (results[prevMouse, prevCat, prevTurn] == DRAW) {
                    bool canWin = (result == MOUSE_WIN && prevTurn == MOUSE_TURN) || (result == CAT_WIN && prevTurn == CAT_TURN);
                    if (canWin) {
                        results[prevMouse, prevCat, prevTurn] = result;
                        queue.Enqueue(new Tuple<int, int, int>(prevMouse, prevCat, prevTurn));
                    } else {
                        degrees[prevMouse, prevCat, prevTurn]--;
                        if (degrees[prevMouse, prevCat, prevTurn] == 0) {
                            int loseResult = prevTurn == MOUSE_TURN ? CAT_WIN : MOUSE_WIN;
                            results[prevMouse, prevCat, prevTurn] = loseResult;
                            queue.Enqueue(new Tuple<int, int, int>(prevMouse, prevCat, prevTurn));
                        }
                    }
                }
            }
        }
        return results[1, 2, MOUSE_TURN];
    }

    public IList<Tuple<int, int, int>> GetPrevStates(int mouse, int cat, int turn) {
        IList<Tuple<int, int, int>> prevStates = new List<Tuple<int, int, int>>();
        int prevTurn = turn == MOUSE_TURN ? CAT_TURN : MOUSE_TURN;
        if (prevTurn == MOUSE_TURN) {
            foreach (int prev in graph[mouse]) {
                prevStates.Add(new Tuple<int, int, int>(prev, cat, prevTurn));
            }
        } else {
            foreach (int prev in graph[cat]) {
                if (prev != 0) {
                    prevStates.Add(new Tuple<int, int, int>(mouse, prev, prevTurn));
                }
            }
        }
        return prevStates;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    const int MOUSE_TURN = 0, CAT_TURN = 1;
    const int DRAW = 0, MOUSE_WIN = 1, CAT_WIN = 2;
    vector<vector<int>> graph;
    vector<vector<vector<int>>> degrees;
    vector<vector<vector<int>>> results;

    int catMouseGame(vector<vector<int>>& graph) {
        int n = graph.size();
        this->graph = graph;
        this->degrees = vector<vector<vector<int>>>(n, vector<vector<int>>(n, vector<int>(2)));
        this->results = vector<vector<vector<int>>>(n, vector<vector<int>>(n, vector<int>(2)));
        queue<tuple<int, int, int>> qu;

        for (int i = 0; i < n; i++) {
            for (int j = 1; j < n; j++) {
                degrees[i][j][MOUSE_TURN] = graph[i].size();
                degrees[i][j][CAT_TURN] = graph[j].size();
            }
        }
        for (int node : graph[0]) {
            for (int i = 0; i < n; i++) {
                degrees[i][node][CAT_TURN]--;
            }
        }
        for (int j = 1; j < n; j++) {
            results[0][j][MOUSE_TURN] = MOUSE_WIN;
            results[0][j][CAT_TURN] = MOUSE_WIN;
            qu.emplace(0, j, MOUSE_TURN);
            qu.emplace(0, j, CAT_TURN);
        }
        for (int i = 1; i < n; i++) {
            results[i][i][MOUSE_TURN] = CAT_WIN;
            results[i][i][CAT_TURN] = CAT_WIN;
            qu.emplace(i, i, MOUSE_TURN);
            qu.emplace(i, i, CAT_TURN);
        }
        while (!qu.empty()) {
            auto [mouse, cat, turn] = qu.front();
            qu.pop();
            int result = results[mouse][cat][turn];
            vector<tuple<int, int, int>> prevStates = GetPrevStates(mouse, cat, turn);
            for (auto & [prevMouse, prevCat, prevTurn] : prevStates) {
                if (results[prevMouse][prevCat][prevTurn] == DRAW) {
                    bool canWin = (result == MOUSE_WIN && prevTurn == MOUSE_TURN) || (result == CAT_WIN && prevTurn == CAT_TURN);
                    if (canWin) {
                        results[prevMouse][prevCat][prevTurn] = result;
                        qu.emplace(prevMouse, prevCat, prevTurn);
                    } else if (--degrees[prevMouse][prevCat][prevTurn] == 0) {
                        int loseResult = prevTurn == MOUSE_TURN ? CAT_WIN : MOUSE_WIN;
                        results[prevMouse][prevCat][prevTurn] = loseResult;
                        qu.emplace(prevMouse, prevCat, prevTurn);
                    }
                }
            }
        }
        return results[1][2][MOUSE_TURN];
    }

    vector<tuple<int, int, int>> GetPrevStates(int mouse, int cat, int turn) {
        vector<tuple<int, int, int>> prevStates;
        int prevTurn = turn == MOUSE_TURN ? CAT_TURN : MOUSE_TURN;
        if (prevTurn == MOUSE_TURN) {
            for (int & prev : graph[mouse]) {
                prevStates.emplace_back(prev, cat, prevTurn);
            }
        } else {
            for (int & prev : graph[cat]) {
                if (prev != 0) {
                    prevStates.emplace_back(mouse, prev, prevTurn);
                }
            }
        }
        return prevStates;
    }
};
```

```Python [sol1-Python3]
MOUSE_TURN = 0
CAT_TURN = 1

DRAW = 0
MOUSE_WIN = 1
CAT_WIN = 2

class Solution:
    def catMouseGame(self, graph: List[List[int]]) -> int:
        n = len(graph)
        degrees = [[[0, 0] for _ in range(n)] for _ in range(n)]
        results = [[[0, 0] for _ in range(n)] for _ in range(n)]
        for i in range(n):
            for j in range(1, n):
                degrees[i][j][MOUSE_TURN] = len(graph[i])
                degrees[i][j][CAT_TURN] = len(graph[j])
        for y in graph[0]:
            for i in range(n):
                degrees[i][y][CAT_TURN] -= 1

        q = deque()
        for j in range(1, n):
            results[0][j][MOUSE_TURN] = MOUSE_WIN
            results[0][j][CAT_TURN] = MOUSE_WIN
            q.append((0, j, MOUSE_TURN))
            q.append((0, j, CAT_TURN))
        for i in range(1, n):
            results[i][i][MOUSE_TURN] = CAT_WIN
            results[i][i][CAT_TURN] = CAT_WIN
            q.append((i, i, MOUSE_TURN))
            q.append((i, i, CAT_TURN))

        while q:
            mouse, cat, turn = q.popleft()
            result = results[mouse][cat][turn]
            if turn == MOUSE_TURN:
                prevStates = [(mouse, prev, CAT_TURN) for prev in graph[cat]]
            else:
                prevStates = [(prev, cat, MOUSE_TURN) for prev in graph[mouse]]
            for prevMouse, prevCat, prevTurn in prevStates:
                if prevCat == 0:
                    continue
                if results[prevMouse][prevCat][prevTurn] == DRAW:
                    canWin = result == MOUSE_WIN and prevTurn == MOUSE_TURN or result == CAT_WIN and prevTurn == CAT_TURN
                    if canWin:
                        results[prevMouse][prevCat][prevTurn] = result
                        q.append((prevMouse, prevCat, prevTurn))
                    else:
                        degrees[prevMouse][prevCat][prevTurn] -= 1
                        if degrees[prevMouse][prevCat][prevTurn] == 0:
                            results[prevMouse][prevCat][prevTurn] = CAT_WIN if prevTurn == MOUSE_TURN else MOUSE_WIN
                            q.append((prevMouse, prevCat, prevTurn))
        return results[1][2][MOUSE_TURN]
```

```JavaScript [sol1-JavaScript]
const MOUSE_TURN = 0, CAT_TURN = 1;
const DRAW = 0, MOUSE_WIN = 1, CAT_WIN = 2;
var catMouseGame = function(graph) {
    const n = graph.length;
    degrees = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2).fill(0)));
    results = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2).fill(0)));
    const queue = [];
    for (let i = 0; i < n; i++) {
        for (let j = 1; j < n; j++) {
            degrees[i][j][MOUSE_TURN] = graph[i].length;
            degrees[i][j][CAT_TURN] = graph[j].length;
        }
    }
    for (const node of graph[0]) {
        for (let i = 0; i < n; i++) {
            degrees[i][node][CAT_TURN]--;
        }
    }
    for (let j = 1; j < n; j++) {
        results[0][j][MOUSE_TURN] = MOUSE_WIN;
        results[0][j][CAT_TURN] = MOUSE_WIN;
        queue.push([0, j, MOUSE_TURN]);
        queue.push([0, j, CAT_TURN]);
    }
    for (let i = 1; i < n; i++) {
        results[i][i][MOUSE_TURN] = CAT_WIN;
        results[i][i][CAT_TURN] = CAT_WIN;
        queue.push([i, i, MOUSE_TURN]);
        queue.push([i, i, CAT_TURN]);
    }
    while (queue.length) {
        const state = queue.shift();
        const mouse = state[0], cat = state[1], turn = state[2];
        const result = results[mouse][cat][turn];
        const prevStates = getPrevStates(mouse, cat, turn, graph);
        for (const prevState of prevStates) {
            let prevMouse = prevState[0], prevCat = prevState[1], prevTurn = prevState[2];
            if (results[prevMouse][prevCat][prevTurn] === DRAW) {
                const canWin = (result === MOUSE_WIN && prevTurn === MOUSE_TURN) || (result === CAT_WIN && prevTurn === CAT_TURN);
                if (canWin) {
                    results[prevMouse][prevCat][prevTurn] = result;
                    queue.push([prevMouse, prevCat, prevTurn]);
                } else {
                    degrees[prevMouse][prevCat][prevTurn]--;
                    if (degrees[prevMouse][prevCat][prevTurn] == 0) {
                        const loseResult = prevTurn === MOUSE_TURN ? CAT_WIN : MOUSE_WIN;
                        results[prevMouse][prevCat][prevTurn] = loseResult;
                        queue.push([prevMouse, prevCat, prevTurn]);
                    }
                }
            }
        }
    }
    return results[1][2][MOUSE_TURN];
};

const getPrevStates = (mouse, cat, turn, graph) => {
    const prevStates = [];
    const prevTurn = turn == MOUSE_TURN ? CAT_TURN : MOUSE_TURN;
    if (prevTurn === MOUSE_TURN) {
        for (const prev of graph[mouse]) {
            prevStates.push([prev, cat, prevTurn]);
        }
    } else {
        for (const prev of graph[cat]) {
            if (prev != 0) {
                prevStates.push([mouse, prev, prevTurn]);
            }
        }
    }
    return prevStates;
}
```

```go [sol1-Golang]
const (
    mouseTurn = 0
    catTurn   = 1

    draw     = 0
    mouseWin = 1
    catWin   = 2
)

func catMouseGame(graph [][]int) int {
    n := len(graph)
    degrees := make([][][2]int, n)
    results := make([][][2]int, n)
    for i := range degrees {
        degrees[i] = make([][2]int, n)
        results[i] = make([][2]int, n)
    }
    for i, to := range graph {
        for j := 1; j < n; j++ {
            degrees[i][j][mouseTurn] = len(to)
            degrees[i][j][catTurn] = len(graph[j])
        }
    }
    for _, y := range graph[0] {
        for i := range degrees {
            degrees[i][y][catTurn]--
        }
    }

    type state struct{ mouse, cat, turn int }
    q := []state{}
    for j := 1; j < n; j++ {
        results[0][j][mouseTurn] = mouseWin
        results[0][j][catTurn] = mouseWin
        q = append(q, state{0, j, mouseTurn}, state{0, j, catTurn})
    }
    for i := 1; i < n; i++ {
        results[i][i][mouseTurn] = catWin
        results[i][i][catTurn] = catWin
        q = append(q, state{i, i, mouseTurn}, state{i, i, catTurn})
    }

    getPrevStates := func(s state) (prevStates []state) {
        if s.turn == mouseTurn {
            for _, prev := range graph[s.cat] {
                if prev != 0 {
                    prevStates = append(prevStates, state{s.mouse, prev, catTurn})
                }
            }
        } else {
            for _, prev := range graph[s.mouse] {
                prevStates = append(prevStates, state{prev, s.cat, mouseTurn})
            }
        }
        return
    }

    for len(q) > 0 {
        s := q[0]
        q = q[1:]
        result := results[s.mouse][s.cat][s.turn]
        for _, p := range getPrevStates(s) {
            prevMouse, prevCat, prevTurn := p.mouse, p.cat, p.turn
            if results[prevMouse][prevCat][prevTurn] == draw {
                canWin := result == mouseWin && prevTurn == mouseTurn || result == catWin && prevTurn == catTurn
                if canWin {
                    results[prevMouse][prevCat][prevTurn] = result
                    q = append(q, p)
                } else {
                    degrees[prevMouse][prevCat][prevTurn]--
                    if degrees[prevMouse][prevCat][prevTurn] == 0 {
                        if prevTurn == mouseTurn {
                            results[prevMouse][prevCat][prevTurn] = catWin
                        } else {
                            results[prevMouse][prevCat][prevTurn] = mouseWin
                        }
                        q = append(q, p)
                    }
                }
            }
        }
    }
    return results[1][2][mouseTurn]
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是图中的节点数。状态数是 $O(n^2)$，对于每个状态需要 $O(n)$ 的时间计算状态值，因此总时间复杂度是 $O(n^3)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 是图中的节点数。需要记录每个状态的度和结果，状态数是 $O(n^2)$。