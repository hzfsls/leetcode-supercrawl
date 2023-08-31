## [30.串联所有单词的子串 中文官方题解](https://leetcode.cn/problems/substring-with-concatenation-of-all-words/solutions/100000/chuan-lian-suo-you-dan-ci-de-zi-chuan-by-244a)
#### 方法一：滑动窗口

**思路**

此题是「[438. 找到字符串中所有字母异位词](https://leetcode.cn/problems/find-all-anagrams-in-a-string/)」的进阶版。不同的是第 438 题的元素是字母，而此题的元素是单词。可以用类似「[438. 找到字符串中所有字母异位词的官方题解](https://leetcode.cn/problems/find-all-anagrams-in-a-string/solution/zhao-dao-zi-fu-chuan-zhong-suo-you-zi-mu-xzin/)」的方法二的滑动窗口来解这题。

记 $\textit{words}$ 的长度为 $m$，$\textit{words}$ 中每个单词的长度为 $n$，$s$ 的长度为 $\textit{ls}$。首先需要将 $s$ 划分为单词组，每个单词的大小均为 $n$ （首尾除外）。这样的划分方法有 $n$ 种，即先删去前 $i$ （$i = 0 \sim n-1$）个字母后，将剩下的字母进行划分，如果末尾有不到 $n$ 个字母也删去。对这 $n$ 种划分得到的单词数组分别使用滑动窗口对 $\textit{words}$ 进行类似于「字母异位词」的搜寻。

划分成单词组后，一个窗口包含 $s$ 中前 $m$ 个单词，用一个哈希表 $\textit{differ}$ 表示窗口中单词频次和 $\textit{words}$ 中单词频次之差。初始化 $\textit{differ}$ 时，出现在窗口中的单词，每出现一次，相应的值增加 $1$，出现在 $\textit{words}$ 中的单词，每出现一次，相应的值减少 $1$。然后将窗口右移，右侧会加入一个单词，左侧会移出一个单词，并对 $\textit{differ}$ 做相应的更新。窗口移动时，若出现 $\textit{differ}$ 中值不为 $0$ 的键的数量为 $0$，则表示这个窗口中的单词频次和 $\textit{words}$ 中单词频次相同，窗口的左端点是一个待求的起始位置。划分的方法有 $n$ 种，做 $n$ 次滑动窗口后，即可找到所有的起始位置。

**代码**

```Python [sol1-Python3]
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        res = []
        m, n, ls = len(words), len(words[0]), len(s)
        for i in range(n):
            if i + m * n > ls:
                break
            differ = Counter()
            for j in range(m):
                word = s[i + j * n: i + (j + 1) * n]
                differ[word] += 1
            for word in words:
                differ[word] -= 1
                if differ[word] == 0:
                    del differ[word]
            for start in range(i, ls - m * n + 1, n):
                if start != i:
                    word = s[start + (m - 1) * n: start + m * n]
                    differ[word] += 1
                    if differ[word] == 0:
                        del differ[word]
                    word = s[start - n: start]
                    differ[word] -= 1
                    if differ[word] == 0:
                        del differ[word]
                if len(differ) == 0:
                    res.append(start)
        return res
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findSubstring(String s, String[] words) {
        List<Integer> res = new ArrayList<Integer>();
        int m = words.length, n = words[0].length(), ls = s.length();
        for (int i = 0; i < n; i++) {
            if (i + m * n > ls) {
                break;
            }
            Map<String, Integer> differ = new HashMap<String, Integer>();
            for (int j = 0; j < m; j++) {
                String word = s.substring(i + j * n, i + (j + 1) * n);
                differ.put(word, differ.getOrDefault(word, 0) + 1);
            }
            for (String word : words) {
                differ.put(word, differ.getOrDefault(word, 0) - 1);
                if (differ.get(word) == 0) {
                    differ.remove(word);
                }
            }
            for (int start = i; start < ls - m * n + 1; start += n) {
                if (start != i) {
                    String word = s.substring(start + (m - 1) * n, start + m * n);
                    differ.put(word, differ.getOrDefault(word, 0) + 1);
                    if (differ.get(word) == 0) {
                        differ.remove(word);
                    }
                    word = s.substring(start - n, start);
                    differ.put(word, differ.getOrDefault(word, 0) - 1);
                    if (differ.get(word) == 0) {
                        differ.remove(word);
                    }
                }
                if (differ.isEmpty()) {
                    res.add(start);
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> FindSubstring(string s, string[] words) {
        IList<int> res = new List<int>();
        int m = words.Length, n = words[0].Length, ls = s.Length;
        for (int i = 0; i < n; i++) {
            if (i + m * n > ls) {
                break;
            }
            Dictionary<string, int> differ = new Dictionary<string, int>();
            for (int j = 0; j < m; j++) {
                string word = s.Substring(i + j * n, n);
                if (!differ.ContainsKey(word)) {
                    differ.Add(word, 0);
                }
                differ[word]++;
            }
            foreach (string word in words) {
                if (!differ.ContainsKey(word)) {
                    differ.Add(word, 0);
                }
                differ[word]--;
                if (differ[word] == 0) {
                    differ.Remove(word);
                }
            }
            for (int start = i; start < ls - m * n + 1; start += n) {
                if (start != i) {
                    string word = s.Substring(start + (m - 1) * n, n);
                    if (!differ.ContainsKey(word)) {
                        differ.Add(word, 0);
                    }
                    differ[word]++;
                    if (differ[word] == 0) {
                        differ.Remove(word);
                    }
                    word = s.Substring(start - n, n);
                    if (!differ.ContainsKey(word)) {
                        differ.Add(word, 0);
                    }
                    differ[word]--;
                    if (differ[word] == 0) {
                        differ.Remove(word);
                    }
                }
                if (differ.Count == 0) {
                    res.Add(start);
                }
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findSubstring(string &s, vector<string> &words) {
        vector<int> res;
        int m = words.size(), n = words[0].size(), ls = s.size();
        for (int i = 0; i < n && i + m * n <= ls; ++i) {
            unordered_map<string, int> differ;
            for (int j = 0; j < m; ++j) {
                ++differ[s.substr(i + j * n, n)];
            }
            for (string &word: words) {
                if (--differ[word] == 0) {
                    differ.erase(word);
                }
            }
            for (int start = i; start < ls - m * n + 1; start += n) {
                if (start != i) {
                    string word = s.substr(start + (m - 1) * n, n);
                    if (++differ[word] == 0) {
                        differ.erase(word);
                    }
                    word = s.substr(start - n, n);
                    if (--differ[word] == 0) {
                        differ.erase(word);
                    }
                }
                if (differ.empty()) {
                    res.emplace_back(start);
                }
            }
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    char key[32];
    int val;
    UT_hash_handle hh;
} HashItem;

int* findSubstring(char * s, char ** words, int wordsSize, int* returnSize){    
    int m = wordsSize, n = strlen(words[0]), ls = strlen(s);
    int *res = (int *)malloc(sizeof(int) * ls);
    int pos = 0;
    for (int i = 0; i < n; i++) {
        if (i + m * n > ls) {
            break;
        }
        HashItem *diff = NULL;
        char word[32] = {0};
        for (int j = 0; j < m; j++) {
            snprintf(word, n + 1, "%s", s + i + j * n);
            HashItem * pEntry = NULL;
            HASH_FIND_STR(diff, word, pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                strcpy(pEntry->key, word);
                pEntry->val = 0;
                HASH_ADD_STR(diff, key, pEntry);
            } 
            pEntry->val++;            
        }
        for (int j = 0; j < m; j++) {
            HashItem * pEntry = NULL;
            HASH_FIND_STR(diff, words[j], pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                strcpy(pEntry->key, words[j]);
                pEntry->val = 0;
                HASH_ADD_STR(diff, key, pEntry);
            } 
            pEntry->val--;
            if (pEntry->val == 0) {
                HASH_DEL(diff, pEntry);
                free(pEntry);
            }
        }
        for (int start = i; start < ls - m * n + 1; start += n) {
            if (start != i) {
                char word[32];
                snprintf(word, n + 1, "%s", s + start + (m - 1) * n);
                HashItem * pEntry = NULL;
                HASH_FIND_STR(diff, word, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    strcpy(pEntry->key, word);
                    pEntry->val = 0;
                    HASH_ADD_STR(diff, key, pEntry);
                } 
                pEntry->val++;
                if (pEntry->val == 0) {
                    HASH_DEL(diff, pEntry);
                    free(pEntry);
                }
                snprintf(word, n + 1, "%s", s + start - n);
                pEntry = NULL;
                HASH_FIND_STR(diff, word, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    strcpy(pEntry->key, word);
                    pEntry->val = 0;
                    HASH_ADD_STR(diff, key, pEntry);
                } 
                pEntry->val--;
                if (pEntry->val == 0) {
                    HASH_DEL(diff, pEntry);
                    free(pEntry);
                }
            }
            if (HASH_COUNT(diff) == 0) {
                res[pos++] = start;
            }
        }
        HashItem *curr, *tmp;
        HASH_ITER(hh, diff, curr, tmp) {
            HASH_DEL(diff, curr);  
            free(curr);      
        }
    }
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var findSubstring = function(s, words) {
    const res = [];
    const m = words.length, n = words[0].length, ls = s.length;
    for (let i = 0; i < n; i++) {
        if (i + m * n > ls) {
            break;
        }
        const differ = new Map();
        for (let j = 0; j < m; j++) {
            const word = s.substring(i + j * n, i + (j + 1) * n);
            differ.set(word, (differ.get(word) || 0) + 1);
        }
        for (const word of words) {
            differ.set(word, (differ.get(word) || 0) - 1);
            if (differ.get(word) === 0) {
                differ.delete(word);
            }
        }
        for (let start = i; start < ls - m * n + 1; start += n) {
            if (start !== i) {
                let word = s.substring(start + (m - 1) * n, start + m * n);
                differ.set(word, (differ.get(word) || 0) + 1);
                if (differ.get(word) === 0) {
                    differ.delete(word);
                }
                word = s.substring(start - n, start);
                differ.set(word, (differ.get(word) || 0) - 1);
                if (differ.get(word) === 0) {
                    differ.delete(word);
                }
            }
            if (differ.size === 0) {
                res.push(start);
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func findSubstring(s string, words []string) (ans []int) {
    ls, m, n := len(s), len(words), len(words[0])
    for i := 0; i < n && i+m*n <= ls; i++ {
        differ := map[string]int{}
        for j := 0; j < m; j++ {
            differ[s[i+j*n:i+(j+1)*n]]++
        }
        for _, word := range words {
            differ[word]--
            if differ[word] == 0 {
                delete(differ, word)
            }
        }
        for start := i; start < ls-m*n+1; start += n {
            if start != i {
                word := s[start+(m-1)*n : start+m*n]
                differ[word]++
                if differ[word] == 0 {
                    delete(differ, word)
                }
                word = s[start-n : start]
                differ[word]--
                if differ[word] == 0 {
                    delete(differ, word)
                }
            }
            if len(differ) == 0 {
                ans = append(ans, start)
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{ls} \times n)$，其中 $\textit{ls}$ 是输入 $s$ 的长度，$n$ 是 $\textit{words}$ 中每个单词的长度。需要做 $n$ 次滑动窗口，每次需要遍历一次 $s$。

- 空间复杂度：$O(m \times n)$，其中 $m$ 是 $\textit{words}$ 的单词数，$n$ 是 $\textit{words}$ 中每个单词的长度。每次滑动窗口时，需要用一个哈希表保存单词频次。