#### 方法一：广度优先搜索

我们可以将整个问题建模成一张图：给定图中的一些点（变量），以及某些边的权值（两个变量的比值），试对任意两点（两个变量）求出其路径长（两个变量的比值）。

因此，我们首先需要遍历 $\textit{equations}$ 数组，找出其中所有不同的字符串，并通过哈希表将每个不同的字符串映射成整数。

在构建完图之后，对于任何一个查询，就可以从起点出发，通过广度优先搜索的方式，不断更新起点与当前点之间的路径长度，直到搜索到终点为止。

```C++ [sol1-C++]
class Solution {
public:
    vector<double> calcEquation(vector<vector<string>>& equations, vector<double>& values, vector<vector<string>>& queries) {
        int nvars = 0;
        unordered_map<string, int> variables;

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (variables.find(equations[i][0]) == variables.end()) {
                variables[equations[i][0]] = nvars++;
            }
            if (variables.find(equations[i][1]) == variables.end()) {
                variables[equations[i][1]] = nvars++;
            }
        }

        // 对于每个点，存储其直接连接到的所有点及对应的权值
        vector<vector<pair<int, double>>> edges(nvars);
        for (int i = 0; i < n; i++) {
            int va = variables[equations[i][0]], vb = variables[equations[i][1]];
            edges[va].push_back(make_pair(vb, values[i]));
            edges[vb].push_back(make_pair(va, 1.0 / values[i]));
        }

        vector<double> ret;
        for (const auto& q: queries) {
            double result = -1.0;
            if (variables.find(q[0]) != variables.end() && variables.find(q[1]) != variables.end()) {
                int ia = variables[q[0]], ib = variables[q[1]];
                if (ia == ib) {
                    result = 1.0;
                } else {
                    queue<int> points;
                    points.push(ia);
                    vector<double> ratios(nvars, -1.0);
                    ratios[ia] = 1.0;

                    while (!points.empty() && ratios[ib] < 0) {
                        int x = points.front();
                        points.pop();

                        for (const auto [y, val]: edges[x]) {
                            if (ratios[y] < 0) {
                                ratios[y] = ratios[x] * val;
                                points.push(y);
                            }
                        }
                    }
                    result = ratios[ib];
                }
            }
            ret.push_back(result);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public double[] calcEquation(List<List<String>> equations, double[] values, List<List<String>> queries) {
        int nvars = 0;
        Map<String, Integer> variables = new HashMap<String, Integer>();

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (!variables.containsKey(equations.get(i).get(0))) {
                variables.put(equations.get(i).get(0), nvars++);
            }
            if (!variables.containsKey(equations.get(i).get(1))) {
                variables.put(equations.get(i).get(1), nvars++);
            }
        }

        // 对于每个点，存储其直接连接到的所有点及对应的权值
        List<Pair>[] edges = new List[nvars];
        for (int i = 0; i < nvars; i++) {
            edges[i] = new ArrayList<Pair>();
        }
        for (int i = 0; i < n; i++) {
            int va = variables.get(equations.get(i).get(0)), vb = variables.get(equations.get(i).get(1));
            edges[va].add(new Pair(vb, values[i]));
            edges[vb].add(new Pair(va, 1.0 / values[i]));
        }

        int queriesCount = queries.size();
        double[] ret = new double[queriesCount];
        for (int i = 0; i < queriesCount; i++) {
            List<String> query = queries.get(i);
            double result = -1.0;
            if (variables.containsKey(query.get(0)) && variables.containsKey(query.get(1))) {
                int ia = variables.get(query.get(0)), ib = variables.get(query.get(1));
                if (ia == ib) {
                    result = 1.0;
                } else {
                    Queue<Integer> points = new LinkedList<Integer>();
                    points.offer(ia);
                    double[] ratios = new double[nvars];
                    Arrays.fill(ratios, -1.0);
                    ratios[ia] = 1.0;

                    while (!points.isEmpty() && ratios[ib] < 0) {
                        int x = points.poll();
                        for (Pair pair : edges[x]) {
                            int y = pair.index;
                            double val = pair.value;
                            if (ratios[y] < 0) {
                                ratios[y] = ratios[x] * val;
                                points.offer(y);
                            }
                        }
                    }
                    result = ratios[ib];
                }
            }
            ret[i] = result;
        }
        return ret;
    }
}

class Pair {
    int index;
    double value;

    Pair(int index, double value) {
        this.index = index;
        this.value = value;
    }
}
```

