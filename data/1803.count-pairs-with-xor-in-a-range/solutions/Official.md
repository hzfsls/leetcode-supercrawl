## [1803.统计异或值在范围内的数对有多少 中文官方题解](https://leetcode.cn/problems/count-pairs-with-xor-in-a-range/solutions/100000/tong-ji-yi-huo-zhi-zai-fan-wei-nei-de-sh-cu18)
#### 方法一：字典树

**思路与算法**

题目想要求解有多少对数字的异或运算结果处于 $[\textit{low}, \textit{high}]$ 之间，为了方便求解，我们用 $\textit{f}(x)$ 来表示有多少对数字的异或运算结果小于等于 $x$，这时问题变为求解 $f(\textit{high}) - f(\textit{low} - 1)$。

考虑枚举一个元素 $a_i$，求解有多少元素 $a_j~(j\lt i)$ 使得 $a_i \oplus a_j \le x$，其中 $\oplus$ 表示按位异或运算。由于求解问题时，$x$ 是已知的，我们可以设计一种「从高位到低位依次计算数字个数」的方法，来得到问题的解。该方法的关键点在于：

- 由于数组中的元素都在 $[1, 2\times 10^4]$ 的范围内，那么我们可以将每一个数字表示为一个长度为 $15$ 位的二进制数字（如果不满 $15$ 位，在最高位之前补上若干个前导 $0$ 即可）；
- 这 $15$ 个二进制位从低位到高位依次编号为 $0,1,\cdots,14$。我们从最高位第 $14$ 个二进制位开始，依次计算有多少元素与 $a_i$ 的异或运算结果小于 $x$；
- 对于任意一个使得 $a_i \oplus a_j \lt x$ 条件成立的 $a_j$，都存在一个 $k$，使得 $a_i \oplus a_j$ 的二进制表示中的第 $14$ 位到第 $k + 1$ 位与 $x$ 相同，而第 $k$ 位却小于。

