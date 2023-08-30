#### 方法一：哈希表

对于需要被创建的文件名 $\textit{name}$，如果文件系统中不存在名为 $\textit{name}$ 的文件夹，那么直接创建即可，否则我们需要从 $k=1$ 开始，尝试使用添加后缀 $k$ 的新文件名创建新文件夹。

使用哈希表 $\textit{index}$ 记录已创建的文件夹的下一后缀序号，遍历 $\textit{names}$ 数组，记当前遍历的文件名为 $\textit{name}$：

+ 如果 $\textit{name}$ 不在哈希表中，那么说明文件系统不存在名为 $\textit{name}$ 的文件夹，我们直接创建该文件夹，并且记录对应文件夹的下一后缀序号为 $1$。

+ 如果 $\textit{name}$ 在哈希表中，那么说明文件系统已经存在名为 $\textit{name}$ 的文件夹，我们在哈希表找到 $\textit{name}$ 的下一后缀序号 $k$，逐一尝试直到添加后缀 $k$ 的新文件名不存在于哈希表中，然后创建该文件夹。需要注意的是，创建该文件夹后，有两个文件名的下一后缀序号需要修改，首先文件名 $\textit{name}$ 的下一后缀序号为 $k+1$，其次，文件名 $\textit{name}$ 添加后缀 $k$ 的新文件名的下一后缀序号为 $1$。

```Python [sol1-Python3]
class Solution:
    def getFolderNames(self, names: List[str]) -> List[str]:
        ans = []
        index = {}
        for name in names:
            if name not in index:
                ans.append(name)
                index[name] = 1
            else:
                k = index[name]
                while name + '(' + str(k) + ')' in index:
                    k += 1
                t = name + '(' + str(k) + ')'
                ans.append(t)
                index[name] = k + 1
                index[t] = 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    string addSuffix(string name, int k) {
        return name + "(" + to_string(k) + ")";
    }

    vector<string> getFolderNames(vector<string>& names) {
        unordered_map<string, int> index;
        vector<string> res;
        for (const auto &name : names) {
            if (!index.count(name)) {
                res.push_back(name);
                index[name] = 1;
            } else {
                int k = index[name];
                while (index.count(addSuffix(name, k))) {
                    k++;
                }
                res.push_back(addSuffix(name, k));
                index[name] = k + 1;
                index[addSuffix(name, k)] = 1;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String[] getFolderNames(String[] names) {
        Map<String, Integer> index = new HashMap<String, Integer>();
        int n = names.length;
        String[] res = new String[n];
        for (int i = 0; i < n; i++) {
            String name = names[i];
            if (!index.containsKey(name)) {
                res[i] = name;
                index.put(name, 1);
            } else {
                int k = index.get(name);
                while (index.containsKey(addSuffix(name, k))) {
                    k++;
                }
                res[i] = addSuffix(name, k);
                index.put(name, k + 1);
                index.put(addSuffix(name, k), 1);
            }
        }
        return res;
    }

    public String addSuffix(String name, int k) {
        return name + "(" + k + ")";
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] GetFolderNames(string[] names) {
        IDictionary<string, int> index = new Dictionary<string, int>();
        int n = names.Length;
        string[] res = new string[n];
        for (int i = 0; i < n; i++) {
            string name = names[i];
            if (!index.ContainsKey(name)) {
                res[i] = name;
                index.Add(name, 1);
            } else {
                int k = index[name];
                while (index.ContainsKey(AddSuffix(name, k))) {
                    k++;
                }
                res[i] = AddSuffix(name, k);
                index[name] = k + 1;
                index.Add(AddSuffix(name, k), 1);
            }
        }
        return res;
    }

    public string AddSuffix(string name, int k) {
        return name + "(" + k + ")";
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
    pEntry->key = (char *)calloc(sizeof(char), strlen(key) + 1);
    strcpy(pEntry->key, key);
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, const char *key, int val) {
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
        free(curr->key);
        free(curr);             
    }
}

char ** getFolderNames(char ** names, int namesSize, int* returnSize) {
    HashItem *index = NULL;
    char **res = (char **)calloc(sizeof(char *), namesSize);
    int pos = 0;
    for (int i = 0; i < namesSize; i++) {
        if (!hashFindItem(&index, names[i])) {
            res[pos] = (char *)calloc(sizeof(char), strlen(names[i]) + 1);
            strcpy(res[pos], names[i]);
            pos++;
            hashAddItem(&index, names[i], 1);
        } else {
            int k = hashGetItem(&index, names[i], 0);
            char str[strlen(names[i]) + 16];
            sprintf(str, "%s(%d)", names[i], k);
            while (hashFindItem(&index, str)) {
                k++;
                sprintf(str, "%s(%d)", names[i], k);
            }
            res[pos] = (char *)calloc(sizeof(char), strlen(str) + 1);
            strcpy(res[pos], str);
            pos++;
            hashSetItem(&index, names[i], k + 1);
            hashAddItem(&index, str, 1);
        }
    }
    *returnSize = pos;
    hashFree(&index);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var getFolderNames = function(names) {
    const index = new Map();
    const n = names.length;
    const res = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        const name = names[i];
        if (!index.has(name)) {
            res[i] = name;
            index.set(name, 1);
        } else {
            let k = index.get(name);
            while (index.has(addSuffix(name, k))) {
                k++;
            }
            res[i] = addSuffix(name, k);
            index.set(name, k + 1);
            index.set(addSuffix(name, k), 1);
        }
    }
    return res;
}

const addSuffix = (name, k) => {
    return name + "(" + k + ")";
};
```

```go [sol1-Golang]
func getFolderNames(names []string) []string {
    ans := make([]string, len(names))
    index := map[string]int{}
    for p, name := range names {
        i := index[name]
        if i == 0 {
            index[name] = 1
            ans[p] = name
            continue
        }
        for index[name+"("+strconv.Itoa(i)+")"] > 0 {
            i++
        }
        t := name + "(" + strconv.Itoa(i) + ")"
        ans[p] = t
        index[name] = i + 1
        index[t] = 1
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O(\sum_{i=0}^{n-1} m_i)$，其中 $m_i$ 表示字符串 $\textit{names}[i]$ 的长度，$n$ 表示数组 $\textit{names}$ 的长度。外层循环每次运行时间为 $O(m_i)$，总时间复杂度为 $O(\sum_{i=0}^{n-1} m_i)$；内层循环的总运行次数不超过 $n$ 次，总时间复杂度为 $O(\sum_{i=0}^{n-1} m_i)$。

+ 空间复杂度：$O(\sum_{i=0}^{n-1}{m_i})$。保存哈希表需要 $O(\sum_{i=0}^{n-1}{m_i})$ 的空间。