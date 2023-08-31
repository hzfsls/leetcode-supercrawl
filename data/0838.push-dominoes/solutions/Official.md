## [838.推多米诺 中文官方题解](https://leetcode.cn/problems/push-dominoes/solutions/100000/tui-duo-mi-nuo-by-leetcode-solution-dwgm)

#### 方法一：广度优先搜索

**思路**

当时间为 $0$ 时，部分骨牌会受到一个初始的向左或向右的力而翻倒。过了 $1$ 秒后，这些翻倒的骨牌会对其周围的骨牌施加一个力。具体表现为：

- 向左翻倒的骨牌，如果它有直立的左边紧邻的骨牌，则会对该直立的骨牌施加一个向左的力。

- 向右翻倒的骨牌，如果它有直立的右边紧邻的骨牌，则会对该直立的骨牌施加一个向右的力。

接下去需要分析这些 $1$ 秒时受力的骨牌的状态。如果仅受到单侧的力，它们会倒向单侧；如果受到两个力，则会保持平衡。再过 $1$ 秒后，这些新翻倒的骨牌又会对其他直立的骨牌施加力，而不会对正在翻倒或已经翻倒的骨牌施加力。

这样的思路类似于广度优先搜索。我们用一个队列 $q$ 模拟搜索的顺序；数组 $\textit{time}$ 记录骨牌翻倒或者确定不翻倒的时间，翻倒的骨牌不会对正在翻倒或者已经翻倒的骨牌施加力；数组 $\textit{force}$ 记录骨牌受到的力，骨牌仅在受到单侧的力时会翻倒。

**代码**

```Python [sol1-Python3]
class Solution:
    def pushDominoes(self, dominoes: str) -> str:
        n = len(dominoes)
        q = deque()
        time = [-1] * n
        force = [[] for _ in range(n)]
        for i, f in enumerate(dominoes):
            if f != '.':
                q.append(i)
                time[i] = 0
                force[i].append(f)

        res = ['.'] * n
        while q:
            i = q.popleft()
            if len(force[i]) == 1:
                res[i] = f = force[i][0]
                ni = i - 1 if f == 'L' else i + 1
                if 0 <= ni < n:
                    t = time[i]
                    if time[ni] == -1:
                        q.append(ni)
                        time[ni] = t + 1
                        force[ni].append(f)
                    elif time[ni] == t + 1:
                        force[ni].append(f)
        return ''.join(res)
```

