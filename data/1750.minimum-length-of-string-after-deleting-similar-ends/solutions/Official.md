#### 方法一：双指针

**思路与算法**

题目要求删除字符串 $s$ 中字母相同且不相交的前缀与后缀，假设当前字符串的长度为 $n$，则执行的删除规则如下：
+ 选择字符串 $s$ 一个**非空**的前缀 $\textit{prefix} = s[0,\cdots,l]$，这个前缀的所有字符都相同，$s[0] = s[1] = \cdots = s[l]$。
+ 选择字符串 $s$ 一个**非空**的后缀 $\textit{suffix} = s[r,\cdots,n-1]$，这个后缀的所有字符都相同，$s[r] = s[r + 1] = \cdots = s[n-1]$。
+ 前缀和后缀在字符串中任意位置都不能有交集，即 $l < r$。
+ 前缀和后缀包含的所有字符都要相同，$s[0] = s[1] = \cdots = s[l] = s[r] = s[r + 1] = \cdots = s[n-1]$。
+ 同时删除前缀和后缀。

通过观察我们对 $s$ 进行分类讨论如下：
+ $s$ 的长度为 $1$ 时，假设 $s = \text{``a"}$，此时按照题目的删除规则此时不能删除。
+ $s$ 的长度大于 $1$ 且 $s$ 中的所有字符均相同，假设 $s = \text{``aaaa"}$，此时按照题目的删除规则 $s$ 一定可以全部删除完。
+ $s$ 的长度大于 $1$ 且 $s$ 存在字母相同的前缀与后缀，假设 $s = \text{``aaabbbccca"}$，此时按照题目的删除规则最优选择是 $s$ 应当将前缀与后缀中连续的 $\text{`a’}$ 全部删除完，删除完成后 $s' = \text{``bbbccc"}$。
+ $s$ 的长度大于 $1$ 且 $s$ 不存在字母相同的前缀与后缀，假设 $s = \text{``aaaccc"}$，此时按照删除规则，无法进行删除。

根据以上的删除规则分类，我们设 $\textit{left}$ 和 $\textit{right}$ 分别指向当前待删除字符串的起始位置与结束位置，然后按照规则进行删除，当前可以删除的条件必须满足如下:
+ 只有字符串的长度大于 $1$ 时我们才进行删除，因此可以进行删除的条件一定需要满足 $\textit{left} < \textit{right}$；
+ 只有存在字母相同的前缀与后缀我们才进行删除，因此可以进行删除的条件一定需要满足 $s[\textit{left}] = s[\textit{right}]$。

假设有可以进行删除的前缀和后缀时，则我们将所有字母相同的前缀与后缀全部删除，此时 $\textit{left}$ 需要向右移动，$\textit{right}$ 需要向左移动，并删除字符串中字母相同的前缀与后缀，直到无法删除为止。最终 $\textit{left}$ 指向删除后字符串的左起点，$\textit{right}$ 指向删除后字符串的右终点，剩余的字符串的长度则为 $\textit{right} - \textit{left} + 1$。

需要注意的是，如果当 $s$ 的长度大于 $1$ 且 $s$ 中的字符全部相等时，此时需要将 $s$ 全部进行删除，则会出现 $\textit{right} = \textit{left} - 1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumLength(self, s: str) -> int:
        left, right = 0, len(s) - 1
        while left < right and s[left] == s[right]:
            c = s[left]
            while left <= right and s[left] == c:
                left += 1
            while right >= left and s[right] == c:
                right -= 1
        return right - left + 1
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumLength(string s) {
        int n = s.size();
        int left = 0, right = n - 1;
        while (left < right && s[left] == s[right]) {
            char c = s[left];
            while (left <= right && s[left] == c) {
                left++;
            }
            while (left <= right && s[right] == c) {
                right--;
            }
        }
        return right - left + 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumLength(String s) {
        int n = s.length();
        int left = 0, right = n - 1;
        while (left < right && s.charAt(left) == s.charAt(right)) {
            char c = s.charAt(left);
            while (left <= right && s.charAt(left) == c) {
                left++;
            }
            while (left <= right && s.charAt(right) == c) {
                right--;
            }
        }
        return right - left + 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumLength(string s) {
        int n = s.Length;
        int left = 0, right = n - 1;
        while (left < right && s[left] == s[right]) {
            char c = s[left];
            while (left <= right && s[left] == c) {
                left++;
            }
            while (left <= right && s[right] == c) {
                right--;
            }
        }
        return right - left + 1;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int minimumLength(char * s) {
    int n = strlen(s);
    int left = 0, right = n - 1;
    while (left < right && s[left] == s[right]) {
        char c = s[left];
        while (left <= right && s[left] == c) {
            left++;
        }
        while (left <= right && s[right] == c) {
            right--;
        }
    }
    return right - left + 1;
}
```

```JavaScript [sol1-JavaScript]
var minimumLength = function(s) {
    const n = s.length;
    let left = 0, right = n - 1;
    while (left < right && s[left] == s[right]) {
        const c = s[left];
        while (left <= right && s[left] === c) {
            left++;
        }
        while (left <= right && s[right] === c) {
            right--;
        }
    }
    return right - left + 1;
};
```

```go [sol1-Golang]
func minimumLength(s string) int {
	left, right := 0, len(s)-1
	for left < right && s[left] == s[right] {
		c := s[left]
		for left <= right && s[left] == c {
			left++
		}
		for right >= left && s[right] == c {
			right--
		}
	}
	return right - left + 1
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(1)$。