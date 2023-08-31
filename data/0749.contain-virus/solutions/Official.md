## [749.隔离病毒 中文官方题解](https://leetcode.cn/problems/contain-virus/solutions/100000/ge-chi-bing-du-by-leetcode-solution-vn9m)

#### 方法一：广度优先搜索

**思路与算法**

本题只需要根据题意进行模拟即可，但细节较多，需要仔细编写代码。

我们首先可以对矩阵 $\textit{isInfected}$ 进行广度优先搜索，具体地，当我们遍历到 $\textit{isInfected}$ 中的一个 $1$ 时，就从这个 $1$ 对应的位置开始进行广度优先搜索，这样就可以得到连续的一块被病毒感染的区域。

在搜索的过程中，如果当前是第 $\textit{idx}~(\textit{idx} \geq 1)$ 块被病毒感染的区域，我们就把这些 $1$ 都赋值成 $-\textit{idx}$，这样就可以防止重复搜索，并且可以和非病毒区域 $0$ 区分开来。同时，由于我们每次需要选择「对未感染区域的威胁最大」的区域设置防火墙，因此我们还需要存储：

- 该区域相邻的未感染区域（即 $0$）的位置和个数；

- 如果需要位该区域设置防火墙，那么需要防火墙的个数。

对于前者，我们在广度优先搜索的过程中，只要在扩展 $1$ 时搜索相邻的 $0$，就可以把这个 $0$ 对应的位置放在一个哈希集合中。这里使用哈希集合的原因是同一个 $0$ 可能会和多个 $1$ 相邻，可以防止重复计算。同时，由于多个 $1$ 可能出现在不同的感染区域中，如果通过修改矩阵 $\textit{isInfected}$ 的形式来标记这些 $0$，会使得代码编写较为麻烦。

对于后者，计算的方法是类似的，在扩展 $1$ 时如果搜索到相邻的 $0$，那么我们就需要在 $1$ 和 $0$ 之间的这条网格边上建一个防火墙。同一个 $0$ 和多个 $1$ 相邻，就需要建立多个防火墙，因此我们只需要使用一个变量在广度优先搜索的过程中计数即可，无需考虑重复的情况。

在广度优先搜索完成后，如果我们没有发现任何感染区域，说明区域内不存在病毒，我们直接返回 $0$ 作为答案。否则，我们需要找到「对未感染区域的威胁最大」的区域，这里只需要找出对应的哈希集合的大小最大的那块区域即可。

在确定了区域（假设是第 $\textit{idx}$ 块区域）后，我们把矩阵中所有的 $-\textit{idx}$ 都变成 $2$，这样可以不影响任何搜索和判断；除此之外的所有负数都恢复成 $1$。此外，所有哈希集合中存储的（除了第 $\textit{idx}$ 块区域对应的以外）所有相邻位置都需要从 $0$ 变成 $1$，表示病毒的传播。

