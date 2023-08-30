#### 方法一：状态压缩 + 广度优先搜索

**思路与算法**

由于 $\textit{words}$ 中的每一个字符串都至多包含每个字母一次，并且字母的顺序无关紧要，因此我们可以使用一个 $26$ 位的二进制数 $\textit{mask}$ 表示一个字符串，其中 $\textit{mask}$ 的第 $i~(0 \leq i < 26)$ 个二进制位为 $1$，当且仅当字符串中包含第 $i$ 个字母。

根据题目描述，设 $s_1$ 和 $s_2$ 的二进制表示分别为 $\textit{mask}_1$ 和 $\textit{mask}_2$，那么 $s_1$ 和 $s_2$ 是关联的，当且仅当下面四条要求中的某一条满足：

- $s_1 = s_2$；

- $s_1$ 中有一个二进制位为 $0$，而 $s_2$ 中对应二进制位为 $1$，其余二进制位均完全相同；

- $s_1$ 中有一个二进制位为 $1$，而 $s_2$ 中对应二进制位为 $0$，其余二进制位均完全相同；

- $s_1$ 中有一个二进制位为 $1$，而 $s_2$ 中对应二进制位为 $0$；同时 $s_1$ 中有另一个二进制位为 $0$，而 $s_2$ 中对应二进制位为 $1$，其余二进制位均完全相同。

因此，我们可以将 $\textit{words}$ 中的每一个字符串看成图上的一个节点，如果两个字符串是关联的，那么它们对应的节点之间存在一条无向边。此时，题目需要求出的「总组数」就是图中连通分量的个数，「包含字符串最多的组」就是最大的连通分量。我们可以使用深度优先搜索、广度优先搜索、并查集中的任意一种方法求出所有的连通分量。

然而需要注意的是，本题中最多有 $n = 2 \times 10^4$ 个字符串，如果直接枚举任意两个字符串并判断是否关联，并以此得到图上所有的边，时间复杂度至少为 $O(n^2)$，会超出时间限制。因此我们需要找出一种更高效的方法得到所有的边。

可以发现，对于每一个字符串而言，与它关联的字符串最多会有 $1 + \textit{count}_0 + \textit{count}_1 + \textit{count}_0 \times \textit{count}_1$ 个，其中 $\textit{count}_0$ 和 $\textit{count}_1$ 分别是字符串的二进制表示中的 $0$ 和 $1$ 的数量。这个值不会超过 $1 + 26 + 26 + 26 \times 26 = 729$（当然实际上它不会超过 $196$，但它们是同阶的），即为 $O(|\Sigma|^2)$，其中 $\Sigma$ 表示字符集。因此我们可以通过「枚举一个节点」+「枚举可能的相邻节点」+「使用哈希表判断相邻节点是否真正存在」的方法得到图上所有的边，时间复杂度为 $O(n \times |\Sigma|^2)$，是可以接受的。

下面的代码给出的是基于广度优先搜索的方法。

**细节**

对于要求之一的 $s_1 = s_2$，我们可以使用哈希映射而不是普通的哈希集合来存储所有的二进制表示。在哈希映射中的每一个键值对中，键表示一个二进制表示，值表示该二进制表示出现的次数。这样一来，所有二进制表示相同的节点都会被合并成同一个节点。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> groupStrings(vector<string>& words) {
        // 使用哈希映射统计每一个二进制表示出现的次数
        unordered_map<int, int> wordmasks;
        for (const string& word: words) {
            int mask = 0;
            for (char ch: word) {
                mask |= (1 << (ch - 'a'));
            }
            ++wordmasks[mask];
        }
        
        // 辅助函数，用来得到 mask 的所有可能的相邻节点
        auto get_adjacent = [](int mask) -> vector<int> {
            vector<int> adj;
            // 将一个 0 变成 1，或将一个 1 变成 0
            for (int i = 0; i < 26; ++i) {
                adj.push_back(mask ^ (1 << i));
            }
            // 将一个 0 变成 1，且将一个 1 变成 0
            for (int i = 0; i < 26; ++i) {
                if (mask & (1 << i)) {
                    for (int j = 0; j < 26; ++j) {
                        if (!(mask & (1 << j))) {
                            adj.push_back(mask ^ (1 << i) ^ (1 << j));
                        }
                    }
                }
            }
            return adj;
        };
        
        unordered_set<int> used;
        int best = 0, cnt = 0;
        for (const auto& [mask, occ]: wordmasks) {
            if (used.count(mask)) {
                continue;
            }
            // 从一个未搜索过的节点开始进行广度优先搜索，并求出对应连通分量的大小
            queue<int> q;
            q.push(mask);
            used.insert(mask);
            // total 记录联通分量的大小
            int total = occ;
            while (!q.empty()) {
                int u = q.front();
                q.pop();
                for (int v: get_adjacent(u)) {
                    if (wordmasks.count(v) && !used.count(v)) {
                        q.push(v);
                        used.insert(v);
                        total += wordmasks[v];
                    }
                }
            }
            best = max(best, total);
            ++cnt;
        }
            
        return {cnt, best};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def groupStrings(self, words: List[str]) -> List[int]:
        # 使用哈希映射统计每一个二进制表示出现的次数
        wordmasks = Counter()
        for word in words:
            mask = 0
            for ch in word:
                mask |= (1 << (ord(ch) - ord("a")))
            wordmasks[mask] += 1
        
        # 辅助函数，用来得到 mask 的所有可能的相邻节点
        def get_adjacent(mask: int) -> List[int]:
            adj = list()
            # 将一个 0 变成 1，或将一个 1 变成 0
            for i in range(26):
                adj.append(mask ^ (1 << i))
            # 将一个 0 变成 1，且将一个 1 变成 0
            for i in range(26):
                if mask & (1 << i):
                    for j in range(26):
                        if not (mask & (1 << j)):
                            adj.append(mask ^ (1 << i) ^ (1 << j))
            return adj
        
        used = set()
        best = cnt = 0
        for mask, occ in wordmasks.items():
            if mask in used:
                continue
            
            # 从一个未搜索过的节点开始进行广度优先搜索，并求出对应连通分量的大小
            q = deque([mask])
            used.add(mask)
            # total 记录联通分量的大小
            total = occ

            while q:
                u = q.popleft()
                for v in get_adjacent(u):
                    if v in wordmasks and v not in used:
                        q.append(v)
                        used.add(v)
                        total += wordmasks[v]
            
            best = max(best, total)
            cnt += 1
            
        return [cnt, best]
```

**复杂度分析**

- 时间复杂度：$O(n |\Sigma|^2)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$\Sigma$ 表示字符集，在本题中为所有小写字母，$|\Sigma| = 26$。

- 空间复杂度：$O(n)$，即为哈希映射需要使用的空间。