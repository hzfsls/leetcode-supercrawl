## [1239.串联字符串的最大长度 中文官方题解](https://leetcode.cn/problems/maximum-length-of-a-concatenated-string-with-unique-characters/solutions/100000/chuan-lian-zi-fu-chuan-de-zui-da-chang-d-g6gk)

#### 方法一：回溯 + 位运算

我们需要计算可行解的长度，至于可行解具体是什么，以及可行解中各个字符的顺序我们是不用考虑的。因此构成可行解的每个字符串均可以视作一个字符集合，且集合不含重复元素。

由于构成可行解的字符串仅包含小写字母，且无重复元素，我们可以用一个二进制数来表示该字符串的字符集合，二进制的第 $i$ 位为 $1$ 表示字符集合中含有第 $i$ 个小写字母，为 $0$ 表示字符集合中不含有第 $i$ 个小写字母。

由于包含重复字母的字符串无法参与构成可行解，因此遍历 $\textit{arr}$，从中筛选出无重复字母的字符串，将其对应二进制数加入一数组，记作 $\textit{masks}$。

接下来，使用回溯法来解决本问题：

- 我们用 $\text{backtrack}(\textit{pos}, \textit{mask})$ 表示递归的函数，其中 $\textit{pos}$ 表示我们当前递归到了数组 $\textit{masks}$ 中的第 $\textit{pos}$ 个数，$\textit{mask}$ 表示当前连接得到的字符串对应二进制数为 $\textit{mask}$；

- 对于第 $\textit{pos}$ 个数，我们有两种方法：选或者不选。如果 $\textit{mask}$ 和 $\textit{masks}[\textit{pos}]$ 无公共元素，则可以选这个数，此时我们调用 $\text{backtrack}(\textit{pos}+1, \textit{mask}\ |\ \textit{masks}[\textit{pos}])$ 进行递归。如果我们不选这个数，那么我们调用 $\text{backtrack}(\textit{pos}+1, \textit{mask})$ 进行递归。

- 记 $\textit{masks}$ 的长度为 $n$，当 $\textit{pos}=n$ 时，计算 $\textit{mask}$ 中 $1$ 的个数，即为可行解的长度，用其更新可行解的最长长度。

```C++ [sol1-C++]
class Solution {
public:
    int maxLength(vector<string> &arr) {
        vector<int> masks;
        for (string &s : arr) {
            int mask = 0;
            for (char ch : s) {
                ch -= 'a';
                if ((mask >> ch) & 1) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask > 0) {
                masks.push_back(mask);
            }
        }

        int ans = 0;
        function<void(int, int)> backtrack = [&](int pos, int mask) {
            if (pos == masks.size()) {
                ans = max(ans, __builtin_popcount(mask));
                return;
            }
            if ((mask & masks[pos]) == 0) { // mask 和 masks[pos] 无公共元素
                backtrack(pos + 1, mask | masks[pos]);
            }
            backtrack(pos + 1, mask);
        };
        backtrack(0, 0);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int ans = 0;

    public int maxLength(List<String> arr) {
        List<Integer> masks = new ArrayList<Integer>();
        for (String s : arr) {
            int mask = 0;
            for (int i = 0; i < s.length(); ++i) {
                int ch = s.charAt(i) - 'a';
                if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask > 0) {
                masks.add(mask);
            }
        }

        backtrack(masks, 0, 0);
        return ans;
    }

    public void backtrack(List<Integer> masks, int pos, int mask) {
        if (pos == masks.size()) {
            ans = Math.max(ans, Integer.bitCount(mask));
            return;
        }
        if ((mask & masks.get(pos)) == 0) { // mask 和 masks[pos] 无公共元素
            backtrack(masks, pos + 1, mask | masks.get(pos));
        }
        backtrack(masks, pos + 1, mask);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int ans = 0;

    public int MaxLength(IList<string> arr) {
        IList<int> masks = new List<int>();
        foreach (string s in arr) {
            int mask = 0;
            foreach (char c in s) {
                int ch = c - 'a';
                if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask > 0) {
                masks.Add(mask);
            }
        }

        Backtrack(masks, 0, 0);
        return ans;
    }

    public void Backtrack(IList<int> masks, int pos, int mask) {
        if (pos == masks.Count) {
            ans = Math.Max(ans, BitCount(mask));
            return;
        }
        if ((mask & masks[pos]) == 0) { // mask 和 masks[pos] 无公共元素
            Backtrack(masks, pos + 1, mask | masks[pos]);
        }
        Backtrack(masks, pos + 1, mask);
    }

    private static int BitCount(int i) {
        i = i - ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0f0f0f0f;
        i = i + (i >> 8);
        i = i + (i >> 16);
        return i & 0x3f;
    }
}
```

