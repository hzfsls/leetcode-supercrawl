## [978.最长湍流子数组 中文官方题解](https://leetcode.cn/problems/longest-turbulent-subarray/solutions/100000/zui-chang-tuan-liu-zi-shu-zu-by-leetcode-t4d8)
#### 方法一：滑动窗口

设数组 $\textit{arr}$ 的长度为 $n$，窗口 $[\textit{left},\textit{right}](0 \le \textit{left} \le \textit{right} \le n-1)$ 为当前的窗口，窗口内构成了一个「湍流子数组」。随后，我们要考虑下一个窗口的位置。

根据「湍流子数组」的定义，当 $0<\textit{right}<n-1$ 时：

- 如果 $\textit{arr}[\textit{right}-1] < \textit{arr}[\textit{right}]$ 且 $\textit{arr}[\textit{right}] > \textit{arr}[\textit{right}+1]$，则 $[\textit{left},\textit{right}+1]$ 也构成「湍流子数组」，因此需要将 $\textit{right}$ 右移一个单位；

- 如果 $\textit{arr}[\textit{right}-1] > \textit{arr}[\textit{right}]$ 且 $\textit{arr}[\textit{right}] < \textit{arr}[\textit{right}+1]$，同理，也需要将 $\textit{right}$ 右移一个单位；

- 否则，$[\textit{right}-1,\textit{right}+1]$ 无法构成「湍流子数组」，当 $\textit{left}<\textit{right}$ 时，$[\textit{left},\textit{right}+1]$ 也无法构成「湍流子数组」，因此需要将 $\textit{left}$ 移到 $\textit{right}$，即令 $\textit{left}=\textit{right}$。

此外，我们还需要特殊考虑窗口长度为 $1$ (即 $\textit{left}$ 和 $\textit{right}$ 相等的情况)：只要 $\textit{arr}[\textit{right}] \ne \textit{arr}[\textit{right}+1]$，就可以将 $\textit{right}$ 右移一个单位；否则，$\textit{left}$ 和 $\textit{right}$ 都要同时右移。

```C++ [sol1-C++]
class Solution {
public:
    int maxTurbulenceSize(vector<int>& arr) {
        int n = arr.size();
        int ret = 1;
        int left = 0, right = 0;

        while (right < n - 1) {
            if (left == right) {
                if (arr[left] == arr[left + 1]) {
                    left++;
                }
                right++;
            } else {
                if (arr[right - 1] < arr[right] && arr[right] > arr[right + 1]) {
                    right++;
                } else if (arr[right - 1] > arr[right] && arr[right] < arr[right + 1]) {
                    right++;
                } else {
                    left = right;
                }
            }
            ret = max(ret, right - left + 1);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxTurbulenceSize(int[] arr) {
        int n = arr.length;
        int ret = 1;
        int left = 0, right = 0;

        while (right < n - 1) {
            if (left == right) {
                if (arr[left] == arr[left + 1]) {
                    left++;
                }
                right++;
            } else {
                if (arr[right - 1] < arr[right] && arr[right] > arr[right + 1]) {
                    right++;
                } else if (arr[right - 1] > arr[right] && arr[right] < arr[right + 1]) {
                    right++;
                } else {
                    left = right;
                }
            }
            ret = Math.max(ret, right - left + 1);
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var maxTurbulenceSize = function(arr) {
    const n = arr.length;
    let ret = 1;
    let left = 0, right = 0;

    while (right < n - 1) {
        if (left == right) {
            if (arr[left] == arr[left + 1]) {
                left++;
            }
            right++;
        } else {
            if (arr[right - 1] < arr[right] && arr[right] > arr[right + 1]) {
                right++;
            } else if (arr[right - 1] > arr[right] && arr[right] < arr[right + 1]) {
                right++;
            } else {
                left = right;
            }
        }
        ret = Math.max(ret, right - left + 1);
    }
    return ret;
};
```

