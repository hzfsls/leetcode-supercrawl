## [752.打开转盘锁 中文官方题解](https://leetcode.cn/problems/open-the-lock/solutions/100000/da-kai-zhuan-pan-suo-by-leetcode-solutio-l0xo)
#### 方法一：广度优先搜索

**思路与算法**

我们可以使用广度优先搜索，找出从初始数字 $0000$ 到解锁数字 $\textit{target}$ 的最小旋转次数。

具体地，我们在一开始将 $(0000, 0)$ 加入队列，并使用该队列进行广度优先搜索。在搜索的过程中，设当前搜索到的数字为 $\textit{status}$，旋转的次数为 $\textit{step}$，我们可以枚举 $\textit{status}$ 通过一次旋转得到的数字。设其中的某个数字为 $\textit{next\_status}$，如果其没有被搜索过，我们就将 $(\textit{next\_status}, \textit{step} + 1)$ 加入队列。如果搜索到了 $\textit{target}$，我们就返回其对应的旋转次数。

为了避免搜索到死亡数字，我们可以使用哈希表存储 $\textit{deadends}$ 中的所有元素，这样在搜索的过程中，我们可以均摊 $O(1)$ 地判断一个数字是否为死亡数字。同时，我们还需要一个哈希表存储所有搜索到的状态，避免重复搜索。

如果搜索完成后，我们仍没有搜索到 $\textit{target}$，说明我们无法解锁，返回 $-1$。

**细节**

本题中需要注意如下两个细节：

- 如果 $\textit{target}$ 就是初始数字 $0000$，那么直接返回答案 $0$；

