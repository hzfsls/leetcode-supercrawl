## [819.最常见的单词 中文官方题解](https://leetcode.cn/problems/most-common-word/solutions/100000/zui-chang-jian-de-dan-ci-by-leetcode-sol-mzjb)

#### 方法一：哈希表 + 计数

为了判断给定段落中的每个单词是否在禁用单词列表中，需要使用哈希集合存储禁用单词列表中的单词。以下将禁用单词列表中的单词称为禁用单词。

遍历段落 $\textit{paragraph}$，得到段落中的所有单词，并对每个单词计数，使用哈希表记录每个单词的计数。由于每个单词由连续的字母组成，因此当遇到一个非字母的字符且该字符的前一个字符是字母时，即为一个单词的结束，如果该单词不是禁用单词，则将该单词的计数加 $1$。如果段落的最后一个字符是字母，则当遍历结束时需要对段落中的最后一个单词判断是否为禁用单词，如果不是禁用单词则将次数加 $1$。

在遍历段落的过程中，对于每个单词都会更新计数，因此遍历结束之后即可得到最大计数，即出现次数最多的单词的出现次数。

遍历段落之后，遍历哈希表，寻找出现次数等于最大计数的单词，该单词即为最常见的单词。

```Python [sol1-Python3]
class Solution:
    def mostCommonWord(self, paragraph: str, banned: List[str]) -> str:
        ban = set(banned)
        freq = Counter()
        word, n = "", len(paragraph)
        for i in range(n + 1):
            if i < n and paragraph[i].isalpha():
                word += paragraph[i].lower()
            elif word:
                if word not in ban:
                    freq[word] += 1
                word = ""
        maxFreq = max(freq.values())
        return next(word for word, f in freq.items() if f == maxFreq)
```

```Java [sol1-Java]
class Solution {
    public String mostCommonWord(String paragraph, String[] banned) {
        Set<String> bannedSet = new HashSet<String>();
        for (String word : banned) {
            bannedSet.add(word);
        }
        int maxFrequency = 0;
        Map<String, Integer> frequencies = new HashMap<String, Integer>();
        StringBuffer sb = new StringBuffer();
        int length = paragraph.length();
        for (int i = 0; i <= length; i++) {
            if (i < length && Character.isLetter(paragraph.charAt(i))) {
                sb.append(Character.toLowerCase(paragraph.charAt(i)));
            } else if (sb.length() > 0) {
                String word = sb.toString();
                if (!bannedSet.contains(word)) {
                    int frequency = frequencies.getOrDefault(word, 0) + 1;
                    frequencies.put(word, frequency);
                    maxFrequency = Math.max(maxFrequency, frequency);
                }
                sb.setLength(0);
            }
        }
        String mostCommon = "";
        Set<Map.Entry<String, Integer>> entries = frequencies.entrySet();
        for (Map.Entry<String, Integer> entry : entries) {
            String word = entry.getKey();
            int frequency = entry.getValue();
            if (frequency == maxFrequency) {
                mostCommon = word;
                break;
            }
        }
        return mostCommon;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string MostCommonWord(string paragraph, string[] banned) {
        ISet<string> bannedSet = new HashSet<string>();
        foreach (string word in banned) {
            bannedSet.Add(word);
        }
        int maxFrequency = 0;
        Dictionary<string, int> frequencies = new Dictionary<string, int>();
        StringBuilder sb = new StringBuilder();
        int length = paragraph.Length;
        for (int i = 0; i <= length; i++) {
            if (i < length && char.IsLetter(paragraph[i])) {
                sb.Append(char.ToLower(paragraph[i]));
            } else if (sb.Length > 0) {
                string word = sb.ToString();
                if (!bannedSet.Contains(word)) {
                    if (!frequencies.ContainsKey(word)) {
                        frequencies.Add(word, 1);
                    } else {
                        frequencies[word]++;
                    }
                    maxFrequency = Math.Max(maxFrequency, frequencies[word]);
                }
                sb.Length = 0;
            }
        }
        string mostCommon = "";
        foreach (KeyValuePair<string, int> pair in frequencies) {
            string word = pair.Key;
            int frequency = pair.Value;
            if (frequency == maxFrequency) {
                mostCommon = word;
                break;
            }
        }
        return mostCommon;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string mostCommonWord(string paragraph, vector<string>& banned) {
        unordered_set<string> bannedSet;
        for (auto & word : banned) {
            bannedSet.emplace(word);
        }
        int maxFrequency = 0;
        unordered_map<string, int> frequencies;
        string word;
        int length = paragraph.size();
        for (int i = 0; i <= length; i++) {
            if (i < length && isalpha(paragraph[i])) {
                word.push_back(tolower(paragraph[i]));
            } else if (word.size() > 0) {
                if (!bannedSet.count(word)) {
                    frequencies[word]++;
                    maxFrequency = max(maxFrequency, frequencies[word]);
                }
                word = "";
            }
        }
        string mostCommon = "";
        for (auto &[word , frequency] : frequencies) {
            if (frequency == maxFrequency) {
                mostCommon = word;
                break;
            }
        }
        return mostCommon;
    }
};
```

