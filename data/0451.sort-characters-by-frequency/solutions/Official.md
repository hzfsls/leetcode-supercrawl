## [451.根据字符出现频率排序 中文官方题解](https://leetcode.cn/problems/sort-characters-by-frequency/solutions/100000/gen-ju-zi-fu-chu-xian-pin-lu-pai-xu-by-l-zmvy)
#### 方法一：按照出现频率排序

题目要求将给定的字符串按照字符出现的频率降序排序，因此需要首先遍历字符串，统计每个字符出现的频率，然后每次得到频率最高的字符，生成排序后的字符串。

可以使用哈希表记录每个字符出现的频率，将字符去重后存入列表，再将列表中的字符按照频率降序排序。

生成排序后的字符串时，遍历列表中的每个字符，则遍历顺序为字符按照频率递减的顺序。对于每个字符，将该字符按照出现频率拼接到排序后的字符串。例如，遍历到字符 $c$，该字符在字符串中出现了 $\textit{freq}$ 次，则将 $\textit{freq}$ 个字符 $c$ 拼接到排序后的字符串。

也可以使用优先队列或大根堆存储字符，读者可以自行尝试。

```Java [sol1-Java]
class Solution {
    public String frequencySort(String s) {
        Map<Character, Integer> map = new HashMap<Character, Integer>();
        int length = s.length();
        for (int i = 0; i < length; i++) {
            char c = s.charAt(i);
            int frequency = map.getOrDefault(c, 0) + 1;
            map.put(c, frequency);
        }
        List<Character> list = new ArrayList<Character>(map.keySet());
        Collections.sort(list, (a, b) -> map.get(b) - map.get(a));
        StringBuffer sb = new StringBuffer();
        int size = list.size();
        for (int i = 0; i < size; i++) {
            char c = list.get(i);
            int frequency = map.get(c);
            for (int j = 0; j < frequency; j++) {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string FrequencySort(string s) {
        Dictionary<char, int> dictionary = new Dictionary<char, int>();
        int length = s.Length;
        for (int i = 0; i < length; i++) {
            char c = s[i];
            if (dictionary.ContainsKey(c)) {
                dictionary[c]++;
            } else {
                dictionary.Add(c, 1);
            }
        }
        List<char> list = new List<char>(dictionary.Keys);
        list.Sort((a, b) => dictionary[b] - dictionary[a]);
        StringBuilder sb = new StringBuilder();
        int size = list.Count;
        for (int i = 0; i < size; i++) {
            char c = list[i];
            int frequency = dictionary[c];
            for (int j = 0; j < frequency; j++) {
                sb.Append(c);
            }
        }
        return sb.ToString();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string frequencySort(string s) {
        unordered_map<char, int> mp;
        int length = s.length();
        for (auto &ch : s) {
            mp[ch]++;
        }
        vector<pair<char, int>> vec;
        for (auto &it : mp) {
            vec.emplace_back(it);
        }
        sort(vec.begin(), vec.end(), [](const pair<char, int> &a, const pair<char, int> &b) {
            return a.second > b.second;
        });
        string ret;
        for (auto &[ch, num] : vec) {
            for (int i = 0; i < num; i++) {
                ret.push_back(ch);
            }
        }
        return ret;
    }
};
```

```C [sol1-C]
#define HASH_FIND_CHAR(head, findint, out) HASH_FIND(hh, head, findint, sizeof(char), out)
#define HASH_ADD_CHAR(head, intfield, add) HASH_ADD(hh, head, intfield, sizeof(char), add)

struct HashTable {
    char key;
    int val;
    UT_hash_handle hh;
};

int cmp(struct HashTable* a, struct HashTable* b) {
    return b->val - a->val;
}

char* frequencySort(char* s) {
    struct HashTable* hashTable = NULL;
    int length = strlen(s);
    for (int i = 0; i < length; i++) {
        struct HashTable* tmp;
        HASH_FIND_CHAR(hashTable, &s[i], tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = s[i], tmp->val = 1;
            HASH_ADD_CHAR(hashTable, key, tmp);
        } else {
            tmp->val++;
        }
    }
    int n = HASH_COUNT(hashTable);
    HASH_SORT(hashTable, cmp);
    int retSize = 0;
    struct HashTable *tmp, *iter;
    HASH_ITER(hh, hashTable, iter, tmp) {
        retSize += iter->val;
    }
    char* ret = malloc(sizeof(char) * (retSize + 1));
    retSize = 0;
    HASH_ITER(hh, hashTable, iter, tmp) {
        for (int i = 0; i < iter->val; i++) {
            ret[retSize++] = iter->key;
        }
    }
    ret[retSize] = '\0';
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var frequencySort = function(s) {
    const map = new Map();
    const length = s.length;
    for (let i = 0; i < length; i++) {
        const c = s[i];
        const frequency = (map.get(c) || 0) + 1;
        map.set(c, frequency);
    }
    const list = [...map.keys()];
    list.sort((a, b) => map.get(b) - map.get(a));
    const sb = [];
    const size = list.length;
    for (let i = 0; i < size; i++) {
        const c = list[i];
        const frequency = map.get(c);
        for (let j = 0; j < frequency; j++) {
            sb.push(c);
        }
    }
    return sb.join('');
};
```