```Java [sol1-Java]
class Solution {
    public String pushDominoes(String dominoes) {
        int n = dominoes.length();
        Deque<Integer> queue = new ArrayDeque<Integer>();
        int[] time = new int[n];
        Arrays.fill(time, -1);
        List<Character>[] force = new List[n];
        for (int i = 0; i < n; i++) {
            force[i] = new ArrayList<Character>();
        }
        for (int i = 0; i < n; i++) {
            char f = dominoes.charAt(i);
            if (f != '.') {
                queue.offer(i);
                time[i] = 0;
                force[i].add(f);
            }
        }

        char[] res = new char[n];
        Arrays.fill(res, '.');
        while (!queue.isEmpty()) {
            int i = queue.poll();
            if (force[i].size() == 1) {
                char f = force[i].get(0);
                res[i] = f;
                int ni = f == 'L' ? i - 1 : i + 1;
                if (ni >= 0 && ni < n) {
                    int t = time[i];
                    if (time[ni] == -1) {
                        queue.offer(ni);
                        time[ni] = t + 1;
                        force[ni].add(f);
                    } else if (time[ni] == t + 1) {
                        force[ni].add(f);
                    }
                }
            }
        }
        return new String(res);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string PushDominoes(string dominoes) {
        int n = dominoes.Length;
        Queue<int> queue = new Queue<int>();
        int[] time = new int[n];
        Array.Fill(time, -1);
        IList<char>[] force = new IList<char>[n];
        for (int i = 0; i < n; i++) {
            force[i] = new List<char>();
        }
        for (int i = 0; i < n; i++) {
            char f = dominoes[i];
            if (f != '.') {
                queue.Enqueue(i);
                time[i] = 0;
                force[i].Add(f);
            }
        }

        char[] res = new char[n];
        Array.Fill(res, '.');
        while (queue.Count > 0) {
            int i = queue.Dequeue();
            if (force[i].Count == 1) {
                char f = force[i][0];
                res[i] = f;
                int ni = f == 'L' ? i - 1 : i + 1;
                if (ni >= 0 && ni < n) {
                    int t = time[i];
                    if (time[ni] == -1) {
                        queue.Enqueue(ni);
                        time[ni] = t + 1;
                        force[ni].Add(f);
                    } else if (time[ni] == t + 1) {
                        force[ni].Add(f);
                    }
                }
            }
        }
        return new string(res);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string pushDominoes(string dominoes) {
        int n = dominoes.size();
        queue<int> q;
        vector<int> time(n, - 1);
        vector<string> force(n);
        for (int i = 0; i < n; i++) {
            if (dominoes[i] != '.') {
                q.emplace(i);
                time[i] = 0;
                force[i].push_back(dominoes[i]);
            }
        }

        string res(n, '.');
        while (!q.empty()) {
            int i = q.front();
            q.pop();
            if (force[i].size() == 1) {
                char f = force[i][0];
                res[i] = f;
                int ni = (f == 'L') ? (i - 1) : (i + 1);
                if (ni >= 0 and ni < n) {
                    int t = time[i];
                    if (time[ni] == -1) {
                        q.emplace(ni);
                        time[ni] = t + 1;
                        force[ni].push_back(f);
                    } else if(time[ni] == t + 1) {
                        force[ni].push_back(f);
                    }
                }
            }
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct StListNode {
    int val;
    struct StListNode * next;
} StListNode;

typedef struct Queue{
    struct StListNode * head;
    struct StListNode * tail;
    int length;
} Queue;

bool isEmpty(const Queue * obj) {
    return obj->length == 0;
}

int length(const Queue * obj) {
    return obj->length;
}

bool initQueue(Queue * obj) {
    obj->head = NULL;
    obj->tail = NULL;
    obj->length = 0;
    return true;
}

bool pushQueue(Queue * obj, int val) {
    StListNode * node = (StListNode *)malloc(sizeof(StListNode));
    node->val = val;
    node->next = NULL;
    if (NULL == obj->head) {
        obj->head = node;
        obj->tail = node;
    } else {
        obj->tail->next = node;
        obj->tail = obj->tail->next;
    }
    obj->length++;
    return true;
}

int front(const Queue * obj) {
    if (obj->length == 0) {
        return -1;
    }
    return obj->head->val;
}

int popQueue(Queue * obj) {
    if (obj->length == 0) {
        return -1;
    }
    int res = obj->head->val;
    StListNode * node = obj->head;
    obj->head = obj->head->next;
    obj->length--;
    free(node);
    return res;
}

char * pushDominoes(char * dominoes){
    int n = strlen(dominoes);
    int * time = (int *)malloc(sizeof(int) * n);
    char * res = (char *)malloc(sizeof(char) * (n + 1));
    Queue ** force = (Queue **)malloc(sizeof(Queue *) * n);

    for (int i = 0; i < n; i++) {
        time[i] = -1;
        force[i] = (Queue *)malloc(sizeof(Queue));
        initQueue(force[i]);
        res[i] = '.';
    }
    res[n] = '\0';
    Queue qu; 
    initQueue(&qu);
    for (int i = 0; i < n; i++) {
        if (dominoes[i] != '.') {
            pushQueue(&qu, i);
            time[i] = 0;
            pushQueue(force[i], dominoes[i]);
        }
    }

    while (!isEmpty(&qu)) {
        int i = popQueue(&qu);
        if (length(force[i]) == 1) {
            char f = front(force[i]);
            res[i] = f;
            int ni = (f == 'L') ? (i - 1) : (i + 1);
            if (ni >= 0 && ni < n) {
                int t = time[i];
                if (time[ni] == -1) {
                    pushQueue(&qu, ni);
                    time[ni] = t + 1;
                    pushQueue(force[ni], f);
                } else if(time[ni] == t + 1) {
                    pushQueue(force[ni], f);
                }
            }
        }
    }
    /* free resource */
    for (int i = 0; i < n; i++) {
        while (!isEmpty(force[i])) {
            popQueue(force[i]);
        }
    }
    return res;
}
```

