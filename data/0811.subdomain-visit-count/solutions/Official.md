#### 方法一：哈希表

每个计数配对域名的格式都是 $\texttt{"rep d1.d2.d3"}$ 或 $\texttt{"rep d1.d2"}$。子域名的计数如下：

- 对于格式 $\texttt{"rep d1.d2.d3"}$，有三个子域名 $\texttt{"d1.d2.d3"}$、$\texttt{"d2.d3"}$ 和 $\texttt{"d3"}$，每个子域名各被访问 $\texttt{rep}$ 次；

- 对于格式 $\texttt{"rep d1.d2"}$，有两个子域名 $\texttt{"d1.d2"}$ 和 $\texttt{"d2"}$，每个子域名各被访问 $\texttt{rep}$ 次。

为了获得每个子域名的计数配对域名，需要使用哈希表记录每个子域名的计数。遍历数组 $\textit{cpdomains}$，对于每个计数配对域名，获得计数和完整域名，更新哈希表中的每个子域名的访问次数。

遍历数组 $\textit{cpdomains}$ 之后，遍历哈希表，对于哈希表中的每个键值对，关键字是子域名，值是计数，将计数和子域名拼接得到计数配对域名，添加到答案中。

```Python [sol1-Python3]
class Solution:
    def subdomainVisits(self, cpdomains: List[str]) -> List[str]:
        cnt = Counter()
        for domain in cpdomains:
            c, s = domain.split()
            c = int(c)
            cnt[s] += c
            while '.' in s:
                s = s[s.index('.') + 1:]
                cnt[s] += c
        return [f"{c} {s}" for s, c in cnt.items()]
```

```Java [sol1-Java]
class Solution {
    public List<String> subdomainVisits(String[] cpdomains) {
        List<String> ans = new ArrayList<String>();
        Map<String, Integer> counts = new HashMap<String, Integer>();
        for (String cpdomain : cpdomains) {
            int space = cpdomain.indexOf(' ');
            int count = Integer.parseInt(cpdomain.substring(0, space));
            String domain = cpdomain.substring(space + 1);
            counts.put(domain, counts.getOrDefault(domain, 0) + count);
            for (int i = 0; i < domain.length(); i++) {
                if (domain.charAt(i) == '.') {
                    String subdomain = domain.substring(i + 1);
                    counts.put(subdomain, counts.getOrDefault(subdomain, 0) + count);
                }
            }
        }
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            String subdomain = entry.getKey();
            int count = entry.getValue();
            ans.add(count + " " + subdomain);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> SubdomainVisits(string[] cpdomains) {
        IList<string> ans = new List<string>();
        Dictionary<string, int> counts = new Dictionary<string, int>();
        foreach (string cpdomain in cpdomains) {
            int space = cpdomain.IndexOf(' ');
            int count = int.Parse(cpdomain.Substring(0, space));
            string domain = cpdomain.Substring(space + 1);
            if (!counts.ContainsKey(domain)) {
                counts.Add(domain, 0);
            }
            counts[domain] += count;
            for (int i = 0; i < domain.Length; i++) {
                if (domain[i] == '.') {
                    string subdomain = domain.Substring(i + 1);
                    if (!counts.ContainsKey(subdomain)) {
                        counts.Add(subdomain, 0);
                    }
                    counts[subdomain] += count;
                }
            }
        }
        foreach (KeyValuePair<string, int> pair in counts) {
            string subdomain = pair.Key;
            int count = pair.Value;
            ans.Add(count + " " + subdomain);
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> subdomainVisits(vector<string>& cpdomains) {
        vector<string> ans;
        unordered_map<string, int> counts;
        for (auto &&cpdomain : cpdomains) {
            int space = cpdomain.find(' ');
            int count = stoi(cpdomain.substr(0, space));
            string domain = cpdomain.substr(space + 1);
            counts[domain] += count;
            for (int i = 0; i < domain.size(); i++) {
                if (domain[i] == '.') {
                    string subdomain = domain.substr(i + 1);
                    counts[subdomain] += count;
                }
            }
        }
        for (auto &&[subdomain, count] : counts) {
            ans.emplace_back(to_string(count) + " " + subdomain);
        }
        return ans;
    }
};
```

```C [sol1-C]
typedef struct {
    const char *key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, const char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, const char* key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, const char* key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char* key, int defaultVal) {
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

char ** subdomainVisits(char ** cpdomains, int cpdomainsSize, int* returnSize){
    HashItem *counts = NULL;
    for (int i = 0; i < cpdomainsSize; i++) {
        int space = strchr(cpdomains[i], ' ') - cpdomains[i];
        int count = atoi(cpdomains[i]);
        char *domain = cpdomains[i] + space + 1;
        hashSetItem(&counts, domain, hashGetItem(&counts, domain, 0) + count);
        int len = strlen(domain);
        for (int j = 0; j < len; j++) {
            if (domain[j] == '.') {
                char *subdomain = domain + j + 1;
                hashSetItem(&counts, subdomain, hashGetItem(&counts, subdomain, 0) + count);
            }
        }
    }
    char **ans = (char **)malloc(sizeof(char *) * cpdomainsSize * 4);
    int pos = 0;
    *returnSize = HASH_COUNT(counts);
    for (HashItem *pEntry = counts; pEntry != NULL; pEntry = pEntry->hh.next) {
        ans[pos] = (char *)malloc(sizeof(char) * (strlen(pEntry->key) + 32));
        sprintf(ans[pos], "%d %s", pEntry->val, pEntry->key);
        pos++;
    }
    hashFree(&counts);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var subdomainVisits = function(cpdomains) {
    const ans = [];
    const counts = new Map();
    for (const cpdomain of cpdomains) {
        const space = cpdomain.indexOf(' ');
        const count = parseInt(cpdomain.slice(0, space));
        const domain = cpdomain.slice(space + 1);
        counts.set(domain, (counts.get(domain) || 0) + count);
        for (let i = 0; i < domain.length; i++) {
            if (domain[i] === '.') {
                const subdomain = domain.slice(i + 1);
                counts.set(subdomain, (counts.get(subdomain) || 0) + count);
            }
        }
    }
    for (const [subdomain, count] of counts.entries()) {
        ans.push(count + " " + subdomain);
    }
    return ans;
};
```

```go [sol1-Golang]
func subdomainVisits(cpdomains []string) []string {
    cnt := map[string]int{}
    for _, s := range cpdomains {
        i := strings.IndexByte(s, ' ')
        c, _ := strconv.Atoi(s[:i])
        s = s[i+1:]
        cnt[s] += c
        for {
            i := strings.IndexByte(s, '.')
            if i < 0 {
                break
            }
            s = s[i+1:]
            cnt[s] += c
        }
    }
    ans := make([]string, 0, len(cnt))
    for s, c := range cnt {
        ans = append(ans, strconv.Itoa(c)+" "+s)
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(L)$，其中 $L$ 是数组 $\textit{cpdomains}$ 中的所有字符串长度之和。遍历数组中所有的计数配对域名计算每个子域名的计数需要 $O(L)$ 的时间，遍历哈希表也需要 $O(L)$ 的时间。

- 空间复杂度：$O(L)$，其中 $L$ 是数组 $\textit{cpdomains}$ 中的所有字符串长度之和。哈希表需要 $O(L)$ 的空间。