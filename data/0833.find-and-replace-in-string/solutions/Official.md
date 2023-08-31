## [833.字符串中的查找与替换 中文官方题解](https://leetcode.cn/problems/find-and-replace-in-string/solutions/100000/zi-fu-chuan-zhong-de-cha-zhao-yu-ti-huan-9ns4)
#### 方法一：按照下标排序 + 模拟

**思路与算法**

我们直接按照题目的要求进行模拟即可。

首先我们根据数组 $\textit{indices}$，将所有的替换操作进行升序排序。在这一步中，同时对 $\textit{indices}$，$\textit{sources}$，$\textit{targets}$ 这三个数组进行排序较为困难，我们可以使用一个长度（记为 $m$）与它们相同的数组 $\textit{ops}$，存储 $0$ 到 $m-1$ 这 $m$ 个下标，随后对 $\textit{ops}$ 本身按照 $\textit{indices}$ 作为第一关键字进行排序即可。

在排序完成后，我们就可以遍历给定的字符串 $s$ 进行操作了。我们使用另一个指针 $\textit{pt}$ 指向 $\textit{ops}$ 的首个元素，表示当前需要进行的操作。当我们遍历到第 $i$ 个字符时，我们首先不断往右移动 $\textit{pt}$，直到其移出边界，或者第 $\textit{ops}[\textit{pt}]$ 个操作的下标不小于 $i$。此时，会有如下的两种情况：

- 如果这个下标大于 $i$，说明不存在下标为 $i$ 的操作。我们可以直接将第 $i$ 个字符放入答案中；

- 如果这个下标等于 $i$，说明存在下标为 $i$ 的操作。我们将 $s$ 从位置 $i$ 开始的长度与 $\textit{sources}[\textit{ops}[i]]$ 的子串与 $\textit{sources}[\textit{ops}[i]]$ 进行比较：
    - 如果相等，那么替换操作成功，我们将 $\textit{targets}[\textit{ops}[i]]$ 放入答案中。由于替换操作不可能重叠，因此我们可以直接跳过 $\textit{sources}[\textit{ops}[i]]$ 长度那么多数量的字符；

    - 否则，替换操作失败，我们可以直接将第 $i$ 个字符放入答案中。

