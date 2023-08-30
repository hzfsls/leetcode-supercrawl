#### 方法一：广度优先搜索

**思路与算法**

我们用布尔数组 $\textit{secret}[i]$ 表示第 $i$ 个人是否知道秘密。初始时，$\textit{secret}[0]$ 和 $\textit{secret}[\textit{firstPerson}]$ 均为 $\text{True}$，其余的元素为 $\text{False}$。

我们将数组 $\textit{meetings}$ 中的所有会议按照时间升序排序，这样在我们对 $\textit{meetings}$ 进行遍历的过程中，就可以保证按照顺序地处理所有会议。根据题目要求，由于秘密共享是「瞬时发生」的，所以我们还需要将时间相同的一批会议进行「统一」处理。

我们可以把每一个时间发生的一批会议抽象成如下的一个图论模型：

- 我们将每一个专家看成图中的一个节点；

- 如果两个专家之间进行了一场会议，那么这两个专家在图中对应的节点之间存在一条无向边。

而我们需要解决的问题转变为：

- 对于任意一个专家，如果存在另一个**已经知道秘密的专家**，它们在图中对应的节点之间是**连通的**，那么这个专家就会知道秘密。

因此，我们可以使用广度优先搜索的方法解决该问题。我们将所有已经知道秘密的专家对应的节点（如果存在）放入队列，在广度优先搜索的每一步中，我们取出队首的节点 $u$，并枚举与 $u$ 相邻的节点 $v$，如果 $v$ 对应的专家还不知道秘密，就将 $v$ 放入队列中以待后续的搜索。当广度优先搜索完成后，我们就将所有在当前时间知道了秘密的专家进行了更新。

最后我们只需要遍历数组 $\textit{secret}$，将元素值为 $\textit{True}$ 的下标加入答案即可。

**细节**

上述问题本质上是「静态连通性问题」，因此同样可以使用深度优先搜索或者并查集解决，这里不再赘述。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findAllPeople(int n, vector<vector<int>>& meetings, int firstPerson) {
        int m = meetings.size();
        sort(meetings.begin(), meetings.end(), [&](const auto& x, const auto& y) {
            return x[2] < y[2];
        });

        vector<int> secret(n);
        secret[0] = secret[firstPerson] = true;

        unordered_set<int> vertices;
        unordered_map<int, vector<int>> edges;

        for (int i = 0; i < m;) {
            // meetings[i .. j] 为同一时间
            int j = i;
            while (j + 1 < m && meetings[j + 1][2] == meetings[i][2]) {
                ++j;
            }

            vertices.clear();
            edges.clear();
            for (int k = i; k <= j; ++k) {
                int x = meetings[k][0], y = meetings[k][1];
                vertices.insert(x);
                vertices.insert(y);
                edges[x].push_back(y);
                edges[y].push_back(x);
            }
            
            queue<int> q;
            for (int u: vertices) {
                if (secret[u]) {
                    q.push(u);
                }
            }
            while (!q.empty()) {
                int u = q.front();
                q.pop();
                for (int v: edges[u]) {
                    if (!secret[v]) {
                        secret[v] = true;
                        q.push(v);
                    }
                }
            }

            i = j + 1;
        }
        
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            if (secret[i]) {
                ans.push_back(i);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findAllPeople(self, n: int, meetings: List[List[int]], firstPerson: int) -> List[int]:
        m = len(meetings)
        meetings.sort(key=lambda x: x[2])

        secret = [False] * n
        secret[0] = secret[firstPerson] = True

        i = 0
        while i < m:
            # meetings[i .. j] 为同一时间
            j = i
            while j + 1 < m and meetings[j + 1][2] == meetings[i][2]:
                j += 1

            vertices = set()
            edges = defaultdict(list)
            for k in range(i, j + 1):
                x, y = meetings[k][0], meetings[k][1]
                vertices.update([x, y])
                edges[x].append(y)
                edges[y].append(x)
            
            q = deque([u for u in vertices if secret[u]])
            while q:
                u = q.popleft()
                for v in edges[u]:
                    if not secret[v]:
                        secret[v] = True
                        q.append(v)
            
            i = j + 1
        
        ans = [i for i in range(n) if secret[i]]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(m \log m + n)$。

    - 排序需要的时间为 $O(m \log m)$；
    
    - 在所有的广度优先搜索中，数组 $\textit{meetings}$ 的每一个出现的节点（如果出现多次就计入多次）被访问的次数不超过 $1$ 次，总时间复杂度为 $O(m)$；

    - 统计答案需要的时间为 $O(n)$。

- 空间复杂度：$O(n + m)$，记为广度优先搜索需要的空间。这里不计算返回值数组 $\textit{ans}$ 需要的空间。