最后，如果我们发现区域一共只有一块，那么这次防火墙建立后，不会再有病毒传播，可以返回答案；否则我们还需要继续重复执行上述的所有步骤。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
public:
    int containVirus(vector<vector<int>>& isInfected) {
        auto pair_hash = [fn = hash<int>()](const pair<int, int>& o) {
            return (fn(o.first) << 16) ^ fn(o.second);
        };

        int m = isInfected.size(), n = isInfected[0].size();
        int ans = 0;
        while (true) {
            vector<unordered_set<pair<int, int>, decltype(pair_hash)>> neighbors;
            vector<int> firewalls;
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] == 1) {
                        queue<pair<int, int>> q;
                        unordered_set<pair<int, int>, decltype(pair_hash)> neighbor(0, pair_hash);
                        int firewall = 0, idx = neighbors.size() + 1;
                        q.emplace(i, j);
                        isInfected[i][j] = -idx;

                        while (!q.empty()) {
                            auto [x, y] = q.front();
                            q.pop();
                            for (int d = 0; d < 4; ++d) {
                                int nx = x + dirs[d][0];
                                int ny = y + dirs[d][1];
                                if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                                    if (isInfected[nx][ny] == 1) {
                                        q.emplace(nx, ny);
                                        isInfected[nx][ny] = -idx;
                                    }
                                    else if (isInfected[nx][ny] == 0) {
                                        ++firewall;
                                        neighbor.emplace(nx, ny);
                                    }
                                }
                            }
                        }
                        neighbors.push_back(move(neighbor));
                        firewalls.push_back(firewall);
                    }
                }
            }
            
            if (neighbors.empty()) {
                break;
            }

            int idx = max_element(neighbors.begin(), neighbors.end(), [](const auto& v0, const auto& v1) { return v0.size() < v1.size(); }) - neighbors.begin();
            ans += firewalls[idx];
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] < 0) {
                        if (isInfected[i][j] != -idx - 1) {
                            isInfected[i][j] = 1;
                        }
                        else {
                            isInfected[i][j] = 2;
                        }
                    }
                }
            }
            for (int i = 0; i < neighbors.size(); ++i) {
                if (i != idx) {
                    for (const auto& [x, y]: neighbors[i]) {
                        isInfected[x][y] = 1;
                    }
                }
            }
            if (neighbors.size() == 1) {
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int containVirus(int[][] isInfected) {
        int m = isInfected.length, n = isInfected[0].length;
        int ans = 0;
        while (true) {
            List<Set<Integer>> neighbors = new ArrayList<Set<Integer>>();
            List<Integer> firewalls = new ArrayList<Integer>();
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] == 1) {
                        Queue<int[]> queue = new ArrayDeque<int[]>();
                        queue.offer(new int[]{i, j});
                        Set<Integer> neighbor = new HashSet<Integer>();
                        int firewall = 0, idx = neighbors.size() + 1;
                        isInfected[i][j] = -idx;

                        while (!queue.isEmpty()) {
                            int[] arr = queue.poll();
                            int x = arr[0], y = arr[1];
                            for (int d = 0; d < 4; ++d) {
                                int nx = x + dirs[d][0], ny = y + dirs[d][1];
                                if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                                    if (isInfected[nx][ny] == 1) {
                                        queue.offer(new int[]{nx, ny});
                                        isInfected[nx][ny] = -idx;
                                    } else if (isInfected[nx][ny] == 0) {
                                        ++firewall;
                                        neighbor.add(getHash(nx, ny));
                                    }
                                }
                            }
                        }
                        neighbors.add(neighbor);
                        firewalls.add(firewall);
                    }
                }
            }

            if (neighbors.isEmpty()) {
                break;
            }

            int idx = 0;
            for (int i = 1; i < neighbors.size(); ++i) {
                if (neighbors.get(i).size() > neighbors.get(idx).size()) {
                    idx = i;
                }
            }
            ans += firewalls.get(idx);
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] < 0) {
                        if (isInfected[i][j] != -idx - 1) {
                            isInfected[i][j] = 1;
                        } else {
                            isInfected[i][j] = 2;
                        }
                    }
                }
            }
            for (int i = 0; i < neighbors.size(); ++i) {
                if (i != idx) {
                    for (int val : neighbors.get(i)) {
                        int x = val >> 16, y = val & ((1 << 16) - 1);
                        isInfected[x][y] = 1;
                    }
                }
            }
            if (neighbors.size() == 1) {
                break;
            }
        }
        return ans;
    }

    public int getHash(int x, int y) {
        return (x << 16) ^ y;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int ContainVirus(int[][] isInfected) {
        int m = isInfected.Length, n = isInfected[0].Length;
        int ans = 0;
        while (true) {
            IList<ISet<int>> neighbors = new List<ISet<int>>();
            IList<int> firewalls = new List<int>();
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] == 1) {
                        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
                        queue.Enqueue(new Tuple<int, int>(i, j));
                        ISet<int> neighbor = new HashSet<int>();
                        int firewall = 0, idx = neighbors.Count + 1;
                        isInfected[i][j] = -idx;

                        while (queue.Count > 0) {
                            Tuple<int, int> tuple = queue.Dequeue();
                            int x = tuple.Item1, y = tuple.Item2;
                            for (int d = 0; d < 4; ++d) {
                                int nx = x + dirs[d][0], ny = y + dirs[d][1];
                                if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                                    if (isInfected[nx][ny] == 1) {
                                        queue.Enqueue(new Tuple<int, int>(nx, ny));
                                        isInfected[nx][ny] = -idx;
                                    } else if (isInfected[nx][ny] == 0) {
                                        ++firewall;
                                        neighbor.Add(GetHash(nx, ny));
                                    }
                                }
                            }
                        }
                        neighbors.Add(neighbor);
                        firewalls.Add(firewall);
                    }
                }
            }

            if (neighbors.Count == 0) {
                break;
            }

            int maxIdx = 0;
            for (int i = 1; i < neighbors.Count; ++i) {
                if (neighbors[i].Count > neighbors[maxIdx].Count) {
                    maxIdx = i;
                }
            }
            ans += firewalls[maxIdx];
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (isInfected[i][j] < 0) {
                        if (isInfected[i][j] != -maxIdx - 1) {
                            isInfected[i][j] = 1;
                        } else {
                            isInfected[i][j] = 2;
                        }
                    }
                }
            }
            for (int i = 0; i < neighbors.Count; ++i) {
                if (i != maxIdx) {
                    foreach (int val in neighbors[i]) {
                        int x = val >> 16, y = val & ((1 << 16) - 1);
                        isInfected[x][y] = 1;
                    }
                }
            }
            if (neighbors.Count == 1) {
                break;
            }
        }
        return ans;
    }

    public int GetHash(int x, int y) {
        return (x << 16) ^ y;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def containVirus(self, isInfected: List[List[int]]) -> int:
        dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
        m, n = len(isInfected), len(isInfected[0])
        ans = 0

        while True:
            neighbors, firewalls = list(), list()
            for i in range(m):
                for j in range(n):
                    if isInfected[i][j] == 1:
                        q = deque([(i, j)])
                        neighbor = set()
                        firewall, idx = 0, len(neighbors) + 1
                        isInfected[i][j] = -idx

                        while q:
                            x, y = q.popleft()
                            for d in range(4):
                                nx, ny = x + dirs[d][0], y + dirs[d][1]
                                if 0 <= nx < m and 0 <= ny < n:
                                    if isInfected[nx][ny] == 1:
                                        q.append((nx, ny))
                                        isInfected[nx][ny] = -idx
                                    elif isInfected[nx][ny] == 0:
                                        firewall += 1
                                        neighbor.add((nx, ny))
                        
                        neighbors.append(neighbor)
                        firewalls.append(firewall)
            
            if not neighbors:
                break

            idx = 0
            for i in range(1, len(neighbors)):
                if len(neighbors[i]) > len(neighbors[idx]):
                    idx = i
                
            ans += firewalls[idx]
            for i in range(m):
                for j in range(n):
                    if isInfected[i][j] < 0:
                        if isInfected[i][j] != -idx - 1:
                            isInfected[i][j] = 1
                        else:
                            isInfected[i][j] = 2
            
            for i, neighbor in enumerate(neighbors):
                if i != idx:
                    for x, y in neighbor:
                        isInfected[x][y] = 1
            
            if len(neighbors) == 1:
                break
        
        return ans
```

```C [sol1-C]
#define HASH(x, y) (((x) << 16) ^ (y))

typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

int containVirus(int** isInfected, int isInfectedSize, int* isInfectedColSize) {
    int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int m = isInfectedSize, n = isInfectedColSize[0];
    int ans = 0;
    HashItem **neighbors = (HashItem **)malloc(sizeof(HashItem *) * m * n);
    int *firewalls = (int *)malloc(sizeof(int) * m * n);
    for (int i = 0; i < m * n; i++) {
        neighbors[i] = NULL;
    }
    while (true) {
        int neighborsSize = 0, firewallsSize = 0;
        int *queue = (int *)malloc(sizeof(int) * m * n);          
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (isInfected[i][j] == 1) {                    
                    int head = 0, tail = 0;
                    HashItem *neighbor = NULL;
                    int firewall = 0, idx = neighborsSize + 1;
                    queue[tail++] = i * n + j;
                    isInfected[i][j] = -idx;
                    while (head != tail) {
                        int x = queue[head] / n;
                        int y = queue[head] % n;
                        head++;
                        for (int d = 0; d < 4; ++d) {
                            int nx = x + dirs[d][0];
                            int ny = y + dirs[d][1];
                            if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                                if (isInfected[nx][ny] == 1) {
                                    queue[tail++] = nx * n + ny;
                                    isInfected[nx][ny] = -idx;
                                }
                                else if (isInfected[nx][ny] == 0) {
                                    ++firewall;
                                    HashItem *pEntry = NULL;
                                    int hashkey = HASH(nx, ny);
                                    HASH_FIND_INT(neighbor, &hashkey, pEntry);
                                    if (pEntry == NULL) {
                                        HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
                                        pEntry->key = hashkey;
                                        HASH_ADD_INT(neighbor, key, pEntry); 
                                    }
                                }
                            }
                        }
                    }
                    neighbors[neighborsSize++] = neighbor;
                    firewalls[firewallsSize++] = firewall;
                }
            }
        }
        free(queue);
        if (neighborsSize == 0) {
            break;
        }
        int idx = 0;
        for (int i = 1; i < neighborsSize; i++) {
            if (HASH_COUNT(neighbors[i]) > HASH_COUNT(neighbors[idx])) {
                idx = i;
            }
        }
        ans += firewalls[idx];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (isInfected[i][j] < 0) {
                    if (isInfected[i][j] != -idx - 1) {
                        isInfected[i][j] = 1;
                    }
                    else {
                        isInfected[i][j] = 2;
                    }
                }
            }
        }
        for (int i = 0; i < neighborsSize; ++i) {
            if (i != idx) {
                for (HashItem *pEntry = neighbors[i]; pEntry != NULL; pEntry = pEntry->hh.next) {
                    int x = pEntry->key >> 16, y = pEntry->key & ((1 << 16) - 1);
                    isInfected[x][y] = 1;
                }
            }
        }
        for (int i = 0; i < neighborsSize; i++) {
            HashItem *cur, *tmp;
            HASH_ITER(hh, neighbors[i], cur, tmp) {
                HASH_DEL(neighbors[i], cur);  
                free(cur);             
            }
            neighbors[i] = NULL;
        }
        if (neighborsSize == 1) {
            break;
        }
    }
    free(neighbors);
    free(firewalls);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
