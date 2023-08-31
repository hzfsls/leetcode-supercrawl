## [1016.子串能表示从 1 到 N 数字的二进制串 中文官方题解](https://leetcode.cn/problems/binary-string-with-substrings-representing-1-to-n/solutions/100000/zi-chuan-neng-biao-shi-cong-1-dao-n-shu-ojtz8)
#### 方法一：数学 + 滑动窗口 + 哈希表

**思路与算法**

题目给定一个二进制字符串 $s$ 和一个正整数 $n$。我们需要判断 $1$ 到 $n$ 中的每一个整数是否都是 $s$ 的子字符串。

设 $[l, r]$ 表示大于等于 $l$ 且小于等于 $r$ 范围内的整数，对于 $n > 1$，一定存在 $k \in \mathbb{N^+}$，使得 $2^k \le n < 2^{k + 1}$。那么对于 $[2^{k-1}, 2^{k}-1]$ 内的数，它们都小于 $n$，且二进制表示都为 $k$ 位，所以字符串 $s$ 中至少需要有 $2^{k-1}$ 个长度为 $k$ 的不同二进制数。记字符串 $s$ 的长度为 $m$，则 $m$ 至少需要满足：

$$m \ge 2 ^ {k - 1} + k - 1$$

同理在 $[2^k, n]$ 内的数，二进制表示都为 $k + 1$ 位，所以 $m$ 同样需要满足：

$$m \ge n - 2^k + k + 1$$

若上述两个条件不满足，则可以直接返回 $\text{False}$，否则，因为题目给定 $m \le 1000$，所以此时 $k$ 一定不大于 $11$。又因为若 $s$ 的子串能包含 $[2^{k-1}, 2^k-1]$ 全部二进制表示，则一定可以包含 $[1, 2^k-1]$ 全部二进制表示。因为我们可以将 $[2^{k-1}, 2^k-1]$ 中数的二进制表示中的最高位的 $1$ 去掉并去掉对应的前导零，便可以得到 $[0, 2^{k-1} - 1]$ 的全部二进制表示。

> 比如若当前 $s$ 的子串能包含 $[4, 7]$ 全部的二进制表示，即有子串中有 $100, 101, 110, 111$，那么去掉每一个数的最高位和前导零可以得到 $[0, 3]$ 的全部二进制表示 $0, 1, 10, 11$。

所以我们对字符串 $s$ 判断是否存在 $[2^{k-1}, 2^k-1]$ 和 $[2^k, n]$ 的全部二进制表示即可。我们可以分别用长度为 $k$ 和 $k + 1$ 的「滑动窗口」来枚举 $s$ 中全部长度为 $k$ 和 $k + 1$ 的子串，将其加入哈希表，并判断哈希表中是否存在 $[2^{k-1}, n]$ 中的全部数即可。

