## [383.赎金信 中文官方题解](https://leetcode.cn/problems/ransom-note/solutions/100000/shu-jin-xin-by-leetcode-solution-ji8a)
#### 方法一：字符统计

题目要求使用字符串 $\textit{magazine}$ 中的字符来构建新的字符串 $\textit{ransomNote}$，且$\textit{ransomNote}$ 中的每个字符只能使用一次，只需要满足字符串 $\textit{magazine}$ 中的每个英文字母 $(\texttt{'a'-'z'})$ 的统计次数都大于等于 $\textit{ransomNote}$ 中相同字母的统计次数即可。
- 如果字符串 $\textit{magazine}$ 的长度小于字符串 $\textit{ransomNote}$ 的长度，则我们可以肯定 $\textit{magazine}$ 无法构成 $\textit{ransomNote}$，此时直接返回 $\textit{false}$。
- 首先统计 $\textit{magazine}$ 中每个英文字母 $a$ 的次数 $\textit{cnt}[a]$，再遍历统计 $\textit{ransomNote}$ 中每个英文字母的次数，如果发现 $\textit{ransomNote}$ 中存在某个英文字母 $c$ 的统计次数大于 $\textit{magazine}$ 中该字母统计次数 $\textit{cnt}[c]$，则此时我们直接返回 $\textit{false}$。

**代码**

```Java [sol1-Java]
class Solution {
    public boolean canConstruct(String ransomNote, String magazine) {
        if (ransomNote.length() > magazine.length()) {
            return false;
        }
        int[] cnt = new int[26];
        for (char c : magazine.toCharArray()) {
            cnt[c - 'a']++;
        }
        for (char c : ransomNote.toCharArray()) {
            cnt[c - 'a']--;
            if(cnt[c - 'a'] < 0) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool canConstruct(string ransomNote, string magazine) {
        if (ransomNote.size() > magazine.size()) {
            return false;
        }
        vector<int> cnt(26);
        for (auto & c : magazine) {
            cnt[c - 'a']++;
        }
        for (auto & c : ransomNote) {
            cnt[c - 'a']--;
            if (cnt[c - 'a'] < 0) {
                return false;
            }
        }
        return true;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public bool CanConstruct(string ransomNote, string magazine) {
        if (ransomNote.Length > magazine.Length) {
            return false;
        }
        int[] cnt = new int[26];
        foreach (char c in magazine) {
            cnt[c - 'a']++;
        }
        foreach (char c in ransomNote) {
            cnt[c - 'a']--;
            if (cnt[c - 'a'] < 0) {
                return false;
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        if len(ransomNote) > len(magazine):
            return False
        return not collections.Counter(ransomNote) - collections.Counter(magazine)
```

```JavaScript [sol1-JavaScript]
var canConstruct = function(ransomNote, magazine) {
    if (ransomNote.length > magazine.length) {
        return false;
    }
    const cnt = new Array(26).fill(0);
    for (const c of magazine) {
        cnt[c.charCodeAt() - 'a'.charCodeAt()]++;
    }
    for (const c of ransomNote) {
        cnt[c.charCodeAt() - 'a'.charCodeAt()]--;
        if(cnt[c.charCodeAt() - 'a'.charCodeAt()] < 0) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func canConstruct(ransomNote, magazine string) bool {
    if len(ransomNote) > len(magazine) {
        return false
    }
    cnt := [26]int{}
    for _, ch := range magazine {
        cnt[ch-'a']++
    }
    for _, ch := range ransomNote {
        cnt[ch-'a']--
        if cnt[ch-'a'] < 0 {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $m$ 是字符串 $\textit{ransomNote}$ 的长度，$n$ 是字符串 $\textit{magazine}$ 的长度，我们只需要遍历两个字符一次即可。

- 空间复杂度：$O(|S|)$，$S$ 是字符集，这道题中 $S$ 为全部小写英语字母，因此 $|S| = 26$。