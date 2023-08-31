## [1583.统计不开心的朋友 中文官方题解](https://leetcode.cn/problems/count-unhappy-friends/solutions/100000/tong-ji-bu-kai-xin-de-peng-you-by-leetcode-solutio)

#### 方法一：模拟

这道题看似复杂，其实只要进行模拟，即可得到答案。

共有 $n$ 位朋友，每位朋友都对应一个其余 $n-1$ 位朋友的亲近程度从高到低排列的朋友列表，列表中的下标越小的朋友亲近程度越高。

题目已经给出了二维数组 $\textit{preferences}$ 表示每位朋友对应的按亲近程度从高到低排列的朋友列表，但是并没有直接给出其余 $n-1$ 位朋友对应的亲近程度下标，因此需要进行预处理，存储每位朋友的其余 $n-1$ 位朋友对应的亲近程度下标。

具体而言，创建 $n$ 行 $n$ 列的二维数组 $\textit{order}$，其中 $\textit{order}[i][j]$ 表示朋友 $j$ 在 $i$ 的朋友列表中的亲近程度下标。遍历 $\textit{preferences}$ 即可填入 $\textit{order}$ 中的全部元素的值。

所有的朋友被分成 $\frac{n}{2}$ 对，为了快速知道每位朋友的配对的朋友，对于配对情况也需要进行预处理。创建长度为 $n$ 的数组 $\textit{match}$，如果 $x$ 和 $y$ 配对，则有 $\textit{match}[x]=y$ 以及 $\textit{match}[y]=x$。

进行预处理之后，即可统计不开心的朋友的数目。

遍历从 $0$ 到 $n-1$ 的每位朋友 $x$，进行如下操作。

1. 找到与朋友 $x$ 配对的朋友 $y$。
2. 找到朋友 $y$ 在朋友 $x$ 的朋友列表中的亲近程度下标，记为 $\textit{index}$。
3. 朋友 $x$ 的朋友列表中的下标从 $0$ 到 $\textit{index}-1$ 的朋友都是可能的 $u$。遍历每个可能的 $u$，找到与朋友 $u$ 配对的朋友 $v$。
4. 如果 $\textit{order}[u][x] < \textit{order}[u][v]$，则 $x$ 是不开心的朋友。

需要注意的是，对于每个朋友 $x$，只要能找到一个满足条件的四元组 $(x,y,u,v)$，则 $x$ 就是不开心的朋友。

```Java [sol1-Java]
class Solution {
    public int unhappyFriends(int n, int[][] preferences, int[][] pairs) {
        int[][] order = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n - 1; j++) {
                order[i][preferences[i][j]] = j;
            }
        }
        int[] match = new int[n];
        for (int[] pair : pairs) {
            int person0 = pair[0], person1 = pair[1];
            match[person0] = person1;
            match[person1] = person0;
        }
        int unhappyCount = 0;
        for (int x = 0; x < n; x++) {
            int y = match[x];
            int index = order[x][y];
            for (int i = 0; i < index; i++) {
                int u = preferences[x][i];
                int v = match[u];
                if (order[u][x] < order[u][v]) {
                    unhappyCount++;
                    break;
                }
            }
        }
        return unhappyCount;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int UnhappyFriends(int n, int[][] preferences, int[][] pairs) {
        int[,] order = new int[n, n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n - 1; j++) {
                order[i, preferences[i][j]] = j;
            }
        }
        int[] match = new int[n];
        foreach (int[] pair in pairs) {
            int person0 = pair[0], person1 = pair[1];
            match[person0] = person1;
            match[person1] = person0;
        }
        int unhappyCount = 0;
        for (int x = 0; x < n; x++) {
            int y = match[x];
            int index = order[x, y];
            for (int i = 0; i < index; i++) {
                int u = preferences[x][i];
                int v = match[u];
                if (order[u, x] < order[u, v]) {
                    unhappyCount++;
                    break;
                }
            }
        }
        return unhappyCount;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int unhappyFriends(int n, vector<vector<int>>& preferences, vector<vector<int>>& pairs) {
        vector<vector<int>> order(n, vector<int>(n));
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n - 1; ++j) {
                order[i][preferences[i][j]] = j;
            }
        }
        vector<int> match(n);
        for (const auto& pr: pairs) {
            match[pr[0]] = pr[1];
            match[pr[1]] = pr[0];
        }

        int unhappyCount = 0;
        for (int x = 0; x < n; ++x) {
            int y = match[x];
            int index = order[x][y];
            for (int i = 0; i < index; ++i) {
                int u = preferences[x][i];
                int v = match[u];
                if (order[u][x] < order[u][v]) {
                    ++unhappyCount;
                    break;
                }
            }
        }
        return unhappyCount;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def unhappyFriends(self, n: int, preferences: List[List[int]], pairs: List[List[int]]) -> int:
        order = [[0] * n for _ in range(n)]
        for i in range(n):
            for j in range(n - 1):
                order[i][preferences[i][j]] = j
        
        match = [0] * n
        for x, y in pairs:
            match[x] = y
            match[y] = x

        unhappyCount = 0
        for x in range(n):
            y = match[x]
            index = order[x][y]
            for i in range(index):
                u = preferences[x][i]
                v = match[u]
                if order[u][x] < order[u][v]:
                    unhappyCount += 1
                    break
        
        return unhappyCount
```

