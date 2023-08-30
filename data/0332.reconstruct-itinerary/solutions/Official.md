#### 前言

本题和「[753. 破解保险箱](https://leetcode-cn.com/problems/cracking-the-safe/)」类似，是力扣平台上为数不多的求解欧拉回路 / 欧拉通路的题目。读者可以配合着进行练习。

我们化简本题题意：给定一个 $n$ 个点 $m$ 条边的图，要求从指定的顶点出发，经过所有的边恰好一次（可以理解为给定起点的「一笔画」问题），使得路径的字典序最小。

这种「一笔画」问题与欧拉图或者半欧拉图有着紧密的联系，下面给出定义：

- 通过图中所有边恰好一次且行遍所有顶点的通路称为欧拉通路；
- 通过图中所有边恰好一次且行遍所有顶点的回路称为欧拉回路；
- 具有欧拉回路的无向图称为欧拉图；
- 具有欧拉通路但不具有欧拉回路的无向图称为半欧拉图。

因为本题保证至少存在一种合理的路径，也就告诉了我们，这张图是一个欧拉图或者半欧拉图。我们只需要输出这条欧拉通路的路径即可。

> 如果没有保证至少存在一种合理的路径，我们需要判别这张图是否是欧拉图或者半欧拉图，具体地：
>
> - 对于无向图 $G$，$G$ 是欧拉图当且仅当 $G$ 是连通的且没有奇度顶点。
> - 对于无向图 $G$，$G$ 是半欧拉图当且仅当 $G$ 是连通的且 $G$ 中恰有 $0$ 个或 $2$ 个奇度顶点。
> - 对于有向图 $G$，$G$ 是欧拉图当且仅当 $G$ 的所有顶点属于同一个强连通分量且每个顶点的入度和出度相同。
> - 对于有向图 $G$，$G$ 是半欧拉图当且仅当
>   - 如果将 $G$ 中的所有有向边退化为无向边时，那么 $G$ 的所有顶点属于同一个强连通分量；
>   - 最多只有一个顶点的出度与入度差为 $1$；
>   - 最多只有一个顶点的入度与出度差为 $1$；
>   - 所有其他顶点的入度和出度相同。

让我们考虑下面的这张图：

![Graph1](https://assets.leetcode-cn.com/solution-static/332/332_fig1.png){:width="70%"}

我们从起点 $\text{JFK}$ 出发，合法路径有两条：

- $\text{JFK} \to \text{AAA} \to \text{JFK} \to \text{BBB} \to \text{JFK}$

- $\text{JFK} \to \text{BBB} \to \text{JFK} \to \text{AAA} \to \text{JFK}$

既然要求字典序最小，那么我们每次应该贪心地选择当前节点所连的节点中字典序最小的那一个，并将其入栈。最后栈中就保存了我们遍历的顺序。

为了保证我们能够快速找到当前节点所连的节点中字典序最小的那一个，我们可以使用优先队列存储当前节点所连到的点，每次我们 $O(1)$ 地找到最小字典序的节点，并 $O(\log m)$ 地删除它。

然后我们考虑一种特殊情况：

![Graph2](https://assets.leetcode-cn.com/solution-static/332/332_fig2.png){:width="70%"}

当我们先访问 $\text{AAA}$ 时，我们无法回到 $\text{JFK}$，这样我们就无法访问剩余的边了。

也就是说，当我们贪心地选择字典序最小的节点前进时，我们可能先走入「死胡同」，从而导致无法遍历到其他还未访问的边。于是我们希望能够遍历完当前节点所连接的其他节点后再进入「死胡同」。

> 注意对于每一个节点，它只有最多一个「死胡同」分支。依据前言中对于半欧拉图的描述，只有那个入度与出度差为 $1$ 的节点会导致死胡同。

#### 方法一：$\text{Hierholzer}$ 算法

**思路及算法**

$\text{Hierholzer}$ 算法用于在连通图中寻找欧拉路径，其流程如下：

1. 从起点出发，进行深度优先搜索。
   
2. 每次沿着某条边从某个顶点移动到另外一个顶点的时候，都需要删除这条边。
   
3. 如果没有可移动的路径，则将所在节点加入到栈中，并返回。

当我们顺序地考虑该问题时，我们也许很难解决该问题，因为我们无法判断当前节点的哪一个分支是「死胡同」分支。

不妨倒过来思考。我们注意到只有那个入度与出度差为 $1$ 的节点会导致死胡同。而该节点必然是最后一个遍历到的节点。我们可以改变入栈的规则，当我们遍历完一个节点所连的所有节点后，我们才将该节点入栈（即逆序入栈）。

对于当前节点而言，从它的每一个非「死胡同」分支出发进行深度优先搜索，都将会搜回到当前节点。而从它的「死胡同」分支出发进行深度优先搜索将不会搜回到当前节点。也就是说当前节点的死胡同分支将会优先于其他非「死胡同」分支入栈。

这样就能保证我们可以「一笔画」地走完所有边，最终的栈中逆序地保存了「一笔画」的结果。我们只要将栈中的内容反转，即可得到答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    unordered_map<string, priority_queue<string, vector<string>, std::greater<string>>> vec;

    vector<string> stk;

    void dfs(const string& curr) {
        while (vec.count(curr) && vec[curr].size() > 0) {
            string tmp = vec[curr].top();
            vec[curr].pop();
            dfs(move(tmp));
        }
        stk.emplace_back(curr);
    }

    vector<string> findItinerary(vector<vector<string>>& tickets) {
        for (auto& it : tickets) {
            vec[it[0]].emplace(it[1]);
        }
        dfs("JFK");

        reverse(stk.begin(), stk.end());
        return stk;
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<String, PriorityQueue<String>> map = new HashMap<String, PriorityQueue<String>>();
    List<String> itinerary = new LinkedList<String>();

    public List<String> findItinerary(List<List<String>> tickets) {
        for (List<String> ticket : tickets) {
            String src = ticket.get(0), dst = ticket.get(1);
            if (!map.containsKey(src)) {
                map.put(src, new PriorityQueue<String>());
            }
            map.get(src).offer(dst);
        }
        dfs("JFK");
        Collections.reverse(itinerary);
        return itinerary;
    }

    public void dfs(String curr) {
        while (map.containsKey(curr) && map.get(curr).size() > 0) {
            String tmp = map.get(curr).poll();
            dfs(tmp);
        }
        itinerary.add(curr);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findItinerary(self, tickets: List[List[str]]) -> List[str]:
        def dfs(curr: str):
            while vec[curr]:
                tmp = heapq.heappop(vec[curr])
                dfs(tmp)
            stack.append(curr)

        vec = collections.defaultdict(list)
        for depart, arrive in tickets:
            vec[depart].append(arrive)
        for key in vec:
            heapq.heapify(vec[key])
        
        stack = list()
        dfs("JFK")
        return stack[::-1]
```

```C [sol1-C]
char* id2str[26 * 26 * 26];

int str2id(char* a) {
    int ret = 0;
    for (int i = 0; i < 3; i++) {
        ret = ret * 26 + a[i] - 'A';
    }
    return ret;
}

int cmp(const void* _a, const void* _b) {
    int **a = (int**)_a, **b = (int**)_b;
    return (*b)[0] - (*a)[0] ? (*b)[0] - (*a)[0] : (*b)[1] - (*a)[1];
}

int* vec[26 * 26 * 26];
int vec_len[26 * 26 * 26];
int* stk;
int stk_len;

void dfs(int curr) {
    while (vec_len[curr] > 0) {
        int tmp = vec[curr][--vec_len[curr]];
        dfs(tmp);
    }
    stk[stk_len++] = curr;
}

char** findItinerary(char*** tickets, int ticketsSize, int* ticketsColSize, int* returnSize) {
    memset(vec_len, 0, sizeof(vec_len));
    stk = malloc(sizeof(int) * (ticketsSize + 1));
    stk_len = 0;

    int* tickets_tmp[ticketsSize];
    for (int i = 0; i < ticketsSize; i++) {
        tickets_tmp[i] = (int*)malloc(sizeof(int) * 2);
        tickets_tmp[i][0] = str2id(tickets[i][0]);
        tickets_tmp[i][1] = str2id(tickets[i][1]);
        id2str[tickets_tmp[i][0]] = tickets[i][0];
        id2str[tickets_tmp[i][1]] = tickets[i][1];
    }
    qsort(tickets_tmp, ticketsSize, sizeof(int*), cmp);

    int add = 0;
    while (add < ticketsSize) {
        int adds = add + 1, start = tickets_tmp[add][0];
        while (adds < ticketsSize && start == tickets_tmp[adds][0]) {
            adds++;
        }
        vec_len[start] = adds - add;
        vec[start] = malloc(sizeof(int) * vec_len[start]);
        for (int i = add; i < adds; i++) {
            vec[start][i - add] = tickets_tmp[i][1];
        }
        add = adds;
    }

    dfs(str2id("JFK"));

    *returnSize = ticketsSize + 1;
    char** ret = malloc(sizeof(char*) * (ticketsSize + 1));
    for (int i = 0; i <= ticketsSize; i++) {
        ret[ticketsSize - i] = id2str[stk[i]];
    }
    return ret;
}
```

```golang [sol1-Golang]
func findItinerary(tickets [][]string) []string {
    var (
        m  = map[string][]string{}
        res []string
    )
    
    for _, ticket := range tickets {
        src, dst := ticket[0], ticket[1]
        m[src] = append(m[src], dst)
    }
    for key := range m {
        sort.Strings(m[key])
    }

    var dfs func(curr string)
    dfs = func(curr string) {
        for {
            if v, ok := m[curr]; !ok || len(v) == 0 {
                break
            }
            tmp := m[curr][0]
            m[curr] = m[curr][1:]
            dfs(tmp)
        }
        res = append(res, curr)
    }

    dfs("JFK")
    for i := 0; i < len(res)/2; i++ {
        res[i], res[len(res) - 1 - i] = res[len(res) - 1 - i], res[i]
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(m \log m)$，其中 $m$ 是边的数量。对于每一条边我们需要 $O(\log m)$ 地删除它，最终的答案序列长度为 $m+1$，而与 $n$ 无关。
  
- 空间复杂度：$O(m)$，其中 $m$ 是边的数量。我们需要存储每一条边。