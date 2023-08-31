## [444.序列重建 中文官方题解](https://leetcode.cn/problems/sequence-reconstruction/solutions/100000/xu-lie-zhong-jian-by-leetcode-solution-x337)

#### 方法一：拓扑排序

**思路和算法**

由于 $\textit{sequences}$ 中的每个序列都是 $\textit{nums}$ 的子序列，因此每个序列中的数字顺序都和 $\textit{nums}$ 中的数字顺序一致。为了判断 $\textit{nums}$ 是不是序列的唯一最短超序列，只需要判断根据 $\textit{sequences}$ 中的每个序列构造超序列的结果是否唯一。

可以将 $\textit{sequences}$ 中的所有序列看成有向图，数字 $1$ 到 $n$ 分别表示图中的 $n$ 个结点，每个序列中的相邻数字表示的结点之间存在一条有向边。根据给定的序列构造超序列等价于有向图的拓扑排序。

首先根据有向边计算每个结点的入度，然后将所有入度为 $0$ 的结点添加到队列中，进行拓扑排序。每一轮拓扑排序时，队列中的元素个数表示可以作为超序列下一个数字的元素个数，根据队列中的元素个数，执行如下操作。

- 如果队列中的元素个数大于 $1$，则超序列的下一个数字不唯一，因此 $\textit{nums}$ 不是唯一的最短超序列，返回 $\text{false}$。

- 如果队列中的元素个数等于 $1$，则超序列的下一个数字是队列中唯一的数字。将该数字从队列中取出，将该数字指向的每个数字的入度减 $1$，并将入度变成 $0$ 的数字添加到队列中。

重复上述过程，直到出现队列中的元素个数不等于 $1$ 的情况。

- 如果队列中的元素个数大于 $1$，则 $\textit{nums}$ 不是唯一的最短超序列，返回 $\text{false}$。

- 如果队列为空，则完整的拓扑排序结束，$\textit{nums}$ 是唯一的最短超序列，返回 $\text{true}$。

**证明**

如果拓扑排序的过程中，有一轮的队列中的元素个数大于 $1$，则由于超序列的下一个数字有多种可能，因此 $\textit{nums}$ 不是唯一的最短超序列，这一点颇为直观。需要证明的是：当队列为空时，完整的拓扑排序结束，$\textit{nums}$ 是唯一的最短超序列。

证明一：只有当 $\textit{nums}$ 中的所有数字都在至少一个序列中出现时，才可能执行完整的拓扑排序。

由于 $\textit{sequences}$ 中的每个序列都是 $\textit{nums}$ 的子序列，因此序列中不存在环，对于所有在至少一个序列中出现的数字，这些数字中一定存在入度为 $0$ 的数字。

如果一个数字没有在任何序列中出现，则该数字的入度为 $0$，即初始时就有多个数字的入度为 $0$，超序列的第一个数字就不唯一，此时会提前返回 $\text{false}$。因此如果执行完整的拓扑排序，则 $\textit{nums}$ 中的所有数字都在至少一个序列中出现。

证明二：当执行完整的拓扑排序时，得到的超序列的长度为 $n$。

由于序列中不存在环，因此当完整的拓扑排序结束时，所有在至少一个序列中出现过的数字都在超序列中。由于执行完整的拓扑排序意味着 $\textit{nums}$ 中的所有数字都在至少一个序列中出现，因此 $\textit{nums}$ 中的所有数字都在超序列中，即超序列的长度为 $n$。

综上所述，当完整的拓扑排序结束时，$\textit{nums}$ 是唯一的最短超序列。

**代码**

```Python [sol1-Python3]
class Solution:
    def sequenceReconstruction(self, nums: List[int], sequences: List[List[int]]) -> bool:
        n = len(nums)
        g = [[] for _ in range(n)]
        inDeg = [0] * n
        for sequence in sequences:
            for x, y in pairwise(sequence):
                g[x - 1].append(y - 1)
                inDeg[y - 1] += 1

        q = deque([i for i, d in enumerate(inDeg) if d == 0])
        while q:
            if len(q) > 1:
                return False
            x = q.popleft()
            for y in g[x]:
                inDeg[y] -= 1
                if inDeg[y] == 0:
                    q.append(y)
        return True
```

