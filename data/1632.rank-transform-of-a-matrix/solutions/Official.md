#### 方法一：并查集 + 拓扑排序

**思路**

根据题意，同一行的元素中，相同的元素秩相同；同一列的元素中，相同的元素秩相同。可以根据这两条性质，利用并查集将秩相同的元素进行合并操作。合并之后，只需求出某个集合里一个元素（集合根）的秩，即可将其赋给这个集合里所有元素的秩。合并时，只需将每行（或每列）按照元素的值进行分类，用哈希表暂时保存，键值对分别是元素值和下标数组，然后将值相同的元素进行合并。下标数组长度为 $k$ 时，仅需进行 $(k-1)$ 次合并，即对下标数组中 $(k-1)$ 个相邻的下标对进行合并即可，这样的合并操作可以使 $k$ 个下标均在同一个集合中。

按照各行中相同的元素和各列中相同的元素进行合并后，需要求出各个集合的秩。根据题目的条件，每行（或每列）中，元素大的秩大，元素小的秩小。题目又要求秩尽可能小。因此，需要先求出值小的集合的秩，并尽可能赋一个小的秩，再根据大小关系去求值大的集合的秩。求秩的顺序可以按照拓扑排序，将同行同列的大小关系用单向边表示，值小的集合会有一条单向边指向值大的集合。建图时，将每行每列的元素进行去重排序，如果有 $k$ 个不重复元素，只需建立 $(k-1)$ 条单向边，即可表示出大小关系。所有入度为 $0$ 的集合的秩都赋为 $1$，其他的集合，秩取为指向该集合的所有集合的秩的最大值加 $1$，既满足大小关系，又满足秩需要尽可能小。这样下来，可以保证拓扑排序一定有通路，所有集合的秩都可以计算出来。最后每个元素的秩即为它所在的集合的秩。

**代码**

```Python [sol1-Python3]
class Solution:
    def matrixRankTransform(self, matrix: List[List[int]]) -> List[List[int]]:
        m, n = len(matrix), len(matrix[0])
        uf = UnionFind(m, n)
        for i, row in enumerate(matrix):
            num2indexList = defaultdict(list)
            for j, num in enumerate(row):
                num2indexList[num].append([i, j])
            for indexList in num2indexList.values():
                i1, j1 = indexList[0]
                for k in range(1, len(indexList)):
                    i2, j2 = indexList[k]
                    uf.union(i1, j1, i2, j2)
        for j in range(n):
            num2indexList = defaultdict(list)
            for i in range(m):
                num2indexList[matrix[i][j]].append([i, j])
            for indexList in num2indexList.values():
                i1, j1 = indexList[0]
                for k in range(1, len(indexList)):
                    i2, j2 = indexList[k]
                    uf.union(i1, j1, i2, j2)

        degree = Counter()
        adj = defaultdict(list)
        for i, row in enumerate(matrix):
            num2index = {}
            for j, num in enumerate(row):
                num2index[num] = (i, j)
            sortedArray = sorted(num2index.keys())
            for k in range(1, len(sortedArray)):
                i1, j1 = num2index[sortedArray[k - 1]]
                i2, j2 = num2index[sortedArray[k]]
                ri1, rj1 = uf.find(i1, j1)
                ri2, rj2 = uf.find(i2, j2)
                degree[(ri2, rj2)] += 1
                adj[(ri1, rj1)].append([ri2, rj2])
        for j in range(n):
            num2index = {}
            for i in range(m):
                num = matrix[i][j]
                num2index[num] = (i, j)
            sortedArray = sorted(num2index.keys())
            for k in range(1, len(sortedArray)):
                i1, j1 = num2index[sortedArray[k - 1]]
                i2, j2 = num2index[sortedArray[k]]
                ri1, rj1 = uf.find(i1, j1)
                ri2, rj2 = uf.find(i2, j2)
                degree[(ri2, rj2)] += 1
                adj[(ri1, rj1)].append([ri2, rj2])
        
        rootSet = set()
        ranks = {}
        for i in range(m):
            for j in range(n):
                ri, rj = uf.find(i, j)
                rootSet.add((ri, rj))
                ranks[(ri, rj)] = 1
        q = deque([[i, j] for i, j in rootSet if degree[(i, j)] == 0])
        while q:
            i, j = q.popleft()
            for ui, uj in adj[(i, j)]:
                degree[(ui, uj)] -= 1
                if degree[(ui, uj)] == 0:
                    q.append([ui, uj])
                ranks[(ui, uj)] = max(ranks[(ui, uj)], ranks[(i, j)] + 1)
        res = [[1] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                ri, rj = uf.find(i, j)
                res[i][j] = ranks[(ri, rj)]
        return res

class UnionFind:
    def __init__(self, m, n):
        self.m = m
        self.n = n
        self.root = [[[i, j] for j in range(n)] for i in range(m)]
        self.size = [[1] * n for _ in range(m)]

    def find(self, i, j):
        ri, rj = self.root[i][j]
        if [ri, rj] == [i, j]:
            return [i, j]
        self.root[i][j] = self.find(ri, rj)
        return self.root[i][j]

    def union(self, i1, j1, i2, j2):
        ri1, rj1 = self.find(i1, j1)
        ri2, rj2 = self.find(i2, j2)
        if [ri1, rj1] != [ri2, rj2]:
            if self.size[ri1][rj1] >= self.size[ri2][rj2]:
                self.root[ri2][rj2] = [ri1, rj1]
                self.size[ri1][rj1] += self.size[ri2][rj2]
            else:
                self.root[ri1][rj1] = [ri2, rj2]
                self.size[ri2][rj2] += self.size[ri1][rj1]
```

