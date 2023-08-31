## [2055.蜡烛之间的盘子 中文官方题解](https://leetcode.cn/problems/plates-between-candles/solutions/100000/zha-zhu-zhi-jian-de-pan-zi-by-leetcode-s-ejst)

#### 方法一：预处理 + 前缀和

**思路和算法**

对于每一个询问，我们只需要找到给定区间内最左侧和最右侧的两个蜡烛，这样两个蜡烛之间的所有盘子都是符合条件的。

对于**寻找蜡烛**，我们可以预处理区间内每个位置左侧的第一个蜡烛和右侧的第一个蜡烛。这样区间左端点 $\textit{left}_i$ 右侧的第一个蜡烛即为区间最左侧的蜡烛，区间右端点 $\textit{right}_i$ 左侧的第一个蜡烛即为区间最右侧的蜡烛。

对于**计算盘子数量**，我们可以计算盘子数量的前缀和 $\textit{preSum}$。假设找到的两蜡烛的位置分别为 $x$ 和 $y$，那么两位置之间的盘子数量即为 $\textit{preSum}_y - \textit{preSum}_{x - 1}$。

这样我们就通过预处理，将寻找蜡烛和计算盘子数量两个操作的时间复杂度降至 $O(1)$，因此对于每个询问，时间复杂度为 $O(1)$。

