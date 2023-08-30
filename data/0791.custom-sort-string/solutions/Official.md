#### 方法一：自定义排序

**思路与算法**

最简单的方法是直接对字符串 $s$ 进行排序。

我们首先遍历给定的字符串 $\textit{order}$，将第一个出现的字符的权值赋值为 $1$，第二个出现的字符的权值赋值为 $2$，以此类推。在遍历完成之后，所有未出现字符的权值默认赋值为 $0$。

随后我们根据权值表，对字符串 $s$ 进行排序，即可得到一种满足要求的排列方案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string customSortString(string order, string s) {
        vector<int> val(26);
        for (int i = 0; i < order.size(); ++i) {
            val[order[i] - 'a'] = i + 1;
        }
        sort(s.begin(), s.end(), [&](char c0, char c1) {
            return val[c0 - 'a'] < val[c1 - 'a'];
        });
        return s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String customSortString(String order, String s) {
        int[] val = new int[26];
        for (int i = 0; i < order.length(); ++i) {
            val[order.charAt(i) - 'a'] = i + 1;
        }
        Character[] arr = new Character[s.length()];
        for (int i = 0; i < s.length(); ++i) {
            arr[i] = s.charAt(i);
        }
        Arrays.sort(arr, (c0, c1) -> val[c0 - 'a'] - val[c1 - 'a']);
        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < s.length(); ++i) {
            ans.append(arr[i]);
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string CustomSortString(string order, string s) {
        int[] val = new int[26];
        for (int i = 0; i < order.Length; ++i) {
            val[order[i] - 'a'] = i + 1;
        }
        char[] arr = s.ToCharArray();
        Array.Sort(arr, (c0, c1) => val[c0 - 'a'] - val[c1 - 'a']);
        return new string(arr);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def customSortString(self, order: str, s: str) -> str:
        val = defaultdict(int)
        for i, ch in enumerate(order):
            val[ch] = i + 1
        
        return "".join(sorted(s, key=lambda ch: val[ch]))
```

```C [sol1-C]
int val[26];

int cmp(const void *pa, const void *pb) {
    return val[*(char *)pa - 'a'] - val[*(char *)pb - 'a'];
}

char * customSortString(char * order, char * s) {
    memset(val, 0, sizeof(val));
    for (int i = 0; order[i] != '\0'; ++i) {
        val[order[i] - 'a'] = i + 1;
    }
    qsort(s, strlen(s), sizeof(char), cmp);
    return s;
}
```

```go [sol1-Golang]
func customSortString(order, s string) string {
    val := map[byte]int{}
    for i, c := range order {
        val[byte(c)] = i + 1
    }
    t := []byte(s)
    sort.Slice(t, func(i, j int) bool { return val[t[i]] < val[t[j]] })
    return string(t)
}
```

```JavaScript [sol1-JavaScript]
var customSortString = function(order, s) {
    const val = new Array(26).fill(0);
    for (let i = 0; i < order.length; ++i) {
        val[order[i].charCodeAt() - 'a'.charCodeAt()] = i + 1;
    }
    const arr = new Array(s.length).fill(0).map((_, i) => s[i]);
    arr.sort((c0, c1) => val[c0.charCodeAt() - 'a'.charCodeAt()] - val[c1.charCodeAt() - 'a'.charCodeAt()])
    let ans = '';
    for (let i = 0; i < s.length; ++i) {
        ans += arr[i];
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n + |\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。

    - 排序的时间复杂度为 $O(n \log n)$；
    - 如果我们使用数组存储权值，数组的大小为 $O(|\Sigma|)$；如果我们使用哈希表存储权值，哈希表的大小与字符串 $s$ 和 $\textit{order}$ 中出现的字符种类数相同，为叙述方便也可以记为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$。即为数组或哈希表需要使用的空间。

#### 方法二：计数排序

**思路与算法**

由于字符集的大小为 $26$，我们也可以考虑使用计数排序代替普通的排序方法。

我们首先遍历字符串 $s$，使用数组或哈希表统计每个字符出现的次数。随后遍历字符串 $\textit{order}$ 中的每个字符 $c$，如果其在 $s$ 中出现了 $k$ 次，就在答案的末尾添加 $k$ 个 $c$，并将数组或哈希表中对应的次数置为 $0$。最后我们遍历一次哈希表，对于所有次数 $k$ 非 $0$ 的键值对 $(c, k)$，在答案的末尾添加 $k$ 个 $c$ 即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    string customSortString(string order, string s) {
        vector<int> freq(26);
        for (char ch: s) {
            ++freq[ch - 'a'];
        }
        string ans;
        for (char ch: order) {
            if (freq[ch - 'a'] > 0) {
                ans += string(freq[ch - 'a'], ch);
                freq[ch - 'a'] = 0;
            }
        }
        for (int i = 0; i < 26; ++i) {
            if (freq[i] > 0) {
                ans += string(freq[i], i + 'a');
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String customSortString(String order, String s) {
        int[] freq = new int[26];
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            ++freq[ch - 'a'];
        }
        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < order.length(); ++i) {
            char ch = order.charAt(i);
            while (freq[ch - 'a'] > 0) {
                ans.append(ch);
                freq[ch - 'a']--;
            }
        }
        for (int i = 0; i < 26; ++i) {
            while (freq[i] > 0) {
                ans.append((char) (i + 'a'));
                freq[i]--;
            }
        }
        return ans.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string CustomSortString(string order, string s) {
        int[] freq = new int[26];
        foreach (char ch in s) {
            ++freq[ch - 'a'];
        }
        StringBuilder ans = new StringBuilder();
        foreach (char ch in order) {
            while (freq[ch - 'a'] > 0) {
                ans.Append(ch);
                freq[ch - 'a']--;
            }
        }
        for (int i = 0; i < 26; ++i) {
            while (freq[i] > 0) {
                ans.Append((char) (i + 'a'));
                freq[i]--;
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def customSortString(self, order: str, s: str) -> str:
        freq = Counter(s)
        ans = list()
        for ch in order:
            if ch in freq:
                ans.extend([ch] * freq[ch])
                freq[ch] = 0
        for (ch, k) in freq.items():
            if k > 0:
                ans.extend([ch] * k)
        return "".join(ans)
```

```C [sol2-C]
char * customSortString(char * order, char * s) {
    int freq[26];
    memset(freq, 0, sizeof(freq));
    for (int i = 0; s[i] != '\0'; i++) {
        ++freq[s[i] - 'a'];
    }
    char *ans = (char *)malloc(sizeof(char) * (strlen(s) + 1));
    int pos = 0;
    for (int i = 0; order[i] != '\0'; i++) {
        if (freq[order[i] - 'a'] > 0) {
            for (int j = 0; j < freq[order[i] - 'a']; j++) {
                ans[pos++] = order[i];
            }
            freq[order[i] - 'a'] = 0;
        }
    }
    for (int i = 0; i < 26; ++i) {
        if (freq[i] > 0) {
            for (int j = 0; j < freq[i]; j++) {
                ans[pos++] = i + 'a';
            }
        }
    }
    ans[pos] = '\0';
    return ans;
}
```

```go [sol2-Golang]
func customSortString(order, s string) string {
    freq := [26]int{}
    for _, c := range s {
        freq[c-'a']++
    }
    t := &strings.Builder{}
    for _, c := range order {
        if freq[c-'a'] > 0 {
            t.WriteString(strings.Repeat(string(c), freq[c-'a']))
            freq[c-'a'] = 0
        }
    }
    for i, k := range freq {
        if k > 0 {
            t.WriteString(strings.Repeat(string('a'+i), k))
        }
    }
    return t.String()
}
```

```JavaScript [sol2-JavaScript]
var customSortString = function(order, s) {
    const freq = new Array(26).fill(0);
    for (let i = 0; i < s.length; ++i) {
        const ch = s[i];
        ++freq[ch.charCodeAt() - 'a'.charCodeAt()];
    }
    let ans = '';
    for (let i = 0; i < order.length; ++i) {
        const ch = order[i];
        while (freq[ch.charCodeAt() - 'a'.charCodeAt()] > 0) {
            ans += ch;
            freq[ch.charCodeAt() - 'a'.charCodeAt()]--;
        }
    }
    for (let i = 0; i < 26; ++i) {
        while (freq[i] > 0) {
            ans += String.fromCharCode(i + 'a'.charCodeAt());
            freq[i]--;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。

- 空间复杂度：$O(|\Sigma|)$。即为数组或哈希表需要使用的空间。