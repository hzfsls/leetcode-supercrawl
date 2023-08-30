#### 方法一：贪心

考虑 $\textit{perm}[0]$ 的值，根据题意：

- 如果 $s[0]=\texttt{`I'}$，那么令 $\textit{perm}[0]=0$，则无论 $\textit{perm}[1]$ 为何值都满足 $\textit{perm}[0] < \textit{perm}[1]$；
- 如果 $s[0]=\texttt{`D'}$，那么令 $\textit{perm}[0]=n$，则无论 $\textit{perm}[1]$ 为何值都满足 $\textit{perm}[0] > \textit{perm}[1]$；

确定好 $\textit{perm}[0]$ 后，剩余的 $n-1$ 个字符和 $n$ 个待确定的数就变成了一个和原问题相同，但规模为 $n-1$ 的问题。因此我们可以继续按照上述方法确定 $\textit{perm}[1]$：如果 $s[1]=\texttt{`I'}$，那么令 $\textit{perm}[1]$ 为剩余数字中的最小数；如果 $s[1]=\texttt{`D'}$，那么令 $\textit{perm}[1]$ 为剩余数字中的最大数。如此循环直至剩下一个数，填入 $\textit{perm}[n]$ 中。

代码实现时，由于每次都选择的是最小数和最大数，我们可以用两个变量 $\textit{lo}$ 和 $\textit{hi}$ 表示当前剩余数字中的最小数和最大数。

```Python [sol1-Python3]
class Solution:
    def diStringMatch(self, s: str) -> List[int]:
        lo = 0
        hi = n = len(s)
        perm = [0] * (n + 1)
        for i, ch in enumerate(s):
            if ch == 'I':
                perm[i] = lo
                lo += 1
            else:
                perm[i] = hi
                hi -= 1
        perm[n] = lo  # 最后剩下一个数，此时 lo == hi
        return perm
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> diStringMatch(string s) {
        int n = s.length(), lo = 0, hi = n;
        vector<int> perm(n + 1);
        for (int i = 0; i < n; ++i) {
            perm[i] = s[i] == 'I' ? lo++ : hi--;
        }
        perm[n] = lo; // 最后剩下一个数，此时 lo == hi
        return perm;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] diStringMatch(String s) {
        int n = s.length(), lo = 0, hi = n;
        int[] perm = new int[n + 1];
        for (int i = 0; i < n; ++i) {
            perm[i] = s.charAt(i) == 'I' ? lo++ : hi--;
        }
        perm[n] = lo; // 最后剩下一个数，此时 lo == hi
        return perm;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] DiStringMatch(string s) {
        int n = s.Length, lo = 0, hi = n;
        int[] perm = new int[n + 1];
        for (int i = 0; i < n; ++i) {
            perm[i] = s[i] == 'I' ? lo++ : hi--;
        }
        perm[n] = lo; // 最后剩下一个数，此时 lo == hi
        return perm;
    }
}
```

```go [sol1-Golang]
func diStringMatch(s string) []int {
    n := len(s)
    perm := make([]int, n+1)
    lo, hi := 0, n
    for i, ch := range s {
        if ch == 'I' {
            perm[i] = lo
            lo++
        } else {
            perm[i] = hi
            hi--
        }
    }
    perm[n] = lo // 最后剩下一个数，此时 lo == hi
    return perm
}
```

```JavaScript [sol1-JavaScript]
var diStringMatch = function(s) {
    let n = s.length, lo = 0, hi = n;
    const perm = new Array(n + 1).fill(0);
    for (let i = 0; i < n; ++i) {
        perm[i] = s[i] === 'I' ? lo++ : hi--;
    }
    perm[n] = lo; // 最后剩下一个数，此时 lo == hi
    return perm;
};
```

```C [sol1-C]
int* diStringMatch(char * s, int* returnSize) {
    int n = strlen(s), lo = 0, hi = n;
    int *perm = (int *)malloc(sizeof(int) * (n + 1));
    for (int i = 0; i < n; ++i) {
        perm[i] = s[i] == 'I' ? lo++ : hi--;
    }
    perm[n] = lo; // 最后剩下一个数，此时 lo == hi
    *returnSize = n + 1;
    return perm;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$，返回值不计入空间复杂度。