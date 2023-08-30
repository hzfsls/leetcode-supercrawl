#### 方法一：两次遍历

问题可以转换成，对 $s$ 的每个下标 $i$，求

- $s[i]$ 到其左侧最近的字符 $c$ 的距离
- $s[i]$ 到其右侧最近的字符 $c$ 的距离

这两者的最小值。

对于前者，我们可以从左往右遍历 $s$，若 $s[i]=c$ 则记录下此时字符 $c$ 的的下标 $\textit{idx}$。遍历的同时更新 $\textit{answer}[i]=i-\textit{idx}$。

对于后者，我们可以从右往左遍历 $s$，若 $s[i]=c$ 则记录下此时字符 $c$ 的的下标 $\textit{idx}$。遍历的同时更新 $\textit{answer}[i]=\min(\textit{answer}[i],\textit{idx}-i)$。

代码实现时，在开始遍历的时候 $\textit{idx}$ 可能不存在，为了简化逻辑，我们可以用 $-n$ 或 $2n$ 表示，这里 $n$ 是 $s$ 的长度。

```Python [sol1-Python3]
class Solution:
    def shortestToChar(self, s: str, c: str) -> List[int]:
        n = len(s)
        ans = [0] * n

        idx = -n
        for i, ch in enumerate(s):
            if ch == c:
                idx = i
            ans[i] = i - idx

        idx = 2 * n
        for i in range(n - 1, -1, -1):
            if s[i] == c:
                idx = i
            ans[i] = min(ans[i], idx - i)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> shortestToChar(string s, char c) {
        int n = s.length();
        vector<int> ans(n);

        for (int i = 0, idx = -n; i < n; ++i) {
            if (s[i] == c) {
                idx = i;
            }
            ans[i] = i - idx;
        }

        for (int i = n - 1, idx = 2 * n; i >= 0; --i) {
            if (s[i] == c) {
                idx = i;
            }
            ans[i] = min(ans[i], idx - i);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] shortestToChar(String s, char c) {
        int n = s.length();
        int[] ans = new int[n];

        for (int i = 0, idx = -n; i < n; ++i) {
            if (s.charAt(i) == c) {
                idx = i;
            }
            ans[i] = i - idx;
        }

        for (int i = n - 1, idx = 2 * n; i >= 0; --i) {
            if (s.charAt(i) == c) {
                idx = i;
            }
            ans[i] = Math.min(ans[i], idx - i);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ShortestToChar(string s, char c) {
        int n = s.Length;
        int[] ans = new int[n];

        for (int i = 0, idx = -n; i < n; ++i) {
            if (s[i] == c) {
                idx = i;
            }
            ans[i] = i - idx;
        }

        for (int i = n - 1, idx = 2 * n; i >= 0; --i) {
            if (s[i] == c) {
                idx = i;
            }
            ans[i] = Math.Min(ans[i], idx - i);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func shortestToChar(s string, c byte) []int {
    n := len(s)
    ans := make([]int, n)

    idx := -n
    for i, ch := range s {
        if byte(ch) == c {
            idx = i
        }
        ans[i] = i - idx
    }

    idx = n * 2
    for i := n - 1; i >= 0; i-- {
        if s[i] == c {
            idx = i
        }
        ans[i] = min(ans[i], idx-i)
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var shortestToChar = function(s, c) {
    const n = s.length;
    const ans = new Array(n).fill(0);

    for (let i = 0, idx = -n; i < n; ++i) {
        if (s[i] === c) {
            idx = i;
        }
        ans[i] = i - idx;
    }

    for (let i = n - 1, idx = 2 * n; i >= 0; --i) {
        if (s[i] == c) {
            idx = i;
        }
        ans[i] = Math.min(ans[i], idx - i);
    }
    return ans;
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int* shortestToChar(char * s, char c, int* returnSize){
    int n = strlen(s);
    int *ans = (int *)malloc(sizeof(int) * n);

    for (int i = 0, idx = -n; i < n; ++i) {
        if (s[i] == c) {
            idx = i;
        }
        ans[i] = i - idx;
    }

    for (int i = n - 1, idx = 2 * n; i >= 0; --i) {
        if (s[i] == c) {
            idx = i;
        }
        ans[i] = MIN(ans[i], idx - i);
    }
    *returnSize = n;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。