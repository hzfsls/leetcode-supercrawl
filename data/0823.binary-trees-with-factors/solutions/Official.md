## [823.带因子的二叉树 中文官方题解](https://leetcode.cn/problems/binary-trees-with-factors/solutions/100000/dai-yin-zi-de-er-cha-shu-by-leetcode-sol-0082)
#### 方法一：动态规划 + 双指针

因为每个整数 $\textit{arr}[i]$ 均大于 $1$，因此每个非叶结点的值都大于它的子结点的值。考虑以 $\textit{arr}[i]$ 为根结点的带因子的二叉树，那么它的所有子孙结点的值都小于 $\textit{arr}[i]$。我们将 $\textit{arr}$ 从小到大进行排序，那么对于以 $\textit{arr}[i]$ 为根结点的带因子的二叉树，它的子孙结点值的下标只能在区间 $[0, i - 1)$ 中。
使用 $\textit{dp}[i]$ 保存以 $\textit{arr}[i]$ 为根结点的带因子的二叉树数目。我们从区间 $[0, i - 1)$ 内枚举 $\textit{arr}[i]$ 的子结点，假设存在 $0 \le \textit{left} \le \textit{right} \lt i$，使 $\textit{arr}[\textit{left}] \times \textit{arr}[\textit{right}] = \textit{arr}[i]$ 成立，那么 $\textit{arr}[\textit{left}]$ 和 $\textit{arr}[\textit{right}]$ 可以作为 $\textit{arr}[i]$ 的两个子结点。同时 $\textit{arr}[\textit{left}]$ 和 $\textit{arr}[\textit{right}]$ 为根结点的带因子二叉树数目分别为 $\textit{dp}[\textit{left}]$ 和 $\textit{dp}[\textit{right}]$，不难推导出 $\textit{arr}[\textit{left}]$ 和 $\textit{arr}[\textit{right}]$ 作为 $\textit{arr}[i]$ 的两个子结点时，带因子二叉树数目 $s$ 为：

+ $\textit{left} = \textit{right}$ 时，$s = \textit{dp}[\textit{left}] \times \textit{dp}[\textit{right}]$

+ $\textit{left} \ne \textit{right}$ 时，因为两个子结点可以交换，所以 $s = \textit{dp}[\textit{left}] \times \textit{dp}[\textit{right}] \times 2$

当 $\textit{arr}[i]$ 没有子结点时，对应 $1$ 个带因子二叉树。因此，状态转移方程为：

$$
    \textit{dp}[i] = 1 + \sum_{(\textit{left}, \textit{right}) \in U} \textit{dp}[\textit{left}] \times \textit{dp}[\textit{right}] \times (1 + f(\textit{left}, \textit{right}))
$$

其中 $(\textit{left}, \textit{right}) \in U$ 表示所有满足 $0 \le \textit{left} \le \textit{right} \lt i$ 且 $\textit{arr}[\textit{left}] \times \textit{arr}[\textit{right}] = \textit{arr}[i]$ 的下标对 $(\textit{left}, \textit{right})$，而 $f(\textit{left}, \textit{right})$ 的取值为当 $\textit{left} = \textit{right}$ 时，值为 $0$，否则值为 $1$（因为 $\textit{left} \ne \textit{right}$ 时，两个子结点可以交换）。

> 找出 $(\textit{left}, \textit{right}) \in U$ 的所有 $(\textit{left}, \textit{right})$ 可以使用双指针进行查找。

