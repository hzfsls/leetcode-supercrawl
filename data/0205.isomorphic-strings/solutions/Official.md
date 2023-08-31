## [205.同构字符串 中文官方题解](https://leetcode.cn/problems/isomorphic-strings/solutions/100000/tong-gou-zi-fu-chuan-by-leetcode-solutio-s6fd)
#### 方法一：哈希表

此题是「[290. 单词规律](https://leetcode-cn.com/problems/word-pattern/)」的简化版，需要我们判断 $s$ 和 $t$ 每个位置上的字符是否都一一对应，即 $s$ 的任意一个字符被 $t$ 中唯一的字符对应，同时 $t$ 的任意一个字符被 $s$ 中唯一的字符对应。这也被称为「双射」的关系。

以示例 $2$ 为例，$t$ 中的字符 $a$ 和 $r$ 虽然有唯一的映射 $o$，但对于 $s$ 中的字符 $o$ 来说其存在两个映射 $\{a,r\}$，故不满足条件。

因此，我们维护两张哈希表，第一张哈希表 $\textit{s2t}$ 以 $s$ 中字符为键，映射至 $t$ 的字符为值，第二张哈希表 $\textit{t2s}$ 以 $t$ 中字符为键，映射至 $s$ 的字符为值。从左至右遍历两个字符串的字符，不断更新两张哈希表，如果出现冲突（即当前下标 $\textit{index}$ 对应的字符 $s[\textit{index}]$ 已经存在映射且不为 $t[\textit{index}]$ 或当前下标 $\textit{index}$ 对应的字符 $t[\textit{index}]$ 已经存在映射且不为 $s[\textit{index}]$）时说明两个字符串无法构成同构，返回 $\rm false$。

如果遍历结束没有出现冲突，则表明两个字符串是同构的，返回 $\rm true$ 即可。

```C++ [sol1-C++]
class Solution {
public:
    bool isIsomorphic(string s, string t) {
        unordered_map<char, char> s2t;
        unordered_map<char, char> t2s;
        int len = s.length();
        for (int i = 0; i < len; ++i) {
            char x = s[i], y = t[i];
            if ((s2t.count(x) && s2t[x] != y) || (t2s.count(y) && t2s[y] != x)) {
                return false;
            }
            s2t[x] = y;
            t2s[y] = x;
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isIsomorphic(String s, String t) {
        Map<Character, Character> s2t = new HashMap<Character, Character>();
        Map<Character, Character> t2s = new HashMap<Character, Character>();
        int len = s.length();
        for (int i = 0; i < len; ++i) {
            char x = s.charAt(i), y = t.charAt(i);
            if ((s2t.containsKey(x) && s2t.get(x) != y) || (t2s.containsKey(y) && t2s.get(y) != x)) {
                return false;
            }
            s2t.put(x, y);
            t2s.put(y, x);
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var isIsomorphic = function(s, t) {
    const s2t = {};
    const t2s = {};
    const len = s.length;
    for (let i = 0; i < len; ++i) {
        const x = s[i], y = t[i];
        if ((s2t[x] && s2t[x] !== y) || (t2s[y] && t2s[y] !== x)) {
            return false;
        }
        s2t[x] = y;
        t2s[y] = x;
    }
    return true;
};
```

```go [sol1-Golang]
func isIsomorphic(s, t string) bool {
    s2t := map[byte]byte{}
    t2s := map[byte]byte{}
    for i := range s {
        x, y := s[i], t[i]
        if s2t[x] > 0 && s2t[x] != y || t2s[y] > 0 && t2s[y] != x {
            return false
        }
        s2t[x] = y
        t2s[y] = x
    }
    return true
}
```

```C [sol1-C]
struct HashTable {
    char key;
    char val;
    UT_hash_handle hh;
};

bool isIsomorphic(char* s, char* t) {
    struct HashTable* s2t = NULL;
    struct HashTable* t2s = NULL;
    int len = strlen(s);
    for (int i = 0; i < len; ++i) {
        char x = s[i], y = t[i];
        struct HashTable *tmp1, *tmp2;
        HASH_FIND(hh, s2t, &x, sizeof(char), tmp1);
        HASH_FIND(hh, t2s, &y, sizeof(char), tmp2);
        if (tmp1 != NULL) {
            if (tmp1->val != y) {
                return false;
            }
        } else {
            tmp1 = malloc(sizeof(struct HashTable));
            tmp1->key = x;
            tmp1->val = y;
            HASH_ADD(hh, s2t, key, sizeof(char), tmp1);
        }
        if (tmp2 != NULL) {
            if (tmp2->val != x) {
                return false;
            }
        } else {
            tmp2 = malloc(sizeof(struct HashTable));
            tmp2->key = y;
            tmp2->val = x;
            HASH_ADD(hh, t2s, key, sizeof(char), tmp2);
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。我们只需同时遍历一遍字符串 $s$ 和 $t$ 即可。
- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符串的字符集。哈希表存储字符的空间取决于字符串的字符集大小，最坏情况下每个字符均不相同，需要 $O(|\Sigma|)$ 的空间。