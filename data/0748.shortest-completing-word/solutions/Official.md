#### 方法一：统计字符出现次数

根据题意，我们先统计 $\textit{licensePlate}$ 中每个字母的出现次数（忽略大小写），然后遍历 $\textit{words}$ 中的每个单词，若 $26$ 个字母在该单词中的出现次数均不小于在 $\textit{licensePlate}$ 中的出现次数，则该单词是一个补全词。返回最短且最靠前的补全词。

```Python [sol1-Python3]
class Solution:
    def shortestCompletingWord(self, licensePlate: str, words: List[str]) -> str:
        cnt = Counter(ch.lower() for ch in licensePlate if ch.isalpha())
        return min((word for word in words if not cnt - Counter(word)), key=len)
```

```C++ [sol1-C++]
class Solution {
public:
    string shortestCompletingWord(string licensePlate, vector<string> &words) {
        array<int, 26> cnt{};
        for (char ch : licensePlate) {
            if (isalpha(ch)) {
                ++cnt[tolower(ch) - 'a'];
            }
        }
        int idx = -1;
        for (int i = 0; i < words.size(); ++i) {
            array<int, 26> c{};
            for (char ch : words[i]) {
                ++c[ch - 'a'];
            }
            bool ok = true;
            for (int j = 0; j < 26; ++j) {
                if (c[j] < cnt[j]) {
                    ok = false;
                    break;
                }
            }
            if (ok && (idx < 0 || words[i].length() < words[idx].length())) {
                idx = i;
            }
        }
        return words[idx];
    }
};
```

```Java [sol1-Java]
class Solution {
    public String shortestCompletingWord(String licensePlate, String[] words) {
        int[] cnt = new int[26];
        for (int i = 0; i < licensePlate.length(); ++i) {
            char ch = licensePlate.charAt(i);
            if (Character.isLetter(ch)) {
                ++cnt[Character.toLowerCase(ch) - 'a'];
            }
        }
        int idx = -1;
        for (int i = 0; i < words.length; ++i) {
            int[] c = new int[26];
            for (int j = 0; j < words[i].length(); ++j) {
                char ch = words[i].charAt(j);
                ++c[ch - 'a'];
            }
            boolean ok = true;
            for (int j = 0; j < 26; ++j) {
                if (c[j] < cnt[j]) {
                    ok = false;
                    break;
                }
            }
            if (ok && (idx < 0 || words[i].length() < words[idx].length())) {
                idx = i;
            }
        }
        return words[idx];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ShortestCompletingWord(string licensePlate, string[] words) {
        int[] cnt = new int[26];
        foreach (char ch in licensePlate) {
            if (char.IsLetter(ch)) {
                ++cnt[char.ToLower(ch) - 'a'];
            }
        }
        int idx = -1;
        for (int i = 0; i < words.Length; ++i) {
            int[] c = new int[26];
            foreach (char ch in words[i]) {
                ++c[ch - 'a'];
            }
            bool ok = true;
            for (int j = 0; j < 26; ++j) {
                if (c[j] < cnt[j]) {
                    ok = false;
                    break;
                }
            }
            if (ok && (idx < 0 || words[i].Length < words[idx].Length)) {
                idx = i;
            }
        }
        return words[idx];
    }
}
```

```go [sol1-Golang]
func shortestCompletingWord(licensePlate string, words []string) (ans string) {
    cnt := [26]int{}
    for _, ch := range licensePlate {
        if unicode.IsLetter(ch) {
            cnt[unicode.ToLower(ch)-'a']++
        }
    }

next:
    for _, word := range words {
        c := [26]int{}
        for _, ch := range word {
            c[ch-'a']++
        }
        for i := 0; i < 26; i++ {
            if c[i] < cnt[i] {
                continue next
            }
        }
        if ans == "" || len(word) < len(ans) {
            ans = word
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var shortestCompletingWord = function(licensePlate, words) {
    const cnt = new Array(26).fill(0);
    for (const ch of licensePlate) {
        if (/^[a-zA-Z]+$/.test(ch)) {
            ++cnt[ch.toLowerCase().charCodeAt() - 'a'.charCodeAt()];
        }
    }
    let idx = -1;
    for (let i = 0; i < words.length; ++i) {
        const c = Array(26).fill(0);
        for (let j = 0; j < words[i].length; ++j) {
            const ch = words[i][j];
            ++c[ch.charCodeAt() - 'a'.charCodeAt()];
        }
        let ok = true;
        for (let j = 0; j < 26; ++j) {
            if (c[j] < cnt[j]) {
                ok = false;
                break;
            }
        }
        if (ok && (idx < 0 || words[i].length < words[idx].length)) {
            idx = i;
        }
    }
    return words[idx];
};
```

```C [sol1-C]
char * shortestCompletingWord(char * licensePlate, char ** words, int wordsSize){
    int cnt[26];
    int n = strlen(licensePlate);
    memset(cnt, 0 ,sizeof(cnt));

    for(int i = 0; i < n; ++i) {
        if (isalpha(licensePlate[i])) {
            ++cnt[tolower(licensePlate[i]) - 'a'];
        }
    }
    int idx = -1;
    int minLen = INT_MAX;
    for (int i = 0; i < wordsSize; ++i) {
        int currLen = strlen(words[i]);
        int c[26];
        memset(c, 0, sizeof(c));
        for (int j = 0; j < currLen; ++j) {
            ++c[words[i][j] - 'a'];
        }
        bool ok = true;
        for (int j = 0; j < 26; ++j) {
            if (c[j] < cnt[j]) {
                ok = false;
                break;
            }
        }
        if (ok && (idx < 0 || currLen < minLen)) {
            minLen = currLen;
            idx = i;
        }
    }
    return words[idx];
}
```

**复杂度分析**

- 时间复杂度：$O(N+L+M\cdot |\Sigma|)$，其中 $N$ 是字符串 $\textit{licensePlate}$ 的长度，$L$ 是 $\textit{words}$ 中的所有字符串的长度之和，$M$ 是 $\textit{words}$ 数组的长度，$|\Sigma|$ 为字符集合的大小，本题中有 $26$ 个英文字母，即 $|\Sigma|=26$。

- 空间复杂度：$O(|\Sigma|)$。