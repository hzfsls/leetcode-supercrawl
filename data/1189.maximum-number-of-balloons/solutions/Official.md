#### 方法一：统计

**思路**

构成单词 $\texttt{"balloon"}$ 需要 $1$ 个字母 $\texttt{`b'}$ 、$1$ 个字母 $\texttt{`a'}$ 、$2$ 个字母 $\texttt{`l'}$ 、$2$ 个字母 $\texttt{`o'}$ 、$1$ 个字母 $\texttt{`n'}$，因此只需要统计字符串中字母 $\texttt{`a',`b',`l',`o',`n'}$ 的数量即可。其中每个字母 $\texttt{"balloon"}$ 需要两个 $\texttt{`l',`o'}$，可以将字母 $\texttt{`l',`o'}$ 的数量除以 $2$，返回字母 $\texttt{`a',`b',`l',`o',`n'}$ 中数量最小值即为可以构成的单词数量。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxNumberOfBalloons(self, text: str) -> int:
        cnt = Counter(ch for ch in text if ch in "balon")
        cnt['l'] //= 2
        cnt['o'] //= 2
        return min(cnt.values()) if len(cnt) == 5 else 0
```

```C++ [sol1-C++]
class Solution {
public:
    int maxNumberOfBalloons(string text) {
        vector<int> cnt(5);
        for (auto & ch : text) {
            if (ch == 'b') {
                cnt[0]++;
            } else if (ch == 'a') {
                cnt[1]++;
            } else if (ch == 'l') {
                cnt[2]++;
            } else if (ch == 'o') {
                cnt[3]++;
            } else if (ch == 'n') {
                cnt[4]++;
            }
        }
        cnt[2] /= 2;
        cnt[3] /= 2;
        return *min_element(cnt.begin(), cnt.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxNumberOfBalloons(String text) {
        int[] cnt = new int[5];
        for (int i = 0; i < text.length(); ++i) {
            char ch = text.charAt(i);
            if (ch == 'b') {
                cnt[0]++;
            } else if (ch == 'a') {
                cnt[1]++;
            } else if (ch == 'l') {
                cnt[2]++;
            } else if (ch == 'o') {
                cnt[3]++;
            } else if (ch == 'n') {
                cnt[4]++;
            }
        }
        cnt[2] /= 2;
        cnt[3] /= 2;
        return Arrays.stream(cnt).min().getAsInt();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxNumberOfBalloons(string text) {
        int[] cnt = new int[5];
        foreach (char ch in text) {
            if (ch == 'b') {
                cnt[0]++;
            } else if (ch == 'a') {
                cnt[1]++;
            } else if (ch == 'l') {
                cnt[2]++;
            } else if (ch == 'o') {
                cnt[3]++;
            } else if (ch == 'n') {
                cnt[4]++;
            }
        }
        cnt[2] /= 2;
        cnt[3] /= 2;
        return cnt.Min();
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int maxNumberOfBalloons(char * text) {
    int cnt[5];
    int n = strlen(text);
    memset(cnt, 0, sizeof(int) * 5);
    for (int i = 0; i < n; i++) {
        if (text[i] == 'b') {
            cnt[0]++;
        } else if (text[i] == 'a') {
            cnt[1]++;
        } else if (text[i] == 'l') {
            cnt[2]++;
        } else if (text[i] == 'o') {
            cnt[3]++;
        } else if (text[i] == 'n') {
            cnt[4]++;
        }
    }
    cnt[2] /= 2;
    cnt[3] /= 2;
    int res = INT_MAX;
    for (int i = 0; i < 5; i++) {
        res = MIN(res, cnt[i]);
    }
    return res;
}
```

```go [sol1-Golang]
func maxNumberOfBalloons(text string) int {
    cnt := [5]int{}
    for _, ch := range text {
        if ch == 'b' {
            cnt[0]++
        } else if ch == 'a' {
            cnt[1]++
        } else if ch == 'l' {
            cnt[2]++
        } else if ch == 'o' {
            cnt[3]++
        } else if ch == 'n' {
            cnt[4]++
        }
    }
    cnt[2] /= 2
    cnt[3] /= 2
    ans := cnt[0]
    for _, v := range cnt[1:] {
        if v < ans {
            ans = v
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var maxNumberOfBalloons = function(text) {
    const cnt = new Array(5).fill(0);
    for (const ch of text) {
        if (ch === 'b') {
            cnt[0]++;
        } else if (ch === 'a') {
            cnt[1]++;
        } else if (ch === 'l') {
            cnt[2]++;
        } else if (ch === 'o') {
            cnt[3]++;
        } else if (ch === 'n') {
            cnt[4]++;
        }
    }
    cnt[2] = Math.floor(cnt[2] / 2);
    cnt[3] = Math.floor(cnt[3] / 2);
    return _.min(cnt);
};
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $n$ 为字符串的长度，$C$ 表示单词中字符的种类数，在本题中 $C = 5$。需要遍历一遍字符串，并求出单词中字符的最小数目。

- 空间复杂度：$O(C)$，$C$ 表示单词中字符的种类数，在本题中 $C = 5$。需要 $O(C)$ 的空间存储字符的统计数目。