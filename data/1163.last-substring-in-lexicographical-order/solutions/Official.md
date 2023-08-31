## [1163.按字典序排在最后的子串 中文官方题解](https://leetcode.cn/problems/last-substring-in-lexicographical-order/solutions/100000/an-zi-dian-xu-pai-zai-zui-hou-de-zi-chua-31yl)
#### 方法一：双指针

记字符串 $s$ 的长度为 $n$。首先并非所有的子字符串都需要被考虑到，只有后缀子字符串才可能是排在最后的子字符串。

> ***为什么只有后缀子字符串才可能是排在最后的子字符串？***
>
> 考虑一个非后缀子字符串 $s_1$，那么 $s_1$ 向后延伸得到的后缀子字符串 $s_2$ 比 $s_1$ 大，即 $s_2$ 排在 $s_1$ 后面。

我们用 $s_i$ ​表示从 $s[i]$ 开始的后缀子字符串，那么可以用指针 $i$ 来指向后缀子字符串 $s_i$。我们使用指针 $i$ 指向已知的最大后缀子字符串，$j$ 指向待比较的后缀子字符串，初始时有 $i=0$，$j=1$。一个简单的做法是从小到大枚举 $j$，如果 $s_i < s_j$，那么令 $i=j$，最终的后缀子字符串 $s_i$ 就是排在最后的子字符串。类似于字符串匹配，在 $s_i$ 与 $s_j$ 的比较过程中，一部分前缀是相等的，我们利用这一点跳过一些不需要进行比较的后缀子字符串。假设 $s_i$ 与 $s_j$ 在第 $k$ 个字符处不相等，即 $s_i[k] \ne s_j [k]$，那么有两种情况：

+ $s_i[k] < s_j[k]$

    + 当 $i+k \gt j$ 时

        对于 $m \in [1, k]$ 的后缀子字符串 $s_{i+m}$：

        + 如果 $m \in [k - (j - i) + 1, k]$，显然有 $s_{i + m} \lt s_{j+m}$，而 $j + m \gt i + k$，因此 $s_{i+m}$ 是不需要比较的。
        
        + 如果 $m \in [1, k - (j-i)]$，那么 $s_{i + m} \lt s_{j+m} = s_{i+m+j-i}$，又因为 $m \lt m+j-i \le k$，而 $s_{i+m}$ 右边的后缀子字符串不需要进行比较，因此 $s_{i+m}$ 是不需要进行比较的。

        综上，下一个需要进行比较的后缀子字符串为 $s_{i+k+1}$。

        ![2.jpeg](https://pic.leetcode.cn/1682247247-UltPaR-2.jpeg){:width=650}

    + 当 $i+k \le j$ 时

        下一个需要进行比较的后缀子字符串为 $s_{j+1}$。

+ $s_i[k] > s_j[k]$

    对于 $m \in [1, k]$ 的后缀子字符串 $s_{j+m}$：
    
    + 如果 $m \in [1, j-i]$，显然有 $s_{j+m} \lt s_{i+m} \lt s_i$。
    
    + 如果 $m \in [j-i+1, k]$，那么 $s_{j+m} \lt s_{i+m} = s_{j + m + i - j} \lt s_i$（因为 $1 \le m + i - j \lt m$，而 $s_{j+m}$ 左边的后缀子字符串小于 $s_i$，因此 $s_{j+m}$ 也小于 $s_i$）。
    
    综上，对于 $m \in [1, k]$，都有 $s_{j+m} \lt s_i$，所以下一个需要比较的后缀子字符串为 $s_{j+k+1}$。

    ![1.jpeg](https://pic.leetcode.cn/1682247209-pEmLZX-1.jpeg){:width=600}

> ***当 $s_j$ 为 $s_i$ 的前缀子字符串，即 $j+k=n$ 时，与情况 $s_i[k] > s_j[k]$ 类似***。

```C++ [sol1-C++]
class Solution {
public:
    string lastSubstring(string s) {
        int i = 0, j = 1, n = s.size();
        while (j < n) {
            int k = 0;
            while (j + k < n && s[i + k] == s[j + k]) {
                k++;
            }
            if (j + k < n && s[i + k] < s[j + k]) {
                int t = i;
                i = j;
                j = max(j + 1, t + k + 1);
            } else {
                j = j + k + 1;
            }
        }
        return s.substr(i, n - i);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String lastSubstring(String s) {
        int i = 0, j = 1, n = s.length();
        while (j < n) {
            int k = 0;
            while (j + k < n && s.charAt(i + k) == s.charAt(j + k)) {
                k++;
            }
            if (j + k < n && s.charAt(i + k) < s.charAt(j + k)) {
                int t = i;
                i = j;
                j = Math.max(j + 1, t + k + 1);
            } else {
                j = j + k + 1;
            }
        }
        return s.substring(i);
    }
}
```
```Python [sol1-Python3]
class Solution:
    def lastSubstring(self, s: str) -> str:
        i, j, n = 0, 1, len(s)
        while j < n:
            k = 0
            while j + k < n and s[i + k] == s[j + k]:
                k += 1
            if j + k < n and s[i + k] < s[j + k]:
                i, j = j, max(j + 1, i + k + 1)
            else:
                j = j + k + 1
        return s[i:]
```

```JavaScript [sol1-JavaScript]
var lastSubstring = function(s) {
    let i = 0, j = 1, n = s.length;
    while (j < n) {
        let k = 0;
        while (j + k < n && s[i + k] === s[j + k]) {
            k++;
        }
        if (j + k < n && s[i + k] < s[j + k]) {
            let t = i;
            i = j;
            j = Math.max(j + 1, t + k + 1);
        } else {
            j = j + k + 1;
        }
    }
    return s.substring(i, n);
};
```
```C# [sol1-C#]
public class Solution {
    public string LastSubstring(string s) {
        int i = 0, j = 1, n = s.Length;
        while (j < n) {
            int k = 0;
            while (j + k < n && s[i + k] == s[j + k]) {
                k++;
            }
            if (j + k < n && s[i + k] < s[j + k]) {
                int t = i;
                i = j;
                j = Math.Max(j + 1, t + k + 1);
            } else {
                j = j + k + 1;
            }
        }
        return s.Substring(i);
    }
}
```

```Golang [sol1-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func lastSubstring(s string) string {
    i, j, n := 0, 1, len(s)
    for j < n {
        k := 0
        for j + k < n && s[i + k] == s[j + k] {
            k++
        }
        if j + k < n && s[i + k] < s[j + k] {
            i, j = j, max(j + 1, i + k + 1)
        } else {
            j = j + k + 1
        }
    }
    return s[i:]
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

char * lastSubstring(char * s) {
    int i = 0, j = 1, n = strlen(s);
    while (j < n) {
        int k = 0;
        while (j + k < n && s[i + k] == s[j + k]) {
            k++;
        }
        if (j + k < n && s[i + k] < s[j + k]) {
            int t = i;
            i = j;
            j = MAX(j + 1, t + k + 1);
        } else {
            j = j + k + 1;
        }
    }
    char *res = (char *)calloc(n - i + 1, sizeof(char));
    strncpy(res, s + i, n - i);
    return res;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。每 $k$ 次比较，$i$ 与 $j$ 共同至少向右移动 $k$，因此总比较次数不超过 $2 \times n$ 次。

+ 空间复杂度：$O(1)$。返回值不计算空间复杂度。