var containVirus = function(isInfected) {
    const m = isInfected.length, n = isInfected[0].length;
    let ans = 0;
    while (true) {
        const neighbors = [];
        const firewalls = [];
        for (let i = 0; i < m; ++i) {
            for (let j = 0; j < n; ++j) {
                if (isInfected[i][j] === 1) {
                    const queue = [];
                    queue.push([i, j]);
                    const neighbor = new Set();
                    let firewall = 0, idx = neighbors.length + 1;
                    isInfected[i][j] = -idx;

                    while (queue.length > 0) {
                        const arr = queue.shift();
                        let x = arr[0], y = arr[1];
                        for (let d = 0; d < 4; ++d) {
                            let nx = x + dirs[d][0], ny = y + dirs[d][1];
                            if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                                if (isInfected[nx][ny] === 1) {
                                    queue.push([nx, ny]);
                                    isInfected[nx][ny] = -idx;
                                } else if (isInfected[nx][ny] === 0) {
                                    ++firewall;
                                    neighbor.add(getHash(nx, ny));
                                }
                            }
                        }
                    }
                    neighbors.push(neighbor);
                    firewalls.push(firewall);
                }
            }
        }

        if (neighbors.length === 0) {
            break;
        }

        let idx = 0;
        for (let i = 1; i < neighbors.length; ++i) {
            if (neighbors[i].size > neighbors[idx].size) {
                idx = i;
            }
        }
        ans += firewalls[idx];
        for (let i = 0; i < m; ++i) {
            for (let j = 0; j < n; ++j) {
                if (isInfected[i][j] < 0) {
                    if (isInfected[i][j] !== -idx - 1) {
                        isInfected[i][j] = 1;
                    } else {
                        isInfected[i][j] = 2;
                    }
                }
            }
        }
        for (let i = 0; i < neighbors.length; ++i) {
            if (i !== idx) {
                for (const val of neighbors[i]) {
                    let x = val >> 16, y = val & ((1 << 16) - 1);
                    isInfected[x][y] = 1;
                }
            }
        }
        if (neighbors.length === 1) {
            break;
        }
    }
    return ans;
}

