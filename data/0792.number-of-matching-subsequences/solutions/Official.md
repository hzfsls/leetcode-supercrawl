#### 方法一：二分查找

**思路与算法**

首先题目给出字符串 $s$ 和一个字符串数组 $\textit{words}$，我们需要统计字符串数组中有多少个字符串是字符串 $s$ 的子序列。
那么最朴素的方法就是我们对于字符串数组 $\textit{words}$ 中的每一个字符串和字符串 $s$ 尝试进行匹配，我们可以用「双指针」的方法来进行匹配——用 $i$ 指向字符串 $s$ 当前遍历到的字符，$j$ 指向当前需要匹配的字符串 $t$ 需要匹配的字符，初始 $i = 0$，$j = 0$，如果 $s[i] = t[j]$ 那么将指针 $i$ 和 $j$ 同时往后移动一个单位，否则仅 $i$ 移动 $i$ 往后移动一个单位，并在 $i$ 指向字符串 $s$ 结尾或者 $j$ 指向 $t$ 结尾时结束匹配过程，然后判断 $j$ 是否指向 $t$ 的结尾，若指向结尾则说明 $t$ 为字符串 $s$ 的子序列，否则不是。但是这个方法的时间复杂度会为 $O(n \times m + \sum_{i = 0}^{m - 1} \textit{size}_i)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 是字符串数组 $\textit{words}$ 的大小，$\textit{size}_i$ 为字符串数组 $\textit{words}$ 中索引为 $i$ 的字符串长度。该时间复杂度在本题中将会超时。所以我们考虑是否可以在朴素方法的基础上进行优化。

在朴素方法的匹配的过程中，对于每一个需要匹配的字符 $t[j]$，我们都需要将字符串 $s$ 中的指针 $i$ 在当前位置不断往后移动直至找到字符 $s[i]$ 使得 $s[i] = t[j]$，或者移至结尾，我们现在考虑能否加速这个过程——如果我们将字符串 $s$ 中的全部的字符的位置按照对应的字符进行存储，令其为数组 $\textit{pos}$，其中 $\textit{pos}[c]$ 存储的是字符串 $s$ 中字符为 $c$ 的从小到大排列的位置。那么对于需要匹配的字符 $t[j]$ 我们就可以通过在对应的 $\textit{pos}$ 数组中进行「二分查找」来找到第一个大于当前 $i$ 指针的位置，若不存在则说明匹配不成功，否则就将指针 $i$ 直接移到找到的对应位置，并将指针 $j$ 后移一个单位，这样就加速了指针 $i$ 的移动。

**代码**

```Python [sol1-Python3]
class Solution:
    def numMatchingSubseq(self, s: str, words: List[str]) -> int:
        pos = defaultdict(list)
        for i, c in enumerate(s):
            pos[c].append(i)
        ans = len(words)
        for w in words:
            if len(w) > len(s):
                ans -= 1
                continue
            p = -1
            for c in w:
                ps = pos[c]
                j = bisect_right(ps, p)
                if j == len(ps):
                    ans -= 1
                    break
                p = ps[j]
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int numMatchingSubseq(string s, vector<string> &words) {
        vector<vector<int>> pos(26);
        for (int i = 0; i < s.size(); ++i) {
            pos[s[i] - 'a'].push_back(i);
        }
        int res = words.size();
        for (auto &w : words) {
            if (w.size() > s.size()) {
                --res;
                continue;
            }
            int p = -1;
            for (char c : w) {
                auto &ps = pos[c - 'a'];
                auto it = upper_bound(ps.begin(), ps.end(), p);
                if (it == ps.end()) {
                    --res;
                    break;
                }
                p = *it;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numMatchingSubseq(String s, String[] words) {
        List<Integer>[] pos = new List[26];
        for (int i = 0; i < 26; ++i) {
            pos[i] = new ArrayList<Integer>();
        }
        for (int i = 0; i < s.length(); ++i) {
            pos[s.charAt(i) - 'a'].add(i);
        }
        int res = words.length;
        for (String w : words) {
            if (w.length() > s.length()) {
                --res;
                continue;
            }
            int p = -1;
            for (int i = 0; i < w.length(); ++i) {
                char c = w.charAt(i);
                if (pos[c - 'a'].isEmpty() || pos[c - 'a'].get(pos[c - 'a'].size() - 1) <= p) {
                    --res;
                    break;
                }
                p = binarySearch(pos[c - 'a'], p);
            }
        }
        return res;
    }

    public int binarySearch(List<Integer> list, int target) {
        int left = 0, right = list.size() - 1;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (list.get(mid) > target) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return list.get(left);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumMatchingSubseq(string s, string[] words) {
        IList<int>[] pos = new IList<int>[26];
        for (int i = 0; i < 26; ++i) {
            pos[i] = new List<int>();
        }
        for (int i = 0; i < s.Length; ++i) {
            pos[s[i] - 'a'].Add(i);
        }
        int res = words.Length;
        foreach (string w in words) {
            if (w.Length > s.Length) {
                --res;
                continue;
            }
            int p = -1;
            for (int i = 0; i < w.Length; ++i) {
                char c = w[i];
                if (pos[c - 'a'].Count == 0 || pos[c - 'a'][pos[c - 'a'].Count - 1] <= p) {
                    --res;
                    break;
                }
                p = BinarySearch(pos[c - 'a'], p);
            }
        }
        return res;
    }

    public int BinarySearch(IList<int> list, int target) {
        int left = 0, right = list.Count - 1;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (list[mid] > target) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return list[left];
    }
}
```

