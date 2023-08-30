#### 方法一：模拟

**思路**

首先，如果 $s$ 和 $\textit{goal}$ 的长度不一样，那么无论怎么旋转，$s$ 都不能得到 $\textit{goal}$，返回 $\text{false}$。在长度一样（都为 $n$）的前提下，假设 $s$ 旋转 $i$ 位，则与 $\textit{goal}$ 中的某一位字符 $\textit{goal}[j]$ 对应的原 $s$ 中的字符应该为 $s[(i+j) \bmod n]$。在固定 $i$ 的情况下，遍历所有 $j$，若对应字符都相同，则返回 $\text{true}$。否则，继续遍历其他候选的 $i$。若所有的 $i$ 都不能使 $s$ 变成 $\textit{goal}$，则返回 $\text{false}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def rotateString(self, s: str, goal: str) -> bool:
        m, n = len(s), len(goal)
        if m != n:
            return False
        for i in range(n):
            for j in range(n):
                if s[(i + j) % n] != goal[j]:
                    break
            else:
                return True
        return False
```

```Java [sol1-Java]
class Solution {
    public boolean rotateString(String s, String goal) {
        int m = s.length(), n = goal.length();
        if (m != n) {
            return false;
        }
        for (int i = 0; i < n; i++) {
            boolean flag = true;
            for (int j = 0; j < n; j++) {
                if (s.charAt((i + j) % n) != goal.charAt(j)) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                return true;
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool RotateString(string s, string goal) {
        int m = s.Length, n = goal.Length;
        if (m != n) {
            return false;
        }
        for (int i = 0; i < n; i++) {
            bool flag = true;
            for (int j = 0; j < n; j++) {
                if (s[(i + j) % n] != goal[j]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                return true;
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool rotateString(string s, string goal) {
        int m = s.size(), n = goal.size();
        if (m != n) {
            return false;
        }
        for (int i = 0; i < n; i++) {
            bool flag = true;
            for (int j = 0; j < n; j++) {
                if (s[(i + j) % n] != goal[j]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                return true;
            }
        }
        return false;
    }
};
```

```C [sol1-C]
bool rotateString(char * s, char * goal){
    int m = strlen(s), n = strlen(goal);
    if (m != n) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        bool flag = true;
        for (int j = 0; j < n; j++) {
            if (s[(i + j) % n] != goal[j]) {
                flag = false;
                break;
            }
        }
        if (flag) {
            return true;
        }
    }
    return false;
}
```

```JavaScript [sol1-JavaScript]
var rotateString = function(s, goal) {
    const m = s.length, n = goal.length;
    if (m !== n) {
        return false;
    }
    for (let i = 0; i < n; i++) {
        let flag = true;
        for (let j = 0; j < n; j++) {
            if (s[(i + j) % n] !== goal[j]) {
                flag = false;
                break;
            }
        }
        if (flag) {
            return true;
        }
    }
    return false;
};
```

```go [sol1-Golang]
func rotateString(s, goal string) bool {
    n := len(s)
    if n != len(goal) {
        return false
    }
next:
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            if s[(i+j)%n] != goal[j] {
                continue next
            }
        }
        return true
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。我们需要双重循环来判断。

- 空间复杂度：$O(1)$。仅使用常数空间。

#### 方法二：搜索子字符串

**思路**

首先，如果 $s$ 和 $\textit{goal}$ 的长度不一样，那么无论怎么旋转，$s$ 都不能得到 $\textit{goal}$，返回 $\text{false}$。字符串 $s + s$ 包含了所有 $s$ 可以通过旋转操作得到的字符串，只需要检查 $\textit{goal}$ 是否为 $s + s$ 的子字符串即可。具体可以参考「[28. 实现 strStr() 的官方题解](https://leetcode-cn.com/problems/implement-strstr/solution/shi-xian-strstr-by-leetcode-solution-ds6y/)」的实现代码，本题解中采用直接调用库函数的方法。

**代码**

```Python [sol2-Python3]
class Solution:
    def rotateString(self, s: str, goal: str) -> bool:
        return len(s) == len(goal) and goal in s + s
```

```Java [sol2-Java]
class Solution {
    public boolean rotateString(String s, String goal) {
        return s.length() == goal.length() && (s + s).contains(goal);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool RotateString(string s, string goal) {
        return s.Length == goal.Length && (s + s).Contains(goal);
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool rotateString(string s, string goal) {
        return s.size() == goal.size() && (s + s).find(goal) != string::npos;
    }
};
```

```C [sol2-C]
bool rotateString(char * s, char * goal){
    int m = strlen(s), n = strlen(goal);
    if (m != n) {
        return false;
    }
    char * str = (char *)malloc(sizeof(char) * (m + n + 1));
    sprintf(str, "%s%s", goal, goal);
    return strstr(str, s) != NULL;
}
```

```JavaScript [sol2-JavaScript]
var rotateString = function(s, goal) {
    return s.length === goal.length && (s + s).indexOf(goal) !== -1;
};
```

```go [sol2-Golang]
func rotateString(s, goal string) bool {
    return len(s) == len(goal) && strings.Contains(s+s, goal)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。$\text{KMP}$ 算法搜索子字符串的时间复杂度为 $O(n)$，其他搜索子字符串的方法会略有差异。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。$\text{KMP}$ 算法搜索子字符串的空间复杂度为 $O(n)$，其他搜索子字符串的方法会略有差异。