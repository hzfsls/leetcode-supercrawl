#### 方法一：分治

对于字符串 $s$，如果存在某个字符 $\textit{ch}$，它的出现次数大于 $0$ 且小于 $k$，则任何包含 $\textit{ch}$ 的子串都不可能满足要求。也就是说，我们将字符串按照 $\textit{ch}$ 切分成若干段，则满足要求的最长子串一定出现在某个被切分的段内，而不能跨越一个或多个段。因此，可以考虑分治的方式求解本题。

```C++ [sol1-C++]
class Solution {
public:
    int dfs(const string& s, int l, int r, int k) {
        vector<int> cnt(26, 0);
        for (int i = l; i <= r; i++) {
            cnt[s[i] - 'a']++;
        }

        char split = 0;
        for (int i = 0; i < 26; i++) {
            if (cnt[i] > 0 && cnt[i] < k) {
                split = i + 'a';
                break;
            }
        }
        if (split == 0) {
            return r - l + 1;
        }

        int i = l;
        int ret = 0;
        while (i <= r) {
            while (i <= r && s[i] == split) {
                i++;
            }
            if (i > r) {
                break;
            }
            int start = i;
            while (i <= r && s[i] != split) {
                i++;
            }

            int length = dfs(s, start, i - 1, k);
            ret = max(ret, length);
        }
        return ret;
    }

    int longestSubstring(string s, int k) {
        int n = s.length();
        return dfs(s, 0, n - 1, k);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestSubstring(String s, int k) {
        int n = s.length();
        return dfs(s, 0, n - 1, k);
    }

    public int dfs(String s, int l, int r, int k) {
        int[] cnt = new int[26];
        for (int i = l; i <= r; i++) {
            cnt[s.charAt(i) - 'a']++;
        }

        char split = 0;
        for (int i = 0; i < 26; i++) {
            if (cnt[i] > 0 && cnt[i] < k) {
                split = (char) (i + 'a');
                break;
            }
        }
        if (split == 0) {
            return r - l + 1;
        }

        int i = l;
        int ret = 0;
        while (i <= r) {
            while (i <= r && s.charAt(i) == split) {
                i++;
            }
            if (i > r) {
                break;
            }
            int start = i;
            while (i <= r && s.charAt(i) != split) {
                i++;
            }

            int length = dfs(s, start, i - 1, k);
            ret = Math.max(ret, length);
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var longestSubstring = function(s, k) {
    const n = s.length;
    return dfs(s, 0, n - 1, k);
}

const dfs = (s, l, r, k) => {
    const cnt = new Array(26).fill(0);
    for (let i = l; i <= r; i++) {
        cnt[s[i].charCodeAt() - 'a'.charCodeAt()]++;
    }

    let split = 0;
    for (let i = 0; i < 26; i++) {
        if (cnt[i] > 0 && cnt[i] < k) {
            split = String.fromCharCode(i + 'a'.charCodeAt());
            break;
        }
    }
    if (split == 0) {
        return r - l + 1;
    }

    let i = l;
    let ret = 0;
    while (i <= r) {
        while (i <= r && s[i] === split) {
            i++;
        }
        if (i > r) {
            break;
        }
        let start = i;
        while (i <= r && s[i] !== split) {
            i++;
        }

        const length = dfs(s, start, i - 1, k);
        ret = Math.max(ret, length);
    }
    return ret;
};
```

```go [sol1-Golang]
func longestSubstring(s string, k int) (ans int) {
    if s == "" {
        return
    }

    cnt := [26]int{}
    for _, ch := range s {
        cnt[ch-'a']++
    }

    var split byte
    for i, c := range cnt[:] {
        if 0 < c && c < k {
            split = 'a' + byte(i)
            break
        }
    }
    if split == 0 {
        return len(s)
    }

    for _, subStr := range strings.Split(s, string(split)) {
        ans = max(ans, longestSubstring(subStr, k))
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

```C [sol1-C]
int dfs(char* s, int l, int r, int k) {
    int cnt[26];
    memset(cnt, 0, sizeof(cnt));
    for (int i = l; i <= r; i++) {
        cnt[s[i] - 'a']++;
    }

    char split = 0;
    for (int i = 0; i < 26; i++) {
        if (cnt[i] > 0 && cnt[i] < k) {
            split = i + 'a';
            break;
        }
    }
    if (split == 0) {
        return r - l + 1;
    }

    int i = l;
    int ret = 0;
    while (i <= r) {
        while (i <= r && s[i] == split) {
            i++;
        }
        if (i > r) {
            break;
        }
        int start = i;
        while (i <= r && s[i] != split) {
            i++;
        }

        int length = dfs(s, start, i - 1, k);
        ret = fmax(ret, length);
    }
    return ret;
}

