## [2423.删除字符使频率相同 中文官方题解](https://leetcode.cn/problems/remove-letter-to-equalize-frequency/solutions/100000/shan-chu-zi-fu-shi-pin-lu-xiang-tong-by-bz1ix)
#### 方法一：枚举

**思路与算法**

题目要求选择一个下标并删除下标处的字符，使得 $\textit{word}$ 中剩余每个字母出现频率相同。

暴力方法可以尝试删除不同下标处字符，复杂度为 $O(n^2)$，其中 $n$ 是字符串 $\textit{word}$ 的长度。

注意到删除不同位置的相同字符，不会改变剩余字符的频率，我们可以进行优化，只枚举删除不同的字符即可。

首先遍历输入字符串 $\textit{word}$，统计每一个字符出现的频率。然后我们按照字母序，遍历所有的字符。如果当前这个字符出现在原字符串中，我们假定要删除这个字符，把这个字符出现的频率减一，统计所有出现字符的频率集合。如果集合大小为 $1$，则说明剩余每个字母出现频率相同，我们直接返回 $\text{true}$，反之说明删除当前字符不可行，我们把这个字符的频率加一进行还原。

最后，当我们尝试过所有不同字符后，还没有找到能删除的字符，使得满足要求，我们返回 $\text{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool equalFrequency(string word) {
        int charCount[26] = {0};
        for (char& c : word) {
            charCount[c - 'a']++;
        }
        for (int i = 0; i < 26; i++) {
            if (charCount[i] == 0) {
                continue;
            }
            charCount[i]--;
            unordered_set<int> frequency;
            for (int f : charCount) {
                if (f > 0) {
                    frequency.insert(f);
                }
            }
            if (frequency.size() == 1) {
                return true;
            }
            charCount[i]++;
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean equalFrequency(String word) {
        int[] charCount = new int[26];
        int n = word.length();
        for (int i = 0; i < n; i++) {
            charCount[word.charAt(i) - 'a']++;
        }
        for (int i = 0; i < 26; i++) {
            if (charCount[i] == 0) {
                continue;
            }
            charCount[i]--;
            HashSet<Integer> frequency = new HashSet<Integer>();
            for (int f : charCount) {
                if (f > 0) {
                    frequency.add(f);
                }
            }
            if (frequency.size() == 1) {
                return true;
            }
            charCount[i]++;
        }
        return false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def equalFrequency(self, word: str) -> bool:
        charCount = [0] * 26
        for c in word:
            charCount[ord(c) - ord('a')] += 1
        for i in range(26):
            if charCount[i] == 0: continue
            charCount[i] -= 1
            frequency = set(f for f in charCount if f > 0)
            if len(frequency) == 1:
                return True
            charCount[i] += 1
        return False
```

```Go [sol1-Go]
func equalFrequency(word string) bool {
    charCount := [26]int{}
    for _, c := range word {
        charCount[c - 'a']++
    }
    for i := 0; i < 26; i++ {
        if charCount[i] == 0 {
            continue
        }
        charCount[i]--
        frequency := make(map[int]bool)
        for _, f := range charCount {
            if f > 0 {
                frequency[f] = true
            }
        }
        if len(frequency) == 1 {
            return true
        }
        charCount[i]++
    }
    return false
}

```

```C# [sol1-C#]
public class Solution {
    public bool EqualFrequency(string word) {
        int[] charCount = new int[26];
        foreach (char c in word) {
            charCount[c - 'a']++;
        }
        for (int i = 0; i < 26; i++) {
            if (charCount[i] == 0) {
                continue;
            }
            charCount[i]--;
            HashSet<int> frequency = new HashSet<int>();
            foreach (int f in charCount) {
                if (f > 0) {
                    frequency.Add(f);
                }
            }
            if (frequency.Count == 1) {
                return true;
            }
            charCount[i]++;
        }
        return false;
    }
}
```

```JavaScript [sol1-JavaScript]
var equalFrequency = function(word) {
    const charCount = new Array(26).fill(0);
    for (let c of word) {
        charCount[c.charCodeAt(0) - 'a'.charCodeAt(0)]++;
    }
    for (let i = 0; i < 26; i++) {
        if (charCount[i] == 0) {
            continue;
        }
        charCount[i]--;
        const frequency = new Set();
        for (const f of charCount) {
            if (f > 0) {
                frequency.add(f);
            }
        }
        if (frequency.size == 1) {
            return true;
        }
        charCount[i]++;
    }
    return false;
};
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

bool equalFrequency(char * word) {
    int charCount[26] = {0};
    int len = strlen(word);
    for (int i = 0; i < len; i++) {
        charCount[word[i] - 'a']++;
    }
    for (int i = 0; i < 26; i++) {
        if (charCount[i] == 0) {
            continue;
        }
        charCount[i]--;
        HashItem *frequency = NULL;
        for (int j = 0; j < 26; j++) {
            int freq = charCount[j];
            if (freq > 0) {
                hashAddItem(&frequency, freq);
            }
        }
        int total = HASH_COUNT(frequency);
        hashFree(&frequency);
        if (total == 1) {
            return true;
        }
        charCount[i]++;
    }
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n+|\Sigma|^2)$，其中 $n$ 是字符串 $\textit{word}$ 的长度, $\Sigma$ 为字符集，在本题中字符集为所有小写字母，$|\Sigma| = 26$。

- 空间复杂度：$O(|\Sigma|)$，$\Sigma$ 为字符集，在本题中字符集为所有小写字母，$|\Sigma| = 26$。


#### 方法二：枚举 + 哈希表

**思路与算法**

在方法一中，我们每次枚举要删除的字符后，都要重新统计所有字符出现的频率，造成了重复的运算。这里我们可以使用哈希表进行优化，在枚举之前，先统计不同字符频率的频率。

假如一个字符出现的频率是 $c$，那这个字符删除一个后，频率就从 $c$ 变成了 $c - 1$。我们只需要更新哈希表中 $c$ 和 $c - 1$ 的频率，再判断哈希表的大小是否为一就可以了。如果哈希表大小为 $1$，则说明剩余每个字母出现频率相同，我们直接返回 $\text{true}$，反之说明删除当前字符不可行，我们把这个字符的频率就从 $c - 1$ 变成 $c$，更新哈希表进行还原。

要注意更新哈希表后，如果一个键对 $\langle \textit{key}, \textit{value} \rangle$ 中 $\textit{value} = 0$，我们需要手动删除 $\textit{key}$。

最后，当我们尝试过所有不同字符后，还没有找到能删除的字符，使得满足要求，我们返回 $\text{false}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool equalFrequency(string word) {
        int charCount[26] = {0};
        for (char c : word) {
            charCount[c - 'a']++;
        }
        unordered_map<int, int> freqCount;
        for (int c : charCount) {
            if (c > 0) {
                freqCount[c]++;
            }
        }
        for (int c : charCount) {
            if (c == 0) {
                continue;
            }
            freqCount[c]--;
            if (freqCount[c] == 0) {
                freqCount.erase(c);
            }
            if (c - 1 > 0) {
                freqCount[c - 1]++;
            }
            if (freqCount.size() == 1) {
                return true;
            }
            if (c - 1 > 0) {
                freqCount[c - 1]--;
                if (freqCount[c - 1] == 0) {
                    freqCount.erase(c - 1);
                }
            }
            freqCount[c]++;
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean equalFrequency(String word) {
        int[] charCount = new int[26];
        for (char c : word.toCharArray()) {
            charCount[c - 'a']++;
        }
        Map<Integer, Integer> freqCount = new HashMap<>();
        for (int c : charCount) {
            if (c > 0) {
                freqCount.put(c, freqCount.getOrDefault(c, 0) + 1);
            }
        }
        for (int c : charCount) {
            if (c == 0) {
                continue;
            }
            freqCount.put(c, freqCount.get(c) - 1);
            if (freqCount.get(c) == 0) {
                freqCount.remove(c);
            }
            if (c - 1 > 0) {
                freqCount.put(c - 1, freqCount.getOrDefault(c - 1, 0) + 1);
            }
            if (freqCount.size() == 1) {
                return true;
            }
            if (c - 1 > 0) {
                freqCount.put(c - 1, freqCount.get(c - 1) - 1);
                if (freqCount.get(c - 1) == 0) {
                    freqCount.remove(c - 1);
                }
            }
            freqCount.put(c, freqCount.getOrDefault(c, 0) + 1);
        }
        return false;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def equalFrequency(self, word: str) -> bool:
        charCount = [0] * 26
        for c in word:
            charCount[ord(c) - ord('a')] += 1
        freqCount = Counter(c for c in charCount if c > 0)
        for c in charCount:
            if c == 0: continue
            freqCount[c] -= 1
            if freqCount[c] == 0:
                del freqCount[c]
            if c - 1 > 0:
                freqCount[c - 1] += 1
            if len(freqCount) == 1:
                return True
            if c - 1 > 0:
                freqCount[c - 1] -= 1
            if freqCount[c - 1] == 0:
                del freqCount[c - 1]
            freqCount[c] += 1
        return False
```

```Go [sol2-Go]
func equalFrequency(word string) bool {
    charCount := [26]int{}
    for _, c := range word {
        charCount[c - 'a'] += 1
    }
    freqCount := make(map[int]int)
    for _, c := range charCount {
        if c > 0 {
            freqCount[c] += 1
        }
    }
    for _, c := range charCount {
        if c == 0 {
            continue
        }
        freqCount[c] -= 1
        if freqCount[c] == 0 {
            delete(freqCount, c)
        }
        if c - 1 > 0 {
            freqCount[c - 1] += 1
        }
        if len(freqCount) == 1 {
            return true
        }
        if c - 1 > 0 {
            freqCount[c - 1] -= 1
            if freqCount[c - 1] == 0 {
                delete(freqCount, c - 1)
            }
        }
        freqCount[c] += 1
    }
    return false
}
```

```C# [sol2-C#]
public class Solution {
    public bool EqualFrequency(string word) {
        int[] charCount = new int[26];
        foreach (char c in word) {
            charCount[c - 'a'] += 1;
        }
        Dictionary<int, int> freqCount = new Dictionary<int, int>();
        foreach (int c in charCount) {
            if (c > 0) {
                if (freqCount.ContainsKey(c)) {
                    freqCount[c] += 1;
                } else {
                    freqCount.Add(c, 1);
                }
            }
        }
        foreach (int c in charCount) {
            if (c == 0) {
                continue;
            }
            freqCount[c] -= 1;
            if (freqCount[c] == 0) {
                freqCount.Remove(c);
            }
            if (c - 1 > 0) {
                if (freqCount.ContainsKey(c - 1)) {
                    freqCount[c - 1] += 1;
                } else {
                    freqCount.Add(c - 1, 1);
                }
            }
            if (freqCount.Count == 1) {
                return true;
            }
            if (c - 1 > 0) {
                freqCount[c - 1] -= 1;
                if (freqCount[c - 1] == 0) {
                    freqCount.Remove(c - 1);
                }
            }
            if (freqCount.ContainsKey(c)) {
                freqCount[c] += 1;
            } else {
                freqCount.Add(c, 1);
            }
        }
        return false;
    }
}
```

```JavaScript [sol2-JavaScript]
var equalFrequency = function(word) {
    let charCount = new Array(26).fill(0);
    for (let c of word) {
        charCount[c.charCodeAt(0) - 'a'.charCodeAt(0)]++;
    }
    let freqCount = new Map();
    for (let c of charCount) {
        if (c > 0) {
            freqCount.set(c, (freqCount.get(c) || 0) + 1);
        }
    }
    for (let c of charCount) {
        if (c == 0) {
            continue;
        }
        freqCount.set(c, freqCount.get(c) - 1);
        if (freqCount.get(c) == 0) {
            freqCount.delete(c);
        }
        if (c - 1 > 0) {
            freqCount.set(c - 1, (freqCount.get(c - 1) || 0) + 1);
        }
        if (freqCount.size == 1) {
            return true;
        }
        if (c - 1 > 0) {
            freqCount.set(c - 1, freqCount.get(c - 1) - 1);
            if (freqCount.get(c - 1) == 0) {
            freqCount.delete(c - 1);
            }
        }
        freqCount.set(c, (freqCount.get(c) || 0) + 1);
    }
    return false;
};
```

```C [sol2-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashEraseItem(HashItem **obj, const char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    HASH_DEL(*obj, pEntry);
    free(pEntry);
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

bool equalFrequency(char * word) {
    int charCount[26] = {0};
    int len = strlen(word);
    for (int i = 0; i < len; i++) {
        char c = word[i];
        charCount[c - 'a']++;
    }
    HashItem *freqCount = NULL;
    for (int i = 0; i < 26; i++) {
        char freq = charCount[i];
        if (freq > 0) {
            hashSetItem(&freqCount, freq, hashGetItem(&freqCount, freq, 0) + 1);
        }
    }
    for (int i = 0; i < 26; i++) {
        int freq = charCount[i];
        if (freq == 0) {
            continue;
        }
        hashSetItem(&freqCount, freq, hashGetItem(&freqCount, freq, 0) - 1);
        if (hashGetItem(&freqCount, freq, 0) == 0) {
            hashEraseItem(&freqCount, freq);
        }
        if (freq - 1 > 0) {
            hashSetItem(&freqCount, freq - 1, hashGetItem(&freqCount, freq - 1, 0) + 1);
        }
        if (HASH_COUNT(freqCount) == 1) {
            hashFree(&freqCount);
            return true;
        }
        if (freq - 1 > 0) {
            hashSetItem(&freqCount, freq - 1, hashGetItem(&freqCount, freq - 1, 0) - 1);
            if (hashGetItem(&freqCount, freq - 1, 0) == 0) {
                hashEraseItem(&freqCount, freq - 1);
            }
        }
        hashSetItem(&freqCount, freq, hashGetItem(&freqCount, freq, 0) + 1);
    }
    hashFree(&freqCount);
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n+|\Sigma|)$，其中 $n$ 是字符串 $\textit{word}$ 的长度, $\Sigma$ 为字符集，在本题中字符集为所有小写字母，$|\Sigma| = 26$。

- 空间复杂度：$O(|\Sigma|)$，$\Sigma$ 为字符集，在本题中字符集为所有小写字母，$|\Sigma| = 26$。