```go [sol1-Golang]
func pushDominoes(dominoes string) string {
    n := len(dominoes)
    q := []int{}
    time := make([]int, n)
    for i := range time {
        time[i] = -1
    }
    force := make([][]byte, n)
    for i, ch := range dominoes {
        if ch != '.' {
            q = append(q, i)
            time[i] = 0
            force[i] = append(force[i], byte(ch))
        }
    }

    ans := bytes.Repeat([]byte{'.'}, n)
    for len(q) > 0 {
        i := q[0]
        q = q[1:]
        if len(force[i]) > 1 {
            continue
        }
        f := force[i][0]
        ans[i] = f
        ni := i - 1
        if f == 'R' {
            ni = i + 1
        }
        if 0 <= ni && ni < n {
            t := time[i]
            if time[ni] == -1 {
                q = append(q, ni)
                time[ni] = t + 1
                force[ni] = append(force[ni], f)
            } else if time[ni] == t+1 {
                force[ni] = append(force[ni], f)
            }
        }
    }
    return string(ans)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{dominoes}$ 的长度。每个下标会最多被判断一次状态。

- 空间复杂度：$O(n)$。队列和数组最多各包含 $n$ 个元素。

#### 方法二：模拟

**思路**

我们可以枚举所有连续的没有被推动的骨牌，根据这段骨牌的两边骨牌（如果有的话）的推倒方向决定这段骨牌的最终状态：

- 如果两边的骨牌同向，那么这段连续的竖立骨牌会倒向同一方向。
- 如果两边的骨牌相对，那么这段骨牌会向中间倒。
- 如果两边的骨牌相反，那么这段骨牌会保持竖立。

特别地，如果左侧没有被推倒的骨牌，则假设存在一块向左倒的骨牌；如果右侧没有被推倒的骨牌，则假设存在一块向右倒的骨牌。这样的假设不会破坏骨牌的最终状态，并且边界情况也可以落入到上述三种情况中。

我们可以使用两个指针 $i$ 和 $j$ 来枚举所有连续的没有被推动的骨牌，$\textit{left}$ 和 $\textit{right}$ 表示两边骨牌的推倒方向。根据上述三种情况来计算骨牌的最终状态。

**代码**

```Python [sol2-Python3]
class Solution:
    def pushDominoes(self, dominoes: str) -> str:
        s = list(dominoes)
        n, i, left = len(s), 0, 'L'
        while i < n:
            j = i
            while j < n and s[j] == '.':  # 找到一段连续的没有被推动的骨牌
                j += 1
            right = s[j] if j < n else 'R'
            if left == right:  # 方向相同，那么这些竖立骨牌也会倒向同一方向
                while i < j:
                    s[i] = right
                    i += 1
            elif left == 'R' and right == 'L':  # 方向相对，那么就从两侧向中间倒
                k = j - 1
                while i < k:
                    s[i] = 'R'
                    s[k] = 'L'
                    i += 1
                    k -= 1
            left = right
            i = j + 1
        return ''.join(s)
