## [771.宝石与石头 中文官方题解](https://leetcode.cn/problems/jewels-and-stones/solutions/100000/bao-shi-yu-shi-tou-by-leetcode-solution)
#### 方法一：暴力

**思路与算法**

暴力法的思路很直观，遍历字符串 $\textit{stones}$，对于 $\textit{stones}$ 中的每个字符，遍历一次字符串 $\textit{jewels}$，如果其和 $\textit{jewels}$ 中的某一个字符相同，则是宝石。

**代码**

```Java [sol1-Java]
class Solution {
    public int numJewelsInStones(String jewels, String stones) {
        int jewelsCount = 0;
        int jewelsLength = jewels.length(), stonesLength = stones.length();
        for (int i = 0; i < stonesLength; i++) {
            char stone = stones.charAt(i);
            for (int j = 0; j < jewelsLength; j++) {
                char jewel = jewels.charAt(j);
                if (stone == jewel) {
                    jewelsCount++;
                    break;
                }
            }
        }
        return jewelsCount;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numJewelsInStones(self, jewels: str, stones: str) -> int:
        return sum(s in jewels for s in stones)
```

```C++ [sol1-C++]
class Solution {
public:
    int numJewelsInStones(string jewels, string stones) {
        int jewelsCount = 0;
        int jewelsLength = jewels.length(), stonesLength = stones.length();
        for (int i = 0; i < stonesLength; i++) {
            char stone = stones[i];
            for (int j = 0; j < jewelsLength; j++) {
                char jewel = jewels[j];
                if (stone == jewel) {
                    jewelsCount++;
                    break;
                }
            }
        }
        return jewelsCount;
    }
};
```

```JavaScript [sol1-JavaScript]
var numJewelsInStones = function(jewels, stones) {
    jewels = jewels.split('');
    return stones.split('').reduce((prev, val) => {
        for (const ch of jewels) {
            if (ch === val) {
                return prev + 1;
            }
        }
        return prev;
    }, 0);
};
```

```Golang [sol1-Golang]
func numJewelsInStones(jewels string, stones string) int {
    jewelsCount := 0
    for _, s := range stones {
        for _, j := range jewels {
            if s == j {
                jewelsCount++
                break
            }
        }
    }
    return jewelsCount
}
```

```C [sol1-C]
int numJewelsInStones(char * jewels, char * stones) {
    int jewelsCount = 0;
    int jewelsLength = strlen(jewels), stonesLength = strlen(stones);
    for (int i = 0; i < stonesLength; i++) {
        char stone = stones[i];
        for (int j = 0; j < jewelsLength; j++) {
            char jewel = jewels[j];
            if (stone == jewel) {
                jewelsCount++;
                break;
            }
        }
    }
    return jewelsCount;
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 是字符串 $\textit{jewels}$ 的长度，$n$ 是字符串 $\textit{stones}$ 的长度。遍历字符串 $\textit{stones}$ 的时间复杂度是 $O(n)$，对于 $\textit{stones}$ 中的每个字符，需要遍历字符串 $\textit{jewels}$ 判断是否是宝石，时间复杂度是 $O(m)$，因此总时间复杂度是 $O(mn)$。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。

#### 方法二：哈希集合

**思路与算法**

方法一中，对于字符串 $\textit{stones}$ 中的每个字符，都需要遍历一次字符串 $\textit{jewels}$，导致时间复杂度较高。如果使用哈希集合存储字符串 $\textit{jewels}$ 中的宝石，则可以降低判断的时间复杂度。

遍历字符串 $\textit{jewels}$，使用哈希集合存储其中的字符，然后遍历字符串 $\textit{stones}$，对于其中的每个字符，如果其在哈希集合中，则是宝石。

**代码**

```Java [sol2-Java]
class Solution {
    public int numJewelsInStones(String jewels, String stones) {
        int jewelsCount = 0;
        Set<Character> jewelsSet = new HashSet<Character>();
        int jewelsLength = jewels.length(), stonesLength = stones.length();
        for (int i = 0; i < jewelsLength; i++) {
            char jewel = jewels.charAt(i);
            jewelsSet.add(jewel);
        }
        for (int i = 0; i < stonesLength; i++) {
            char stone = stones.charAt(i);
            if (jewelsSet.contains(stone)) {
                jewelsCount++;
            }
        }
        return jewelsCount;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def numJewelsInStones(self, jewels: str, stones: str) -> int:
        jewelsSet = set(jewels)
        return sum(s in jewelsSet for s in stones)
```

```C++ [sol2-C++]
class Solution {
public:
    int numJewelsInStones(string jewels, string stones) {
        int jewelsCount = 0;
        unordered_set<char> jewelsSet;
        int jewelsLength = jewels.length(), stonesLength = stones.length();
        for (int i = 0; i < jewelsLength; i++) {
            char jewel = jewels[i];
            jewelsSet.insert(jewel);
        }
        for (int i = 0; i < stonesLength; i++) {
            char stone = stones[i];
            if (jewelsSet.count(stone)) {
                jewelsCount++;
            }
        }
        return jewelsCount;
    }
};
```

```JavaScript [sol2-JavaScript]
var numJewelsInStones = function(jewels, stones) {
    const jewelsSet = new Set(jewels.split(''));
    return stones.split('').reduce((prev, val) => {
        return prev + jewelsSet.has(val);
    }, 0);
};
```

```Golang [sol2-Golang]
func numJewelsInStones(jewels string, stones string) int {
    jewelsCount := 0
    jewelsSet := map[byte]bool{}
    for i := range jewels {
        jewelsSet[jewels[i]] = true
    }
    for i := range stones {
        if jewelsSet[stones[i]] {
            jewelsCount++
        }
    }
    return jewelsCount
}
```

```C [sol2-C]
struct HashTable {
    int key;
    UT_hash_handle hh;
};

struct HashTable* jewelsSet;

struct HashTable* find(int ikey) {
    struct HashTable* tmp = NULL;
    HASH_FIND_INT(jewelsSet, &ikey, tmp);
    return tmp;
}

void insert(int ikey) {
    struct HashTable* rec = find(ikey);
    if (rec == NULL) {
        struct HashTable* tmp = malloc(sizeof(struct HashTable));
        tmp->key = ikey;
        HASH_ADD_INT(jewelsSet, key, tmp);
    }
}

int numJewelsInStones(char * jewels, char * stones) {
    int jewelsCount = 0;
    jewelsSet = NULL;
    int jewelsLength = strlen(jewels), stonesLength = strlen(stones);
    for (int i = 0; i < jewelsLength; i++) {
        char jewel = jewels[i];
        insert(jewel);
    }
    for (int i = 0; i < stonesLength; i++) {
        char stone = stones[i];
        if (find(stone) != NULL) {
            jewelsCount++;
        }
    }
    return jewelsCount;
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 是字符串 $\textit{jewels}$ 的长度，$n$ 是字符串 $\textit{stones}$ 的长度。遍历字符串 $\textit{jewels}$ 将其中的字符存储到哈希集合中，时间复杂度是 $O(m)$，然后遍历字符串 $\textit{stones}$，对于 $\textit{stones}$ 中的每个字符在 $O(1)$ 的时间内判断当前字符是否是宝石，时间复杂度是 $O(n)$，因此总时间复杂度是 $O(m+n)$。

- 空间复杂度：$O(m)$，其中 $m$ 是字符串 $\textit{jewels}$ 的长度。使用哈希集合存储字符串 $\textit{jewels}$ 中的字符。