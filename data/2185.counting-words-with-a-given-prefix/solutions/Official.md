## [2185.统计包含给定前缀的字符串 中文官方题解](https://leetcode.cn/problems/counting-words-with-a-given-prefix/solutions/100000/tong-ji-bao-han-gei-ding-qian-zhui-de-zi-aaq7)

#### 方法一：模拟

**思路**

按照题意，对 $\textit{words}$ 每个单词进行判断，是否以 $\textit{pref}$ 开头即可。最后返回满足条件的单词的数量。

**代码**

```Python [sol1-Python3]
class Solution:
    def prefixCount(self, words: List[str], pref: str) -> int:
        return sum(w.startswith(pref) for w in words)
```

```Java [sol1-Java]
class Solution {
    public int prefixCount(String[] words, String pref) {
        int res = 0;
        for (String word : words) {
            if (word.startsWith(pref)) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int PrefixCount(string[] words, string pref) {
        int res = 0;
        foreach (string word in words) {
            if (word.StartsWith(pref)) {
                res++;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int prefixCount(vector<string>& words, string pref) {
        int res = 0;
        for (string & word : words) {
            if (word.compare(0, pref.size(), pref) == 0) {
                res++;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int prefixCount(char ** words, int wordsSize, char * pref) {
    int res = 0;
    int len = strlen(pref);
    for (int i = 0; i < wordsSize; i++) {
        if (strncmp(words[i], pref, len) == 0) {
            res++;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func prefixCount(words []string, pref string) (ans int) {
	for _, word := range words {
		if strings.HasPrefix(word, pref) {
			ans++
		}
	}
	return
}
```

```JavaScript [sol1-JavaScript]
var prefixCount = function(words, pref) {
    let res = 0;
    for (const word of words) {
        if (word.startsWith(pref)) {
            res++;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$，其中 $n$ 是输入 $\textit{words}$ 的长度，$m$ 是输入 $\textit{pref}$ 的长度。

- 空间复杂度：$O(1)$，仅需要常数空间。