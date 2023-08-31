## [1707.与数组中元素的最大异或值 中文官方题解](https://leetcode.cn/problems/maximum-xor-with-an-element-from-array/solutions/100000/yu-shu-zu-zhong-yuan-su-de-zui-da-yi-huo-7erc)

#### 前言

本文需要读者了解字典树的相关知识，建议读者尝试解决「[208. 实现 Trie (前缀树)](https://leetcode-cn.com/problems/implement-trie-prefix-tree/)」，在充分理解该题做法后继续阅读。

#### 方法一：离线询问 + 字典树

**思路**

我们先来解决一个弱化版的问题：去掉询问中 $m_i$ 的限制，如何求 $x_i$ 与 $\textit{nums}$ 数组任意元素的异或最大值？

我们可以将 $\textit{nums}$ 中的每个元素看作一个长为 $L$ 的二进制串，将其插入字典树中。

例如 $\textit{nums}=[3,10,5,25,2]$，取 $L=5$，对应的二进制串为 $[00011,01010,00101,11001,00010]$，将其插入字典树后得到的结果如下图。

![fig1](https://assets.leetcode-cn.com/solution-static/1707/1.png)

为了最大化异或值，我们可以在字典树中进行一次与检索字符串类似的过程，从根节点出发，由于异或运算具有「相同得 $0$，不同得 $1$」的性质，为了尽可能多地取到 $1$，我们需要在每一步寻找与当前位相反的子节点，若该节点存在则将指针移动到该节点，否则只能移动到与当前位相同的子节点。（注意由于插入和查询的二进制串长度均为 $L$，非叶节点的两个子节点中，至少有一个是非空节点）

以 $x_i=25=(11001)_2$ 为例，下图展示了求取最大异或值的过程。

![fig2](https://assets.leetcode-cn.com/solution-static/1707/2.png)

回到原问题，由于全部询问已经给出，我们不一定要按顺序回答询问，而是按照 $m_i$ 从小到大的顺序回答。

首先将数组 $\textit{nums}$ 从小到大排序，将询问按照 $m_i$ 的大小从小到大排序。

在回答每个询问前，将所有不超过 $m_i$ 的 $\textit{nums}$ 元素插入字典序中，由于 $\textit{nums}$ 已经排好序，我们可以维护一个指向 $\textit{nums}$ 数组元素的下标 $\textit{idx}$，初始值为 $0$，每插入一个元素就将 $\textit{idx}$ 加一。对于每个询问，我们可以不断插入满足 $\textit{nums}[\textit{idx}]\le m_i$ 的元素，直至不满足该条件或 $\textit{idx}$ 指向了数组末尾。

此时字典树中的元素就是 $\textit{nums}$ 中所有不超过 $m_i$ 的元素，这样就转换成了弱化版的问题。

代码实现时，由于 $\textit{nums}$ 元素不超过 $10^9$，为简单起见，可取 $L=30$，即 $10^9$ 的二进制串的长度。此外，由于对询问排序会打乱原询问的顺序，而我们需要按照原询问的顺序返回答案，因此可以在排序前，对每个询问附加一个其在 $\textit{queries}$ 中的下标。

**代码**

```C++ [sol1-C++]
class Trie {
public:
    const int L = 30;

    Trie* children[2] = {};

    void insert(int val) {
        Trie* node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node->children[bit] == nullptr) {
                node->children[bit] = new Trie();
            }
            node = node->children[bit];
        }
    }

    int getMaxXor(int val) {
        int ans = 0;
        Trie* node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node->children[bit ^ 1] != nullptr) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node->children[bit];
        }
        return ans;
    }
};

class Solution {
public:
    vector<int> maximizeXor(vector<int> &nums, vector<vector<int>> &queries) {
        sort(nums.begin(), nums.end());
        int numQ = queries.size();
        for (int i = 0; i < numQ; ++i) {
            queries[i].push_back(i);
        }
        sort(queries.begin(), queries.end(), [](auto &x, auto &y) { return x[1] < y[1]; });

        vector<int> ans(numQ);
        Trie* t = new Trie();
        int idx = 0, n = nums.size();
        for (auto &q : queries) {
            int x = q[0], m = q[1], qid = q[2];
            while (idx < n && nums[idx] <= m) {
                t->insert(nums[idx]);
                ++idx;
            }
            if (idx == 0) { // 字典树为空
                ans[qid] = -1;
            } else {
                ans[qid] = t->getMaxXor(x);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] maximizeXor(int[] nums, int[][] queries) {
        Arrays.sort(nums);
        int numQ = queries.length;
        int[][] newQueries = new int[numQ][3];
        for (int i = 0; i < numQ; ++i) {
            newQueries[i][0] = queries[i][0];
            newQueries[i][1] = queries[i][1];
            newQueries[i][2] = i;
        }
        Arrays.sort(newQueries, new Comparator<int[]>() {
            public int compare(int[] query1, int[] query2) {
                return query1[1] - query2[1];
            }
        });

        int[] ans = new int[numQ];
        Trie trie = new Trie();
        int idx = 0, n = nums.length;
        for (int[] query : newQueries) {
            int x = query[0], m = query[1], qid = query[2];
            while (idx < n && nums[idx] <= m) {
                trie.insert(nums[idx]);
                ++idx;
            }
            if (idx == 0) { // 字典树为空
                ans[qid] = -1;
            } else {
                ans[qid] = trie.getMaxXor(x);
            }
        }
        return ans;
    }
}

class Trie {
    static final int L = 30;
    Trie[] children = new Trie[2];

    public void insert(int val) {
        Trie node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit] == null) {
                node.children[bit] = new Trie();
            }
            node = node.children[bit];
        }
    }

    public int getMaxXor(int val) {
        int ans = 0;
        Trie node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit ^ 1] != null) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node.children[bit];
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] MaximizeXor(int[] nums, int[][] queries) {
        Array.Sort(nums);
        int numQ = queries.Length;
        Tuple<int, int, int>[] newQueries = new Tuple<int, int, int>[numQ];
        for (int i = 0; i < numQ; ++i) {
            newQueries[i] = new Tuple<int, int, int>(queries[i][0], queries[i][1], i);
        }
        Array.Sort<Tuple<int, int, int>>(newQueries,
            delegate(Tuple<int, int, int> query1, Tuple<int, int, int> query2) {
                return query1.Item2 - query2.Item2;
            }
        );

        int[] ans = new int[numQ];
        Trie trie = new Trie();
        int idx = 0, n = nums.Length;
        foreach (Tuple<int, int, int> query in newQueries) {
            int x = query.Item1, m = query.Item2, qid = query.Item3;
            while (idx < n && nums[idx] <= m) {
                trie.Insert(nums[idx]);
                ++idx;
            }
            if (idx == 0) { // 字典树为空
                ans[qid] = -1;
            } else {
                ans[qid] = trie.GetMaxXor(x);
            }
        }
        return ans;
    }
}

class Trie {
    const int L = 30;
    Trie[] children = new Trie[2];

    public void Insert(int val) {
        Trie node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit] == null) {
                node.children[bit] = new Trie();
            }
            node = node.children[bit];
        }
    }

    public int GetMaxXor(int val) {
        int ans = 0;
        Trie node = this;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit ^ 1] != null) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node.children[bit];
        }
        return ans;
    }
}
```

```go [sol1-Golang]
const L = 30

type trie struct {
    children [2]*trie
}

func (t *trie) insert(val int) {
    node := t
    for i := L - 1; i >= 0; i-- {
        bit := val >> i & 1
        if node.children[bit] == nil {
            node.children[bit] = &trie{}
        }
        node = node.children[bit]
    }
}

func (t *trie) getMaxXor(val int) (ans int) {
    node := t
    for i := L - 1; i >= 0; i-- {
        bit := val >> i & 1
        if node.children[bit^1] != nil {
            ans |= 1 << i
            bit ^= 1
        }
        node = node.children[bit]
    }
    return
}

func maximizeXor(nums []int, queries [][]int) []int {
    sort.Ints(nums)
    for i := range queries {
        queries[i] = append(queries[i], i)
    }
    sort.Slice(queries, func(i, j int) bool { return queries[i][1] < queries[j][1] })

    ans := make([]int, len(queries))
    t := &trie{}
    idx, n := 0, len(nums)
    for _, q := range queries {
        x, m, qid := q[0], q[1], q[2]
        for idx < n && nums[idx] <= m {
            t.insert(nums[idx])
            idx++
        }
        if idx == 0 { // 字典树为空
            ans[qid] = -1
        } else {
            ans[qid] = t.getMaxXor(x)
        }
    }
    return ans
}
```

```Python [sol1-Python3]
class Trie:
    L = 30

    def __init__(self):
        self.left = None
        self.right = None

    def insert(self, val: int):
        node = self
        for i in range(Trie.L, -1, -1):
            bit = (val >> i) & 1
            if bit == 0:
                if not node.left:
                    node.left = Trie()
                node = node.left
            else:
                if not node.right:
                    node.right = Trie()
                node = node.right
    
    def getMaxXor(self, val: int) -> int:
        ans, node = 0, self
        for i in range(Trie.L, -1, -1):
            bit = (val >> i) & 1
            check = False
            if bit == 0:
                if node.right:
                    node = node.right
                    check = True
                else:
                    node = node.left
            else:
                if node.left:
                    node = node.left
                    check = True
                else:
                    node = node.right
            if check:
                ans |= 1 << i
        return ans


class Solution:
    def maximizeXor(self, nums: List[int], queries: List[List[int]]) -> List[int]:
        n, q = len(nums), len(queries)
        nums.sort()
        queries = sorted([(x, m, i) for i, (x, m) in enumerate(queries)], key=lambda query: query[1])
        
        ans = [0] * q
        t = Trie()
        idx = 0
        for x, m, qid in queries:
            while idx < n and nums[idx] <= m:
                t.insert(nums[idx])
                idx += 1
            if idx == 0:
                # 字典树为空
                ans[qid] = -1
            else:
                ans[qid] = t.getMaxXor(x)
        
        return ans
```

```C [sol1-C]
const int L = 30;

struct TrieNode {
    struct TrieNode* children[2];
};

struct TrieNode* createTrieNode() {
    struct TrieNode* ret = malloc(sizeof(struct TrieNode));
    ret->children[0] = ret->children[1] = NULL;
    return ret;
};

void insert(struct TrieNode* root, int val) {
    struct TrieNode* node = root;
    for (int i = L - 1; i >= 0; --i) {
        int bit = (val >> i) & 1;
        if (node->children[bit] == NULL) {
            node->children[bit] = createTrieNode();
        }
        node = node->children[bit];
    }
}

int getMaxXor(struct TrieNode* root, int val) {
    int ans = 0;
    struct TrieNode* node = root;
    for (int i = L - 1; i >= 0; --i) {
        int bit = (val >> i) & 1;
        if (node->children[bit ^ 1] != NULL) {
            ans |= 1 << i;
            bit ^= 1;
        }
        node = node->children[bit];
    }
    return ans;
}

int cmp1(int* a, int* b) {
    return *a - *b;
}

int cmp2(int** a, int** b) {
    return (*a)[1] - (*b)[1];
}

int* maximizeXor(int* nums, int numsSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    qsort(nums, numsSize, sizeof(int), cmp1);
    for (int i = 0; i < queriesSize; ++i) {
        queries[i] = realloc(queries[i], sizeof(int) * 3);
        queries[i][2] = i;
    }
    qsort(queries, queriesSize, sizeof(int*), cmp2);
    int* ans = malloc(sizeof(int) * queriesSize);
    *returnSize = queriesSize;
    struct TrieNode* t = createTrieNode();
    int idx = 0, n = numsSize;
    for (int i = 0; i < queriesSize; i++) {
        int x = queries[i][0], m = queries[i][1], qid = queries[i][2];
        while (idx < n && nums[idx] <= m) {
            insert(t, nums[idx]);
            ++idx;
        }
        if (idx == 0) {  // 字典树为空
            ans[qid] = -1;
        } else {
            ans[qid] = getMaxXor(t, x);
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N+Q\log Q+(N+Q)\cdot L)$。其中 $N$ 是数组 $\textit{nums}$ 的长度，$Q$ 是数组 $\textit{queries}$ 的长度，$L$ 是 $\textit{nums}$ 中的每个元素的二进制表示的长度，算法中固定 $L=30$。排序 $\textit{nums}$ 的时间复杂度为 $O(N\log N)$，排序 $\textit{queries}$ 的时间复杂度为 $O(Q\log Q)$，每次插入和查询的时间复杂度均为 $O(L)$，因此总的时间复杂度为 $O(N\log N+Q\log Q+(N+Q)\cdot L)$。

- 空间复杂度：$O(Q+N\cdot L)$。我们需要 $O(Q)$ 的空间来存储每个查询在排序前的 $\textit{queries}$ 中的位置，且 $\textit{nums}$ 中的每个元素至多需要 $O(L)$ 个字典树节点来存储，因此空间复杂度为 $O(Q+N\cdot L)$。

#### 方法二：在线询问 + 字典树

**思路**

我们可以给字典树上的每个节点添加一个值 $\textit{min}$，表示以该节点为根的子树所记录的元素的最小值。特别地，根节点的 $\textit{min}$ 表示字典树上记录的所有元素的最小值。

首先将所有元素插入字典树，插入时更新字典树对应节点的 $\textit{min}$ 值。

然后依次回答每个询问：若 $m_i$ 小于根节点的 $\textit{min}$ 值，说明 $\textit{nums}$ 中的所有元素都大于 $m_i$，返回 $-1$；否则，做法类似方法一，只需要在循环内额外判断与当前位相反的子节点的 $\textit{min}$ 是否不超过 $m_i$，若不超过则可以转移至该节点。

**代码**

```C++ [sol2-C++]
class Trie {
public:
    const int L = 30;

    Trie* children[2] = {};
    int min = INT_MAX;

    void insert(int val) {
        Trie* node = this;
        node->min = std::min(node->min, val);
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node->children[bit] == nullptr) {
                node->children[bit] = new Trie();
            }
            node = node->children[bit];
            node->min = std::min(node->min, val);
        }
    }

    int getMaxXorWithLimit(int val, int limit) {
        Trie* node = this;
        if (node->min > limit) {
            return -1;
        }
        int ans = 0;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node->children[bit ^ 1] != nullptr && node->children[bit ^ 1]->min <= limit) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node->children[bit];
        }
        return ans;
    }
};