```C++ [sol1-C++]
class Solution {
public:
    int numFactoredBinaryTrees(vector<int>& arr) {
        sort(arr.begin(), arr.end());
        int n = arr.size();
        vector<long long> dp(n);
        long long res = 0, mod = 1e9 + 7;
        for (int i = 0; i < n; i++) {
            dp[i] = 1;
            for (int left = 0, right = i - 1; left <= right; left++) {
                while (right >= left && (long long)arr[left] * arr[right] > arr[i]) {
                    right--;
                }
                if (right >= left && (long long)arr[left] * arr[right] == arr[i]) {
                    if (right != left) {
                        dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod;
                    } else {
                        dp[i] = (dp[i] + dp[left] * dp[right]) % mod;
                    }
                }
            }
            res = (res + dp[i]) % mod;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numFactoredBinaryTrees(int[] arr) {
        Arrays.sort(arr);
        int n = arr.length;
        long[] dp = new long[n];
        long res = 0, mod = 1000000007;
        for (int i = 0; i < n; i++) {
            dp[i] = 1;
            for (int left = 0, right = i - 1; left <= right; left++) {
                while (right >= left && (long) arr[left] * arr[right] > arr[i]) {
                    right--;
                }
                if (right >= left && (long) arr[left] * arr[right] == arr[i]) {
                    if (right != left) {
                        dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod;
                    } else {
                        dp[i] = (dp[i] + dp[left] * dp[right]) % mod;
                    }
                }
            }
            res = (res + dp[i]) % mod;
        }
        return (int) res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumFactoredBinaryTrees(int[] arr) {
        Array.Sort(arr);
        int n = arr.Length;
        long[] dp = new long[n];
        long res = 0, mod = 1000000007;
        for (int i = 0; i < n; i++) {
            dp[i] = 1;
            for (int left = 0, right = i - 1; left <= right; left++) {
                while (right >= left && (long) arr[left] * arr[right] > arr[i]) {
                    right--;
                }
                if (right >= left && (long) arr[left] * arr[right] == arr[i]) {
                    if (right != left) {
                        dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod;
                    } else {
                        dp[i] = (dp[i] + dp[left] * dp[right]) % mod;
                    }
                }
            }
            res = (res + dp[i]) % mod;
        }
        return (int) res;
    }
}
```

```Go [sol1-Golang]
func numFactoredBinaryTrees(arr []int) int {
    sort.Ints(arr)
    dp := make([]int64, len(arr))
    res, mod := int64(0), int64(1e9 + 7)
    for i := 0; i < len(arr); i++ {
        dp[i] = 1
        for left, right := 0, i - 1; left <= right; left++ {
            for left <= right && int64(arr[left]) * int64(arr[right]) > int64(arr[i]) {
                right--
            }
            if left <= right && int64(arr[left]) * int64(arr[right]) == int64(arr[i]) {
                if left == right {
                    dp[i] = (dp[i] + dp[left] * dp[right]) % mod
                } else {
                    dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod
                }
            }
        }
        res = (res + dp[i]) % mod
    }
    return int(res)
}
```

```C [sol1-C]
int cmp(const void *p1, const void *p2) {
    return *(int *)p1 - *(int *)p2;
}

int numFactoredBinaryTrees(int *arr, int arrSize){
    qsort(arr, arrSize, sizeof(int), cmp);
    long long *dp = (long long *)malloc(arrSize * sizeof(long long));
    long long res = 0, mod = 1e9 + 7;
    for (int i = 0; i < arrSize; i++) {
        dp[i] = 1;
        for (int left = 0, right = i - 1; left <= right; left++) {
            while (left <= right && (long long)arr[left] * arr[right] > arr[i]) {
                right--;
            }
            if (left <= right && (long long)arr[left] * arr[right] == arr[i]) {
                if (left == right) {
                    dp[i] = (dp[i] + dp[left] * dp[right]) % mod;
                } else {
                    dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod;
                }
            }
        }
        res = (res + dp[i]) % mod;
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def numFactoredBinaryTrees(self, arr: List[int]) -> int:
        n = len(arr)
        arr = sorted(arr)
        dp = [1] * n
        res, mod = 0, 10**9 + 7
        for i in range(n):
            left, right = 0, i - 1
            while left <= right:
                while right >= left and arr[left] * arr[right] > arr[i]:
                    right -= 1
                if right >= left and arr[left] * arr[right] == arr[i]:
                    if right != left:
                        dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod
                    else:
                        dp[i] = (dp[i] + dp[left] * dp[right]) % mod
                left += 1
            res = (res + dp[i]) % mod
        return res
```

```JavaScript [sol1-JavaScript]
var numFactoredBinaryTrees = function(arr) {
    const n = arr.length;
    const mod = 1e9 + 7;
    const dp = new Array(n).fill(1)
    arr.sort((a, b) => a - b);
    let res = 0;
    for (let i = 0; i < n; i++) {
        for (let left = 0, right = i - 1; left <= right; left++) {
            while (right >= left && arr[left] * arr[right] > arr[i]) {
                right--;
            }
            if (right >= left && arr[left] * arr[right] == arr[i]) {
                if (right != left) {
                    dp[i] = (dp[i] + dp[left] * dp[right] * 2) % mod;
                } else {
                    dp[i] = (dp[i] + dp[left] * dp[right]) % mod;
                }
            }
        }
        res = (res + dp[i]) % mod;
    }
    return res;
};
```


**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。双指针找两个子结点需要 $O(n)$，总时间复杂度为 $O(n^2)$。

+ 空间复杂度：$O(n)$。保存动态规划的状态需要 $O(n)$。