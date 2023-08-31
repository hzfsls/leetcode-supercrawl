## [165.比较版本号 中文官方题解](https://leetcode.cn/problems/compare-version-numbers/solutions/100000/bi-jiao-ban-ben-hao-by-leetcode-solution-k6wi)
#### 方法一：字符串分割

我们可以将版本号按照点号分割成修订号，然后从左到右比较两个版本号的相同下标的修订号。在比较修订号时，需要将字符串转换成整数进行比较。注意根据题目要求，如果版本号不存在某个下标处的修订号，则该修订号视为 $0$。

```Python [sol1-Python3]
class Solution:
    def compareVersion(self, version1: str, version2: str) -> int:
        for v1, v2 in zip_longest(version1.split('.'), version2.split('.'), fillvalue=0):
            x, y = int(v1), int(v2)
            if x != y:
                return 1 if x > y else -1
        return 0
```

```Java [sol1-Java]
class Solution {
    public int compareVersion(String version1, String version2) {
        String[] v1 = version1.split("\\.");
        String[] v2 = version2.split("\\.");
        for (int i = 0; i < v1.length || i < v2.length; ++i) {
            int x = 0, y = 0;
            if (i < v1.length) {
                x = Integer.parseInt(v1[i]);
            }
            if (i < v2.length) {
                y = Integer.parseInt(v2[i]);
            }
            if (x > y) {
                return 1;
            }
            if (x < y) {
                return -1;
            }
        }
        return 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CompareVersion(string version1, string version2) {
        string[] v1 = version1.Split('.');
        string[] v2 = version2.Split('.');
        for (int i = 0; i < v1.Length || i < v2.Length; ++i) {
            int x = 0, y = 0;
            if (i < v1.Length) {
                x = int.Parse(v1[i]);
            }
            if (i < v2.Length) {
                y = int.Parse(v2[i]);
            }
            if (x > y) {
                return 1;
            }
            if (x < y) {
                return -1;
            }
        }
        return 0;
    }
}
```

```go [sol1-Golang]
func compareVersion(version1, version2 string) int {
    v1 := strings.Split(version1, ".")
    v2 := strings.Split(version2, ".")
    for i := 0; i < len(v1) || i < len(v2); i++ {
        x, y := 0, 0
        if i < len(v1) {
            x, _ = strconv.Atoi(v1[i])
        }
        if i < len(v2) {
            y, _ = strconv.Atoi(v2[i])
        }
        if x > y {
            return 1
        }
        if x < y {
            return -1
        }
    }
    return 0
}
```

```JavaScript [sol1-JavaScript]
var compareVersion = function(version1, version2) {
    const v1 = version1.split('.');
    const v2 = version2.split('.');
    for (let i = 0; i < v1.length || i < v2.length; ++i) {
        let x = 0, y = 0;
        if (i < v1.length) {
            x = parseInt(v1[i]);
        }
        if (i < v2.length) {
            y = parseInt(v2[i]);
        }
        if (x > y) {
            return 1;
        }
        if (x < y) {
            return -1;
        }
    }
    return 0;
};
```

- 时间复杂度：$O(n+m)$（或 $O(\max(n,m))$，这是等价的），其中 $n$ 是字符串 $\textit{version1}$ 的长度，$m$ 是字符串 $\textit{version2}$ 的长度。

- 空间复杂度：$O(n+m)$，我们需要 $O(n+m)$ 的空间存储分割后的修订号列表。

#### 方法二：双指针

方法一需要存储分割后的修订号，为了优化空间复杂度，我们可以在分割版本号的同时解析出修订号进行比较。

```Python [sol2-Python3]
class Solution:
    def compareVersion(self, version1: str, version2: str) -> int:
        n, m = len(version1), len(version2)
        i, j = 0, 0
        while i < n or j < m:
            x = 0
            while i < n and version1[i] != '.':
                x = x * 10 + ord(version1[i]) - ord('0')
                i += 1
            i += 1  # 跳过点号
            y = 0
            while j < m and version2[j] != '.':
                y = y * 10 + ord(version2[j]) - ord('0')
                j += 1
            j += 1  # 跳过点号
            if x != y:
                return 1 if x > y else -1
        return 0
```

```C++ [sol2-C++]
class Solution {
public:
    int compareVersion(string version1, string version2) {
        int n = version1.length(), m = version2.length();
        int i = 0, j = 0;
        while (i < n || j < m) {
            int x = 0;
            for (; i < n && version1[i] != '.'; ++i) {
                x = x * 10 + version1[i] - '0';
            }
            ++i; // 跳过点号
            int y = 0;
            for (; j < m && version2[j] != '.'; ++j) {
                y = y * 10 + version2[j] - '0';
            }
            ++j; // 跳过点号
            if (x != y) {
                return x > y ? 1 : -1;
            }
        }
        return 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int compareVersion(String version1, String version2) {
        int n = version1.length(), m = version2.length();
        int i = 0, j = 0;
        while (i < n || j < m) {
            int x = 0;
            for (; i < n && version1.charAt(i) != '.'; ++i) {
                x = x * 10 + version1.charAt(i) - '0';
            }
            ++i; // 跳过点号
            int y = 0;
            for (; j < m && version2.charAt(j) != '.'; ++j) {
                y = y * 10 + version2.charAt(j) - '0';
            }
            ++j; // 跳过点号
            if (x != y) {
                return x > y ? 1 : -1;
            }
        }
        return 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CompareVersion(string version1, string version2) {
        int n = version1.Length, m = version2.Length;
        int i = 0, j = 0;
        while (i < n || j < m) {
            int x = 0;
            for (; i < n && version1[i] != '.'; ++i) {
                x = x * 10 + version1[i] - '0';
            }
            ++i; // 跳过点号
            int y = 0;
            for (; j < m && version2[j] != '.'; ++j) {
                y = y * 10 + version2[j] - '0';
            }
            ++j; // 跳过点号
            if (x != y) {
                return x > y ? 1 : -1;
            }
        }
        return 0;
    }
}
```

```go [sol2-Golang]
func compareVersion(version1, version2 string) int {
    n, m := len(version1), len(version2)
    i, j := 0, 0
    for i < n || j < m {
        x := 0
        for ; i < n && version1[i] != '.'; i++ {
            x = x*10 + int(version1[i]-'0')
        }
        i++ // 跳过点号
        y := 0
        for ; j < m && version2[j] != '.'; j++ {
            y = y*10 + int(version2[j]-'0')
        }
        j++ // 跳过点号
        if x > y {
            return 1
        }
        if x < y {
            return -1
        }
    }
    return 0
}
```

```JavaScript [sol2-JavaScript]
var compareVersion = function(version1, version2) {
    const n = version1.length, m = version2.length;
    let i = 0, j = 0;
    while (i < n || j < m) {
        let x = 0;
        for (; i < n && version1[i] !== '.'; ++i) {
            x = x * 10 + version1[i].charCodeAt() - '0'.charCodeAt();
        }
        ++i; // 跳过点号
        let y = 0;
        for (; j < m && version2.charAt(j) !== '.'; ++j) {
            y = y * 10 + version2[j].charCodeAt() - '0'.charCodeAt();
        }
        ++j; // 跳过点号
        if (x !== y) {
            return x > y ? 1 : -1;
        }
    }
    return 0;
};
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是字符串 $\textit{version1}$ 的长度，$m$ 是字符串 $\textit{version2}$ 的长度。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。