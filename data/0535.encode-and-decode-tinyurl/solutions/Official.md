## [535.TinyURL 的加密与解密 中文官方题解](https://leetcode.cn/problems/encode-and-decode-tinyurl/solutions/100000/tinyurl-de-jia-mi-yu-jie-mi-by-leetcode-ty5yp)

#### 前言

题目不要求相同的 $\text{URL}$ 必须加密成同一个 $\text{TinyURL}$，因此本文的方法不满足相同的 $\text{URL}$ 加密成同一个 $\text{TinyURL}$。如果想要实现相同的 $\text{URL}$ 加密成同一个 $\text{TinyURL}$，则额外保存一个从 $\text{URL}$ 到 $\text{TinyURL}$ 的映射。

#### 方法一：自增

+ $\text{Encode}$ 函数

    使用自增 $\textit{id}$ 作为 $\textit{longUrl}$ 的键，每接收一个 $\textit{longUrl}$ 都将 $\textit{id}$ 加一，将键值对 $(\textit{id}, \textit{longUrl})$ 插入数据库 $\textit{dataBase}$，然后返回带有 $\textit{id}$ 的字符串作为 $\textit{shorUrl}$。

+ $\text{Decode}$ 函数

    将 $\textit{shortUrl}$ 转换成对应的 $\textit{key}$，然后在数据库 $\textit{dataBase}$ 中查找 $\textit{key}$ 对应的 $\textit{longUrl}$。

```Python [sol1-Python3]
class Codec:
    def __init__(self):
        self.database = {}
        self.id = 0

    def encode(self, longUrl: str) -> str:
        self.id += 1
        self.database[self.id] = longUrl
        return "http://tinyurl.com/" + str(self.id)

    def decode(self, shortUrl: str) -> str:
        i = shortUrl.rfind('/')
        id = int(shortUrl[i + 1:])
        return self.database[id]
```

```C++ [sol1-C++]
class Solution {
private:
    unordered_map<int, string> dataBase;
    int id;

public:
    Solution() {
        id = 0;
    }

    string encode(string longUrl) {
        id++;
        dataBase[id] = longUrl;
        return string("http://tinyurl.com/") + to_string(id);
    }

    string decode(string shortUrl) {
        int p = shortUrl.rfind('/') + 1;
        int key = stoi(shortUrl.substr(p, int(shortUrl.size()) - p));
        return dataBase[key];
    }
};
```

```Java [sol1-Java]
public class Codec {
    private Map<Integer, String> dataBase = new HashMap<Integer, String>();
    private int id;

    public String encode(String longUrl) {
        id++;
        dataBase.put(id, longUrl);
        return "http://tinyurl.com/" + id;
    }

    public String decode(String shortUrl) {
        int p = shortUrl.lastIndexOf('/') + 1;
        int key = Integer.parseInt(shortUrl.substring(p));
        return dataBase.get(key);
    }
}
```

```C# [sol1-C#]
public class Codec {
    private Dictionary<int, string> dataBase = new Dictionary<int, string>();
    private int id;

    public string encode(string longUrl) {
        id++;
        if (!dataBase.ContainsKey(id)) {
            dataBase.Add(id, longUrl);
        } else {
            dataBase[id] = longUrl;
        }
        return "http://tinyurl.com/" + id;
    }

    public string decode(string shortUrl) {
        int p = shortUrl.LastIndexOf('/') + 1;
        int key = int.Parse(shortUrl.Substring(p, shortUrl.Length - p));
        return dataBase[key];
    }
}
```

```C [sol1-C]
typedef struct {
    int key;
    char *val;
    UT_hash_handle hh;
} HashItem;

HashItem *dataBase = NULL;
int id = 0;

char* encode(char* longUrl) {
    id++;
    HashItem * pEntry = NULL;
    HASH_FIND_INT(dataBase, &id, pEntry);
    if (NULL == pEntry) {
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = id;
        pEntry->val = longUrl;
        HASH_ADD_INT(dataBase, key, pEntry);
    }
    char *res = (char *)malloc(sizeof(char) * 64);
    sprintf(res, "%s%d", "http://tinyurl.com/", id); 
    return res;
}

char* decode(char* shortUrl) {
    char *p = shortUrl;
    char *last = shortUrl;
    while (last = strchr(p, '/')) {
        p = last + 1;
    }
    int key = atoi(p);
    HashItem * pEntry = NULL;
    HASH_FIND_INT(dataBase, &key, pEntry);
    if (NULL != pEntry) {
        return pEntry->val;
    }
    return NULL;
}

```

