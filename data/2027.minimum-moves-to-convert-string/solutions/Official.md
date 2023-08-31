## [2027.转换字符串的最少操作次数 中文官方题解](https://leetcode.cn/problems/minimum-moves-to-convert-string/solutions/100000/zhuan-huan-zi-fu-chuan-de-zui-shao-cao-z-cji1)
#### 方法一：模拟

**思路**

从左至右遍历 $s$，用 $\textit{covered}$ 表示 $\textit{res}$ 操作次数内最多可以转换的下标数。$\textit{res}$ 初始化为 $0$，$\textit{covered}$ 初始化为 $-1$。遍历时，如果当前元素为 $`\text{O}’$ 或当前下标已被覆盖了，则不需要额外操作数。仅当当前元素为 $`\text{X}’$ 且当前下标未被覆盖，需要增加一次操作，并更新 $\textit{covered}$。最后返回操作数。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumMoves(self, s: str) -> int:
        covered = -1
        res = 0
        for i, c in enumerate(s):
            if c == 'X' and i > covered:
                res += 1
                covered = i + 2
        return res
```

```Java [sol1-Java]
class Solution {
    public int minimumMoves(String s) {
        int covered = -1, res = 0;
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == 'X' && i > covered) {
                res++;
                covered = i + 2;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumMoves(string s) {
        int covered = -1, res = 0;
        for (int i = 0; i < s.Length; i++) {
            if (s[i] == 'X' && i > covered) {
                res++;
                covered = i + 2;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumMoves(string s) {
        int covered = -1, res = 0;
        for (int i = 0; i < s.size(); i++) {
            if (s[i] == 'X' && i > covered) {
                res += 1;
                covered = i + 2;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int minimumMoves(char * s) {
    int covered = -1, res = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        if (s[i] == 'X' && i > covered) {
            res += 1;
            covered = i + 2;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func minimumMoves(s string) (res int) {
	covered := -1
	for i, c := range s {
		if c == 'X' && i > covered {
			res++
			covered = i + 2
		}
	}
	return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。只需要遍历 $s$ 一遍。

- 空间复杂度：$O(1)$。只需要常数空间。