## [1023.驼峰式匹配 中文官方题解](https://leetcode.cn/problems/camelcase-matching/solutions/100000/tuo-feng-shi-pi-pei-by-leetcode-solution-pwq7)
#### 方法一：双指针

**思路与算法**

设待检验字符串是 $\textit{queries}[i]$，如果 $\textit{pattern}$ 是 $\textit{queries}[i]$ 的子序列，并且去掉 $\textit{pattern}$ 之后 $\textit{queries}[i]$ 的剩余部分都由小写字母构成，那么 $\textit{queries}[i]$ 就与 $\textit{pattern}$ 匹配。

具体来说，我们维护一个下标 $p$，用来遍历 $\textit{pattern}$，然后遍历 $\textit{queries}[i]$ 中的每个字符 $c$：

1. 如果 $p < \textit{pattern.length}$，并且 $\textit{pattern}[p] = c$，那么令 $p$ 加 $1$。
2. 否则，考虑 $c$ 是否是一个大写字母。如果是，则匹配失败；如果不是，则该小写字母可以插入 $\textit{pattern}$ 来与 $\textit{queries}[i]$ 匹配，因此，我们可以继续遍历下一个字符。

$\textit{queries}[i]$ 遍历结束后，如果 $p < \textit{pattern.length}$，则表示 $\textit{pattern}$ 中还有字符未被匹配，$\textit{queries}[i]$ 与 $\textit{pattern}$ 匹配失败。其余情况 $\textit{pattern}$ 匹配完毕，匹配成功。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<bool> camelMatch(vector<string>& queries, string pattern) {
        int n = queries.size();
        vector<bool> res(n, true);
        for (int i = 0; i < n; i++) {
            int p = 0;
            for (auto c : queries[i]) {
                if (p < pattern.size() && pattern[p] == c) {
                    p++;
                } else if (isupper(c)) {
                    res[i] = false;
                    break;
                }
            }
            if (p < pattern.size()) {
                res[i] = false;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Boolean> camelMatch(String[] queries, String pattern) {
        int n = queries.length;
        List<Boolean> res = new ArrayList<Boolean>();
        for (int i = 0; i < n; i++) {
            boolean flag = true;
            int p = 0;
            for (int j = 0; j < queries[i].length(); j++) {
                char c = queries[i].charAt(j);
                if (p < pattern.length() && pattern.charAt(p) == c) {
                    p++;
                } else if (Character.isUpperCase(c)) {
                    flag = false;
                    break;
                }
            }
            if (p < pattern.length()) {
                flag = false;
            }
            res.add(flag);
        }
        return res;
    }
}
```

```Python [sol1-Python]
class Solution:
    def camelMatch(self, queries: List[str], pattern: str) -> List[bool]:
        n = len(queries)
        res = [True] * n
        for i in range(n):
            p = 0
            for c in queries[i]:
                if p < len(pattern) and pattern[p] == c:
                    p += 1
                elif c.isupper():
                    res[i] = False
                    break
            if p < len(pattern):
                res[i] = False
        return res

```

```Go [sol1-Go]
func camelMatch(queries []string, pattern string) []bool {
    n := len(queries)
    res := make([]bool, n)
    for i := 0; i < n; i++ {
        res[i] = true
        p := 0
        for _, c := range queries[i] {
            if p < len(pattern) && pattern[p] == byte(c) {
                p++
            } else if unicode.IsUpper(c) {
                res[i] = false
                break
            }
        }
        if p < len(pattern) {
            res[i] = false
        }
    }
    return res
}
```
```JavaScript [sol1-JavaScript]
var camelMatch = function(queries, pattern) {
    let n = queries.length
    let res = new Array(n)
    for (let i = 0; i < n; i++) {
        res[i] = true
        let p = 0
        for (let j = 0; j < queries[i].length; j++) {
            let c = queries[i][j]
            if (p < pattern.length && pattern[p] === c) {
                p++
            } else if (c.toUpperCase() === c) {
                res[i] = false
                break
            }
        }
        if (p < pattern.length) {
            res[i] = false
        }
    }
    return res
};
```

```C# [sol1-C#]
public class Solution {
    public IList<bool> CamelMatch(string[] queries, string pattern) {
        int n = queries.Length;
        IList<bool> res = new List<bool>();
        for (int i = 0; i < n; i++) {
            bool flag = true;
            int p = 0;
            foreach (char c in queries[i]) {
                if (p < pattern.Length && pattern[p] == c) {
                    p++;
                } else if (char.IsUpper(c)) {
                    flag = false;
                    break;
                }
            }
            if (p < pattern.Length) {
                flag = false;
            }
            res.Add(flag);
        }
        return res;
    }
}
```

```C [sol1-C]
bool* camelMatch(char ** queries, int queriesSize, char * pattern, int* returnSize) {
    int n = queriesSize;
    int m = strlen(pattern);
    bool *res = (bool *)calloc(n, sizeof(bool));
    for (int i = 0; i < n; i++) {
        res[i] = true;
        int p = 0;
        for (int j = 0; queries[i][j] != '\0'; j++) {
            if (p < m && pattern[p] == queries[i][j]) {
                p++;
            } else if (isupper(queries[i][j])) {
                res[i] = false;
                break;
            }
        }
        if (p < m) {
            res[i] = false;
        }
    }
    *returnSize = n;
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 是 $\textit{queries}$ 的长度，$m$ 是 $\textit{queries}[i]$ 的长度。

- 空间复杂度：$O(1)$。我们忽略返回值的空间复杂度，过程中只使用了常数个变量。