```Java [sol1-Java]
class Solution {
    public int[][] matrixRankTransform(int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        UnionFind uf = new UnionFind(m, n);
        for (int i = 0; i < m; i++) {
            Map<Integer, List<int[]>> num2indexList = new HashMap<Integer, List<int[]>>();
            for (int j = 0; j < n; j++) {
                int num = matrix[i][j];
                num2indexList.putIfAbsent(num, new ArrayList<int[]>());
                num2indexList.get(num).add(new int[]{i, j});
            }
            for (List<int[]> indexList : num2indexList.values()) {
                int[] arr1 = indexList.get(0);
                int i1 = arr1[0], j1 = arr1[1];
                for (int k = 1; k < indexList.size(); k++) {
                    int[] arr2 = indexList.get(k);
                    int i2 = arr2[0], j2 = arr2[1];
                    uf.union(i1, j1, i2, j2);
                }
            }
        }
        for (int j = 0; j < n; j++) {
            Map<Integer, List<int[]>> num2indexList = new HashMap<Integer, List<int[]>>();
            for (int i = 0; i < m; i++) {
                int num = matrix[i][j];
                num2indexList.putIfAbsent(num, new ArrayList<int[]>());
                num2indexList.get(num).add(new int[]{i, j});
            }
            for (List<int[]> indexList : num2indexList.values()) {
                int[] arr1 = indexList.get(0);
                int i1 = arr1[0], j1 = arr1[1];
                for (int k = 1; k < indexList.size(); k++) {
                    int[] arr2 = indexList.get(k);
                    int i2 = arr2[0], j2 = arr2[1];
                    uf.union(i1, j1, i2, j2);
                }
            }
        }

        int[][] degree = new int[m][n];
        Map<Integer, List<int[]>> adj = new HashMap<Integer, List<int[]>>();
        for (int i = 0; i < m; i++) {
            Map<Integer, int[]> num2index = new HashMap<Integer, int[]>();
            for (int j = 0; j < n; j++) {
                int num = matrix[i][j];
                num2index.put(num, new int[]{i, j});
            }
            List<Integer> sortedArray = new ArrayList<Integer>(num2index.keySet());
            Collections.sort(sortedArray);
            for (int k = 1; k < sortedArray.size(); k++) {
                int[] prev = num2index.get(sortedArray.get(k - 1));
                int[] curr = num2index.get(sortedArray.get(k));
                int i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
                int[] root1 = uf.find(i1, j1);
                int[] root2 = uf.find(i2, j2);
                int ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
                degree[ri2][rj2]++;
                adj.putIfAbsent(ri1 * n + rj1, new ArrayList<int[]>());
                adj.get(ri1 * n + rj1).add(new int[]{ri2, rj2});
            }
        }
        for (int j = 0; j < n; j++) {
            Map<Integer, int[]> num2index = new HashMap<Integer, int[]>();
            for (int i = 0; i < m; i++) {
                int num = matrix[i][j];
                num2index.put(num, new int[]{i, j});
            }
            List<Integer> sortedArray = new ArrayList<Integer>(num2index.keySet());
            Collections.sort(sortedArray);
            for (int k = 1; k < sortedArray.size(); k++) {
                int[] prev = num2index.get(sortedArray.get(k - 1));
                int[] curr = num2index.get(sortedArray.get(k));
                int i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
                int[] root1 = uf.find(i1, j1);
                int[] root2 = uf.find(i2, j2);
                int ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
                degree[ri2][rj2]++;
                adj.putIfAbsent(ri1 * n + rj1, new ArrayList<int[]>());
                adj.get(ri1 * n + rj1).add(new int[]{ri2, rj2});
            }
        }

        Set<Integer> rootSet = new HashSet<Integer>();
        int[][] ranks = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int[] rootArr = uf.find(i, j);
                int ri = rootArr[0], rj = rootArr[1];
                rootSet.add(ri * n + rj);
                ranks[ri][rj] = 1;
            }
        }
        Queue<int[]> queue = new ArrayDeque<int[]>();
        for (int val : rootSet) {
            if (degree[val / n][val % n] == 0) {
                queue.offer(new int[]{val / n, val % n});
            }
        }
        while (!queue.isEmpty()) {
            int[] arr = queue.poll();
            int i = arr[0], j = arr[1];
            for (int[] adjArr : adj.getOrDefault(i * n + j, new ArrayList<int[]>())) {
                int ui = adjArr[0], uj = adjArr[1];
                degree[ui][uj]--;
                if (degree[ui][uj] == 0) {
                    queue.offer(new int[]{ui, uj});
                }
                ranks[ui][uj] = Math.max(ranks[ui][uj], ranks[i][j] + 1);
            }
        }
        int[][] res = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int[] rootArr = uf.find(i, j);
                int ri = rootArr[0], rj = rootArr[1];
                res[i][j] = ranks[ri][rj];
            }
        }
        return res;
    }
}

class UnionFind {
    int m, n;
    int[][][] root;
    int[][] size;

    public UnionFind(int m, int n) {
        this.m = m;
        this.n = n;
        this.root = new int[m][n][2];
        this.size = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                root[i][j][0] = i;
                root[i][j][1] = j;
                size[i][j] = 1;
            }
        }
    }

    public int[] find(int i, int j) {
        int[] rootArr = root[i][j];
        int ri = rootArr[0], rj = rootArr[1];
        if (ri == i && rj == j) {
            return rootArr;
        }
        return find(ri, rj);
    }

    public void union(int i1, int j1, int i2, int j2) {
        int[] rootArr1 = find(i1, j1);
        int[] rootArr2 = find(i2, j2);
        int ri1 = rootArr1[0], rj1 = rootArr1[1];
        int ri2 = rootArr2[0], rj2 = rootArr2[1];
        if (ri1 != ri2 || rj1 != rj2) {
            if (size[ri1][rj1] >= size[ri2][rj2]) {
                root[ri2][rj2][0] = ri1;
                root[ri2][rj2][1] = rj1;
                size[ri1][rj1] += size[ri2][rj2];
            } else {
                root[ri1][rj1][0] = ri2;
                root[ri1][rj1][1] = rj2;
                size[ri2][rj2] += size[ri1][rj1];
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] MatrixRankTransform(int[][] matrix) {
        int m = matrix.Length, n = matrix[0].Length;
        UnionFind uf = new UnionFind(m, n);
        for (int i = 0; i < m; i++) {
            IDictionary<int, IList<int[]>> num2indexList = new Dictionary<int, IList<int[]>>();
            for (int j = 0; j < n; j++) {
                int num = matrix[i][j];
                num2indexList.TryAdd(num, new List<int[]>());
                num2indexList[num].Add(new int[]{i, j});
            }
            foreach (IList<int[]> indexList in num2indexList.Values) {
                int[] arr1 = indexList[0];
                int i1 = arr1[0], j1 = arr1[1];
                for (int k = 1; k < indexList.Count; k++) {
                    int[] arr2 = indexList[k];
                    int i2 = arr2[0], j2 = arr2[1];
                    uf.Union(i1, j1, i2, j2);
                }
            }
        }
        for (int j = 0; j < n; j++) {
            IDictionary<int, IList<int[]>> num2indexList = new Dictionary<int, IList<int[]>>();
            for (int i = 0; i < m; i++) {
                int num = matrix[i][j];
                num2indexList.TryAdd(num, new List<int[]>());
                num2indexList[num].Add(new int[]{i, j});
            }
            foreach (IList<int[]> indexList in num2indexList.Values) {
                int[] arr1 = indexList[0];
                int i1 = arr1[0], j1 = arr1[1];
                for (int k = 1; k < indexList.Count; k++) {
                    int[] arr2 = indexList[k];
                    int i2 = arr2[0], j2 = arr2[1];
                    uf.Union(i1, j1, i2, j2);
                }
            }
        }

        int[][] degree = new int[m][];
        for (int i = 0; i < m; i++) {
            degree[i] = new int[n];
        }
        IDictionary<int, IList<int[]>> adj = new Dictionary<int, IList<int[]>>();
        for (int i = 0; i < m; i++) {
            IDictionary<int, int[]> num2index = new Dictionary<int, int[]>();
            for (int j = 0; j < n; j++) {
                int num = matrix[i][j];
                if (!num2index.ContainsKey(num)) {
                    num2index.Add(num, new int[]{i, j});
                } else {
                    num2index[num] = new int[]{i, j};
                }
            }
            IList<int> sortedArray = new List<int>(num2index.Keys);
            ((List<int>) sortedArray).Sort();
            for (int k = 1; k < sortedArray.Count; k++) {
                int[] prev = num2index[sortedArray[k - 1]];
                int[] curr = num2index[sortedArray[k]];
                int i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
                int[] root1 = uf.Find(i1, j1);
                int[] root2 = uf.Find(i2, j2);
                int ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
                degree[ri2][rj2]++;
                adj.TryAdd(ri1 * n + rj1, new List<int[]>());
                adj[ri1 * n + rj1].Add(new int[]{ri2, rj2});
            }
        }
        for (int j = 0; j < n; j++) {
            IDictionary<int, int[]> num2index = new Dictionary<int, int[]>();
            for (int i = 0; i < m; i++) {
                int num = matrix[i][j];
                if (!num2index.ContainsKey(num)) {
                    num2index.Add(num, new int[]{i, j});
                } else {
                    num2index[num] = new int[]{i, j};
                }
            }
            IList<int> sortedArray = new List<int>(num2index.Keys);
            ((List<int>) sortedArray).Sort();
            for (int k = 1; k < sortedArray.Count; k++) {
                int[] prev = num2index[sortedArray[k - 1]];
                int[] curr = num2index[sortedArray[k]];
                int i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
                int[] root1 = uf.Find(i1, j1);
                int[] root2 = uf.Find(i2, j2);
                int ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
                degree[ri2][rj2]++;
                adj.TryAdd(ri1 * n + rj1, new List<int[]>());
                adj[ri1 * n + rj1].Add(new int[]{ri2, rj2});
            }
        }

        ISet<int> rootSet = new HashSet<int>();
        int[][] ranks = new int[m][];
        for (int i = 0; i < m; i++) {
            ranks[i] = new int[n];
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int[] rootArr = uf.Find(i, j);
                int ri = rootArr[0], rj = rootArr[1];
                rootSet.Add(ri * n + rj);
                ranks[ri][rj] = 1;
            }
        }
        Queue<int[]> queue = new Queue<int[]>();
        foreach (int val in rootSet) {
            if (degree[val / n][val % n] == 0) {
                queue.Enqueue(new int[]{val / n, val % n});
            }
        }
        while (queue.Count > 0) {
            int[] arr = queue.Dequeue();
            int i = arr[0], j = arr[1];
            if (!adj.ContainsKey(i * n + j)) {
                continue;
            }
            foreach (int[] adjArr in adj[i * n + j]) {
                int ui = adjArr[0], uj = adjArr[1];
                degree[ui][uj]--;
                if (degree[ui][uj] == 0) {
                    queue.Enqueue(new int[]{ui, uj});
                }
                ranks[ui][uj] = Math.Max(ranks[ui][uj], ranks[i][j] + 1);
            }
        }
        int[][] res = new int[m][];
        for (int i = 0; i < m; i++) {
            res[i] = new int[n];
            for (int j = 0; j < n; j++) {
                int[] rootArr = uf.Find(i, j);
                int ri = rootArr[0], rj = rootArr[1];
                res[i][j] = ranks[ri][rj];
            }
        }
        return res;
    }
}

class UnionFind {
    int m, n;
    int[][][] root;
    int[][] size;

    public UnionFind(int m, int n) {
        this.m = m;
        this.n = n;
        this.root = new int[m][][];
        this.size = new int[m][];
        for (int i = 0; i < m; i++) {
            root[i] = new int[n][];
            for (int j = 0; j < n; j++) {
                root[i][j] = new int[2];
            }
            size[i] = new int[n];
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                root[i][j][0] = i;
                root[i][j][1] = j;
                size[i][j] = 1;
            }
        }
    }

    public int[] Find(int i, int j) {
        int[] rootArr = root[i][j];
        int ri = rootArr[0], rj = rootArr[1];
        if (ri == i && rj == j) {
            return rootArr;
        }
        return Find(ri, rj);
    }

    public void Union(int i1, int j1, int i2, int j2) {
        int[] rootArr1 = Find(i1, j1);
        int[] rootArr2 = Find(i2, j2);
        int ri1 = rootArr1[0], rj1 = rootArr1[1];
        int ri2 = rootArr2[0], rj2 = rootArr2[1];
        if (ri1 != ri2 || rj1 != rj2) {
            if (size[ri1][rj1] >= size[ri2][rj2]) {
                root[ri2][rj2][0] = ri1;
                root[ri2][rj2][1] = rj1;
                size[ri1][rj1] += size[ri2][rj2];
            } else {
                root[ri1][rj1][0] = ri2;
                root[ri1][rj1][1] = rj2;
                size[ri2][rj2] += size[ri1][rj1];
            }
        }
    }
}
```