在实际代码中，可能某个位置的左侧或右侧是不存在蜡烛的，此时我们将对应数组的值记为 $-1$。当 $x$ 为 $-1$ 或者 $y$ 为 $-1$ 或者 $x \geq y$ 时，不存在满足条件的盘子。同时注意到因为 $x$ 位置是蜡烛，所以盘子数量也可以表示为 $\textit{preSum}_y - \textit{preSum}_{x}$，这个写法可以防止 $x$ 为 $0$ 时数组越界。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> platesBetweenCandles(string s, vector<vector<int>>& queries) {
        int n = s.length();
        vector<int> preSum(n);
        for (int i = 0, sum = 0; i < n; i++) {
            if (s[i] == '*') {
                sum++;
            }
            preSum[i] = sum;
        }
        vector<int> left(n);
        for (int i = 0, l = -1; i < n; i++) {
            if (s[i] == '|') {
                l = i;
            }
            left[i] = l;
        }
        vector<int> right(n);
        for (int i = n - 1, r = -1; i >= 0; i--) {
            if (s[i] == '|') {
                r = i;
            }
            right[i] = r;
        }
        vector<int> ans;
        for (auto& query : queries) {
            int x = right[query[0]], y = left[query[1]];
            ans.push_back(x == -1 || y == -1 || x >= y ? 0 : preSum[y] - preSum[x]);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] platesBetweenCandles(String s, int[][] queries) {
        int n = s.length();
        int[] preSum = new int[n];
        for (int i = 0, sum = 0; i < n; i++) {
            if (s.charAt(i) == '*') {
                sum++;
            }
            preSum[i] = sum;
        }
        int[] left = new int[n];
        for (int i = 0, l = -1; i < n; i++) {
            if (s.charAt(i) == '|') {
                l = i;
            }
            left[i] = l;
        }
        int[] right = new int[n];
        for (int i = n - 1, r = -1; i >= 0; i--) {
            if (s.charAt(i) == '|') {
                r = i;
            }
            right[i] = r;
        }
        int[] ans = new int[queries.length];
        for (int i = 0; i < queries.length; i++) {
            int[] query = queries[i];
            int x = right[query[0]], y = left[query[1]];
            ans[i] = x == -1 || y == -1 || x >= y ? 0 : preSum[y] - preSum[x];
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] PlatesBetweenCandles(string s, int[][] queries) {
        int n = s.Length;
        int[] preSum = new int[n];
        for (int i = 0, sum = 0; i < n; i++) {
            if (s[i] == '*') {
                sum++;
            }
            preSum[i] = sum;
        }
        int[] left = new int[n];
        for (int i = 0, l = -1; i < n; i++) {
            if (s[i] == '|') {
                l = i;
            }
            left[i] = l;
        }
        int[] right = new int[n];
        for (int i = n - 1, r = -1; i >= 0; i--) {
            if (s[i] == '|') {
                r = i;
            }
            right[i] = r;
        }
        int[] ans = new int[queries.Length];
        for (int i = 0; i < queries.Length; i++) {
            int[] query = queries[i];
            int x = right[query[0]], y = left[query[1]];
            ans[i] = x == -1 || y == -1 || x >= y ? 0 : preSum[y] - preSum[x];
        }
        return ans;
    }
}
```

```C [sol1-C]
int* platesBetweenCandles(char * s, int** queries, int queriesSize, int* queriesColSize, int* returnSize){
    int n = strlen(s);
    int * preSum = (int *)malloc(sizeof(int) * n);
    memset(preSum, 0, sizeof(int) * n);
    for (int i = 0, sum = 0; i < n; i++) {
        if (s[i] == '*') {
            sum++;
        }
        preSum[i] = sum;
    }
    int * left = (int *)malloc(sizeof(int) * n);
    memset(left, 0, sizeof(int) * n);
    for (int i = 0, l = -1; i < n; i++) {
        if (s[i] == '|') {
            l = i;
        }
        left[i] = l;
    }
    int * right = (int *)malloc(sizeof(int) * n);
    memset(right, 0, sizeof(int) * n);
    for (int i = n - 1, r = -1; i >= 0; i--) {
        if (s[i] == '|') {
            r = i;
        }
        right[i] = r;
    }
    int * ans = (int *)malloc(sizeof(int) * queriesSize);
    for (int i = 0; i < queriesSize; i++) {
        int x = right[queries[i][0]], y = left[queries[i][1]];
        ans[i] = x == -1 || y == -1 || x >= y ? 0 : preSum[y] - preSum[x];
    }
    free(preSum);
    free(left);
    free(right);
    *returnSize = queriesSize; 
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def platesBetweenCandles(self, s: str, queries: List[List[int]]) -> List[int]:
        n = len(s)
        preSum, sum = [0] * n, 0
        left, l = [0] * n, -1
        for i, ch in enumerate(s):
            if ch == '*':
                sum += 1
            else:
                l = i
            preSum[i] = sum
            left[i] = l

        right, r = [0] * n, -1
        for i in range(n - 1, -1, -1):
            if s[i] == '|':
                r = i
            right[i] = r

        ans = [0] * len(queries)
        for i, (x, y) in enumerate(queries):
            x, y = right[x], left[y]
            if x >= 0 and y >= 0 and x < y:
                ans[i] = preSum[y] - preSum[x]
        return ans
```

```go [sol1-Golang]
func platesBetweenCandles(s string, queries [][]int) []int {
    n := len(s)
    preSum := make([]int, n)
    left := make([]int, n)
    sum, l := 0, -1
    for i, ch := range s {
        if ch == '*' {
            sum++
        } else {
            l = i
        }
        preSum[i] = sum
        left[i] = l
    }

    right := make([]int, n)
    for i, r := n-1, -1; i >= 0; i-- {
        if s[i] == '|' {
            r = i
        }
        right[i] = r
    }

    ans := make([]int, len(queries))
    for i, q := range queries {
        x, y := right[q[0]], left[q[1]]
        if x >= 0 && y >= 0 && x < y {
            ans[i] = preSum[y] - preSum[x]
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var platesBetweenCandles = function(s, queries) {
    const n = s.length;
    const preSum = new Array(n).fill(0);
    for (let i = 0, sum = 0; i < n; i++) {
        if (s[i] === '*') {
            sum++;
        }
        preSum[i] = sum;
    }
    const left = new Array(n).fill(0);;
    for (let i = 0, l = -1; i < n; i++) {
        if (s[i] === '|') {
            l = i;
        }
        left[i] = l;
    }
    const right = new Array(n).fill(0);;
    for (let i = n - 1, r = -1; i >= 0; i--) {
        if (s[i] === '|') {
            r = i;
        }
        right[i] = r;
    }
    const ans = new Array(queries.length).fill(0);
    for (let i = 0; i < queries.length; i++) {
        const query = queries[i];
        const x = right[query[0]], y = left[query[1]];
        ans[i] = x === -1 || y === -1 || x >= y ? 0 : preSum[y] - preSum[x];
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + q)$，其中 $n$ 为数组长度，$q$ 为询问数量。我们需要 $O(n)$ 的时间预处理。对于每一个询问，我们需要 $O(1)$ 的时间计算答案。

- 空间复杂度：$O(n)$，其中 $n$ 为数组长度。我们需要 $O(n)$ 的空间保存预处理的结果。注意返回值不计入空间复杂度。