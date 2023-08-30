#### 方法一：遍历

**思路与算法**

由题意可知，除了最后一个单词，每个单词后面都跟随一个空格。因此我们可以通过统计空格与句子结尾的数目来统计单词数 $\textit{count}$。当 $\textit{count}=\textit{k}$ 时，将当前的下标记录到 $\textit{end}$，返回句子 $\textit{s}$ 在 $\textit{end}$ 处截断的句子。

**代码**

```C [sol1-C]
char * truncateSentence(char * s, int k){
    int n = strlen(s);
    int end = 0, count = 0;
    for (int i = 1; i <= n; i++) {
        if (i == n || s[i] == ' ') {
            count++;
            if (count == k) {
                end = i;
                break;
            }
        }
    }
    s[end] = '\0';
    return s;
}
```

```C++ [sol1-C++]
class Solution {
public:
    string truncateSentence(string s, int k) {
        int n = s.size();
        int end = 0, count = 0;
        for (int i = 1; i <= n; i++) {
            if (i == n || s[i] == ' ') {
                count++;
                if (count == k) {
                    end = i;
                    break;
                }
            }
        }
        return s.substr(0, end);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String truncateSentence(String s, int k) {
        int n = s.length();
        int end = 0, count = 0;
        for (int i = 1; i <= n; i++) {
            if (i == n || s.charAt(i) == ' ') {
                count++;
                if (count == k) {
                    end = i;
                    break;
                }
            }
        }
        return s.substring(0, end);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string TruncateSentence(string s, int k) {
        int n = s.Length;
        int end = 0, count = 0;
        for (int i = 1; i <= n; i++) {
            if (i == n || s[i] == ' ') {
                count++;
                if (count == k) {
                    end = i;
                    break;
                }
            }
        }
        return s.Substring(0, end);
    }
}
```

```Go [sol1-Golang]
func truncateSentence(s string, k int) string {
    n, end, count := len(s), 0, 0
    for i := 1; i <= n; i++ {
        if i == n || s[i] == ' ' {
            count++
            if count == k {
                end = i
                break
            }
        }
    }
    return s[:end]
}
```

```JavaScript [sol1-JavaScript]
var truncateSentence = function(s, k) {
    const n = s.length;
    let end = 0, count = 0;
    for (let i = 1; i <= n; i++) {
        if (i === n || s[i] === ' ') {
            count++;
            if (count === k) {
                end = i;
                break;
            }
        }
    }
    return s.slice(0, end);
};
```

```Python [sol1-Python3]
class Solution:
    def truncateSentence(self, s: str, k: int) -> str:
        n, end, count = len(s), 0, 0
        for i in range(1, n + 1):
            if i == n or s[i] == ' ':
                count += 1
                if count == k:
                    end = i
                    break
        return s[:end]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为句子 $\textit{s}$ 的长度。遍历整个字符串需要 $O(N)$。

- 空间复杂度：$O(1)$。注意返回值不计入空间复杂度。