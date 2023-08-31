## [1130.叶值的最小代价生成树 中文官方题解](https://leetcode.cn/problems/minimum-cost-tree-from-leaf-values/solutions/100000/xie-zhi-de-zui-xiao-dai-jie-sheng-cheng-26ozf)
#### 方法一：动态规划

已知数组 $\textit{arr}$ 与二叉树的中序遍历的所有叶子节点对应，并且二叉树的每个节点都有 $0$ 个节点或 $2$ 个节点。考虑数组 $\textit{arr}$ 可以生成的所有二叉树，我们可以将 $\textit{arr}$ 切分成任意两个非空子数组，分别对应左子树和右子树，然后递归地对两个非空子树组执行相同的操作，直到子数组大小等于 $1$，即叶子节点，那么一种切分方案对应一个合法的二叉树。

使用 $\textit{dp}[i][j]$ 表示子数组 $[i, j]~(i \le j)$ 对应的子树所有非叶子节点的最小总和，那么 $\textit{dp}[i][j]$ 可以通过切分子树求得，状态转移方程如下：

$$
\textit{dp}[i][j] = 
\begin{cases}
0, & i = j \\
\min \limits _{k \in [i,j)} ~ (dp[i][k] + dp[k + 1][j] + m_{ik} \times m_{(k+1)j}), & i \lt j
\end{cases}
$$

其中 $m_{ik}$ 表示子数组 $[i, k]$ 的最大值，可以预先计算并保存下来。

```C++ [sol1-C++]
class Solution {
public:
    int mctFromLeafValues(vector<int>& arr) {
        int n = arr.size();
        vector<vector<int>> dp(n, vector<int>(n, INT_MAX / 4)), mval(n, vector<int>(n));
        for (int j = 0; j < n; j++) {
            mval[j][j] = arr[j];
            dp[j][j] = 0;
            for (int i = j - 1; i >= 0; i--) {
                mval[i][j] = max(arr[i], mval[i + 1][j]);
                for (int k = i; k < j; k++) {
                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j]);
                }
            }
        }
        return dp[0][n - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int mctFromLeafValues(int[] arr) {
        int n = arr.length;
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            Arrays.fill(dp[i], Integer.MAX_VALUE / 4);
        }
        int[][] mval = new int[n][n];
        for (int j = 0; j < n; j++) {
            mval[j][j] = arr[j];
            dp[j][j] = 0;
            for (int i = j - 1; i >= 0; i--) {
                mval[i][j] = Math.max(arr[i], mval[i + 1][j]);
                for (int k = i; k < j; k++) {
                    dp[i][j] = Math.min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MctFromLeafValues(int[] arr) {
        int n = arr.Length;
        int[][] dp = new int[n][];
        for (int i = 0; i < n; i++) {
            dp[i] = new int[n];
            Array.Fill(dp[i], int.MaxValue / 4);
        }
        int[][] mval = new int[n][];
        for (int i = 0; i < n; i++) {
            mval[i] = new int[n];
        }
        for (int j = 0; j < n; j++) {
            mval[j][j] = arr[j];
            dp[j][j] = 0;
            for (int i = j - 1; i >= 0; i--) {
                mval[i][j] = Math.Max(arr[i], mval[i + 1][j]);
                for (int k = i; k < j; k++) {
                    dp[i][j] = Math.Min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def mctFromLeafValues(self, arr: List[int]) -> int:
        n = len(arr)
        dp = [[inf for i in range(n)] for j in range(n)]
        mval = [[0 for i in range(n)] for j in range(n)]
        for j in range(n):
            mval[j][j] = arr[j]
            dp[j][j] = 0
            for i in range(j - 1, -1, -1):
                mval[i][j] = max(arr[i], mval[i + 1][j])
                for k in range(i, j):
                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j])
        return dp[0][n - 1]
```

```JavaScript [sol1-JavaScript]
var mctFromLeafValues = function(arr) {
    const n = arr.length;
    const dp = Array(n).fill(0).map(() => Array(n).fill(Infinity));
    const mval = Array(n).fill(0).map(() => Array(n));
    for (let j = 0; j < n; j++) {
        mval[j][j] = arr[j];
        dp[j][j] = 0;
    }
    for (let i = n - 1; i >= 0; i--) {
        for (let j = i + 1; j < n; j++) {
          mval[i][j] = Math.max(arr[i], mval[i + 1][j]);
          for (let k = i; k < j; k++) {
              dp[i][j] = Math.min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j]);
          }
        }
    }
    return dp[0][n - 1];
}
```

