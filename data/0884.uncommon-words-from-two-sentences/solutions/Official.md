## [884.两句话中的不常见单词 中文官方题解](https://leetcode.cn/problems/uncommon-words-from-two-sentences/solutions/100000/liang-ju-hua-zhong-de-bu-chang-jian-dan-a8bmz)

#### 方法一：哈希表

**思路与算法**

根据题目要求，我们需要找出「在句子 $s_1$ 中恰好出现一次，但在句子 $s_2$ 中没有出现的单词」或者「在句子 $s_2$ 中恰好出现一次，但在句子 $s_1$ 中没有出现的单词」。这其实等价于找出：

> 在两个句子中一共只出现一次的单词。

因此我们可以使用一个哈希映射统计两个句子中单词出现的次数。对于哈希映射中的每个键值对，键表示一个单词，值表示该单词出现的次数。在统计完成后，我们再对哈希映射进行一次遍历，把所有值为 $1$ 的键放入答案中即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> uncommonFromSentences(string s1, string s2) {
        unordered_map<string, int> freq;
        
        auto insert = [&](const string& s) {
            stringstream ss(s);
            string word;
            while (ss >> word) {
                ++freq[move(word)];
            }
        };

        insert(s1);
        insert(s2);

        vector<string> ans;
        for (const auto& [word, occ]: freq) {
            if (occ == 1) {
                ans.push_back(word);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String[] uncommonFromSentences(String s1, String s2) {
        Map<String, Integer> freq = new HashMap<String, Integer>();
        insert(s1, freq);
        insert(s2, freq);

        List<String> ans = new ArrayList<String>();
        for (Map.Entry<String, Integer> entry : freq.entrySet()) {
            if (entry.getValue() == 1) {
                ans.add(entry.getKey());
            }
        }
        return ans.toArray(new String[0]);
    }

    public void insert(String s, Map<String, Integer> freq) {
        String[] arr = s.split(" ");
        for (String word : arr) {
            freq.put(word, freq.getOrDefault(word, 0) + 1);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] UncommonFromSentences(string s1, string s2) {
        Dictionary<string, int> freq = new Dictionary<string, int>();
        Insert(s1, freq);
        Insert(s2, freq);

        IList<string> ans = new List<string>();
        foreach (KeyValuePair<string, int> pair in freq) {
            if (pair.Value == 1) {
                ans.Add(pair.Key);
            }
        }
        return ans.ToArray();
    }

    public void Insert(string s, Dictionary<string, int> freq) {
        string[] arr = s.Split(" ");
        foreach (string word in arr) {
            if (!freq.ContainsKey(word)) {
                freq.Add(word, 0);
            }
            ++freq[word];
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def uncommonFromSentences(self, s1: str, s2: str) -> List[str]:
        freq = Counter(s1.split()) + Counter(s2.split())
        
        ans = list()
        for word, occ in freq.items():
            if occ == 1:
                ans.append(word)
        
        return ans
```

```Golang [sol1-Golang]
func uncommonFromSentences(s1 string, s2 string) []string {
	freq := make(map[string]int)

	insert := func(s string) {
		words := strings.Split(s, " ")
		for _, word := range words {
			freq[word]++
		}
	}

	insert(s1)
	insert(s2)

	ans := []string{}
	for word, occ := range freq {
		if occ == 1 {
			ans = append(ans, word)
		}
	}
	return ans
}
```

```C [sol1-C]
typedef struct  {
    char * word;            
    int val;
    UT_hash_handle hh;
} HashEntry;

bool insert(char * str, HashEntry ** obj) {
    HashEntry * pEntry = NULL;
    char *token = NULL;

    token = strtok(str, " ");
    while (token != NULL ) {
        pEntry = NULL;
        HASH_FIND_STR(*obj, token, pEntry);
        if (NULL == pEntry) {
            HashEntry * pEntry = (HashEntry *)malloc(sizeof(HashEntry));
            pEntry->word = (char *)malloc(sizeof(char) * (strlen(token) + 1));
            strcpy(pEntry->word, token);
            pEntry->val = 1;
            HASH_ADD_STR(*obj, word, pEntry);
        } else {
            pEntry->val++;
        }
        token = strtok(NULL, " ");
    }
    return true;
}

char ** uncommonFromSentences(char * s1, char * s2, int* returnSize){
    HashEntry * freq = NULL;
    HashEntry * pEntry = NULL;

    insert(s1, &freq);
    insert(s2, &freq);
    unsigned int sentenceSize = HASH_COUNT(freq);
    char ** ans = (char **)malloc(sizeof(char *) * sentenceSize);
    int pos = 0;
    HashEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, freq, curr, next) {
        if (curr->val == 1) {
            ans[pos] = (char *)malloc(sizeof(char) * (strlen(curr->word) + 1));
            strcpy(ans[pos], curr->word);
            pos++;
        }
    }
    HASH_ITER(hh, freq, curr, next) {
        free(curr->word);
        HASH_DEL(freq, curr);
    }
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var uncommonFromSentences = function(s1, s2) {
    let freq = new Map();
    freq = insert(s1, freq);
    freq = insert(s2, freq);

    const ans = [];
    for (const entry of freq.entries()) {
        if (entry[1] === 1) {
            ans.push(entry[0]);
        }
    }
    return ans;
};

const insert = (s, freq) => {
    const arr = s.split(" ");
    for (const word of arr) {
        freq.set(word, (freq.get(word) || 0) + 1);
    }
    return freq;
}
```

**复杂度分析**

- 时间复杂度：$O(|s_1| + |s_2|)$。我们需要 $O(|s_1| + |s_2|)$ 的时间对这两个字符串进行遍历，并将所有的单词放入哈希映射。在这之后，我们还需要对哈希映射进行遍历。在最坏情况下，$s_1$ 和 $s_2$ 包含的单词都不重复，并且长度较短，即哈希映射中单词的个数为 $O(|s_1| + |s_2|)$。此时遍历哈希映射就需要 $O(|s_1| + |s_2|)$ 的时间。

- 空间复杂度：$O(|s_1| + |s_2|)$。即为哈希映射需要使用的空间。此外，在取出两个字符串中的单词时，为了方便也需要 $O(|s_1| + |s_2|)$ 的辅助空间。