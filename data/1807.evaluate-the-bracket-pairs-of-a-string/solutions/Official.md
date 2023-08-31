## [1807.替换字符串中的括号内容 中文官方题解](https://leetcode.cn/problems/evaluate-the-bracket-pairs-of-a-string/solutions/100000/ti-huan-zi-fu-chuan-zhong-de-gua-hao-nei-y8d3)
#### 方法一：哈希表

为了方便查找，我们将 $\textit{knowledge}$ 保存到哈希表 $\textit{dict}$ 中。字符串 $s$ 中有四种类型的字符：

+ 字符 $`(’$

+ 字符 $`)’$

+ 不在括号内的小写字母

+ 在括号内的小写字母

我们使用 $\textit{key}$ 保存括号内的键，$\textit{addKey}$ 表示当前小写字母是否为在括号内的小写字母。遍历字符串 $s$，假设当前字符为 $c$：

+ 如果 $c$ 等于 $`(’$

    说明之后的小写字母是在括号内的，令 $\textit{addKey} = \text{true}$。

+ 如果 $c$ 等于 $`)’$

    说明 $\textit{key}$ 已经结束，如果 $\textit{key}$ 在 $\textit{dict}$ 中，我们将 $\textit{dict}[\textit{key}]$ 附加到结果字符串中，否则将字符 $`?’$ 附加到结果字符串中。清除字符串 $\textit{key}$，令 $\textit{addKey} = \text{false}$。

+ 如果 $c$ 是小写字母

    根据 $\textit{addKey}$ 决定字符 $c$ 应该添加到哪里。如果 $\textit{addKey}$ 为真，那么将字符 $c$ 追加到 $\textit{key}$ 中，否则将字符 $c$ 追加到结果字符串中。

```Python [sol1-Python3]
class Solution:
    def evaluate(self, s: str, knowledge: List[List[str]]) -> str:
        d = dict(knowledge)
        ans, start = [], -1
        for i, c in enumerate(s):
            if c == '(':
                start = i
            elif c == ')':
                ans.append(d.get(s[start + 1: i], '?'))
                start = -1
            elif start < 0:
                ans.append(c)
        return "".join(ans)
```

```C++ [sol1-C++]
class Solution {
public:
    string evaluate(string s, vector<vector<string>>& knowledge) {
        unordered_map<string, string> dict;
        for (auto &kd : knowledge) {
            dict[kd[0]] = kd[1];
        }
        bool addKey = false;
        string key, res;
        for (char c : s) {
            if (c == '(') {
                addKey = true;
            } else if (c == ')') {
                if (dict.count(key) > 0) {
                    res += dict[key];
                } else {
                    res.push_back('?');
                }
                addKey = false;
                key.clear();
            } else {
                if (addKey) {
                    key.push_back(c);
                } else {
                    res.push_back(c);
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String evaluate(String s, List<List<String>> knowledge) {
        Map<String, String> dict = new HashMap<String, String>();
        for (List<String> kd : knowledge) {
            dict.put(kd.get(0), kd.get(1));
        }
        boolean addKey = false;
        StringBuilder key = new StringBuilder();
        StringBuilder res = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '(') {
                addKey = true;
            } else if (c == ')') {
                if (dict.containsKey(key.toString())) {
                    res.append(dict.get(key.toString()));
                } else {
                    res.append('?');
                }
                addKey = false;
                key.setLength(0);
            } else {
                if (addKey) {
                    key.append(c);
                } else {
                    res.append(c);
                }
            }
        }
        return res.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string Evaluate(string s, IList<IList<string>> knowledge) {
        IDictionary<string, string> dict = new Dictionary<string, string>();
        foreach (IList<string> kd in knowledge) {
            dict.Add(kd[0], kd[1]);
        }
        bool addKey = false;
        StringBuilder key = new StringBuilder();
        StringBuilder res = new StringBuilder();
        foreach (char c in s) {
            if (c == '(') {
                addKey = true;
            } else if (c == ')') {
                if (dict.ContainsKey(key.ToString())) {
                    res.Append(dict[key.ToString()]);
                } else {
                    res.Append('?');
                }
                addKey = false;
                key.Length = 0;
            } else {
                if (addKey) {
                    key.Append(c);
                } else {
                    res.Append(c);
                }
            }
        }
        return res.ToString();
    }
}
```

```C [sol1-C]
typedef struct {
    char *key;
    char *val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, const char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, char *val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

char * evaluate(char * s, char *** knowledge, int knowledgeSize, int* knowledgeColSize) {
    HashItem *dict = NULL;
    for (int i = 0; i < knowledgeSize; i++) {
        hashAddItem(&dict, knowledge[i][0], knowledge[i][1]);
    }
    bool addKey = false;
    int len = strlen(s);
    char key[16], *res = (char *)malloc(sizeof(char) * (len + 1));
    int keySize = 0, resSize = 0;
    memset(key, 0, sizeof(key));
    memset(res, 0, sizeof(char) * (len + 1));
    for (int i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        if (c == '(') {
            addKey = true;
        } else if (c == ')') {
            HashItem *pEntry = hashFindItem(&dict, key);
            if (pEntry) {
                resSize += sprintf(res + resSize, "%s", pEntry->val);
            } else {
                res[resSize++] = '?';
            }
            addKey = false;
            keySize = 0;
        } else {
            if (addKey) {
                key[keySize++] = c;
                key[keySize] = '\0';
            } else {
                res[resSize++] = c;
            }
        }
    }
    hashFree(&dict);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var evaluate = function(s, knowledge) {
    const dict = new Map();
    for (const kd of knowledge) {
        dict.set(kd[0], kd[1]);
    }
    let addKey = false;
    let key = '';
    let res = '';
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c === '(') {
            addKey = true;
        } else if (c === ')') {
            if (dict.has(key)) {
                res += dict.get(key);
            } else {
                res += '?';
            }
            addKey = false;
            key = '';
        } else {
            if (addKey) {
                key += c;
            } else {
                res += c;
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func evaluate(s string, knowledge [][]string) string {
    dict := map[string]string{}
    for _, kd := range knowledge {
        dict[kd[0]] = kd[1]
    }
    ans := &strings.Builder{}
    start := -1
    for i, c := range s {
        if c == '(' {
            start = i
        } else if c == ')' {
            if t, ok := dict[s[start+1:i]]; ok {
                ans.WriteString(t)
            } else {
                ans.WriteByte('?')
            }
            start = -1
        } else if start < 0 {
            ans.WriteRune(c)
        }
    }
    return ans.String()
}
```

**复杂度分析**

+ 时间复杂度：$O(n + k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串数组 $\textit{knowledge}$ 中所有字符串的长度之和。

+ 空间复杂度：$O(n + k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串数组 $\textit{knowledge}$ 中所有字符串的长度之和。保存哈希表 $\textit{dict}$ 和 $\textit{key}$ 分别需要 $O(k)$ 和 $O(n)$。