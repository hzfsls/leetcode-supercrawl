## [1768.交替合并字符串 中文官方题解](https://leetcode.cn/problems/merge-strings-alternately/solutions/100000/jiao-ti-he-bing-zi-fu-chuan-by-leetcode-ac4ih)
#### 方法一：双指针

**思路与算法**

我们直接按照题目的要求模拟即可。我们使用两个指针 $i$ 和 $j$，初始时分别指向两个字符串的首个位置。随后的每次循环中，依次进行如下的两步操作：

- 如果 $i$ 没有超出 $\textit{word}_1$ 的范围，就将 $\textit{word}_1[i]$ 加入答案，并且将 $i$ 移动一个位置；

- 如果 $j$ 没有超出 $\textit{word}_2$ 的范围，就将 $\textit{word}_2[j]$ 加入答案，并且将 $j$ 移动一个位置。

当 $i$ 和 $j$ 都超出对应的范围后，结束循环并返回答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string mergeAlternately(string word1, string word2) {
        int m = word1.size(), n = word2.size();
        int i = 0, j = 0;
        
        string ans;
        ans.reserve(m + n);
        while (i < m || j < n) {
            if (i < m) {
                ans.push_back(word1[i]);
                ++i;
            }
            if (j < n) {
                ans.push_back(word2[j]);
                ++j;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String mergeAlternately(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        int i = 0, j = 0;

        StringBuilder ans = new StringBuilder();
        while (i < m || j < n) {
            if (i < m) {
                ans.append(word1.charAt(i));
                ++i;
            }
            if (j < n) {
                ans.append(word2.charAt(j));
                ++j;
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string MergeAlternately(string word1, string word2) {
        int m = word1.Length, n = word2.Length;
        int i = 0, j = 0;

        StringBuilder ans = new StringBuilder();
        while (i < m || j < n) {
            if (i < m) {
                ans.Append(word1[i]);
                ++i;
            }
            if (j < n) {
                ans.Append(word2[j]);
                ++j;
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def mergeAlternately(self, word1: str, word2: str) -> str:
        m, n = len(word1), len(word2)
        i = j = 0

        ans = list()
        while i < m or j < n:
            if i < m:
                ans.append(word1[i])
                i += 1
            if j < n:
                ans.append(word2[j])
                j += 1
        
        return "".join(ans)
```

```JavaScript [sol1-JavaScript]
var mergeAlternately = function(word1, word2) {
    const m = word1.length, n = word2.length;
    let i = 0, j = 0;

    const ans = [];
    while (i < m || j < n) {
        if (i < m) {
            ans.push(word1[i]);
            ++i;
        }
        if (j < n) {
            ans.push(word2[j]);
            ++j;
        }
    }
    return ans.join('');
};
```

```go [sol1-Golang]
func mergeAlternately(word1, word2 string) string {
    n, m := len(word1), len(word2)
    ans := make([]byte, 0, n+m)
    for i := 0; i < n || i < m; i++ {
        if i < n {
            ans = append(ans, word1[i])
        }
        if i < m {
            ans = append(ans, word2[i])
        }
    }
    return string(ans)
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度。

- 空间复杂度：$O(1)$ 或 $O(m+n)$。如果使用的语言支持可修改的字符串，那么空间复杂度为 $O(1)$，否则为 $O(m+n)$。注意这里不计入返回值需要的空间。