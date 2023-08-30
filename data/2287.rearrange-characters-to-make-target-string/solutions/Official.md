#### 方法一：哈希表计数

这道题要求计算使用 $s$ 中的字符可以形成的 $\textit{target}$ 的最大副本数，因此需要统计 $\textit{target}$ 中的每个字符的出现次数，以及统计这些字符在 $s$ 中的出现次数。

如果一个字符在 $\textit{target}$ 中出现 $x$ 次（$x > 0$），在 $s$ 中出现 $y$ 次，则在只考虑该字符的情况下，可以形成的 $\textit{target}$ 的最大副本数是 $\Big\lfloor \dfrac{y}{x} \Big\rfloor$。特别地，如果 $y < x$，则不能形成 $\textit{target}$ 的副本。

对于 $\textit{target}$ 中的每个字符，计算该字符在 $\textit{target}$ 中的出现次数和在 $s$ 中的出现次数，并计算使用该字符可以形成的 $\textit{target}$ 的最大副本数。所有字符对应的最大副本数中的最小值即为使用 $s$ 中的字符可以形成的 $\textit{target}$ 的最大副本数。

实现方面，需要使用两个哈希表分别记录 $s$ 和 $\textit{target}$ 的每个字符的出现次数。有两处可以优化。

1. 由于只有在 $\textit{target}$ 中出现的字符才会影响最大副本数，因此统计 $s$ 中的每个字符的出现次数时，只需要考虑在 $\textit{target}$ 中出现的字符，忽略没有在 $\textit{target}$ 中出现的字符。

2. 如果遇到一个在 $\textit{target}$ 中出现的字符对应的最大副本数是 $0$，则不能使用 $s$ 中的字符形成 $\textit{target}$ 的副本，此时可提前返回 $0$。

```Python [sol1-Python3]
class Solution:
    def rearrangeCharacters(self, s: str, target: str) -> int:
        ans = inf
        cnt_s = Counter(s)
        for c, cnt in Counter(target).items():
            ans = min(ans, cnt_s[c] // cnt)
            if ans == 0:
                return 0
        return ans
```

```Java [sol1-Java]
class Solution {
    public int rearrangeCharacters(String s, String target) {
        Map<Character, Integer> sCounts = new HashMap<Character, Integer>();
        Map<Character, Integer> targetCounts = new HashMap<Character, Integer>();
        int n = s.length(), m = target.length();
        for (int i = 0; i < m; i++) {
            char c = target.charAt(i);
            targetCounts.put(c, targetCounts.getOrDefault(c, 0) + 1);
        }
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (targetCounts.containsKey(c)) {
                sCounts.put(c, sCounts.getOrDefault(c, 0) + 1);
            }
        }
        int ans = Integer.MAX_VALUE;
        for (Map.Entry<Character, Integer> entry : targetCounts.entrySet()) {
            char c = entry.getKey();
            int count = entry.getValue();
            int totalCount = sCounts.containsKey(c) ? sCounts.get(c) : 0;
            ans = Math.min(ans, totalCount / count);
            if (ans == 0) {
                return 0;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int RearrangeCharacters(string s, string target) {
        IDictionary<char, int> sCounts = new Dictionary<char, int>();
        IDictionary<char, int> targetCounts = new Dictionary<char, int>();
        foreach (char c in target) {
            targetCounts.TryAdd(c, 0);
            targetCounts[c]++;
        }
        foreach (char c in s) {
            if (targetCounts.ContainsKey(c)) {
                sCounts.TryAdd(c, 0);
                sCounts[c]++;
            }
        }
        int ans = int.MaxValue;
        foreach (KeyValuePair<char, int> pair in targetCounts) {
            char c = pair.Key;
            int count = pair.Value;
            int totalCount = sCounts.ContainsKey(c) ? sCounts[c] : 0;
            ans = Math.Min(ans, totalCount / count);
            if (ans == 0) {
                return 0;
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int rearrangeCharacters(string s, string target) {
        unordered_map<char, int> sCounts, targetCounts;
        int n = s.size(), m = target.size();
        for (int i = 0; i < m; i++) {
            targetCounts[target[i]]++;
        }
        for (int i = 0; i < n; i++) {
            if (targetCounts.count(s[i])) {
                sCounts[s[i]]++;
            }
        }
        int ans = INT_MAX;
        for (auto &[c, count] : targetCounts) {
            int totalCount = sCounts[c];
            ans = min(ans, totalCount / count);
            if (ans == 0) {
                return 0;
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int rearrangeCharacters(char * s, char * target) {
    int sCounts[26], targetCounts[26];
    memset(sCounts, 0, sizeof(sCounts));
    memset(targetCounts, 0, sizeof(targetCounts));
    int n = strlen(s), m = strlen(target);
    for (int i = 0; i < m; i++) {
        targetCounts[target[i] - 'a']++;
    }
    for (int i = 0; i < n; i++) {
        if (targetCounts[s[i] - 'a']) {
            sCounts[s[i] - 'a']++;
        }
    }
    int ans = INT_MAX;
    for (int i = 0; i < 26; i++) {
        if (targetCounts[i] > 0) {
            ans = MIN(ans, sCounts[i] / targetCounts[i]);
            if (ans == 0) {
                return 0;
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var rearrangeCharacters = function(s, target) {
    const sCounts = new Map();
    const targetCounts = new Map();
    const n = s.length, m = target.length;
    for (let i = 0; i < m; i++) {
        const c = target[i];
        targetCounts.set(c, (targetCounts.get(c) || 0) + 1);
    }
    for (let i = 0; i < n; i++) {
        const c = s[i];
        if (targetCounts.has(c)) {
            sCounts.set(c, (sCounts.get(c) || 0) + 1);
        }
    }
    let ans = Number.MAX_VALUE;
    for (const [c, count] of targetCounts.entries()) {
        const totalCount = sCounts.has(c) ? sCounts.get(c) : 0;
        ans = Math.min(ans, Math.floor(totalCount / count));
        if (ans === 0) {
            return 0;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func rearrangeCharacters(s, target string) int {
    var cntS, cntT [26]int
    for _, c := range s {
        cntS[c-'a']++
    }
    for _, c := range target {
        cntT[c-'a']++
    }
    ans := len(s)
    for i, c := range cntT {
        if c > 0 {
            ans = min(ans, cntS[i]/c)
            if ans == 0 {
                return 0
            }
        }
    }
    return ans
}

func min(a, b int) int { if a > b { return b }; return a }
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 和 $m$ 分别是字符串 $s$ 的长度和字符串 $\textit{target}$ 的长度。需要分别遍历两个字符串一次统计每个字符的出现次数并使用哈希表记录，然后遍历哈希表一次计算最大副本数，时间复杂度是 $O(n + m)$。

- 空间复杂度：$O(m)$，其中 $m$ 是字符串 $\textit{target}$ 的长度。空间复杂度主要取决于哈希表，哈希表中只记录在 $\textit{target}$ 中出现的字符，因此哈希表的大小不超过 $m$，空间复杂度是 $O(m)$。