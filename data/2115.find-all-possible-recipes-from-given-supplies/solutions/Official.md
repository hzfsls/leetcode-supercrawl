## [2115.从给定原材料中找到所有可以做出的菜 中文官方题解](https://leetcode.cn/problems/find-all-possible-recipes-from-given-supplies/solutions/100000/cong-gei-ding-yuan-cai-liao-zhong-zhao-d-d02i)

#### 方法一：拓扑排序

**思路与算法**

我们把每一种原材料（菜也算一种原材料）看成图上的一个节点，如果某一道菜需要一种原材料，就添加一条从原材料到菜的有向边。

可以发现，如果图上的一个节点的入度为 $0$（即不存在以该节点为终点的边），那么该节点对应的原材料是可以直接使用的。特别地，如果该节点对应的原材料是一道菜，那么我们就可以做出这道菜。在这之后，我们将以该节点本身和以该节点为起点的边全部删除，这样就可能会有节点的入度变为 $0$，我们就可以不断重复这一过程，直到图中不存在节点，或所有剩余节点的入度均不为 $0$。

上述过程实际上就是使用广度优先搜索进行拓扑排序的过程。

**代码**


```C++ [sol1-C++]
class Solution {
public:
    vector<string> findAllRecipes(vector<string>& recipes, vector<vector<string>>& ingredients, vector<string>& supplies) {
        int n = recipes.size();
        // 图
        unordered_map<string, vector<string>> depend;
        // 入度统计
        unordered_map<string, int> cnt;
        for (int i = 0; i < n; ++i) {
            for (const string& ing: ingredients[i]) {
                depend[ing].push_back(recipes[i]);
            }
            cnt[recipes[i]] = ingredients[i].size();
        }
        
        vector<string> ans;
        queue<string> q;
        // 把初始的原材料放入队列
        for (const string& sup: supplies) {
            q.push(sup);
        }
        // 拓扑排序
        while (!q.empty()) {
            string cur = q.front();
            q.pop();
            if (depend.count(cur)) {
                for (const string& rec: depend[cur]) {
                    --cnt[rec];
                    // 如果入度变为 0，说明可以做出这道菜
                    if (cnt[rec] == 0) {
                        ans.push_back(rec);
                        q.push(rec);
                    }
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findAllRecipes(self, recipes: List[str], ingredients: List[List[str]], supplies: List[str]) -> List[str]:
        n = len(recipes)
        # 图
        depend = defaultdict(list)
        # 入度统计
        cnt = Counter()
        for i in range(n):
            for ing in ingredients[i]:
                depend[ing].append(recipes[i])
            cnt[recipes[i]] = len(ingredients[i])
        
        ans = list()
        # 把初始的原材料放入队列
        q = deque(supplies)
        
        # 拓扑排序
        while q:
            cur = q.popleft()
            if cur in depend:
                for rec in depend[cur]:
                    cnt[rec] -= 1
                    # 如果入度变为 0，说明可以做出这道菜
                    if cnt[rec] == 0:
                        ans.append(rec)
                        q.append(rec)
        return ans

```

**复杂度分析**

- 时间复杂度：$O(dn + m)$，其中 $m$ 是数组 $\textit{supplies}$ 的长度，$d$ 是数组 $\textit{recipe}$ 中每一个元素（数组）的最大长度，并且我们把所有字符串的长度视为常数。图中会有 $n + m$ 个节点，并且会有不超过 $dn$ 条边，因此建立图以及拓扑排序的时间复杂度为 $O(n + m + dn) = O(dn + m)$。

- 空间复杂度：$O(dn + m)$，即为存储图需要的空间。