```Golang [sol1-Golang]
func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func mctFromLeafValues(arr []int) int {
    n := len(arr)
    dp, mval := make([][]int, n), make([][]int, n)
    for i := 0; i < n; i++ {
        dp[i] = make([]int, n)
        mval[i] = make([]int, n)
    }
    for j := 0; j < n; j++ {
        mval[j][j] = arr[j]
        for i := j - 1; i >= 0; i-- {
            mval[i][j] = max(arr[i], mval[i + 1][j])
            dp[i][j] = 0x3f3f3f3f
            for k := i; k < j; k++ {
                dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j])
            }
        }
    }
    return dp[0][n - 1]
}
```

```C [sol1-C]
const int INF = 0x3f3f3f3f;

static inline int max(int a, int b) {
    return a > b ? a : b;
}

static inline int min(int a, int b) {
    return a < b ? a : b;
}

int mctFromLeafValues(int* arr, int arrSize) {
    int n = arrSize;
    int dp[n][n];
    int mval[n][n];
    memset(dp, 0x3f, sizeof(dp));
    memset(mval, 0, sizeof(mval));
    for (int j = 0; j < n; j++) {
        mval[j][j] = arr[j];
        dp[j][j] = 0;
        for (int i = j - 1; i >= 0; i--) {
            mval[i][j] = max(arr[i], mval[i + 1][j]);
            for (int k = i; k < j; k++) {
                dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j] + mval[i][k] * mval[k + 1][j]);
            }
        }
    }
    return dp[0][n - 1];
}
```

**复杂度分析**

+ 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。三重循环需要 $O(n^3)$ 的空间。

+ 空间复杂度：$O(n^2)$。保存 $\textit{dp}$ 和 $\textit{mval}$ 需要 $O(n^2)$ 的空间。

#### 方法二：单调栈

方法一的思路是自上而下构建二叉树，这里我们可以尝试自下而上构建二叉树：

1. 选择 $\textit{arr}$ 两个相邻的值，即两个节点，将它们作为一个新节点的左子节点和右子节点；

2. 将这个新节点在数组 $\textit{arr}$ 替代这两个节点；

3. 如果 $\textit{arr}$ 剩余的元素数目大于 $1$，执行步骤 $1$，否则终止，那么剩余的节点就是构建的二叉树的根节点。

问题可以转化为：**给定一个数组 $\textit{arr}$，不断地合并相邻的数，合并代价为两个数的乘积，合并之后的数为两个数的最大值，直到数组只剩一个数，求最小合并代价和**。

> 假设一个数 $\textit{arr}[i] ~ (0 \lt i \lt n - 1$)，满足 $\textit{arr}[i-1] \ge \textit{arr}[i]$ 且 $\textit{arr}[i] \le \textit{arr}[i+1]$，如果 $\textit{arr}[i-1] \le \textit{arr}[i+1]$，那么优先将 $\textit{arr}[i]$ 与 $\textit{arr}[i-1]$ 合并是最优的，反之如果 $\textit{arr}[i-1] \gt \textit{arr}[i+1]$，那么优先将 $\textit{arr}[i]$ 与 $\textit{arr}[i+1]$ 合并是最优的（读者可以思考一下，就不给证明了）。

按照这种思路，套用单调栈算法（栈元素从底到顶是严格递减的），我们遍历数组 $\textit{arr}$，记当前遍历的值为 $x$。

如果栈非空且栈顶元素小于等于 $x$，那么说明栈顶元素（类似于 $\textit{arr}[i]$）是符合前面所说的最优合并的条件，将栈顶元素 $y$ 出栈：

+ 如果栈空或栈顶元素大于 $x$，那么将 $y$ 与 $x$ 合并，合并代价为 $x \times y$，合并之后的值为 $x$；

+ 否则将 $y$ 与栈顶元素合并，合并代价为 $y$ 与栈顶元素的乘积，合并之后的值为栈顶元素。

重复以上过程直到栈空或栈顶元素大于 $x$，然后将 $x$ 入栈。

经过以上合并过程后，栈中的元素从底到顶是严格递减的，因此可以不断地将栈顶的两个元素出栈，合并，再入栈，直到栈元素数目小于 $2$。返回最终合并代价和即可。