```C [sol1-C]
int binarySearch(const int *list, int listSize, int target) {
    int left = 0, right = listSize - 1;
    while (left < right) {
        int mid = left + (right - left) / 2;
        if (list[mid] > target) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return list[left];
}

int numMatchingSubseq(char * s, char ** words, int wordsSize) {
    int cnt[26], *pos[26], posSize[26];
    for (int i = 0; i < 26; ++i) {
        pos[i] = NULL;
        cnt[i] = 0;
        posSize[i] = 0;
    }
    int len = strlen(s);
    for (int i = 0; i < len; ++i) {
        posSize[s[i] - 'a']++;
    }
    for (int i = 0; i < 26; i++) {
        pos[i] = (int *)malloc(sizeof(int) * posSize[i]);
    }
    for (int i = 0; i < len; ++i) {
        pos[s[i] - 'a'][cnt[s[i] - 'a']] = i;
        cnt[s[i] - 'a']++;
    }
    int res = wordsSize;
    for (int i = 0; i < wordsSize; i++) {
        if (strlen(words[i]) > len) {
            --res;
            continue;
        }
        int p = -1;
        for (int j = 0; words[i][j] != '\0' ; ++j) {
            char c = words[i][j];
            int m = posSize[c - 'a'];
            if (m == 0 || pos[c - 'a'][m - 1] <= p) {
                --res;
                break;
            }
            p = binarySearch(pos[c - 'a'], posSize[c - 'a'], p);
        }
    }
    for (int i = 0; i < 26; i++) {
        free(pos[i]);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var numMatchingSubseq = function(s, words) {
    const pos = new Array(26).fill(0).map(() => new Array());
    for (let i = 0; i < s.length; ++i) {
        pos[s[i].charCodeAt() - 'a'.charCodeAt()].push(i);
    }
    let res = words.length;
    for (const w of words) {
        if (w.length > s.length) {
            --res;
            continue;
        }
        let p = -1;
        for (let i = 0; i < w.length; ++i) {
            const c = w[i];
            if (pos[c.charCodeAt() - 'a'.charCodeAt()].length === 0 || pos[c.charCodeAt() - 'a'.charCodeAt()][pos[c.charCodeAt() - 'a'.charCodeAt()].length - 1] <= p) {
                --res;
                break;
            }
            p = binarySearch(pos[c.charCodeAt() - 'a'.charCodeAt()], p);
        }
    }
    return res;
}

const binarySearch = (list, target) => {
    let left = 0, right = list.length - 1;
    while (left < right) {
        const mid = left + Math.floor((right - left) / 2);
        if (list[mid] > target) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return list[left];
};
```

