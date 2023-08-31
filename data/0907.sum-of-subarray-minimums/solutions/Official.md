## [907.子数组的最小值之和 中文官方题解](https://leetcode.cn/problems/sum-of-subarray-minimums/solutions/100000/zi-shu-zu-de-zui-xiao-zhi-zhi-he-by-leet-bp3k)

#### 方法一：单调栈

考虑所有满足以数组 $\textit{arr}$ 中的某个元素 $\textit{arr}[i]$ 为最右且最小的元素的子序列个数 $C[i]$，那么题目要求求连续子数组的最小值之和即为 $\sum_{i=0}^{n-1} \limits \textit{arr}[i] \times C[i]$，其中数组 $\textit{arr}$ 的长度为 $n$。我们必须假设当前元素为最右边且最小的元素，这样才可以构造互不相交的子序列，否则会出现多次计算，因为一个数组的最小值可能不唯一。

经过以上思考，我们只需要找到每个元素 $\textit{arr}[i]$ 以该元素为最右且最小的子序列的数目 $\textit{left}[i]$，以及以该元素为最左且最小的子序列的数目 $\textit{right}[i]$，则以 $\textit{arr}[i]$ 为最小元素的子序列的数目合计为 $\textit{left}[i] \times \textit{right[i]}$。当然为了防止重复计算，我们可以设 $\textit{arr}[i]$ 左边的元素都必须满足小于等于 $\textit{arr}[i]$，$\textit{arr}[i]$ 右边的元素必须满足严格小于 $\textit{arr}[i]$。当然这就变成求最小的下标 $j \le i$，且连续子序列中的元素 $\textit{arr}[j], \textit{arr}[j+1], \cdots, \textit{arr}[i]$ 都满足大于等于 $\textit{arr}[i]$，以及最大的下标 $k > i$ 满足连续子序列 $\textit{arr}[i + 1], \textit{arr}[i+1], \cdots, \textit{arr}[k]$ 都满足严格大于 $\textit{arr}[i]$。上述即转化为经典的单调栈问题，即求数组中当前元素 $x$ 左边第一个小于 $x$ 的元素以及右边第一个小于等于 $x$ 的元素，关于「[单调栈](https://oi-wiki.org/ds/monotonous-stack/)」的算法细节，可以参考「[496. 下一个更大元素 I 题解](https://leetcode.cn/problems/next-greater-element-i/solutions/1065517/xia-yi-ge-geng-da-yuan-su-i-by-leetcode-bfcoj/)」。

对于数组中每个元素 $\textit{arr}[i]$，具体做法如下：

+ 求左边第一个小于 $\textit{arr}[i]$ 的元素：从左向右遍历数组，并维护一个单调递增的栈，遍历当前元素 $\textit{arr}[i]$，如果遇到当前栈顶的元素大于等于 $\textit{arr}[i]$ 则将其弹出，直到栈顶的元素小于 $\textit{arr}[i]$，栈顶的元素即为左边第一个小于 $\textit{arr}[i]$ 的元素 $\textit{arr}[j]$，此时 $\textit{left}[i] = i - j$。

+ 求右边第一个大于等于 $\textit{arr}[i]$ 的元素：从右向左遍历数组，维护一个单调递增的栈，遍历当前元素 $\textit{arr}[i]$，如果遇到当前栈顶的元素大于 $\textit{arr}[i]$ 则将其弹出，直到栈顶的元素小于等于 $\textit{arr}[i]$，栈顶的元素即为右边第一个小于等于 $\textit{arr}[i]$ 的元素 $\textit{arr}[k]$，此时 $\textit{right}[i] = k - i$。

+ 连续子数组 $\textit{arr}[j], \textit{arr}[j + 1], \cdots, \textit{arr}[k]$ 的最小元素即为 $\textit{arr}[i]$，以 $\textit{arr}[i]$ 为最小元素的连续子序列的数量为 $(i - j) \times (k - i)$。

根据以上结论可以知道，所有子数组的最小值之和即为 $\sum_{i=0}^{n - 1} \limits \textit{arr}[i] \times \textit{left}[i] \times \textit{right}[i]$。维护单调栈的过程线性的，因为只进行了线性次的入栈和出栈。

```Python [sol1-Python3]
MOD = 10 ** 9 + 7

class Solution:
    def sumSubarrayMins(self, arr: List[int]) -> int:
        n = len(arr)
        monoStack = []
        left = [0] * n
        right = [0] * n
        for i, x in enumerate(arr):
            while monoStack and x <= arr[monoStack[-1]]:
                monoStack.pop()
            left[i] = i - (monoStack[-1] if monoStack else -1)
            monoStack.append(i)
        monoStack = []
        for i in range(n - 1, -1, -1):
            while monoStack and arr[i] < arr[monoStack[-1]]:
                monoStack.pop()
            right[i] = (monoStack[-1] if monoStack else n) - i
            monoStack.append(i)
        ans = 0
        for l, r, x in zip(left, right, arr):
            ans = (ans + l * r * x) % MOD
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int sumSubarrayMins(vector<int>& arr) {
        int n = arr.size();
        vector<int> monoStack;
        vector<int> left(n), right(n);
        for (int i = 0; i < n; i++) {
            while (!monoStack.empty() && arr[i] <= arr[monoStack.back()]) {
                monoStack.pop_back();
            }
            left[i] = i - (monoStack.empty() ? -1 : monoStack.back());
            monoStack.emplace_back(i);
        }
        monoStack.clear();
        for (int i = n - 1; i >= 0; i--) {
            while (!monoStack.empty() && arr[i] < arr[monoStack.back()]) {
                monoStack.pop_back();
            }
            right[i] = (monoStack.empty() ? n : monoStack.back()) - i;
            monoStack.emplace_back(i);
        }
        long long ans = 0;
        long long mod = 1e9 + 7;
        for (int i = 0; i < n; i++) {
            ans = (ans + (long long)left[i] * right[i] * arr[i]) % mod; 
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumSubarrayMins(int[] arr) {
        int n = arr.length;
        Deque<Integer> monoStack = new ArrayDeque<Integer>();
        int[] left = new int[n];
        int[] right = new int[n];
        for (int i = 0; i < n; i++) {
            while (!monoStack.isEmpty() && arr[i] <= arr[monoStack.peek()]) {
                monoStack.pop();
            }
            left[i] = i - (monoStack.isEmpty() ? -1 : monoStack.peek());
            monoStack.push(i);
        }
        monoStack.clear();
        for (int i = n - 1; i >= 0; i--) {
            while (!monoStack.isEmpty() && arr[i] < arr[monoStack.peek()]) {
                monoStack.pop();
            }
            right[i] = (monoStack.isEmpty() ? n : monoStack.peek()) - i;
            monoStack.push(i);
        }
        long ans = 0;
        final int MOD = 1000000007;
        for (int i = 0; i < n; i++) {
            ans = (ans + (long) left[i] * right[i] * arr[i]) % MOD; 
        }
        return (int) ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SumSubarrayMins(int[] arr) {
        int n = arr.Length;
        Stack<int> monoStack = new Stack<int>();
        int[] left = new int[n];
        int[] right = new int[n];
        for (int i = 0; i < n; i++) {
            while (monoStack.Count > 0 && arr[i] <= arr[monoStack.Peek()]) {
                monoStack.Pop();
            }
            left[i] = i - (monoStack.Count == 0 ? -1 : monoStack.Peek());
            monoStack.Push(i);
        }
        monoStack.Clear();
        for (int i = n - 1; i >= 0; i--) {
            while (monoStack.Count > 0 && arr[i] < arr[monoStack.Peek()]) {
                monoStack.Pop();
            }
            right[i] = (monoStack.Count == 0 ? n : monoStack.Peek()) - i;
            monoStack.Push(i);
        }
        long ans = 0;
        const int MOD = 1000000007;
        for (int i = 0; i < n; i++) {
            ans = (ans + (long) left[i] * right[i] * arr[i]) % MOD; 
        }
        return (int) ans;
    }
}
```

```C [sol1-C]
int sumSubarrayMins(int* arr, int arrSize) {
    int monoStack[arrSize], left[arrSize], right[arrSize];
    int top = 0;
    for (int i = 0; i < arrSize; i++) {
        while (top != 0 && arr[i] <= arr[monoStack[top - 1]]) {
            top--;
        }
        left[i] = i - (top == 0 ? -1 : monoStack[top - 1]);
        monoStack[top++] = i;
    }
    top = 0;
    for (int i = arrSize - 1; i >= 0; i--) {
        while (top != 0 && arr[i] < arr[monoStack[top - 1]]) {
            top--;
        }
        right[i] = (top == 0 ? arrSize : monoStack[top - 1]) - i;
        monoStack[top++] = i;
    }
    long long ans = 0;
    long long mod = 1e9 + 7;
    for (int i = 0; i < arrSize; i++) {
        ans = (ans + (long long)left[i] * right[i] * arr[i]) % mod; 
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var sumSubarrayMins = function(arr) {
    const n = arr.length;
    let monoStack = [];
    const left = new Array(n).fill(0);
    const right = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        while (monoStack.length !== 0 && arr[i] <= arr[monoStack[monoStack.length - 1]]) {
            monoStack.pop();
        }
        left[i] = i - (monoStack.length === 0 ? -1 : monoStack[monoStack.length - 1]);
        monoStack.push(i);
    }
    monoStack = [];
    for (let i = n - 1; i >= 0; i--) {
        while (monoStack.length !== 0 && arr[i] < arr[monoStack[monoStack.length - 1]]) {
            monoStack.pop();
        }
        right[i] = (monoStack.length === 0 ? n : monoStack[monoStack.length - 1]) - i;
        monoStack.push(i);
    }
    let ans = 0;
    const MOD = 1000000007;
    for (let i = 0; i < n; i++) {
        ans = (ans + left[i] * right[i] * arr[i]) % MOD; 
    }
    return ans;
};
```

```go [sol1-Golang]
func sumSubarrayMins(arr []int) (ans int) {
    const mod int = 1e9 + 7
    n := len(arr)
    left := make([]int, n)
    right := make([]int, n)
    monoStack := []int{}
    for i, x := range arr {
        for len(monoStack) > 0 && x <= arr[monoStack[len(monoStack)-1]] {
            monoStack = monoStack[:len(monoStack)-1]
        }
        if len(monoStack) == 0 {
            left[i] = i + 1
        } else {
            left[i] = i - monoStack[len(monoStack)-1]
        }
        monoStack = append(monoStack, i)
    }
    monoStack = []int{}
    for i := n - 1; i >= 0; i-- {
        for len(monoStack) > 0 && arr[i] < arr[monoStack[len(monoStack)-1]] {
            monoStack = monoStack[:len(monoStack)-1]
        }
        if len(monoStack) == 0 {
            right[i] = n - i
        } else {
            right[i] = monoStack[len(monoStack)-1] - i
        }
        monoStack = append(monoStack, i)
    }
    for i, x := range arr {
        ans = (ans + left[i]*right[i]*x) % mod
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。利用单调栈求出每个元素为最小值的子序列长度需要的时间为 $O(n)$，求出连续子数组的最小值的总和需要的时间为 $O(n)$，因此总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$。其中 $n$ 为数组的长度。我们需要保存以每个元素为最小元素的子序列长度，所需的空间为 $O(n)$。

#### 方法二：动态规划

设 $s[j][i]$ 表示子数组 $[\textit{arr}[j], \textit{arr}[j+1], \cdots,\textit{arr}[i]]$ 的最小值，则可以推出所有连续子数组的最小值之和为 $\sum_{i=0}^{n-1} \limits \sum_{j=0}^{i} \limits s[j][i]$。对于每个以 $i$ 为最右的子数组最小值之和为 $\sum_{j=0}^{i} \limits s[j][i]$。我们只需要求出以每个元素 $\textit{arr}[i]$ 为最右的子数组最小值之和，即可求出所有的子数组的最小值之和。每当我们减少 $j$ 时，子序列的最小值可能会有关联，事实上我们可以观察到 $s[j-1][i] =  \min(s[j][i], \textit{arr}[j-1])$。
假设当前数组为: $\textit{arr} = [1,7,5,2,4,3,9]$，当 $i = 5$ 时，所有以索引 $j$ 为起点且以 $i$ 结尾的连续子序列为:
$$
\begin{aligned}
& j = 5, \quad [3] \\
& j = 4, \quad [4,3] \\
& j = 3, \quad [2,4,3] \\
& j = 2, \quad [5,2,4,3] \\
& j = 1, \quad [7,5,2,4,3] \\
& j = 0, \quad [1,7,5,2,4,3] \\
\end{aligned}
$$
上述序列的最小值分别为 $[3, 3, 2, 2, 2, 1]$，可以发现重要点是 $j = 5, j = 3, j = 0$，分别是 $j$ 从 $i$ 开始向左移动遇到的最小值的位置。如下图所示:
![1](https://assets.leetcode-cn.com/solution-static/907/907_1.png)

设以 $\textit{arr}[i]$ 为最右且最小的最长子序列长度为 $k$：

+ 当 $j >= i-k+1$ 时：连续子序列 $[\textit{arr}[j]，\textit{arr}[j+1], \cdots，\textit{arr}[i]]$ 的最小值为 $\textit{arr}[i]$，即 $s[j][i] = \textit{arr}[i]$。

+ 当 $j < i-k + 1$ 时：连续子序列 $[\textit{arr}[j]，\textit{arr}[j+1], \cdots，\textit{arr}[i]]$ 的最小值一定比 $\textit{arr}[i]$ 更小，通过分析可以知道它的最小值 $s[j][i] = \min(s[j][i-k], \textit{arr}[i]) = s[j][i-k]$。

则可以知道递推公式如下：
$$
\begin{aligned}
\sum_{j=0}^{i} \limits s[j][i] 
& = \sum_{j=0}^{i - k} \limits s[j][i] + \sum_{j=i-k+1}^{i} \limits s[j][i] \\
& = \sum_{j=0}^{i - k} \limits s[j][i] + k \times \textit{arr}[i] \\
& = \sum_{j=0}^{i - k} \limits s[j][i-k] + k \times \textit{arr}[i] 
\end{aligned}
$$
我们令 $\textit{dp}[i] = \sum_{j=0}^{i} \limits s[j][i]$，则上述等式转换为：
$$
\textit{dp}[i] = \textit{dp}[i-k] + k \times \textit{arr}[i]
$$
我们维护一个单调栈，很容易求出元素 $x$ 的左边第一个比它小的元素，即求出以 $x$ 为最右且最小的子序列的最大长度，子数组的最小值之和即为 $\sum_{i=0}^{n-1} \limits \textit{dp}[i]$。

具体解法过程如下：

+ 从左向右遍历数组并维护一个单调递增的栈，如果栈顶的元素大于等于当前元素 $\textit{arr}[i]$ 则弹出栈，此时栈顶的元素即为左边第一个小于小于当前值的元素；

+ 我们求出以当前值为最右且最小的子序列的长度 $k$，根据上述递推公式求出 $\textit{dp}[i]$，最终的返回值即为 $\sum_{i=0}^{n-1} \limits \textit{dp}[i]$。

```Python [sol2-Python3]
MOD = 10 ** 9 + 7

class Solution:
    def sumSubarrayMins(self, arr: List[int]) -> int:
        n = len(arr)
        monoStack = []
        dp = [0] * n
        ans = 0
        for i, x in enumerate(arr):
            while monoStack and arr[monoStack[-1]] > x:
                monoStack.pop()
            k = i - monoStack[-1] if monoStack else i + 1
            dp[i] = k * x + (dp[i - k] if monoStack else 0)
            ans = (ans + dp[i]) % MOD
            monoStack.append(i)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int sumSubarrayMins(vector<int>& arr) {
        int n = arr.size();
        long long ans = 0;
        long long mod = 1e9 + 7;
        stack<int> monoStack;
        vector<int> dp(n);
        for (int i = 0; i < n; i++) {
            while (!monoStack.empty() && arr[monoStack.top()] > arr[i]) {
                monoStack.pop();
            }
            int k = monoStack.empty() ? (i + 1) : (i - monoStack.top());
            dp[i] = k * arr[i] + (monoStack.empty() ? 0 : dp[i - k]);
            ans = (ans + dp[i]) % mod;
            monoStack.emplace(i);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int sumSubarrayMins(int[] arr) {
        int n = arr.length;
        long ans = 0;
        final int MOD = 1000000007;
        Deque<Integer> monoStack = new ArrayDeque<Integer>();
        int[] dp = new int[n];
        for (int i = 0; i < n; i++) {
            while (!monoStack.isEmpty() && arr[monoStack.peek()] > arr[i]) {
                monoStack.pop();
            }
            int k = monoStack.isEmpty() ? (i + 1) : (i - monoStack.peek());
            dp[i] = k * arr[i] + (monoStack.isEmpty() ? 0 : dp[i - k]);
            ans = (ans + dp[i]) % MOD;
            monoStack.push(i);
        }
        return (int) ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int SumSubarrayMins(int[] arr) {
        int n = arr.Length;
        long ans = 0;
        const int MOD = 1000000007;
        Stack<int> monoStack = new Stack<int>();
        int[] dp = new int[n];
        for (int i = 0; i < n; i++) {
            while (monoStack.Count > 0 && arr[monoStack.Peek()] > arr[i]) {
                monoStack.Pop();
            }
            int k = monoStack.Count == 0 ? (i + 1) : (i - monoStack.Peek());
            dp[i] = k * arr[i] + (monoStack.Count == 0 ? 0 : dp[i - k]);
            ans = (ans + dp[i]) % MOD;
            monoStack.Push(i);
        }
        return (int) ans;
    }
}
```

```C [sol2-C]
int sumSubarrayMins(int* arr, int arrSize) {
    long long ans = 0;
    long long mod = 1e9 + 7;
    int monoStack[arrSize], dp[arrSize];
    int top = 0;
    for (int i = 0; i < arrSize; i++) {
        while (top > 0 && arr[monoStack[top - 1]] > arr[i]) {
            top--;
        }
        int k = top == 0 ? (i + 1) : (i - monoStack[top - 1]);
        dp[i] = k * arr[i] + (top == 0 ? 0 : dp[i - k]);
        ans = (ans + dp[i]) % mod;
        monoStack[top++] = i;
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var sumSubarrayMins = function(arr) {
    const n = arr.length;
    let ans = 0;
    const MOD = 1000000007;
    const monoStack = [];
    const dp = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        while (monoStack.length !== 0 && arr[monoStack[monoStack.length - 1]] > arr[i]) {
            monoStack.pop();
        }
        const k = monoStack.length === 0 ? (i + 1) : (i - monoStack[monoStack.length - 1]);
        dp[i] = k * arr[i] + (monoStack.length === 0 ? 0 : dp[i - k]);
        ans = (ans + dp[i]) % MOD;
        monoStack.push(i);
    }
    return ans;
};
```

```go [sol2-Golang]
func sumSubarrayMins(arr []int) (ans int) {
    const mod int = 1e9 + 7
    n := len(arr)
    monoStack := []int{}
    dp := make([]int, n)
    for i, x := range arr {
        for len(monoStack) > 0 && arr[monoStack[len(monoStack)-1]] > x {
            monoStack = monoStack[:len(monoStack)-1]
        }
        k := i + 1
        if len(monoStack) > 0 {
            k = i - monoStack[len(monoStack)-1]
        }
        dp[i] = k * x
        if len(monoStack) > 0 {
            dp[i] += dp[i-k]
        }
        ans = (ans + dp[i]) % mod
        monoStack = append(monoStack, i)
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。利用单调栈求出每个元素为最小值的子序列长度需要的时间为 $O(n)$。

- 空间复杂度：$O(n)$。其中 $n$ 为数组的长度。需要存储每个元素为结尾的子序列最小值之和，所需的空间为 $O(n)$。