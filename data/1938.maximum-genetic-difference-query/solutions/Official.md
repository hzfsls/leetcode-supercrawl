#### 前言

本题与[「1707. 与数组中元素的最大异或值」](https://leetcode-cn.com/problems/maximum-xor-with-an-element-from-array/)是非常相似的题，读者只需要掌握[「1707. 与数组中元素的最大异或值」的官方题解](https://leetcode-cn.com/problems/maximum-xor-with-an-element-from-array/solution/yu-shu-zu-zhong-yuan-su-de-zui-da-yi-huo-7erc/)中的方法一，即可顺利地解决本题。

#### 方法一：离线算法 + 字典树

**思路与算法**

对于给定的询问 $(\textit{node}_i, \textit{val}_i)$，我们需要找出从根节点到节点 $\textit{node}_i$ 的路径中使得 $p_i \oplus \textit{val}_i$ 达到最大值的节点 $p_i$，其中 $\oplus$ 表示按位异或运算。那么我们可以从根节点开始，对整棵树进行一次深度优先遍历，即：

- 当我们第一次遍历到某一节点 $i$ 时，我们将 $i$ 放入「数据结构」中；

- 当我们遍历完所有节点 $i$ 的子节点，即将回溯到 $i$ 的父节点前，我们将 $i$ 从「数据结构」中移除。

这样一来，我们就可以通过「离线」的思想将每一个询问 $(\textit{node}_i, \textit{val}_i)$ 在遍历到节点 $\textit{val}_i$ 时进行求解。这是因为，如果当前正在遍历节点 $\textit{val}_i$，那么数据结构中就存放着所有从根节点到节点 $\textit{val}_i$ 的路径上的所有节点。此时，我们只需要找出数据结构中使得 $p_i \oplus \textit{val}_i$ 达到最大值的节点 $p_i$ 即可。

一种满足要求的数据结构即为字典树。在力扣平台上，使用这一思路的题目已经出现了多次，除了前言部分提到的 1707 题以外，还有[「421. 数组中两个数的最大异或值」](https://leetcode-cn.com/problems/maximum-xor-of-two-numbers-in-an-array/)，都是通过字典树来求解最大的异或值。

在本题中，我们希望字典树能够：

- 添加一个数；

- 删除一个数；

- 查询与给定的 $\textit{val}_i$ 进行异或运算可以达到的最大值。

这些都是字典树的最基本操作，如果读者对此不够熟悉，可以参考上文提到的题目或者下文的代码进行学习。

**细节**

由于字典树中存储的是每个数的二进制表示，因此我们需要确定题目中最大的数的二进制表示的位数。在本题中，节点的编号不超过 $10^5$，询问中的 $\textit{val}_i$ 不超过 $2\times 10^5$，由于 $2^{17} < 2\times 10^5 < 2^{18}$，那么最大的数的二进制表示不会超过 $18$ 位。

**代码**

在下面的 $\texttt{C++}$ 代码中，我们没有对字典树进行析构操作。如果读者在面试中遇到了本题，对于是否进行析构这一问题，需要与面试官进行沟通。

```C++ [sol1-C++]
struct Trie {
    Trie* left;
    Trie* right;
    // 由于我们的字典树需要支持删除数的操作
    // 因此这里使用 cnt 变量进行记录该节点对应的数的个数
    int cnt;

    Trie(): left(nullptr), right(nullptr), cnt(0) {}
};

class Solution {
private:
    // 最大的数的二进制表示不会超过 18 位
    // 那么二进制位的下标范围为 [0, 17]
    static constexpr int MAXD = 17;

public:
    vector<int> maxGeneticDifference(vector<int>& parents, vector<vector<int>>& queries) {
        int n = parents.size();

        // 将 parents 存储为树的形式，方便进行深度优先遍历
        vector<vector<int>> edges(n);
        // 找出根节点
        int root = -1;
        for (int i = 0; i < n; ++i) {
            if (parents[i] == -1) {
                root = i;
            }
            else {
                edges[parents[i]].push_back(i);
            }
        }

        int q = queries.size();
        // 使用离线的思想，stored[i] 存储了所有节点 i 对应的询问
        vector<vector<pair<int, int>>> stored(n);
        vector<int> ans(q);
        for (int i = 0; i < q; ++i) {
            stored[queries[i][0]].emplace_back(i, queries[i][1]);
        }

        Trie* r = new Trie();

        // 向字典树添加一个数
        auto trie_insert = [&](int x) {
            Trie* cur = r;
            for (int i = MAXD; i >= 0; --i) {
                if (x & (1 << i)) {
                    if (!cur->right) {
                        cur->right = new Trie();
                    }
                    cur = cur->right;
                }
                else {
                    if (!cur->left) {
                        cur->left = new Trie();
                    }
                    cur = cur->left;
                }
                ++cur->cnt;
            }
        };

        // 对于给定的 x，返回字典树中包含的数与 x 进行异或运算可以达到的最大值
        auto trie_query = [&](int x) -> int {
            int ret = 0;
            Trie* cur = r;
            for (int i = MAXD; i >= 0; --i) {
                if (x & (1 << i)) {
                    if (cur->left && cur->left->cnt) {
                        ret |= (1 << i);
                        cur = cur->left;
                    }
                    else {
                        cur = cur->right;
                    }
                }
                else {
                    if (cur->right && cur->right->cnt) {
                        ret |= (1 << i);
                        cur = cur->right;
                    }
                    else {
                        cur = cur->left;
                    }
                }
            }
            return ret;
        };

        // 从字典树中删除一个数
        auto trie_erase = [&](int x) {
            Trie* cur = r;
            for (int i = MAXD; i >= 0; --i) {
                if (x & (1 << i)) {
                    cur = cur->right;
                }
                else {
                    cur = cur->left;
                }
                --cur->cnt;
            }
        };

        // 深度优先遍历
        function<void(int)> dfs = [&](int u) {
            trie_insert(u);
            for (auto [idx, num]: stored[u]) {
                ans[idx] = trie_query(num);
            }
            for (int v: edges[u]) {
                dfs(v);
            }
            trie_erase(u);
        };

        dfs(root);
        return ans;
    }
};
```

```Python [sol1-Python3]
class Trie:
    left: "Trie" = None
    right: "Trie" = None
    # 由于我们的字典树需要支持删除数的操作
    # 因此这里使用 cnt 变量进行记录该节点对应的数的个数
    cnt: int = 0

class Solution:

    # 最大的数的二进制表示不会超过 18 位
    # 那么二进制位的下标范围为 [0, 17]
    MAXD = 17

    def maxGeneticDifference(self, parents: List[int], queries: List[List[int]]) -> List[int]:
        n = len(parents)

        # 将 parents 存储为树的形式，方便进行深度优先遍历
        edges = defaultdict(list)
        # 找出根节点
        root = -1
        for i, parent in enumerate(parents):
            if parent == -1:
                root = i
            else:
                edges[parent].append(i)

        q = len(queries)
        # 使用离线的思想，stored[i] 存储了所有节点 i 对应的询问
        stored = defaultdict(list)
        ans = [0] * q
        for i, (node, val) in enumerate(queries):
            stored[node].append((i, val))

        r = Trie()

        # 向字典树添加一个数
        def trie_insert(x: int) -> None:
            cur = r
            for i in range(Solution.MAXD, -1, -1):
                if x & (1 << i):
                    if not cur.right:
                        cur.right = Trie()
                    cur = cur.right
                else:
                    if not cur.left:
                        cur.left = Trie()
                    cur = cur.left
                cur.cnt += 1

        # 对于给定的 x，返回字典树中包含的数与 x 进行异或运算可以达到的最大值
        def trie_query(x: int) -> int:
            cur, ret = r, 0
            for i in range(Solution.MAXD, -1, -1):
                if x & (1 << i):
                    if cur.left and cur.left.cnt:
                        ret |= (1 << i)
                        cur = cur.left
                    else:
                        cur = cur.right
                else:
                    if cur.right and cur.right.cnt:
                        ret |= (1 << i)
                        cur = cur.right
                    else:
                        cur = cur.left
            return ret

        # 从字典树中删除一个数
        def trie_erase(x: int) -> None:
            cur = r
            for i in range(Solution.MAXD, -1, -1):
                if x & (1 << i):
                    cur = cur.right
                else:
                    cur = cur.left
                cur.cnt -= 1

        # 深度优先遍历
        def dfs(u: int) -> None:
            trie_insert(u)
            for idx, num in stored[u]:
                ans[idx] = trie_query(num)
            for v in edges[u]:
                dfs(v)
            trie_erase(u)

        dfs(root)
        return ans
```

**复杂度分析**

- 时间复杂度：$O((n+q) \log C)$，其中 $q$ 是数组 $\textit{queries}$ 的长度，$\log C = 18$ 是本题中最大的数的二进制表示的位数。在深度优先遍历的过程中，访问的节点个数为 $n$，每个节点需要 $O(\log C)$ 的时间在一开将其加入字典树以及回溯前将其从字典树中移除。对于数组 $\textit{queries}$ 中的每一个询问，我们需要 $O(\log C)$ 的时间得到答案。因此总时间复杂度为 $O((n+q) \log C)$。

- 空间复杂度：$O(n\log C + q)$。我们需要 $O(n)$ 的空间存储树本身，$O(n \log C)$ 的空间存储字典树，$O(q)$ 的空间存储将询问进行离线，分配到每个节点上。