## [1790.仅执行一次字符串交换能否使两个字符串相等 中文官方题解](https://leetcode.cn/problems/check-if-one-string-swap-can-make-strings-equal/solutions/100000/jin-zhi-xing-yi-ci-zi-fu-chuan-jiao-huan-j8si)
#### 方法一：计数统计

题目要求其中一个字符串执行最多一次字符交换使得两个字符串相等，意味着两个字符串中最多只存在两个位置 $i,j$ 处字符不相等，此时我们交换 $i,j$ 处字符可使其相等。设两个字符串分别为 $s_1,s_2$：
+ 如果两个字符串 $s_1,s_2$ 相等，则不需要进行交换即可满足相等；
+ 如果两个字符串 $s_1,s_2$ 不相等，字符串一定存在两个位置 $i,j$ 处的字符不相等，需要交换 $i,j$ 处字符使其相等，此时一定满足 $s_1[i] = s_2[j], s_1[j] = s_2[i]$；如果两个字符中只存在一个或大于两个位置的字符不相等，则此时无法通过一次交换使其相等；

```Python [sol1-Python3]
class Solution:
    def areAlmostEqual(self, s1: str, s2: str) -> bool:
        i = j = -1
        for idx, (x, y) in enumerate(zip(s1, s2)):
            if x != y:
                if i < 0:
                    i = idx
                elif j < 0:
                    j = idx
                else:
                    return False
        return i < 0 or j >= 0 and s1[i] == s2[j] and s1[j] == s2[i]
```

```C++ [sol1-C++]
class Solution {
public:
    bool areAlmostEqual(string s1, string s2) {
        int n = s1.size();
        vector<int> diff;
        for (int i = 0; i < n; ++i) {
            if (s1[i] != s2[i]) {
                if (diff.size() >= 2) {
                    return false;
                }
                diff.emplace_back(i);
            }
        }
        if (diff.size() == 0) {
            return true;
        }
        if (diff.size() != 2) {
            return false;
        }
        return s1[diff[0]] == s2[diff[1]] && s1[diff[1]] == s2[diff[0]];
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean areAlmostEqual(String s1, String s2) {
        int n = s1.length();
        List<Integer> diff = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (s1.charAt(i) != s2.charAt(i)) {
                if (diff.size() >= 2) {
                    return false;
                }
                diff.add(i);
            }
        }
        if (diff.isEmpty()) {
            return true;
        }
        if (diff.size() != 2) {
            return false;
        }
        return s1.charAt(diff.get(0)) == s2.charAt(diff.get(1)) && s1.charAt(diff.get(1)) == s2.charAt(diff.get(0));
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool AreAlmostEqual(string s1, string s2) {
        int n = s1.Length;
        IList<int> diff = new List<int>();
        for (int i = 0; i < n; ++i) {
            if (s1[i] != s2[i]) {
                if (diff.Count >= 2) {
                    return false;
                }
                diff.Add(i);
            }
        }
        if (diff.Count == 0) {
            return true;
        }
        if (diff.Count != 2) {
            return false;
        }
        return s1[diff[0]] == s2[diff[1]] && s1[diff[1]] == s2[diff[0]];
    }
}
```

```C [sol1-C]
bool areAlmostEqual(char * s1, char * s2){
    int n = strlen(s1), pos = 0;
    int diff[2];
    for (int i = 0; i < n; ++i) {
        if (s1[i] != s2[i]) {
            if (pos >= 2) {
                return false;
            }
            diff[pos++] = i;
        }
    }
    if (pos == 0) {
        return true;
    }
    if (pos != 2) {
        return false;
    }
    return s1[diff[0]] == s2[diff[1]] && s1[diff[1]] == s2[diff[0]];
}
```

```JavaScript [sol1-JavaScript]
var areAlmostEqual = function(s1, s2) {
    const n = s1.length;
    const diff = [];
    for (let i = 0; i < n; ++i) {
        if (s1[i] !== s2[i]) {
            if (diff.length >= 2) {
                return false;
            }
            diff.push(i);
        }
    }
    if (diff.length === 0) {
        return true;
    }
    if (diff.length !== 2) {
        return false;
    }
    return s1[diff[0]] === s2[diff[1]] && s1[diff[1]] === s2[diff[0]];
};
```

```go [sol1-Golang]
func areAlmostEqual(s1, s2 string) bool {
    i, j := -1, -1
    for idx := range s1 {
        if s1[idx] != s2[idx] {
            if i < 0 {
                i = idx
            } else if j < 0 {
                j = idx
            } else {
                return false
            }
        }
    }
    return i < 0 || j >= 0 && s1[i] == s2[j] && s1[j] == s2[i]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(C)$。由于两个字符串中字符不同的数目大于 $2$ 即可返回，因此最多只需要保存 $C = 2$ 个不同位置的索引即可。