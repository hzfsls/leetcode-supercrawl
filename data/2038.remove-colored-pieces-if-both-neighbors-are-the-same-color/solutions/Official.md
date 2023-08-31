## [2038.如果相邻两个颜色均相同则删除当前颜色 中文官方题解](https://leetcode.cn/problems/remove-colored-pieces-if-both-neighbors-are-the-same-color/solutions/100000/ru-guo-xiang-lin-liang-ge-yan-se-jun-xia-rfbk)

#### 方法一：贪心

**思路**

根据题意，当 $\textit{colors}$ 中有一串连续的长度为 $L_\text{A}$ 的 $\text{A}$ 时，$\text{Alice}$ 可以删除中间的 $L_\text{A}-2$ 个 $\text{A}$，而不能删除两边的 $2$ 个 $\text{A}$。并且 $\text{Bob}$ 删除 $\text{B}$ 的操作，不会影响 $\text{Alice}$ 删除 $L_\text{A}$ 的操作。

同理，当 $\textit{colors}$ 中有一串连续的长度为 $L_\text{B}$ 的 $\text{B}$ 时，$\text{Bob}$ 可以删除中间的 $L_\text{B}-2$ 个 $\text{B}$，而不能删除两边的 $2$ 个 $\text{B}$。并且 $\text{Alice}$ 删除 $\text{A}$ 的操作，不会影响 $\text{Bob}$ 删除 $L_\text{B}$ 的操作。

根据这两个结论，我们可以分别计算出 $\text{Alice}$ 和 $\text{Bob}$ 的操作数。当 $\text{Alice}$ 的操作数大于 $\text{Bob}$ 的操作数时，$\text{Alice}$ 获胜；否则，$\text{Bob}$ 获胜。

**代码**

```Python [sol1-Python3]
class Solution:
    def winnerOfGame(self, colors: str) -> bool:
        freq = [0, 0]
        cur, cnt = 'C', 0
        for c in colors:
            if c != cur:
                cur = c
                cnt = 1
            else:
                cnt += 1
                if cnt >= 3:
                    freq[ord(cur) - ord('A')] += 1
        return freq[0] > freq[1]
```

```Java [sol1-Java]
class Solution {
    public boolean winnerOfGame(String colors) {
        int[] freq = {0, 0};
        char cur = 'C';
        int cnt = 0;
        for (int i = 0; i < colors.length(); i++) {
            char c = colors.charAt(i);
            if (c != cur) {
                cur = c;
                cnt = 1;
            } else {
                cnt += 1;
                if (cnt >= 3) {
                    freq[cur - 'A'] += 1;
                }
            }
        }            
        return freq[0] > freq[1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool WinnerOfGame(string colors) {
        int[] freq = {0, 0};
        char cur = 'C';
        int cnt = 0;
        foreach (char c in colors) {
            if (c != cur) {
                cur = c;
                cnt = 1;
            } else {
                cnt += 1;
                if (cnt >= 3) {
                    freq[cur - 'A'] += 1;
                }
            }
        }            
        return freq[0] > freq[1];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool winnerOfGame(string colors) {
        int freq[2] = {0, 0};
        char cur = 'C';
        int cnt = 0;
        for (char c : colors) {
            if (c != cur) {
                cur = c;
                cnt = 1;
            } else if (++cnt >= 3) {
                ++freq[cur - 'A'];
            }
        }            
        return freq[0] > freq[1];
    }
};
```

```C [sol1-C]
bool winnerOfGame(char * colors){
    int freq[2] = {0, 0};
    char cur = 'C';
    int cnt = 0;
    int len = strlen(colors);
    for (int i = 0; i < len; i++) {
        char c = colors[i];
        if (c != cur) {
            cur = c;
            cnt = 1;
        } else {
            cnt += 1;
            if (cnt >= 3) {
                freq[cur - 'A'] += 1;
            }
        }
    }       
    return freq[0] > freq[1];
}
```

```JavaScript [sol1-JavaScript]
var winnerOfGame = function(colors) {
    const freq = [0, 0];
    let cur = 'C';
    let cnt = 0;
    for (let i = 0; i < colors.length; i++) {
        const c = colors[i];
        if (c !== cur) {
            cur = c;
            cnt = 1;
        } else {
            cnt += 1;
            if (cnt >= 3) {
                freq[cur.charCodeAt() - 'A'.charCodeAt()] += 1;
            }
        }
    }            
    return freq[0] > freq[1];
};
```

```go [sol1-Golang]
func winnerOfGame(colors string) bool {
    freq := [2]int{}
    cur, cnt := 'C', 0
    for _, c := range colors {
        if c != cur {
            cur, cnt = c, 1
        } else {
            cnt++
            if cnt >= 3 {
                freq[cur-'A']++
            }
        }
    }
    return freq[0] > freq[1]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{colors}$ 的长度。需要遍历 $\textit{colors}$ 来统计 $\text{Alice}$ 和 $\text{Bob}$ 可以移动的次数。

- 空间复杂度：$O(1)$。仅需要常数空间。