```JavaScript [sol1-JavaScript]
var encode = function(longUrl) {
    this.dataBase = new Map();
    this.id = 0;
    this.id++;
    this.dataBase.set(this.id, longUrl);
    return "http://tinyurl.com/" + this.id;
};

var decode = function(shortUrl) {
    const p = shortUrl.lastIndexOf('/') + 1;
    const key = parseInt(shortUrl.substring(p));
    return this.dataBase.get(key);
};
```

```go [sol1-Golang]
type Codec struct {
    dataBase map[int]string
    id       int
}

func Constructor() Codec {
    return Codec{map[int]string{}, 0}
}

func (c *Codec) encode(longUrl string) string {
    c.id++
    c.dataBase[c.id] = longUrl
    return "http://tinyurl.com/" + strconv.Itoa(c.id)
}

func (c *Codec) decode(shortUrl string) string {
    i := strings.LastIndexByte(shortUrl, '/')
    id, _ := strconv.Atoi(shortUrl[i+1:])
    return c.dataBase[id]
}
```

**复杂度分析**

+ 时间复杂度：
    
    + $\text{Encode}$ 函数：$O(n)$，其中 $n$ 是字符串 $\textit{longUrl}$ 的长度。

    + $\text{Decode}$ 函数：$O(1)$。我们当 $\textit{shortUrl}$ 当成有限长度的字符串看待。

+ 空间复杂度：

    + $\text{Encode}$ 函数：$O(n)$。保存字符串 $\textit{longUrl}$ 需要 $O(n)$ 的空间。

    + $\text{Decode}$ 函数：$O(1)$。

#### 方法二：哈希生成

+ $\text{Encode}$ 函数

    设字符串 $\textit{longUrl}$ 的长度为 $n$，选择两个合适的质数 $k_1 = 1117$，$k_2 = 10^9 + 7$，使用以下方法来计算 $\textit{longUrl}$ 的哈希值：

    $$\text{Hash} ( \textit{longUrl} ) = \big ( \sum^{n-1}_{i=0} \textit{longUrl}[i] \times k_1^i \big ) \bmod k_2$$

    将哈希值作为 $\textit{longUrl}$ 的 $\textit{key}$，将键值对 $(\textit{key}, \textit{longUrl})$ 插入数据库 $\textit{dataBase}$，然后返回带有 $\textit{key}$ 的字符串作为 $\textit{shorUrl}$。

    > 发生哈希冲突时，我们采用线性探测再散列的方法，将 $\textit{key}$ 加一，直到没有冲突。相同的 $\textit{longUrl}$ 的哈希值相同，因此哈希冲突会频繁发生。为了避免这一点，我们使用一个额外的哈希表记录从 $\textit{longUrl}$ 到 $\textit{key}$ 的映射。

+ $\text{Decode}$ 函数

    将 $\textit{shortUrl}$ 转换成对应的 $\textit{key}$，然后在数据库 $\textit{dataBase}$ 中查找 $\textit{key}$ 对应的 $\textit{longUrl}$。

```Python [sol2-Python3]
K1, K2 = 1117, 10 ** 9 + 7

class Codec:
    def __init__(self):
        self.dataBase = {}
        self.urlToKey = {}

    def encode(self, longUrl: str) -> str:
        if longUrl in self.urlToKey:
            return "http://tinyurl.com/" + str(self.urlToKey[longUrl])
        key, base = 0, 1
        for c in longUrl:
            key = (key + ord(c) * base) % K2
            base = (base * K1) % K2
        while key in self.dataBase:
            key = (key + 1) % K2
        self.dataBase[key] = longUrl
        self.urlToKey[longUrl] = key
        return "http://tinyurl.com/" + str(key)

    def decode(self, shortUrl: str) -> str:
        i = shortUrl.rfind('/')
        key = int(shortUrl[i + 1:])
        return self.dataBase[key]
```

```C++ [sol2-C++]
const long long k1 = 1117;
const long long k2 = 1e9 + 7;

class Solution {
private:
    unordered_map<int, string> dataBase;
    unordered_map<string, int> urlToKey;

public:
    Solution() {

    }

    string encode(string longUrl) {
        if (urlToKey.count(longUrl) > 0) {
            return string("http://tinyurl.com/") + to_string(urlToKey[longUrl]);
        }
        long long key = 0, base = 1;
        for (auto c : longUrl) {
            key = (key + c * base) % k2;
            base = (base * k1) % k2;
        }
        while (dataBase.count(key) > 0) {
            key = (key + 1) % k2;
        }
        dataBase[key] = longUrl;
        urlToKey[longUrl] = key;
        return string("http://tinyurl.com/") + to_string(key);
    }

    string decode(string shortUrl) {
        int p = shortUrl.rfind('/') + 1;
        int key = stoi(shortUrl.substr(p, int(shortUrl.size()) - p));
        return dataBase[key];
    }
};
```