为了更好的计算答案，我们将数组中的元素看做是长度为 $15$ 的字符串，字符串中只包含 $0$ 和 $1$。如果将字符串放入字典树中，那么在字典树中查询一个字符串的过程，恰好就是从高位开始确定一个二进制的过程。字典树的具体逻辑以及实现可以参考[「208. 实现 Trie（前缀树）的官方题解」](https://leetcode.cn/problems/implement-trie-prefix-tree/solutions/717239/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)，这里我们只说明如何使用字典树解决本题。

我们枚举 $a_i$，并将 $a_0,a_1,\cdots,a_{i-1}$ 作为 $a_j$ 放入字典树中，希望找出有多少个 $a_j$ 使得 $a_i \oplus a_j \le x$。字典树的每个节点记录一个数字，表示有多少个数字以根结点到该节点路径为前缀。为了计算它，我们需要在添加一个数字时，将路径上的所有节点的数字都加 $1$。

我们可以从字典树的根结点开始遍历，遍历的参照对象是 $a_i$ 和 $x$。假设我们当前遍历到了第 $k$ 个二进制位：

- 如果 $x$ 的第 $k$ 个二进制位为 $0$，那么此时不存在使得 $a_i \oplus a_j \lt x$ 条件成立的 $a_j$，设 $r$ 是 $a_i$ 的第 $k$ 个二进制位，我们需要往表示 $r$ 的子节点走，这保证了路径上的数值与 $a_i$ 做异或后前缀与 $x$ 相同。
- 如果 $x$ 的第 $k$ 个二进制位为 $1$，设 $r$ 是 $a_i$ 的第 $k$ 个二进制位，那么此时表示 $r$ 的子节点中记录的数字，就是使得 $a_i \oplus a_j \lt x$ 条件成立的 $a_j$ 的个数，将它累加到答案中。然后我们需要往表示 $r\oplus 1$ 的子节点走，这保证了路径上的数值与 $a_i$ 做异或后前缀与 $x$ 相同。

如果在过程中，出现某个子节点不存在使得过程无法继续，我们需要立刻返回答案。否则在最后，我们遍历完所有的 $15$ 个二进制位后，到达的最后一个节点中记录的数字是使得 $a_i \oplus a_j = x$ 条件成立的 $a_j$ 的个数，也将其累加到答案中。至此，我们求出来所有使得 $a_i \oplus a_j \le x$ 条件成立的 $a_j$ 的个数。

**代码**

```Python [sol1-Python3]
HIGH_BIT = 14

class TrieNode:
    def __init__(self):
        self.children = [None, None]
        self.sum = 0

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def add(self, num: int) -> None:
        cur = self.root
        for k in range(HIGH_BIT, -1, -1):
            bit = (num >> k) & 1
            if not cur.children[bit]:
                cur.children[bit] = TrieNode()
            cur = cur.children[bit]
            cur.sum += 1

    def get(self, num: int, x: int) -> int:
        res = 0
        cur = self.root
        for k in range(HIGH_BIT, -1, -1):
            bit = (num >> k) & 1
            if (x >> k) & 1:
                if cur.children[bit]:
                    res += cur.children[bit].sum
                if not cur.children[bit ^ 1]:
                    return res
                cur = cur.children[bit ^ 1]
            else:
                if not cur.children[bit]:
                    return res
                cur = cur.children[bit]
        res += cur.sum
        return res

class Solution:
    def countPairs(self, nums: List[int], low: int, high: int) -> int:
        def f(nums: List[int], x: int) -> int:
            res = 0
            trie = Trie()
            for i in range(1, len(nums)):
                trie.add(nums[i - 1])
                res += trie.get(nums[i], x)
            return res
        return f(nums, high) - f(nums, low - 1)
```

```C++ [sol1-C++]
struct Trie {
    // son[0] 表示左子树，son[1] 表示右子树
    array<Trie*, 2> son{nullptr, nullptr};
    int sum;
    Trie():sum(0) {}
};

class Solution {
private:
    // 字典树的根节点
    Trie* root = nullptr;
    // 最高位的二进制位编号为 14
    static constexpr int HIGH_BIT = 14;

public:
    void add(int num) {
        Trie* cur = root;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int bit = (num >> k) & 1;
            if (cur->son[bit] == nullptr) {
                cur->son[bit] = new Trie();
            }
            cur = cur->son[bit];
            cur->sum++;
        }
    }

    int get(int num, int x) {
        Trie* cur = root;
        int sum = 0;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int r = (num >> k) & 1;
            if ((x >> k) & 1) {
                if (cur->son[r] != nullptr) {
                    sum += cur->son[r]->sum;
                }
                if (cur->son[r ^ 1] == nullptr) {
                    return sum;
                }
                cur = cur->son[r ^ 1];
            } else {
                if (cur->son[r] == nullptr) {
                    return sum;
                }
                cur = cur->son[r];
            }
        }
        sum += cur->sum;
        return sum;
    }

    int f(vector<int>& nums, int x) {
        root = new Trie();
        int res = 0;
        for (int i = 1; i < nums.size(); i++) {
            add(nums[i - 1]);
            res += get(nums[i], x);
        }
        return res;
    }

    int countPairs(vector<int>& nums, int low, int high) {
        return f(nums, high) - f(nums, low - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    // 字典树的根节点
    private Trie root = null;
    // 最高位的二进制位编号为 14
    private static final int HIGH_BIT = 14;

    public int countPairs(int[] nums, int low, int high) {
        return f(nums, high) - f(nums, low - 1);
    }

    public int f(int[] nums, int x) {
        root = new Trie();
        int res = 0;
        for (int i = 1; i < nums.length; i++) {
            add(nums[i - 1]);
            res += get(nums[i], x);
        }
        return res;
    }

    public void add(int num) {
        Trie cur = root;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int bit = (num >> k) & 1;
            if (cur.son[bit] == null) {
                cur.son[bit] = new Trie();
            }
            cur = cur.son[bit];
            cur.sum++;
        }
    }

    public int get(int num, int x) {
        Trie cur = root;
        int sum = 0;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int r = (num >> k) & 1;
            if (((x >> k) & 1) != 0) {
                if (cur.son[r] != null) {
                    sum += cur.son[r].sum;
                }
                if (cur.son[r ^ 1] == null) {
                    return sum;
                }
                cur = cur.son[r ^ 1];
            } else {
                if (cur.son[r] == null) {
                    return sum;
                }
                cur = cur.son[r];
            }
        }
        sum += cur.sum;
        return sum;
    }
}

class Trie {
    // son[0] 表示左子树，son[1] 表示右子树
    Trie[] son = new Trie[2];
    int sum;

    public Trie() {
        sum = 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    // 字典树的根节点
    private Trie root = null;
    // 最高位的二进制位编号为 14
    private const int HIGH_BIT = 14;

    public int CountPairs(int[] nums, int low, int high) {
        return F(nums, high) - F(nums, low - 1);
    }

    public int F(int[] nums, int x) {
        root = new Trie();
        int res = 0;
        for (int i = 1; i < nums.Length; i++) {
            Add(nums[i - 1]);
            res += Get(nums[i], x);
        }
        return res;
    }

    public void Add(int num) {
        Trie cur = root;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int bit = (num >> k) & 1;
            if (cur.son[bit] == null) {
                cur.son[bit] = new Trie();
            }
            cur = cur.son[bit];
            cur.sum++;
        }
    }

    public int Get(int num, int x) {
        Trie cur = root;
        int sum = 0;
        for (int k = HIGH_BIT; k >= 0; k--) {
            int r = (num >> k) & 1;
            if (((x >> k) & 1) != 0) {
                if (cur.son[r] != null) {
                    sum += cur.son[r].sum;
                }
                if (cur.son[r ^ 1] == null) {
                    return sum;
                }
                cur = cur.son[r ^ 1];
            } else {
                if (cur.son[r] == null) {
                    return sum;
                }
                cur = cur.son[r];
            }
        }
        sum += cur.sum;
        return sum;
    }
}

class Trie {
    // son[0] 表示左子树，son[1] 表示右子树
    public Trie[] son = new Trie[2];
    public int sum;

    public Trie() {
        sum = 0;
    }
}
```

```C [sol1-C]
typedef struct Trie {
    struct Trie *son[2];
    int sum;
} Trie;

const int HIGH_BIT = 14;

Trie * creatTrieNode() {
    Trie *obj = (Trie *)malloc(sizeof(Trie));
    obj->son[0] = obj->son[1] = NULL;
    obj->sum = 0;
    return obj;
}

void freeTrie(Trie *root) {
    if (!root) {
        return;
    }
    freeTrie(root->son[0]);
    freeTrie(root->son[1]);
    free(root);
}

void add(int num, Trie *root) {
    Trie* cur = root;
    for (int k = HIGH_BIT; k >= 0; k--) {
        int bit = (num >> k) & 1;
        if (cur->son[bit] == NULL) {
            cur->son[bit] = creatTrieNode();
        }
        cur = cur->son[bit];
        cur->sum++;
    }
}

int get(int num, int x, const Trie *root) {
    const Trie* cur = root;
    int sum = 0;
    for (int k = HIGH_BIT; k >= 0; k--) {
        int r = (num >> k) & 1;
        if ((x >> k) & 1) {
            if (cur->son[r] != NULL) {
                sum += cur->son[r]->sum;
            }
            if (cur->son[r ^ 1] == NULL) {
                return sum;
            }
            cur = cur->son[r ^ 1];
        } else {
            if (cur->son[r] == NULL) {
                return sum;
            }
            cur = cur->son[r];
        }
    }
    sum += cur->sum;
    return sum;
}

int f(const int *nums, int numsSize, int x) {
    Trie *root = creatTrieNode();
    int res = 0;
    for (int i = 1; i < numsSize; i++) {
        add(nums[i - 1], root);
        res += get(nums[i], x, root);
    }
    freeTrie(root);
    return res;
}

int countPairs(int* nums, int numsSize, int low, int high) {
    return f(nums, numsSize, high) - f(nums, numsSize, low - 1);
}
```

```JavaScript [sol1-JavaScript]
const HIGH_BIT = 14;
var countPairs = function(nums, low, high) {
    return f(nums, high) - f(nums, low - 1);
};

const f = (nums, x) => {
    root = new Trie();
    let res = 0;

    const add = (num) => {
        let cur = root;
        for (let k = HIGH_BIT; k >= 0; k--) {
            let bit = (num >> k) & 1;
            if (!cur.son[bit]) {
                cur.son[bit] = new Trie();
            }
            cur = cur.son[bit];
            cur.sum++;
        }
    }

    const get = (num, x) => {
        let cur = root;
        let sum = 0;
        for (let k = HIGH_BIT; k >= 0; k--) {
            let r = (num >> k) & 1;
            if (((x >> k) & 1) !== 0) {
                if (cur.son[r]) {
                    sum += cur.son[r].sum;
                }
                if (!cur.son[r ^ 1]) {
                    return sum;
                }
                cur = cur.son[r ^ 1];
            } else {
                if (!cur.son[r]) {
                    return sum;
                }
                cur = cur.son[r];
            }
        }
        sum += cur.sum;
        return sum;
    }

    for (let i = 1; i < nums.length; i++) {
        add(nums[i - 1]);
        res += get(nums[i], x);
    }
    return res;
}

class Trie {
    // son[0] 表示左子树，son[1] 表示右子树
    constructor() {
        this.son = new Array(2).fill(0);
        this.sum = 0;
    }
}
```

```go [sol1-Golang]
const trieBitLen = 14

type trieNode struct {
    son [2]*trieNode
    cnt int
}

type trie struct{ root *trieNode }

func (t *trie) put(v int) *trieNode {
    o := t.root
    for i := trieBitLen; i >= 0; i-- {
        b := v >> i & 1
        if o.son[b] == nil {
            o.son[b] = &trieNode{}
        }
        o = o.son[b]
        o.cnt++
    }
    return o
}

func (t *trie) countLimitXOR(v, limit int) (cnt int) {
    o := t.root
    for i := trieBitLen; i >= 0; i-- {
        b := v >> i & 1
        if limit>>i&1 > 0 {
            if o.son[b] != nil {
                cnt += o.son[b].cnt
            }
            b ^= 1
        }
        if o.son[b] == nil {
            return
        }
        o = o.son[b]
    }
    return
}

func countPairs(nums []int, low, high int) (ans int) {
    t := &trie{&trieNode{}}
    t.put(nums[0])
    for _, v := range nums[1:] {
        ans += t.countLimitXOR(v, high+1) - t.countLimitXOR(v, low)
        t.put(v)
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n\log C)$。其中 $n$ 是 $nums$ 的长度，$C$ 是数组中的元素范围，在本题中 $C \lt 2^{15}$。我们需要将 $a_0,a_1,\cdots,a_{n-2}$ 加入到字典树中，并且需要以 $a_1,a_2,\cdots,a_{n-1}$ 以及 $x$ 作为「参照对象」在字典树上进行遍历，每一项操作的单次时间复杂度为 $O(\log C)$，因此总时间复杂度为 $O(n\log C)$。

- 空间复杂度：$O(n\log C)$。每一个元素在字典树中需要使用 $O(\log C)$ 的空间，因此总空间复杂度为 $O(n\log C)$。