以上的分析都在 $n > 1$ 的基础上，当 $n = 1$ 时，我们只需要判断 $\text{`1'}$ 是否在 $s$ 中即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool help(const string& s, int k, int mi, int ma) {
        unordered_set<int> st;
        int t = 0;
        for (int r = 0; r < s.size(); ++r) {
            t = t * 2 + (s[r] - '0');
            if (r >= k) {
                t -= (s[r - k] - '0') << k;
            }
            if (r >= k - 1 && t >= mi && t <= ma) {
                st.insert(t);
            }
        }
        return st.size() == ma - mi + 1;
    }

    bool queryString(string s, int n) {
        if (n == 1) {
            return s.find('1') != -1;
        }
        int k = 30;
        while ((1 << k) > n) {
            --k;
        }
        if (s.size() < (1 << (k - 1)) + k - 1 || s.size() < n - (1 << k) + k + 1) {
            return false;
        }
        return help(s, k, 1 << (k - 1), (1 << k) - 1) && help(s, k + 1, 1 << k, n);
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean queryString(String s, int n) {
        if (n == 1) {
            return s.indexOf('1') != -1;
        }
        int k = 30;
        while ((1 << k) > n) {
            --k;
        }
        if (s.length() < (1 << (k - 1)) + k - 1 || s.length() < n - (1 << k) + k + 1) {
            return false;
        }
        return help(s, k, 1 << (k - 1), (1 << k) - 1) && help(s, k + 1, 1 << k, n);
    }

    public boolean help(String s, int k, int mi, int ma) {
        Set<Integer> set = new HashSet<Integer>();
        int t = 0;
        for (int r = 0; r < s.length(); ++r) {
            t = t * 2 + (s.charAt(r) - '0');
            if (r >= k) {
                t -= (s.charAt(r - k) - '0') << k;
            }
            if (r >= k - 1 && t >= mi && t <= ma) {
                set.add(t);
            }
        }
        return set.size() == ma - mi + 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool QueryString(string s, int n) {
        if (n == 1) {
            return s.IndexOf('1') != -1;
        }
        int k = 30;
        while ((1 << k) > n) {
            --k;
        }
        if (s.Length < (1 << (k - 1)) + k - 1 || s.Length < n - (1 << k) + k + 1) {
            return false;
        }
        return Help(s, k, 1 << (k - 1), (1 << k) - 1) && Help(s, k + 1, 1 << k, n);
    }

    public bool Help(string s, int k, int mi, int ma) {
        ISet<int> set = new HashSet<int>();
        int t = 0;
        for (int r = 0; r < s.Length; ++r) {
            t = t * 2 + (s[r] - '0');
            if (r >= k) {
                t -= (s[r - k] - '0') << k;
            }
            if (r >= k - 1 && t >= mi && t <= ma) {
                set.Add(t);
            }
        }
        return set.Count == ma - mi + 1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def queryString(self, s: str, n: int) -> bool:
        def help(s, k, mi, ma):
            st = set()
            t = 0
            for r in range(len(s)):
                t = t * 2 + (int)(s[r])
                if r >= k:
                    t -= int(s[r - k]) << k
                if r >= k - 1 and t >= mi and t <= ma:
                    st.add(t)
            return len(st) == ma - mi + 1
        if n == 1:
            return s.find('1') != -1
        k = 30
        while (1 << k) >= n:
            k -= 1
        if len(s) < (1 << (k - 1)) + k - 1 or len(s) < n - (1 << k) + k + 1:
            return False
        return help(s, k, 1 << (k - 1), (1 << k) - 1) and help(s, k + 1, 1 << k, n)

```

```Go [sol1-Go]
func help(s string, k int, mi int, ma int) bool {
    st := map[int]struct{}{}
    t := 0
    for r := 0; r < len(s); r++ {
        t = (t << 1) + int(s[r] - '0')
        if r >= k {
            t -= int(s[r - k] - '0') << k
        }
        if r >= k - 1 && t >= mi && t <= ma {
            st[t] = struct{}{}
        }
    }
    return len(st) == ma - mi + 1
}

func queryString(s string, n int) bool {
    if n == 1 {
        return strings.Contains(s, "1")
    }
    k := 30
    for (1 << k) >= n {
        k--
    }
    if len(s) < (1 << (k - 1)) + k - 1 || len(s) < n - (1 << k) + k + 1 {
        return false
    }
    return help(s, k, 1 << (k - 1), (1 << k) - 1) && help(s, k + 1, 1 << k, n)
}
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

bool help(const char* s, int k, int mi, int ma) {
    HashItem *st = NULL;
    int t = 0;
    for (int r = 0; s[r] != '\0'; ++r) {
        t = t * 2 + (s[r] - '0');
        if (r >= k) {
            t -= (s[r - k] - '0') << k;
        }
        if (r >= k - 1 && t >= mi && t <= ma) {
            hashAddItem(&st, t);
        }
    }
    int count = HASH_COUNT(st);
    hashFree(&st);
    return count == ma - mi + 1;
}

bool queryString(char * s, int n) {
    int len = strlen(s);
    if (n == 1) {
        return strchr(s, '1') != NULL;
    }
    int k = 30;
    while ((1 << k) > n) {
        --k;
    }
    if (len < (1 << (k - 1)) + k - 1 || len < n - (1 << k) + k + 1) {
        return false;
    }
    return help(s, k, 1 << (k - 1), (1 << k) - 1) && help(s, k + 1, 1 << k, n);
}
```

```JavaScript [sol1-JavaScript]
var queryString = function(s, n) {
    if (n === 1) {
        return [...s].indexOf('1') !== -1;
    }
    let k = 30;
    while ((1 << k) > n) {
        --k;
    }
    if (s.length < (1 << (k - 1)) + k - 1 || s.length < n - (1 << k) + k + 1) {
        return false;
    }
    return help(s, k, 1 << (k - 1), (1 << k) - 1) && help(s, k + 1, 1 << k, n);
}

const help = (s, k, mi, ma) => {
    const set = new Set();
    let t = 0;
    for (let r = 0; r < s.length; ++r) {
        t = t * 2 + (s[r].charCodeAt() - '0'.charCodeAt());
        if (r >= k) {
            t -= (s[r - k].charCodeAt() - '0'.charCodeAt()) << k;
        }
        if (r >= k - 1 && t >= mi && t <= ma) {
            set.add(t);
        }
    }
    return set.size === ma - mi + 1;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n + m)$，其中 $m$ 为字符串 $s$ 的长度。$k$ 的求解时间开销为 $O(\log n)$，「滑动窗口」枚举字符串 $s$ 每一个 $k$ 和 $k + 1$ 子串的时间开销为 $O(m)$。
- 空间复杂度：$O(m)$，其中 $m$ 为字符串 $s$ 的长度，主要为哈希表的空间开销。