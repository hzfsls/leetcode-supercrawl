#### 方法一：分情况讨论

计算字典序最小的字符串时，需要分别考虑 $k = 1$ 和 $k > 1$ 的两种情况。

当 $k = 1$ 时，每次只能取 $s$ 的首个字符并将其移动到末尾，因此对于给定的字符串，可能的移动方法是唯一的，移动后的结果也是唯一的。对于长度为 $n$ 的字符串 $s$，经过 $0$ 次到 $n - 1$ 次移动之后分别得到 $n$ 个字符串，这 $n$ 个字符串中的字典序最小的字符串即为答案。

当 $k > 1$ 时，一定可以经过移动将 $s$ 变成升序字符串，因此将字符串 $s$ 升序排序之后得到的字符串即为答案。理由如下。

考虑 $k = 2$ 的情况。假设 $s$ 的所有字符按照升序排序依次是 $c_0, c_1, \ldots, c_{n - 1}$。对于 $s$ 的任意排列，总是可以经过若干次移动将 $c_{n - 1}$ 变成首个字符。

当 $c_{n - 1}$ 变成首个字符之后，可以将 $c_{n - 2}, c_{n - 1}$ 变成前两个字符：

1. 每次将首个字符移动到末尾，直到 $c_{n - 2}$ 变成首个字符；

2. 保持 $c_{n - 2}$ 位于首个字符，每次将 $c_{n - 2}$ 后面的字符移动到末尾，直到 $c_{n - 2}$ 后面的字符是 $c_{n - 1}$。

使用同样的方法，对于 $1 \le m < n$，如果 $c_{n - m}, c_{n - m + 1}, \ldots, c_{n - 1}$ 位于前 $m$ 个字符，则可以经过若干次移动将 $c_{n - m - 1}, c_{n - m}, c_{n - m + 1}, \ldots, c_{n - 1}$ 变成前 $m + 1$ 个字符：

1. 每次将首个字符移动到末尾，直到 $c_{n - m - 1}$ 变成首个字符，此时 $c_{n - m}, c_{n - m + 1}, \ldots, c_{n - 1}$ 为字符串中连续的 $m$ 个字符；

2. 保持 $c_{n - m - 1}$ 位于首个字符，每次将 $c_{n - m - 1}$ 后面的字符移动到末尾，直到 $c_{n - m - 1}$ 后面的字符是 $c_{n - m}$，此时前 $m + 1$ 个字符是 $c_{n - m - 1}, c_{n - m}, c_{n - m + 1}, \ldots, c_{n - 1}$。

因此，当 $k = 2$ 时，一定可以经过移动将 $s$ 变成升序字符串。

当 $k > 2$ 时，同样可以对字符串的前两个字符执行移动操作将 $s$ 变成升序字符串。

```Python [sol1-Python3]
class Solution:
    def orderlyQueue(self, s: str, k: int) -> str:
        if k == 1:
            ans = s
            for _ in range(len(s) - 1):
                s = s[1:] + s[0]
                ans = min(ans, s)
            return ans
        return ''.join(sorted(s))
```

```Java [sol1-Java]
class Solution {
    public String orderlyQueue(String s, int k) {
        if (k == 1) {
            String smallest = s;
            StringBuilder sb = new StringBuilder(s);
            int n = s.length();
            for (int i = 1; i < n; i++) {
                char c = sb.charAt(0);
                sb.deleteCharAt(0);
                sb.append(c);
                if (sb.toString().compareTo(smallest) < 0) {
                    smallest = sb.toString();
                }
            }
            return smallest;
        } else {
            char[] arr = s.toCharArray();
            Arrays.sort(arr);
            return new String(arr);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string OrderlyQueue(string s, int k) {
        if (k == 1) {
            string smallest = s;
            StringBuilder sb = new StringBuilder(s);
            int n = s.Length;
            for (int i = 1; i < n; i++) {
                char c = sb[0];
                sb.Remove(0, 1);
                sb.Append(c);
                if (sb.ToString().CompareTo(smallest) < 0) {
                    smallest = sb.ToString();
                }
            }
            return smallest;
        } else {
            char[] arr = s.ToCharArray();
            Array.Sort(arr);
            return new string(arr);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string orderlyQueue(string s, int k) {
        if (k == 1) {
            string smallest = s;
            int n = s.size();
            for (int i = 1; i < n; i++) {
                char c = s[0];
                s = s.substr(1);
                s.push_back(c);
                if (s < smallest) {
                    smallest = s;
                }
            }
            return smallest;
        } else {
            sort(s.begin(), s.end());
            return s;
        }
    }
};
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(char *)pa - *(char *)pb;
}

char * orderlyQueue(char * s, int k) {
    int n = strlen(s);
    if (k == 1) {
        char *smallest = (char *)malloc(sizeof(char) * (n + 1));
        strcpy(smallest, s);
        for (int i = 1; i < n; i++) {
            char c = s[0];
            for (int j = 0; j < n - 1; j++) {
                s[j] = s[j + 1];
            }
            s[n - 1] = c;
            if (strcmp(s, smallest) < 0) {
                strcpy(smallest, s);
            }
        }
        return smallest;
    } else {
        qsort(s, n, sizeof(char), cmp);
        return s;
    }
}
```

```go [sol1-Golang]
func orderlyQueue(s string, k int) string {
    if k == 1 {
        ans := s
        for i := 1; i < len(s); i++ {
            s = s[1:] + s[:1]
            if s < ans {
                ans = s
            }
        }
        return ans
    }
    t := []byte(s)
    sort.Slice(t, func(i, j int) bool { return t[i] < t[j] })
    return string(t)
}
```

```JavaScript [sol1-JavaScript]
var orderlyQueue = function(s, k) {
    if (k === 1) {
        let ans = s;
        for (let i = 0; i < s.length - 1; ++i) {
            const n = s.length;
            s = s.substring(1, n) + s[0];
            ans = ans < s ? ans : s;
        }
        return ans;
    }
    return [...s].sort().join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。当 $k = 1$ 时需要遍历 $n$ 个可能的字符串，每个字符串需要 $O(n)$ 的时间生成和判断是否字典序最小，时间复杂度是 $O(n^2)$；当 $k > 1$ 时需要对字符串排序，时间复杂度是 $O(n \log n)$。最坏情况下时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(n)$ 或 $O(\log n)$，其中 $n$ 是字符串 $s$ 的长度。空间复杂度取决于具体实现的语言。对于字符串不可变的语言，当 $k = 1$ 时生成每个字符串和当 $k > 1$ 时生成排序后的字符串都需要 $O(n)$ 的空间；对于字符串可变的语言，可以省略 $O(n)$ 的空间，只有当 $k > 1$ 时排序需要 $O(\log n)$ 的空间。

#### 结语

上述做法在 $k = 1$ 时寻找字典序最小的字符串需要 $O(n^2)$ 的时间。如果使用最小表示法，则可以将时间复杂度降低到 $O(n)$。

由于最小表示法超出了面试的范围，因此这里不具体讲解，感兴趣的读者可以参考[最小表示法](https://oi-wiki.org/string/minimal-string)。