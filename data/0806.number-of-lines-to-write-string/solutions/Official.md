## [806.写字符串需要的行数 中文官方题解](https://leetcode.cn/problems/number-of-lines-to-write-string/solutions/100000/xie-zi-fu-chuan-xu-yao-de-xing-shu-by-le-9bj5)
#### 方法一: 直接遍历

**思路与算法**

我们从左到右遍历字符串 $s$ 中的每个字母，$\textit{lines}$ 表示当前书写所需的行数，$\textit{width}$ 表示当前行已经使用的宽度。当遍历到一个字母 $c$ 时：
+ 如果 $\textit{width} + \textit{widths}[c] \le 100$，此时那么更新 $\textit{width} = \textit{width} + \textit{widths}[c]$ 并保持 $\textit{lines}$ 不变；
+ 如果 $\textit{width} + \textit{widths}[c] > 100$，此时需要另起新的一行，那么此时 $\textit{lines}$ 的值加 $1$，并将 $\textit{width}$ 置为 $\textit{widths}[c]$。

**代码**

```Python [sol1-Python3]
class Solution:
    def numberOfLines(self, widths: List[int], s: str) -> List[int]:
        MAX_WIDTH = 100
        lines, width = 1, 0
        for c in s:
            need = widths[ord(c) - ord('a')]
            width += need
            if width > MAX_WIDTH:
                lines += 1
                width = need
        return [lines, width]
```

```Java [sol1-Java]
class Solution {
    public static final int MAX_WIDTH = 100;

    public int[] numberOfLines(int[] widths, String s) {
        int lines = 1;
        int width = 0;
        for (int i = 0; i < s.length(); i++) {
            int need = widths[s.charAt(i) - 'a'];
            width += need;
            if (width > MAX_WIDTH) {
                lines++;
                width = need;
            }
        }
        return new int[]{lines, width};
    }
}
```

```C++ [sol1-C++]
const int MAX_WIDTH = 100;

class Solution {
public:
    vector<int> numberOfLines(vector<int>& widths, string s) {
        int lines = 1;
        int width = 0;
        for (auto & c : s) {
            int need = widths[c - 'a'];
            width += need;
            if (width > MAX_WIDTH) {
                lines++;
                width = need;
            }
        }
        return {lines, width};
    }
};
```

```C# [sol1-C#]
public class Solution {
    public static int MAX_WIDTH = 100;

    public int[] NumberOfLines(int[] widths, string s) {
        int lines = 1;
        int width = 0;
        for (int i = 0; i < s.Length; i++) {
            int need = widths[s[i] - 'a'];
            width += need;
            if (width > MAX_WIDTH) {
                lines++;
                width = need;
            }
        }
        return new int[]{lines, width};
    }
}
```

```C [sol1-C]
#define MAX_WIDTH 100

int* numberOfLines(int* widths, int widthsSize, char * s, int* returnSize){
    int lines = 1;
    int width = 0;
    int len = strlen(s);
    for (int i = 0; i < len; i++) {
        int need = widths[s[i] - 'a'];
        width += need;
        if (width > MAX_WIDTH) {
            lines++;
            width = need;
        }
    }
    int * ans = (int *)malloc(sizeof(int) * 2);
    *returnSize = 2;
    ans[0] = lines;
    ans[1] = width;
    return ans;
}
```

```go [sol1-Golang]
func numberOfLines(widths []int, s string) []int {
    const maxWidth = 100
    lines, width := 1, 0
    for _, c := range s {
        need := widths[c-'a']
        width += need
        if width > maxWidth {
            lines++
            width = need
        }
    }
    return []int{lines, width}
}
```

```JavaScript [sol1-JavaScript]
const MAX_WIDTH = 100;
var numberOfLines = function(widths, s) {
    let lines = 1;
    let width = 0;
    for (let i = 0; i < s.length; i++) {
        const need = widths[s[i].charCodeAt() - 'a'.charCodeAt()];
        width += need;
        if (width > MAX_WIDTH) {
            lines++;
            width = need;
        }
    }
    return [lines, width];
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。需要遍历一遍字符串 $s$，求出行数。

+ 空间复杂度：$O(1)$。