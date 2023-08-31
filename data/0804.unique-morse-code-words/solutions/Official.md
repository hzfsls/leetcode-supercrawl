## [804.唯一摩尔斯密码词 中文官方题解](https://leetcode.cn/problems/unique-morse-code-words/solutions/100000/wei-yi-mo-er-si-mi-ma-ci-by-leetcode-sol-9n7w)
#### 方法一：哈希表

**思路与算法**

我们将数组 $\textit{words}$ 中的每个单词按照莫尔斯密码表转换为摩尔斯码，并加入哈希集合中，最终的答案即为哈希集合中元素的个数。

**代码**

```Python [sol1-Python3]
MORSE = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.",
         "....", "..", ".---", "-.-", ".-..", "--", "-.",
         "---", ".--.", "--.-", ".-.", "...", "-", "..-",
         "...-", ".--", "-..-", "-.--", "--.."]

class Solution:
    def uniqueMorseRepresentations(self, words: List[str]) -> int:
        return len(set("".join(MORSE[ord(ch) - ord('a')] for ch in word) for word in words))
```

```Java [sol1-Java]
class Solution {
    public static final String[] MORSE = {".-", "-...", "-.-.", "-..", ".", "..-.", "--.",
                                      "....", "..", ".---", "-.-", ".-..", "--", "-.",
                                      "---", ".--.", "--.-", ".-.", "...", "-", "..-",
                                      "...-", ".--", "-..-", "-.--", "--.."};

    public int uniqueMorseRepresentations(String[] words) {
        Set<String> seen = new HashSet<String>();
        for (String word : words) {
            StringBuilder code = new StringBuilder();
            for (int i = 0; i < word.length(); i++) {
                char c = word.charAt(i);
                code.append(MORSE[c - 'a']);
            }
            seen.add(code.toString());
        }
        return seen.size();
    }
}
```

```C++ [sol1-C++]
const static string MORSE[] = {
        ".-", "-...", "-.-.", "-..", ".", "..-.", "--.",
        "....", "..", ".---", "-.-", ".-..", "--", "-.",
        "---", ".--.", "--.-", ".-.", "...", "-", "..-",
        "...-", ".--", "-..-", "-.--", "--.."
};

class Solution {
public:
    int uniqueMorseRepresentations(vector<string> &words) {
        unordered_set<string> seen;
        for (auto &word: words) {
            string code;
            for (auto &c: word) {
                code.append(MORSE[c - 'a']);
            }
            seen.emplace(code);
        }
        return seen.size();
    }
};
```

```C# [sol1-C#]
public class Solution {
    public static string[] MORSE = {".-", "-...", "-.-.", "-..", ".", "..-.", "--.",
                                      "....", "..", ".---", "-.-", ".-..", "--", "-.",
                                      "---", ".--.", "--.-", ".-.", "...", "-", "..-",
                                      "...-", ".--", "-..-", "-.--", "--.."};

    public int UniqueMorseRepresentations(string[] words) {
        ISet<string> seen = new HashSet<string>();
        foreach (string word in words) {
            StringBuilder code = new StringBuilder();
            foreach (char c in word) {
                code.Append(MORSE[c - 'a']);
            }
            seen.Add(code.ToString());
        }
        return seen.Count;
    }
}
```

```C [sol1-C]
#define MAX_STR_LEN 64

typedef struct {
    char key[MAX_STR_LEN];
    UT_hash_handle hh;
} HashItem;

const static char * MORSE[26] = {".-", "-...", "-.-.", "-..", ".", "..-.", "--.", \
                                 "....", "..", ".---", "-.-", ".-..", "--", "-.", \
                                 "---", ".--.", "--.-", ".-.", "...", "-", "..-", \
                                 "...-", ".--", "-..-", "-.--", "--.."};

int uniqueMorseRepresentations(char ** words, int wordsSize){
    HashItem * seen = NULL;
    for (int i = 0; i < wordsSize; i++) {
        HashItem * pEntry = NULL;
        int len = strlen(words[i]);
        int pos = 0;
        char code[MAX_STR_LEN];
        for (int j = 0; j < len; j++) {
            pos += sprintf(code + pos, "%s", MORSE[words[i][j] - 'a']);
        }
        HASH_FIND_STR(seen, code, pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            strcpy(pEntry->key, code);
            HASH_ADD_STR(seen, key, pEntry);
        }
    }
    int ans = HASH_COUNT(seen);
    HashItem * curr = NULL, * tmp = NULL;
    HASH_ITER(hh, seen, curr, tmp) {
        HASH_DEL(seen, curr); 
        free(curr);            
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
const MORSE = [".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."];
var uniqueMorseRepresentations = function(words) {
    const seen = new Set();
    for (const word of words) {
        let code = '';
        for (const ch of word) {
            code += (MORSE[ch.charCodeAt() - 'a'.charCodeAt()]);
        }
        seen.add(code);
    }
    return seen.size;
}
```

```go [sol1-Golang]
var morse = []string{
    ".-", "-...", "-.-.", "-..", ".", "..-.", "--.",
    "....", "..", ".---", "-.-", ".-..", "--", "-.",
    "---", ".--.", "--.-", ".-.", "...", "-", "..-",
    "...-", ".--", "-..-", "-.--", "--..",
}

func uniqueMorseRepresentations(words []string) int {
    set := map[string]struct{}{}
    for _, word := range words {
        trans := &strings.Builder{}
        for _, ch := range word {
            trans.WriteString(morse[ch-'a'])
        }
        set[trans.String()] = struct{}{}
    }
    return len(set)
}
```

**复杂度分析**

+ 时间复杂度：$O(S)$，其中 $S$ 是数组 $\textit{words}$ 中所有单词的长度之和。

+ 空间复杂度：$O(S)$，其中 $S$ 是数组 $\textit{words}$ 中所有单词的长度之和。