需要注意的是，题目中只保证了成功的替换操作不会重叠，而不保证失败的替换操作不会重叠。因此当这个下标等于 $i$ 时，可能会有多个替换操作需要进行尝试，即我们需要不断往右移动 $pt$，直到其移出边界，或者第 $\textit{ops}[\textit{pt}]$ 个操作的下标严格大于 $i$。遍历到的替换操作需要依次进行尝试，如果其中一个成功，那么剩余的不必尝试，可以直接退出。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string findReplaceString(string s, vector<int>& indices, vector<string>& sources, vector<string>& targets) {
        int n = s.size(), m = indices.size();

        vector<int> ops(m);
        iota(ops.begin(), ops.end(), 0);
        sort(ops.begin(), ops.end(), [&](int i, int j) { return indices[i] < indices[j]; });

        string ans;
        int pt = 0;
        for (int i = 0; i < n;) {
            while (pt < m && indices[ops[pt]] < i) {
                ++pt;
            }
            bool succeed = false;
            while (pt < m && indices[ops[pt]] == i) {
                if (s.substr(i, sources[ops[pt]].size()) == sources[ops[pt]]) {
                    succeed = true;
                    break;
                }
                ++pt;
            }
            if (succeed) {
                ans += targets[ops[pt]];
                i += sources[ops[pt]].size();
            }
            else {
                ans += s[i];
                ++i;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String findReplaceString(String s, int[] indices, String[] sources, String[] targets) {
        int n = s.length(), m = indices.length;

        List<Integer> ops = new ArrayList<>();
        for (int i = 0; i < m; i++) {
            ops.add(i);
        }
        ops.sort((i, j) -> indices[i] - indices[j]);

        StringBuilder ans = new StringBuilder();
        int pt = 0;
        for (int i = 0; i < n;) {
            while (pt < m && indices[ops.get(pt)] < i) {
                pt++;
            }
            boolean succeed = false;
            while (pt < m && indices[ops.get(pt)] == i) {
                if (s.substring(i, Math.min(i + sources[ops.get(pt)].length(), n)).equals(sources[ops.get(pt)])) {
                    succeed = true;
                    break;
                }
                pt++;
            }
            if (succeed) {
                ans.append(targets[ops.get(pt)]);
                i += sources[ops.get(pt)].length();
            } else {
                ans.append(s.charAt(i));
                i++;
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string FindReplaceString(string s, int[] indices, string[] sources, string[] targets) {
        int n = s.Length, m = indices.Length;

        IList<int> ops = new List<int>();
        for (int i = 0; i < m; i++) {
            ops.Add(i);
        }
        ((List<int>) ops).Sort((i, j) => indices[i] - indices[j]);

        StringBuilder ans = new StringBuilder();
        int pt = 0;
        for (int i = 0; i < n;) {
            while (pt < m && indices[ops[pt]] < i) {
                pt++;
            }
            bool succeed = false;
            while (pt < m && indices[ops[pt]] == i) {
                if (s.Substring(i, Math.Min(sources[ops[pt]].Length, n - i)).Equals(sources[ops[pt]])) {
                    succeed = true;
                    break;
                }
                pt++;
            }
            if (succeed) {
                ans.Append(targets[ops[pt]]);
                i += sources[ops[pt]].Length;
            } else {
                ans.Append(s[i]);
                i++;
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findReplaceString(self, s: str, indices: List[int], sources: List[str], targets: List[str]) -> str:
        n, m = len(s), len(indices)

        ops = list(range(m))
        ops.sort(key=lambda x: indices[x])

        ans = list()
        i = pt = 0
        while i < n:
            while pt < m and indices[ops[pt]] < i:
                pt += 1
            succeed = False
            while pt < m and indices[ops[pt]] == i:
                if s[i:i + len(sources[ops[pt]])] == sources[ops[pt]]:
                    succeed = True
                    break
                pt += 1
            if succeed:
                ans.append(targets[ops[pt]])
                i += len(sources[ops[pt]])
            else:
                ans.append(s[i])
                i += 1

        return "".join(ans)
```

```JavaScript [sol1-JavaScript]
var findReplaceString = function(s, indices, sources, targets) {
    const n = s.length;
    const m = indices.length;

    const ops = new Array(m);
    for (let i = 0; i < m; i++) {
        ops[i] = i;
    }
    ops.sort((i, j) => indices[i] - indices[j]);

    let ans = "";
    let pt = 0;
    for (let i = 0; i < n; ) {
        while (pt < m && indices[ops[pt]] < i) {
            pt++;
        }
        let found = false;
        while (pt < m && indices[ops[pt]] == i) {
            if (s.substring(i, i + sources[ops[pt]].length) === sources[ops[pt]]) {
                found = true;
                break;
            }
            pt++;
        }
        if (found) {
            ans += targets[ops[pt]];
            i += sources[ops[pt]].length;
        } else {
            ans += s[i];
            i++;
        }
    }
    return ans;
};
```

```C [sol1-C]
static int cmp(const void *a, const void *b) {
    return ((int *)a)[1] - ((int *)b)[1];
}

char * findReplaceString(char * s, int* indices, int indicesSize, char ** sources, int sourcesSize, char ** targets, int targetsSize) {
    int n = strlen(s), m = indicesSize;

    int ops[m][2];
    int sourcesLen[sourcesSize];
    for (int i = 0; i < m; i++) {
        ops[i][0] = i;
        ops[i][1] = indices[i];
    }
    for (int i = 0; i < sourcesSize; i++) {
        sourcesLen[i] = strlen(sources[i]);
    }
    qsort(ops, m, sizeof(ops[0]), cmp);

    char *ans = (char *)calloc(1024, sizeof(char));
    int pt = 0, pos = 0;
    for (int i = 0; i < n;) {
        while (pt < m && indices[ops[pt][0]] < i) {
            ++pt;
        }
        bool succeed = false;
        while (pt < m && indices[ops[pt][0]] == i) {
            if (strncmp(s + i, sources[ops[pt][0]], sourcesLen[ops[pt][0]]) == 0) {
                succeed = true;
                break;
            }
            ++pt;
        }
        if (succeed) {
            pos += sprintf(ans + pos, "%s", targets[ops[pt][0]]);
            i += sourcesLen[ops[pt][0]];
        } else {
            ans[pos++] = s[i];
            ++i;
        }
    }
    return ans;
}
```

```Go [sol1-Go]
func findReplaceString(s string, indices []int, sources []string, targets []string) string {
    n, m := len(s), len(indices)

    ops := make([][]int, m)
    for i := 0; i < m; i++ {
        ops[i] = []int{i, indices[i]}
    }
    sort.Slice(ops, func(i int, j int) bool {
        return ops[i][1] < ops[j][1]
    })

    ans := ""
    pt := 0
    for i := 0; i < n; {
        for pt < m && indices[ops[pt][0]] < i {
            pt++
        }
        succeed := false
        for pt < m && indices[ops[pt][0]] == i {
            if s[i : i + min(len(sources[ops[pt][0]]), n - i)] == sources[ops[pt][0]] {
                succeed = true
                break
            }
            pt++
        }
        if succeed {
            ans += targets[ops[pt][0]]
            i += len(sources[ops[pt][0]])
        } else {
            ans += string(s[i])
            i++
        }
    }
    return ans
}

func min(x int, y int) int {
    if x > y {
        return y
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n + m \log m + ml)$，其中 $n$ 是字符串 $s$ 的长度，$m$ 是数组 $\textit{indices}$ 的长度，$l$ 是数组 $\textit{sources}$ 和 $\textit{targets}$ 中字符串的平均长度。

    - 排序需要的时间为 $O(m \log m)$；

    - 在使用双指针进行遍历的过程中，遍历字符串需要的时间为 $O(n)$，遍历数组 $\textit{ops}$ 需要的时间为 $O(m)$，在最坏情况下需要尝试每一个替换操作，比较和构造最终答案需要的时间为 $O(ml)$。

    相加即可得到总时间复杂度 $O(n + m \log m + ml)$。

- 空间复杂度：$O(n + ml)$。

    - 数组 $\textit{ops}$ 需要的空间为 $O(m)$；

    - 排序需要的栈空间为 $O(\log m)$；

    - 在替换操作中进行比较时，如果使用的语言支持无拷贝的切片操作，那么需要的空间为 $O(1)$，否则为 $O(l)$；

    - 在构造最终答案时，如果使用的语言支持带修改的字符串，那么需要的空间为 $O(1)$（不考虑最终答案占用的空间），否则需要 $O(n + ml)$ 的辅助空间。

    对于不同语言，上述需要的空间会有所变化。这里取每一种可能的最大值，相加即可得到总空间复杂度 $O(n + ml)$。

#### 方法二：哈希表 + 模拟

**思路与算法**

我们也可以将方法一中的数组 $\textit{ops}$ 换成哈希映射，其中的键表示字符串中的下标，值是一个数组，存储了所有操作该下标的操作编号。我们只需要对数组 $\textit{indices}$ 进行一次遍历，就可以得到这个哈希表。

在这之后，当我们对字符串 $s$ 进行遍历时，如果遍历到位置 $i$，那么哈希表中键 $i$ 对应的数组，就是所有对位置 $i$ 进行的操作。我们使用与方法一相同的方法处理这些操作即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    string findReplaceString(string s, vector<int>& indices, vector<string>& sources, vector<string>& targets) {
        int n = s.size(), m = indices.size();

        unordered_map<int, vector<int>> ops;
        for (int i = 0; i < m; ++i) {
            ops[indices[i]].push_back(i);
        }

        string ans;
        for (int i = 0; i < n;) {
            bool succeed = false;
            if (ops.count(i)) {
                for (int pt: ops[i]) {
                    if (s.substr(i, sources[pt].size()) == sources[pt]) {
                        succeed = true;
                        ans += targets[pt];
                        i += sources[pt].size();
                        break;
                    }
                }
            }
            if (!succeed) {
                ans += s[i];
                ++i;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String findReplaceString(String s, int[] indices, String[] sources, String[] targets) {
        int n = s.length(), m = indices.length;

        Map<Integer, List<Integer>> ops = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < m; ++i) {
            ops.putIfAbsent(indices[i], new ArrayList<Integer>());
            ops.get(indices[i]).add(i);
        }

        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < n;) {
            boolean succeed = false;
            if (ops.containsKey(i)) {
                for (int pt : ops.get(i)) {
                    if (s.substring(i, Math.min(i + sources[pt].length(), n)).equals(sources[pt])) {
                        succeed = true;
                        ans.append(targets[pt]);
                        i += sources[pt].length();
                        break;
                    }
                }
            }
            if (!succeed) {
                ans.append(s.charAt(i));
                ++i;
            }
        }
        return ans.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string FindReplaceString(string s, int[] indices, string[] sources, string[] targets) {
        int n = s.Length, m = indices.Length;

        IDictionary<int, IList<int>> ops = new Dictionary<int, IList<int>>();
        for (int i = 0; i < m; ++i) {
            ops.TryAdd(indices[i], new List<int>());
            ops[indices[i]].Add(i);
        }

        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < n;) {
            bool succeed = false;
            if (ops.ContainsKey(i)) {
                foreach (int pt in ops[i]) {
                    if (s.Substring(i, Math.Min(i + sources[pt].Length, n) - i).Equals(sources[pt])) {
                        succeed = true;
                        ans.Append(targets[pt]);
                        i += sources[pt].Length;
                        break;
                    }
                }
            }
            if (!succeed) {
                ans.Append(s[i]);
                ++i;
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def findReplaceString(self, s: str, indices: List[int], sources: List[str], targets: List[str]) -> str:
        n, m = len(s), len(indices)

        ops = defaultdict(list)
        for i, idx in enumerate(indices):
            ops[idx].append(i)

        ans = list()
        i = 0
        while i < n:
            succeed = False
            if i in ops:
                for pt in ops[i]:
                    if s[i:i+len(sources[pt])] == sources[pt]:
                        succeed = True
                        ans.append(targets[pt])
                        i += len(sources[pt])
                        break
            if not succeed:
                ans.append(s[i])
                i += 1

        return "".join(ans)
```

```JavaScript [sol2-JavaScript]
var findReplaceString = function(s, indices, sources, targets) {
    const n = s.length, m = indices.length;

    const ops = new Map();
    for (let i = 0; i < m; i++) {
        if (!ops.has(indices[i])) {
            ops.set(indices[i], []);
        }
        ops.get(indices[i]).push(i);
    }

    let ans = "";
    for (let i = 0; i < n; ) {
        let succeed = false;
        if (ops.has(i)) {
            console.log(ops.get(i))
            for (const pt of ops.get(i)) {
                if (s.substring(i, Math.min(i + sources[pt].length, n)) === sources[pt]) {
                    succeed = true;
                    ans += targets[pt];
                    i += sources[pt].length;
                    break;
                }
            }
        }
        if (!succeed) {
            ans += s[i];
            ++i;
        }
    }
    return ans;
};
```

```C [sol2-C]
typedef struct {
    int key;
    struct ListNode *list;
    UT_hash_handle hh;
} HashItem;

struct ListNode *creatListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

void freeLinkList(struct ListNode *list) {
    while (list) {
        struct ListNode *curr = list;
        list = list->next;
        free(curr);
    }
}

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (pEntry) {
        struct ListNode *node = creatListNode(val);
        node->next = pEntry->list;
        pEntry->list = node;
    } else {
        HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->list = creatListNode(val);
        HASH_ADD_INT(*obj, key, pEntry);
    }
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        freeLinkList(curr->list);
        free(curr);
    }
}

char * findReplaceString(char * s, int* indices, int indicesSize, char ** sources, int sourcesSize, char ** targets, int targetsSize) {
    int n = strlen(s), m = indicesSize;

    HashItem *ops = NULL;
    for (int i = 0; i < m; ++i) {
        hashAddItem(&ops, indices[i], i);
    }

    char *ans = (char *)calloc(n * 50 + 1, sizeof(char));
    int pos = 0;
    for (int i = 0; i < n;) {
        bool succeed = false;
        HashItem *pEntry = hashFindItem(&ops, i);
        if (pEntry) {
            for (struct ListNode *node = pEntry->list; node; node = node->next) {
                int pt = node->val;
                if (!strncmp(s + i, sources[pt], strlen(sources[pt]))) {
                    succeed = true;
                    pos += sprintf(ans + pos, "%s", targets[pt]);
                    i += strlen(sources[pt]);
                    break;
                }
            }
        }
        if (!succeed) {
            ans[pos++] = s[i++];
        }
    }
    hashFree(&ops);
    return ans;
}
```

```Go [sol2-Go]
func findReplaceString(s string, indices []int, sources []string, targets []string) string {
    n, m := len(s), len(indices)

    ops := map[int][]int{}
    for i := 0; i < m; i++ {
        ops[indices[i]] = append(ops[i], i)
    }

    ans := ""
    for i := 0; i < n; {
        succeed := false
        _, ok := ops[i]
        if ok {
            for _, pt := range ops[i] {
                if s[i : i + min(len(sources[pt]), n - i)] == sources[pt] {
                    succeed = true
                    ans += targets[pt]
                    i += len(sources[pt])
                    break
                }
            }
        }
        if !succeed {
            ans += string(s[i])
            i++
        }
    }
    return ans
}

func min(x int, y int) int {
    if x > y {
        return y
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n + ml)$，其中 $n$ 是字符串 $s$ 的长度，$m$ 是数组 $\textit{indices}$ 的长度，$l$ 是数组 $\textit{sources}$ 和 $\textit{targets}$ 中字符串的平均长度。

    - 将操作放入哈希表需要的时间为 $O(m)$；

    - 在使用双指针进行遍历的过程中，遍历字符串需要的时间为 $O(n)$，遍历哈希表需要的时间为 $O(m)$，在最坏情况下需要尝试每一个替换操作，比较和构造最终答案需要的时间为 $O(ml)$。

    相加即可得到总时间复杂度 $O(n + ml)$。

- 空间复杂度：$O(n + ml)$。

    - 哈希表需要的空间为 $O(m)$；

    - 在替换操作中进行比较时，如果使用的语言支持无拷贝的切片操作，那么需要的空间为 $O(1)$，否则为 $O(l)$；

    - 在构造最终答案时，如果使用的语言支持带修改的字符串，那么需要的空间为 $O(1)$（不考虑最终答案占用的空间），否则需要 $O(n + ml)$ 的辅助空间。

    对于不同语言，上述需要的空间会有所变化。这里取每一种可能的最大值，相加即可得到总空间复杂度 $O(n + ml)$。