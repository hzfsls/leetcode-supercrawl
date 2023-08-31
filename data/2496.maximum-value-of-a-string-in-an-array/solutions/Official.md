## [2496.数组中字符串的最大值 中文官方题解](https://leetcode.cn/problems/maximum-value-of-a-string-in-an-array/solutions/100000/shu-zu-zhong-zi-fu-chuan-de-zui-da-zhi-b-erig)

#### 方法一：字符串遍历

遍历输入数组中的字符串，判断字符串每一个字符是否都是数字。如果字符串只包含数字，那么转换该字符串为十进制下的所表示的数字，否则值为字符串的长度。

最后返回字符串数组里的最大值。

```C++ [sol1-C++]
class Solution {
public:
    int maximumValue(vector<string>& strs) {
        int res = 0;
        for (auto& s : strs) {
            bool isDigits = true;
            for (char& c : s) {
                isDigits &= isdigit(c);
            }
            res = max(res, isDigits ? stoi(s) : (int)s.size());
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumValue(String[] strs) {
        int res = 0;
        for (String s : strs) {
            boolean isDigits = true;
            int n = s.length();
            for (int i = 0; i < n; ++i) {
                isDigits &= Character.isDigit(s.charAt(i));
            }
            res = Math.max(res, isDigits ? Integer.parseInt(s) : n);
        }
        return res;
    }
}

```

```C# [sol1-C#]
public class Solution {
    public int MaximumValue(string[] strs) {
        int res = 0;
        foreach (string s in strs) {
            bool isDigits = true;
            foreach (char c in s) {
                isDigits &= char.IsDigit(c);
            }
            res = Math.Max(res, isDigits? int.Parse(s) : s.Length);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maximumValue(self, strs: List[str]) -> int:
        res = 0
        for s in strs:
            is_digits = all(c.isdigit() for c in s)
            res = max(res, int(s) if is_digits else len(s))
        return res
```

```JavaScript [sol1-JavaScript]
var maximumValue = function(strs) {
    let res = 0;
    for (const s of strs) {
        let isDigits = true;
        for (const c of s) {
            isDigits &= c >= '0' && c <= '9';
        }
        res = Math.max(res, isDigits ? Number(s) : s.length);
    }
    return res;
};
```

```Golang [sol1-Golang]
func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}

func maximumValue(strs []string) int {
    res := 0
    for _, s := range strs {
        isDigits := true
        for _, c := range s {
            isDigits = isDigits && (c >= '0' && c <= '9')
        }
        if isDigits {
            v, _ := strconv.Atoi(s)
            res = max(res, v)
        } else {
            res = max(res, len(s))
        }
    }
    return res
}
```

```C [sol1-C]
int maximumValue(char ** strs, int strsSize){
    int res = 0;
    for (int i = 0; i < strsSize; i++) {
        bool isDigits = true;
        for (int j = 0; j < strlen(strs[i]); j++) {
            isDigits &= strs[i][j] >= '0' && strs[i][j] <= '9';
        }
        if (isDigits) {
            res = fmax(res, atoi(strs[i]));
        } else {
            res = fmax(res, strlen(strs[i]));
        }
    }
    return res;
}
```

**复杂度分析**

+ 时间复杂度：$O(nm)$，其中 $n$ 是数组 $\textit{strs}$ 的长度， 其中 $m$ 是字符串的长度。

+ 空间复杂度：$O(1)$，不需要额外的空间。