## [2399.检查相同字母间的距离 中文官方题解](https://leetcode.cn/problems/check-distances-between-same-letters/solutions/100000/jian-cha-xiang-tong-zi-mu-jian-de-ju-chi-gxqg)

#### 方法一：枚举

**思路与算法**

直接枚举所有相同的字符对 $(s[i],s[j])$，且满足 $s[i]=s[j],i<j$，此时两个相同字符之间的字母数量为 $j - i - 1$，然后检测该字符的匀整性。

假设字符 $s[i]$ 在字符集中的顺序为 $\textit{idx}$，此时只需要判断 $j - i - 1$ 是否等于给定的 $\textit{distance}[\textit{idx}]$ 即可。

按照上述方法检测所有相同的字符对，如果所有的字符都满足匀整性，则返回 $\text{true}$，否则返回 $\textit{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkDistances(string s, vector<int>& distance) {
        int n = s.size();
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (s[i] == s[j] && distance[s[i] - 'a'] != j - i - 1) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkDistances(String s, int[] distance) {
        int n = s.length();
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (s.charAt(i) == s.charAt(j) && distance[s.charAt(i) - 'a'] != j - i - 1) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def checkDistances(self, s: str, distance: List[int]) -> bool:
        n = len(s)
        for i in range(n):
            for j in range(i + 1, n):
                if s[i] == s[j] and distance[ord(s[i]) - ord('a')] != j - i - 1:
                    return False
        return True
```

```C# [sol1-C#]
public class Solution {
    public bool CheckDistances(string s, int[] distance) {
        int n = s.Length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (s[i] == s[j] && distance[s[i] - 'a'] != j - i - 1) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool checkDistances(char * s, int* distance, int distanceSize) {
    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        for(int j = i + 1; j < n; j++) {
            if (s[i] == s[j] && distance[s[i] - 'a'] != j - i - 1) {
                return false;
            }
        }
    }
    return true;
}
```

```Go [sol1-Go]
func checkDistances(s string, distance []int) bool {
    n := len(s)
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            if s[i] == s[j] && distance[s[i] - 'a'] != j - i - 1 {
                return false
            }
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var checkDistances = function(s, distance) {
    let n = s.length;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            if (s[i] == s[j] && distance[s.charCodeAt(i) - 'a'.charCodeAt(0)] != j - i - 1) {
                return false;
            }
        }
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示字符串的长度。我们枚举所有可能相等的字符对，一共最多有 $n^2$ 个不同的字符对，因此时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(1)$。

#### 方法二：模拟

**思路与算法**

由于题目中每个字母恰好出现两次，因此我们使用数组 $\textit{firstIndex}$ 记录每个字母从左到右第一次出现的位置，当该字母第二次出现时，减去第一次出现的位置即可得到两个相同字母之间的字母数量。初始化 $\textit{firstIndex}$ 中的元素全为 $0$，为了方便计算，记录字符 $s[i]$ 出现的位置为 $i + 1$。按照上述检测所有的字符，如果所有的字符都满足匀整性，则返回 $\text{true}$，否则返回 $\textit{false}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool checkDistances(string s, vector<int>& distance) {
        vector<int> firstIndex(26);
        for (int i = 0; i < s.size(); i++) {
            int idx = s[i] - 'a';
            if (firstIndex[idx] && i - firstIndex[idx] != distance[idx]) {
                return false;
            }
            firstIndex[idx] = i + 1;
        }
        return true;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean checkDistances(String s, int[] distance) {
        int[] firstIndex = new int[26];
        for (int i = 0; i < s.length(); i++) {
            int idx = s.charAt(i) - 'a';
            if (firstIndex[idx] != 0 && i - firstIndex[idx] != distance[idx]) {
                return false;
            }
            firstIndex[idx] = i + 1;
        }
        return true;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def checkDistances(self, s: str, distance: List[int]) -> bool:
        n = len(s)
        firstIndex = [0] * 26;
        for i in range(n):
            idx = ord(s[i]) - ord('a');
            if firstIndex[idx] and i - firstIndex[idx] != distance[idx]:
                return False
            firstIndex[idx] = i + 1
        return True
```

```C# [sol2-C#]
public class Solution {
    public bool CheckDistances(string s, int[] distance) {
        int[] firstIndex = new int[26];
        for (int i = 0; i < s.Length; i++) {
            int idx = s[i] - 'a';
            if (firstIndex[idx] != 0 && i - firstIndex[idx] != distance[idx]) {
                return false;
            }
            firstIndex[idx] = i + 1;
        }
        return true;
    }
}
```

```C [sol2-C]
bool checkDistances(char * s, int* distance, int distanceSize) {
    int n = strlen(s);
    int firstIndex[26];
    memset(firstIndex, 0, sizeof(firstIndex));
    for (int i = 0; i < n; i++) {
        int idx = s[i] - 'a';
        if (firstIndex[idx] && i - firstIndex[idx] != distance[idx]) {
            return false;
        }
        firstIndex[idx] = i + 1;
    }
    return true;
}
```

```Go [sol2-Go]
func checkDistances(s string, distance []int) bool {
    firstIndex := make([]int, 26)
    for i := 0; i < len(s); i++ {
        idx := s[i] - 'a'
        if firstIndex[idx] != 0 && i - firstIndex[idx] != distance[idx] {
            return false
        }
        firstIndex[idx] = i + 1
    }
    return true
}
```

```JavaScript [sol2-JavaScript]
var checkDistances = function(s, distance) {
    let firstIndex = new Array(26).fill(0);
    for (let i = 0; i < s.length; i++) {
        let idx = s.charCodeAt(i) - 'a'.charCodeAt(0);
        if (firstIndex[idx] != 0 && i - firstIndex[idx] != distance[idx]) {
            return false;
        }
        firstIndex[idx] = i + 1;
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。只需要遍历字符串一次即可，总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(|\Sigma|)$，其中 $|\Sigma|$ 表示字符集的大小，在本题中 $|\Sigma| = 26$。只需要记录每个字母第一次出现的位置，需要的空间为 $O(|\Sigma|)$。