```Java [sol2-Java]
public class Codec {
    static final int K1 = 1117;
    static final int K2 = 1000000007;
    private Map<Integer, String> dataBase = new HashMap<Integer, String>();
    private Map<String, Integer> urlToKey = new HashMap<String, Integer>();

    public String encode(String longUrl) {
        if (urlToKey.containsKey(longUrl)) {
            return "http://tinyurl.com/" + urlToKey.get(longUrl);
        }
        int key = 0;
        long base = 1;
        for (int i = 0; i < longUrl.length(); i++) {
            char c = longUrl.charAt(i);
            key = (int) ((key + (long) c * base) % K2);
            base = (base * K1) % K2;
        }
        while (dataBase.containsKey(key)) {
            key = (key + 1) % K2;
        }
        dataBase.put(key, longUrl);
        urlToKey.put(longUrl, key);
        return "http://tinyurl.com/" + key;
    }

    public String decode(String shortUrl) {
        int p = shortUrl.lastIndexOf('/') + 1;
        int key = Integer.parseInt(shortUrl.substring(p));
        return dataBase.get(key);
    }
}
```

```C# [sol2-C#]
public class Codec {
    const int K1 = 1117;
    const int K2 = 1000000007;
    private Dictionary<int, string> dataBase = new Dictionary<int, string>();
    private Dictionary<string, int> urlToKey = new Dictionary<string, int>();

    public string encode(string longUrl) {
        if (urlToKey.ContainsKey(longUrl)) {
            return "http://tinyurl.com/" + urlToKey[longUrl];
        }
        int key = 0;
        long b = 1;
        foreach (char c in longUrl) {
            key = (int) ((key + (long) c * b) % K2);
            b = (b * K1) % K2;
        }
        while (dataBase.ContainsKey(key)) {
            key = (key + 1) % K2;
        }
        dataBase.Add(key, longUrl);
        urlToKey.Add(longUrl, key);
        return "http://tinyurl.com/" + key;
    }

    public string decode(string shortUrl) {
        int p = shortUrl.LastIndexOf('/') + 1;
        int key = int.Parse(shortUrl.Substring(p, shortUrl.Length - p));
        return dataBase[key];
    }
}
```

```C [sol2-C]
typedef struct {
    int key;
    char *val;
    UT_hash_handle hh;
} HashDataItem;

typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashTokenItem;

const long long k1 = 1117;
const long long k2 = 1e9 + 7;
HashDataItem *dataBase = NULL;
HashTokenItem * urlToKey = NULL;

char* encode(char* longUrl) {
    HashTokenItem *pToken = NULL;
    HASH_FIND_STR(urlToKey, longUrl, pToken);
    if (NULL != pToken) {
        char *res = (char *)malloc(sizeof(char) * 64);
        sprintf(res, "%s%d", "http://tinyurl.com/", pToken->val); 
        return res;
    }
    long long key = 0, base = 1;
    int len = strlen(longUrl);
    for (int i = 0; i < len; i++) {
        char c = longUrl[i];
        key = (key + c * base) % k2;
        base = (base * k1) % k2;
    }
    HashDataItem * pEntry = NULL;
    do {
        pEntry = NULL;
        HASH_FIND_INT(dataBase, &key, pEntry);
        if (pEntry) {
            key = (key + 1) % k2;
        }
    } while(pEntry);
    pEntry = (HashDataItem *)malloc(sizeof(HashDataItem));
    pEntry->key = key;
    pEntry->val = longUrl;
    HASH_ADD_INT(dataBase, key, pEntry);
    pToken = (HashTokenItem *)malloc(sizeof(HashTokenItem));
    pToken->key = longUrl;
    pToken->val = key;
    HASH_ADD_STR(urlToKey, key, pToken);
    char *res = (char *)malloc(sizeof(char) * 64);
    sprintf(res, "%s%d", "http://tinyurl.com/", key); 
    return res;
}

char* decode(char* shortUrl) {
    char *p = shortUrl;
    char *last = shortUrl;
    while (last = strchr(p, '/')) {
        p = last + 1;
    }
    int key = atoi(p);
    HashDataItem * pEntry = NULL;
    HASH_FIND_INT(dataBase, &key, pEntry);
    if (NULL != pEntry) {
        return pEntry->val;
    }
    return NULL;
}
```

