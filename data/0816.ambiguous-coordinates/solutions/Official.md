## [816.模糊坐标 中文官方题解](https://leetcode.cn/problems/ambiguous-coordinates/solutions/100000/mo-hu-zuo-biao-by-leetcode-solution-y1yz)

#### 方法一：枚举

**思路与算法**

题目给出字符串 $s$ 为某些原始坐标字符串去掉所有逗号，小数点和空格后得到的字符串，其中需要满足原始坐标表示中的数不会存在多余的零。现在我们要求出所有能生成字符串 $s$ 的所有可能的原始字符串。
我们可以尝试将原始坐标字符串中去掉的逗号，小数点和空格进行还原——首先在字符串 $s$ 中枚举添加逗号和空格的位置，将 $s$ 的数字部分为两个部分，前一部分为原始坐标 $x$ 坐标去掉（若存在）小数点后的数字，后一部分为原始坐标 $y$ 坐标去掉（若存在）小数点后的数字。然后我们分别对于前后部分数字枚举添加小数点的位置（也可以不添加），其中添加或者不添加小数点合法情况需要满足的条件：

- 不添加小数点和添小数点后的整数部分都需要满足当前表示数字为 $0$ 或者为不含前导零的正数。
- 添加小数点后，小数部分需要满足其末尾不为 $0$。

然后对于前后部分的合法方案进行一一匹配得到此时情况的合法原始坐标字符串。

**代码**

```Python [sol1-Python3]
class Solution:
    def ambiguousCoordinates(self, s: str) -> List[str]:
        def get_pos(s: str) -> List[str]:
            pos = []
            if s[0] != '0' or s == '0':
                pos.append(s)
            for p in range(1, len(s)):
                if p != 1 and s[0] == '0' or s[-1] == '0':
                    continue
                pos.append(s[:p] + '.' + s[p:])
            return pos

        n = len(s) - 2
        res = []
        s = s[1: len(s) - 1]
        for l in range(1, n):
            lt = get_pos(s[:l])
            if len(lt) == 0:
                continue
            rt = get_pos(s[l:])
            if len(rt) == 0:
                continue
            for i, j in product(lt, rt):
                res.append('(' + i + ', ' + j + ')')
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> getPos(string s) {
        vector<string> pos;
        if (s[0] != '0' || s == "0") pos.push_back(s);
        for (int p = 1; p < s.size(); ++p) {
            if ((p != 1 && s[0] == '0') || s.back() == '0') continue;
            pos.push_back(s.substr(0, p) + "." + s.substr(p));
        }
        return pos;
    }
    vector<string> ambiguousCoordinates(string s) {
        int n = s.size() - 2;
        vector<string> res;
        s = s.substr(1, s.size() - 2);
        for (int l = 1; l < n; ++l) {
            vector<string> lt = getPos(s.substr(0, l));
            if (lt.empty()) continue;
            vector<string> rt = getPos(s.substr(l));
            if (rt.empty()) continue;
            for (auto& i : lt) {
                for (auto& j : rt) {
                    res.push_back("(" + i + ", " + j + ")");
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> ambiguousCoordinates(String s) {
        int n = s.length() - 2;
        List<String> res = new ArrayList<String>();
        s = s.substring(1, s.length() - 1);
        for (int l = 1; l < n; ++l) {
            List<String> lt = getPos(s.substring(0, l));
            if (lt.isEmpty()) {
                continue;
            }
            List<String> rt = getPos(s.substring(l));
            if (rt.isEmpty()) {
                continue;
            }
            for (String i : lt) {
                for (String j : rt) {
                    res.add("(" + i + ", " + j + ")");
                }
            }
        }
        return res;
    }

    public List<String> getPos(String s) {
        List<String> pos = new ArrayList<String>();
        if (s.charAt(0) != '0' || "0".equals(s)) {
            pos.add(s);
        }
        for (int p = 1; p < s.length(); ++p) {
            if ((p != 1 && s.charAt(0) == '0') || s.charAt(s.length() - 1) == '0') {
                continue;
            }
            pos.add(s.substring(0, p) + "." + s.substring(p));
        }
        return pos;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> AmbiguousCoordinates(string s) {
        int n = s.Length - 2;
        IList<string> res = new List<string>();
        s = s.Substring(1, s.Length - 2);
        for (int l = 1; l < n; ++l) {
            IList<string> lt = GetPos(s.Substring(0, l));
            if (lt.Count == 0) {
                continue;
            }
            IList<string> rt = GetPos(s.Substring(l));
            if (rt.Count == 0) {
                continue;
            }
            foreach (string i in lt) {
                foreach (string j in rt) {
                    res.Add("(" + i + ", " + j + ")");
                }
            }
        }
        return res;
    }

    public IList<string> GetPos(string s) {
        IList<string> pos = new List<string>();
        if (s[0] != '0' || "0".Equals(s)) {
            pos.Add(s);
        }
        for (int p = 1; p < s.Length; ++p) {
            if ((p != 1 && s[0] == '0') || s[s.Length - 1] == '0') {
                continue;
            }
            pos.Add(s.Substring(0, p) + "." + s.Substring(p));
        }
        return pos;
    }
}
```

