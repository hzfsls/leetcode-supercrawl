## [1234.替换子串得到平衡字符串 中文官方题解](https://leetcode.cn/problems/replace-the-substring-for-balanced-string/solutions/100000/ti-huan-zi-chuan-de-dao-ping-heng-zi-fu-f8fk8)

#### 方法一：滑动窗口

**思路与算法**

设 $\textit{partial} = \dfrac{n}{4}$，我们选择 $s$ 的一个子串作为「待替换子串」，只有当 $s$ 剩余的部分中 $\text{`Q'}$，$\text{`W'}$，$\text{`E'}$，$\text{`R'}$ 的出现次数都小于等于 $\textit{partial}$ 时，我们才有可能使 $s$ 变为「平衡字符串」。

如果原始的 $s$ 就是 「平衡字符串」，我们直接返回 $0$，否则我们按照以下思路求解。

从小到大枚举「待替换子串」的左端点 $l$，为了使得替换的长度最小，我们要找到最近的右端点 $r$，使得去除 $[l,r)$ 之后的剩余部分满足上述条件。不难发现，随着 $l$ 的递增，$r$ 也是递增的。

具体的，我们使用滑动窗口来维护区间 $[l, r)$ 之外的剩余部分中 $\text{`Q'}$，$\text{`W'}$，$\text{`E'}$，$\text{`R'}$ 的出现次数，当其中一种字符的出现次数大于 $\textit{partial}$ 时，令 $s[r]$ 的出现次数减 $1$，并使得 $r$ 向右移动一个单位。该操作一直被执行，直到条件被满足或者 $r$ 到达 $s$ 的末尾。

如果找到了使得条件被满足的 $r$，我们用 $r - l$ 来更新答案，然后令 $s[l]$ 的出现次数加 $1$，并使得 $l$ 向右移动一个单位进行下一次枚举。否则，后序的 $l$ 也将不会有合法的 $r$，此时我们可以直接跳出循环。对于所有合法的 $[l, r)$，取 $r - l$ 的最小值做为答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def balancedString(self, s: str) -> int:
        cnt = Counter(s)
        partial = len(s) // 4

        def check():
            if cnt['Q'] > partial or \
                    cnt['W'] > partial or \
                    cnt['E'] > partial or \
                    cnt['R'] > partial:
                return False
            return True

        if check():
            return 0

        res = len(s)
        r = 0
        for l, c in enumerate(s):
            while r < len(s) and not check():
                cnt[s[r]] -= 1
                r += 1
            if not check():
                break
            res = min(res, r - l)
            cnt[c] += 1
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int idx(const char& c) {
        return c - 'A';
    }

    int balancedString(string s) {
        vector<int> cnt(26);
        for (auto c : s) {
            cnt[idx(c)]++;
        }

        int partial = s.size() / 4;
        int res = s.size();
        auto check = [&]() {
            if (cnt[idx('Q')] > partial || cnt[idx('W')] > partial \
                || cnt[idx('E')] > partial || cnt[idx('R')] > partial) {
                return false;
            }
            return true;
        };

        if (check()) {
            return 0;
        }
        for (int l = 0, r = 0; l < s.size(); l++) {
            while (r < s.size() && !check()) {
                cnt[idx(s[r])]--;
                r++;
            }
            if (!check()) {
                break;
            }
            res = min(res, r - l);
            cnt[idx(s[l])]++;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int balancedString(String s) {
        int[] cnt = new int[26];
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            cnt[idx(c)]++;
        }

        int partial = s.length() / 4;
        int res = s.length();

        if (check(cnt, partial)) {
            return 0;
        }
        for (int l = 0, r = 0; l < s.length(); l++) {
            while (r < s.length() && !check(cnt, partial)) {
                cnt[idx(s.charAt(r))]--;
                r++;
            }
            if (!check(cnt, partial)) {
                break;
            }
            res = Math.min(res, r - l);
            cnt[idx(s.charAt(l))]++;
        }
        return res;
    }

    public int idx(char c) {
        return c - 'A';
    }

    public boolean check(int[] cnt, int partial) {
        if (cnt[idx('Q')] > partial || cnt[idx('W')] > partial || cnt[idx('E')] > partial || cnt[idx('R')] > partial) {
            return false;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BalancedString(string s) {
        int[] cnt = new int[26];
        foreach (char c in s) {
            cnt[Idx(c)]++;
        }

        int partial = s.Length / 4;
        int res = s.Length;

        if (Check(cnt, partial)) {
            return 0;
        }
        for (int l = 0, r = 0; l < s.Length; l++) {
            while (r < s.Length && !Check(cnt, partial)) {
                cnt[Idx(s[r])]--;
                r++;
            }
            if (!Check(cnt, partial)) {
                break;
            }
            res = Math.Min(res, r - l);
            cnt[Idx(s[l])]++;
        }
        return res;
    }

    public int Idx(char c) {
        return c - 'A';
    }

    public bool Check(int[] cnt, int partial) {
        if (cnt[Idx('Q')] > partial || cnt[Idx('W')] > partial || cnt[Idx('E')] > partial || cnt[Idx('R')] > partial) {
            return false;
        }
        return true;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static inline int idx(const char c) {
    return c - 'A';
}

bool check(const int *cnt, int partial) {
    if (cnt[idx('Q')] > partial || cnt[idx('W')] > partial || \
        cnt[idx('E')] > partial || cnt[idx('R')] > partial) {
        return false;
    }
    return true;
};

int balancedString(char * s) {
    int cnt[26];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; s[i] != '\0'; i++) {
        cnt[idx(s[i])]++;
    }

    int len = strlen(s);
    int partial = len / 4;
    int res = len;
    if (check(cnt, partial)) {
        return 0;
    }
    
    for (int l = 0, r = 0; l < len; l++) {
        while (r < len && !check(cnt, partial)) {
            cnt[idx(s[r])]--;
            r++;
        }
        if (!check(cnt, partial)) {
            break;
        }
        res = MIN(res, r - l);
        cnt[idx(s[l])]++;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var balancedString = function(s) {
    const cnt = new Array(26).fill(0);
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        cnt[idx(c)]++;
    }

    const partial = s.length / 4;
    let res = s.length;

    if (check(cnt, partial)) {
        return 0;
    }
    for (let l = 0, r = 0; l < s.length; l++) {
        while (r < s.length && !check(cnt, partial)) {
            cnt[idx(s[r])]--;
            r++;
        }
        if (!check(cnt, partial)) {
            break;
        }
        res = Math.min(res, r - l);
        cnt[idx(s[l])]++;
    }
    return res;
}

const idx = (c) => {
    return c.charCodeAt() - 'A'.charCodeAt();
}

const check = (cnt, partial) => {
    if (cnt[idx('Q')] > partial || cnt[idx('W')] > partial || cnt[idx('E')] > partial || cnt[idx('R')] > partial) {
        return false;
    }
    return true;
};
```

```go [sol1-Golang]
func balancedString(s string) int {
    cnt := map[byte]int{}
    for _, c := range s {
        cnt[byte(c)]++
    }
    partial := len(s) / 4
    check := func() bool {
        if cnt['Q'] > partial ||
            cnt['W'] > partial ||
            cnt['E'] > partial ||
            cnt['R'] > partial {
            return false
        }
        return true
    }

    if check() {
        return 0
    }

    res := len(s)
    r := 0
    for l, c := range s {
        for r < len(s) && !check() {
            cnt[s[r]]--
            r += 1
        }
        if !check() {
            break
        }
        res = min(res, r-l)
        cnt[byte(c)]++
    }
    return res
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。

- 空间复杂度：$O(|\Sigma|)$，其中 $|\Sigma|$ 表示字符集大小，在本题中 $|\Sigma|=26$。