```Java [sol1-Java]
class Solution {
    public boolean sequenceReconstruction(int[] nums, int[][] sequences) {
        int n = nums.length;
        int[] indegrees = new int[n + 1];
        Set<Integer>[] graph = new Set[n + 1];
        for (int i = 1; i <= n; i++) {
            graph[i] = new HashSet<Integer>();
        }
        for (int[] sequence : sequences) {
            int size = sequence.length;
            for (int i = 1; i < size; i++) {
                int prev = sequence[i - 1], next = sequence[i];
                if (graph[prev].add(next)) {
                    indegrees[next]++;
                }
            }
        }
        Queue<Integer> queue = new ArrayDeque<Integer>();
        for (int i = 1; i <= n; i++) {
            if (indegrees[i] == 0) {
                queue.offer(i);
            }
        }
        while (!queue.isEmpty()) {
            if (queue.size() > 1) {
                return false;
            }
            int num = queue.poll();
            Set<Integer> set = graph[num];
            for (int next : set) {
                indegrees[next]--;
                if (indegrees[next] == 0) {
                    queue.offer(next);
                }
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool SequenceReconstruction(int[] nums, int[][] sequences) {
        int n = nums.Length;
        int[] indegrees = new int[n + 1];
        ISet<int>[] graph = new ISet<int>[n + 1];
        for (int i = 1; i <= n; i++) {
            graph[i] = new HashSet<int>();
        }
        foreach (int[] sequence in sequences) {
            int size = sequence.Length;
            for (int i = 1; i < size; i++) {
                int prev = sequence[i - 1], next = sequence[i];
                if (graph[prev].Add(next)) {
                    indegrees[next]++;
                }
            }
        }
        Queue<int> queue = new Queue<int>();
        for (int i = 1; i <= n; i++) {
            if (indegrees[i] == 0) {
                queue.Enqueue(i);
            }
        }
        while (queue.Count > 0) {
            if (queue.Count > 1) {
                return false;
            }
            int num = queue.Dequeue();
            ISet<int> set = graph[num];
            foreach (int next in set) {
                indegrees[next]--;
                if (indegrees[next] == 0) {
                    queue.Enqueue(next);
                }
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool sequenceReconstruction(vector<int>& nums, vector<vector<int>>& sequences) {
        int n = nums.size();
        vector<int> indegrees(n + 1);
        vector<unordered_set<int>> graph(n + 1);
        for (auto &sequence : sequences) {
            for (int i = 1; i < sequence.size(); i++) {
                int prev = sequence[i - 1], next = sequence[i];
                if (!graph[prev].count(next)) {
                    graph[prev].emplace(next);
                    indegrees[next]++;
                }
            }
        }
        queue<int> qu;
        for (int i = 1; i <= n; i++) {
            if (indegrees[i] == 0) {
                qu.emplace(i);
            }
        }
        while (!qu.empty()) {
            if (qu.size() > 1) {
                return false;
            }
            int num = qu.front();
            qu.pop();
            for (int next : graph[num]) {
                indegrees[next]--;
                if (indegrees[next] == 0) {
                    qu.emplace(next);
                }
            }
        }
        return true;
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

bool sequenceReconstruction(int* nums, int numsSize, int** sequences, int sequencesSize, int* sequencesColSize){
    int n = numsSize;
    int *indegrees = (int *)malloc(sizeof(int) * (n + 1));
    HashItem **graph = (HashItem **)malloc(sizeof(HashItem *) * (n + 1));
    memset(indegrees, 0, sizeof(int) * (n + 1));
    for (int i = 0; i <= n; i++) {
        graph[i] = NULL;
    }
    for (int j = 0; j < sequencesSize; j++) {
        for (int i = 1; i < sequencesColSize[j]; i++) {
            int prev = sequences[j][i - 1], next = sequences[j][i];
            HashItem *pEntry = NULL;
            HASH_FIND_INT(graph[prev], &next, pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = next;
                HASH_ADD_INT(graph[prev], key, pEntry);
                indegrees[next]++;
            }
        }
    }
    int *queue = (int *)malloc(sizeof(int) * n);
    int head = 0, tail = 0;
    for (int i = 1; i <= n; i++) {
        if (indegrees[i] == 0) {
            queue[tail++] = i;
        }
    }
    while (head != tail) {
        if ((tail - head) > 1) {
            free(queue);
            return false;
        }
        int num = queue[head++];
        for (HashItem *pEntry = graph[num]; pEntry != NULL; pEntry = pEntry->hh.next) {
            int next = pEntry->key;
            indegrees[next]--;
            if (indegrees[next] == 0) {
                queue[tail++] = next;
            }
        }
    }
    free(queue);
    return true;
}
```

```go [sol1-Golang]
func sequenceReconstruction(nums []int, sequences [][]int) bool {
    n := len(nums)
    g := make([][]int, n+1)
    inDeg := make([]int, n+1)
    for _, sequence := range sequences {
        for i := 1; i < len(sequence); i++ {
            x, y := sequence[i-1], sequence[i]
            g[x] = append(g[x], y)
            inDeg[y]++
        }
    }

    q := []int{}
    for i := 1; i <= n; i++ {
        if inDeg[i] == 0 {
            q = append(q, i)
        }
    }
    for len(q) > 0 {
        if len(q) > 1 {
            return false
        }
        x := q[0]
        q = q[1:]
        for _, y := range g[x] {
            if inDeg[y]--; inDeg[y] == 0 {
                q = append(q, y)
            }
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var sequenceReconstruction = function(nums, sequences) {
    const n = nums.length;
    const indegrees = new Array(n + 1).fill(0);
    const graph = new Array(n + 1).fill(0).map(() => new Set());
    for (const sequence of sequences) {
        const size = sequence.length;
        for (let i = 1; i < size; i++) {
            const prev = sequence[i - 1], next = sequence[i];
            if (graph[prev].add(next)) {
                indegrees[next]++;
            }
        }
    }
    const queue = [];
    for (let i = 1; i <= n; i++) {
        if (indegrees[i] === 0) {
            queue.push(i);
        }
    }
    while (queue.length) {
        if (queue.length > 1) {
            return false;
        }
        const num = queue.shift();
        const set = graph[num];
        for (const next of set) {
            indegrees[next]--;
            if (indegrees[next] === 0) {
                queue.push(next);
            }
        }
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是 $\textit{sequences}$ 中的所有序列长度之和。建图和拓扑排序都需要 $O(n + m)$ 的时间。

- 空间复杂度：$O(n + m)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是 $\textit{sequences}$ 中的所有序列长度之和。需要 $O(n + m)$ 的空间存储图信息，需要 $O(n)$ 的空间存储每个结点的入度，拓扑排序过程中队列空间是 $O(n)$。