```go [sol1-Golang]
func maxLength(arr []string) (ans int) {
    masks := []int{}
outer:
    for _, s := range arr {
        mask := 0
        for _, ch := range s {
            ch -= 'a'
            if mask>>ch&1 > 0 { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                continue outer
            }
            mask |= 1 << ch // 将 ch 加入 mask 中
        }
        masks = append(masks, mask)
    }

    var backtrack func(int, int)
    backtrack = func(pos, mask int) {
        if pos == len(masks) {
            ans = max(ans, bits.OnesCount(uint(mask)))
            return
        }
        if mask&masks[pos] == 0 { // mask 和 masks[pos] 无公共元素
            backtrack(pos+1, mask|masks[pos])
        }
        backtrack(pos+1, mask)
    }
    backtrack(0, 0)
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int ans;

void backtrack(int* masks, int masksSize, int pos, int mask) {
    if (pos == masksSize) {
        ans = fmax(ans, __builtin_popcount(mask));
        return;
    }
    if ((mask & masks[pos]) == 0) {  // mask 和 masks[pos] 无公共元素
        backtrack(masks, masksSize, pos + 1, mask | masks[pos]);
    }
    backtrack(masks, masksSize, pos + 1, mask);
}

int maxLength(char** arr, int arrSize) {
    ans = 0;
    int masks[arrSize];
    int masksSize = 0;
    for (int i = 0; i < arrSize; ++i) {
        int mask = 0;
        int len = strlen(arr[i]);
        for (int j = 0; j < len; ++j) {
            int ch = arr[i][j] - 'a';
            if (((mask >> ch) & 1) != 0) {  // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                mask = 0;
                break;
            }
            mask |= 1 << ch;  // 将 ch 加入 mask 中
        }
        if (mask > 0) {
            masks[masksSize++] = mask;
        }
    }

    backtrack(masks, masksSize, 0, 0);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maxLength = function(arr) {
    let ans = 0;
    const masks = [];
    for (const s of arr) {
        let mask = 0;
        for (let i = 0; i < s.length; ++i) {
            const ch = s[i].charCodeAt() - 'a'.charCodeAt();
            if (((mask >> ch) & 1) !== 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                mask = 0;
                break;
            }
            mask |= 1 << ch; // 将 ch 加入 mask 中
        }
        if (mask > 0) {
            masks.push(mask);
        }
    }

    const backtrack = (masks, pos, mask) => {
        if (pos === masks.length) {
            ans = Math.max(ans, mask.toString(2).split('0').join('').length);
            return;
        }
        if ((mask & masks[pos]) === 0) { // mask 和 masks[pos] 无公共元素
            backtrack(masks, pos + 1, mask | masks[pos]);
        }
        backtrack(masks, pos + 1, mask);
    }

    backtrack(masks, 0, 0);
    return ans;
};
```

