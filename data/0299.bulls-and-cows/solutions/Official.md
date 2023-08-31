## [299.猜数字游戏 中文官方题解](https://leetcode.cn/problems/bulls-and-cows/solutions/100000/cai-shu-zi-you-xi-by-leetcode-solution-q9lz)

#### 方法一：遍历

根据题意，对于公牛，需要满足数字和确切位置都猜对。我们可以遍历 $\textit{secret}$ 和 $\textit{guess}$，统计满足 $\textit{secret}[i]=\textit{guess}[i]$ 的下标个数，即为公牛的个数。

对于奶牛，需要满足数字猜对但是位置不对。我们可以在 $\textit{secret}[i]\ne\textit{guess}[i]$ 时，分别统计 $\textit{secret}$ 和 $\textit{guess}$ 的各个字符的出现次数，记在两个长度为 $10$ 的数组中。根据题目所述的「这次猜测中有多少位非公牛数字可以通过重新排列转换成公牛数字」，由于多余的数字无法匹配，对于 $\texttt{0}$ 到 $\texttt{9}$ 的每位数字，应取其在 $\textit{secret}$ 和 $\textit{guess}$ 中的出现次数的最小值。将每位数字出现次数的最小值累加，即为奶牛的个数。

```Python [sol1-Python3]
class Solution:
    def getHint(self, secret: str, guess: str) -> str:
        bulls = 0
        cntS, cntG = [0] * 10, [0] * 10
        for s, g in zip(secret, guess):
            if s == g:
                bulls += 1
            else:
                cntS[int(s)] += 1
                cntG[int(g)] += 1
        cows = sum(min(s, g) for s, g in zip(cntS, cntG))
        return f'{bulls}A{cows}B'
```

```C++ [sol1-C++]
class Solution {
public:
    string getHint(string secret, string guess) {
        int bulls = 0;
        vector<int> cntS(10), cntG(10);
        for (int i = 0; i < secret.length(); ++i) {
            if (secret[i] == guess[i]) {
                ++bulls;
            } else {
                ++cntS[secret[i] - '0'];
                ++cntG[guess[i] - '0'];
            }
        }
        int cows = 0;
        for (int i = 0; i < 10; ++i) {
            cows += min(cntS[i], cntG[i]);
        }
        return to_string(bulls) + "A" + to_string(cows) + "B";
    }
};
```

```Java [sol1-Java]
class Solution {
    public String getHint(String secret, String guess) {
        int bulls = 0;
        int[] cntS = new int[10];
        int[] cntG = new int[10];
        for (int i = 0; i < secret.length(); ++i) {
            if (secret.charAt(i) == guess.charAt(i)) {
                ++bulls;
            } else {
                ++cntS[secret.charAt(i) - '0'];
                ++cntG[guess.charAt(i) - '0'];
            }
        }
        int cows = 0;
        for (int i = 0; i < 10; ++i) {
            cows += Math.min(cntS[i], cntG[i]);
        }
        return Integer.toString(bulls) + "A" + Integer.toString(cows) + "B";
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string GetHint(string secret, string guess) {
        int bulls = 0;
        int[] cntS = new int[10];
        int[] cntG = new int[10];
        for (int i = 0; i < secret.Length; ++i) {
            if (secret[i] == guess[i]) {
                ++bulls;
            } else {
                ++cntS[secret[i] - '0'];
                ++cntG[guess[i] - '0'];
            }
        }
        int cows = 0;
        for (int i = 0; i < 10; ++i) {
            cows += Math.Min(cntS[i], cntG[i]);
        }
        return bulls.ToString() + "A" + cows.ToString() + "B";
    }
}
```

```go [sol1-Golang]
func getHint(secret, guess string) string {
    bulls := 0
    var cntS, cntG [10]int
    for i := range secret {
        if secret[i] == guess[i] {
            bulls++
        } else {
            cntS[secret[i]-'0']++
            cntG[guess[i]-'0']++
        }
    }
    cows := 0
    for i := 0; i < 10; i++ {
        cows += min(cntS[i], cntG[i])
    }
    return fmt.Sprintf("%dA%dB", bulls, cows)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var getHint = function(secret, guess) {
    let bulls = 0;
    const cntS = new Array(10).fill(0);
    const cntG = new Array(10).fill(0);
    for (let i = 0; i < secret.length; ++i) {
        if (secret[i] == guess[i]) {
            ++bulls;
        } else {
            ++cntS[secret[i].charCodeAt() - '0'.charCodeAt()];
            ++cntG[guess[i].charCodeAt() - '0'.charCodeAt()];
        }
    }
    let cows = 0;
    for (let i = 0; i < 10; ++i) {
        cows += Math.min(cntS[i], cntG[i]);
    }
    return '' + bulls + "A" + '' + cows + "B";
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是字符串 $\textit{secret}$ 的长度。

- 空间复杂度：$O(C)$。需要常数个空间统计字符出现次数，由于我们统计的是数字字符，因此 $C=10$。