class Solution {
public:
    vector<int> maximizeXor(vector<int> &nums, vector<vector<int>> &queries) {
        Trie* t = new Trie();
        for (int val : nums) {
            t->insert(val);
        }
        int numQ = queries.size();
        vector<int> ans(numQ);
        for (int i = 0; i < numQ; ++i) {
            ans[i] = t->getMaxXorWithLimit(queries[i][0], queries[i][1]);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] maximizeXor(int[] nums, int[][] queries) {
        Trie trie = new Trie();
        for (int val : nums) {
            trie.insert(val);
        }
        int numQ = queries.length;
        int[] ans = new int[numQ];
        for (int i = 0; i < numQ; ++i) {
            ans[i] = trie.getMaxXorWithLimit(queries[i][0], queries[i][1]);
        }
        return ans;
    }
}

class Trie {
    static final int L = 30;
    Trie[] children = new Trie[2];
    int min = Integer.MAX_VALUE;

    public void insert(int val) {
        Trie node = this;
        node.min = Math.min(node.min, val);
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit] == null) {
                node.children[bit] = new Trie();
            }
            node = node.children[bit];
            node.min = Math.min(node.min, val);
        }
    }

    public int getMaxXorWithLimit(int val, int limit) {
        Trie node = this;
        if (node.min > limit) {
            return -1;
        }
        int ans = 0;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit ^ 1] != null && node.children[bit ^ 1].min <= limit) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node.children[bit];
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] MaximizeXor(int[] nums, int[][] queries) {
        Trie trie = new Trie();
        foreach (int val in nums) {
            trie.Insert(val);
        }
        int numQ = queries.Length;
        int[] ans = new int[numQ];
        for (int i = 0; i < numQ; ++i) {
            ans[i] = trie.GetMaxXorWithLimit(queries[i][0], queries[i][1]);
        }
        return ans;
    }
}