```

```Java [sol2-Java]
class Solution {
    public String pushDominoes(String dominoes) {
        char[] s = dominoes.toCharArray();
        int n = s.length, i = 0;
        char left = 'L';
        while (i < n) {
            int j = i;
            while (j < n && s[j] == '.') { // 找到一段连续的没有被推动的骨牌
                j++;
            }
            char right = j < n ? s[j] : 'R';
            if (left == right) { // 方向相同，那么这些竖立骨牌也会倒向同一方向
                while (i < j) {
                    s[i++] = right;
                }
            } else if (left == 'R' && right == 'L') { // 方向相对，那么就从两侧向中间倒
                int k = j - 1;
                while (i < k) {
                    s[i++] = 'R';
                    s[k--] = 'L';
                }
            }
            left = right;
            i = j + 1;
        }
        return new String(s);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string PushDominoes(string dominoes) {
        char[] s = dominoes.ToCharArray();
        int n = s.Length, i = 0;
        char left = 'L';
        while (i < n) {
            int j = i;
            while (j < n && s[j] == '.') { // 找到一段连续的没有被推动的骨牌
                j++;
            }
            char right = j < n ? s[j] : 'R';
            if (left == right) { // 方向相同，那么这些竖立骨牌也会倒向同一方向
                while (i < j) {
                    s[i++] = right;
                }
            } else if (left == 'R' && right == 'L') { // 方向相对，那么就从两侧向中间倒
                int k = j - 1;
                while (i < k) {
                    s[i++] = 'R';
                    s[k--] = 'L';
                }
            }
            left = right;
            i = j + 1;
        }
        return new string(s);
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    string pushDominoes(string dominoes) {
        int n = dominoes.size(), i = 0;
        char left = 'L';
        while (i < n) {
            int j = i;
            while (j < n && dominoes[j] == '.') { // 找到一段连续的没有被推动的骨牌
                j++;
            }
            char right = j < n ? dominoes[j] : 'R';
            if (left == right) { // 方向相同，那么这些竖立骨牌也会倒向同一方向
                while (i < j) {
                    dominoes[i++] = right;
                }
            } else if (left == 'R' && right == 'L') { // 方向相对，那么就从两侧向中间倒
                int k = j - 1;
                while (i < k) {
                    dominoes[i++] = 'R';
                    dominoes[k--] = 'L';
                }
            }
            left = right;
            i = j + 1;
        }
        return dominoes;
    }
};
```

```C [sol2-C]
char * pushDominoes(char * dominoes) {
    int n = strlen(dominoes), i = 0;
    char left = 'L';
    while (i < n) {
        int j = i;
        while (j < n && dominoes[j] == '.') { // 找到一段连续的没有被推动的骨牌
            j++;
        }
        char right = j < n ? dominoes[j] : 'R';
        if (left == right) { // 方向相同，那么这些竖立骨牌也会倒向同一方向
            while (i < j) {
                dominoes[i++] = right;
            }
        } else if (left == 'R' && right == 'L') { // 方向相对，那么就从两侧向中间倒
            int k = j - 1;
            while (i < k) {
                dominoes[i++] = 'R';
                dominoes[k--] = 'L';
            }
        }
        left = right;
        i = j + 1;
    }
    return dominoes;
}
```

```go [sol2-Golang]
func pushDominoes(dominoes string) string {
    s := []byte(dominoes)
    i, n, left := 0, len(s), byte('L')
    for i < n {
        j := i
        for j < n && s[j] == '.' { // 找到一段连续的没有被推动的骨牌
            j++
        }
        right := byte('R')
        if j < n {
            right = s[j]
        }
        if left == right { // 方向相同，那么这些竖立骨牌也会倒向同一方向
            for i < j {
                s[i] = right
                i++
            }
        } else if left == 'R' && right == 'L' { // 方向相对，那么就从两侧向中间倒
            k := j - 1
            for i < k {
                s[i] = 'R'
                s[k] = 'L'
                i++
                k--
            }
        }
        left = right
        i = j + 1
    }
    return string(s)
}
```

```JavaScript [sol2-JavaScript]
var pushDominoes = function(dominoes) {
    const s = [...dominoes];
    let n = s.length, i = 0;
    let left = 'L';
    while (i < n) {
        let j = i;
        while (j < n && s[j] == '.') { // 找到一段连续的没有被推动的骨牌
            j++;
        }
        const right = j < n ? s[j] : 'R';
        if (left === right) { // 方向相同，那么这些竖立骨牌也会倒向同一方向
            while (i < j) {
                s[i++] = right;
            }
        } else if (left === 'R' && right === 'L') { // 方向相对，那么就从两侧向中间倒
            let k = j - 1;
            while (i < k) {
                s[i++] = 'R';
                s[k--] = 'L';
            }
        }
        left = right;
        i = j + 1;
    }
    return s.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{dominoes}$ 的长度。每个下标会最多会被访问和赋值各一次。

- 空间复杂度：$O(1)$ 或 $O(n)$。某些语言字符串不可变，需要 $O(n)$ 的额外空间。