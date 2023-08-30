#### 方法一：动态规划

**思路和算法**

我们定义 $\textit{dp}[i]$ 表示字符串 $s$ 前 $i$ 个字符组成的字符串 $s[0..i-1]$ 是否能被空格拆分成若干个字典中出现的单词。从前往后计算考虑转移方程，每次转移的时候我们需要枚举包含位置 $i-1$ 的最后一个单词，看它是否出现在字典中以及除去这部分的字符串是否合法即可。公式化来说，我们需要枚举 $s[0..i-1]$ 中的分割点 $j$ ，看 $s[0..j-1]$ 组成的字符串 $s_1$（**默认 $j = 0$ 时 $s_1$ 为空串**）和 $s[j..i-1]$ 组成的字符串 $s_2$ 是否都合法，如果两个字符串均合法，那么按照定义 $s_1$ 和 $s_2$ 拼接成的字符串也同样合法。由于计算到 $\textit{dp}[i]$ 时我们已经计算出了 $\textit{dp}[0..i-1]$ 的值，因此字符串 $s_1$ 是否合法可以直接由 $dp[j]$ 得知，剩下的我们只需要看 $s_2$ 是否合法即可，因此我们可以得出如下转移方程：  
$$
\textit{dp}[i]=\textit{dp}[j]\ \&\&\ \textit{check}(s[j..i-1])
$$
其中 $\textit{check}(s[j..i-1])$ 表示子串 $s[j..i-1]$ 是否出现在字典中。

对于检查一个字符串是否出现在给定的字符串列表里一般可以考虑哈希表来快速判断，同时也可以做一些简单的剪枝，枚举分割点的时候倒着枚举，如果分割点 $j$ 到 $i$ 的长度已经大于字典列表里最长的单词的长度，那么就结束枚举，但是需要注意的是下面的代码给出的是不带剪枝的写法。

对于边界条件，我们定义 $\textit{dp}[0]=true$ 表示空串且合法。

有能力的读者也可以考虑怎么结合字典树 $\text{Trie}$ 来实现，这里不再展开。

```Java [sol1-Java]
public class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        Set<String> wordDictSet = new HashSet(wordDict);
        boolean[] dp = new boolean[s.length() + 1];
        dp[0] = true;
        for (int i = 1; i <= s.length(); i++) {
            for (int j = 0; j < i; j++) {
                if (dp[j] && wordDictSet.contains(s.substring(j, i))) {
                    dp[i] = true;
                    break;
                }
            }
        }
        return dp[s.length()];
    }
}
```

```TypeScript [sol1-TypeScript]
function wordBreak(s: string, wordDict: string[]): boolean {
    const n: number = s.length;
    const wordDictSet: Set<string> = new Set(wordDict);
    const dp: Array<boolean> = new Array(n + 1).fill(false);
    dp[0] = true;
    for (let i = 1; i <= n; i++) {
        for (let j = 0; j < i; j++) {
            if (dp[j] && wordDictSet.has(s.substr(j, i - j))) {
                dp[i] = true;
                break;
            }
        }
    }
    return dp[n];
};
```

```golang [sol1-Golang]
func wordBreak(s string, wordDict []string) bool {
    wordDictSet := make(map[string]bool)
    for _, w := range wordDict {
        wordDictSet[w] = true
    }
    dp := make([]bool, len(s) + 1)
    dp[0] = true
    for i := 1; i <= len(s); i++ {
        for j := 0; j < i; j++ {
            if dp[j] && wordDictSet[s[j:i]] {
                dp[i] = true
                break
            }
        }
    }
    return dp[len(s)]
}
```

```C [sol1-C]
unsigned long long Hash(char* s, int l, int r) {
    unsigned long long value = 0;
    for (int i = l; i < r; i++) {
        value = value * 2333ull;
        value += s[i] - 'a' + 1;
    }
    return value;
}
bool query(unsigned long long* rec, int len_rec, unsigned long long x) {
    for (int i = 0; i < len_rec; i++) {
        if (rec[i] == x) return true;
    }
    return false;
}
bool wordBreak(char* s, char** wordDict, int wordDictSize) {
    unsigned long long rec[wordDictSize + 1];
    for (int i = 0; i < wordDictSize; i++) {
        rec[i] = Hash(wordDict[i], 0, strlen(wordDict[i]));
    }
    int len_s = strlen(s);
    bool dp[len_s + 1];
    memset(dp, 0, sizeof(dp));
    dp[0] = true;
    for (int i = 1; i <= len_s; i++) {
        for (int j = 0; j < i; j++) {
            if (dp[j] && query(rec, wordDictSize, Hash(s, j, i))) {
                dp[i] = true;
                break;
            }
        }
    }
    return dp[len_s];
}
```

```csharp [sol1-C#]
public class Solution {
    public bool WordBreak(string s, IList<string> wordDict) {
        var wordDictSet = new HashSet<string>(wordDict);

        var dp = new bool [s.Length + 1];
        dp[0] = true;
        for (int i = 1; i <= s.Length; ++i) 
        {
            for (int j = 0; j < i; ++j) 
            {
                if (dp[j] && wordDictSet.Contains(s.Substring(j, i - j))) 
                {
                    dp[i] = true;
                    break;
                }
            }
        }

        return dp[s.Length];
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    bool wordBreak(string s, vector<string>& wordDict) {
        auto wordDictSet = unordered_set <string> ();
        for (auto word: wordDict) {
            wordDictSet.insert(word);
        }

        auto dp = vector <bool> (s.size() + 1);
        dp[0] = true;
        for (int i = 1; i <= s.size(); ++i) {
            for (int j = 0; j < i; ++j) {
                if (dp[j] && wordDictSet.find(s.substr(j, i - j)) != wordDictSet.end()) {
                    dp[i] = true;
                    break;
                }
            }
        }

        return dp[s.size()];
    }
};
```

**复杂度分析**

* 时间复杂度：$O(n^2)$ ，其中 $n$ 为字符串 $s$ 的长度。我们一共有 $O(n)$ 个状态需要计算，每次计算需要枚举 $O(n)$ 个分割点，哈希表判断一个字符串是否出现在给定的字符串列表需要 $O(1)$ 的时间，因此总时间复杂度为 $O(n^2)$。

* 空间复杂度：$O(n)$ ，其中 $n$ 为字符串 $s$ 的长度。我们需要 $O(n)$ 的空间存放 $\textit{dp}$ 值以及哈希表亦需要 $O(n)$ 的空间复杂度，因此总空间复杂度为 $O(n)$。