- 如果初始数字 $0000$ 出现在 $\textit{deadends}$ 中，那么直接返回答案 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int openLock(vector<string>& deadends, string target) {
        if (target == "0000") {
            return 0;
        }

        unordered_set<string> dead(deadends.begin(), deadends.end());
        if (dead.count("0000")) {
            return -1;
        }

        auto num_prev = [](char x) -> char {
            return (x == '0' ? '9' : x - 1);
        };
        auto num_succ = [](char x) -> char {
            return (x == '9' ? '0' : x + 1);
        };

        // 枚举 status 通过一次旋转得到的数字
        auto get = [&](string& status) -> vector<string> {
            vector<string> ret;
            for (int i = 0; i < 4; ++i) {
                char num = status[i];
                status[i] = num_prev(num);
                ret.push_back(status);
                status[i] = num_succ(num);
                ret.push_back(status);
                status[i] = num;
            }
            return ret;
        };

        queue<pair<string, int>> q;
        q.emplace("0000", 0);
        unordered_set<string> seen = {"0000"};

        while (!q.empty()) {
            auto [status, step] = q.front();
            q.pop();
            for (auto&& next_status: get(status)) {
                if (!seen.count(next_status) && !dead.count(next_status)) {
                    if (next_status == target) {
                        return step + 1;
                    }
                    q.emplace(next_status, step + 1);
                    seen.insert(move(next_status));
                }
            }
        }

        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int openLock(String[] deadends, String target) {
        if ("0000".equals(target)) {
            return 0;
        }

        Set<String> dead = new HashSet<String>();
        for (String deadend : deadends) {
            dead.add(deadend);
        }
        if (dead.contains("0000")) {
            return -1;
        }

        int step = 0;
        Queue<String> queue = new LinkedList<String>();
        queue.offer("0000");
        Set<String> seen = new HashSet<String>();
        seen.add("0000");

        while (!queue.isEmpty()) {
            ++step;
            int size = queue.size();
            for (int i = 0; i < size; ++i) {
                String status = queue.poll();
                for (String nextStatus : get(status)) {
                    if (!seen.contains(nextStatus) && !dead.contains(nextStatus)) {
                        if (nextStatus.equals(target)) {
                            return step;
                        }
                        queue.offer(nextStatus);
                        seen.add(nextStatus);
                    }
                }
            }
        }

        return -1;
    }

    public char numPrev(char x) {
        return x == '0' ? '9' : (char) (x - 1);
    }

    public char numSucc(char x) {
        return x == '9' ? '0' : (char) (x + 1);
    }

    // 枚举 status 通过一次旋转得到的数字
    public List<String> get(String status) {
        List<String> ret = new ArrayList<String>();
        char[] array = status.toCharArray();
        for (int i = 0; i < 4; ++i) {
            char num = array[i];
            array[i] = numPrev(num);
            ret.add(new String(array));
            array[i] = numSucc(num);
            ret.add(new String(array));
            array[i] = num;
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int OpenLock(string[] deadends, string target) {
        if ("0000".Equals(target)) {
            return 0;
        }

        ISet<string> dead = new HashSet<string>();
        foreach (string deadend in deadends) {
            dead.Add(deadend);
        }
        if (dead.Contains("0000")) {
            return -1;
        }

        int step = 0;
        Queue<string> queue = new Queue<string>();
        queue.Enqueue("0000");
        ISet<string> seen = new HashSet<string>();
        seen.Add("0000");

        while (queue.Count > 0) {
            ++step;
            int size = queue.Count;
            for (int i = 0; i < size; ++i) {
                string status = queue.Dequeue();
                foreach (string nextStatus in Get(status)) {
                    if (!seen.Contains(nextStatus) && !dead.Contains(nextStatus)) {
                        if (nextStatus.Equals(target)) {
                            return step;
                        }
                        queue.Enqueue(nextStatus);
                        seen.Add(nextStatus);
                    }
                }
            }
        }

        return -1;
    }

    public char NumPrev(char x) {
        return x == '0' ? '9' : (char) (x - 1);
    }

    public char NumSucc(char x) {
        return x == '9' ? '0' : (char) (x + 1);
    }

    // 枚举 status 通过一次旋转得到的数字
    public IList<string> Get(string status) {
        IList<string> ret = new List<string>();
        char[] array = status.ToCharArray();
        for (int i = 0; i < 4; ++i) {
            char num = array[i];
            array[i] = NumPrev(num);
            ret.Add(new string(array));
            array[i] = NumSucc(num);
            ret.Add(new string(array));
            array[i] = num;
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def openLock(self, deadends: List[str], target: str) -> int:
        if target == "0000":
            return 0

        dead = set(deadends)
        if "0000" in dead:
            return -1
        
        def num_prev(x: str) -> str:
            return "9" if x == "0" else str(int(x) - 1)
        
        def num_succ(x: str) -> str:
            return "0" if x == "9" else str(int(x) + 1)
        
        # 枚举 status 通过一次旋转得到的数字
        def get(status: str) -> Generator[str, None, None]:
            s = list(status)
            for i in range(4):
                num = s[i]
                s[i] = num_prev(num)
                yield "".join(s)
                s[i] = num_succ(num)
                yield "".join(s)
                s[i] = num

        q = deque([("0000", 0)])
        seen = {"0000"}
        while q:
            status, step = q.popleft()
            for next_status in get(status):
                if next_status not in seen and next_status not in dead:
                    if next_status == target:
                        return step + 1
                    q.append((next_status, step + 1))
                    seen.add(next_status)
        
        return -1
```

```JavaScript [sol1-JavaScript]
var openLock = function(deadends, target) {
    if (target === '0000') {
        return 0;
    }

    const dead = new Set(deadends);
    if (dead.has("0000")) {
        return -1;
    }

    let step = 0;
    const queue = [];
    queue.push("0000");
    const seen = new Set();
    seen.add("0000");

    while (queue.length) {
        ++step;
        const size = queue.length;
        for (let i = 0; i < size; ++i) {
            const status = queue.shift();
            for (const nextStatus of get(status)) {
                if (!seen.has(nextStatus) && !dead.has(nextStatus)) {
                    if (nextStatus === target) {
                        return step;
                    }
                    queue.push(nextStatus);
                    seen.add(nextStatus);
                }
            }
        }
    }

    return -1;
};

const numPrev = (x) => {
    return x === '0' ? '9' : (parseInt(x) - 1) + '';
}

const numSucc = (x) => {
    return x === '9' ? '0' : (parseInt(x) + 1) + '';
}

// 枚举 status 通过一次旋转得到的数字
const get = (status) => {
    const ret = [];
    const array = Array.from(status);
    for (let i = 0; i < 4; ++i) {
        const num = array[i];
        array[i] = numPrev(num);
        ret.push(array.join(''));
        array[i] = numSucc(num);
        ret.push(array.join(''));
        array[i] = num;
    }

    return ret;
}
```

```go [sol1-Golang]
func openLock(deadends []string, target string) int {
    const start = "0000"
    if target == start {
        return 0
    }

    dead := map[string]bool{}
    for _, s := range deadends {
        dead[s] = true
    }
    if dead[start] {
        return -1
    }

    // 枚举 status 通过一次旋转得到的数字
    get := func(status string) (ret []string) {
        s := []byte(status)
        for i, b := range s {
            s[i] = b - 1
            if s[i] < '0' {
                s[i] = '9'
            }
            ret = append(ret, string(s))
            s[i] = b + 1
            if s[i] > '9' {
                s[i] = '0'
            }
            ret = append(ret, string(s))
            s[i] = b
        }
        return
    }

    type pair struct {
        status string
        step   int
    }
    q := []pair{{start, 0}}
    seen := map[string]bool{start: true}
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        for _, nxt := range get(p.status) {
            if !seen[nxt] && !dead[nxt] {
                if nxt == target {
                    return p.step + 1
                }
                seen[nxt] = true
                q = append(q, pair{nxt, p.step + 1})
            }
        }
    }
    return -1
}
```

```C [sol1-C]
struct HashTable {
    char str[5];
    UT_hash_handle hh;
};

struct Node {
    char str[5];
    int val;
};

char num_prev(char x) {
    return (x == '0' ? '9' : x - 1);
}

char num_succ(char x) {
    return (x == '9' ? '0' : x + 1);
}

// 枚举 status 通过一次旋转得到的数字
char** getNextStatus(char* status, int* retSize) {
    char** ret = malloc(sizeof(char*) * 8);
    *retSize = 0;
    for (int i = 0; i < 4; ++i) {
        char num = status[i];
        status[i] = num_prev(num);
        ret[(*retSize)] = malloc(sizeof(char) * 5);
        strcpy(ret[(*retSize)++], status);
        status[i] = num_succ(num);
        ret[(*retSize)] = malloc(sizeof(char) * 5);
        strcpy(ret[(*retSize)++], status);
        status[i] = num;
    }
    return ret;
}

int openLock(char** deadends, int deadendsSize, char* target) {
    char str_0[5] = "0000";
    if (strcmp(target, str_0) == 0) {
        return 0;
    }
    struct HashTable* dead = NULL;
    struct HashTable* tmp;
    for (int i = 0; i < deadendsSize; i++) {
        HASH_FIND(hh, dead, deadends[i], sizeof(char) * 5, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            strcpy(tmp->str, deadends[i]);
            HASH_ADD(hh, dead, str, sizeof(char) * 5, tmp);
        }
    }
    HASH_FIND(hh, dead, str_0, sizeof(char) * 5, tmp);

    if (tmp != NULL) {
        return -1;
    }

    struct Node q[10001];
    int left = 0, right = 0;
    strcpy(q[right].str, str_0);
    q[right++].val = 0;

    struct HashTable* seen = NULL;
    tmp = malloc(sizeof(struct HashTable));
    strcpy(tmp->str, str_0);
    HASH_ADD(hh, seen, str, sizeof(char) * 5, tmp);

    while (left < right) {
        char* status = q[left].str;
        int step = q[left++].val;
        int nextStatusSize;
        char** nextStatus = getNextStatus(status, &nextStatusSize);
        for (int i = 0; i < nextStatusSize; i++) {
            struct HashTable *tmp1, *tmp2;
            HASH_FIND(hh, dead, nextStatus[i], sizeof(char) * 5, tmp1);
            HASH_FIND(hh, seen, nextStatus[i], sizeof(char) * 5, tmp2);
            if (tmp1 == NULL && tmp2 == NULL) {
                if (strcmp(nextStatus[i], target) == 0) {
                    return step + 1;
                }
                strcpy(q[right].str, nextStatus[i]);
                q[right++].val = step + 1;
                tmp = malloc(sizeof(struct HashTable));
                strcpy(tmp->str, nextStatus[i]);
                HASH_ADD(hh, seen, str, sizeof(char) * 5, tmp);
            }
        }
    }

    return -1;
}
```

**复杂度分析**

- 时间复杂度：$O(b^d \cdot d^2 + md)$，其中 $b$ 是数字的进制，$d$ 是转盘数字的位数，$m$ 是数组 $\textit{deadends}$ 的长度，在本题中 $b=10$，$d=4$。

    - 转盘数字的可能性一共有 $b^d$ 种，这也是我们可以搜索到的状态数上限。对于每一个转盘数字，我们需要 $O(d)$ 的时间枚举旋转的数位，同时需要 $O(d)$ 的时间生成旋转后的数字（即加入队列），因此广度优先搜索的总时间复杂度为 $O(b^d \cdot d^2)$。

    - 此外，在搜索前我们需要将 $\textit{deadends}$ 中的所有元素放入哈希表中，计算一个字符串哈希值需要的时间为 $O(d)$，因此需要的总时间为 $O(md)$。


- 空间复杂度：$O(b^d \cdot d + m)$。

    - 我们最多需要在队列中存储 $O(b^d)$ 个长度为 $d$ 的字符串，空间复杂度为 $O(b^d \cdot d)$；

    - 哈希表需要 $O(m)$ 的空间。如果使用的语言存储的是元素的**拷贝**，那么需要的空间为 $O(md)$。

#### 方法二：启发式搜索

**概念**

我们可以使用启发式搜索更快地找到最小旋转次数。这里我们可以使用 $\text{A*}$ 算法。

读者可以自行查阅资料学习关于 $\text{A*}$ 算法的基础知识，例如 [Wikipedia - A* search algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) 或 [oi-wiki - A*](https://oi-wiki.org/search/astar/)。它不是本题解的重点，因此这里不再赘述。读者可以阅读下面的段落检验自己的学习成果：

在 $\text{A*}$ 算法中，我们需要使用四个距离函数 $F(x), G(x), H(x), H^*(x)$，其中 $F(x), G(x), H(x)$ 是可以求出的，而 $H^*(x)$ 是无法求出的，我们需要用 $H(x)$ 近似 $H^*(x)$。设起点为 $s$，终点为 $t$，这些距离函数的意义如下：

- $G(x)$ 表示从起点 $s$ 到节点 $x$ 的「实际」路径长度，注意 $G(x)$ 并不一定是最短的；

- $H(x)$ 表示从节点 $x$ 到终点 $t$ 的「估计」最短路径长度，称为**启发函数**；

- $H^*(x)$ 表示从节点 $x$ 到终点 $t$ 的「实际」最短路径长度，这是我们在广度优先搜索的过程中无法求出的，我们需要用 $H(x)$ 近似 $H^*(x)$；

- $F(x)$ 满足 $F(x) = G(x) + H(x)$，即为从起点 $s$ 到终点 $t$ 的「估计」路径长度。我们总是挑选出最小的 $F(x)$ 对应的 $x$ 进行搜索，因此 $\text{A*}$ 算法需要借助**优先队列**来实现。

如果读者熟悉求解最短路的 $\text{Dijkstra}$ 算法，就可以发现 $\text{Dijkstra}$ 算法是 $\text{A*}$ 算法在 $H(x) \equiv 0$ 时的特殊情况。

$\text{A*}$ 算法具有两个性质：

- 如果对于任意的节点 $x$，$H(x) \leq H^*(x)$ 恒成立，即我们「估计」出的从节点 $x$ 到终点 $t$ 的最短路径长度总是不超过「实际」的最短路径长度，那么称启发函数 $H(x)$ 是可接纳的（admissible heuristic）。在这种情况下，$\text{A*}$ 算法一定能找到最短路，但同一节点可能需要加入优先队列并搜索多次，即当我们从优先队列中取出节点 $x$ 时，$G(x)$ 并不一定等于从起点到节点 $x$ 的「实际」**最短**路径的长度；

- 如果对于任意的两个节点 $x$ 和 $y$，并且 $x$ 到 $y$ 有一条长度为 $D(x, y)$ 的有向边，$H(x) - H(y) \leq D(x, y)$ 恒成立，并且 $H(t)=0$，那么称启发函数 $H(x)$ 是一致的（consistent heuristic）。可以证明，一致的启发函数一定也是可接纳的。在这种情况下，同一节点只会被加入优先队列一次，并搜索不超过一次，即当我们从优先队列中取出节点 $x$ 时，$G(x)$ 一定等于从起点到节点 $x$ 的「实际」**最短**路径的长度。

**思路与算法**

我们可以设计如下的启发函数：

$$
H(\textit{status}) = \sum_{i=0}^3
\left( \begin{aligned}
& 将 ~\textit{status}~ 的第 ~i~ 个数字旋转到与 ~\textit{target}~ 的第 ~i~ 个数字一致，\\
& 最少需要的次数
\end{aligned} \right)
$$

即 $H(\textit{status})$ 等于不存在死亡数字时最小的旋转次数。根据定义，对于数字 $\textit{status}$ 和其通过一次旋转得到的数字 $\textit{next\_status}$，$H(\textit{status}) - H(\textit{next\_status})$ 要么为 $1$（旋转的那一个数位与 $\textit{target}$ 更近了），要么为 $-1$（旋转的那一个数位与 $\textit{target}$ 更远了），而 $D(\textit{status}, \textit{next\_status}) = 1$，因此我们设计的启发函数是一致的。

我们在 $\text{A*}$ 算法中使用该启发函数，即可得到最小的旋转次数。

**代码**

```C++ [sol2-C++]
struct AStar {
    // 计算启发函数
    static int getH(const string& status, const string& target) {
        int ret = 0;
        for (int i = 0; i < 4; ++i) {
            int dist = abs(int(status[i]) - int(target[i]));
            ret += min(dist, 10 - dist);
        }
        return ret;
    };

    AStar(const string& status, const string& target, int g): status_{status}, g_{g}, h_{getH(status, target)} {
        f_ = g_ + h_;
    }

    bool operator< (const AStar& that) const {
        return f_ > that.f_;
    }

    string status_;
    int f_, g_, h_;
};

class Solution {
public:
    int openLock(vector<string>& deadends, string target) {
        if (target == "0000") {
            return 0;
        }

        unordered_set<string> dead(deadends.begin(), deadends.end());
        if (dead.count("0000")) {
            return -1;
        }

        auto num_prev = [](char x) -> char {
            return (x == '0' ? '9' : x - 1);
        };
        auto num_succ = [](char x) -> char {
            return (x == '9' ? '0' : x + 1);
        };

        auto get = [&](string& status) -> vector<string> {
            vector<string> ret;
            for (int i = 0; i < 4; ++i) {
                char num = status[i];
                status[i] = num_prev(num);
                ret.push_back(status);
                status[i] = num_succ(num);
                ret.push_back(status);
                status[i] = num;
            }
            return ret;
        };

        priority_queue<AStar> q;
        q.emplace("0000", target, 0);
        unordered_set<string> seen = {"0000"};

        while (!q.empty()) {
            AStar node = q.top();
            q.pop();
            for (auto&& next_status: get(node.status_)) {
                if (!seen.count(next_status) && !dead.count(next_status)) {
                    if (next_status == target) {
                        return node.g_ + 1;
                    }
                    q.emplace(next_status, target, node.g_ + 1);
                    seen.insert(move(next_status));
                }
            }
        }

        return -1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int openLock(String[] deadends, String target) {
        if ("0000".equals(target)) {
            return 0;
        }

        Set<String> dead = new HashSet<String>();
        for (String deadend : deadends) {
            dead.add(deadend);
        }
        if (dead.contains("0000")) {
            return -1;
        }

        PriorityQueue<AStar> pq = new PriorityQueue<AStar>((a, b) -> a.f - b.f);
        pq.offer(new AStar("0000", target, 0));
        Set<String> seen = new HashSet<String>();
        seen.add("0000");

        while (!pq.isEmpty()) {
            AStar node = pq.poll();
            for (String nextStatus : get(node.status)) {
                if (!seen.contains(nextStatus) && !dead.contains(nextStatus)) {
                    if (nextStatus.equals(target)) {
                        return node.g + 1;
                    }
                    pq.offer(new AStar(nextStatus, target, node.g + 1));
                    seen.add(nextStatus);
                }
            }
        }

        return -1;
    }

    public char numPrev(char x) {
        return x == '0' ? '9' : (char) (x - 1);
    }

    public char numSucc(char x) {
        return x == '9' ? '0' : (char) (x + 1);
    }

    // 枚举 status 通过一次旋转得到的数字
    public List<String> get(String status) {
        List<String> ret = new ArrayList<String>();
        char[] array = status.toCharArray();
        for (int i = 0; i < 4; ++i) {
            char num = array[i];
            array[i] = numPrev(num);
            ret.add(new String(array));
            array[i] = numSucc(num);
            ret.add(new String(array));
            array[i] = num;
        }
        return ret;
    }
}

class AStar {
    String status;
    int f, g, h;

    public AStar(String status, String target, int g) {
        this.status = status;
        this.g = g;
        this.h = getH(status, target);
        this.f = this.g + this.h;
    }

    // 计算启发函数
    public static int getH(String status, String target) {
        int ret = 0;
        for (int i = 0; i < 4; ++i) {
            int dist = Math.abs(status.charAt(i) - target.charAt(i));
            ret += Math.min(dist, 10 - dist);
        }
        return ret;
    }
}
```

```Python [sol2-Python3]
class AStar:
    # 计算启发函数
    @staticmethod
    def getH(status: str, target: str) -> int:
        ret = 0
        for i in range(4):
            dist = abs(int(status[i]) - int(target[i]))
            ret += min(dist, 10 - dist)
        return ret

    def __init__(self, status: str, target: str, g: str) -> None:
        self.status = status
        self.g = g
        self.h = AStar.getH(status, target)
        self.f = self.g + self.h
    
    def __lt__(self, other: "AStar") -> bool:
        return self.f < other.f

class Solution:
    def openLock(self, deadends: List[str], target: str) -> int:
        if target == "0000":
            return 0

        dead = set(deadends)
        if "0000" in dead:
            return -1
        
        def num_prev(x: str) -> str:
            return "9" if x == "0" else str(int(x) - 1)
        
        def num_succ(x: str) -> str:
            return "0" if x == "9" else str(int(x) + 1)
        
        def get(status: str) -> Generator[str, None, None]:
            s = list(status)
            for i in range(4):
                num = s[i]
                s[i] = num_prev(num)
                yield "".join(s)
                s[i] = num_succ(num)
                yield "".join(s)
                s[i] = num

        q = [AStar("0000", target, 0)]
        seen = {"0000"}
        while q:
            node = heapq.heappop(q)
            for next_status in get(node.status):
                if next_status not in seen and next_status not in dead:
                    if next_status == target:
                        return node.g + 1
                    heapq.heappush(q, AStar(next_status, target, node.g + 1))
                    seen.add(next_status)
        
        return -1
```

```go [sol2-Golang]
type astar struct {
    g, h   int
    status string
}
type hp []astar

func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].g+h[i].h < h[j].g+h[j].h }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(astar)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }

// 计算启发函数
func getH(status, target string) (ret int) {
    for i := 0; i < 4; i++ {
        dist := abs(int(status[i]) - int(target[i]))
        ret += min(dist, 10-dist)
    }
    return
}

func openLock(deadends []string, target string) int {
    const start = "0000"
    if target == start {
        return 0
    }

    dead := map[string]bool{}
    for _, s := range deadends {
        dead[s] = true
    }
    if dead[start] {
        return -1
    }

    get := func(status string) (ret []string) {
        s := []byte(status)
        for i, b := range s {
            s[i] = b - 1
            if s[i] < '0' {
                s[i] = '9'
            }
            ret = append(ret, string(s))
            s[i] = b + 1
            if s[i] > '9' {
                s[i] = '0'
            }
            ret = append(ret, string(s))
            s[i] = b
        }
        return
    }

    type pair struct {
        status string
        step   int
    }
    h := hp{{0, getH(start, target), start}}
    seen := map[string]bool{start: true}
    for len(h) > 0 {
        node := heap.Pop(&h).(astar)
        for _, nxt := range get(node.status) {
            if !seen[nxt] && !dead[nxt] {
                if nxt == target {
                    return node.g + 1
                }
                seen[nxt] = true
                heap.Push(&h, astar{node.g + 1, getH(nxt, target), nxt})
            }
        }
    }
    return -1
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

启发式搜索不讨论时空复杂度。