## [2049.统计最高分的节点数目 中文官方题解](https://leetcode.cn/problems/count-nodes-with-the-highest-score/solutions/100000/tong-ji-zui-gao-fen-de-jie-dian-shu-mu-b-n810)

#### 方法一：深度优先搜索

**思路**

在一棵树中，当把一个节点和与它相连的所有边删除，剩余部分最多为三棵非空子树，即原节点的左子树（如果有），右子树（如果有），以及把以这个节点为根结点的子树移除所形成的子树（除根结点外均有）。而这个节点的分数为这些子树的节点个数的乘积。我们可以先用 $\textit{parents}$ 数组统计出每个节点的子节点，然后使用深度优先搜索来计算以每个节点为根结点的子树的大小，同时计算每个节点的大小，作为深度优先搜索的返回值，最后统计最大分数出现的次数。在实现上，统计最大分数出现的次数可以放到深度优先搜索中完成，从而节省一部分空间。

**代码**

```Python [sol1-Python3]
class Solution:
    def countHighestScoreNodes(self, parents: List[int]) -> int:
        n = len(parents)
        children = [[] for _ in range(n)]
        for node, p in enumerate(parents):
            if p != -1:
                children[p].append(node)

        maxScore, cnt = 0, 0
        def dfs(node: int) -> int:
            score = 1
            size = n - 1
            for ch in children[node]:
                sz = dfs(ch)
                score *= sz
                size -= sz
            if node != 0:
                score *= size
            nonlocal maxScore, cnt
            if score == maxScore:
                cnt += 1
            elif score > maxScore:
                maxScore, cnt = score, 1
            return n - size
        dfs(0)
        return cnt
```

```Java [sol1-Java]
class Solution {
    long maxScore = 0;
    int cnt = 0;
    int n;
    List<Integer>[] children;

    public int countHighestScoreNodes(int[] parents) {
        n = parents.length;
        children = new List[n];
        for (int i = 0; i < n; i++) {
            children[i] = new ArrayList<Integer>();
        }
        for (int i = 0; i < n; i++) {
            int p = parents[i];
            if (p != -1) {
                children[p].add(i);
            }
        }
        dfs(0);
        return cnt;
    }

    public int dfs(int node) {
        long score = 1;
        int size = n - 1;
        for (int c : children[node]) {
            int t = dfs(c);
            score *= t;
            size -= t;
        }
        if (node != 0) {
            score *= size;
        }
        if (score == maxScore) {
            cnt++;
        } else if (score > maxScore) {
            maxScore = score;
            cnt = 1;
        }
        return n - size;
    }
}
```

```C# [sol1-C#]
public class Solution {
    long maxScore = 0;
    int cnt = 0;
    int n;
    IList<int>[] children;

    public int CountHighestScoreNodes(int[] parents) {
        n = parents.Length;
        children = new IList<int>[n];
        for (int i = 0; i < n; i++) {
            children[i] = new List<int>();
        }
        for (int i = 0; i < n; i++) {
            int p = parents[i];
            if (p != -1) {
                children[p].Add(i);
            }
        }
        DFS(0);
        return cnt;
    }

    public int DFS(int node) {
        long score = 1;
        int size = n - 1;
        foreach (int c in children[node]) {
            int t = DFS(c);
            score *= t;
            size -= t;
        }
        if (node != 0) {
            score *= size;
        }
        if (score == maxScore) {
            cnt++;
        } else if (score > maxScore) {
            maxScore = score;
            cnt = 1;
        }
        return n - size;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    long maxScore = 0;
    int cnt = 0;
    int n;
    vector<vector<int>> children;

    int dfs(int node) {
        long score = 1;
        int size = n - 1;
        for (int c : children[node]) {
            int t = dfs(c);
            score *= t;
            size -= t;
        }
        if (node != 0) {
            score *= size;
        }
        if (score == maxScore) {
            cnt++;
        } else if (score > maxScore) {
            maxScore = score;
            cnt = 1;
        }
        return n - size;
    }

    int countHighestScoreNodes(vector<int>& parents) {
        this->n = parents.size();
        this->children = vector<vector<int>>(n);
        for (int i = 0; i < n; i++) {
            int p = parents[i];
            if (p != -1) {
                children[p].emplace_back(i);
            }
        }
        dfs(0);
        return cnt;
    }
};
```

```C [sol1-C]
int dfs(int node, long * maxScore, int * cnt, int n, const struct ListNode ** children) {
    long score = 1;
    int size = n - 1;
    for (struct ListNode * curr = children[node]; curr; curr = curr->next) {
        int t = dfs(curr->val, maxScore, cnt, n, children);
        score *= t;
        size -= t;
    }
    if (node != 0) {
        score *= size;
    }
    if (score == *maxScore) {
        (*cnt)++;
    } else if (score > *maxScore) {
        *maxScore = score;
        *cnt = 1;
    }
    return n - size;
}

int countHighestScoreNodes(int* parents, int parentsSize){
    int n = parentsSize;
    int cnt = 0;
    long maxScore = 0;
    struct ListNode ** children = (struct ListNode **)malloc(sizeof(struct ListNode *) * n);
    for (int i = 0; i < n; i++) {
        children[i] = NULL;
    }
    for (int i = 0; i < n; i++) {
        int p = parents[i];
        if (p != -1) {
            struct ListNode * node = (struct ListNode *)malloc(sizeof(struct ListNode));
            node->val = i;
            node->next = children[p];
            children[p] = node;
        }
    }
    dfs(0, &maxScore, &cnt, n, children);
    for (int i = 0; i < n; i++) {
        for (struct ListNode * curr = children[i]; curr; ) {
            struct ListNode * next = curr->next;
            free(curr);
            curr = next;
        }
    }
    free(children);
    return cnt;
}
```

```go [sol1-Golang]
func countHighestScoreNodes(parents []int) (ans int) {
    n := len(parents)
    children := make([][]int, n)
    for node := 1; node < n; node++ {
        p := parents[node]
        children[p] = append(children[p], node)
    }

    maxScore := 0
    var dfs func(int) int
    dfs = func(node int) int {
        score, size := 1, n-1
        for _, ch := range children[node] {
            sz := dfs(ch)
            score *= sz
            size -= sz
        }
        if node > 0 {
            score *= size
        }
        if score == maxScore {
            ans++
        } else if score > maxScore {
            maxScore = score
            ans = 1
        }
        return n - size
    }
    dfs(0)
    return
}
```

```JavaScript [sol1-JavaScript]
var countHighestScoreNodes = function(parents) {
    const n = parents.length;
    const children = new Array(n).fill(0);
    let maxScore = 0;
    let cnt = 0;
    for (let i = 0; i < n; i++) {
        children[i] = [];
    }
    for (let i = 0; i < n; i++) {
        const p = parents[i];
        if (p !== -1) {
            children[p].push(i);
        }
    }

    const dfs = (node) => {
        let score = 1;
        let size = n - 1;
        for (const c of children[node]) {
            let t = dfs(c);
            score *= t;
            size -= t;
        }
        if (node !== 0) {
            score *= size;
        }
        if (score === maxScore) {
            cnt++;
        } else if (score > maxScore) {
            maxScore = score;
            cnt = 1;
        }
        return n - size;
    }

    dfs(0);
    return cnt;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树的节点数。预处理，深度优先搜索均消耗 $O(n)$ 时间。

- 空间复杂度：$O(n)$。统计每个节点的子节点消耗 $O(n)$ 空间，深度优先搜索的深度最多为 $O(n)$ 空间。