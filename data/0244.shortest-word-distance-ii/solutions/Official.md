## [244.最短单词距离 II 中文官方题解](https://leetcode.cn/problems/shortest-word-distance-ii/solutions/100000/zui-duan-dan-ci-ju-chi-ii-by-leetcode-so-no7m)

#### 方法一：哈希表 + 双指针

这道题是「[243. 最短单词距离](https://leetcode-cn.com/problems/shortest-word-distance)」的进阶版本，和第 243 题的区别在于这道题要求实现一个数据结构，该数据结构支持计算两个单词的最短距离。

由于计算最短距离的操作会被调用多次且每次寻找的单词可能不同，因此需要维护一个哈希表记录每个单词的下标列表。

初始化数据结构时，从左到右遍历数组 $\textit{wordsDict}$，得到每个单词在数组中的全部下标。由于从左到右遍历满足下标递增顺序，因此每个单词的下标列表中存储的下标都是递增的。

计算两个单词的最短距离时，首先得到两个单词对应的下标列表，然后使用双指针遍历两个下标列表，计算最短距离。具体做法是，用 $\textit{index}_1$ 和 $\textit{index}_2$ 分别表示 $\textit{word}_1$ 和 $\textit{word}_2$ 在数组中的下标，此时两个单词的距离是 $|\textit{index}_1 - \textit{index}_2|$，为了计算最短距离，应根据 $\textit{index}_1$ 和 $\textit{index}_2$ 的大小关系执行相应的操作：

- 如果 $\textit{index}_1 < \textit{index}_2$，则将 $\textit{index}_1$ 移动到下一个 $\textit{word}_1$ 的下标；

- 如果 $\textit{index}_1 > \textit{index}_2$，则将 $\textit{index}_2$ 移动到下一个 $\textit{word}_2$ 的下标。

```Python [sol1-Python3]
class WordDistance:
    def __init__(self, wordsDict: List[str]):
        self.indicesMap = defaultdict(list)
        for i, word in enumerate(wordsDict):
            self.indicesMap[word].append(i)

    def shortest(self, word1: str, word2: str) -> int:
        ans = inf
        indices1 = self.indicesMap[word1]
        indices2 = self.indicesMap[word2]
        i, n = 0, len(indices1)
        j, m = 0, len(indices2)
        while i < n and j < m:
            index1, index2 = indices1[i], indices2[j]
            ans = min(ans, abs(index1 - index2))
            if index1 < index2:
                i += 1
            else:
                j += 1
        return ans
```

```Java [sol1-Java]
class WordDistance {
    Map<String, List<Integer>> indicesMap = new HashMap<String, List<Integer>>();

    public WordDistance(String[] wordsDict) {
        int length = wordsDict.length;
        for (int i = 0; i < length; i++) {
            String word = wordsDict[i];
            indicesMap.putIfAbsent(word, new ArrayList<Integer>());
            indicesMap.get(word).add(i);
        }
    }

    public int shortest(String word1, String word2) {
        List<Integer> indices1 = indicesMap.get(word1);
        List<Integer> indices2 = indicesMap.get(word2);
        int size1 = indices1.size(), size2 = indices2.size();
        int pos1 = 0, pos2 = 0;
        int ans = Integer.MAX_VALUE;
        while (pos1 < size1 && pos2 < size2) {
            int index1 = indices1.get(pos1), index2 = indices2.get(pos2);
            ans = Math.min(ans, Math.abs(index1 - index2));
            if (index1 < index2) {
                pos1++;
            } else {
                pos2++;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class WordDistance {
    Dictionary<string, IList<int>> indicesDictionary = new Dictionary<string, IList<int>>();

    public WordDistance(string[] wordsDict) {
        int length = wordsDict.Length;
        for (int i = 0; i < length; i++) {
            string word = wordsDict[i];
            if (!indicesDictionary.ContainsKey(word)) {
                indicesDictionary.Add(word, new List<int>());
            }
            indicesDictionary[word].Add(i);
        }
    }

    public int Shortest(string word1, string word2) {
        IList<int> indices1 = indicesDictionary[word1];
        IList<int> indices2 = indicesDictionary[word2];
        int size1 = indices1.Count, size2 = indices2.Count;
        int pos1 = 0, pos2 = 0;
        int ans = int.MaxValue;
        while (pos1 < size1 && pos2 < size2) {
            int index1 = indices1[pos1], index2 = indices2[pos2];
            ans = Math.Min(ans, Math.Abs(index1 - index2));
            if (index1 < index2) {
                pos1++;
            } else {
                pos2++;
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class WordDistance {
public:
    WordDistance(vector<string>& wordsDict) {
        int length = wordsDict.size();
        for (int i = 0; i < length; i++) {
            string word = wordsDict[i];
            indicesMap[word].emplace_back(i);
        }
    }
    
    int shortest(string word1, string word2) {
        vector<int> indices1 = indicesMap[word1];
        vector<int> indices2 = indicesMap[word2];
        int size1 = indices1.size(), size2 = indices2.size();
        int pos1 = 0, pos2 = 0;
        int ans = INT_MAX;
        while (pos1 < size1 && pos2 < size2) {
            int index1 = indices1[pos1], index2 = indices2[pos2];
            ans = min(ans, abs(index1 - index2));
            if (index1 < index2) {
                pos1++;
            } else {
                pos2++;
            }
        }
        return ans;
    }
private:
    unordered_map<string, vector<int>> indicesMap;
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct {
    char * key;
    struct ListNode * val;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem * indicesMap;
} WordDistance;


WordDistance* wordDistanceCreate(char ** wordsDict, int wordsDictSize) {
    WordDistance *obj = (WordDistance *)malloc(sizeof(WordDistance));
    obj->indicesMap = NULL;
    for (int i = 0; i < wordsDictSize; i++) {
        struct ListNode * node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = i;
        node->next = NULL;
        HashItem * pEntry = NULL;
        HASH_FIND_STR(obj->indicesMap, wordsDict[i], pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = wordsDict[i];
            pEntry->val = node;
            HASH_ADD_STR(obj->indicesMap, key, pEntry);
        } else {
            node->next = pEntry->val;
            pEntry->val = node;  
        }
    }
    return obj;
}

int wordDistanceShortest(WordDistance* obj, char * word1, char * word2) {
    HashItem *pEntry = NULL;
    struct ListNode *indices1 = NULL, *indices2 = NULL;
    HASH_FIND_STR(obj->indicesMap, word1, pEntry);
    indices1 = pEntry->val;
    HASH_FIND_STR(obj->indicesMap, word2, pEntry);
    indices2 = pEntry->val;
    int ans = INT_MAX;
    while (indices1 && indices2) {
        int index1 = indices1->val, index2 = indices2->val;
        ans = MIN(ans, abs(index1 - index2));
        if (index1 < index2) {
            indices2 = indices2->next;
        } else {
            indices1 = indices1->next;
        }
    }
    return ans;
}

void wordDistanceFree(WordDistance* obj) {
    HashItem *curr, *next;
    HASH_ITER(hh, obj->indicesMap, curr, next) {
      HASH_DEL(obj->indicesMap, curr);
      for (struct ListNode * node = curr->val; node; ) {
          struct ListNode * tmp = node;
          node = node->next;
          free(tmp);
      }
      free(curr);
    }
}
```

```JavaScript [sol1-JavaScript]
var WordDistance = function(wordsDict) {
    this.indicesMap = new Map();
    const length = wordsDict.length;
    for (let i = 0; i < length; i++) {
        const word = wordsDict[i];
        if (!this.indicesMap.has(word)) {
            this.indicesMap.set(word, []);
        }
        this.indicesMap.get(word).push(i);
    }
};

WordDistance.prototype.shortest = function(word1, word2) {
    const indices1 = this.indicesMap.get(word1);
    const indices2 = this.indicesMap.get(word2);
    const size1 = indices1.length, size2 = indices2.length;
    let pos1 = 0, pos2 = 0;
    let ans = Number.MAX_VALUE;
    while (pos1 < size1 && pos2 < size2) {
        const index1 = indices1[pos1], index2 = indices2[pos2];
        ans = Math.min(ans, Math.abs(index1 - index2));
        if (index1 < index2) {
            pos1++;
        } else {
            pos2++;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
type WordDistance map[string][]int

func Constructor(wordsDict []string) WordDistance {
    indicesMap := WordDistance{}
    for i, word := range wordsDict {
        indicesMap[word] = append(indicesMap[word], i)
    }
    return indicesMap
}

func (indicesMap WordDistance) Shortest(word1, word2 string) int {
    ans := math.MaxInt32
    indices1 := indicesMap[word1]
    indices2 := indicesMap[word2]
    i, n := 0, len(indices1)
    j, m := 0, len(indices2)
    for i < n && j < m {
        index1, index2 := indices1[i], indices2[j]
        ans = min(ans, abs(index1-index2))
        if index1 < index2 {
            i++
        } else {
            j++
        }
    }
    return ans
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：初始化和计算最短距离的时间复杂度都是 $O(n)$，其中 $n$ 是数组 $\textit{wordsDict}$ 的长度。这里将字符串的长度视为常数。
  构造方法需要遍历数组 $\textit{wordsDict}$ 一次，得到每个单词的下标列表。
  计算最短距离需要遍历两个单词的下标列表，两个单词的下标列表中的下标总数不超过数组的长度。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{wordsDict}$ 的长度。需要使用哈希表存储每个单词的下标列表，空间复杂度是 $O(n)$。这里将字符串的长度视为常数。