```Python [sol1-Python3]
class Solution:
    def maxLength(self, arr: List[str]) -> int:
        masks = list()
        for s in arr:
            mask = 0
            for ch in s:
                idx = ord(ch) - ord("a")
                if ((mask >> idx) & 1):   # // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0
                    break
                mask |= 1 << idx   # 将 ch 加入 mask 中
            if mask > 0:
                masks.append(mask)

        ans = 0

        def backtrack(pos: int, mask: int) -> None:
            if pos == len(masks):
                nonlocal ans
                ans = max(ans, bin(mask).count("1"))
                return
            
            if (mask & masks[pos]) == 0:   # mask 和 masks[pos] 无公共元素
                backtrack(pos + 1, mask | masks[pos])
            backtrack(pos + 1, mask)
        
        backtrack(0, 0)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|+2^n)$。其中 $|\Sigma|$ 是 $\textit{arr}$ 中所有字符串的长度之和，$n$ 是 $\textit{arr}$ 的长度。遍历所有字符串需要 $O(|\Sigma|)$，回溯时由于每个元素有选或不选两种情况，最坏情况下会有 $2^n$ 种组合方式。因此总的时间复杂度为 $O(|\Sigma|+2^n)$。

- 空间复杂度：$O(n)$。

#### 方法二：迭代 + 位运算

我们可以遍历 $\textit{arr}$，维护前 $i$ 个字符串构成的可行解集合，记作 $\textit{masks}$。初始时，可行解集合仅包含一个空字符串。

若 $\textit{arr}[i+1]$ 中无重复字符，则将其与 $\textit{masks}$ 中的字符串连接，若连接后仍无重复字符，则将连接后的新字符串加入到 $\textit{masks}$ 中，这样我们就得到了前 $i+1$ 个字符串构成的可行解集合。

遍历结束后，$\textit{masks}$ 即为 $\textit{arr}$ 构成的所有可行解，求出其中最长的可行解，即为答案。

代码实现时，我们沿用方法一，用二进制数表示字符串，并在得到新字符串的同时更新可行解长度最大值。

```C++ [sol2-C++]
class Solution {
public:
    int maxLength(vector<string> &arr) {
        int ans = 0;
        vector<int> masks = {0};
        for (string &s : arr) {
            int mask = 0;
            for (char ch : s) {
                ch -= 'a';
                if ((mask >> ch) & 1) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask == 0) {
                continue;
            }
            int n = masks.size();
            for (int i = 0; i < n; ++i) {
                int m = masks[i];
                if ((m & mask) == 0) { // m 和 mask 无公共元素
                    masks.push_back(m | mask);
                    ans = max(ans, __builtin_popcount(m | mask));
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxLength(List<String> arr) {
        int ans = 0;
        List<Integer> masks = new ArrayList<Integer>();
        masks.add(0);
        for (String s : arr) {
            int mask = 0;
            for (int i = 0; i < s.length(); ++i) {
                int ch = s.charAt(i) - 'a';
                if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask == 0) {
                continue;
            }
            int n = masks.size();
            for (int i = 0; i < n; ++i) {
                int m = masks.get(i);
                if ((m & mask) == 0) { // m 和 mask 无公共元素
                    masks.add(m | mask);
                    ans = Math.max(ans, Integer.bitCount(m | mask));
                }
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxLength(IList<string> arr) {
        int ans = 0;
        IList<int> masks = new List<int>();
        masks.Add(0);
        foreach (string s in arr) {
            int mask = 0;
            foreach (char c in s) {
                int ch = c - 'a';
                if (((mask >> ch) & 1) != 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0;
                    break;
                }
                mask |= 1 << ch; // 将 ch 加入 mask 中
            }
            if (mask == 0) {
                continue;
            }
            int n = masks.Count;
            for (int i = 0; i < n; ++i) {
                int m = masks[i];
                if ((m & mask) == 0) { // m 和 mask 无公共元素
                    masks.Add(m | mask);
                    ans = Math.Max(ans, BitCount(m | mask));
                }
            }
        }
        return ans;
    }

    private static int BitCount(int i) {
        i = i - ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0f0f0f0f;
        i = i + (i >> 8);
        i = i + (i >> 16);
        return i & 0x3f;
    }
}
```

```go [sol2-Golang]
func maxLength(arr []string) (ans int) {
    masks := []int{0} // 0 对应空串
outer:
    for _, s := range arr {
        mask := 0
        for _, ch := range s {
            ch -= 'a'
            if mask>>ch&1 > 0 { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                continue outer
            }
            mask |= 1 << ch // 将 ch 加入 mask 中
        }
        for _, m := range masks {
            if m&mask == 0 { // m 和 mask 无公共元素
                masks = append(masks, m|mask)
                ans = max(ans, bits.OnesCount(uint(m|mask)))
            }
        }
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int maxLength(char** arr, int arrSize) {
    int ans = 0;
    int masks[1 << arrSize], masksSize = 0;
    masks[masksSize++] = 0;
    for (int i = 0; i < arrSize; ++i) {
        int mask = 0;
        int len = strlen(arr[i]);
        for (int j = 0; j < len; ++j) {
            char ch = arr[i][j] - 'a';
            if ((mask >> ch) & 1) {  // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                mask = 0;
                break;
            }
            mask |= 1 << ch;  // 将 ch 加入 mask 中
        }
        if (mask == 0) {
            continue;
        }
        int n = masksSize;
        for (int j = 0; j < n; ++j) {
            int m = masks[j];
            if ((m & mask) == 0) {  // m 和 mask 无公共元素
                masks[masksSize++] = m | mask;
                ans = fmax(ans, __builtin_popcount(m | mask));
            }
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var maxLength = function(arr) {
    let ans = 0;
    const masks = [0];
    for (const s of arr) {
        let mask = 0;
        for (let i = 0; i < s.length; ++i) {
            const ch = s[i].charCodeAt() - 'a'.charCodeAt();
            if (((mask >> ch) & 1) !== 0) { // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                mask = 0;
                break;
            }
            mask |= 1 << ch; // 将 ch 加入 mask 中
        }
        if (mask === 0) {
            continue;
        }
        const n = masks.length;
        for (let i = 0; i < n; ++i) {
            const m = masks[i];
            if ((m & mask) === 0) { // m 和 mask 无公共元素
                masks.push(m | mask);
                ans = Math.max(ans, (m | mask).toString(2).split('0').join('').length);
            }
        }
    }
    return ans;
};
```

```Python [sol2-Python3]
class Solution:
    def maxLength(self, arr: List[str]) -> int:
        ans = 0
        masks = [0]
        for s in arr:
            mask = 0
            for ch in s:
                idx = ord(ch) - ord("a")
                if ((mask >> idx) & 1):   # // 若 mask 已有 ch，则说明 s 含有重复字母，无法构成可行解
                    mask = 0
                    break
                mask |= 1 << idx   # 将 ch 加入 mask 中
            if mask == 0:
                continue
            
            n = len(masks)
            for i in range(n):
                m = masks[i]
                if (m & mask) == 0:   # m 和 mask 无公共元素
                    masks.append(m | mask)
                    ans = max(ans, bin(m | mask).count("1"))
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|+2^n)$。其中 $|\Sigma|$ 是 $\textit{arr}$ 中所有字符串的长度之和，$n$ 是 $\textit{arr}$ 的长度。遍历所有字符串需要 $O(|\Sigma|)$，每次循环会将 $\textit{masks}$ 的大小增加至多一倍，因此总的时间复杂度为 $O(|\Sigma|+2^0+2^1+...+2^{n-1})=O(|\Sigma|+2^n)$。

- 空间复杂度：$O(2^n)$。由于最坏情况下 $\textit{arr}$ 的所有子集都能构成可行解，这有 $2^n$ 个，这种情况下遍历结束后的 $\textit{masks}$ 的长度为 $2^n$，因此空间复杂度为 $O(2^n)$。