int longestSubstring(char* s, int k) {
    return dfs(s, 0, strlen(s) - 1, k);
}
```

**复杂度分析**

- 时间复杂度：$O(N\cdot |\Sigma|)$，其中 $N$ 为字符串的长度，$\Sigma$ 为字符集，本题中字符串仅包含小写字母，因此 $|\Sigma| = 26$。由于每次递归调用都会**完全去除**某个字符，因此递归深度最多为 $|\Sigma|$。

- 空间复杂度：$O(|\Sigma|^2)$。递归的深度为 $O(|\Sigma|)$，每层递归需要开辟 $O(|\Sigma|)$ 的额外空间。

#### 方法二：滑动窗口

我们枚举最长子串中的**字符种类数目**，它最小为 $1$，最大为 $|\Sigma|$（字符集的大小，本题中为 $26$）。

对于给定的字符种类数量 $t$，我们维护滑动窗口的左右边界 $l,r$、滑动窗口内部每个字符出现的次数 $\textit{cnt}$，以及滑动窗口内的字符种类数目 $\textit{total}$。当 $\textit{total} > t$ 时，我们不断地右移左边界 $l$，并对应地更新 $\textit{cnt}$ 以及 $\textit{total}$，直到 $\textit{total} \le t$ 为止。这样，对于任何一个右边界 $r$，我们都能找到最小的 $l$（记为 $l_{min}$），使得 $s[l_{min}...r]$ 之间的字符种类数目不多于 $t$。

对于任何一组 $l_{min}, r$ 而言，如果 $s[l_{min}...r]$ 之间存在某个出现次数小于 $k$ （且不为 $0$，下文不再特殊说明）的字符，我们可以断定：对于任何 $l' \in (l_{min}, r)$ 而言，$s[l'...r]$ 依然不可能是满足题意的子串，因为：
- 要么该字符的出现次数降为 $0$，此时子串内虽然少了一个出现次数小于 $k$ 的字符，但字符种类数目也随之小于 $t$ 了；
- 要么该字符的出现次数降为非 $0$ 整数，此时该字符的出现次数依然小于 $k$。

根据上面的结论，我们发现：当限定字符种类数目为 $t$ 时，满足题意的最长子串，就一定出自某个 $s[l_{min}...r]$。因此，在滑动窗口的维护过程中，就可以直接得到最长子串的大小。

此外还剩下一个细节：如何判断某个子串内的字符是否都出现了至少 $k$ 次？我们当然可以每次遍历 $\textit{cnt}$ 数组，但是这会带来 $O(|\Sigma|)$ 的额外开销。

我们可以维护一个计数器 $\textit{less}$，代表当前出现次数小于 $k$ 的字符的数量。注意到：每次移动滑动窗口的边界时，只会让某个字符的出现次数加一或者减一。对于移动右边界 $l$ 的情况而言：

- 当某个字符的出现次数从 $0$ 增加到 $1$ 时，将 $\textit{less}$ 加一；

- 当某个字符的出现次数从 $k-1$ 增加到 $k$ 时，将 $\textit{less}$ 减一。

对于移动左边界的情形，讨论是类似的。

通过维护额外的计数器 $\textit{less}$，我们无需遍历 $\textit{cnt}$ 数组，就能知道每个字符是否都出现了至少 $k$ 次，同时可以在每次循环时，在常数时间内更新计数器的取值。读者可以自行思考 $k=1$ 时的处理逻辑。

```C++ [sol2-C++]
class Solution {
public:
    int longestSubstring(string s, int k) {
        int ret = 0;
        int n = s.length();
        for (int t = 1; t <= 26; t++) {
            int l = 0, r = 0;
            vector<int> cnt(26, 0);
            int tot = 0;
            int less = 0;
            while (r < n) {
                cnt[s[r] - 'a']++;
                if (cnt[s[r] - 'a'] == 1) {
                    tot++;
                    less++;
                }
                if (cnt[s[r] - 'a'] == k) {
                    less--;
                }

                while (tot > t) {
                    cnt[s[l] - 'a']--;
                    if (cnt[s[l] - 'a'] == k - 1) {
                        less++;
                    }
                    if (cnt[s[l] - 'a'] == 0) {
                        tot--;
                        less--;
                    }
                    l++;
                }
                if (less == 0) {
                    ret = max(ret, r - l + 1);
                }
                r++;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int longestSubstring(String s, int k) {
        int ret = 0;
        int n = s.length();
        for (int t = 1; t <= 26; t++) {
            int l = 0, r = 0;
            int[] cnt = new int[26];
            int tot = 0;
            int less = 0;
            while (r < n) {
                cnt[s.charAt(r) - 'a']++;
                if (cnt[s.charAt(r) - 'a'] == 1) {
                    tot++;
                    less++;
                }
                if (cnt[s.charAt(r) - 'a'] == k) {
                    less--;
                }

                while (tot > t) {
                    cnt[s.charAt(l) - 'a']--;
                    if (cnt[s.charAt(l) - 'a'] == k - 1) {
                        less++;
                    }
                    if (cnt[s.charAt(l) - 'a'] == 0) {
                        tot--;
                        less--;
                    }
                    l++;
                }
                if (less == 0) {
                    ret = Math.max(ret, r - l + 1);
                }
                r++;
            }
        }
        return ret;
    }
}
```

```JavaScript [sol2-JavaScript]
var longestSubstring = function(s, k) {
    let ret = 0;
    const n = s.length;
    for (let t = 1; t <= 26; t++) {
        let l = 0, r = 0;
        const cnt = new Array(26).fill(0);
        let tot = 0;
        let less = 0;
        while (r < n) {
            cnt[s[r].charCodeAt() - 'a'.charCodeAt()]++;
            if (cnt[s[r].charCodeAt() - 'a'.charCodeAt()] === 1) {
                tot++;
                less++;
            }
            if (cnt[s[r].charCodeAt() - 'a'.charCodeAt()] === k) {
                less--;
            }

            while (tot > t) {
                cnt[s[l].charCodeAt() - 'a'.charCodeAt()]--;
                if (cnt[s[l].charCodeAt() - 'a'.charCodeAt()] === k - 1) {
                    less++;
                }
                if (cnt[s[l].charCodeAt() - 'a'.charCodeAt()] === 0) {
                    tot--;
                    less--;
                }
                l++;
            }
            if (less == 0) {
                ret = Math.max(ret, r - l + 1);
            }
            r++;
        }
    }
    return ret;
};
```

```go [sol2-Golang]
func longestSubstring(s string, k int) (ans int) {
    for t := 1; t <= 26; t++ {
        cnt := [26]int{}
        total := 0
        lessK := 0
        l := 0
        for r, ch := range s {
            ch -= 'a'
            if cnt[ch] == 0 {
                total++
                lessK++
            }
            cnt[ch]++
            if cnt[ch] == k {
                lessK--
            }

            for total > t {
                ch := s[l] - 'a'
                if cnt[ch] == k {
                    lessK++
                }
                cnt[ch]--
                if cnt[ch] == 0 {
                    total--
                    lessK--
                }
                l++
            }
            if lessK == 0 {
                ans = max(ans, r-l+1)
            }
        }
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int longestSubstring(char* s, int k) {
    int ret = 0;
    int n = strlen(s);
    for (int t = 1; t <= 26; t++) {
        int l = 0, r = 0;
        int cnt[26];
        memset(cnt, 0, sizeof(cnt));
        int tot = 0;
        int less = 0;
        while (r < n) {
            cnt[s[r] - 'a']++;
            if (cnt[s[r] - 'a'] == 1) {
                tot++;
                less++;
            }
            if (cnt[s[r] - 'a'] == k) {
                less--;
            }

            while (tot > t) {
                cnt[s[l] - 'a']--;
                if (cnt[s[l] - 'a'] == k - 1) {
                    less++;
                }
                if (cnt[s[l] - 'a'] == 0) {
                    tot--;
                    less--;
                }
                l++;
            }
            if (less == 0) {
                ret = fmax(ret, r - l + 1);
            }
            r++;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(N \cdot |\Sigma| + |\Sigma|^2)$，其中 $N$ 为字符串的长度，$\Sigma$ 为字符集，本题中字符串仅包含小写字母，因此 $|\Sigma| = 26$。我们需要遍历所有可能的 $t$，共 $|\Sigma|$ 种可能性；内层循环中滑动窗口的复杂度为 $O(N)$，且初始时需要 $O(|\Sigma|)$ 的时间初始化 $\textit{cnt}$ 数组。

- 空间复杂度：$O(|\Sigma|)$。