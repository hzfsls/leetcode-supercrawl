## [2076.处理含限制条件的好友请求 中文官方题解](https://leetcode.cn/problems/process-restricted-friend-requests/solutions/100000/chu-li-han-xian-zhi-tiao-jian-de-hao-you-jj2q)
#### 方法一：并查集

**思路与算法**

我们可以使用并查集维护朋友关系。

我们依次处理每一条好友请求。对于请求 $[x_i, y_i]$，记 $x_i$ 和 $y_i$ 在并查集中的代表元素为 $x$ 和 $y$，那么：

- 如果 $x = y$，那么它们 $x_i$ 和 $y_i$ 在之前已经是朋友了，这条好友请求也一定会成功；

- 如果 $x \neq y$，那么我们需要判断这条好友请求是否会违反规则，因此还需要枚举所有的限制。

    对于限制 $[u_j, v_j]$，记 $u_j$ 和 $v_j$ 在并查集中的代表元素为 $u$ 和 $v$。在当前好友请求前，一定有 $u \neq v$，并且我们希望如果当前好友请求成功，$u \neq v$ 仍然成立，所以我们不能将 **$u$ 和 $v$ 所在的连通分量**合并起来。由于当前好友请求会合并 $x$ 和 $y$ 所在的连通分量，并且 $x, y, u, v$ 均为对应连通分量的代表元素，因此 $(x, y) = (u, v)$ 以及 $(y, x) = (v, u)$ 二者均不能成立，否则合并 $x$ 和 $y$ 所在的连通分量即为合并 $u$ 和 $v$ 所在的连通分量。
    
    如果所有的限制都满足，那么这条好友请求成功，否则失败。

对于每一条成功的好友请求，我们需要在并查集中将对应的连通分量进行合并。

**代码**

```C++ [sol1-C++]
// 并查集模板
class UnionFind {
public:
    vector<int> parent;
    vector<int> size;
    int n;
    // 当前连通分量数目
    int setCount;
    
public:
    UnionFind(int _n): n(_n), setCount(_n), parent(_n), size(_n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int findset(int x) {
        return parent[x] == x ? x : parent[x] = findset(parent[x]);
    }
    
    bool unite(int x, int y) {
        x = findset(x);
        y = findset(y);
        if (x == y) {
            return false;
        }
        if (size[x] < size[y]) {
            swap(x, y);
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
        return true;
    }
    
    bool connected(int x, int y) {
        x = findset(x);
        y = findset(y);
        return x == y;
    }
};

class Solution {
public:
    vector<bool> friendRequests(int n, vector<vector<int>>& restrictions, vector<vector<int>>& requests) {
        UnionFind uf(n);
        vector<bool> ans;
        for (const auto& req: requests) {
            int x = uf.findset(req[0]), y = uf.findset(req[1]);
            if (x != y) {
                bool check = true;
                for (const auto& res: restrictions) {
                    int u = uf.findset(res[0]), v = uf.findset(res[1]);
                    if ((x == u && y == v) || (x == v && y == u)) {
                        check = false;
                        break;
                    }
                }
                if (check) {
                    ans.push_back(true);
                    uf.unite(x, y);
                }
                else {
                    ans.push_back(false);
                }
            }
            else {
                ans.push_back(true);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
# 并查集模板
class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.size = [1] * n
        self.n = n
        # 当前连通分量数目
        self.setCount = n
    
    def findset(self, x: int) -> int:
        if self.parent[x] == x:
            return x
        self.parent[x] = self.findset(self.parent[x])
        return self.parent[x]
    
    def unite(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        if x == y:
            return False
        if self.size[x] < self.size[y]:
            x, y = y, x
        self.parent[y] = x
        self.size[x] += self.size[y]
        self.setCount -= 1
        return True
    
    def connected(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        return x == y

class Solution:
    def friendRequests(self, n: int, restrictions: List[List[int]], requests: List[List[int]]) -> List[bool]:
        uf = UnionFind(n)
        ans = list()

        for req in requests:
            x, y = uf.findset(req[0]), uf.findset(req[1])
            if x != y:
                check = True
                for res in restrictions:
                    u, v = uf.findset(res[0]), uf.findset(res[1])
                    if (x == u and y == v) or (x == v and y == u):
                        check = False
                        break
                if check:
                    ans.append(True)
                    uf.unite(x, y)
                else:
                    ans.append(False)
            else:
                ans.append(True)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn \cdot \alpha(n))$，其中 $m$ 是数组 $\textit{restrictions}$ 的长度，$\alpha(\cdot)$ 是反阿克曼函数，表示在路径压缩和按秩合并优化下的并查集的单次操作时间复杂度。

- 空间复杂度：$O(n)$，即为并查集需要使用的空间。