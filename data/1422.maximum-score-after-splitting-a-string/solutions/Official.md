## [1422.分割字符串的最大得分 中文官方题解](https://leetcode.cn/problems/maximum-score-after-splitting-a-string/solutions/100000/fen-ge-zi-fu-chuan-de-zui-da-de-fen-by-l-7u5p)

#### 方法一：枚举每个分割点

用 $n$ 表示字符串 $s$ 的长度。对于每个 $1 \le i < n$，下标 $i$ 是一个分割点，将字符串 $s$ 分割成两个非空子字符串，左子字符串的下标范围是 $[0, i - 1]$，右子字符串的下标范围是 $[i, n - 1]$，分别计算左子字符串中的 $0$ 的个数和右子字符串中的 $1$ 的个数即可得到分割字符串的得分。遍历所有的分割点，即可得到分割字符串的最大得分。

```Python [sol1-Python3]
class Solution:
    def maxScore(self, s: str) -> int:
        return max(s[:i].count('0') + s[i:].count('1') for i in range(1, len(s)))
```

```Java [sol1-Java]
class Solution {
    public int maxScore(String s) {
        int ans = 0;
        int n = s.length();
        for (int i = 1; i < n; i++) {
            int score = 0;
            for (int j = 0; j < i; j++) {
                if (s.charAt(j) == '0') {
                    score++;
                }
            }
            for (int j = i; j < n; j++) {
                if (s.charAt(j) == '1') {
                    score++;
                }
            }
            ans = Math.max(ans, score);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxScore(string s) {
        int ans = 0;
        int n = s.Length;
        for (int i = 1; i < n; i++) {
            int score = 0;
            for (int j = 0; j < i; j++) {
                if (s[j] == '0') {
                    score++;
                }
            }
            for (int j = i; j < n; j++) {
                if (s[j] == '1') {
                    score++;
                }
            }
            ans = Math.Max(ans, score);
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxScore(string s) {
        int ans = 0;
        int n = s.size();
        for (int i = 1; i < n; i++) {
            int score = 0;
            for (int j = 0; j < i; j++) {
                if (s[j] == '0') {
                    score++;
                }
            }
            for (int j = i; j < n; j++) {
                if (s[j] == '1') {
                    score++;
                }
            }
            ans = max(ans, score);
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxScore(char * s){
    int ans = 0;
    int n = strlen(s);
    for (int i = 1; i < n; i++) {
        int score = 0;
        for (int j = 0; j < i; j++) {
            if (s[j] == '0') {
                score++;
            }
        }
        for (int j = i; j < n; j++) {
            if (s[j] == '1') {
                score++;
            }
        }
        ans = MAX(ans, score);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maxScore = function(s) {
    let ans = 0;
    const n = s.length;
    for (let i = 1; i < n; i++) {
        let score = 0;
        for (let j = 0; j < i; j++) {
            if (s[j] === '0') {
                score++;
            }
        }
        for (let j = i; j < n; j++) {
            if (s[j] === '1') {
                score++;
            }
        }
        ans = Math.max(ans, score);
    }
    return ans;
};
```

```go [sol1-Golang]
func maxScore(s string) (ans int) {
    for i := 1; i < len(s); i++ {
        ans = max(ans, strings.Count(s[:i], "0")+strings.Count(s[i:], "1"))
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历 $n - 1$ 个分割点，对于每个分割点需要 $O(n)$ 的时间遍历整个字符串计算分割字符串的得分，因此时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(1)$。

#### 方法二：两次遍历

方法一中，对于每个分割点遍历整个字符串计算分割字符串的得分。可以换一个角度思考，如果分割点从左到右移动一位，则位于原分割点处的字符从右子字符串中移除并添加到左子字符串中，根据该字符的值更新分割字符串的得分。

当 $1 \le i < n$ 时，分割点 $i$ 将字符串 $s$ 分割成两个非空子字符串，左子字符串的下标范围是 $[0, i - 1]$，右子字符串的下标范围是 $[i, n - 1]$。对于 $1 \le i < n - 1$，当分割点从 $i$ 移动到 $i + 1$ 时，位于下标 $i$ 处的字符 $s[i]$ 从右子字符串中移除并添加到左子字符串中，分割字符串的得分变化如下：

- 如果 $s[i] = 0$，则左子字符串的得分加 $1$，右子字符串的得分不变，因此分割字符串的得分加 $1$；

- 如果 $s[i] = 1$，则左子字符串的得分不变，右子字符串的得分减 $1$，因此分割字符串的得分减 $1$。

由于最左侧的分割点是 $i = 1$，因此首先计算 $i = 1$ 处的分割字符串的得分，然后从左到右依次遍历每个分割点，遍历过程中更新分割字符串的得分，遍历结束之后即可得到分割字符串的最大得分。

```Python [sol2-Python3]
class Solution:
    def maxScore(self, s: str) -> int:
        ans = score = (s[0] == '0') + s[1:].count('1')
        for c in s[1:-1]:
            score += 1 if c == '0' else -1
            ans = max(ans, score)
        return ans
```

```Java [sol2-Java]
class Solution {
    public int maxScore(String s) {
        int score = 0;
        int n = s.length();
        if (s.charAt(0) == '0') {
            score++;
        }
        for (int i = 1; i < n; i++) {
            if (s.charAt(i) == '1') {
                score++;
            }
        }
        int ans = score;
        for (int i = 1; i < n - 1; i++) {
            if (s.charAt(i) == '0') {
                score++;
            } else {
                score--;
            }
            ans = Math.max(ans, score);
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxScore(string s) {
        int score = 0;
        int n = s.Length;
        if (s[0] == '0') {
            score++;
        }
        for (int i = 1; i < n; i++) {
            if (s[i] == '1') {
                score++;
            }
        }
        int ans = score;
        for (int i = 1; i < n - 1; i++) {
            if (s[i] == '0') {
                score++;
            } else {
                score--;
            }
            ans = Math.Max(ans, score);
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxScore(string s) {
        int score = 0;
        int n = s.size();
        if (s[0] == '0') {
            score++;
        }
        for (int i = 1; i < n; i++) {
            if (s[i] == '1') {
                score++;
            }
        }
        int ans = score;
        for (int i = 1; i < n - 1; i++) {
            if (s[i] == '0') {
                score++;
            } else {
                score--;
            }
            ans = max(ans, score);
        }
        return ans;
    }
};
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxScore(char * s){
    int score = 0;
    int n = strlen(s);
    if (s[0] == '0') {
        score++;
    }
    for (int i = 1; i < n; i++) {
        if (s[i] == '1') {
            score++;
        }
    }
    int ans = score;
    for (int i = 1; i < n - 1; i++) {
        if (s[i] == '0') {
            score++;
        } else {
            score--;
        }
        ans = MAX(ans, score);
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var maxScore = function(s) {
    let score = 0;
    const n = s.length;
    if (s[0] === '0') {
        score++;
    }
    for (let i = 1; i < n; i++) {
        if (s[i] === '1') {
            score++;
        }
    }
    let ans = score;
    for (let i = 1; i < n - 1; i++) {
        if (s[i] == '0') {
            score++;
        } else {
            score--;
        }
        ans = Math.max(ans, score);
    }
    return ans;
};
```

```go [sol2-Golang]
func maxScore(s string) int {
    score := int('1'-s[0]) + strings.Count(s[1:], "1")
    ans := score
    for _, c := range s[1 : len(s)-1] {
        if c == '0' {
            score++
        } else {
            score--
        }
        ans = max(ans, score)
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历字符串两次。

- 空间复杂度：$O(1)$。