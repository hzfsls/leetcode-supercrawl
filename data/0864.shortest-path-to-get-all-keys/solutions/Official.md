## [864.获取所有钥匙的最短路径 中文官方题解](https://leetcode.cn/problems/shortest-path-to-get-all-keys/solutions/100000/huo-qu-suo-you-yao-chi-de-zui-duan-lu-ji-uu5m)

#### 方法一：状态压缩 + 广度优先搜索

**思路与算法**

给定一个只包含空房间、墙、起点和终点的二维网格，我们可以使用广度优先搜索的方法求出起点到终点的最短路径。这是因为在最短路径上，我们最多只会经过每个房间一次。因此从起点开始，使用队列进行广度优先搜索，当第一个搜索到某个节点的时候，我们就可以得到从起点到该节点正确的最短路。

如果加上了钥匙和锁，我们应该如何解决问题呢？类似地，在最短路径上也不可能存在如下的情况：我们经过了某个房间两次，并且这两次我们拥有钥匙的情况是完全一致的。

因此，我们可以用一个三元组 $(x, y, \textit{mask})$ 表示当前的状态，其中 $(x, y)$ 表示当前所处的位置，$\textit{mask}$ 是一个二进制数，长度恰好等于网格中钥匙的数目，$\textit{mask}$ 的第 $i$ 个二进制位为 $1$，当且仅当我们已经获得了网格中的第 $i$ 把钥匙。

这样一来，我们就可以使用上述的状态进行广度优先搜索。初始时，我们把 $(\textit{sx}, \textit{sy}, 0)$ 加入队列，其中 $(\textit{sx}, \textit{sy})$ 为起点。在搜索的过程中，我们可以向上下左右四个方向进行扩展：

- 如果对应方向是空房间，那么 $\textit{mask}$ 的值不变；

- 如果对应方向是第 $i$ 把钥匙，那么将 $\textit{mask}$ 的第 $i$ 位置为 $1$；

- 如果对应方向是第 $i$ 把锁，那么只有在 $\textit{mask}$ 的第 $i$ 位为 $1$ 时，才可以通过。

当我们搜索到一个 $\textit{mask}$ 每一个二进制都为 $1$ 的状态时，说明获取了所有钥匙，此时就可以返回最短路作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int shortestPathAllKeys(vector<string>& grid) {
        int m = grid.size(), n = grid[0].size();
        int sx = 0, sy = 0;
        unordered_map<char, int> key_to_idx;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == '@') {
                    sx = i;
                    sy = j;
                }
                else if (islower(grid[i][j])) {
                    if (!key_to_idx.count(grid[i][j])) {
                        int idx = key_to_idx.size();
                        key_to_idx[grid[i][j]] = idx;
                    }
                }
            }
        }

        queue<tuple<int, int, int>> q;
        vector<vector<vector<int>>> dist(m, vector<vector<int>>(n, vector<int>(1 << key_to_idx.size(), -1)));
        q.emplace(sx, sy, 0);
        dist[sx][sy][0] = 0;
        while (!q.empty()) {
            auto [x, y, mask] = q.front();
            q.pop();
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] != '#') {
                    if (grid[nx][ny] == '.' || grid[nx][ny] == '@') {
                        if (dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            q.emplace(nx, ny, mask);
                        }
                    }
                    else if (islower(grid[nx][ny])) {
                        int idx = key_to_idx[grid[nx][ny]];
                        if (dist[nx][ny][mask | (1 << idx)] == -1) {
                            dist[nx][ny][mask | (1 << idx)] = dist[x][y][mask] + 1;
                            if ((mask | (1 << idx)) == (1 << key_to_idx.size()) - 1) {
                                return dist[nx][ny][mask | (1 << idx)];
                            }
                            q.emplace(nx, ny, mask | (1 << idx));
                        }
                    }
                    else {
                        int idx = key_to_idx[tolower(grid[nx][ny])];
                        if ((mask & (1 << idx)) && dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            q.emplace(nx, ny, mask);
                        }
                    }
                }
            }
        }
        return -1;
    }