```JavaScript [sol1-JavaScript]
var unhappyFriends = function(n, preferences, pairs) {
    const order = new Array(n).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n - 1; j++) {
            order[i][preferences[i][j]] = j;
        }
    }
    const match = new Array(n).fill(0);
    for (const pair of pairs) {
        let person0 = pair[0], person1 = pair[1];
        match[person0] = person1;
        match[person1] = person0;
    }
    let unhappyCount = 0;
    for (let x = 0; x < n; x++) {
        const y = match[x];
        const index = order[x][y];
        for (let i = 0; i < index; i++) {
            const u = preferences[x][i];
            const v = match[u];
            if (order[u][x] < order[u][v]) {
                unhappyCount++;
                break;
            }
        }
    }
    return unhappyCount;
};
```

```C [sol1-C]
int unhappyFriends(int n, int** preferences, int preferencesSize, int* preferencesColSize, int** pairs, int pairsSize, int* pairsColSize) {
    int order[n][n];
    memset(order, 0, sizeof(order));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n - 1; ++j) {
            order[i][preferences[i][j]] = j;
        }
    }
    int match[n];
    memset(match, 0, sizeof(match));
    for (int i = 0; i < pairsSize; ++i) {
        int* pr = pairs[i];
        match[pr[0]] = pr[1];
        match[pr[1]] = pr[0];
    }

    int unhappyCount = 0;
    for (int x = 0; x < n; ++x) {
        int y = match[x];
        int index = order[x][y];
        for (int i = 0; i < index; ++i) {
            int u = preferences[x][i];
            int v = match[u];
            if (order[u][x] < order[u][v]) {
                ++unhappyCount;
                break;
            }
        }
    }
    return unhappyCount;
}
```

```go [sol1-Golang]
func unhappyFriends(n int, preferences [][]int, pairs [][]int) (ans int) {
    order := make([][]int, n)
    for i, preference := range preferences {
        order[i] = make([]int, n)
        for j, p := range preference {
            order[i][p] = j
        }
    }
    match := make([]int, n)
    for _, p := range pairs {
        match[p[0]] = p[1]
        match[p[1]] = p[0]
    }

    for x, y := range match {
        index := order[x][y]
        for _, u := range preferences[x][:index] {
            v := match[u]
            if order[u][x] < order[u][v] {
                ans++
                break
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。
  预处理需要填入二维数组 $\textit{order}$ 和数组 $\textit{match}$ 中的值，时间复杂度分别是 $O(n^2)$ 和 $O(n)$。
  统计不开心的朋友的数目时，需要遍历每个 $x$，找到满足要求的四元组 $(x,y,u,v)$，其中遍历 $u$ 的时间复杂度是 $O(n)$，在已知 $x$ 和 $u$ 的情况下，可以在 $O(1)$ 时间内得到 $y$ 和 $v$，因此时间复杂度是 $O(n^2)$。
  故总时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(n^2)$。空间复杂度取决于预处理时创建的二维数组 $\textit{order}$ 和数组 $\textit{match}$，其大小分别为 $n \times n$ 和 $n$，因此空间复杂度是 $O(n^2)$。