```JavaScript [sol2-JavaScript]
var encode = function(longUrl) {
    const K1 = 1117;
    const K2 = 1000000007;
    this.dataBase = new Map();
    this.urlToKey = new Map();

    if (this.urlToKey.has(longUrl)) {
            return "http://tinyurl.com/" + this.urlToKey.get(longUrl);
        }
        let key = 0;
        let base = 1;
        for (let i = 0; i < longUrl.length; i++) {
            const c = longUrl[i];
            key = (key + c * base) % K2;
            base = (base * K1) % K2;
        }
        while (dataBase.has(key)) {
            key = (key + 1) % K2;
        }
        dataBase.set(key, longUrl);
        urlToKey.set(longUrl, key);
        return "http://tinyurl.com/" + key;
};

var decode = function(shortUrl) {
    const p = shortUrl.lastIndexOf('/') + 1;
    const key = parseInt(shortUrl.substring(p));
    return this.dataBase.get(key);
};
```

```go [sol2-Golang]
const k1, k2 = 1117, 1e9 + 7

type Codec struct {
    dataBase map[int]string
    urlToKey map[string]int
}

func Constructor() Codec {
    return Codec{map[int]string{}, map[string]int{}}
}

func (c *Codec) encode(longUrl string) string {
    if key, ok := c.urlToKey[longUrl]; ok {
        return "http://tinyurl.com/" + strconv.Itoa(key)
    }
    key, base := 0, 1
    for _, c := range longUrl {
        key = (key + int(c)*base) % k2
        base = (base * k1) % k2
    }
    for c.dataBase[key] != "" {
        key = (key + 1) % k2
    }
    c.dataBase[key] = longUrl
    c.urlToKey[longUrl] = key
    return "http://tinyurl.com/" + strconv.Itoa(key)
}

func (c *Codec) decode(shortUrl string) string {
    i := strings.LastIndexByte(shortUrl, '/')
    key, _ := strconv.Atoi(shortUrl[i+1:])
    return c.dataBase[key]
}
```

**复杂度分析**

+ 时间复杂度：
    
    + $\text{Encode}$ 函数：$O(n)$，其中 $n$ 是字符串 $\textit{longUrl}$ 的长度。在数据量远小于 $10^9 + 7$ 的情况下，发生哈希冲突的可能性十分小。

    + $\text{Decode}$ 函数：$O(1)$。我们当 $\textit{shortUrl}$ 当成有限长度的字符串看待。

+ 空间复杂度：

    + $\text{Encode}$ 函数：$O(n)$。保存字符串 $\textit{longUrl}$ 需要 $O(n)$ 的空间。

    + $\text{Decode}$ 函数：$O(1)$。

#### 方法三：随机生成

+ $\text{Encode}$ 函数

    使用一个随机生成的整数作为 $\textit{longUrl}$ 的 $\textit{key}$，如果 $\textit{key}$ 已经重复，那么不断尝试随机生成整数，直到 $\textit{key}$ 唯一。将键值对 $(\textit{key}, \textit{longUrl})$ 插入数据库 $\textit{dataBase}$，然后返回带有 $\textit{key}$ 的字符串作为 $\textit{shorUrl}$。

+ $\text{Decode}$ 函数

    将 $\textit{shortUrl}$ 转换成对应的 $\textit{key}$，然后在数据库 $\textit{dataBase}$ 中查找 $\textit{key}$ 对应的 $\textit{longUrl}$。

```Python [sol3-Python3]
class Codec:
    def __init__(self):
        self.dataBase = {}

    def encode(self, longUrl: str) -> str:
        while True:
            key = randrange(maxsize)
            if key not in self.dataBase:
                self.dataBase[key] = longUrl
                return "http://tinyurl.com/" + str(key)

    def decode(self, shortUrl: str) -> str:
        i = shortUrl.rfind('/')
        key = int(shortUrl[i + 1:])
        return self.dataBase[key]
```