private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
};
```

```Java [sol1-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int shortestPathAllKeys(String[] grid) {
        int m = grid.length, n = grid[0].length();
        int sx = 0, sy = 0;
        Map<Character, Integer> keyToIndex = new HashMap<Character, Integer>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i].charAt(j) == '@') {
                    sx = i;
                    sy = j;
                } else if (Character.isLowerCase(grid[i].charAt(j))) {
                    if (!keyToIndex.containsKey(grid[i].charAt(j))) {
                        int idx = keyToIndex.size();
                        keyToIndex.put(grid[i].charAt(j), idx);
                    }
                }
            }
        }

        Queue<int[]> queue = new ArrayDeque<int[]>();
        int[][][] dist = new int[m][n][1 << keyToIndex.size()];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                Arrays.fill(dist[i][j], -1);
            }
        }
        queue.offer(new int[]{sx, sy, 0});
        dist[sx][sy][0] = 0;
        while (!queue.isEmpty()) {
            int[] arr = queue.poll();
            int x = arr[0], y = arr[1], mask = arr[2];
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx].charAt(ny) != '#') {
                    if (grid[nx].charAt(ny) == '.' || grid[nx].charAt(ny) == '@') {
                        if (dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            queue.offer(new int[]{nx, ny, mask});
                        }
                    } else if (Character.isLowerCase(grid[nx].charAt(ny))) {
                        int idx = keyToIndex.get(grid[nx].charAt(ny));
                        if (dist[nx][ny][mask | (1 << idx)] == -1) {
                            dist[nx][ny][mask | (1 << idx)] = dist[x][y][mask] + 1;
                            if ((mask | (1 << idx)) == (1 << keyToIndex.size()) - 1) {
                                return dist[nx][ny][mask | (1 << idx)];
                            }
                            queue.offer(new int[]{nx, ny, mask | (1 << idx)});
                        }
                    } else {
                        int idx = keyToIndex.get(Character.toLowerCase(grid[nx].charAt(ny)));
                        if ((mask & (1 << idx)) != 0 && dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            queue.offer(new int[]{nx, ny, mask});
                        }
                    }
                }
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int ShortestPathAllKeys(string[] grid) {
        int m = grid.Length, n = grid[0].Length;
        int sx = 0, sy = 0;
        IDictionary<char, int> keyToIndex = new Dictionary<char, int>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == '@') {
                    sx = i;
                    sy = j;
                } else if (char.IsLower(grid[i][j])) {
                    if (!keyToIndex.ContainsKey(grid[i][j])) {
                        int idx = keyToIndex.Count;
                        keyToIndex.Add(grid[i][j], idx);
                    }
                }
            }
        }

        Queue<Tuple<int, int, int>> queue = new Queue<Tuple<int, int, int>>();
        int[][][] dist = new int[m][][];
        for (int i = 0; i < m; ++i) {
            dist[i] = new int[n][];
            for (int j = 0; j < n; ++j) {
                dist[i][j] = new int[1 << keyToIndex.Count];
                Array.Fill(dist[i][j], -1);
            }
        }
        queue.Enqueue(new Tuple<int, int, int>(sx, sy, 0));
        dist[sx][sy][0] = 0;
        while (queue.Count > 0) {
            Tuple<int, int, int> tuple = queue.Dequeue();
            int x = tuple.Item1, y = tuple.Item2, mask = tuple.Item3;
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] != '#') {
                    if (grid[nx][ny] == '.' || grid[nx][ny] == '@') {
                        if (dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            queue.Enqueue(new Tuple<int, int, int>(nx, ny, mask));
                        }
                    } else if (char.IsLower(grid[nx][ny])) {
                        int idx = keyToIndex[grid[nx][ny]];
                        if (dist[nx][ny][mask | (1 << idx)] == -1) {
                            dist[nx][ny][mask | (1 << idx)] = dist[x][y][mask] + 1;
                            if ((mask | (1 << idx)) == (1 << keyToIndex.Count) - 1) {
                                return dist[nx][ny][mask | (1 << idx)];
                            }
                            queue.Enqueue(new Tuple<int, int, int>(nx, ny, mask | (1 << idx)));
                        }
                    } else {
                        int idx = keyToIndex[char.ToLower(grid[nx][ny])];
                        if ((mask & (1 << idx)) != 0 && dist[nx][ny][mask] == -1) {
                            dist[nx][ny][mask] = dist[x][y][mask] + 1;
                            queue.Enqueue(new Tuple<int, int, int>(nx, ny, mask));
                        }
                    }
                }
            }
        }
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def shortestPathAllKeys(self, grid: List[str]) -> int:
        dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

        m, n = len(grid), len(grid[0])
        sx = sy = 0
        key_to_idx = dict()
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == "@":
                    sx, sy = i, j
                elif grid[i][j].islower():
                    if grid[i][j] not in key_to_idx:
                        idx = len(key_to_idx)
                        key_to_idx[grid[i][j]] = idx

        q = deque([(sx, sy, 0)])
        dist = dict()
        dist[(sx, sy, 0)] = 0
        while q:
            x, y, mask = q.popleft()
            for dx, dy in dirs:
                nx, ny = x + dx, y + dy
                if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] != "#":
                    if grid[nx][ny] == "." or grid[nx][ny] == "@":
                        if (nx, ny, mask) not in dist:
                            dist[(nx, ny, mask)] = dist[(x, y, mask)] + 1
                            q.append((nx, ny, mask))
                    elif grid[nx][ny].islower():
                        idx = key_to_idx[grid[nx][ny]]
                        if (nx, ny, mask | (1 << idx)) not in dist:
                            dist[(nx, ny, mask | (1 << idx))] = dist[(x, y, mask)] + 1
                            if (mask | (1 << idx)) == (1 << len(key_to_idx)) - 1:
                                return dist[(nx, ny, mask | (1 << idx))]
                            q.append((nx, ny, mask | (1 << idx)))
                    else:
                        idx = key_to_idx[grid[nx][ny].lower()]
                        if (mask & (1 << idx)) and (nx, ny, mask) not in dist:
                            dist[(nx, ny, mask)] = dist[(x, y, mask)] + 1
                            q.append((nx, ny, mask))
        return -1
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

