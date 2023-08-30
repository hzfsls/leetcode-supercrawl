#### 方法一：广度优先搜索

**思路与算法**

经过分析可知，题目要求将一个基因序列 $A$ 变化至另一个基因序列 $B$，需要满足一下条件：

+ 序列 $A$ 与 序列 $B$ 之间只有一个字符不同；
+ 变化字符只能从 $\texttt{`A', `C', `G', `T'}$ 中进行选择；
+ 变换后的序列 $B$ 一定要在字符串数组 $\textit{bank}$ 中。

根据以上变换规则，我们可以进行尝试所有合法的基因变化，并找到最小的变换次数即可。步骤如下：

+ 如果 $\textit{start}$ 与 $\textit{end}$ 相等，此时直接返回 $0$；如果最终的基因序列不在 $\textit{bank}$ 中，则此时按照题意要求，无法生成，直接返回 $-1$；

+ 首先我们将可能变换的基因 $s$ 从队列中取出，按照上述的变换规则，尝试所有可能的变化后的基因，比如一个 $\texttt{AACCGGTA}$，我们依次尝试改变基因 $s$ 的一个字符，并尝试所有可能的基因变化序列 $s_0, s_1, s_2, \cdots, s_i, \cdots, s_{23}$，变化一次最多可能会生成 $3 \times 8 = 24$ 种不同的基因序列。

+ 我们需要检测当前生成的基因序列的合法性 $s_i$，首先利用哈希表检测 $s_i$ 是否在数组 $\textit{bank}$ 中，如果是则认为该基因合法，否则改变化非法直接丢弃；其次我们还需要用哈希表记录已经遍历过的基因序列，如果该基因序列已经遍历过，则此时直接跳过；如果合法且未遍历过的基因序列，则我们将其加入到队列中。

+ 如果当前变换后的基因序列与 $\textit{end}$ 相等，则此时我们直接返回最小的变化次数即可；如果队列中所有的元素都已经遍历完成还无法变成 $\textit{end}$，则此时无法实现目标变化，返回 $-1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minMutation(self, start: str, end: str, bank: List[str]) -> int:
        if start == end:
            return 0
        bank = set(bank)
        if end not in bank:
            return -1
        q = deque([(start, 0)])
        while q:
            cur, step = q.popleft()
            for i, x in enumerate(cur):
                for y in "ACGT":
                    if y != x:
                        nxt = cur[:i] + y + cur[i + 1:]
                        if nxt in bank:
                            if nxt == end:
                                return step + 1
                            bank.remove(nxt)
                            q.append((nxt, step + 1))
        return -1
```

```C++ [sol1-C++]
class Solution {
public:    
    int minMutation(string start, string end, vector<string>& bank) {
        unordered_set<string> cnt;
        unordered_set<string> visited;
        char keys[4] = {'A', 'C', 'G', 'T'};        
        for (auto & w : bank) {
            cnt.emplace(w);
        }
        if (start == end) {
            return 0;
        }
        if (!cnt.count(end)) {
            return -1;
        }
        queue<string> qu;
        qu.emplace(start);
        visited.emplace(start);
        int step = 1;
        while (!qu.empty()) {
            int sz = qu.size();
            for (int i = 0; i < sz; i++) {
                string curr = qu.front();
                qu.pop();
                for (int j = 0; j < 8; j++) {
                    for (int k = 0; k < 4; k++) {
                        if (keys[k] != curr[j]) {
                            string next = curr;
                            next[j] = keys[k];
                            if (!visited.count(next) && cnt.count(next)) {
                                if (next == end) {
                                    return step;
                                }
                                qu.emplace(next);
                                visited.emplace(next);
                            }
                        }
                    }
                }
            }
            step++;
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minMutation(String start, String end, String[] bank) {
        Set<String> cnt = new HashSet<String>();
        Set<String> visited = new HashSet<String>();
        char[] keys = {'A', 'C', 'G', 'T'};        
        for (String w : bank) {
            cnt.add(w);
        }
        if (start.equals(end)) {
            return 0;
        }
        if (!cnt.contains(end)) {
            return -1;
        }
        Queue<String> queue = new ArrayDeque<String>();
        queue.offer(start);
        visited.add(start);
        int step = 1;
        while (!queue.isEmpty()) {
            int sz = queue.size();
            for (int i = 0; i < sz; i++) {
                String curr = queue.poll();
                for (int j = 0; j < 8; j++) {
                    for (int k = 0; k < 4; k++) {
                        if (keys[k] != curr.charAt(j)) {
                            StringBuffer sb = new StringBuffer(curr);
                            sb.setCharAt(j, keys[k]);
                            String next = sb.toString();
                            if (!visited.contains(next) && cnt.contains(next)) {
                                if (next.equals(end)) {
                                    return step;
                                }
                                queue.offer(next);
                                visited.add(next);
                            }
                        }
                    }
                }
            }
            step++;
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMutation(string start, string end, string[] bank) {
        ISet<string> cnt = new HashSet<string>();
        ISet<string> visited = new HashSet<string>();
        char[] keys = {'A', 'C', 'G', 'T'};        
        foreach (string w in bank) {
            cnt.Add(w);
        }
        if (start.Equals(end)) {
            return 0;
        }
        if (!cnt.Contains(end)) {
            return -1;
        }
        Queue<string> queue = new Queue<string>();
        queue.Enqueue(start);
        visited.Add(start);
        int step = 1;
        while (queue.Count > 0) {
            int sz = queue.Count;
            for (int i = 0; i < sz; i++) {
                string curr = queue.Dequeue();
                for (int j = 0; j < 8; j++) {
                    for (int k = 0; k < 4; k++) {
                        if (keys[k] != curr[j]) {
                            StringBuilder sb = new StringBuilder(curr);
                            sb.Replace(curr[j], keys[k], j, 1);
                            string next = sb.ToString();
                            if (!visited.Contains(next) && cnt.Contains(next)) {
                                if (next.Equals(end)) {
                                    return step;
                                }
                                queue.Enqueue(next);
                                visited.Add(next);
                            }
                        }
                    }
                }
            }
            step++;
        }
        return -1;
    }
}
```

```C [sol1-C]
typedef struct {
    char key[16];
    UT_hash_handle hh;
} HashItem;

bool hashInsert(HashItem ** obj, const char * str) {
    HashItem * pEntry = (HashItem *)malloc(sizeof(HashItem));
    strcpy(pEntry->key, str);
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashFind(HashItem ** obj, const char * str) {
    HashItem * pEntry = NULL;
    HASH_FIND_STR(*obj, str, pEntry);
    if (NULL == pEntry) {
        return false;
    } else {
        return true;
    }
}

void hashFree(HashItem ** obj) {
    HashItem *curr, *tmp;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr);
    } 
}

int minMutation(char * start, char * end, char ** bank, int bankSize) {
    HashItem *cnt = NULL;
    HashItem *visited = NULL;
    char keys[4] = {'A', 'C', 'G', 'T'}; 
    if (strcmp(start, end) == 0) {
        return 0;
    }       
    for (int i = 0; i < bankSize; i++) {
        hashInsert(&cnt, bank[i]);
    }
    if (!hashFind(&cnt, end)) {
        return -1;
    }
    char ** queue = (char **)malloc(sizeof(char *) * bankSize);
    int head = 0;
    int tail = 0;
    queue[tail] = (char *)malloc(sizeof(char) * 16);
    strcpy(queue[tail], start);
    hashInsert(&visited, start);
    tail++;
    int step = 1;
    while (head != tail) {
        int sz = tail - head;
        for (int i = 0; i < sz; i++) {
            char * curr = queue[head++];
            for (int j = 0; j < 8; j++) {
                for (int k = 0; k < 4; k++) {
                    if (keys[k] != curr[j]) {
                        char *next = (char *)malloc(sizeof(char) * 16);
                        strcpy(next, curr);
                        next[j] = keys[k];
                        if (!hashFind(&visited, next) && hashFind(&cnt, next)) {
                            if (strcmp(next, end) == 0) {
                                while (head != tail) {
                                    free(queue[head++]);
                                }
                                hashFree(&cnt);
                                hashFree(&visited);
                                free(queue);
                                return step;
                            }
                            queue[tail++] = next;
                            hashInsert(&visited, next);
                        } else {
                            free(next);
                        }
                    }
                }
            }
            free(curr);
        }
        step++;
    }
    hashFree(&cnt);
    hashFree(&visited);
    free(queue);
    return -1;
}
```

```JavaScript [sol1-JavaScript]
var minMutation = function(start, end, bank) {
    const cnt = new Set();
    const visited = new Set();
    const keys = ['A', 'C', 'G', 'T'];
    for (const w of bank) {
        cnt.add(w);
    }
    if (start === end) {
        return 0;
    }
    if (!cnt.has(end)) {
        return -1;
    }
    const queue = [start];
    visited.add(start);
    let step = 1;
    while (queue.length) {
        const sz = queue.length;
        for (let i = 0; i < sz; i++) {
            const curr = queue.shift();
            for (let j = 0; j < 8; j++) {
                for (let k = 0; k < 4; k++) {
                    if (keys[k] !== curr[j]) {
                        const sb = [...curr];
                        sb[j] = keys[k];
                        const next = sb.join('');
                        if (!visited.has(next) && cnt.has(next)) {
                            if (next === end) {
                                return step;
                            }
                            queue.push(next);
                            visited.add(next);
                        }
                    }
                }
            }
        }
        step++;
    }
    return -1;
};
```

```go [sol1-Golang]
func minMutation(start, end string, bank []string) int {
    if start == end {
        return 0
    }
    bankSet := map[string]struct{}{}
    for _, s := range bank {
        bankSet[s] = struct{}{}
    }
    if _, ok := bankSet[end]; !ok {
        return -1
    }

    q := []string{start}
    for step := 0; q != nil; step++ {
        tmp := q
        q = nil
        for _, cur := range tmp {
            for i, x := range cur {
                for _, y := range "ACGT" {
                    if y != x {
                        nxt := cur[:i] + string(y) + cur[i+1:]
                        if _, ok := bankSet[nxt]; ok {
                            if nxt == end {
                                return step + 1
                            }
                            delete(bankSet, nxt)
                            q = append(q, nxt)
                        }
                    }
                }
            }
        }
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(C \times n \times m)$，其中 $n$ 为基因序列的长度，$m$ 为数组 $\textit{bank}$ 的长度。对于队列中的每个合法的基因序列每次都需要计算 $C \times n$ 种变化，在这里 $C = 4$；队列中最多有 $m$ 个元素，因此时间复杂度为 $O(C \times n \times m)$。

- 空间复杂度：$O(n \times m)$，其中 $n$ 为基因序列的长度，$m$ 为数组 $\textit{bank}$ 的长度。合法性的哈希表中一共存有 $m$ 个元素，队列中最多有 $m$ 个元素，每个元素的空间为 $O(n)$；队列中最多有 $m$ 个元素，每个元素的空间为 $O(n)$，因此空间复杂度为 $O(n \times m)$。

#### 方法二：预处理优化

**思路与算法**

经过分析可知，题目要求将一个基因序列 $A$ 变化至另一个基因序列 $B$，需要满足一下条件：

+ 序列 $A$ 与 序列 $B$ 之间只有一个字符不同；
+ 变化字符只能从 $\texttt{`A', `C', `G', `T'}$ 中进行选择；
+ 变换后的序列 $B$ 一定要在字符串数组 $\textit{bank}$ 中。

已知方法一中广度优先搜索方法，我们可以对 $\textit{bank}$ 进行预处理，只在合法的基因变化进行搜索即可。由于题目中给定的 $\textit{bank}$ 基因库的长度较小，因此可以直接在对 $\textit{bank}$ 进行预处理，找到基因库中的每个基因的合法变换，而不需要像方法一中每次都需要去计算基因的变化序列，我们将每个基因的合法变化关系存储在邻接表 $\textit{adj}$ 中，每次基因变化搜索只在 $\textit{adj}$ 中进行即可。

```Python [sol2-Python3]
class Solution:
    def minMutation(self, start: str, end: str, bank: List[str]) -> int:
        if start == end:
            return 0

        def diffOne(s: str, t: str) -> bool:
            return sum(x != y for x, y in zip(s, t)) == 1

        m = len(bank)
        adj = [[] for _ in range(m)]
        endIndex = -1
        for i, s in enumerate(bank):
            if s == end:
                endIndex = i
            for j in range(i + 1, m):
                if diffOne(s, bank[j]):
                    adj[i].append(j)
                    adj[j].append(i)
        if endIndex == -1:
            return -1

        q = [i for i, s in enumerate(bank) if diffOne(start, s)]
        vis = set(q)
        step = 1
        while q:
            tmp = q
            q = []
            for cur in tmp:
                if cur == endIndex:
                    return step
                for nxt in adj[cur]:
                    if nxt not in vis:
                        vis.add(nxt)
                        q.append(nxt)
            step += 1
        return -1
```

```C++ [sol2-C++]
class Solution {
public:
    int minMutation(string start, string end, vector<string>& bank) {
        int m = start.size();
        int n = bank.size();
        vector<vector<int>> adj(n);
        int endIndex = -1;
        for (int i = 0; i < n; i++) {
            if (end == bank[i]) {
                endIndex = i;
            }
            for (int j = i + 1; j < n; j++) {
                int mutations = 0;
                for (int k = 0; k < m; k++) {
                    if (bank[i][k] != bank[j][k]) {
                        mutations++;
                    }
                    if (mutations > 1) {
                        break;
                    }
                }
                if (mutations == 1) {
                    adj[i].emplace_back(j);
                    adj[j].emplace_back(i);
                }
            }
        }
        if (endIndex == -1) {
            return -1;
        }

        queue<int> qu;
        vector<bool> visited(n, false);
        int step = 1;
        for (int i = 0; i < n; i++) {
            int mutations = 0;
            for (int k = 0; k < m; k++) {
                if (start[k] != bank[i][k]) {
                    mutations++;
                }
                if (mutations > 1) {
                    break;
                }
            }
            if (mutations == 1) {
                qu.emplace(i);
                visited[i] = true;
            }
        }        
        while (!qu.empty()) {
            int sz = qu.size();
            for (int i = 0; i < sz; i++) {
                int curr = qu.front();
                qu.pop();
                if (curr == endIndex) {
                    return step;
                }
                for (auto & next : adj[curr]) {
                    if (visited[next]) {
                        continue;
                    }
                    visited[next] = true;
                    qu.emplace(next);
                }
            }
            step++;
        }
        return -1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minMutation(String start, String end, String[] bank) {
        int m = start.length();
        int n = bank.length;
        List<Integer>[] adj = new List[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new ArrayList<Integer>();
        }
        int endIndex = -1;
        for (int i = 0; i < n; i++) {
            if (end.equals(bank[i])) {
                endIndex = i;
            }
            for (int j = i + 1; j < n; j++) {
                int mutations = 0;
                for (int k = 0; k < m; k++) {
                    if (bank[i].charAt(k) != bank[j].charAt(k)) {
                        mutations++;
                    }
                    if (mutations > 1) {
                        break;
                    }
                }
                if (mutations == 1) {
                    adj[i].add(j);
                    adj[j].add(i);
                }
            }
        }
        if (endIndex == -1) {
            return -1;
        }

        Queue<Integer> queue = new ArrayDeque<Integer>();
        boolean[] visited = new boolean[n];
        int step = 1;
        for (int i = 0; i < n; i++) {
            int mutations = 0;
            for (int k = 0; k < m; k++) {
                if (start.charAt(k) != bank[i].charAt(k)) {
                    mutations++;
                }
                if (mutations > 1) {
                    break;
                }
            }
            if (mutations == 1) {
                queue.offer(i);
                visited[i] = true;
            }
        }        
        while (!queue.isEmpty()) {
            int sz = queue.size();
            for (int i = 0; i < sz; i++) {
                int curr = queue.poll();
                if (curr == endIndex) {
                    return step;
                }
                for (int next : adj[curr]) {
                    if (visited[next]) {
                        continue;
                    }
                    visited[next] = true;
                    queue.offer(next);
                }
            }
            step++;
        }
        return -1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinMutation(string start, string end, string[] bank) {
        int m = start.Length;
        int n = bank.Length;
        IList<int>[] adj = new IList<int>[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new List<int>();
        }
        int endIndex = -1;
        for (int i = 0; i < n; i++) {
            if (end.Equals(bank[i])) {
                endIndex = i;
            }
            for (int j = i + 1; j < n; j++) {
                int mutations = 0;
                for (int k = 0; k < m; k++) {
                    if (bank[i][k] != bank[j][k]) {
                        mutations++;
                    }
                    if (mutations > 1) {
                        break;
                    }
                }
                if (mutations == 1) {
                    adj[i].Add(j);
                    adj[j].Add(i);
                }
            }
        }
        if (endIndex == -1) {
            return -1;
        }

        Queue<int> queue = new Queue<int>();
        bool[] visited = new bool[n];
        int step = 1;
        for (int i = 0; i < n; i++) {
            int mutations = 0;
            for (int k = 0; k < m; k++) {
                if (start[k] != bank[i][k]) {
                    mutations++;
                }
                if (mutations > 1) {
                    break;
                }
            }
            if (mutations == 1) {
                queue.Enqueue(i);
                visited[i] = true;
            }
        }        
        while (queue.Count > 0) {
            int sz = queue.Count;
            for (int i = 0; i < sz; i++) {
                int curr = queue.Dequeue();
                if (curr == endIndex) {
                    return step;
                }
                foreach (int next in adj[curr]) {
                    if (visited[next]) {
                        continue;
                    }
                    visited[next] = true;
                    queue.Enqueue(next);
                }
            }
            step++;
        }
        return -1;
    }
}
```

```C [sol2-C]
int minMutation(char * start, char * end, char ** bank, int bankSize) {
    int m = strlen(start);
    int **adj = (int **)malloc(sizeof(int *) * bankSize);
    int endIndex = -1;
    for (int i = 0; i < bankSize; i++) {
        adj[i] = (int *)malloc(sizeof(int) * bankSize);
        memset(adj[i], 0, sizeof(int) * bankSize);
    }
    for (int i = 0; i < bankSize; i++) {
        if (!strcmp(end, bank[i])) {
            endIndex = i;
        }
        for (int j = i + 1; j < bankSize; j++) {
            int mutations = 0;
            for (int k = 0; k < m; k++) {
                if (bank[i][k] != bank[j][k]) {
                    mutations++;
                }
                if (mutations > 1) {
                    break;
                }
            }
            if (mutations == 1) {
                adj[i][j] = 1;
                adj[j][i] = 1;
            }
        }
    }
    if (endIndex == -1) {
        return -1;
    }

    int *queue = (int *)malloc(sizeof(int) * bankSize);
    bool *visited = (bool *)malloc(sizeof(bool) * bankSize);
    memset(visited, 0, sizeof(bool) * bankSize);
    int head = 0;
    int tail = 0;
    int step = 1;
    for (int i = 0; i < bankSize; i++) {
        int mutations = 0;
        for (int k = 0; k < m; k++) {
            if (start[k] != bank[i][k]) {
                mutations++;
            }
            if (mutations > 1) {
                break;
            }
        }
        if (mutations == 1) {
            queue[tail++] = i;
            visited[i] = true;
        }
    }        
    while (head != tail) {
        int sz = tail - head;
        for (int i = 0; i < sz; i++) {
            int curr = queue[head++];
            if (curr == endIndex) {
                for (int i = 0; i < bankSize; i++) {
                    free(adj[i]);
                }
                free(adj);
                free(queue);
                free(visited);
                return step;
            }
            for (int j = 0; j < bankSize; j++) {
                if (visited[j] || !adj[curr][j]) {
                    continue;
                }
                visited[j] = true;
                queue[tail++] = j;
            }
        }
        step++;
    }
    for (int i = 0; i < bankSize; i++) {
        free(adj[i]);
    }
    free(adj);
    free(queue);
    free(visited);
    return -1; 
}
```

```JavaScript [sol2-JavaScript]
var minMutation = function(start, end, bank) {
    const m = start.length;
    const n = bank.length;
    const adj = new Array(n).fill(0).map(() => new Array());
    let endIndex = -1;
    for (let i = 0; i < n; i++) {
        if (end === bank[i]) {
            endIndex = i;
        }
        for (let j = i + 1; j < n; j++) {
            let mutations = 0;
            for (let k = 0; k < m; k++) {
                if (bank[i][k] !== bank[j][k]) {
                    mutations++;
                }
                if (mutations > 1) {
                    break;
                }
            }
            if (mutations === 1) {
                adj[i].push(j);
                adj[j].push(i);
            }
        }
    }
    if (endIndex === -1) {
        return -1;
    }

    const queue = [];
    const visited = new Array(n).fill(0);
    let step = 1;
    for (let i = 0; i < n; i++) {
        let mutations = 0;
        for (let k = 0; k < m; k++) {
            if (start[k] != bank[i][k]) {
                mutations++;
            }
            if (mutations > 1) {
                break;
            }
        }
        if (mutations == 1) {
            queue.push(i);
            visited[i] = true;
        }
    }        
    while (queue.length) {
        const sz = queue.length;
        for (let i = 0; i < sz; i++) {
            const curr = queue.shift();
            if (curr === endIndex) {
                return step;
            }
            for (const next of adj[curr]) {
                if (visited[next]) {
                    continue;
                }
                visited[next] = true;
                queue.push(next);
            }
        }
        step++;
    }
    return -1;
};
```

```go [sol2-Golang]
func diffOne(s, t string) (diff bool) {
    for i := range s {
        if s[i] != t[i] {
            if diff {
                return false
            }
            diff = true
        }
    }
    return
}

func minMutation(start, end string, bank []string) int {
    if start == end {
        return 0
    }

    m := len(bank)
    adj := make([][]int, m)
    endIndex := -1
    for i, s := range bank {
        if s == end {
            endIndex = i
        }
        for j := i + 1; j < m; j++ {
            if diffOne(s, bank[j]) {
                adj[i] = append(adj[i], j)
                adj[j] = append(adj[j], i)
            }
        }
    }
    if endIndex == -1 {
        return -1
    }

    var q []int
    vis := make([]bool, m)
    for i, s := range bank {
        if diffOne(start, s) {
            q = append(q, i)
            vis[i] = true
        }
    }
    for step := 1; q != nil; step++ {
        tmp := q
        q = nil
        for _, cur := range tmp {
            if cur == endIndex {
                return step
            }
            for _, nxt := range adj[cur] {
                if !vis[nxt] {
                    vis[nxt] = true
                    q = append(q, nxt)
                }
            }
        }
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n^2)$，其中 $m$ 为基因序列的长度，$n$ 为数组 $\textit{bank}$ 的长度。计算合法的基因变化 $\textit{adj}$ 需要的时间为 $O(m \times n^2)$，广度优先搜索时，队列中最多有 $n$ 个元素，需要的时间为 $O(n)$，因此时间复杂度为 $O(m \times n^2)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 为数组 $\textit{bank}$ 的长度。计算合法的基因变化 $\textit{adj}$ 需要的空间为 $O(n^2)$，队列中最多有 $n$ 个元素，因此空间复杂度为 $O(n^2)$。