const getHash = (x, y) => {
    return (x << 16) ^ y;
};
```

```go [sol1-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func containVirus(isInfected [][]int) (ans int) {
    m, n := len(isInfected), len(isInfected[0])
    for {
        neighbors := []map[pair]struct{}{}
        firewalls := []int{}
        for i, row := range isInfected {
            for j, infected := range row {
                if infected != 1 {
                    continue
                }
                q := []pair{{i, j}}
                neighbor := map[pair]struct{}{}
                firewall, idx := 0, len(neighbors)+1
                row[j] = -idx
                for len(q) > 0 {
                    p := q[0]
                    q = q[1:]
                    for _, d := range dirs {
                        if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < m && 0 <= y && y < n {
                            if isInfected[x][y] == 1 {
                                q = append(q, pair{x, y})
                                isInfected[x][y] = -idx
                            } else if isInfected[x][y] == 0 {
                                firewall++
                                neighbor[pair{x, y}] = struct{}{}
                            }
                        }
                    }
                }
                neighbors = append(neighbors, neighbor)
                firewalls = append(firewalls, firewall)
            }
        }

        if len(neighbors) == 0 {
            break
        }

        idx := 0
        for i := 1; i < len(neighbors); i++ {
            if len(neighbors[i]) > len(neighbors[idx]) {
                idx = i
            }
        }

        ans += firewalls[idx]
        for _, row := range isInfected {
            for j, v := range row {
                if v < 0 {
                    if v != -idx-1 {
                        row[j] = 1
                    } else {
                        row[j] = 2
                    }
                }
            }
        }

        for i, neighbor := range neighbors {
            if i != idx {
                for p := range neighbor {
                    isInfected[p.x][p.y] = 1
                }
            }
        }

        if len(neighbors) == 1 {
            break
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(mn(m+n))$。每一次广度优先搜索需要的时间为 $O(mn)$，而矩阵中任意两个位置的曼哈顿距离最大值为 $m+n-2$，因此在 $O(m+n)$ 次搜索后，所有还没有被隔离的病毒会连成一个整体。

- 空间复杂度：$O(mn)$，即为广度优先搜索中的队列以及哈希集合需要使用的空间。