class Trie {
    const int L = 30;
    Trie[] children = new Trie[2];
    int min = int.MaxValue;

    public void Insert(int val) {
        Trie node = this;
        node.min = Math.Min(node.min, val);
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit] == null) {
                node.children[bit] = new Trie();
            }
            node = node.children[bit];
            node.min = Math.Min(node.min, val);
        }
    }

    public int GetMaxXorWithLimit(int val, int limit) {
        Trie node = this;
        if (node.min > limit) {
            return -1;
        }
        int ans = 0;
        for (int i = L - 1; i >= 0; --i) {
            int bit = (val >> i) & 1;
            if (node.children[bit ^ 1] != null && node.children[bit ^ 1].min <= limit) {
                ans |= 1 << i;
                bit ^= 1;
            }
            node = node.children[bit];
        }
        return ans;
    }
}
```

```go [sol2-Golang]
const L = 30

type trie struct {
    children [2]*trie
    min      int
}

func (t *trie) insert(val int) {
    node := t
    if val < node.min {
        node.min = val
    }
    for i := L - 1; i >= 0; i-- {
        bit := val >> i & 1
        if node.children[bit] == nil {
            node.children[bit] = &trie{min: val}
        }
        node = node.children[bit]
        if val < node.min {
            node.min = val
        }
    }
}

