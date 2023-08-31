## [859.亲密字符串 中文官方题解](https://leetcode.cn/problems/buddy-strings/solutions/100000/qin-mi-zi-fu-chuan-by-leetcode-solution-yyis)

#### 方法一：枚举

**思路与算法**

设两个字符串分别为 $s$ 和 $\textit{goal}$，其中 $s[i]$ 表示 $s$ 的第 $i$ 个字符，其中 $\textit{goal}[i]$ 表示 $\textit{goal}$ 的第 $i$ 个字符。如果 $s[i] = \textit{goal}[i]$，我们就说 $i$ 是匹配的，否则称 $i$ 是不匹配的。亲密字符串定义为：需要交换 $s$ 中的第 $i$ 个字符 $s[i]$ 与 $\textit{s}$ 中第 $j$ 个字符且满足 $i \neq j$，交换后 $s$ 与 $\textit{goal}$ 相等。亲密字符串的两个字符串需要交换一次索引不相等的两个字符后相等。

如果满足交换 $s[i]$ 和 $s[j]$ 后两个字符串相等，那么需要满足以下几个条件使得 $s$ 和 $\textit{goal}$ 为亲密字符串：
- 字符串 $s$ 的长度与字符串 $\textit{goal}$ 的长度相等；
- 存在 $i \neq j$ 且满足 $s[i] = \textit{goal}[j]$ 以及 $s[j] = \textit{goal}[i]$，实际在 $s[i], s[j], \textit{goal}[i], \textit{goal}[j]$ 这四个自由变量中，只存在两种情况：
  1. 满足 $s[i] = s[j]$：则此时必然满足 $s[i] = s[j] = \textit{goal}[i] = \textit{goal}[j]$，字符串 $s$ 与 $\textit{goal}$ 相等，我们应当能够在 $s$ 中找到两个不同的索引 $i,j$，且满足 $s[i] = s[j]$，如果能够找到两个索引不同但值相等的字符则满足 $s$ 与 $\textit{goal}$ 为亲密字符串；否则不为亲密字符串。
  2. 满足 $s[i] \neq s[j]$：满足 $s[i] = \textit{goal}[j], s[j] = \textit{goal}[i], s[i] \neq s[j]$ 的情况下，两个字符串 $s$ 与 $\textit{goal}$ 除了索引 $i,j$ 以外的字符都是匹配的。

**代码**

```Java [sol1-Java]
class Solution {
    public boolean buddyStrings(String s, String goal) {
        if (s.length() != goal.length()) {
            return false;
        }
        
        if (s.equals(goal)) {
            int[] count = new int[26];
            for (int i = 0; i < s.length(); i++) {
                count[s.charAt(i) - 'a']++;
                if (count[s.charAt(i) - 'a'] > 1) {
                    return true;
                }
            }
            return false;
        } else {
            int first = -1, second = -1;
            for (int i = 0; i < goal.length(); i++) {
                if (s.charAt(i) != goal.charAt(i)) {
                    if (first == -1)
                        first = i;
                    else if (second == -1)
                        second = i;
                    else
                        return false;
                }
            }

            return (second != -1 && s.charAt(first) == goal.charAt(second) &&
                    s.charAt(second) == goal.charAt(first));
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool buddyStrings(string s, string goal) {
        if (s.size() != goal.size()) {
            return false;
        }
        
        if (s == goal) {
            vector<int> count(26);
            for (int i = 0; i < s.size(); i++) {
                count[s[i] - 'a']++;
                if (count[s[i] - 'a'] > 1) {
                    return true;
                }
            }
            return false;
        } else {
            int first = -1, second = -1;
            for (int i = 0; i < s.size(); i++) {
                if (s[i] != goal[i]) {
                    if (first == -1)
                        first = i;
                    else if (second == -1)
                        second = i;
                    else
                        return false;
                }
            }

            return (second != -1 && s[first] == goal[second] && s[second] == goal[first]);
        }
    }
};
```

```C# [sol1-C#]
public class Solution {
    public bool BuddyStrings(string s, string goal) {
        if (s.Length != goal.Length) {
            return false;
        }
        
        if (s.Equals(goal)) {
            int[] count = new int[26];
            for (int i = 0; i < s.Length; i++) {
                count[s[i] - 'a']++;
                if (count[s[i] - 'a'] > 1) {
                    return true;
                }
            }
            return false;
        } else {
            int first = -1, second = -1;
            for (int i = 0; i < goal.Length; i++) {
                if (s[i] != goal[i]) {
                    if (first == -1)
                        first = i;
                    else if (second == -1)
                        second = i;
                    else
                        return false;
                }
            }

            return (second != -1 && s[first] == goal[second] && s[second] == goal[first]);
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def buddyStrings(self, s: str, goal: str) -> bool:
        if len(s) != len(goal):
            return False
        if s == goal:
            if len(set(s)) < len(goal): 
                return True
            else:
                return False
        diff = [(a, b) for a, b in zip(s, goal) if a != b]
        return len(diff) == 2 and diff[0][0] == diff[1][1] and diff[0][1] == diff[1][0]
```

```go [sol1-Golang]
func buddyStrings(s, goal string) bool {
    if len(s) != len(goal) {
        return false
    }

    if s == goal {
        seen := [26]bool{}
        for _, ch := range s {
            if seen[ch-'a'] {
                return true
            }
            seen[ch-'a'] = true
        }
        return false
    }

    first, second := -1, -1
    for i := range s {
        if s[i] != goal[i] {
            if first == -1 {
                first = i
            } else if second == -1 {
                second = i
            } else {
                return false
            }
        }
    }
    return second != -1 && s[first] == goal[second] && s[second] == goal[first]
}
```

```JavaScript [sol1-JavaScript]
var buddyStrings = function(s, goal) {
    if (s.length != goal.length) {
        return false;
    }
    
    if (s === goal) {
        const count = new Array(26).fill(0);
        for (let i = 0; i < s.length; i++) {
            count[s[i].charCodeAt() - 'a'.charCodeAt()]++;
            if (count[s[i].charCodeAt() - 'a'.charCodeAt()] > 1) {
                return true;
            }
        }
        return false;
    } else {
        let first = -1, second = -1;
        for (let i = 0; i < s.length; i++) {
            if (s[i] !== goal[i]) {
                if (first === -1)
                    first = i;
                else if (second === -1)
                    second = i;
                else
                    return false;
            }
        }

        return (second !== -1 && s[first] === goal[second] && s[second] === goal[first]);
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串的长度。我们至多遍历字符串两遍。

- 空间复杂度：$O(C)$。需要常数个空间保存字符串的字符统计次数，我们统计所有小写字母的个数，因此 $C = 26$。