```C++ [sol1-C++]
typedef pair<int, int> pii;

class UnionFind {
    int m, n;
    vector<vector<pii>> root;
    vector<vector<int>> size;

public:
    UnionFind(int m, int n) {
        this->m = m;
        this->n = n;
        this->root = vector<vector<pii>>(m, vector<pii>(n));
        this->size = vector<vector<int>>(m, vector<int>(n));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                root[i][j] = make_pair(i, j);
                size[i][j] = 1;
            }
        }
    }

    pii find(int i, int j) {
        pii rootArr = root[i][j];
        int ri = rootArr.first, rj = rootArr.second;
        if (ri == i && rj == j) {
            return rootArr;
        }
        return find(ri, rj);
    }

    void Uni(int i1, int j1, int i2, int j2) {
        auto [ri1, rj1] = find(i1, j1);
        auto [ri2, rj2] = find(i2, j2);
        if (ri1 != ri2 || rj1 != rj2) {
            if (size[ri1][rj1] >= size[ri2][rj2]) {
                root[ri2][rj2] = make_pair(ri1, rj1);
                size[ri1][rj1] += size[ri2][rj2];
            } else {
                root[ri1][rj1] = make_pair(ri2, rj2);
                size[ri2][rj2] += size[ri1][rj1];
            }
        }
    }
};

class Solution {
public:
    vector<vector<int>> matrixRankTransform(vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        UnionFind uf(m, n);
        for (int i = 0; i < m; i++) {
            unordered_map<int, vector<pii>> num2indexList;
            for (int j = 0; j < n; j++) {
                num2indexList[matrix[i][j]].emplace_back(i, j);
            }
            for (auto [_, indexList] : num2indexList) {
                auto [i1, j1] = indexList[0];
                for (int k = 1; k < indexList.size(); k++) {
                    auto [i2, j2] = indexList[k];
                    uf.Uni(i1, j1, i2, j2);
                }
            }
        }
        for (int j = 0; j < n; j++) {
            unordered_map<int, vector<pii>> num2indexList;
            for (int i = 0; i < m; i++) {
                num2indexList[matrix[i][j]].emplace_back(i, j);
            }
            for (auto [_, indexList] : num2indexList) {
                auto [i1, j1] = indexList[0];
                for (int k = 1; k < indexList.size(); k++) {
                    auto [i2, j2] = indexList[k];
                    uf.Uni(i1, j1, i2, j2);
                }
            }
        }

        vector<vector<int>> degree(m, vector<int>(n));
        unordered_map<int, vector<pii>> adj;
        for (int i = 0; i < m; i++) {
            unordered_map<int, pii> num2index;
            for (int j = 0; j < n; j++) {
                num2index[matrix[i][j]] = make_pair(i, j);
            }
            vector<int> sortedArray;
            for (auto [key, _] : num2index) {
                sortedArray.emplace_back(key);
            }
            sort(sortedArray.begin(), sortedArray.end());
            for (int k = 1; k < sortedArray.size(); k++) {
                auto [i1, j1] = num2index[sortedArray[k - 1]];
                auto [i2, j2] = num2index[sortedArray[k]];
                auto [ri1, rj1] = uf.find(i1, j1);
                auto [ri2, rj2] = uf.find(i2, j2);
                degree[ri2][rj2]++;
                adj[ri1 * n + rj1].emplace_back(ri2, rj2);
            }
        }
        for (int j = 0; j < n; j++) {
            unordered_map<int, pii> num2index;
            for (int i = 0; i < m; i++) {
                num2index[matrix[i][j]] = make_pair(i, j);
            }
            vector<int> sortedArray;
            for (auto [key, _] : num2index) {
                sortedArray.emplace_back(key);
            }
            sort(sortedArray.begin(), sortedArray.end());
            for (int k = 1; k < sortedArray.size(); k++) {
                auto [i1, j1] = num2index[sortedArray[k - 1]];
                auto [i2, j2] = num2index[sortedArray[k]];
                auto [ri1, rj1] = uf.find(i1, j1);
                auto [ri2, rj2] = uf.find(i2, j2);
                degree[ri2][rj2]++;
                adj[ri1 * n + rj1].emplace_back(ri2, rj2);
            }
        }

        unordered_set<int> rootSet;
        vector<vector<int>> ranks(m, vector<int>(n));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                auto [ri, rj] = uf.find(i, j);
                rootSet.emplace(ri * n + rj);
                ranks[ri][rj] = 1;
            }
        }
        queue<pii> q;
        for (int val : rootSet) {
            if (degree[val / n][val % n] == 0) {
                q.emplace(val / n, val % n);
            }
        }
        while (!q.empty()) {
            auto [i, j] = q.front();
            q.pop();
            for (auto [ui, uj] : adj[i * n + j]) {
                degree[ui][uj]--;
                if (degree[ui][uj] == 0) {
                    q.emplace(ui, uj);
                }
                ranks[ui][uj] = max(ranks[ui][uj], ranks[i][j] + 1);
            }
        }
        vector<vector<int>> res(m, vector<int>(n));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                auto [ri, rj] = uf.find(i, j);
                res[i][j] = ranks[ri][rj];
            }
        }
        return res;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct {
    int key;
    struct ListNode *val;
    UT_hash_handle hh;
} HashItem; 

struct ListNode *creatListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    struct ListNode *node = creatListNode(val);
    HashItem *pEntry = hashFindItem(obj, key);
    if (pEntry != NULL) {
        node->next = pEntry->val;
        pEntry->val = node;
    } else {
        HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->val = node;
        HASH_ADD_INT(*obj, key, pEntry);
    }
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        for (struct ListNode *node = curr->val; node;) {
            struct ListNode *pre = node;
            node = node->next;
            free(pre);
        }
        free(curr);             
    }
}

typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashMapItem; 

HashMapItem *hashMapFindItem(HashMapItem **obj, int key) {
    HashMapItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashMapAddItem(HashMapItem **obj, int key, int val) {
    HashMapItem *pEntry = hashMapFindItem(obj, key);
    if (pEntry) {
        pEntry->val = val;
    } else {
        pEntry = (HashMapItem *)malloc(sizeof(HashMapItem));
        pEntry->key = key;
        pEntry->val = val;
        HASH_ADD_INT(*obj, key, pEntry);
    }
    return true;
}

int hashMapGetItem(HashMapItem **obj, int key, int defaultVal) {
    HashMapItem *pEntry = hashMapFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashMapFree(HashMapItem **obj) {
    HashMapItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr); 
        free(curr);             
    }
}

typedef struct {
    int *root;
    int *size;
} UnionFind;

UnionFind *creatUnionFind(int n) {
    UnionFind *obj = (UnionFind *)malloc(sizeof(UnionFind));
    obj->root = (int *)malloc(sizeof(int) * n);
    obj->size = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        obj->root[i] = i;
        obj->size[i] = 1;
    }
    return obj;
}

int find(const UnionFind * obj, int x) {
    if (obj->root[x] != x) {
        obj->root[x] = find(obj, obj->root[x]);
    }
    return obj->root[x];
}

void uni(UnionFind * obj, int x, int y) {
    int rootx = find(obj, x);
    int rooty = find(obj, y);
    if (rootx != rooty) {
        if (obj->size[rootx] >= obj->size[rooty]) {
            obj->root[rooty] = rootx;
            obj->size[rootx] += obj->size[rooty];
        } else {
            obj->root[rootx] = rooty;
            obj->size[rooty] += obj->size[rootx];
        }
    }
}

static int cmp(const void *pa, const void *pb) {
    return *(int *)pa  - *(int *)pb;
}

int** matrixRankTransform(int** matrix, int matrixSize, int* matrixColSize, int* returnSize, int** returnColumnSizes) {
    int m = matrixSize, n = matrixColSize[0];
    UnionFind *uf = creatUnionFind(m * n);
    for (int i = 0; i < m; i++) {
        HashItem *num2indexList = NULL;
        for (int j = 0; j < n; j++) {
            hashAddItem(&num2indexList, matrix[i][j], i * n + j);
        }
        for (HashItem *pEntry = num2indexList; pEntry != NULL; pEntry = pEntry->hh.next) {
            struct ListNode *list = pEntry->val;
            int x = list->val;
            for (list = list->next; list != NULL; list = list->next) {
                uni(uf, x, list->val);
            }
        }
        hashFree(&num2indexList);
    }
    for (int j = 0; j < n; j++) {
        HashItem *num2indexList = NULL;
        for (int i = 0; i < m; i++) {
            hashAddItem(&num2indexList, matrix[i][j], i * n + j);
        }
        for (HashItem *pEntry = num2indexList; pEntry != NULL; pEntry = pEntry->hh.next) {
            struct ListNode *list = pEntry->val;
            int x = list->val;
            for (list = list->next; list != NULL; list = list->next) {
                uni(uf, x, list->val);
            }
        }
        hashFree(&num2indexList);
    }

    int degree[m * n];
    memset(degree, 0, sizeof(degree));
    HashItem *adj = NULL;
    for (int i = 0; i < m; i++) {
        HashMapItem *num2index = NULL;
        for (int j = 0; j < n; j++) {
            hashMapAddItem(&num2index, matrix[i][j], i * n + j);
        }
        int len = HASH_COUNT(num2index);
        int sortedArray[len], pos = 0;
        for (HashMapItem *pEntry = num2index; pEntry != NULL; pEntry = pEntry->hh.next) {
            sortedArray[pos++] = pEntry->key;
        }
        qsort(sortedArray, len, sizeof(int), cmp);
        for (int k = 1; k < len; k++) {
            int x = hashMapGetItem(&num2index, sortedArray[k - 1], 0);
            int y = hashMapGetItem(&num2index, sortedArray[k], 0);   
            int rootx = find(uf, x);
            int rooty = find(uf, y);
            degree[rooty]++;
            hashAddItem(&adj, rootx, rooty);
        }
        hashMapFree(&num2index);
    }
    for (int j = 0; j < n; j++) {
        HashMapItem *num2index = NULL;
        for (int i = 0; i < m; i++) {
            hashMapAddItem(&num2index, matrix[i][j], i * n + j);
        }
        int len = HASH_COUNT(num2index);
        int sortedArray[len], pos = 0;
        for (HashMapItem *pEntry = num2index; pEntry != NULL; pEntry = pEntry->hh.next) {
            sortedArray[pos++] = pEntry->key;
        }       
        qsort(sortedArray, len, sizeof(int), cmp);
        for (int k = 1; k < len; k++) {
            int x = hashMapGetItem(&num2index, sortedArray[k - 1], 0);
            int y = hashMapGetItem(&num2index, sortedArray[k], 0); 
            int rootx = find(uf, x);
            int rooty = find(uf, y);
            degree[rooty]++;
            hashAddItem(&adj, rootx, rooty);
        }
        hashMapFree(&num2index);
    }

    int rootSet[m * n], ranks[m * n];
    memset(rootSet, 0, sizeof(rootSet));
    memset(ranks, 0, sizeof(ranks));
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            int x = find(uf, i * n + j);
            rootSet[x] = 1;
            ranks[x] = 1;
        }
    }
    int queue[m * n];
    int head = 0, tail = 0;
    for (int i = 0; i < m * n; i++) {
        if (degree[i] == 0) {
            queue[tail++] = i;
        }
    }
    while (head != tail) {
        int curr = queue[head++];
        HashItem *pEntry = hashFindItem(&adj, curr);
        if (pEntry) {
            for (struct ListNode *list = pEntry->val; list != NULL; list = list->next) {
                degree[list->val]--;
                if (degree[list->val] == 0) {
                    queue[tail++] = list->val;
                }
                ranks[list->val] = MAX(ranks[list->val], ranks[curr] + 1);
            }
        }
    }
    hashFree(&adj);
    int **res = (int **)malloc(sizeof(int *) * m);
    *returnSize = m;
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; i++) {
        res[i] = (int *)malloc(sizeof(int) * n);
        (*returnColumnSizes)[i] = n;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            int x = find(uf, i * n + j);
            res[i][j] = ranks[x];
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var matrixRankTransform = function(matrix) {
    const m = matrix.length, n = matrix[0].length;
    const uf = new UnionFind(m, n);
    for (let i = 0; i < m; i++) {
        const num2indexList = new Map();
        for (let j = 0; j < n; j++) {
            const num = matrix[i][j];
            if (!num2indexList.has(num)) {
                num2indexList.set(num, []);
            }
            num2indexList.get(num).push([i, j]);
        }
        for (const indexList of num2indexList.values()) {
            const arr1 = indexList[0];
            const i1 = arr1[0], j1 = arr1[1];
            for (let k = 1; k < indexList.length; k++) {
                const arr2 = indexList[k];
                const i2 = arr2[0], j2 = arr2[1];
                uf.union(i1, j1, i2, j2);
            }
        }
    }
    for (let j = 0; j < n; j++) {
        const num2indexList = new Map();
        for (let i = 0; i < m; i++) {
            const num = matrix[i][j];
            if (!num2indexList.has(num)) {
                num2indexList.set(num, []);    
            }
            
            num2indexList.get(num).push([i, j]);
        }
        for (const indexList of num2indexList.values()) {
            const arr1 = indexList[0];
            const i1 = arr1[0], j1 = arr1[1];
            for (let k = 1; k < indexList.length; k++) {
                const arr2 = indexList[k];
                const i2 = arr2[0], j2 = arr2[1];
                uf.union(i1, j1, i2, j2);
            }
        }
    }

    const degree = new Array(m).fill(0).map(() => new Array(n).fill(0));
    const adj = new Map();
    for (let i = 0; i < m; i++) {
        const num2index = new Map();
        for (let j = 0; j < n; j++) {
            const num = matrix[i][j];
            num2index.set(num, [i, j]);
        }
        const sortedArray = [...num2index.keys()];
        sortedArray.sort((a, b) => a - b);
        for (let k = 1; k < sortedArray.length; k++) {
            const prev = num2index.get(sortedArray[k - 1]);
            const curr = num2index.get(sortedArray[k]);
            const i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
            const root1 = uf.find(i1, j1);
            const root2 = uf.find(i2, j2);
            const ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
            degree[ri2][rj2]++;
            if (!adj.has(ri1 * n + rj1)) {
                adj.set(ri1 * n + rj1, []);    
            }
            adj.get(ri1 * n + rj1).push([ri2, rj2]);
        }
    }
    for (let j = 0; j < n; j++) {
        const num2index = new Map();
        for (let i = 0; i < m; i++) {
            const num = matrix[i][j];
            num2index.set(num, [i, j]);
        }
        const sortedArray = [...num2index.keys()];
        sortedArray.sort((a, b) => a - b);
        for (let k = 1; k < sortedArray.length; k++) {
            const prev = num2index.get(sortedArray[k - 1]);
            const curr = num2index.get(sortedArray[k]);
            const i1 = prev[0], j1 = prev[1], i2 = curr[0], j2 = curr[1];
            const root1 = uf.find(i1, j1);
            const root2 = uf.find(i2, j2);
            const ri1 = root1[0], rj1 = root1[1], ri2 = root2[0], rj2 = root2[1];
            degree[ri2][rj2]++;
            if (!adj.has(ri1 * n + rj1)) {
                adj.set(ri1 * n + rj1, []);
            }
            adj.get(ri1 * n + rj1).push([ri2, rj2]);
        }
    }

    const rootSet = new Set();
    const ranks = new Array(m).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            const rootArr = uf.find(i, j);
            const ri = rootArr[0], rj = rootArr[1];
            rootSet.add(ri * n + rj);
            ranks[ri][rj] = 1;
        }
    }
    const queue = [];
    for (const val of rootSet) {
        if (degree[Math.floor(val / n)][val % n] === 0) {
            queue.push([Math.floor(val / n), val % n]);
        }
    }
    while (queue.length) {
        const arr = queue.shift();
        const i = arr[0], j = arr[1];
        for (const adjArr of (adj.get(i * n + j) || [])) {
            const ui = adjArr[0], uj = adjArr[1];
            degree[ui][uj]--;
            if (degree[ui][uj] === 0) {
                queue.push([ui, uj]);
            }
            ranks[ui][uj] = Math.max(ranks[ui][uj], ranks[i][j] + 1);
        }
    }
    
    const res = new Array(m).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            const rootArr = uf.find(i, j);
            const ri = rootArr[0], rj = rootArr[1];
            res[i][j] = ranks[ri][rj];
        }
    }
    return res;
};
class UnionFind {
    constructor(m, n) {
        this.m = m;
        this.n = n;
        this.root = new Array(m).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2).fill(0)));
        this.size = new Array(m).fill(0).map(() => new Array(n).fill(0));
        for (let i = 0; i < m; i++) {
            for (let j = 0; j < n; j++) {
                this.root[i][j][0] = i;
                this.root[i][j][1] = j;
                this.size[i][j] = 1;
            }
        }
    }

    find(i, j) {
        const rootArr = this.root[i][j];
        const ri = rootArr[0], rj = rootArr[1];
        if (ri === i && rj === j) {
            return rootArr;
        }
        return this.find(ri, rj);
    }

    union(i1, j1, i2, j2) {
        const rootArr1 = this.find(i1, j1);
        const rootArr2 = this.find(i2, j2);
        const ri1 = rootArr1[0], rj1 = rootArr1[1];
        const ri2 = rootArr2[0], rj2 = rootArr2[1];
        if (ri1 !== ri2 || rj1 !== rj2) {
            if (this.size[ri1][rj1] >= this.size[ri2][rj2]) {
                this.root[ri2][rj2][0] = ri1;
                this.root[ri2][rj2][1] = rj1;
                this.size[ri1][rj1] += this.size[ri2][rj2];
            } else {
                this.root[ri1][rj1][0] = ri2;
                this.root[ri1][rj1][1] = rj2;
                this.size[ri2][rj2] += this.size[ri1][rj1];
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times (\log m + \log n))$。并查集的合并次数是 $O(m \times n)$，用到了路径压缩和按大小合并的优化。建图的复杂度为 $O(m \times n \times (\log m + \log n))$，拓扑排序的复杂度为 $O(m \times n)$。

- 空间复杂度：$O(m \times n)$。并查集的空间复杂度为 $O(m \times n)$，建图的空间复杂度为 $O(m \times n)$，拓扑排序的空间复杂度为 $O(m \times n)$。