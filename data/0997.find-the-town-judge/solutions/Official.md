## [997.找到小镇的法官 中文官方题解](https://leetcode.cn/problems/find-the-town-judge/solutions/100000/zhao-dao-xiao-zhen-de-fa-guan-by-leetcod-0dcg)
#### 预备知识

本题需要用到有向图中节点的入度和出度的概念。在有向图中，一个节点的入度是指向该节点的边的数量；而一个节点的出度是从该节点出发的边的数量。

#### 方法一：计算各节点的入度和出度

**思路及解法**

题干描述了一个有向图。每个人是图的节点，$\textit{trust}$ 的元素 $\textit{trust}[i]$ 是图的有向边，从 $\textit{trust}[i][0]$ 指向 $\textit{trust}[i][1]$。我们可以遍历 $\textit{trust}$，统计每个节点的入度和出度，存储在 $\textit{inDegrees}$ 和 $\textit{outDegrees}$ 中。

根据题意，在法官存在的情况下，法官不相信任何人，每个人（除了法官外）都信任法官，且只有一名法官。因此法官这个节点的入度是 $n-1$, 出度是 $0$。

我们可以遍历每个节点的入度和出度，如果找到一个符合条件的节点，由于题目保证只有一个法官，我们可以直接返回结果；如果不存在符合条件的点，则返回 $-1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def findJudge(self, n: int, trust: List[List[int]]) -> int:
        inDegrees = Counter(y for _, y in trust)
        outDegrees = Counter(x for x, _ in trust)
        return next((i for i in range(1, n + 1) if inDegrees[i] == n - 1 and outDegrees[i] == 0), -1)
```

```Java [sol1-Java]
class Solution {
    public int findJudge(int n, int[][] trust) {
        int[] inDegrees = new int[n + 1];
        int[] outDegrees = new int[n + 1];
        for (int[] edge : trust) {
            int x = edge[0], y = edge[1];
            ++inDegrees[y];
            ++outDegrees[x];
        }
        for (int i = 1; i <= n; ++i) {
            if (inDegrees[i] == n - 1 && outDegrees[i] == 0) {
                return i;
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindJudge(int n, int[][] trust) {
        int[] inDegrees = new int[n + 1];
        int[] outDegrees = new int[n + 1];
        foreach (int[] edge in trust) {
            int x = edge[0], y = edge[1];
            ++inDegrees[y];
            ++outDegrees[x];
        }
        for (int i = 1; i <= n; ++i) {
            if (inDegrees[i] == n - 1 && outDegrees[i] == 0) {
                return i;
            }
        }
        return -1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findJudge(int n, vector<vector<int>>& trust) {
        vector<int> inDegrees(n + 1);
        vector<int> outDegrees(n + 1);
        for (auto& edge : trust) {
            int x = edge[0], y = edge[1];
            ++inDegrees[y];
            ++outDegrees[x];
        }
        for (int i = 1; i <= n; ++i) {
            if (inDegrees[i] == n - 1 && outDegrees[i] == 0) {
                return i;
            }
        }
        return -1;
    }
};
```

```C [sol1-C]
int findJudge(int n, int** trust, int trustSize, int* trustColSize){
    int* inDegrees = (int *)malloc(sizeof(int)*(n+1));
    int* outDegrees = (int *)malloc(sizeof(int)*(n+1));
    memset(inDegrees, 0, sizeof(int)*(n+1));
    memset(outDegrees, 0, sizeof(int)*(n+1));
    for (int i = 0; i < trustSize; ++i) {
        int x = trust[i][0], y = trust[i][1];
        ++inDegrees[y];
        ++outDegrees[x];
    }
    for (int i = 1; i <= n; ++i) {
        if (inDegrees[i] == n - 1 && outDegrees[i] == 0) {
            return i;
        }
    }
    return -1;
}
```

```JavaScript [sol1-JavaScript]
var findJudge = function(n, trust) {
    const inDegrees = new Array(n + 1).fill(0);
    const outDegrees = new Array(n + 1).fill(0);
    for (const edge of trust) {
        const x = edge[0], y = edge[1];
        ++inDegrees[y];
        ++outDegrees[x];
    }
    for (let i = 1; i <= n; ++i) {
        if (inDegrees[i] === n - 1 && outDegrees[i] === 0) {
            return i;
        }
    }
    return -1;
};
```

```go [sol1-Golang]
func findJudge(n int, trust [][]int) int {
    inDegrees := make([]int, n+1)
    outDegrees := make([]int, n+1)
    for _, t := range trust {
        inDegrees[t[1]]++
        outDegrees[t[0]]++
    }
    for i := 1; i <= n; i++ {
        if inDegrees[i] == n-1 && outDegrees[i] == 0 {
            return i
        }
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $m$ 是 $\textit{trust}$ 的长度。首先需要遍历 $\textit{trust}$ 计算出 $\textit{inDegrees}$ 和 $\textit{outDegrees}$，然后需要遍历 $\textit{inDegrees}$ 和 $\textit{outDegrees}$ 来确定法官。

- 空间复杂度：$O(n)$。记录各个节点的入度和出度需要 $O(n)$ 的空间。