```go [sol1-Golang]
func frequencySort(s string) string {
    cnt := map[byte]int{}
    for i := range s {
        cnt[s[i]]++
    }

    type pair struct {
        ch  byte
        cnt int
    }
    pairs := make([]pair, 0, len(cnt))
    for k, v := range cnt {
        pairs = append(pairs, pair{k, v})
    }
    sort.Slice(pairs, func(i, j int) bool { return pairs[i].cnt > pairs[j].cnt })

    ans := make([]byte, 0, len(s))
    for _, p := range pairs {
        ans = append(ans, bytes.Repeat([]byte{p.ch}, p.cnt)...)
    }
    return string(ans)
}
```

**复杂度分析**

- 时间复杂度：$O(n + k \log k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串 $s$ 包含的不同字符的个数，这道题中 $s$ 只包含大写字母、小写字母和数字，因此 $k=26 + 26 + 10 = 62$。
  遍历字符串统计每个字符出现的频率需要 $O(n)$ 的时间。
  将字符按照出现频率排序需要 $O(k \log k)$ 的时间。
  生成排序后的字符串，需要遍历 $k$ 个不同字符，需要 $O(k)$ 的时间，拼接字符串需要 $O(n)$ 的时间。
  因此总时间复杂度是 $O(n + k \log k + k + n)=O(n + k \log k)$。

- 空间复杂度：$O(n + k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串 $s$ 包含的不同字符的个数。空间复杂度主要取决于哈希表、列表和生成的排序后的字符串。

#### 方法二：桶排序

由于每个字符在字符串中出现的频率存在上限，因此可以使用桶排序的思想，根据出现次数生成排序后的字符串。具体做法如下：

1. 遍历字符串，统计每个字符出现的频率，同时记录最高频率 $\textit{maxFreq}$；

2. 创建桶，存储从 $1$ 到 $\textit{maxFreq}$ 的每个出现频率的字符；

3. 按照出现频率从大到小的顺序遍历桶，对于每个出现频率，获得对应的字符，然后将每个字符按照出现频率拼接到排序后的字符串。

```Java [sol2-Java]
class Solution {
    public String frequencySort(String s) {
        Map<Character, Integer> map = new HashMap<Character, Integer>();
        int maxFreq = 0;
        int length = s.length();
        for (int i = 0; i < length; i++) {
            char c = s.charAt(i);
            int frequency = map.getOrDefault(c, 0) + 1;
            map.put(c, frequency);
            maxFreq = Math.max(maxFreq, frequency);
        }
        StringBuffer[] buckets = new StringBuffer[maxFreq + 1];
        for (int i = 0; i <= maxFreq; i++) {
            buckets[i] = new StringBuffer();
        }
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            char c = entry.getKey();
            int frequency = entry.getValue();
            buckets[frequency].append(c);
        }
        StringBuffer sb = new StringBuffer();
        for (int i = maxFreq; i > 0; i--) {
            StringBuffer bucket = buckets[i];
            int size = bucket.length();
            for (int j = 0; j < size; j++) {
                for (int k = 0; k < i; k++) {
                    sb.append(bucket.charAt(j));
                }
            }
        }
        return sb.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string FrequencySort(string s) {
        Dictionary<char, int> dictionary = new Dictionary<char, int>();
        int maxFreq = 0;
        int length = s.Length;
        for (int i = 0; i < length; i++) {
            char c = s[i];
            if (dictionary.ContainsKey(c)) {
                dictionary[c]++;
            } else {
                dictionary.Add(c, 1);
            }
            maxFreq = Math.Max(maxFreq, dictionary[c]);
        }
        StringBuilder[] buckets = new StringBuilder[maxFreq + 1];
        for (int i = 0; i <= maxFreq; i++) {
            buckets[i] = new StringBuilder();
        }
        foreach (KeyValuePair<char, int> pair in dictionary) {
            char c = pair.Key;
            int frequency = pair.Value;
            buckets[frequency].Append(c);
        }
        StringBuilder sb = new StringBuilder();
        for (int i = maxFreq; i > 0; i--) {
            StringBuilder bucket = buckets[i];
            int size = bucket.Length;
            for (int j = 0; j < size; j++) {
                for (int k = 0; k < i; k++) {
                    sb.Append(bucket[j]);
                }
            }
        }
        return sb.ToString();
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    string frequencySort(string s) {
        unordered_map<char, int> mp;
        int maxFreq = 0;
        int length = s.size();
        for (auto &ch : s) {
            maxFreq = max(maxFreq, ++mp[ch]);
        }
        vector<string> buckets(maxFreq + 1);
        for (auto &[ch, num] : mp) {
            buckets[num].push_back(ch);
        }
        string ret;
        for (int i = maxFreq; i > 0; i--) {
            string &bucket = buckets[i];
            for (auto &ch : bucket) {
                for (int k = 0; k < i; k++) {
                    ret.push_back(ch);
                }
            }
        }
        return ret;
    }
};
```

```C [sol2-C]
#define HASH_FIND_CHAR(head, findint, out) HASH_FIND(hh, head, findint, sizeof(char), out)
#define HASH_ADD_CHAR(head, intfield, add) HASH_ADD(hh, head, intfield, sizeof(char), add)

struct HashTable {
    char key;
    int val;
    UT_hash_handle hh;
};

char* frequencySort(char* s) {
    struct HashTable* hashTable = NULL;
    int maxFreq = 0;
    int length = strlen(s);
    for (int i = 0; i < length; i++) {
        struct HashTable* tmp;
        HASH_FIND_CHAR(hashTable, &s[i], tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = s[i], tmp->val = 1;
            HASH_ADD_CHAR(hashTable, key, tmp);
            maxFreq = fmax(maxFreq, 1);
        } else {
            maxFreq = fmax(maxFreq, ++tmp->val);
        }
    }
    char* buckets[maxFreq + 1];
    int bucketsSize[maxFreq + 1];
    memset(bucketsSize, 0, sizeof(bucketsSize));
    int retSize = 0;
    struct HashTable *tmp, *iter;
    HASH_ITER(hh, hashTable, iter, tmp) {
        bucketsSize[iter->val]++;
        retSize += iter->val;
    }
    for (int i = 1; i <= maxFreq; i++) {
        buckets[i] = malloc(sizeof(char) * bucketsSize[i]);
    }
    memset(bucketsSize, 0, sizeof(bucketsSize));
    HASH_ITER(hh, hashTable, iter, tmp) {
        buckets[iter->val][bucketsSize[iter->val]++] = iter->key;
    }
    char* ret = malloc(sizeof(char) * (retSize + 1));
    retSize = 0;
    for (int i = maxFreq; i > 0; i--) {
        char* bucket = buckets[i];
        for (int j = 0; j < bucketsSize[i]; j++) {
            for (int k = 0; k < i; k++) {
                ret[retSize++] = bucket[j];
            }
        }
    }
    ret[retSize] = '\0';
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var frequencySort = function(s) {
    const mp = new Map();
    let maxFreq = 0;
    const length = s.length;
    for (const ch of s) {
        const frequency = (mp.get(ch) || 0) + 1;
        mp.set(ch, frequency);
        maxFreq = Math.max(maxFreq, frequency);
    }
    const buckets = new Array(maxFreq + 1).fill(0).map(() => new Array());
    for (const [ch, num] of mp.entries()) {
        buckets[num].push(ch);
    }
    const ret = [];
    for (let i = maxFreq; i > 0; i--) {
        const bucket = buckets[i];
        for (const ch of bucket) {
            for (let k = 0; k < i; k++) {
                ret.push(ch);
            }
        }
    }
    return ret.join('');
};
```

```go [sol2-Golang]
func frequencySort(s string) string {
    cnt := map[byte]int{}
    maxFreq := 0
    for i := range s {
        cnt[s[i]]++
        maxFreq = max(maxFreq, cnt[s[i]])
    }

    buckets := make([][]byte, maxFreq+1)
    for ch, c := range cnt {
        buckets[c] = append(buckets[c], ch)
    }

    ans := make([]byte, 0, len(s))
    for i := maxFreq; i > 0; i-- {
        for _, ch := range buckets[i] {
            ans = append(ans, bytes.Repeat([]byte{ch}, i)...)
        }
    }
    return string(ans)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n + k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串 $s$ 包含的不同字符的个数。
  遍历字符串统计每个字符出现的频率需要 $O(n)$ 的时间。
  创建桶并将不同字符加入桶需要 $O(k)$ 的时间。
  生成排序后的字符串，需要 $O(k)$ 的时间遍历桶，以及 $O(n)$ 的时拼接字符串间。
  因此总时间复杂度是 $O(n + k)$。

- 空间复杂度：$O(n + k)$，其中 $n$ 是字符串 $s$ 的长度，$k$ 是字符串 $s$ 包含的不同字符的个数。空间复杂度主要取决于桶和生成的排序后的字符串。