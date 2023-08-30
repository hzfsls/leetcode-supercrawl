#### 方法一：一次遍历

可奖励的出勤记录要求缺勤次数少于 $2$ 和连续迟到次数少于 $3$。判断出勤记录是否可奖励，只需要遍历出勤记录，判断这两个条件是否同时满足即可。

遍历过程中，记录缺勤次数和连续迟到次数，根据遍历到的字符更新缺勤次数和连续迟到次数：

- 如果遇到 $\text{`A'}$，即缺勤，则将缺勤次数加 $1$，否则缺勤次数不变；

- 如果遇到 $\text{`L'}$，即迟到，则将连续迟到次数加 $1$，否则将连续迟到次数清零。

如果在更新缺勤次数和连续迟到次数之后，出现缺勤次数大于或等于 $2$ 或者连续迟到次数大于或等于 $3$，则该出勤记录不满足可奖励的要求，返回 $\text{false}$。如果遍历结束时未出现出勤记录不满足可奖励的要求的情况，则返回 $\text{true}$。

```Java [sol1-Java]
class Solution {
    public boolean checkRecord(String s) {
        int absents = 0, lates = 0;
        int n = s.length();
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (c == 'A') {
                absents++;
                if (absents >= 2) {
                    return false;
                }
            }
            if (c == 'L') {
                lates++;
                if (lates >= 3) {
                    return false;
                }
            } else {
                lates = 0;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckRecord(string s) {
        int absents = 0, lates = 0;
        int n = s.Length;
        for (int i = 0; i < n; i++) {
            char c = s[i];
            if (c == 'A') {
                absents++;
                if (absents >= 2) {
                    return false;
                }
            }
            if (c == 'L') {
                lates++;
                if (lates >= 3) {
                    return false;
                }
            } else {
                lates = 0;
            }
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var checkRecord = function(s) {
    let absents = 0, lates = 0;
    const n = s.length;
    for (let i = 0; i < n; i++) {
        const c = s[i];
        if (c === 'A') {
            absents++;
            if (absents >= 2) {
                return false;
            }
        }
        if (c === 'L') {
            lates++;
            if (lates >= 3) {
                return false;
            }
        } else {
            lates = 0;
        }
    }
    return true;
};
```

```Python [sol1-Python3]
class Solution:
    def checkRecord(self, s: str) -> bool:
        absents = lates = 0
        for i, c in enumerate(s):
            if c == "A":
                absents += 1
                if absents >= 2:
                    return False
            if c == "L":
                lates += 1
                if lates >= 3:
                    return False
            else:
                lates = 0
        
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkRecord(string s) {
        int absents = 0, lates = 0;
        for (auto &ch : s) {
            if (ch == 'A') {
                absents++;
                if (absents >= 2) {
                    return false;
                }
            }
            if (ch == 'L') {
                lates++;
                if (lates >= 3) {
                    return false;
                }
            } else {
                lates = 0;
            }
        }
        return true;
    }
};
```

```C [sol1-C]
bool checkRecord(char* s) {
    int absents = 0, lates = 0;
    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        char c = s[i];
        if (c == 'A') {
            absents++;
            if (absents >= 2) {
                return false;
            }
        }
        if (c == 'L') {
            lates++;
            if (lates >= 3) {
                return false;
            }
        } else {
            lates = 0;
        }
    }
    return true;
}
```

```go [sol1-Golang]
func checkRecord(s string) bool {
    absents, lates := 0, 0
    for _, ch := range s {
        if ch == 'A' {
            absents++
            if absents >= 2 {
                return false
            }
        }
        if ch == 'L' {
            lates++
            if lates >= 3 {
                return false
            }
        } else {
            lates = 0
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历字符串 $s$ 一次。

- 空间复杂度：$O(1)$。