```C [sol1-C]
typedef struct {
    char * key;
    UT_hash_handle hh;
} HashSetItem;

typedef struct {
    char * key;
    int val;
    UT_hash_handle hh;
} HashMapItem;

#define MAX_STR_LEN 1024
#define MAX(a, b) ((a) > (b) ? (a) : (b))

char * mostCommonWord(char * paragraph, char ** banned, int bannedSize){
    HashSetItem * bannedSet = NULL;
    for (int i = 0; i < bannedSize; i++) {
        HashSetItem * pSetEntry = NULL;
        HASH_FIND_STR(bannedSet, banned[i], pSetEntry);
        if (NULL == pSetEntry) {
            pSetEntry = (HashSetItem *)malloc(sizeof(HashSetItem));
            pSetEntry->key = banned[i];
            HASH_ADD_STR(bannedSet, key, pSetEntry);
        }
    }
    int maxFrequency = 0;
    char * mostCommon = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    HashMapItem * frequencies = NULL;
    char word[MAX_STR_LEN];
    int pos = 0;
    int length = strlen(paragraph);
    for (int i = 0; i <= length; i++) {
        if (i < length && isalpha(paragraph[i])) {
            word[pos++] = tolower(paragraph[i]);
        } else if (pos > 0) {
            HashSetItem * pSetEntry = NULL;
            word[pos] = 0;
            HASH_FIND_STR(bannedSet, word, pSetEntry);
            if (NULL == pSetEntry) {
                HashMapItem * pMapEntry = NULL;
                HASH_FIND_STR(frequencies, word, pMapEntry);
                if (NULL == pMapEntry) {
                    pMapEntry = (HashMapItem *)malloc(sizeof(HashMapItem));
                    pMapEntry->key = (char *)malloc(sizeof(char) * pos);
                    strcpy(pMapEntry->key, word);
                    pMapEntry->val = 1;
                    HASH_ADD_STR(frequencies, key, pMapEntry);
                } else {
                    pMapEntry->val++;
                }
                if (maxFrequency < pMapEntry->val) {
                    maxFrequency = pMapEntry->val;
                    strcpy(mostCommon, word);
                }
            }
            pos = 0;
        }
    }
    return mostCommon;
}
```

```go [sol1-Golang]
func mostCommonWord(paragraph string, banned []string) string {
    ban := map[string]bool{}
    for _, s := range banned {
        ban[s] = true
    }
    freq := map[string]int{}
    maxFreq := 0
    var word []byte
    for i, n := 0, len(paragraph); i <= n; i++ {
        if i < n && unicode.IsLetter(rune(paragraph[i])) {
            word = append(word, byte(unicode.ToLower(rune(paragraph[i]))))
        } else if word != nil {
            s := string(word)
            if !ban[s] {
                freq[s]++
                maxFreq = max(maxFreq, freq[s])
            }
            word = nil
        }
    }
    for s, f := range freq {
        if f == maxFreq {
            return s
        }
    }
    return ""
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var mostCommonWord = function(paragraph, banned) {
    const bannedSet = new Set();
    for (const word of banned) {
        bannedSet.add(word);
    }
    let maxFrequency = 0;
    const frequencies = new Map();
    let sb = '';
    const length = paragraph.length;
    for (let i = 0; i <= length; i++) {
        if (i < length && isLetter(paragraph[i])) {
            sb = sb + paragraph[i].toLowerCase();
        } else if (sb.length > 0) {
            if (!bannedSet.has(sb)) {
                const frequency = (frequencies.get(sb) || 0) + 1;
                frequencies.set(sb, frequency);
                maxFrequency = Math.max(maxFrequency, frequency);
            }
            sb = '';
        }
    }
    let mostCommon = "";
    for (const [word, frequency] of frequencies.entries()) {
        if (frequency === maxFrequency) {
            mostCommon = word;
            break;
        }
    }
    return mostCommon;
};

const isLetter = (ch) => {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 是段落 $\textit{paragraph}$ 的长度，$m$ 是禁用单词列表 $\textit{banned}$ 的长度。遍历禁用单词列表一次将禁用单词存入哈希集合中需要 $O(m)$ 的时间，遍历段落得到每个非禁用单词的计数需要 $O(n)$ 的时间，遍历哈希表得到最常见的单词需要 $O(n)$ 的时间。

- 空间复杂度：$O(n + m)$，其中 $n$ 是段落 $\textit{paragraph}$ 的长度，$m$ 是禁用单词列表 $\textit{banned}$ 的长度。存储禁用单词的哈希集合需要 $O(m)$ 的空间，记录每个单词的计数的哈希表需要 $O(n)$ 的空间。