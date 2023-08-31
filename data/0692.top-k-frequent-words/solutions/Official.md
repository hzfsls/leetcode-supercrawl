## [692.前K个高频单词 中文官方题解](https://leetcode.cn/problems/top-k-frequent-words/solutions/100000/qian-kge-gao-pin-dan-ci-by-leetcode-solu-3qk0)

#### 方法一：哈希表 + 排序

**思路及算法**

我们可以预处理出每一个单词出现的频率，然后依据每个单词出现的频率降序排序，最后返回前 $k$ 个字符串即可。

具体地，我们利用哈希表记录每一个字符串出现的频率，然后将哈希表中所有字符串进行排序，排序时，如果两个字符串出现频率相同，那么我们让两字符串中字典序较小的排在前面，否则我们让出现频率较高的排在前面。最后我们只需要保留序列中的前 $k$ 个字符串即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> topKFrequent(vector<string>& words, int k) {
        unordered_map<string, int> cnt;
        for (auto& word : words) {
            ++cnt[word];
        }
        vector<string> rec;
        for (auto& [key, value] : cnt) {
            rec.emplace_back(key);
        }
        sort(rec.begin(), rec.end(), [&](const string& a, const string& b) -> bool {
            return cnt[a] == cnt[b] ? a < b : cnt[a] > cnt[b];
        });
        rec.erase(rec.begin() + k, rec.end());
        return rec;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> topKFrequent(String[] words, int k) {
        Map<String, Integer> cnt = new HashMap<String, Integer>();
        for (String word : words) {
            cnt.put(word, cnt.getOrDefault(word, 0) + 1);
        }
        List<String> rec = new ArrayList<String>();
        for (Map.Entry<String, Integer> entry : cnt.entrySet()) {
            rec.add(entry.getKey());
        }
        Collections.sort(rec, new Comparator<String>() {
            public int compare(String word1, String word2) {
                return cnt.get(word1) == cnt.get(word2) ? word1.compareTo(word2) : cnt.get(word2) - cnt.get(word1);
            }
        });
        return rec.subList(0, k);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> TopKFrequent(string[] words, int k) {
        Dictionary<string, int> cnt = new Dictionary<string, int>();
        foreach (string word in words) {
            if (cnt.ContainsKey(word)) {
                cnt[word]++;
            } else {
                cnt.Add(word, 1);
            }
        }
        List<string> rec = new List<string>();
        foreach (var item in cnt) {
            rec.Add(item.Key);
        }
        rec.Sort(
            delegate(string word1, string word2) {
                return cnt[word1] == cnt[word2] ? word1.CompareTo(word2) : cnt[word2] - cnt[word1];
            }
        );
        return rec.GetRange(0, k);
    }
}
```

```go [sol1-Golang]
func topKFrequent(words []string, k int) []string {
    cnt := map[string]int{}
    for _, w := range words {
        cnt[w]++
    }
    uniqueWords := make([]string, 0, len(cnt))
    for w := range cnt {
        uniqueWords = append(uniqueWords, w)
    }
    sort.Slice(uniqueWords, func(i, j int) bool {
        s, t := uniqueWords[i], uniqueWords[j]
        return cnt[s] > cnt[t] || cnt[s] == cnt[t] && s < t
    })
    return uniqueWords[:k]
}
```

```JavaScript [sol1-JavaScript]
var topKFrequent = function(words, k) {
    const cnt = new Map();
    for (const word of words) {
        cnt.set(word, (cnt.get(word) || 0) + 1);
    }
    const rec = [];
    for (const entry of cnt.keys()) {
        rec.push(entry);
    }
    rec.sort((word1, word2) => {
        return cnt.get(word1) === cnt.get(word2) ? word1.localeCompare(word2) : cnt.get(word2) - cnt.get(word1);
    })
    return rec.slice(0, k);
};
```

```C [sol1-C]
struct HashTable {
    char* key;
    int val;
    UT_hash_handle hh;
};

struct HashTable* cnt;

int queryVal(struct HashTable* hashTable, char* ikey) {
    struct HashTable* tmp;
    HASH_FIND_STR(hashTable, ikey, tmp);
    return tmp == NULL ? 0 : tmp->val;
}

int cmp(char** a, char** b) {
    int valA = queryVal(cnt, *a), valB = queryVal(cnt, *b);
    if (valA != valB) {
        return valB - valA;
    }
    int lenA = strlen(*a), lenB = strlen(*b);
    int len = fmin(lenA, lenB);
    for (int i = 0; i < len; i++) {
        if ((*a)[i] != (*b)[i]) {
            return (*a)[i] - (*b)[i];
        }
    }
    return lenA - lenB;
}

char** topKFrequent(char** words, int wordsSize, int k, int* returnSize) {
    cnt = NULL;
    for (int i = 0; i < wordsSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_STR(cnt, words[i], tmp);
        if (tmp == NULL) {
            struct HashTable* tmp = malloc(sizeof(struct HashTable));
            tmp->key = words[i];
            tmp->val = 1;
            HASH_ADD_KEYPTR(hh, cnt, tmp->key, strlen(tmp->key), tmp);
        } else {
            tmp->val++;
        }
    }
    char** ret = malloc(sizeof(char*) * HASH_COUNT(cnt));
    *returnSize = 0;

    struct HashTable *iter, *tmp;
    HASH_ITER(hh, cnt, iter, tmp) {
        ret[(*returnSize)++] = iter->key;
    }

    qsort(ret, *returnSize, sizeof(char*), cmp);
    *returnSize = k;
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(l \times n + l \times m \log m)$，其中 $n$ 表示给定字符串序列的长度，$l$ 表示字符串的平均长度，$m$ 表示实际字符串种类数。我们需要 $l \times n$ 的时间将字符串插入到哈希表中，以及 $l \times m \log m$ 的时间完成字符串比较（最坏情况下所有字符串出现频率都相同，我们需要将它们两两比较）。

- 空间复杂度：$O(l \times m)$，其中 $l$ 表示字符串的平均长度，$m$ 表示实际字符串种类数。哈希表和生成的排序数组空间占用均为 $O(l \times m)$。

#### 方法二：优先队列

**思路及算法**

对于前 $k$ 大或前 $k$ 小这类问题，有一个通用的解法：优先队列。优先队列可以在 $O(\log n)$ 的时间内完成插入或删除元素的操作（其中 $n$ 为优先队列的大小），并可以 $O(1)$ 地查询优先队列顶端元素。

在本题中，我们可以创建一个小根优先队列（顾名思义，就是优先队列顶端元素是最小元素的优先队列）。我们将每一个字符串插入到优先队列中，如果优先队列的大小超过了 $k$，那么我们就将优先队列顶端元素弹出。这样最终优先队列中剩下的 $k$ 个元素就是前 $k$ 个出现次数最多的单词。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<string> topKFrequent(vector<string>& words, int k) {
        unordered_map<string, int> cnt;
        for (auto& word : words) {
            cnt[word]++;
        }
        auto cmp = [](const pair<string, int>& a, const pair<string, int>& b) {
            return a.second == b.second ? a.first < b.first : a.second > b.second;
        };
        priority_queue<pair<string, int>, vector<pair<string, int>>, decltype(cmp)> que(cmp);
        for (auto& it : cnt) {
            que.emplace(it);
            if (que.size() > k) {
                que.pop();
            }
        }
        vector<string> ret(k);
        for (int i = k - 1; i >= 0; i--) {
            ret[i] = que.top().first;
            que.pop();
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<String> topKFrequent(String[] words, int k) {
        Map<String, Integer> cnt = new HashMap<String, Integer>();
        for (String word : words) {
            cnt.put(word, cnt.getOrDefault(word, 0) + 1);
        }
        PriorityQueue<Map.Entry<String, Integer>> pq = new PriorityQueue<Map.Entry<String, Integer>>(new Comparator<Map.Entry<String, Integer>>() {
            public int compare(Map.Entry<String, Integer> entry1, Map.Entry<String, Integer> entry2) {
                return entry1.getValue() == entry2.getValue() ? entry2.getKey().compareTo(entry1.getKey()) : entry1.getValue() - entry2.getValue();
            }
        });
        for (Map.Entry<String, Integer> entry : cnt.entrySet()) {
            pq.offer(entry);
            if (pq.size() > k) {
                pq.poll();
            }
        }
        List<String> ret = new ArrayList<String>();
        while (!pq.isEmpty()) {
            ret.add(pq.poll().getKey());
        }
        Collections.reverse(ret);
        return ret;
    }
}
```

```go [sol2-Golang]
type pair struct {
    w string
    c int
}
type hp []pair
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { a, b := h[i], h[j]; return a.c < b.c || a.c == b.c && a.w > b.w }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }

func topKFrequent(words []string, k int) []string {
    cnt := map[string]int{}
    for _, w := range words {
        cnt[w]++
    }
    h := &hp{}
    for w, c := range cnt {
        heap.Push(h, pair{w, c})
        if h.Len() > k {
            heap.Pop(h)
        }
    }
    ans := make([]string, k)
    for i := k - 1; i >= 0; i-- {
        ans[i] = heap.Pop(h).(pair).w
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(l \times n + m \times l \log k)$，其中 $n$ 表示给定字符串序列的长度，$m$ 表示实际字符串种类数，$l$ 表示字符串的平均长度。我们需要 $l \times n$ 的时间将字符串插入到哈希表中，以及每次插入元素到优先队列中都需要 $l \log k$ 的时间，共需要插入 $m$ 次。

- 空间复杂度：$O(l \times (m + k))$，其中 $l$ 表示字符串的平均长度，$m$ 表示实际字符串种类数。哈希表空间占用为 $O(l \times m)$，优先队列空间占用为 $O(l \times k)$。

---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[活动｜你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)