func (t *trie) getMaxXorWithLimit(val, limit int) (ans int) {
    node := t
    if node.min > limit {
        return -1
    }
    for i := L - 1; i >= 0; i-- {
        bit := val >> i & 1
        if node.children[bit^1] != nil && node.children[bit^1].min <= limit {
            ans |= 1 << i
            bit ^= 1
        }
        node = node.children[bit]
    }
    return
}

func maximizeXor(nums []int, queries [][]int) []int {
    t := &trie{min: math.MaxInt32}
    for _, val := range nums {
        t.insert(val)
    }
    ans := make([]int, len(queries))
    for i, q := range queries {
        ans[i] = t.getMaxXorWithLimit(q[0], q[1])
    }
    return ans
}
```

```Python [sol2-Python3]
class Trie:
    L = 30

    def __init__(self):
        self.left = None
        self.right = None
        self.min_value = float("inf")

    def insert(self, val: int):
        node = self
        node.min_value = min(node.min_value, val)
        for i in range(Trie.L, -1, -1):
            bit = (val >> i) & 1
            if bit == 0:
                if not node.left:
                    node.left = Trie()
                node = node.left
            else:
                if not node.right:
                    node.right = Trie()
                node = node.right
            node.min_value = min(node.min_value, val)
    
    def getMaxXorWithLimit(self, val: int, limit: int) -> int:
        node = self
        if node.min_value > limit:
            return -1
        
        ans = 0
        for i in range(Trie.L, -1, -1):
            bit = (val >> i) & 1
            check = False
            if bit == 0:
                if node.right and node.right.min_value <= limit:
                    node = node.right
                    check = True
                else:
                    node = node.left
            else:
                if node.left and node.left.min_value <= limit:
                    node = node.left
                    check = True
                else:
                    node = node.right
            if check:
                ans |= 1 << i
        return ans


