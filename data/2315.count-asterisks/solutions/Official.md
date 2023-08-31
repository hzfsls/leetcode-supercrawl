## [2315.统计星号 中文官方题解](https://leetcode.cn/problems/count-asterisks/solutions/100000/tong-ji-xing-hao-by-leetcode-solution-rwbs)

#### 方法一：模拟

**思路**

根据题意，需要统计第偶数个竖线之后，第奇数个竖线之前，以及第一个竖线之前和最后一个竖线之后的星号。可以用一个布尔值 $\textit{valid}$ 表示接下去遇到的星号是否要纳入统计，初始化为 $\text{true}$，并且每次遇到竖线都要取反，最后返回符合条件的星号数量即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countAsterisks(self, s: str) -> int:
        valid = True
        res = 0
        for c in s:
            if c == '|':
                valid = not valid
            elif c == '*' and valid:
                res += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int countAsterisks(String s) {
        boolean valid = true;
        int res = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '|') {
                valid = !valid;
            } else if (c == '*' && valid) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountAsterisks(string s) {
        bool valid = true;
        int res = 0;
        foreach (char c in s) {
            if (c == '|') {
                valid = !valid;
            } else if (c == '*' && valid) {
                res++;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countAsterisks(string s) {
        bool valid = true;
        int res = 0;
        for (int i = 0; i < s.size(); i++) {
            char c = s[i];
            if (c == '|') {
                valid = !valid;
            } else if (c == '*' && valid) {
                res++;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int countAsterisks(char * s) {
    bool valid = true;
    int res = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        if (c == '|') {
            valid = !valid;
        } else if (c == '*' && valid) {
            res++;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var countAsterisks = function(s) {
    let valid = true;
    let res = 0;
    for (let i = 0; i < s.length; i++) {
        let c = s[i];
        if (c === '|') {
            valid = !valid;
        } else if (c === '*' && valid) {
            res++;
        }
    }
    return res;
};
```

```go [sol1-Golang]
func countAsterisks(s string) (res int) {
    valid := true
    for _, c := range s {
        if c == '|' {
            valid = !valid
        } else if c == '*' && valid {
            res++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。只需要遍历 $s$ 一遍。

- 空间复杂度：$O(1)$。仅需要常数空间。