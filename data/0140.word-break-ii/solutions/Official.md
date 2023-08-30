#### 前言

这道题是「[139. 单词拆分](https://leetcode-cn.com/problems/word-break/)」的进阶，第 139 题要求判断是否可以拆分，这道题要求返回所有可能的拆分结果。

第 139 题可以使用动态规划的方法判断是否可以拆分，因此这道题也可以使用动态规划的思想。但是这道题如果使用自底向上的动态规划的方法进行拆分，则无法事先判断拆分的可行性，在不能拆分的情况下会超时。

例如以下例子，由于字符串 $s$ 中包含字母 $\texttt{b}$，而单词列表 $\textit{wordDict}$ 中的所有单词都由字母 $\texttt{a}$ 组成，不包含字母 $\texttt{b}$，因此不能拆分，但是自底向上的动态规划仍然会在每个下标都进行大量的匹配，导致超时。

```
s = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
wordDict = ["a","aa","aaa","aaaa","aaaaa","aaaaaa","aaaaaaa","aaaaaaaa","aaaaaaaaa","aaaaaaaaaa"]
```

为了避免动态规划的方法超时，需要首先使用第 139 题的代码进行判断，在可以拆分的情况下再使用动态规划的方法进行拆分。相比之下，自顶向下的记忆化搜索可以在搜索过程中将不可以拆分的情况进行剪枝，因此记忆化搜索是更优的做法。

#### 方法一：记忆化搜索

对于字符串 $s$，如果某个前缀是单词列表中的单词，则拆分出该单词，然后对 $s$ 的剩余部分继续拆分。如果可以将整个字符串 $s$ 拆分成单词列表中的单词，则得到一个句子。在对 $s$ 的剩余部分拆分得到一个句子之后，将拆分出的第一个单词（即 $s$ 的前缀）添加到句子的头部，即可得到一个完整的句子。上述过程可以通过回溯实现。

假设字符串 $s$ 的长度为 $n$，回溯的时间复杂度在最坏情况下高达 $O(n^n)$。时间复杂度高的原因是存在大量重复计算，可以通过记忆化的方式降低时间复杂度。

具体做法是，使用哈希表存储字符串 $s$ 的每个下标和从该下标开始的部分可以组成的句子列表，在回溯过程中如果遇到已经访问过的下标，则可以直接从哈希表得到结果，而不需要重复计算。如果到某个下标发现无法匹配，则哈希表中该下标对应的是空列表，因此可以对不能拆分的情况进行剪枝优化。

还有一个可优化之处为使用哈希集合存储单词列表中的单词，这样在判断一个字符串是否是单词列表中的单词时只需要判断该字符串是否在哈希集合中即可，而不再需要遍历单词列表。

```Java [sol1-Java]
class Solution {
    public List<String> wordBreak(String s, List<String> wordDict) {
        Map<Integer, List<List<String>>> map = new HashMap<Integer, List<List<String>>>();
        List<List<String>> wordBreaks = backtrack(s, s.length(), new HashSet<String>(wordDict), 0, map);
        List<String> breakList = new LinkedList<String>();
        for (List<String> wordBreak : wordBreaks) {
            breakList.add(String.join(" ", wordBreak));
        }
        return breakList;
    }

    public List<List<String>> backtrack(String s, int length, Set<String> wordSet, int index, Map<Integer, List<List<String>>> map) {
        if (!map.containsKey(index)) {
            List<List<String>> wordBreaks = new LinkedList<List<String>>();
            if (index == length) {
                wordBreaks.add(new LinkedList<String>());
            }
            for (int i = index + 1; i <= length; i++) {
                String word = s.substring(index, i);
                if (wordSet.contains(word)) {
                    List<List<String>> nextWordBreaks = backtrack(s, length, wordSet, i, map);
                    for (List<String> nextWordBreak : nextWordBreaks) {
                        LinkedList<String> wordBreak = new LinkedList<String>(nextWordBreak);
                        wordBreak.offerFirst(word);
                        wordBreaks.add(wordBreak);
                    }
                }
            }
            map.put(index, wordBreaks);
        }
        return map.get(index);
    }
}
```

```JavaScript [sol1-JavaScript]
const backtrack = (s, length, wordSet, index, map) => {
    if (map.has(index)) {
        return map.get(index);
    }
    const wordBreaks = [];
    if (index === length) {
        wordBreaks.push([]);
    }
    for (let i = index + 1; i <= length; i++) {
        const word = s.substring(index, i);
        if (wordSet.has(word)) {
            const nextWordBreaks = backtrack(s, length, wordSet, i, map);
            for (const nextWordBreak of nextWordBreaks) {
                const wordBreak = [word, ...nextWordBreak]
                wordBreaks.push(wordBreak);
            }
        }
    }
    map.set(index, wordBreaks);
    return wordBreaks;
}
var wordBreak = function(s, wordDict) {
    const map = new Map();
    const wordBreaks = backtrack(s, s.length, new Set(wordDict), 0, map);
    const breakList = [];
    for (const wordBreak of wordBreaks) {
        breakList.push(wordBreak.join(' '));
    }
    return breakList;
};
```

```Golang [sol1-Golang]
func wordBreak(s string, wordDict []string) (sentences []string) {
    wordSet := map[string]struct{}{}
    for _, w := range wordDict {
        wordSet[w] = struct{}{}
    }

    n := len(s)
    dp := make([][][]string, n)
    var backtrack func(index int) [][]string
    backtrack = func(index int) [][]string {
        if dp[index] != nil {
            return dp[index]
        }
        wordsList := [][]string{}
        for i := index + 1; i < n; i++ {
            word := s[index:i]
            if _, has := wordSet[word]; has {
                for _, nextWords := range backtrack(i) {
                    wordsList = append(wordsList, append([]string{word}, nextWords...))
                }
            }
        }
        word := s[index:]
        if _, has := wordSet[word]; has {
            wordsList = append(wordsList, []string{word})
        }
        dp[index] = wordsList
        return wordsList
    }
    for _, words := range backtrack(0) {
        sentences = append(sentences, strings.Join(words, " "))
    }
    return
}
```

```C++ [sol1-C++]
class Solution {
private:
    unordered_map<int, vector<string>> ans;
    unordered_set<string> wordSet;

public:
    vector<string> wordBreak(string s, vector<string>& wordDict) {
        wordSet = unordered_set(wordDict.begin(), wordDict.end());
        backtrack(s, 0);
        return ans[0];
    }

    void backtrack(const string& s, int index) {
        if (!ans.count(index)) {
            if (index == s.size()) {
                ans[index] = {""};
                return;
            }
            ans[index] = {};
            for (int i = index + 1; i <= s.size(); ++i) {
                string word = s.substr(index, i - index);
                if (wordSet.count(word)) {
                    backtrack(s, i);
                    for (const string& succ: ans[i]) {
                        ans[index].push_back(succ.empty() ? word : word + " " + succ);
                    }
                }
            }
        }
    }
};
```

```Python [sol1-Python3]
class Solution:
    def wordBreak(self, s: str, wordDict: List[str]) -> List[str]:
        @lru_cache(None)
        def backtrack(index: int) -> List[List[str]]:
            if index == len(s):
                return [[]]
            ans = list()
            for i in range(index + 1, len(s) + 1):
                word = s[index:i]
                if word in wordSet:
                    nextWordBreaks = backtrack(i)
                    for nextWordBreak in nextWordBreaks:
                        ans.append(nextWordBreak.copy() + [word])
            return ans
        
        wordSet = set(wordDict)
        breakList = backtrack(0)
        return [" ".join(words[::-1]) for words in breakList]
```

```C [sol1-C]
struct Trie {
    int ch[26];
    bool flag;
} trie[10001];

int size;

void insert(char* s, int sSize) {
    int add = 0;
    for (int i = 0; i < sSize; i++) {
        int x = s[i] - 'a';
        if (trie[add].ch[x] == 0) {
            trie[add].ch[x] = ++size;
            memset(trie[size].ch, 0, sizeof(trie[size].ch));
            trie[size].flag = false;
        }
        add = trie[add].ch[x];
    }
    trie[add].flag = true;
}

bool find(char* s, int sSize) {
    int add = 0;
    for (int i = 0; i < sSize; i++) {
        int x = s[i] - 'a';
        if (trie[add].ch[x] == 0) {
            return false;
        }
        add = trie[add].ch[x];
    }
    return trie[add].flag;
}

char** ans[1001];
int ansSize[1001];

void backtrack(char* s, int sSize, int index) {
    if (ans[index] == NULL) {
        ans[index] = malloc(sizeof(char**));
        if (index == sSize) {
            ansSize[index] = 1;
            char* tmp = malloc(sizeof(char));
            tmp[0] = '\0';
            ans[index][0] = tmp;
            return;
        }
        ansSize[index] = 0;
        for (int i = index + 1; i <= sSize; ++i) {
            int len = i - index;
            char* word = malloc(sizeof(char) * (len + 1));
            for (int j = 0; j < len; ++j) word[j] = s[index + j];
            word[len] = '\0';
            if (find(word, len)) {
                backtrack(s, sSize, i);
                ans[index] = realloc(ans[index], sizeof(char**) * (ansSize[index] + ansSize[i]));
                for (int j = 0; j < ansSize[i]; ++j) {
                    int len1 = len, len2 = strlen(ans[i][j]);
                    char* tmp = malloc(sizeof(char) * (len1 + len2 + 2));
                    strcpy(tmp, word);
                    if (len2 > 0) {
                        tmp[len1] = ' ';
                    }
                    strcpy(tmp + len1 + 1, ans[i][j]);
                    ans[index][ansSize[index]++] = tmp;
                }
            }
        }
    }
}

char** wordBreak(char* s, char** wordDict, int wordDictSize, int* returnSize) {
    memset(ans, 0, sizeof(ans));
    size = 0;
    memset(trie[0].ch, 0, sizeof(trie[0].ch));
    trie[0].flag = false;
    for (int i = 0; i < wordDictSize; i++) {
        insert(wordDict[i], strlen(wordDict[i]));
    }
    backtrack(s, strlen(s), 0);
    *returnSize = ansSize[0];
    return ans[0];
}
```

**复杂度分析**

本题的时间与空间复杂度均为指数级别，较难进行具体的分析。在最坏的情况下，考虑下面这样一组测试数据：

```
s = "aaa...aaa"
wordDict = ["a","aa","aaa", ..., "aaa...aaa"]
```

显然，$s$ 的任意一种分隔方法均符合题目要求。即使我们忽略存储最终答案需要的空间，但在记忆化搜索的过程中缓存下来，防止重复计算而使用的空间**不可以忽略**。这一部分的占用的空间至少为 $O(n \cdot 2^n)$，其中 $n$ 是 $s$ 的长度，即 $s$ 的分隔方法有 $2^n$ 种，每一种方法需要一个长度为 $O(n)$ 的字符串进行存储。

对于时间复杂度部分，由于写入 $O(n \cdot 2^n)$ 空间至少也需要 $O(n \cdot 2^n)$ 的时间，因此时间复杂度同样为指数级别。

虽然记忆化搜索和普通的回溯方法的时间复杂度均为指数级别，但前者的底数为 $2$，后者的底数为 $n$，因此记忆化搜索仍然具有一定的优越性。