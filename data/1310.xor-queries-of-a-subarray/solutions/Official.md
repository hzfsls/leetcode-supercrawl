## [1310.子数组异或查询 中文官方题解](https://leetcode.cn/problems/xor-queries-of-a-subarray/solutions/100000/zi-shu-zu-yi-huo-cha-xun-by-leetcode-solution)
#### 方法一：前缀异或

朴素的想法是，对每个查询，计算数组中的对应下标范围内的元素的异或结果。每个查询的计算时间取决于查询对应的下标范围的长度。如果数组 $\textit{arr}$ 的长度为 $n$，数组 $\textit{queries}$ 的长度为 $m$（即有 $m$ 个查询），则最坏情况下每个查询都需要 $O(n)$ 的时间计算结果，总时间复杂度是 $O(nm)$，会超出时间限制，因此必须优化。

由于有 $m$ 个查询，对于每个查询都要计算结果，因此应该优化每个查询的计算时间。理想情况下，每个查询的计算时间应该为 $O(1)$。为了将每个查询的计算时间从 $O(n)$ 优化到 $O(1)$，需要计算数组的前缀异或。

定义长度为 $n+1$ 的数组 $\textit{xors}$。令 $\textit{xors}[0]=0$，对于 $0 \le i<n$，$\textit{xors}[i+1]=\textit{xors}[i] \oplus \textit{arr}[i]$，其中 $\oplus$ 是异或运算符。当 $1 \le i \le n$ 时，$\textit{xors}[i]$ 为从 $\textit{arr}[0]$ 到 $\textit{arr}[i-1]$ 的元素的异或运算结果：

$$
\textit{xors}[i]=\textit{arr}[0] \oplus \ldots \oplus \textit{arr}[i-1]
$$

对于查询 $[\textit{left},\textit{right}](\textit{left} \le \textit{right})$，用 $Q(\textit{left},\textit{right})$ 表示该查询的结果。

- 当 $\textit{left}=0$ 时，$Q(\textit{left},\textit{right})=\textit{xors}[\textit{right}+1]$。

- 当 $\textit{left}>0$ 时，$Q(\textit{left},\textit{right})$ 的计算如下：

$$
\begin{aligned}
& \quad ~ Q(\textit{left},\textit{right}) \\
&= \textit{arr}[\textit{left}] \oplus \ldots \oplus \textit{arr}[\textit{right}] \\
&= (\textit{arr}[0] \oplus \ldots \oplus \textit{arr}[\textit{left}-1]) \oplus (\textit{arr}[0] \oplus \ldots \oplus \textit{arr}[\textit{left}-1]) \oplus (\textit{arr}[\textit{left}] \oplus \ldots \oplus \textit{arr}[\textit{right}]) \\
&= (\textit{arr}[0] \oplus \ldots \oplus \textit{arr}[\textit{left}-1]) \oplus (\textit{arr}[0] \oplus \ldots \oplus \textit{arr}[\textit{right}]) \\
&= \textit{xors}[\textit{left}] \oplus \textit{xors}[\textit{right}+1]
\end{aligned}
$$

上述计算用到了异或运算的结合律，以及异或运算的性质 $x \oplus x=0$。

当 $\textit{left}=0$ 时，$\textit{xors}[\textit{left}]=0$，因此 $Q(\textit{left},\textit{right})=\textit{xors}[\textit{left}] \oplus \textit{xors}[\textit{right}+1]$ 也成立。

因此对任意 $0 \le \textit{left} \le \textit{right}<n$，都有 $Q(\textit{left},\textit{right})=\textit{xors}[\textit{left}] \oplus \textit{xors}[\textit{right}+1]$，即可在 $O(1)$ 的时间内完成一个查询的计算。

根据上述分析，这道题可以分两步求解。

1. 计算前缀异或数组 $\textit{xors}$；

2. 计算每个查询的结果，第 $i$ 个查询的结果为 $\textit{xors}[\textit{queries}[i][0]] \oplus \textit{xors}[\textit{queries}[i][1]+1]$。

```Java [sol1-Java]
class Solution {
    public int[] xorQueries(int[] arr, int[][] queries) {
        int n = arr.length;
        int[] xors = new int[n + 1];
        for (int i = 0; i < n; i++) {
            xors[i + 1] = xors[i] ^ arr[i];
        }
        int m = queries.length;
        int[] ans = new int[m];
        for (int i = 0; i < m; i++) {
            ans[i] = xors[queries[i][0]] ^ xors[queries[i][1] + 1];
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] XorQueries(int[] arr, int[][] queries) {
        int n = arr.Length;
        int[] xors = new int[n + 1];
        for (int i = 0; i < n; i++) {
            xors[i + 1] = xors[i] ^ arr[i];
        }
        int m = queries.Length;
        int[] ans = new int[m];
        for (int i = 0; i < m; i++) {
            ans[i] = xors[queries[i][0]] ^ xors[queries[i][1] + 1];
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var xorQueries = function(arr, queries) {
    const n = arr.length;
    const xors = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        xors[i + 1] = xors[i] ^ arr[i];
    }
    const m = queries.length;
    const ans = new Array(m).fill(0);
    for (let i = 0; i < m; i++) {
        ans[i] = xors[queries[i][0]] ^ xors[queries[i][1] + 1];
    }
    return ans;
};
```

```go [sol1-Golang]
func xorQueries(arr []int, queries [][]int) []int {
    xors := make([]int, len(arr)+1)
    for i, v := range arr {
        xors[i+1] = xors[i] ^ v
    }
    ans := make([]int, len(queries))
    for i, q := range queries {
        ans[i] = xors[q[0]] ^ xors[q[1]+1]
    }
    return ans
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> xorQueries(vector<int>& arr, vector<vector<int>>& queries) {
        int n = arr.size();
        vector<int> xors(n + 1);
        for (int i = 0; i < n; i++) {
            xors[i + 1] = xors[i] ^ arr[i];
        }
        int m = queries.size();
        vector<int> ans(m);
        for (int i = 0; i < m; i++) {
            ans[i] = xors[queries[i][0]] ^ xors[queries[i][1] + 1];
        }
        return ans;
    }
};
```

```C [sol1-C]
int* xorQueries(int* arr, int arrSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int n = arrSize;
    int xors[n + 1];
    xors[0] = 0;
    for (int i = 0; i < n; i++) {
        xors[i + 1] = xors[i] ^ arr[i];
    }
    int m = queriesSize;
    int* ans = malloc(sizeof(int) * m);
    *returnSize = m;
    for (int i = 0; i < m; i++) {
        ans[i] = xors[queries[i][0]] ^ xors[queries[i][1] + 1];
    }
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def xorQueries(self, arr: List[int], queries: List[List[int]]) -> List[int]:
        xors = [0]
        for num in arr:
            xors.append(xors[-1] ^ num)
        
        ans = list()
        for left, right in queries:
            ans.append(xors[left] ^ xors[right + 1])
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$m$ 是数组 $\textit{queries}$ 的长度。需要遍历数组 $\textit{arr}$ 一次，计算前缀异或数组的每个元素值，然后对每个查询分别使用 $O(1)$ 的时间计算查询结果。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。需要创建长度为 $n+1$ 的前缀异或数组，注意返回值不计入空间复杂度。