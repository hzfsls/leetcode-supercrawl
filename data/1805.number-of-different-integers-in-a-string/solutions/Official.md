#### 方法一：双指针

对于每个字符串中的整数部分，使用指针 $p_1$ 指向整数部分的第一个字符，指针 $p_2$ 指向整数部分最后一个字符的下一个位置。为了去除前导零，如果 $p_2 - p_1 \gt 1$ 且 $\textit{word}[p_1] = `0’$，我们将 $p_1$ 前移一位，即 $p_1 = p_1+1$。将区间 $[p_1, p_2)$ 对应的字符串插入到哈希集合中，最终字符串中不同整数的数目等于哈希集合的元素数目。

```Python [sol1-Python3]
class Solution:
    def numDifferentIntegers(self, word: str) -> int:
        s = set()
        n = len(word)
        p1 = 0
        while True:
            while p1 < n and not word[p1].isdigit():
                p1 += 1
            if p1 == n:
                break
            p2 = p1
            while p2 < n and word[p2].isdigit():
                p2 += 1
            while p2 - p1 > 1 and word[p1] == '0':  # 去除前导 0
                p1 += 1
            s.add(word[p1:p2])
            p1 = p2
        return len(s)
```

```C++ [sol1-C++]
class Solution {
public:
    int numDifferentIntegers(string word) {
        unordered_set<string> s;
        int n = word.size(), p1 = 0, p2;
        while (true) {
            while (p1 < n && !isdigit(word[p1])) {
                p1++;
            }
            if (p1 == n) {
                break;
            }
            p2 = p1;
            while (p2 < n && isdigit(word[p2])) {
                p2++;
            }
            while (p2 - p1 > 1 && word[p1] == '0') { // 去除前导 0
                p1++;
            }
            s.insert(word.substr(p1, p2 - p1));
            p1 = p2;
        }
        return s.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numDifferentIntegers(String word) {
        Set<String> set = new HashSet<String>();
        int n = word.length(), p1 = 0, p2;
        while (true) {
            while (p1 < n && !Character.isDigit(word.charAt(p1))) {
                p1++;
            }
            if (p1 == n) {
                break;
            }
            p2 = p1;
            while (p2 < n && Character.isDigit(word.charAt(p2))) {
                p2++;
            }
            while (p2 - p1 > 1 && word.charAt(p1) == '0') { // 去除前导 0
                p1++;
            }
            set.add(word.substring(p1, p2));
            p1 = p2;
        }
        return set.size();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumDifferentIntegers(string word) {
        ISet<string> set = new HashSet<string>();
        int n = word.Length, p1 = 0, p2;
        while (true) {
            while (p1 < n && !char.IsDigit(word[p1])) {
                p1++;
            }
            if (p1 == n) {
                break;
            }
            p2 = p1;
            while (p2 < n && char.IsDigit(word[p2])) {
                p2++;
            }
            while (p2 - p1 > 1 && word[p1] == '0') { // 去除前导 0
                p1++;
            }
            set.Add(word.Substring(p1, p2 - p1));
            p1 = p2;
        }
        return set.Count;
    }
}
```

```C [sol1-C]
typedef struct {
    char *key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, const char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, const char* key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr->key);
        free(curr);             
    }
}

int numDifferentIntegers(char * word) {
    HashItem *s = NULL;
    int n = strlen(word), p1 = 0, p2;
    while (true) {
        while (p1 < n && !isdigit(word[p1])) {
            p1++;
        }
        if (p1 == n) {
            break;
        }
        p2 = p1;
        while (p2 < n && isdigit(word[p2])) {
            p2++;
        }
        while (p2 - p1 > 1 && word[p1] == '0') { // 去除前导 0
            p1++;
        }
        char *str = (char *)malloc(sizeof(char) * (p2 - p1 + 1));
        strncpy(str, word + p1, p2 - p1);
        str[p2 - p1] = '\0';
        if (hashFindItem(&s, str) == NULL) {
            hashAddItem(&s, str);
        } else {
            free(str);
        }
        p1 = p2;
    }
    int ret = HASH_COUNT(s);
    hashFree(&s);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var numDifferentIntegers = function(word) {
    const set = new Set();
    let n = word.length, p1 = 0, p2;
    while (true) {
        while (p1 < n && !isDigit(word[p1])) {
            p1++;
        }
        if (p1 === n) {
            break;
        }
        p2 = p1;
        while (p2 < n && isDigit(word[p2])) {
            p2++;
        }
        while (p2 - p1 > 1 && word[p1] === '0') {
            p1++;
        }
        set.add(word.slice(p1, p2));
        p1 = p2;
    }
    return set.size;
};

const isDigit = (ch) => {
    return '0' <= ch && ch <= '9';
}
```

```go [sol1-Golang]
func numDifferentIntegers(word string) int {
    s := map[string]bool{}
    n := len(word)
    p1 := 0
    for {
        for p1 < n && !unicode.IsDigit(rune(word[p1])) {
            p1++
        }
        if p1 == n {
            break
        }
        p2 := p1
        for p2 < n && unicode.IsDigit(rune(word[p2])) {
            p2++
        }
        for p2-p1 > 1 && word[p1] == '0' { // 去除前导 0
            p1++
        }
        s[word[p1:p2]] = true
        p1 = p2
    }
    return len(s)
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{word}$ 的长度。

+ 空间复杂度：$O(n)$。哈希集合需要占用 $O(n)$ 的空间。