```go [sol1-Golang]
func calcEquation(equations [][]string, values []float64, queries [][]string) []float64 {
    // 给方程组中的每个变量编号
    id := map[string]int{}
    for _, eq := range equations {
        a, b := eq[0], eq[1]
        if _, has := id[a]; !has {
            id[a] = len(id)
        }
        if _, has := id[b]; !has {
            id[b] = len(id)
        }
    }

    // 建图
    type edge struct {
        to     int
        weight float64
    }
    graph := make([][]edge, len(id))
    for i, eq := range equations {
        v, w := id[eq[0]], id[eq[1]]
        graph[v] = append(graph[v], edge{w, values[i]})
        graph[w] = append(graph[w], edge{v, 1 / values[i]})
    }

    bfs := func(start, end int) float64 {
        ratios := make([]float64, len(graph))
        ratios[start] = 1
        queue := []int{start}
        for len(queue) > 0 {
            v := queue[0]
            queue = queue[1:]
            if v == end {
                return ratios[v]
            }
            for _, e := range graph[v] {
                if w := e.to; ratios[w] == 0 {
                    ratios[w] = ratios[v] * e.weight
                    queue = append(queue, w)
                }
            }
        }
        return -1
    }

    ans := make([]float64, len(queries))
    for i, q := range queries {
        start, hasS := id[q[0]]
        end, hasE := id[q[1]]
        if !hasS || !hasE {
            ans[i] = -1
        } else {
            ans[i] = bfs(start, end)
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var calcEquation = function(equations, values, queries) {
    let nvars = 0;
    const variables = new Map();

    const n = equations.length;
    for (let i = 0; i < n; i++) {
        if (!variables.has(equations[i][0])) {
            variables.set(equations[i][0], nvars++);
        }
        if (!variables.has(equations[i][1])) {
            variables.set(equations[i][1], nvars++);
        }
    }

    // 对于每个点，存储其直接连接到的所有点及对应的权值
    const edges = new Array(nvars).fill(0);
    for (let i = 0; i < nvars; i++) {
        edges[i] = [];
    }
    for (let i = 0; i < n; i++) {
        const va = variables.get(equations[i][0]), vb = variables.get(equations[i][1]);
        edges[va].push([vb, values[i]]);
        edges[vb].push([va, 1.0 / values[i]]);
    }

    const queriesCount = queries.length;
    const ret = [];
    for (let i = 0; i < queriesCount; i++) {
        const query = queries[i];
        let result = -1.0;
        if (variables.has(query[0]) && variables.has(query[1])) {
            const ia = variables.get(query[0]), ib = variables.get(query[1]);
            if (ia === ib) {
                result = 1.0;
            } else {
                const points = [];
                points.push(ia);
                const ratios = new Array(nvars).fill(-1.0);
                ratios[ia] = 1.0;

                while (points.length && ratios[ib] < 0) {
                    const x = points.pop();
                    for (const [y, val] of edges[x]) {
                        if (ratios[y] < 0) {
                            ratios[y] = ratios[x] * val;
                            points.push(y);
                        }
                    }
                }
                result = ratios[ib];
            }
        }
        ret[i] = result;
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(ML+Q\cdot(L+M))$，其中 $M$ 为边的数量，$Q$ 为询问的数量，$L$ 为字符串的平均长度。构建图时，需要处理 $M$ 条边，每条边都涉及到 $O(L)$ 的字符串比较；处理查询时，每次查询首先要进行一次 $O(L)$ 的比较，然后至多遍历 $O(M)$ 条边。

- 空间复杂度：$O(NL+M)$，其中 $N$ 为点的数量，$M$ 为边的数量，$L$ 为字符串的平均长度。为了将每个字符串映射到整数，需要开辟空间为 $O(NL)$ 的哈希表；随后，需要花费 $O(M)$ 的空间存储每条边的权重；处理查询时，还需要 $O(N)$ 的空间维护访问队列。最终，总的复杂度为 $O(NL+M+N) = O(NL+M)$。

#### 方法二：$\text{Floyd}$ 算法

对于查询数量很多的情形，如果为每次查询都独立搜索一次，则效率会变低。为此，我们不妨对图先做一定的预处理，随后就可以在较短的时间内回答每个查询。

在本题中，我们可以使用 $\text{Floyd}$ 算法，预先计算出任意两点之间的距离。

```C++ [sol2-C++]
class Solution {
public:
    vector<double> calcEquation(vector<vector<string>>& equations, vector<double>& values, vector<vector<string>>& queries) {
        int nvars = 0;
        unordered_map<string, int> variables;

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (variables.find(equations[i][0]) == variables.end()) {
                variables[equations[i][0]] = nvars++;
            }
            if (variables.find(equations[i][1]) == variables.end()) {
                variables[equations[i][1]] = nvars++;
            }
        }
        vector<vector<double>> graph(nvars, vector<double>(nvars, -1.0));
        for (int i = 0; i < n; i++) {
            int va = variables[equations[i][0]], vb = variables[equations[i][1]];
            graph[va][vb] = values[i];
            graph[vb][va] = 1.0 / values[i];
        }

