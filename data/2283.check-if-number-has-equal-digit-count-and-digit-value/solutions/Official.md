#### 方法一：哈希表

**思路与算法**

首先题目给出一个只包含数字且下标从 $0$ 开始长度为 $n$ 的字符串 $\textit{num}$。现在我们需要判断字符串 $\textit{num}$ 是否每一个位置 $i$，$0 \le i < n$ 都满足数字 $i$ 在 $\textit{num}$ 中出现了 $\textit{num}[i]$ 次。那么我们首先将 $\textit{num}$ 中的每一个数字用哈希表做一个统计，然后遍历每一个位置来判断是否满足要求即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def digitCount(self, num: str) -> bool:
        h = Counter(num)
        for idx, v in enumerate(num):
            if h[str(idx)] != int(v):
                return False
        return True
```

```Java [sol1-Java]
class Solution {
    public boolean digitCount(String num) {
        Map<Integer, Integer> h = new HashMap<Integer, Integer>();
        int n = num.length();
        for (int i = 0; i < n; i++) {
            int digit = num.charAt(i) - '0';
            h.put(digit, h.getOrDefault(digit, 0) + 1);
        }
        for (int i = 0; i < n; i++) {
            int v = num.charAt(i) - '0';
            if (h.getOrDefault(i, 0) != v) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool DigitCount(string num) {
        IDictionary<int, int> h = new Dictionary<int, int>();
        int n = num.Length;
        for (int i = 0; i < n; i++) {
            int digit = num[i] - '0';
            h.TryAdd(digit, 0);
            h[digit]++;
        }
        for (int i = 0; i < n; i++) {
            int v = num[i] - '0';
            h.TryAdd(i, 0);
            if (h[i] != v) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool digitCount(string num) {
        unordered_map<int, int> h;
        int n = num.size();
        for (int i = 0; i < n; i++) {
            h[num[i] - '0']++;
        }
        for (int i = 0; i < n; i++) {
            int v = num[i] - '0';
            if (h[i] != v) {
                return false;
            }
        }
        return true;
    }
};
```

```C [sol1-C]
bool digitCount(char * num) {
    int h[16];
    memset(h, 0, sizeof(h));
    int n = strlen(num);
    for (int i = 0; i < n; i++) {
        h[num[i] - '0']++;
    }
    for (int i = 0; i < n; i++) {
        int v = num[i] - '0';
        if (h[i] != v) {
            return false;
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var digitCount = function(num) {
    const h = new Map();
    const n = num.length;
    for (let i = 0; i < n; i++) {
        const digit = num[i].charCodeAt() - '0'.charCodeAt();
        h.set(digit, (h.get(digit) || 0) + 1);
    }
    for (let i = 0; i < n; i++) {
        const v = num[i].charCodeAt() - '0'.charCodeAt();
        if ((h.get(i) || 0) !== v) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func digitCount(num string) bool {
    cnt := map[rune]int{}
    for _, c := range num {
        cnt[c-'0']++
    }
    for i, c := range num {
        if cnt[rune(i)] != int(c-'0') {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{num}$ 的长度。
- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{num}$ 的长度，主要为哈希表的空间开销。