class Solution:
    def maximizeXor(self, nums: List[int], queries: List[List[int]]) -> List[int]:
        t = Trie()
        for val in nums:
            t.insert(val)
        
        q = len(queries)
        ans = [0] * q
        for i, (x, m) in enumerate(queries):
            ans[i] = t.getMaxXorWithLimit(x, m)
        
        return ans
```

```C [sol2-C]
const int L = 30;

struct TrieNode {
    int minn;
    struct TrieNode* children[2];
};

struct TrieNode* createTrieNode() {
    struct TrieNode* ret = malloc(sizeof(struct TrieNode));
    ret->minn = INT_MAX;
    ret->children[0] = ret->children[1] = NULL;
    return ret;
};

void insert(struct TrieNode* root, int val) {
    struct TrieNode* node = root;
    node->minn = fmin(node->minn, val);
    for (int i = L - 1; i >= 0; --i) {
        int bit = (val >> i) & 1;
        if (node->children[bit] == NULL) {
            node->children[bit] = createTrieNode();
        }
        node = node->children[bit];
        node->minn = fmin(node->minn, val);
    }
}

int getMaxXorWithLimit(struct TrieNode* root, int val, int limit) {
    struct TrieNode* node = root;
    if (node->minn > limit) {
        return -1;
    }
    int ans = 0;
    for (int i = L - 1; i >= 0; --i) {
        int bit = (val >> i) & 1;
        if (node->children[bit ^ 1] != NULL && node->children[bit ^ 1]->minn <= limit) {
            ans |= 1 << i;
            bit ^= 1;
        }
        node = node->children[bit];
    }
    return ans;
}

int* maximizeXor(int* nums, int numsSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    struct TrieNode* t = createTrieNode();
    for (int i = 0; i < numsSize; i++) {
        insert(t, nums[i]);
    }
    int* ans = malloc(sizeof(int) * queriesSize);
    *returnSize = queriesSize;
    for (int i = 0; i < queriesSize; ++i) {
        ans[i] = getMaxXorWithLimit(t, queries[i][0], queries[i][1]);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O((N+Q)\cdot L)$。相较方法一，方法二没有排序的过程，因此时间复杂度为 $O((N+Q)\cdot L)$。

- 空间复杂度：$O(N\cdot L)$。空间复杂度不考虑返回值，而 $\textit{nums}$ 中的每个元素至多需要 $O(L)$ 个字典树节点来存储，因此空间复杂度为 $O(N\cdot L)$。