```C++ [sol2-C++]
class Solution {
public:
    int mctFromLeafValues(vector<int>& arr) {
        int res = 0;
        stack<int> stk;
        for (int x : arr) {
            while (!stk.empty() && stk.top() <= x) {
                int y = stk.top();
                stk.pop();
                if (stk.empty() || stk.top() > x) {
                    res += y * x;
                } else {
                    res += stk.top() * y;
                }
            }
            stk.push(x);
        }
        while (stk.size() >= 2) {
            int x = stk.top();
            stk.pop();
            res += stk.top() * x;
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int mctFromLeafValues(int[] arr) {
        int res = 0;
        Deque<Integer> stk = new ArrayDeque<Integer>();
        for (int x : arr) {
            while (!stk.isEmpty() && stk.peek() <= x) {
                int y = stk.pop();
                if (stk.isEmpty() || stk.peek() > x) {
                    res += y * x;
                } else {
                    res += stk.peek() * y;
                }
            }
            stk.push(x);
        }
        while (stk.size() >= 2) {
            int x = stk.pop();
            res += stk.peek() * x;
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MctFromLeafValues(int[] arr) {
        int res = 0;
        Stack<int> stk = new Stack<int>();
        foreach (int x in arr) {
            while (stk.Count > 0 && stk.Peek() <= x) {
                int y = stk.Pop();
                if (stk.Count == 0 || stk.Peek() > x) {
                    res += y * x;
                } else {
                    res += stk.Peek() * y;
                }
            }
            stk.Push(x);
        }
        while (stk.Count >= 2) {
            int x = stk.Pop();
            res += stk.Peek() * x;
        }
        return res;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def mctFromLeafValues(self, arr: List[int]) -> int:
        res = 0
        stack = []
        for x in arr:
            while stack and stack[-1] <= x:
                y = stack.pop()
                if not stack or stack[-1] > x:
                    res += y * x
                else:
                    res += stack[-1] * y
            stack.append(x)
        while len(stack) >= 2:
            x = stack.pop()
            res += stack[-1] * x
        return res
```

```JavaScript [sol2-JavaScript]
var mctFromLeafValues = function(arr) {
    let res = 0;
    let stack = [];
    for (let x of arr) {
        while (stack.length && stack[stack.length - 1] <= x) {
            let y = stack.pop();
            if (!stack.length || stack[stack.length - 1] > x) {
                res += y * x;
            } else {
                res += stack[stack.length - 1] * y;
            }
        }
        stack.push(x);
    }
    while (stack.length >= 2) {
        let x = stack.pop();
        res += stack[stack.length - 1] * x;
    }
    return res;
}
```

```Golang [sol2-Golang]
func mctFromLeafValues(arr []int) int {
    res, stk := 0, []int{}
    for _, x := range arr {
        for len(stk) > 0 && stk[len(stk) - 1] <= x {
            if len(stk) == 1 || stk[len(stk) - 2] > x {
                res += stk[len(stk) - 1] * x
            } else {
                res += stk[len(stk) - 2] * stk[len(stk) - 1]
            }
            stk = stk[:len(stk)-1]
        }
        stk = append(stk, x)
    }
    for len(stk) > 1 {
        res += stk[len(stk) - 2] * stk[len(stk) - 1]
        stk = stk[:len(stk)-1]
    }
    return res
}
```

```C [sol2-C]
int mctFromLeafValues(int* arr, int arrSize) {
    int res = 0;
    int stack[arrSize];
    int top = 0;
    for (int i = 0; i < arrSize; i++) {
        int x = arr[i];
        while (top > 0 && stack[top - 1] <= x) {
            int y = stack[top - 1];
            top--;
            if (top == 0 || stack[top - 1] > x) {
                res += y * x;
            } else {
                res += stack[top - 1] * y;
            }
        }
        stack[top++] = x;
    }
    while (top >= 2) {
        int x = stack[top - 1];
        top--;
        res += stack[top - 1] * x;
    }
    return res;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{arr}$ 的长度。每次循环都有入栈或出栈操作，总次数不超过 $2 \times n$，因此时间复杂度为 $O(n)$。

+ 空间复杂度：$O(n)$。栈 $\textit{stk}$ 需要 $O(n)$ 的空间。