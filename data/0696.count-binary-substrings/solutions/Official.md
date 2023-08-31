## [696.计数二进制子串 中文官方题解](https://leetcode.cn/problems/count-binary-substrings/solutions/100000/ji-shu-er-jin-zhi-zi-chuan-by-leetcode-solution)

#### 方法一：按字符分组

**思路与算法**

我们可以将字符串 $s$ 按照 $0$ 和 $1$ 的连续段分组，存在 $\textit{counts}$ 数组中，例如 $s = 00111011$，可以得到这样的 $\textit{counts}$ 数组：$\textit{counts} = \{2, 3, 1, 2\}$。

这里 $\textit{counts}$ 数组中两个相邻的数一定代表的是两种不同的字符。假设 $\textit{counts}$ 数组中两个相邻的数字为 $u$ 或者 $v$，它们对应着 $u$ 个 $0$ 和 $v$ 个 $1$，或者 $u$ 个 $1$ 和 $v$ 个 $0$。它们能组成的满足条件的子串数目为 $\min \{ u, v \}$，即一对相邻的数字对答案的贡献。

我们只要遍历所有相邻的数对，求它们的贡献总和，即可得到答案。

不难得到这样的实现：

```cpp [sol0-C++]
class Solution {
public:
    int countBinarySubstrings(string s) {
        vector<int> counts;
        int ptr = 0, n = s.size();
        while (ptr < n) {
            char c = s[ptr];
            int count = 0;
            while (ptr < n && s[ptr] == c) {
                ++ptr;
                ++count;
            }
            counts.push_back(count);
        }
        int ans = 0;
        for (int i = 1; i < counts.size(); ++i) {
            ans += min(counts[i], counts[i - 1]);
        }
        return ans;
    }
};
```

```Java [sol0-Java]
class Solution {
    public int countBinarySubstrings(String s) {
        List<Integer> counts = new ArrayList<Integer>();
        int ptr = 0, n = s.length();
        while (ptr < n) {
            char c = s.charAt(ptr);
            int count = 0;
            while (ptr < n && s.charAt(ptr) == c) {
                ++ptr;
                ++count;
            }
            counts.add(count);
        }
        int ans = 0;
        for (int i = 1; i < counts.size(); ++i) {
            ans += Math.min(counts.get(i), counts.get(i - 1));
        }
        return ans;
    }
}
```

```JavaScript [sol0-JavaScript]
var countBinarySubstrings = function(s) {
    const counts = [];
    let ptr = 0, n = s.length;
    while (ptr < n) {
        const c = s.charAt(ptr);
        let count = 0;
        while (ptr < n && s.charAt(ptr) === c) {
            ++ptr;
            ++count;
        }
        counts.push(count);
    }
    let ans = 0;
    for (let i = 1; i < counts.length; ++i) {
        ans += Math.min(counts[i], counts[i - 1]);
    }
    return ans;
};
```

```golang [sol0-Golang]
func countBinarySubstrings(s string) int {
    counts := []int{}
    ptr, n := 0, len(s)
    for ptr < n {
        c := s[ptr]
        count := 0
        for ptr < n && s[ptr] == c {
            ptr++
            count++
        }
        counts = append(counts, count)
    }
    ans := 0
    for i := 1; i < len(counts); i++ {
        ans += min(counts[i], counts[i-1])
    }
    return ans
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

```C [sol0-C]
int countBinarySubstrings(char* s) {
    int n = strlen(s);
    int counts[n], counts_len = 0;
    memset(counts, 0, sizeof(counts));
    int ptr = 0;
    while (ptr < n) {
        char c = s[ptr];
        int count = 0;
        while (ptr < n && s[ptr] == c) {
            ++ptr;
            ++count;
        }
        counts[counts_len++] = count;
    }
    int ans = 0;
    for (int i = 1; i < counts_len; ++i) {
        ans += fmin(counts[i], counts[i - 1]);
    }
    return ans;
}
```

这个实现的时间复杂度和空间复杂度都是 $O(n)$。

对于某一个位置 $i$，其实我们只关心 $i - 1$ 位置的 $\textit{counts}$ 值是多少，所以可以用一个 $\textit{last}$ 变量来维护当前位置的前一个位置，这样可以省去一个 $\textit{counts}$ 数组的空间。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int countBinarySubstrings(string s) {
        int ptr = 0, n = s.size(), last = 0, ans = 0;
        while (ptr < n) {
            char c = s[ptr];
            int count = 0;
            while (ptr < n && s[ptr] == c) {
                ++ptr;
                ++count;
            }
            ans += min(count, last);
            last = count;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countBinarySubstrings(String s) {
        int ptr = 0, n = s.length(), last = 0, ans = 0;
        while (ptr < n) {
            char c = s.charAt(ptr);
            int count = 0;
            while (ptr < n && s.charAt(ptr) == c) {
                ++ptr;
                ++count;
            }
            ans += Math.min(count, last);
            last = count;
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var countBinarySubstrings = function(s) {
    let ptr = 0, n = s.length, last = 0, ans = 0;
    while (ptr < n) {
        const c = s.charAt(ptr);
        let count = 0;
        while (ptr < n && s.charAt(ptr) === c) {
            ++ptr;
            ++count;
        }
        ans += Math.min(count, last);
        last = count;
    }
    return ans;
};
```

```golang [sol1-Golang]
func countBinarySubstrings(s string) int {
    var ptr, last, ans int
    n := len(s)
    for ptr < n {
        c := s[ptr]
        count := 0
        for ptr < n && s[ptr] == c {
            ptr++
            count++
        }
        ans += min(count, last)
        last = count
    }

    return ans
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

```C [sol1-C]
int countBinarySubstrings(char* s) {
    int ptr = 0, n = strlen(s), last = 0, ans = 0;
    while (ptr < n) {
        char c = s[ptr];
        int count = 0;
        while (ptr < n && s[ptr] == c) {
            ++ptr;
            ++count;
        }
        ans += fmin(count, last);
        last = count;
    }
    return ans;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$。
+ 空间复杂度：$O(1)$。