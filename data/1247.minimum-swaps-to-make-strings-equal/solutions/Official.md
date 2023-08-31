## [1247.交换字符使得字符串相同 中文官方题解](https://leetcode.cn/problems/minimum-swaps-to-make-strings-equal/solutions/100000/jiao-huan-zi-fu-shi-de-zi-fu-chuan-xiang-6b1u)

#### 方法一：贪心

**思路**

同时遍历两个字符串，比较相同下标下，两个字符串的字符，如果相同，则该下标的字符不需要进行交换。如果不相同，则有两种情况，一是 $s_1[i]$ 为 $\text{``x''}$，$s_2[i]$ 为 $\text{``y''}$，用 $\textit{xy}$ 表示这种情况出现的次数。另一种情况是 $s_1[i]$ 为 $\text{``y''}$，$s_2[i]$ 为 $\text{``x''}$，用 $\textit{yx}$ 表示这种情况出现的次数。现在需要通过最少次数的交换，使得 $\textit{xy}$ 和 $\textit{yx}$ 都为 $0$。交换的方法有两种：

- 示例 1：可以通过一次交换，使得 $\textit{xy}$ **或** $\textit{yx}$ 的值减少 $2$。
- 示例 2：可以通过两次交换，使得 $\textit{xy}$ **和** $\textit{yx}$ 的值各减少 $1$。

为了使用尽可能少的交换次数，需要从以下顺序考虑：

1. 第一种交换方式更有效率，应该尽可能采用第一种交换方式。
2. 如果还未能使 $\textit{xy}$ 和 $\textit{yx}$ 都为 $0$，则应该采用第二种交换方式。
3. 如果 $\textit{xy}$ 和 $\textit{yx}$ 都为 $1$，则可以通过两次第二种交换，来使得 $\textit{xy}$ 和 $\textit{yx}$ 都为 $0$，否则不能使 $\textit{xy}$ 和 $\textit{yx}$ 都为 $0$。这里也可以预先判断，如果 $\textit{xy}$ 和 $\textit{yx}$ 之和为奇数，则没有方法能够使得字符串相等。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumSwap(self, s1: str, s2: str) -> int:
        xy, yx = 0, 0
        n = len(s1)
        for a, b in zip(s1, s2):
            if a == 'x' and b == 'y':
                xy += 1
            if a == 'y' and b == 'x':
                yx += 1
        if (xy + yx) % 2 == 1:
            return -1
        return xy // 2 + yx // 2 + xy % 2 + yx % 2
```

```Java [sol1-Java]
class Solution {
    public int minimumSwap(String s1, String s2) {
        int xy = 0, yx = 0;
        int n = s1.length();
        for (int i = 0; i < n; i++) {
            char a = s1.charAt(i), b = s2.charAt(i);
            if (a == 'x' && b == 'y') {
                xy++;
            }
            if (a == 'y' && b == 'x') {
                yx++;
            }
        }
        if ((xy + yx) % 2 == 1) {
            return -1;
        }
        return xy / 2 + yx / 2 + xy % 2 + yx % 2;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumSwap(string s1, string s2) {
        int xy = 0, yx = 0;
        int n = s1.Length;
        for (int i = 0; i < n; i++) {
            char a = s1[i], b = s2[i];
            if (a == 'x' && b == 'y') {
                xy++;
            }
            if (a == 'y' && b == 'x') {
                yx++;
            }
        }
        if ((xy + yx) % 2 == 1) {
            return -1;
        }
        return xy / 2 + yx / 2 + xy % 2 + yx % 2;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumSwap(string s1, string s2) {
        int xy = 0, yx = 0;
        int n = s1.size();
        for (int i = 0; i < n; i++) {
            char a = s1[i], b = s2[i];
            if (a == 'x' and b == 'y') {
                xy++;
            }
            if (a == 'y' and b == 'x') {
                yx++;
            }
        }
        if ((xy + yx) % 2 == 1) {
            return -1;
        }
        return xy / 2 + yx / 2 + xy % 2 + yx % 2;
    }
};
```

```C [sol1-C]
int minimumSwap(char * s1, char * s2) {
    int xy = 0, yx = 0;
    int n = strlen(s1);
    for (int i = 0; i < n; i++) {
        char a = s1[i], b = s2[i];
        if (a == 'x' && b == 'y') {
            xy++;
        }
        if (a == 'y' && b == 'x') {
            yx++;
        }
    }
    if ((xy + yx) % 2 == 1) {
        return -1;
    }
    return xy / 2 + yx / 2 + xy % 2 + yx % 2;
}
```

```JavaScript [sol1-JavaScript]
var minimumSwap = function(s1, s2) {
    let xy = 0, yx = 0;
    const n = s1.length;
    for (let i = 0; i < n; i++) {
        const a = s1[i], b = s2[i];
        if (a === 'x' && b === 'y') {
            xy++;
        }
        if (a === 'y' && b === 'x') {
            yx++;
        }
    }
    if ((xy + yx) % 2 === 1) {
        return -1;
    }
    return Math.floor(xy / 2) + Math.floor(yx / 2) + xy % 2 + yx % 2;
};
```

```go [sol1-Golang]
func minimumSwap(s1 string, s2 string) int {
    xy, yx := 0, 0
    n := len(s1)
    for i := 0; i < n; i++ {
        a, b := s1[i], s2[i]
        if a == 'x' && b == 'y' {
            xy++
        }
        if a == 'y' && b == 'x' {
            yx++
        }
    }
    if (xy+yx)%2 == 1 {
        return -1
    }
    return xy/2 + yx/2 + xy%2 + yx%2
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。需要遍历两个字符串一遍。

- 空间复杂度：$O(1)$，只需要常数空间。