typedef struct Tuple {
    int x;
    int y;
    int mask;
} Tuple;

Tuple *creatTuple(int x, int y, int mask) {
    Tuple *obj = (Tuple *)malloc(sizeof(Tuple));
    obj->x = x;
    obj->y = y;
    obj->mask = mask;
    return obj;
}

int shortestPathAllKeys(char ** grid, int gridSize){
    int m = gridSize, n = strlen(grid[0]);
    int sx = 0, sy = 0;
    HashItem *key_to_idx = NULL;
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (grid[i][j] == '@') {
                sx = i;
                sy = j;
            }
            else if (islower(grid[i][j])) {
                if (!hashFindItem(&key_to_idx, grid[i][j])) {
                    int idx = HASH_COUNT(key_to_idx);
                    hashAddItem(&key_to_idx, grid[i][j], idx);
                }
            }
        }
    }

    int keySize = HASH_COUNT(key_to_idx);
    int dist[m][n][1 << keySize];
    Tuple *queue[m * n * (1 << keySize)];
    memset(dist, -1, sizeof(dist));
    int head = 0, tail = 0;
    queue[tail++] = creatTuple(sx, sy, 0); 
    dist[sx][sy][0] = 0;
    while (head != tail) {
        int x = queue[head]->x;
        int y = queue[head]->y;
        int mask = queue[head]->mask;
        free(queue[head]);
        head++;
        for (int i = 0; i < 4; ++i) {
            int nx = x + dirs[i][0];
            int ny = y + dirs[i][1];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] != '#') {
                if (grid[nx][ny] == '.' || grid[nx][ny] == '@') {
                    if (dist[nx][ny][mask] == -1) {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1;
                        queue[tail++] = creatTuple(nx, ny, mask);
                    }
                }
                else if (islower(grid[nx][ny])) {
                    int idx = hashGetItem(&key_to_idx, grid[nx][ny], -1);
                    if (dist[nx][ny][mask | (1 << idx)] == -1) {
                        dist[nx][ny][mask | (1 << idx)] = dist[x][y][mask] + 1;
                        if ((mask | (1 << idx)) == (1 << keySize) - 1) {
                            hashFree(&key_to_idx);
                            return dist[nx][ny][mask | (1 << idx)];
                        }
                        queue[tail++] = creatTuple(nx, ny, mask | (1 << idx));
                    }
                }
                else {
                    int idx = hashGetItem(&key_to_idx, tolower(grid[nx][ny]), -1);
                    if ((mask & (1 << idx)) && dist[nx][ny][mask] == -1) {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1;
                        queue[tail++] = creatTuple(nx, ny, mask);
                    }
                }
            }
        }
    }
    hashFree(&key_to_idx);
    return -1;
}
```

```JavaScript [sol1-JavaScript]
const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
var shortestPathAllKeys = function(grid) {
    const m = grid.length, n = grid[0].length;
    let sx = 0, sy = 0;
    const keyToIndex = new Map();
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (grid[i][j] === '@') {
                sx = i;
                sy = j;
            } else if ('a' <= grid[i][j] && grid[i][j] <= 'z') {
                if (!keyToIndex.has(grid[i][j])) {
                    const idx = keyToIndex.size;
                    keyToIndex.set(grid[i][j], idx);
                }
            }
        }
    }

    const queue = [];
    const dist = new Array(m).fill(0).map(() => new Array(n).fill(0).map(() => new Array(1 << keyToIndex.size).fill(-1)));
    queue.push([sx, sy, 0]);
    dist[sx][sy][0] = 0;
    while (queue.length) {
        const arr = queue.shift();
        let x = arr[0], y = arr[1], mask = arr[2];
        for (let i = 0; i < 4; ++i) {
            let nx = x + dirs[i][0];
            let ny = y + dirs[i][1];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] !== '#') {
                if (grid[nx][ny] === '.' || grid[nx][ny] === '@') {
                    if (dist[nx][ny][mask] === -1) {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1;
                        queue.push([nx, ny, mask]);
                    }
                } else if ('a' <= grid[nx][ny] && grid[nx][ny] <= 'z') {
                    const idx = keyToIndex.get(grid[nx][ny]);
                    if (dist[nx][ny][mask | (1 << idx)] === -1) {
                        dist[nx][ny][mask | (1 << idx)] = dist[x][y][mask] + 1;
                        if ((mask | (1 << idx)) === (1 << keyToIndex.size) - 1) {
                            return dist[nx][ny][mask | (1 << idx)];
                        }
                        queue.push([nx, ny, mask | (1 << idx)]);
                    }
                } else {
                    const idx = keyToIndex.get(grid[nx][ny].toLowerCase());
                    if ((mask & (1 << idx)) !== 0 && dist[nx][ny][mask] === -1) {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1;
                        queue.push([nx, ny, mask]);
                    }
                }
            }
        }
    }
    return -1;
};
```

```go [sol1-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func shortestPathAllKeys(grid []string) int {
    m, n := len(grid), len(grid[0])
    sx, sy := 0, 0
    keyToIdx := map[rune]int{}
    for i, row := range grid {
        for j, c := range row {
            if c == '@' {
                sx, sy = i, j
            } else if unicode.IsLower(c) {
                if _, ok := keyToIdx[c]; !ok {
                    keyToIdx[c] = len(keyToIdx)
                }
            }
        }
    }

    dist := make([][][]int, m)
    for i := range dist {
        dist[i] = make([][]int, n)
        for j := range dist[i] {
            dist[i][j] = make([]int, 1<<len(keyToIdx))
            for k := range dist[i][j] {
                dist[i][j][k] = -1
            }
        }
    }
    dist[sx][sy][0] = 0
    q := [][3]int{{sx, sy, 0}}
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        x, y, mask := p[0], p[1], p[2]
        for _, d := range dirs {
            nx, ny := x+d.x, y+d.y
            if 0 <= nx && nx < m && 0 <= ny && ny < n && grid[nx][ny] != '#' {
                c := rune(grid[nx][ny])
                if c == '.' || c == '@' {
                    if dist[nx][ny][mask] == -1 {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1
                        q = append(q, [3]int{nx, ny, mask})
                    }
                } else if unicode.IsLower(c) {
                    t := mask | 1<<keyToIdx[c]
                    if dist[nx][ny][t] == -1 {
                        dist[nx][ny][t] = dist[x][y][mask] + 1
                        if t == 1<<len(keyToIdx)-1 {
                            return dist[nx][ny][t]
                        }
                        q = append(q, [3]int{nx, ny, t})
                    }
                } else {
                    idx := keyToIdx[unicode.ToLower(c)]
                    if mask>>idx&1 > 0 && dist[nx][ny][mask] == -1 {
                        dist[nx][ny][mask] = dist[x][y][mask] + 1
                        q = append(q, [3]int{nx, ny, mask})
                    }
                }
            }
        }
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(mn \cdot 2^k)$，其中 $m$ 和 $n$ 是网格的行数和列数，$k$ 是网格中钥匙的数量。

- 空间复杂度：$O(mn \cdot 2^k)$。