```C [sol1-C]
char ** getPos(const char *s, int *returnSize) {
    int len = strlen(s);
    char **res = (char **)malloc(sizeof(char *) * len);
    int pos = 0;
    if (s[0] != '0' || strcmp(s, "0") == 0) {
        res[pos] = (char *)malloc(sizeof(char) * (len + 1));
        strcpy(res[pos], s);
        pos++;
    }
    for (int p = 1; p < len; ++p) {
        if ((p != 1 && s[0] == '0') || s[len - 1] == '0') {
            continue;
        }
        res[pos] = (char *)malloc(sizeof(char) * (len + 2));
        strncpy(res[pos], s, p);
        sprintf(res[pos] + p, ".%s", s + p);
        pos++;
    }
    *returnSize = pos;
    return res;
}

char ** ambiguousCoordinates(char * s, int* returnSize) {
    int n = strlen(s) - 2;
    s = s + 1;
    s[n] = '\0';
    char **res = (char *)malloc(sizeof(char *) * pow(n, 3));
    int pos = 0;
    for (int l = 1; l < n; ++l) {
        char ls[n + 1];
        strncpy(ls, s, l);
        ls[l] = '\0';
        int ltSize = 0;
        char **lt = getPos(ls, &ltSize);
        if (ltSize == 0) {
            continue;
        }
        char rs[n + 1];
        strncpy(rs, s + l, n - l);
        rs[n - l] = '\0';
        int rtSize = 0;
        char **rt = getPos(rs, &rtSize);
        if (rtSize == 0) {
            continue;
        }
        for (int i = 0; i < ltSize; i++) {
            for (int j = 0; j < rtSize; j++) {
                res[pos] = (char *)malloc(sizeof(char) * (n + 8));
                sprintf(res[pos++], "(%s, %s)", lt[i], rt[j]);
            }
        }
        for (int i = 0; i < ltSize; i++) {
            free(lt[i]);
        }
        for (int i = 0; i < rtSize; i++) {
            free(rt[i]);
        }
        free(lt);
        free(rt);
    }
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var ambiguousCoordinates = function(s) {
    const n = s.length - 2;
    const res = [];
    s = s.slice(1, s.length - 1);
    for (let l = 1; l < n; ++l) {
        const lt = getPos(s.slice(0, l));
        if (lt.length === 0) {
            continue;
        }
        const rt = getPos(s.slice(l));
        if (rt.length === 0) {
            continue;
        }
        for (const i of lt) {
            for (const j of rt) {
                res.push("(" + i + ", " + j + ")");
            }
        }
    }
    return res;
}

const getPos = (s) => {
    const pos = [];
    if (s[0] !== '0' || "0" === s) {
        pos.push(s);
    }
    for (let p = 1; p < s.length; ++p) {
        if ((p !== 1 && s[0] === '0') || s[s.length - 1] === '0') {
            continue;
        }
        pos.push(s.slice(0, p) + "." + s.slice(p));
    }
    return pos;
};
```

```go [sol1-Golang]
func getPos(s string) (pos []string) {
    if s[0] != '0' || s == "0" {
        pos = append(pos, s)
    }
    for p := 1; p < len(s); p++ {
        if p != 1 && s[0] == '0' || s[len(s)-1] == '0' {
            continue
        }
        pos = append(pos, s[:p]+"."+s[p:])
    }
    return
}

func ambiguousCoordinates(s string) (res []string) {
    n := len(s) - 2
    s = s[1 : len(s)-1]
    for l := 1; l < n; l++ {
        lt := getPos(s[:l])
        if len(lt) == 0 {
            continue
        }
        rt := getPos(s[l:])
        if len(rt) == 0 {
            continue
        }
        for _, i := range lt {
            for _, j := range rt {
                res = append(res, "("+i+", "+j+")")
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n ^ 3)$，其中 $n$ 为题目给定字符串 $s$ 的长度。
- 空间复杂度：$O(n ^ 3)$，其中 $n$ 为题目给定字符串 $s$ 的长度，主要为存储答案所需要的空间开销。