```C++ [sol3-C++]
class Solution {
private:
    unordered_map<int, string> dataBase;

public:
    Solution() {
        srand(time(0));
    }

    string encode(string longUrl) {
        int key;
        while (true) {
            key = rand();
            if (dataBase.count(key) == 0) {
                break;
            }
        }
        dataBase[key] = longUrl;
        return string("http://tinyurl.com/") + to_string(key);
    }

    string decode(string shortUrl) {
        int p = shortUrl.rfind('/') + 1;
        int key = stoi(shortUrl.substr(p, int(shortUrl.size()) - p));
        return dataBase[key];
    }
};
```

```Java [sol3-Java]
public class Codec {
    private Map<Integer, String> dataBase = new HashMap<Integer, String>();
    private Random random = new Random();

    public String encode(String longUrl) {
        int key;
        while (true) {
            key = random.nextInt();
            if (!dataBase.containsKey(key)) {
                break;
            }
        }
        dataBase.put(key, longUrl);
        return "http://tinyurl.com/" + key;
    }

    public String decode(String shortUrl) {
        int p = shortUrl.lastIndexOf('/') + 1;
        int key = Integer.parseInt(shortUrl.substring(p));
        return dataBase.get(key);
    }
}
```

```C# [sol3-C#]
public class Codec {
    private Dictionary<int, string> dataBase = new Dictionary<int, string>();
    private Random random = new Random();

    public string encode(string longUrl) {
        int key;
        while (true) {
            key = random.Next();
            if (!dataBase.ContainsKey(key)) {
                break;
            }
        }
        dataBase.Add(key, longUrl);
        return "http://tinyurl.com/" + key;
    }

    public string decode(string shortUrl) {
        int p = shortUrl.LastIndexOf('/') + 1;
        int key = int.Parse(shortUrl.Substring(p, shortUrl.Length - p));
        return dataBase[key];
    }
}
```

```C [sol3-C]
typedef struct {
    int key;
    char *val;
    UT_hash_handle hh;
} HashItem;

HashItem *dataBase = NULL;

char* encode(char* longUrl) {
    srand(time(0));
    int key;
    HashItem * pEntry = NULL;
    while (true) {
        key = rand();
        pEntry = NULL;
        HASH_FIND_INT(dataBase, &key, pEntry);
        if (NULL == pEntry) {
            break;
        }
    }
    pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = longUrl;
    HASH_ADD_INT(dataBase, key, pEntry);
    char *res = (char *)malloc(sizeof(char) * 64);
    sprintf(res, "%s%d", "http://tinyurl.com/", key); 
    return res;
}

char* decode(char* shortUrl) {
    char *p = shortUrl;
    char *last = shortUrl;
    while (last = strchr(p, '/')) {
        p = last + 1;
    }
    int key = atoi(p);
    HashItem * pEntry = NULL;
    HASH_FIND_INT(dataBase, &key, pEntry);
    if (NULL != pEntry) {
        return pEntry->val;
    }
    return NULL;
}

```

```JavaScript [sol3-JavaScript]
var encode = function(longUrl) {
    this.dataBase = new Map();
    let key;
    while (true) {
        key = Math.floor(Math.random() * (Number.MAX_SAFE_INTEGER));
        if (!dataBase.has(key)) {
            break;
        }
    }
    this.dataBase.set(key, longUrl);
    return "http://tinyurl.com/" + key;
};

var decode = function(shortUrl) {
    const p = shortUrl.lastIndexOf('/') + 1;
    const key = parseInt(shortUrl.substring(p));
    return this.dataBase.get(key);
};
```

```go [sol3-Golang]
import "math/rand"

type Codec map[int]string

func Constructor() Codec {
    return Codec{}
}

func (c Codec) encode(longUrl string) string {
    for {
        key := rand.Int()
        if c[key] == "" {
            c[key] = longUrl
            return "http://tinyurl.com/" + strconv.Itoa(key)
        }
    }
}

func (c Codec) decode(shortUrl string) string {
    i := strings.LastIndexByte(shortUrl, '/')
    key, _ := strconv.Atoi(shortUrl[i+1:])
    return c[key]
}
```

**复杂度分析**

+ 时间复杂度：

    + $\text{Encode}$ 函数：$O(n)$，其中 $n$ 是字符串 $\textit{longUrl}$ 的长度。在数据量远小于 $2^{32}$ 的情况下，随机生成的整数重复的可能性十分小。

    + $\text{Decode}$ 函数：$O(1)$。我们当 $\textit{shortUrl}$ 当成有限长度的字符串看待。

+ 空间复杂度：

    + $\text{Encode}$ 函数：$O(n)$。保存字符串 $\textit{longUrl}$ 需要 $O(n)$ 的空间。

    + $\text{Decode}$ 函数：$O(1)$。