```go [sol1-Golang]
func maxTurbulenceSize(arr []int) int {
    n := len(arr)
    ans := 1
    left, right := 0, 0
    for right < n-1 {
        if left == right {
            if arr[left] == arr[left+1] {
                left++
            }
            right++
        } else {
            if arr[right-1] < arr[right] && arr[right] > arr[right+1] {
                right++
            } else if arr[right-1] > arr[right] && arr[right] < arr[right+1] {
                right++
            } else {
                left = right
            }
        }
        ans = max(ans, right-left+1)
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int maxTurbulenceSize(int* arr, int arrSize) {
    int ret = 1;
    int left = 0, right = 0;

    while (right < arrSize - 1) {
        if (left == right) {
            if (arr[left] == arr[left + 1]) {
                left++;
            }
            right++;
        } else {
            if (arr[right - 1] < arr[right] && arr[right] > arr[right + 1]) {
                right++;
            } else if (arr[right - 1] > arr[right] && arr[right] < arr[right + 1]) {
                right++;
            } else {
                left = right;
            }
        }
        ret = fmax(ret, right - left + 1);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。窗口的左右端点最多各移动 $n$ 次。

- 空间复杂度：$O(1)$。只需要维护常数额外空间。

#### 方法二：动态规划

也可以使用动态规划的方法计算最长湍流子数组的长度。

记 $\textit{dp}[i][0]$ 为以 $\textit{arr}[i]$ 结尾，且 $\textit{arr}[i-1] > \textit{arr}[i]$ 的「湍流子数组」的最大长度；$\textit{dp}[i][1]$ 为以 $\textit{arr}[i]$ 结尾，且 $\textit{arr}[i-1] < \textit{arr}[i]$ 的「湍流子数组」的最大长度。

显然，以下标 $0$ 结尾的「湍流子数组」的最大长度为 $1$，因此边界情况为 $\textit{dp}[0][0]=\textit{dp}[0][1]=1$。

当 $i>0$ 时，考虑 $\textit{arr}[i-1]$ 和 $\textit{arr}[i]$ 之间的大小关系：

- 如果 $\textit{arr}[i-1]>\textit{arr}[i]$，则如果以下标 $i-1$ 结尾的子数组是「湍流子数组」，应满足 $i-1=0$，或者当 $i-1>0$ 时 $\textit{arr}[i-2] < \textit{arr}[i-1]$，因此 $\textit{dp}[i][0]=\textit{dp}[i-1][1]+1$，$\textit{dp}[i][1]=1$；

- 如果 $\textit{arr}[i-1]<\textit{arr}[i]$，则如果以下标 $i-1$ 结尾的子数组是「湍流子数组」，应满足 $i-1=0$，或者当 $i-1>0$ 时 $\textit{arr}[i-2] > \textit{arr}[i-1]$，因此 $\textit{dp}[i][0]=1$，$\textit{dp}[i][1]=\textit{dp}[i-1][0]+1$；

- 如果 $\textit{arr}[i-1]=\textit{arr}[i]$，则 $\textit{arr}[i-1]$ 和 $\textit{arr}[i]$ 不能同时出现在同一个湍流子数组中，因此 $\textit{dp}[i][0]=\textit{dp}[i][1]=1$。

最终，$\textit{dp}$ 数组的最大值即为所求的答案。

```C++ [sol21-C++]
class Solution {
public:
    int maxTurbulenceSize(vector<int>& arr) {
        int n = arr.size();
        vector<vector<int>> dp(n, vector<int>(2, 1));
        dp[0][0] = dp[0][1] = 1;
        for (int i = 1; i < n; i++) {
            if (arr[i - 1] > arr[i]) {
                dp[i][0] = dp[i - 1][1] + 1;
            } else if (arr[i - 1] < arr[i]) {
                dp[i][1] = dp[i - 1][0] + 1;
            }
        }

        int ret = 1;
        for (int i = 0; i < n; i++) {
            ret = max(ret, dp[i][0]);
            ret = max(ret, dp[i][1]);
        }
        return ret;
    }
};
```

```Java [sol21-Java]
class Solution {
    public int maxTurbulenceSize(int[] arr) {
        int n = arr.length;
        int[][] dp = new int[n][2];
        dp[0][0] = dp[0][1] = 1;
        for (int i = 1; i < n; i++) {
            dp[i][0] = dp[i][1] = 1;
            if (arr[i - 1] > arr[i]) {
                dp[i][0] = dp[i - 1][1] + 1;
            } else if (arr[i - 1] < arr[i]) {
                dp[i][1] = dp[i - 1][0] + 1;
            }
        }

        int ret = 1;
        for (int i = 0; i < n; i++) {
            ret = Math.max(ret, dp[i][0]);
            ret = Math.max(ret, dp[i][1]);
        }
        return ret;
    }
}
```

```JavaScript [sol21-JavaScript]
var maxTurbulenceSize = function(arr) {
    const n = arr.length;
    const dp = new Array(n).fill(0).map(() => new Array(2).fill(0));
    dp[0][0] = dp[0][1] = 1;
    for (let i = 1; i < n; i++) {
        dp[i][0] = dp[i][1] = 1;
        if (arr[i - 1] > arr[i]) {
            dp[i][0] = dp[i - 1][1] + 1;
        } else if (arr[i - 1] < arr[i]) {
            dp[i][1] = dp[i - 1][0] + 1;
        }
    }

    let ret = 1;
    for (let i = 0; i < n; i++) {
        ret = Math.max(ret, dp[i][0]);
        ret = Math.max(ret, dp[i][1]);
    }
    return ret;
};
```

```go [sol21-Golang]
func maxTurbulenceSize(arr []int) int {
    n := len(arr)
    dp := make([][2]int, n)
    dp[0] = [2]int{1, 1}
    for i := 1; i < n; i++ {
        dp[i] = [2]int{1, 1}
        if arr[i-1] > arr[i] {
            dp[i][0] = dp[i-1][1] + 1
        } else if arr[i-1] < arr[i] {
            dp[i][1] = dp[i-1][0] + 1
        }
    }

    ans := 1
    for i := 0; i < n; i++ {
        ans = max(ans, dp[i][0])
        ans = max(ans, dp[i][1])
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol21-C]
int maxTurbulenceSize(int* arr, int arrSize) {
    int dp[arrSize][2];
    for (int i = 0; i < arrSize; i++) {
        dp[i][0] = dp[i][1] = 1;
    }
    dp[0][0] = dp[0][1] = 1;
    for (int i = 1; i < arrSize; i++) {
        if (arr[i - 1] > arr[i]) {
            dp[i][0] = dp[i - 1][1] + 1;
        } else if (arr[i - 1] < arr[i]) {
            dp[i][1] = dp[i - 1][0] + 1;
        }
    }

    int ret = 1;
    for (int i = 0; i < arrSize; i++) {
        ret = fmax(ret, dp[i][0]);
        ret = fmax(ret, dp[i][1]);
    }
    return ret;
}
```

上述实现的空间复杂度是 $O(n)$。注意到当 $i>0$ 时，下标 $i$ 处的 $\textit{dp}$ 值只和下标 $i-1$ 处的 $\textit{dp}$ 值有关，因此可以用两个变量 $\textit{dp}_0$ 和 $\textit{dp}_1$ 代替 $\textit{dp}[i][0]$ 和 $\textit{dp}[i][1]$，将空间复杂度降到 $O(1)$。

```C++ [sol22-C++]
class Solution {
public:
    int maxTurbulenceSize(vector<int>& arr) {
        int ret = 1;
        int n = arr.size();
        int dp0 = 1, dp1 = 1;
        for (int i = 1; i < n; i++) {
            if (arr[i - 1] > arr[i]) {
                dp0 = dp1 + 1;
                dp1 = 1;
            } else if (arr[i - 1] < arr[i]) {
                dp1 = dp0 + 1;
                dp0 = 1;
            } else {
                dp0 = 1;
                dp1 = 1;
            }
            ret = max(ret, dp0);
            ret = max(ret, dp1);
        }
        return ret;
    }
};
```

```Java [sol22-Java]
class Solution {
    public int maxTurbulenceSize(int[] arr) {
        int ret = 1;
        int n = arr.length;
        int dp0 = 1, dp1 = 1;
        for (int i = 1; i < n; i++) {
            if (arr[i - 1] > arr[i]) {
                dp0 = dp1 + 1;
                dp1 = 1;
            } else if (arr[i - 1] < arr[i]) {
                dp1 = dp0 + 1;
                dp0 = 1;
            } else {
                dp0 = 1;
                dp1 = 1;
            }
            ret = Math.max(ret, dp0);
            ret = Math.max(ret, dp1);
        }
        return ret;
    }
}
```

```JavaScript [sol22-JavaScript]
var maxTurbulenceSize = function(arr) {
    let ret = 1;
    const n = arr.length;
    let dp0 = 1, dp1 = 1;
    for (let i = 1; i < n; i++) {
        if (arr[i - 1] > arr[i]) {
            dp0 = dp1 + 1;
            dp1 = 1;
        } else if (arr[i - 1] < arr[i]) {
            dp1 = dp0 + 1;
            dp0 = 1;
        } else {
            dp0 = 1;
            dp1 = 1;
        }
        ret = Math.max(ret, dp0);
        ret = Math.max(ret, dp1);
    }
    return ret;
};
```

```go [sol22-Golang]
func maxTurbulenceSize(arr []int) int {
    ans := 1
    n := len(arr)
    dp0, dp1 := 1, 1
    for i := 1; i < n; i++ {
        if arr[i-1] > arr[i] {
            dp0, dp1 = dp1+1, 1
        } else if arr[i-1] < arr[i] {
            dp0, dp1 = 1, dp0+1
        } else {
            dp0, dp1 = 1, 1
        }
        ans = max(ans, max(dp0, dp1))
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol22-C]
int maxTurbulenceSize(int* arr, int arrSize) {
    int ret = 1;
    int dp0 = 1, dp1 = 1;
    for (int i = 1; i < arrSize; i++) {
        if (arr[i - 1] > arr[i]) {
            dp0 = dp1 + 1;
            dp1 = 1;
        } else if (arr[i - 1] < arr[i]) {
            dp1 = dp0 + 1;
            dp0 = 1;
        } else {
            dp0 = 1;
            dp1 = 1;
        }
        ret = fmax(ret, dp0);
        ret = fmax(ret, dp1);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。需要遍历数组 $\textit{arr}$ 一次，计算 $\textit{dp}$ 的值。

- 空间复杂度：$O(1)$。使用空间优化的做法，只需要维护常数额外空间。