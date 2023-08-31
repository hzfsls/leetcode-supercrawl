## [1408.数组中的字符串匹配 中文官方题解](https://leetcode.cn/problems/string-matching-in-an-array/solutions/100000/shu-zu-zhong-de-zi-fu-chuan-pi-pei-by-le-rpmt)
#### 方法一：暴力枚举

对于字符串数组中的某个字符串 $\textit{words}[i]$，我们判断它是否是其他字符串的子字符串，只需要枚举 $\textit{words}[j]$，其中 $j \ne i$，如果 $\textit{words}[i]$ 是 $\textit{words}[j]$ 的子字符串，那么将 $\textit{words}[i]$ 加入结果中。

```Python [sol1-Python3]
class Solution:
    def stringMatching(self, words: List[str]) -> List[str]:
        ans = []
        for i, x in enumerate(words):
            for j, y in enumerate(words):
                if j != i and x in y:
                    ans.append(x)
                    break
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> stringMatching(vector<string>& words) {
        vector<string> ret;
        for (int i = 0; i < words.size(); i++) {
            for (int j = 0; j < words.size(); j++) {
                if (i != j && words[j].find(words[i]) != string::npos) {
                    ret.push_back(words[i]);
                    break;
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> stringMatching(String[] words) {
        List<String> ret = new ArrayList<String>();
        for (int i = 0; i < words.length; i++) {
            for (int j = 0; j < words.length; j++) {
                if (i != j && words[j].contains(words[i])) {
                    ret.add(words[i]);
                    break;
                }
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> StringMatching(string[] words) {
        IList<string> ret = new List<string>();
        for (int i = 0; i < words.Length; i++) {
            for (int j = 0; j < words.Length; j++) {
                if (i != j && words[j].Contains(words[i])) {
                    ret.Add(words[i]);
                    break;
                }
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
char ** stringMatching(char ** words, int wordsSize, int* returnSize){
    char **ret = (char **)malloc(sizeof(char *) * wordsSize);
    int pos = 0;
    for (int i = 0; i < wordsSize; i++) {
        for (int j = 0; j < wordsSize; j++) {
            if (i != j && strstr(words[j], words[i])) {
                ret[pos++] = words[i];
                break;
            }
        }
    }
    *returnSize = pos;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var stringMatching = function(words) {
    const ret = [];
    for (let i = 0; i < words.length; i++) {
        for (let j = 0; j < words.length; j++) {
            if (i !== j && words[j].search(words[i]) !== -1) {
                ret.push(words[i]);
                break;
            }
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func stringMatching(words []string) (ans []string) {
    for i, x := range words {
        for j, y := range words {
            if j != i && strings.Contains(y, x) {
                ans = append(ans, x)
                break
            }
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2 \times L^2)$，其中 $n$ 是字符串数组的长度，$L$ 是字符串数组中最长字符串的长度。使用 $\text{KMP}$ 字符串匹配算法可以将时间复杂度优化到 $O(n^2 \times T)$，其中 $T$ 是字符串数组中所有字符串的平均长度。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。如果使用 $\text{KMP}$ 字符串匹配算法，那么对应的空间复杂度为 $O(T)$。