```go [sol1-Golang]
func numMatchingSubseq(s string, words []string) int {
    pos := [26][]int{}
    for i, c := range s {
        pos[c-'a'] = append(pos[c-'a'], i)
    }
    ans := len(words)
    for _, w := range words {
        if len(w) > len(s) {
            ans--
            continue
        }
        p := -1
        for _, c := range w {
            ps := pos[c-'a']
            j := sort.SearchInts(ps, p+1)
            if j == len(ps) {
                ans--
                break
            }
            p = ps[j]
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(\sum_{i = 0}^{m - 1} \textit{size}_i \times \log n)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 是字符串数组 $\textit{words}$ 的大小，$\textit{size}_i$ 为字符串数组 $\textit{words}$ 中索引为 $i$ 的字符串长度，对于字符串数组中某一个字符串 $\textit{words}[i]$ 的查询匹配的时间开销为 $\textit{size}_i \times \log n$。
- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度，主要为存储字符串 $s$ 中每一个字符位置的空间开销。

#### 方法二：多指针

**思路与算法**

同样我们还可以在朴素方法的基础上进行优化，因为朴素方法中是每一个单词分别和字符串 $s$ 进行匹配，这样对于每一次匹配都需要从头开始遍历字符串 $s$，这增加了额外的时间开销。所以我们考虑将字符串数组 $\textit{words}$ 中的全部字符串和字符串 $s$ 同时进行匹配——同样对于每一个需要匹配的字符串我们用一个指针来指向它需要匹配的字符，那么在遍历字符串 $s$ 的过程中，对于当前遍历到的字符如果有可以匹配的字符串，那么将对应的字符串指针往后移动一单位即可。那么当字符串 $s$ 遍历结束时，字符串数组中全部字符串的匹配情况也就全部知道了。

**代码**

```Python [sol2-Python3]
class Solution:
    def numMatchingSubseq(self, s: str, words: List[str]) -> int:
        p = defaultdict(list)
        for i, w in enumerate(words):
            p[w[0]].append((i, 0))
        ans = 0
        for c in s:
            q = p[c]
            p[c] = []
            for i, j in q:
                j += 1
                if j == len(words[i]):
                    ans += 1
                else:
                    p[words[i][j]].append((i, j))
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int numMatchingSubseq(string s, vector<string> &words) {
        vector<queue<pair<int, int>>> queues(26);
        for (int i = 0; i < words.size(); ++i) {
            queues[words[i][0] - 'a'].emplace(i, 0);
        }
        int res = 0;
        for (char c : s) {
            auto &q = queues[c - 'a'];
            int size = q.size();
            while (size--) {
                auto [i, j] = q.front();
                q.pop();
                ++j;
                if (j == words[i].size()) {
                    ++res;
                } else {
                    queues[words[i][j] - 'a'].emplace(i, j);
                }
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numMatchingSubseq(String s, String[] words) {
        Queue<int[]>[] p = new Queue[26];
        for (int i = 0; i < 26; ++i) {
            p[i] = new ArrayDeque<int[]>();
        }
        for (int i = 0; i < words.length; ++i) {
            p[words[i].charAt(0) - 'a'].offer(new int[]{i, 0});
        }
        int res = 0;
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            int len = p[c - 'a'].size();
            while (len > 0) {
                int[] t = p[c - 'a'].poll();
                if (t[1] == words[t[0]].length() - 1) {
                    ++res;
                } else {
                    ++t[1];
                    p[words[t[0]].charAt(t[1]) - 'a'].offer(t);
                }
                --len;
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumMatchingSubseq(string s, string[] words) {
        Queue<int[]>[] p = new Queue<int[]>[26];
        for (int i = 0; i < 26; ++i) {
            p[i] = new Queue<int[]>();
        }
        for (int i = 0; i < words.Length; ++i) {
            p[words[i][0] - 'a'].Enqueue(new int[]{i, 0});
        }
        int res = 0;
        for (int i = 0; i < s.Length; ++i) {
            char c = s[i];
            int len = p[c - 'a'].Count;
            while (len > 0) {
                int[] t = p[c - 'a'].Dequeue();
                if (t[1] == words[t[0]].Length - 1) {
                    ++res;
                } else {
                    ++t[1];
                    p[words[t[0]][t[1]] - 'a'].Enqueue(t);
                }
                --len;
            }
        }
        return res;
    }
}
```

```C [sol2-C]
typedef struct Node {
    int idx;
    int size;
    struct Node *next;
} Node;

typedef struct {
    struct Node *head;
    struct Node *tail;
    int size;
} myQueue;

myQueue* myQueueCreate() {
    myQueue *obj = (myQueue *)malloc(sizeof(myQueue));
    obj->size = 0;
    obj->head = obj->tail = NULL;
    return obj;
}

bool myQueueEnQueue(myQueue* obj, int idx, int size) {
    struct Node *node = (struct Node *)malloc(sizeof(struct Node));
    node->idx = idx;
    node->size = size;
    node->next = NULL;
    if (!obj->head) {
        obj->head = obj->tail = node;
    } else {
        obj->tail->next = node;
        obj->tail = node;
    }
    obj->size++;
    return true;
}

bool myQueueDeQueue(myQueue* obj) {
    if (obj->size == 0) {
        return false;
    }
    struct Node *node = obj->head;
    obj->head = obj->head->next;  
    obj->size--;
    free(node);
    return true;
}

Node * myQueueFront(myQueue* obj) {
    if (obj->size == 0) {
        return NULL;
    }
    return obj->head;
}

bool myQueueIsEmpty(myQueue* obj) {
    return obj->size == 0;
}

void myQueueQueueFree(myQueue* obj) {
    for (struct Node *curr = obj->head; curr;) {
        struct Node *node = curr;
        curr = curr->next;
        free(node);
    }
    free(obj);
}

int numMatchingSubseq(char * s, char ** words, int wordsSize) {
    myQueue *p[26];
    for (int i = 0; i < 26; ++i) {
        p[i] = myQueueCreate();
    }
    for (int i = 0; i < wordsSize; ++i) {
        myQueueEnQueue(p[words[i][0] - 'a'], i, 0);
    }
    int res = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        int len = p[s[i] - 'a']->size;
        while (len) {
            len--;
            Node *t = myQueueFront(p[c - 'a']);
            int idx = t->idx, size = t->size;
            myQueueDeQueue(p[c - 'a']);
            if (size == strlen(words[idx]) - 1) {
                ++res;
            } else {
                ++size;
                myQueueEnQueue(p[words[idx][size] - 'a'], idx, size);
            }
        }
    }
    for (int i = 0; i < 26; i++) {
        myQueueQueueFree(p[i]);
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var numMatchingSubseq = function(s, words) {
    const p = new Array(26).fill(0).map(() => new Array());
    for (let i = 0; i < words.length; ++i) {
        p[words[i][0].charCodeAt() - 'a'.charCodeAt()].push([i, 0]);
    }
    let res = 0;
    for (let i = 0; i < s.length; ++i) {
        const c = s[i];
        let len = p[c.charCodeAt() - 'a'.charCodeAt()].length;
        while (len > 0) {
            const t = p[c.charCodeAt() - 'a'.charCodeAt()].shift();
            if (t[1] === words[t[0]].length - 1) {
                ++res;
            } else {
                ++t[1];
                p[words[t[0]][t[1]].charCodeAt() - 'a'.charCodeAt()].push(t);
            }
            --len;
        }
    }
    return res;
}
```

```go [sol2-Golang]
func numMatchingSubseq(s string, words []string) (ans int) {
    type pair struct{ i, j int }
    ps := [26][]pair{}
    for i, w := range words {
        ps[w[0]-'a'] = append(ps[w[0]-'a'], pair{i, 0})
    }
    for _, c := range s {
        q := ps[c-'a']
        ps[c-'a'] = nil
        for _, p := range q {
            p.j++
            if p.j == len(words[p.i]) {
                ans++
            } else {
                w := words[p.i][p.j] - 'a'
                ps[w] = append(ps[w], p)
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n + \sum_{i = 0}^{m - 1}\textit{size}_i)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 是字符串数组 $\textit{words}$ 的大小，$\textit{size}_i$ 为字符串数组 $\textit{words}$ 中索引为 $i$ 的字符串长度。
- 空间复杂度：$O(m)$，$m$ 为字符串数组 $\textit{words}$ 的大小，主要为存储字符串数组中每一个字符串现在的对应匹配指针的空间开销。