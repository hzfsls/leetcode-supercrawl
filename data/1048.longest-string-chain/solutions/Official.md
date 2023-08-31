## [1048.最长字符串链 中文官方题解](https://leetcode.cn/problems/longest-string-chain/solutions/100000/zui-chang-zi-fu-chuan-lian-by-leetcode-s-4uoe)

#### 方法一：动态规划

**思路与算法**

根据题意可知，对于字符串「前身」的定义为：
+ 不改变其他字符的顺序 ，在 $\textit{wordA}$ 的任何地方添加恰好一个字母使其变成 $\textit{wordB}$，那么我们认为 $\textit{wordA}$ 是 $\textit{wordB}$ 的前身。
+ 将 $\textit{wordB}$ 中去掉任意一个字母，其余字符保持不变构成的字符串即为 $\textit{wordB}$ 的前身。

因此对于每个字符串 $s$，假设其所有的前身 $s'$ 为结尾的最长链的长度为 $l$，即可知道以 $s$ 为结尾的最长链的长度为 $l + 1$。为保证我们求 $s$ 的最长链时，其所有的前身的最长链的长度均已求出，需要将所有的字符串按照长度大小进行排序。假设字符串 $s$ 最长链的长度为 $\textit{cnt}(s)$ 的前身为 $s'_{0},s'_{1},s'_{2}, \cdots,s'_{k}$，则此时可以知道

$$
\textit{cnt}(s) = \max(\textit{cnt}(s'_{i})), \quad i \in [0,k]
$$

根据以上结论，实际计算过程如下：
+ 首先对字符串数组 $\textit{words}$ 按照字符串长度的大小进行排序；
+ 依次遍历每个字符串 $\textit{words}[i]$，并初始以 $\textit{words}[i]$ 为结尾的最长链的长度 $\textit{cnt}[\textit{words}[i]]$ 为 $1$；
+ 依次尝试去掉 $\textit{words}[i]$ 中的每个字符，并构成其可能的前身 $\textit{prev}$，在哈希表 $\textit{cnt}$ 查找 $\textit{prev}$ 对应的最长链长度，如果 $\textit{cnt} + 1$ 大于 $\textit{cnt}[\textit{words}[i]]$，则更新 $\textit{cnt}[\textit{words}[i]]$；
+ 最终返回可能的最长链的长度即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int longestStrChain(vector<string>& words) {
        unordered_map<string, int> cnt;
        sort(words.begin(), words.end(), [](const string &a, const string &b) {
            return a.size() < b.size();
        });
        int res = 0;
        for (string word : words) {
            cnt[word] = 1;
            for (int i = 0; i < word.size(); i++) {
                string prev = word.substr(0, i) + word.substr(i + 1);
                if (cnt.count(prev)) {
                    cnt[word] = max(cnt[word], cnt[prev] + 1);
                }
            }
            res = max(res, cnt[word]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestStrChain(String[] words) {
        Map<String, Integer> cnt = new HashMap<String, Integer>();
        Arrays.sort(words, (a, b) -> a.length() - b.length());
        int res = 0;
        for (String word : words) {
            cnt.put(word, 1);
            for (int i = 0; i < word.length(); i++) {
                String prev = word.substring(0, i) + word.substring(i + 1);
                if (cnt.containsKey(prev)) {
                    cnt.put(word, Math.max(cnt.get(word), cnt.get(prev) + 1));
                }
            }
            res = Math.max(res, cnt.get(word));
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestStrChain(self, words: List[str]) -> int:
        cnt = defaultdict(int)
        words.sort(key=len)
        res = 0
        for word in words:
            cnt[word] = 1
            for i in range(len(word)):
                prev = word[:i] + word[i+1:]
                if prev in cnt:
                    cnt[word] = max(cnt[word], cnt[prev] + 1)
            res = max(res, cnt[word])
        return res
```

```C# [sol1-C#]
public class Solution {
    public int LongestStrChain(string[] words) {
        IDictionary<string, int> cnt = new Dictionary<string, int>();
        Array.Sort(words, (a, b) => a.Length - b.Length);
        int res = 0;
        foreach (string word in words) {
            if (cnt.ContainsKey(word)) {
                cnt[word] = 1;
            } else {
                cnt.Add(word, 1);
            }
            for (int i = 0; i < word.Length; i++) {
                string prev = word.Substring(0, i) + word.Substring(i + 1);
                if (cnt.ContainsKey(prev)) {
                    cnt[word] = Math.Max(cnt[word], cnt[prev] + 1);
                }
            }
            res = Math.Max(res, cnt[word]);
        }
        return res;
    }
}
```

```C [sol1-C]
typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char *key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

static int cmp(const void *pa, const void *pb) {
    return strlen(*(char **)pa) - strlen(*(char **)pb);
}

int longestStrChain(char ** words, int wordsSize) {
    HashItem *cnt = NULL;
    qsort(words, wordsSize, sizeof(char *), cmp);
    int res = 0;
    for (int i = 0; i < wordsSize; i++) {
        hashAddItem(&cnt, words[i], 1);
        char prev[32];
        for (int j = 0; words[i][j] != '\0'; j++) {
            strcpy(prev + j, words[i] + j + 1);
            if (hashFindItem(&cnt, prev)) {
                int len = hashGetItem(&cnt, prev, 0) + 1;
                int cur = hashGetItem(&cnt, words[i], 0);
                if (len > cur) {
                    hashSetItem(&cnt, words[i], len);
                }
            }
            prev[j] = words[i][j];
        }
        int cur = hashGetItem(&cnt, words[i], 0);
        if (cur > res) {
            res = cur;
        }
    }
    hashFree(&cnt);
    return res;
}
```

```Go [sol1-Go]
func longestStrChain(words []string) int {
    cnt := map[string]int{}
    sort.Slice(words, func(i, j int) bool { return len(words[i]) < len(words[j]) })
    res := 0
    for _, word := range words {
        cnt[word] = 1
        for i := range word {
            prev := word[:i] + word[i + 1:]
            if j := cnt[prev] + 1; j > cnt[word] {
                cnt[word] = j
            }
        }
        if cnt[word] > res {
            res = cnt[word]
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var longestStrChain = function(words) {
    const cnt = new Map();
    words.sort((a, b) => a.length - b.length);
    let res = 0;
    for (const word of words) {
        cnt.set(word, 1);
        for (let i = 0; i < word.length; i++) {
            const prev = word.substring(0, i) + word.substring(i + 1);
            if (cnt.has(prev)) {
                cnt.set(word, Math.max(cnt.get(word), cnt.get(prev) + 1));
            }
        }
        res = Math.max(res, cnt.get(word));
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times m \times (\log n + m))$，其中 $n$ 表示字符串数组的长度，$m$ 表示每个字符串的平均长度。首选对字符串数组进行排序，需要的时间为 $O(n \times m \times \log n)$，然后遍历每个字符串，并对每个字符串都生成其「前身」字符串，需要的时间为 $O(n \times m^2)$，因此总的时间复杂度为 $O(n \times m \times (\log n + m))$。

- 空间复杂度：$O(n\times m)$，其中 $n$ 表示字符串数组的长度，$m$ 表示每个字符串的平均长度。需要存储以每个字符串为结尾的最大链的长度，一共有 $n$ 个字符串，每个字符串的平均长度为 $m$，因此需要的空间为 $O(n\times m)$。