        for (int k = 0; k < nvars; k++) {
            for (int i = 0; i < nvars; i++) {
                for (int j = 0; j < nvars; j++) {
                    if (graph[i][k] > 0 && graph[k][j] > 0) {
                        graph[i][j] = graph[i][k] * graph[k][j];
                    }
                }
            }
        }

        vector<double> ret;
        for (const auto& q: queries) {
            double result = -1.0;
            if (variables.find(q[0]) != variables.end() && variables.find(q[1]) != variables.end()) {
                int ia = variables[q[0]], ib = variables[q[1]];
                if (graph[ia][ib] > 0) {
                    result = graph[ia][ib];
                }
            }
            ret.push_back(result);
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public double[] calcEquation(List<List<String>> equations, double[] values, List<List<String>> queries) {
        int nvars = 0;
        Map<String, Integer> variables = new HashMap<String, Integer>();

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (!variables.containsKey(equations.get(i).get(0))) {
                variables.put(equations.get(i).get(0), nvars++);
            }
            if (!variables.containsKey(equations.get(i).get(1))) {
                variables.put(equations.get(i).get(1), nvars++);
            }
        }
        double[][] graph = new double[nvars][nvars];
        for (int i = 0; i < nvars; i++) {
            Arrays.fill(graph[i], -1.0);
        }
        for (int i = 0; i < n; i++) {
            int va = variables.get(equations.get(i).get(0)), vb = variables.get(equations.get(i).get(1));
            graph[va][vb] = values[i];
            graph[vb][va] = 1.0 / values[i];
        }

        for (int k = 0; k < nvars; k++) {
            for (int i = 0; i < nvars; i++) {
                for (int j = 0; j < nvars; j++) {
                    if (graph[i][k] > 0 && graph[k][j] > 0) {
                        graph[i][j] = graph[i][k] * graph[k][j];
                    }
                }
            }
        }

        int queriesCount = queries.size();
        double[] ret = new double[queriesCount];
        for (int i = 0; i < queriesCount; i++) {
            List<String> query = queries.get(i);
            double result = -1.0;
            if (variables.containsKey(query.get(0)) && variables.containsKey(query.get(1))) {
                int ia = variables.get(query.get(0)), ib = variables.get(query.get(1));
                if (graph[ia][ib] > 0) {
                    result = graph[ia][ib];
                }
            }
            ret[i] = result;
        }
        return ret;
    }
}
```

```go [sol2-Golang]
func calcEquation(equations [][]string, values []float64, queries [][]string) []float64 {
    // 给方程组中的每个变量编号
    id := map[string]int{}
    for _, eq := range equations {
        a, b := eq[0], eq[1]
        if _, has := id[a]; !has {
            id[a] = len(id)
        }
        if _, has := id[b]; !has {
            id[b] = len(id)
        }
    }

    // 建图
    graph := make([][]float64, len(id))
    for i := range graph {
        graph[i] = make([]float64, len(id))
    }
    for i, eq := range equations {
        v, w := id[eq[0]], id[eq[1]]
        graph[v][w] = values[i]
        graph[w][v] = 1 / values[i]
    }

    // 执行 Floyd 算法
    for k := range graph {
        for i := range graph {
            for j := range graph {
                if graph[i][k] > 0 && graph[k][j] > 0 {
                    graph[i][j] = graph[i][k] * graph[k][j]
                }
            }
        }
    }

    ans := make([]float64, len(queries))
    for i, q := range queries {
        start, hasS := id[q[0]]
        end, hasE := id[q[1]]
        if !hasS || !hasE || graph[start][end] == 0 {
            ans[i] = -1
        } else {
            ans[i] = graph[start][end]
        }
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
var calcEquation = function(equations, values, queries) {
    let nvars = 0;
    const variables = new Map();

    const n = equations.length;
    for (let i = 0; i < n; i++) {
        if (!variables.has(equations[i][0])) {
            variables.set(equations[i][0], nvars++);
        }
        if (!variables.has(equations[i][1])) {
            variables.set(equations[i][1], nvars++);
        }
    }
    const graph = new Array(nvars).fill(0).map(() => new Array(nvars).fill(-1.0));
    for (let i = 0; i < n; i++) {
        const va = variables.get(equations[i][0]), vb = variables.get(equations[i][1]);
        graph[va][vb] = values[i];
        graph[vb][va] = 1.0 / values[i];
    }

    for (let k = 0; k < nvars; k++) {
        for (let i = 0; i < nvars; i++) {
            for (let j = 0; j < nvars; j++) {
                if (graph[i][k] > 0 && graph[k][j] > 0) {
                    graph[i][j] = graph[i][k] * graph[k][j];
                }
            }
        }
    }

    const queriesCount = queries.length;
    const ret = new Array(queriesCount).fill(0);
    for (let i = 0; i < queriesCount; i++) {
        const query = queries[i];
        let result = -1.0;
        if (variables.has(query[0]) && variables.has(query[1])) {
            const ia = variables.get(query[0]), ib = variables.get(query[1]);
            if (graph[ia][ib] > 0) {
                result = graph[ia][ib];
            }
        }
        ret[i] = result;
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(ML+N^3+QL)$。构建图需要 $O(ML)$ 的时间；$\text{Floyd}$ 算法需要 $O(N^3)$ 的时间；处理查询时，单次查询只需要 $O(L)$ 的字符串比较以及常数时间的额外操作。

- 空间复杂度：$O(NL+N^2)$。

#### 方法三：带权并查集

我们还可以考虑以并查集的方式存储节点之间的关系。设节点 $x$ 的值（即对应变量的取值）为 $v[x]$。对于任意两点 $x, y$，假设它们在并查集中具有共同的父亲 $f$，且 $v[x]/v[f] = a, v[y]/v[f]=b$，则 $v[x]/v[y]=a/b$。

在观察到这一点后，就不难利用并查集的思想解决此题。对于每个节点 $x$ 而言，除了维护其父亲 $f[x]$ 之外，还要维护其权值 $w$，其中「权值」定义为节点 $x$ 的取值与父亲 $f[x]$ 的取值之间的比值。换言之，我们有
$$
w[x] = \frac{v[x]}{v[f[x]]}
$$

下面，我们对并查集的两种操作的实现细节做出讨论。

**当查询节点 $x$ 父亲时**，如果 $f[x] \ne x$，我们需要先找到 $f[x]$ 的父亲 $\textit{father}$，并将 $f[x]$ 更新为 $\textit{father}$。此时，我们有
$$
\begin{aligned}
w[x] &\leftarrow \frac{v[x]}{v[\textit{father}]} \\
&= \frac{v[x]}{v[f[x]]} \cdot \frac{v[f[x]]}{v[\textit{father}]} \\
&= w[i] \cdot w[f[x]]
\end{aligned}
$$

也就是说，我们要将 $w[x]$ 更新为 $w[x] \cdot w[f[x]]$。

**当合并两个节点 $x,y$ 时**，我们首先找到两者的父亲 $f_x, f_y$，并将 $f[f_x]$ 更新为 $f_y$。此时，我们有
$$
\begin{aligned}
w[f_x] &\leftarrow \frac{v[f_x]}{v[f_y]} \\
&= \frac{v[x]/w[x]}{v[y]/w[y]} \\
&= \frac{v[x]}{v[y]} \cdot \frac{w[y]}{w[x]}
\end{aligned}
$$

也就是说，当在已有的图中添加一条方程式 $\frac{v[x]}{v[y]}=k$ 时，需要将 $w[f_x]$ 更新为 $k\cdot \frac{w[y]}{w[x]}$。

```C++ [sol3-C++]
class Solution {
public:
    int findf(vector<int>& f, vector<double>& w, int x) {
        if (f[x] != x) {
            int father = findf(f, w, f[x]);
            w[x] = w[x] * w[f[x]];
            f[x] = father;
        }
        return f[x];
    }

    void merge(vector<int>& f, vector<double>& w, int x, int y, double val) {
        int fx = findf(f, w, x);
        int fy = findf(f, w, y);
        f[fx] = fy;
        w[fx] = val * w[y] / w[x];
    }

    vector<double> calcEquation(vector<vector<string>>& equations, vector<double>& values, vector<vector<string>>& queries) {
        int nvars = 0;
        unordered_map<string, int> variables;

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (variables.find(equations[i][0]) == variables.end()) {
                variables[equations[i][0]] = nvars++;
            }
            if (variables.find(equations[i][1]) == variables.end()) {
                variables[equations[i][1]] = nvars++;
            }
        }
        vector<int> f(nvars);
        vector<double> w(nvars, 1.0);
        for (int i = 0; i < nvars; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i++) {
            int va = variables[equations[i][0]], vb = variables[equations[i][1]];
            merge(f, w, va, vb, values[i]);
        }
        vector<double> ret;
        for (const auto& q: queries) {
            double result = -1.0;
            if (variables.find(q[0]) != variables.end() && variables.find(q[1]) != variables.end()) {
                int ia = variables[q[0]], ib = variables[q[1]];
                int fa = findf(f, w, ia), fb = findf(f, w, ib);
                if (fa == fb) {
                    result = w[ia] / w[ib];
                }
            }
            ret.push_back(result);
        }
        return ret;
    }
};
```

```Java [sol3-Java]
class Solution {
    public double[] calcEquation(List<List<String>> equations, double[] values, List<List<String>> queries) {
        int nvars = 0;
        Map<String, Integer> variables = new HashMap<String, Integer>();

        int n = equations.size();
        for (int i = 0; i < n; i++) {
            if (!variables.containsKey(equations.get(i).get(0))) {
                variables.put(equations.get(i).get(0), nvars++);
            }
            if (!variables.containsKey(equations.get(i).get(1))) {
                variables.put(equations.get(i).get(1), nvars++);
            }
        }
        int[] f = new int[nvars];
        double[] w = new double[nvars];
        Arrays.fill(w, 1.0);
        for (int i = 0; i < nvars; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i++) {
            int va = variables.get(equations.get(i).get(0)), vb = variables.get(equations.get(i).get(1));
            merge(f, w, va, vb, values[i]);
        }
        int queriesCount = queries.size();
        double[] ret = new double[queriesCount];
        for (int i = 0; i < queriesCount; i++) {
            List<String> query = queries.get(i);
            double result = -1.0;
            if (variables.containsKey(query.get(0)) && variables.containsKey(query.get(1))) {
                int ia = variables.get(query.get(0)), ib = variables.get(query.get(1));
                int fa = findf(f, w, ia), fb = findf(f, w, ib);
                if (fa == fb) {
                    result = w[ia] / w[ib];
                }
            }
            ret[i] = result;
        }
        return ret;
    }

    public void merge(int[] f, double[] w, int x, int y, double val) {
        int fx = findf(f, w, x);
        int fy = findf(f, w, y);
        f[fx] = fy;
        w[fx] = val * w[y] / w[x];
    }

    public int findf(int[] f, double[] w, int x) {
        if (f[x] != x) {
            int father = findf(f, w, f[x]);
            w[x] = w[x] * w[f[x]];
            f[x] = father;
        }
        return f[x];
    }
}
```

```go [sol3-Golang]
func calcEquation(equations [][]string, values []float64, queries [][]string) []float64 {
    // 给方程组中的每个变量编号
    id := map[string]int{}
    for _, eq := range equations {
        a, b := eq[0], eq[1]
        if _, has := id[a]; !has {
            id[a] = len(id)
        }
        if _, has := id[b]; !has {
            id[b] = len(id)
        }
    }

    fa := make([]int, len(id))
    w := make([]float64, len(id))
    for i := range fa {
        fa[i] = i
        w[i] = 1
    }
    var find func(int) int
    find = func(x int) int {
        if fa[x] != x {
            f := find(fa[x])
            w[x] *= w[fa[x]]
            fa[x] = f
        }
        return fa[x]
    }
    merge := func(from, to int, val float64) {
        fFrom, fTo := find(from), find(to)
        w[fFrom] = val * w[to] / w[from]
        fa[fFrom] = fTo
    }

    for i, eq := range equations {
        merge(id[eq[0]], id[eq[1]], values[i])
    }

    ans := make([]float64, len(queries))
    for i, q := range queries {
        start, hasS := id[q[0]]
        end, hasE := id[q[1]]
        if hasS && hasE && find(start) == find(end) {
            ans[i] = w[start] / w[end]
        } else {
            ans[i] = -1
        }
    }
    return ans
}
```

```JavaScript [sol3-JavaScript]
var calcEquation = function(equations, values, queries) {
    let nvars = 0;
    const variables = new Map();

    const n = equations.length;
    for (let i = 0; i < n; i++) {
        if (!variables.has(equations[i][0])) {
            variables.set(equations[i][0], nvars++);
        }
        if (!variables.has(equations[i][1])) {
            variables.set(equations[i][1], nvars++);
        }
    }
    const f = new Array(nvars).fill(0).map((val, index) => index);
    const w = new Array(nvars).fill(1.0);

    for (let i = 0; i < n; i++) {
        const va = variables.get(equations[i][0]), vb = variables.get(equations[i][1]);
        merge(f, w, va, vb, values[i]);
    }
    const queriesCount = queries.length;
    const ret = new Array(queriesCount).fill(0);
    for (let i = 0; i < queriesCount; i++) {
        const query = queries[i];
        let result = -1.0;
        if (variables.has(query[0]) && variables.has(query[1])) {
            const ia = variables.get(query[0]), ib = variables.get(query[1]);
            const fa = findf(f, w, ia), fb = findf(f, w, ib);
            if (fa == fb) {
                result = w[ia] / w[ib];
            }
        }
        ret[i] = result;
    }
    return ret;
}

const merge = (f, w, x, y, val) => {
    const fx = findf(f, w, x);
    const fy = findf(f, w, y);
    f[fx] = fy;
    w[fx] = val * w[y] / w[x];
}

const findf = (f, w, x) => {
    if (f[x] != x) {
        const father = findf(f, w, f[x]);
        w[x] = w[x] * w[f[x]];
        f[x] = father;
    }
    return f[x];
};
```

**复杂度分析**

- 时间复杂度：$O(ML+N+M\log N+Q\cdot(L+\log N))$。构建图需要 $O(ML)$ 的时间；初始化并查集需要 $O(N)$ 的初始化时间；构建并查集的单次操作复杂度为 $O(\log N)$，共需 $O(M\log N)$ 的时间；每个查询需要 $O(L)$ 的字符串比较以及 $O(\log N)$ 的查询。

- 空间复杂度：$O(NL)$。哈希表需要 $O(NL)$ 的空间，并查集需要 $O(N)$ 的空间。