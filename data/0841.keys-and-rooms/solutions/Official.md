#### 前言

当 $x$ 号房间中有 $y$ 号房间的钥匙时，我们就可以从 $x$ 号房间去往 $y$ 号房间。如果我们将这 $n$ 个房间看成有向图中的 $n$ 个节点，那么上述关系就可以看作是图中的 $x$ 号点到 $y$ 号点的一条有向边。

这样一来，问题就变成了给定一张有向图，询问从 $0$ 号节点出发是否能够到达所有的节点。

#### 方法一：深度优先搜索

**思路及解法**

我们可以使用深度优先搜索的方式遍历整张图，统计可以到达的节点个数，并利用数组 $\textit{vis}$ 标记当前节点是否访问过，以防止重复访问。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> vis;
    int num;

    void dfs(vector<vector<int>>& rooms, int x) {
        vis[x] = true;
        num++;
        for (auto& it : rooms[x]) {
            if (!vis[it]) {
                dfs(rooms, it);
            }
        }
    }

    bool canVisitAllRooms(vector<vector<int>>& rooms) {
        int n = rooms.size();
        num = 0;
        vis.resize(n);
        dfs(rooms, 0);
        return num == n;
    }
};
```

```Java [sol1-Java]
class Solution {
    boolean[] vis;
    int num;

    public boolean canVisitAllRooms(List<List<Integer>> rooms) {
        int n = rooms.size();
        num = 0;
        vis = new boolean[n];
        dfs(rooms, 0);
        return num == n;
    }

    public void dfs(List<List<Integer>> rooms, int x) {
        vis[x] = true;
        num++;
        for (int it : rooms.get(x)) {
            if (!vis[it]) {
                dfs(rooms, it);
            }
        }
    }
}
```

```C [sol1-C]
int num;

void dfs(int** rooms, int* roomsColSize, int* vis, int x) {
    vis[x] = true;
    num++;
    for (int i = 0; i < roomsColSize[x]; i++) {
        if (!vis[rooms[x][i]]) {
            dfs(rooms, roomsColSize, vis, rooms[x][i]);
        }
    }
}

bool canVisitAllRooms(int** rooms, int roomsSize, int* roomsColSize) {
    int vis[roomsSize];
    memset(vis, 0, sizeof(vis));
    num = 0;
    dfs(rooms, roomsColSize, vis, 0);
    return num == roomsSize;
}
```

```Python [sol1-Python3]
class Solution:
    def canVisitAllRooms(self, rooms: List[List[int]]) -> bool:
        def dfs(x: int):
            vis.add(x)
            nonlocal num
            num += 1
            for it in rooms[x]:
                if it not in vis:
                    dfs(it)
        
        n = len(rooms)
        num = 0
        vis = set()
        dfs(0)
        return num == n
```

```golang [sol1-Golang]
var (
    num int
    vis []bool
)

func canVisitAllRooms(rooms [][]int) bool {
    n := len(rooms)
    num = 0
    vis = make([]bool, n)
    dfs(rooms, 0)
    return num == n
}

func dfs(rooms [][]int, x int) {
    vis[x] = true
    num++
    for _, it := range rooms[x] {
        if !vis[it] {
            dfs(rooms, it)
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是房间的数量，$m$ 是所有房间中的钥匙数量的总数。

- 空间复杂度：$O(n)$，其中 $n$ 是房间的数量。主要为栈空间的开销。

#### 方法二：广度优先搜索

**思路及解法**

我们也可以使用广度优先搜索的方式遍历整张图，统计可以到达的节点个数，并利用数组 $\textit{vis}$ 标记当前节点是否访问过，以防止重复访问。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool canVisitAllRooms(vector<vector<int>>& rooms) {
        int n = rooms.size(), num = 0;
        vector<int> vis(n);
        queue<int> que;
        vis[0] = true;
        que.emplace(0);
        while (!que.empty()) {
            int x = que.front();
            que.pop();
            num++;
            for (auto& it : rooms[x]) {
                if (!vis[it]) {
                    vis[it] = true;
                    que.emplace(it);
                }
            }
        }
        return num == n;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean canVisitAllRooms(List<List<Integer>> rooms) {
        int n = rooms.size(), num = 0;
        boolean[] vis = new boolean[n];
        Queue<Integer> que = new LinkedList<Integer>();
        vis[0] = true;
        que.offer(0);
        while (!que.isEmpty()) {
            int x = que.poll();
            num++;
            for (int it : rooms.get(x)) {
                if (!vis[it]) {
                    vis[it] = true;
                    que.offer(it);
                }
            }
        }
        return num == n;
    }
}
```

```C [sol2-C]
bool canVisitAllRooms(int** rooms, int roomsSize, int* roomsColSize) {
    int vis[roomsSize], que[roomsSize];
    memset(vis, 0, sizeof(vis));
    int left = 0, right = 1, num = 0;
    vis[0] = true;
    que[0] = 0;
    while (left < right) {
        int x = que[left++];
        num++;
        for (int i = 0; i < roomsColSize[x]; i++) {
            if (!vis[rooms[x][i]]) {
                vis[rooms[x][i]] = true;
                que[right++] = rooms[x][i];
            }
        }
    }
    return num == roomsSize;
}
```

```Python [sol2-Python3]
class Solution:
    def canVisitAllRooms(self, rooms: List[List[int]]) -> bool:
        n = len(rooms)
        num = 0
        vis = {0}
        que = collections.deque([0])

        while que:
            x = que.popleft()
            num += 1
            for it in rooms[x]:
                if it not in vis:
                    vis.add(it)
                    que.append(it)
        
        return num == n
```

```golang [sol2-Golang]
func canVisitAllRooms(rooms [][]int) bool {
    n := len(rooms)
    num := 0
    vis := make([]bool, n)
    queue := []int{}
    vis[0] = true
    queue = append(queue, 0)
    for i := 0; i < len(queue); i++ {
        x := queue[i]
        num++
        for _, it := range rooms[x] {
            if !vis[it] {
                vis[it] = true
                queue = append(queue, it)
            }
        }
    }
    return num == n
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是房间的数量，$m$ 是所有房间中的钥匙数量的总数。

- 空间复杂度：$O(n)$，其中 $n$ 是房间的数量。主要为队列的开销。