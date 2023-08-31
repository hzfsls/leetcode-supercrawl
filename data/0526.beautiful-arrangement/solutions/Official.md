## [526.优美的排列 中文官方题解](https://leetcode.cn/problems/beautiful-arrangement/solutions/100000/you-mei-de-pai-lie-by-leetcode-solution-vea2)
#### 方法一：回溯

**思路和算法**

我们可以使用回溯法解决本题，从左向右依次向目标排列中放入数即可。

具体地，我们定义函数 $\textit{backtrack}(\textit{index}, n)$，表示尝试向位置 $\textit{index}$ 放入数。其中 $n$ 表示排列的长度。在当前函数中，我们首先找到一个符合条件的未被使用过的数，然后递归地执行 $\textit{backtrack}(\textit{index}+1, n)$，当该函数执行完毕，回溯到当前层，我们再尝试下一个符合条件的未被使用过的数即可。

回溯过程中，我们可以用 $\textit{vis}$ 数组标记哪些数被使用过，每次我们选中一个数 $x$，我们就将 $\textit{vis}[x]$ 标记为 $\texttt{true}$，回溯完成后，我们再将其置为 $\texttt{false}$。

特别地，为了优化回溯效率，我们可以预处理每个位置的符合条件的数有哪些，用二维数组 $\textit{match}$ 保存。当我们尝试向位置 $\textit{index}$ 放入数时，我们只需要遍历 $\textit{match}[\textit{index}]$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> match;
    vector<int> vis;
    int num;

    void backtrack(int index, int n) {
        if (index == n + 1) {
            num++;
            return;
        }
        for (auto &x : match[index]) {
            if (!vis[x]) {
                vis[x] = true;
                backtrack(index + 1, n);
                vis[x] = false;
            }
        }
    }

    int countArrangement(int n) {
        vis.resize(n + 1);
        match.resize(n + 1);
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                if (i % j == 0 || j % i == 0) {
                    match[i].push_back(j);
                }
            }
        }
        backtrack(1, n);
        return num;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<Integer>[] match;
    boolean[] vis;
    int num;

    public int countArrangement(int n) {
        vis = new boolean[n + 1];
        match = new List[n + 1];
        for (int i = 0; i <= n; i++) {
            match[i] = new ArrayList<Integer>();
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                if (i % j == 0 || j % i == 0) {
                    match[i].add(j);
                }
            }
        }
        backtrack(1, n);
        return num;
    }

    public void backtrack(int index, int n) {
        if (index == n + 1) {
            num++;
            return;
        }
        for (int x : match[index]) {
            if (!vis[x]) {
                vis[x] = true;
                backtrack(index + 1, n);
                vis[x] = false;
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    IList<int>[] match;
    bool[] vis;
    int num;

    public int CountArrangement(int n) {
        vis = new bool[n + 1];
        match = new IList<int>[n + 1];
        for (int i = 0; i <= n; i++) {
            match[i] = new List<int>();
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                if (i % j == 0 || j % i == 0) {
                    match[i].Add(j);
                }
            }
        }
        Backtrack(1, n);
        return num;
    }

    public void Backtrack(int index, int n) {
        if (index == n + 1) {
            num++;
            return;
        }
        foreach (int x in match[index]) {
            if (!vis[x]) {
                vis[x] = true;
                Backtrack(index + 1, n);
                vis[x] = false;
            }
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var countArrangement = function(n) {
    const vis = new Array(n + 1).fill(0);
    const match = new Array(n + 1).fill(0);
    let num = 0;
    for (let i = 0; i <= n; i++) {
        match[i] = [];
    }
    for (let i = 1; i <= n; i++) {
        for (let j = 1; j <= n; j++) {
            if (i % j === 0 || j % i === 0) {
                match[i].push(j);
            }
        }
    }

    const backtrack = (index, n) => {
        if (index === n + 1) {
            num++;
            return;
        }
        for (const x of match[index]) {
            if (!vis[x]) {
                vis[x] = true;
                backtrack(index + 1, n);
                vis[x] = false;
            }
        }
    }
    
    backtrack(1, n);
    return num;
};
```

```Python [sol1-Python3]
class Solution:
    def countArrangement(self, n: int) -> int:
        match = defaultdict(list)
        for i in range(1, n + 1):
            for j in range(1, n + 1):
                if i % j == 0 or j % i == 0:
                    match[i].append(j)
        
        num = 0
        vis = set()

        def backtrack(index: int) -> None:
            if index == n + 1:
                nonlocal num
                num += 1
                return
            
            for x in match[index]:
                if x not in vis:
                    vis.add(x)
                    backtrack(index + 1)
                    vis.discard(x)
                   
        backtrack(1)
        return num
```

```C [sol1-C]
int **match;
int *matchColSize;
int *vis;
int num;

void backtrack(int index, int n) {
    if (index == n + 1) {
        num++;
        return;
    }
    for (int i = 0; i < matchColSize[index]; i++) {
        int x = match[index][i];
        if (!vis[x]) {
            vis[x] = true;
            backtrack(index + 1, n);
            vis[x] = false;
        }
    }
}

int countArrangement(int n) {
    vis = malloc(sizeof(int) * (n + 1));
    match = malloc(sizeof(int *) * (n + 1));
    matchColSize = malloc(sizeof(int) * (n + 1));
    memset(matchColSize, 0, sizeof(int) * (n + 1));
    memset(vis, 0, sizeof(int) * (n + 1));
    num = 0;
    for (int i = 1; i <= n; i++) {
        match[i] = malloc(sizeof(int) * (n));
        for (int j = 1; j <= n; j++) {
            if (i % j == 0 || j % i == 0) {
                match[i][matchColSize[i]++] = j;
            }
        }
    }
    backtrack(1, n);
    return num;
}
```

```go [sol1-Golang]
func countArrangement(n int) (ans int) {
    vis := make([]bool, n+1)
    match := make([][]int, n+1)
    for i := 1; i <= n; i++ {
        for j := 1; j <= n; j++ {
            if i%j == 0 || j%i == 0 {
                match[i] = append(match[i], j)
            }
        }
    }

    var backtrack func(int)
    backtrack = func(index int) {
        if index > n {
            ans++
            return
        }
        for _, x := range match[index] {
            if !vis[x] {
                vis[x] = true
                backtrack(index + 1)
                vis[x] = false
            }
        }
    }
    backtrack(1)
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n!)$，其中 $n$ 为排列的长度。预处理 $\textit{match}$ 数组的时间复杂度为 $O(n^2)$，回溯的时间复杂度为 $O(n!)$，因此总时间复杂度为 $O(n^2 + n!) = O(n!)$。

- 空间复杂度：$O(n^2)$，我们需要 $O(n^2)$ 的空间保存 $\textit{match}$ 数组，递归的栈空间大小为 $O(n)$，因此总空间复杂度为 $O(n^2 + n) = O(n^2)$。


#### 方法二：状态压缩 + 动态规划

**思路和算法**

由于题目保证了排列的长度 $n$ 至多为 $15$，因此我们可以用一个位数为 $n$ 的二进制数 $\textit{mask}$ 表示排列中的数被选取的情况。若 $\textit{mask}$ 中的第 $i$ 位为 $1$（从 $0$ 开始编号），则数 $i+1$ 已经被选取，否则就还未被选取。我们可以利用这样的二进制数表示选取数的过程的状态，以 $n = 4, \textit{mask} = (0110)_2$ 为例，这代表数 $2,3$ 都已经被选取，并以任意顺序放置在排列中前两个位置。

令 $f[\textit{mask}]$ 表示状态为 $\textit{mask}$ 时的可行方案总数，这样答案即为 $f[2^n - 1]$。

这样我们可以得到状态间的转移方程：

$$
f[\textit{mask}] = \sum_{i \in \textit{mask} ~\wedge \big( i+1 \mid \textit{num}(\textit{mask}) ~\vee~ \textit{num}(\textit{mask}) \mid i+1 \big) } f[\textit{mask} - 2^i]
$$

其中 $\textit{num}(\textit{mask})$ 表示二进制数 $\textit{mask}$ 中 $1$ 的个数，$x \mid y$ 表示 $x$ 可以整除 $y$。

状态转移方程的含义为，当我们想要计算 $f[\textit{mask}]$ 时，我们只需要在前 $\textit{num}(\textit{mask}) - 1$ 位都已经放置了数的情况下，考虑第 $\textit{num}(\textit{mask})$ 位要放置的数即可，我们枚举当前位的符合条件的数，并将方案数累加到 $f[\textit{mask}]$ 中即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int countArrangement(int n) {
        vector<int> f(1 << n);
        f[0] = 1;
        for (int mask = 1; mask < (1 << n); mask++) {
            int num = __builtin_popcount(mask);
            for (int i = 0; i < n; i++) {
                if (mask & (1 << i) && (num % (i + 1) == 0 || (i + 1) % num == 0)) {
                    f[mask] += f[mask ^ (1 << i)];
                }
            }
        }
        return f[(1 << n) - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countArrangement(int n) {
        int[] f = new int[1 << n];
        f[0] = 1;
        for (int mask = 1; mask < (1 << n); mask++) {
            int num = Integer.bitCount(mask);
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) != 0 && ((num % (i + 1)) == 0 || (i + 1) % num == 0)) {
                    f[mask] += f[mask ^ (1 << i)];
                }
            }
        }
        return f[(1 << n) - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountArrangement(int n) {
        int[] f = new int[1 << n];
        f[0] = 1;
        for (int mask = 1; mask < (1 << n); mask++) {
            int num = BitCount(mask);
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) != 0 && ((num % (i + 1)) == 0 || (i + 1) % num == 0)) {
                    f[mask] += f[mask ^ (1 << i)];
                }
            }
        }
        return f[(1 << n) - 1];
    }

    private static int BitCount(int i) {
        i = i - ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0f0f0f0f;
        i = i + (i >> 8);
        i = i + (i >> 16);
        return i & 0x3f;
    }
}
```

```JavaScript [sol2-JavaScript]
var countArrangement = function(n) {
    const f = new Array(1 << n).fill(0);
    f[0] = 1;
    for (let mask = 1; mask < (1 << n); mask++) {
        const num = mask.toString(2).split('0').join('').length
        for (let i = 0; i < n; i++) {
            if ((mask & (1 << i)) !== 0 && ((num % (i + 1)) === 0 || (i + 1) % num === 0)) {
                f[mask] += f[mask ^ (1 << i)];
            }
        }
    }
    return f[(1 << n) - 1];
};
```

```Python [sol2-Python3]
class Solution:
    def countArrangement(self, n: int) -> int:
        f = [0] * (1 << n)
        f[0] = 1
        for mask in range(1, 1 << n):
            num = bin(mask).count("1")
            for i in range(n):
                if mask & (1 << i) and (num % (i + 1) == 0 or (i + 1) % num == 0):
                    f[mask] += f[mask ^ (1 << i)]
        
        return f[(1 << n) - 1]
```

```C [sol2-C]
int countArrangement(int n) {
    int f[1 << n];
    memset(f, 0, sizeof(f));
    f[0] = 1;
    for (int mask = 1; mask < (1 << n); mask++) {
        int num = __builtin_popcount(mask);
        for (int i = 0; i < n; i++) {
            if (mask & (1 << i) && (num % (i + 1) == 0 || (i + 1) % num == 0)) {
                f[mask] += f[mask ^ (1 << i)];
            }
        }
    }
    return f[(1 << n) - 1];
}
```

```go [sol2-Golang]
func countArrangement(n int) int {
    f := make([]int, 1<<n)
    f[0] = 1
    for mask := 1; mask < 1<<n; mask++ {
        num := bits.OnesCount(uint(mask))
        for i := 0; i < n; i++ {
            if mask>>i&1 > 0 && (num%(i+1) == 0 || (i+1)%num == 0) {
                f[mask] += f[mask^1<<i]
            }
        }
    }
    return f[1<<n-1]
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为排列的长度。我们需要 $O(2^n)$ 的时间枚举所有状态，每个状态需要 $O(n)$ 的时间检查所有符合条件的数。因此总时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(2^n)$，其中 $n$ 为排列的长度。我们需要 $O(2^n)$ 的空间保存状态。