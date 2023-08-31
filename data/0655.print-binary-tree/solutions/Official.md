## [655.输出二叉树 中文官方题解](https://leetcode.cn/problems/print-binary-tree/solutions/100000/shu-chu-er-cha-shu-by-leetcode-solution-cnxu)

#### 方法一：深度优先搜索

**思路与算法**

我们可以通过深度优先搜索来解决此题。首先通过深度优先搜索来得到二叉树的高度 $\textit{height}$（注意高度从 $0$ 开始），然后创建一个行数为 $m = \textit{height} + 1$，列数为 $n = 2^{\textit{height} + 1} - 1$ 的答案数组 $\textit{res}$ 放置节点的值（字符串形式）。根节点的值应当放在当前空间的第一行正中间。根节点所在的行与列会将剩余空间划分为两部分（左下部分和右下部分），然后递归地将左子树输出在左下部分空间，右子树输出在右下部分空间即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def printTree(self, root: Optional[TreeNode]) -> List[List[str]]:
        def calDepth(node: Optional[TreeNode]) -> int:
            return max(calDepth(node.left) + 1 if node.left else 0, calDepth(node.right) + 1 if node.right else 0)
        height = calDepth(root)

        m = height + 1
        n = 2 ** m - 1
        ans = [[''] * n for _ in range(m)]
        def dfs(node: Optional[TreeNode], r: int, c: int) -> None:
            ans[r][c] = str(node.val)
            if node.left:
                dfs(node.left, r + 1, c - 2 ** (height - r - 1))
            if node.right:
                dfs(node.right, r + 1, c + 2 ** (height - r - 1))
        dfs(root, 0, (n - 1) // 2)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int calDepth(TreeNode* root) {
        int h = 0;
        if (root->left) {
            h = max(h, calDepth(root->left) + 1);
        }
        if (root->right) {
            h = max(h, calDepth(root->right) + 1);
        }
        return h;
    }

    void dfs(vector<vector<string>>& res, TreeNode* root, int r, int c, const int& height) {
        res[r][c] = to_string(root->val);
        if (root->left) {
            dfs(res, root->left, r + 1, c - (1 << (height - r - 1)), height);
        }
        if (root->right) {
            dfs(res, root->right, r + 1, c + (1 << (height - r - 1)), height);
        }
    }

    vector<vector<string>> printTree(TreeNode* root) {
        int height = calDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        vector<vector<string>> res(m, vector<string>(n, ""));
        dfs(res, root, 0, (n - 1) / 2, height);
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<String>> printTree(TreeNode root) {
        int height = calDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        List<List<String>> res = new ArrayList<List<String>>();
        for (int i = 0; i < m; i++) {
            List<String> row = new ArrayList<String>();
            for (int j = 0; j < n; j++) {
                row.add("");
            }
            res.add(row);
        }
        dfs(res, root, 0, (n - 1) / 2, height);
        return res;
    }

    public int calDepth(TreeNode root) {
        int h = 0;
        if (root.left != null) {
            h = Math.max(h, calDepth(root.left) + 1);
        }
        if (root.right != null) {
            h = Math.max(h, calDepth(root.right) + 1);
        }
        return h;
    }

    public void dfs(List<List<String>> res, TreeNode root, int r, int c, int height) {
        res.get(r).set(c, Integer.toString(root.val));
        if (root.left != null) {
            dfs(res, root.left, r + 1, c - (1 << (height - r - 1)), height);
        }
        if (root.right != null) {
            dfs(res, root.right, r + 1, c + (1 << (height - r - 1)), height);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<string>> PrintTree(TreeNode root) {
        int height = CalDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        IList<IList<string>> res = new List<IList<string>>();
        for (int i = 0; i < m; i++) {
            IList<string> row = new List<string>();
            for (int j = 0; j < n; j++) {
                row.Add("");
            }
            res.Add(row);
        }
        DFS(res, root, 0, (n - 1) / 2, height);
        return res;
    }

    public int CalDepth(TreeNode root) {
        int h = 0;
        if (root.left != null) {
            h = Math.Max(h, CalDepth(root.left) + 1);
        }
        if (root.right != null) {
            h = Math.Max(h, CalDepth(root.right) + 1);
        }
        return h;
    }

    public void DFS(IList<IList<string>> res, TreeNode root, int r, int c, int height) {
        res[r][c] = root.val.ToString();
        if (root.left != null) {
            DFS(res, root.left, r + 1, c - (1 << (height - r - 1)), height);
        }
        if (root.right != null) {
            DFS(res, root.right, r + 1, c + (1 << (height - r - 1)), height);
        }
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MAX_VAL_LEN 32

int calDepth(struct TreeNode* root) {
    int h = 0;
    if (root->left) {
        h = MAX(h, calDepth(root->left) + 1);
    }
    if (root->right) {
        h = MAX(h, calDepth(root->right) + 1);
    }
    return h;
}

void dfs(char ***res, struct TreeNode* root, int r, int c, const int height) {
    sprintf(res[r][c], "%d", root->val);
    if (root->left) {
        dfs(res, root->left, r + 1, c - (1 << (height - r - 1)), height);
    }
    if (root->right) {
        dfs(res, root->right, r + 1, c + (1 << (height - r - 1)), height);
    }
}

char ***printTree(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {
    int height = calDepth(root);
    int m = height + 1;
    int n = (1 << (height + 1)) - 1;
    char ***res = (char ***)malloc(sizeof(char **) * m);
    for (int i = 0; i < m; i++) {
        res[i] = (char **)malloc(sizeof(char *) * n);
        for (int j = 0; j < n; j++) {
            res[i][j] = (char *)malloc(sizeof(char) * MAX_VAL_LEN);
            res[i][j][0] = '\0';
        }
    }
    dfs(res, root, 0, (n - 1) / 2, height);
    *returnSize = m;
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; i++) {
        (*returnColumnSizes)[i] = n;
    }
    return res;
}
```

```go [sol1-Golang]
func calDepth(node *TreeNode) int {
    h := 0
    if node.Left != nil {
        h = calDepth(node.Left) + 1
    }
    if node.Right != nil {
        h = max(h, calDepth(node.Right)+1)
    }
    return h
}

func printTree(root *TreeNode) [][]string {
    height := calDepth(root)
    m := height + 1
    n := 1<<m - 1
    ans := make([][]string, m)
    for i := range ans {
        ans[i] = make([]string, n)
    }
    var dfs func(*TreeNode, int, int)
    dfs = func(node *TreeNode, r, c int) {
        ans[r][c] = strconv.Itoa(node.Val)
        if node.Left != nil {
            dfs(node.Left, r+1, c-1<<(height-r-1))
        }
        if node.Right != nil {
            dfs(node.Right, r+1, c+1<<(height-r-1))
        }
    }
    dfs(root, 0, (n-1)/2)
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var printTree = function(root) {
    const calDepth = (root) => {
        let h = 0;
        if (root.left) {
            h = Math.max(h, calDepth(root.left) + 1);
        }
        if (root.right) {
            h = Math.max(h, calDepth(root.right) + 1);
        }
        return h;
    }

    const dfs = (res, root, r, c, height) => {
        res[r][c] = root.val.toString();
        if (root.left) {
            dfs(res, root.left, r + 1, c - (1 << (height - r - 1)), height);
        }
        if (root.right) {
            dfs(res, root.right, r + 1, c + (1 << (height - r - 1)), height);
        }
    }

    const height = calDepth(root);
    const m = height + 1;
    const n = (1 << (height + 1)) - 1;
    const res = new Array(m).fill(0).map(() => new Array(n).fill(''));
    dfs(res, root, 0, Math.floor((n - 1) / 2), height);
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(\textit{height} \times 2^\textit{height})$，其中 $\textit{height}$ 是二叉树的高度。需要填充 $(\textit{height} + 1) \times (2^{\textit{height} + 1} - 1)$ 的数组。

- 空间复杂度：$O(\textit{height})$，其中 $\textit{height}$ 是二叉树的高度。空间复杂度主要是递归调用的栈空间，取决于二叉树的高度。注意返回值不计入空间复杂度。

#### 方法二：广度优先搜索

**思路与算法**

我们也可以通过广度优先搜索来解决此题。首先通过广度优先搜索来得到二叉树的高度 $\textit{height}$，然后创建一个行数为 $m = \textit{height} + 1$，列数为 $n = 2^{\textit{height} + 1} - 1$ 的答案数组 $\textit{res}$ 放置节点的值（字符串形式）。使用广度优先搜索遍历每一个节点时，记录每一个节点对应的放置空间，每一个节点的值放置在对应空间的第一行正中间，然后其所在的行和列会将剩余空间划分为两部分（左下部分和右下部分），并把它的非空左子节点和非空右子节点以及它们的对应的放置空间放入队列即可。特别地，根节点的放置空间为整个 $\textit{res}$ 数组。

**代码**

```Python [sol2-Python3]
class Solution:
    def printTree(self, root: Optional[TreeNode]) -> List[List[str]]:
        def calDepth(root: Optional[TreeNode]) -> int:
            h = -1
            q = [root]
            while q:
                h += 1
                tmp = q
                q = []
                for node in tmp:
                    if node.left:
                        q.append(node.left)
                    if node.right:
                        q.append(node.right)
            return h
        height = calDepth(root)

        m = height + 1
        n = 2 ** m - 1
        ans = [[''] * n for _ in range(m)]
        q = deque([(root, 0, (n - 1) // 2)])
        while q:
            node, r, c = q.popleft()
            ans[r][c] = str(node.val)
            if node.left:
                q.append((node.left, r + 1, c - 2 ** (height - r - 1)))
            if node.right:
                q.append((node.right, r + 1, c + 2 ** (height - r - 1)))
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int calDepth(TreeNode* root) {
        int res = -1;
        queue<TreeNode*> q;
        q.push(root);
        while (!q.empty()) {
            int len = q.size();
            res++;
            while (len) {
                len--;
                auto t = q.front();
                q.pop();
                if (t->left) {
                    q.push(t->left);
                }
                if (t->right) {
                    q.push(t->right);
                }
            }
        }
        return res;
    }

    vector<vector<string>> printTree(TreeNode* root) {
        int height = calDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        vector<vector<string>> res(m, vector<string>(n, ""));
        queue<tuple<TreeNode*, int, int>> q;
        q.push({root, 0, (n - 1) / 2});
        while (!q.empty()) {
            auto t = q.front();
            q.pop();
            int r = get<1>(t), c = get<2>(t);
            res[r][c] = to_string(get<0>(t)->val);
            if (get<0>(t)->left) {
                q.push({get<0>(t)->left, r + 1, c - (1 << (height - r - 1))});
            }
            if (get<0>(t)->right) {
                q.push({get<0>(t)->right, r + 1, c + (1 << (height - r - 1))});
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    class Tuple {
        TreeNode node;
        int r;
        int c;

        public Tuple(TreeNode node, int r, int c) {
            this.node = node;
            this.r = r;
            this.c = c;
        }
    }

    public List<List<String>> printTree(TreeNode root) {
        int height = calDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        List<List<String>> res = new ArrayList<List<String>>();
        for (int i = 0; i < m; i++) {
            List<String> row = new ArrayList<String>();
            for (int j = 0; j < n; j++) {
                row.add("");
            }
            res.add(row);
        }
        Queue<Tuple> queue = new ArrayDeque<Tuple>();
        queue.offer(new Tuple(root, 0, (n - 1) / 2));
        while (!queue.isEmpty()) {
            Tuple t = queue.poll();
            TreeNode node = t.node;
            int r = t.r, c = t.c;
            res.get(r).set(c, Integer.toString(node.val));
            if (node.left != null) {
                queue.offer(new Tuple(node.left, r + 1, c - (1 << (height - r - 1))));
            }
            if (node.right != null) {
                queue.offer(new Tuple(node.right, r + 1, c + (1 << (height - r - 1))));
            }
        }
        return res;
    }

    public int calDepth(TreeNode root) {
        int res = -1;
        Queue<TreeNode> queue = new ArrayDeque<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            int len = queue.size();
            res++;
            while (len > 0) {
                len--;
                TreeNode t = queue.poll();
                if (t.left != null) {
                    queue.offer(t.left);
                }
                if (t.right != null) {
                    queue.offer(t.right);
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<IList<string>> PrintTree(TreeNode root) {
        int height = CalDepth(root);
        int m = height + 1;
        int n = (1 << (height + 1)) - 1;
        IList<IList<string>> res = new List<IList<string>>();
        for (int i = 0; i < m; i++) {
            IList<string> row = new List<string>();
            for (int j = 0; j < n; j++) {
                row.Add("");
            }
            res.Add(row);
        }
        Queue<Tuple<TreeNode, int, int>> queue = new Queue<Tuple<TreeNode, int, int>>();
        queue.Enqueue(new Tuple<TreeNode, int, int>(root, 0, (n - 1) / 2));
        while (queue.Count > 0) {
            Tuple<TreeNode, int, int> t = queue.Dequeue();
            TreeNode node = t.Item1;
            int r = t.Item2, c = t.Item3;
            res[r][c] = node.val.ToString();
            if (node.left != null) {
                queue.Enqueue(new Tuple<TreeNode, int, int>(node.left, r + 1, c - (1 << (height - r - 1))));
            }
            if (node.right != null) {
                queue.Enqueue(new Tuple<TreeNode, int, int>(node.right, r + 1, c + (1 << (height - r - 1))));
            }
        }
        return res;
    }

    public int CalDepth(TreeNode root) {
        int res = -1;
        Queue<TreeNode> queue = new Queue<TreeNode>();
        queue.Enqueue(root);
        while (queue.Count > 0) {
            int len = queue.Count;
            res++;
            while (len > 0) {
                len--;
                TreeNode t = queue.Dequeue();
                if (t.left != null) {
                    queue.Enqueue(t.left);
                }
                if (t.right != null) {
                    queue.Enqueue(t.right);
                }
            }
        }
        return res;
    }
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 1024
#define MAX_VAL_LEN 32

typedef struct {
    struct TreeNode *node;
    int row;
    int col;
} Tuple;

int calDepth(struct TreeNode* root) {
    int res = -1;
    struct TreeNode **queue = (struct TreeNode **)malloc(sizeof(struct TreeNode*) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    queue[tail++] = root;   
    while (head != tail) {
        int len = tail - head;
        res++;
        while (len) {
            len--;
            struct TreeNode *t = queue[head++];
            if (t->left) {
                queue[tail++] = t->left;   
            }
            if (t->right) {
                queue[tail++] = t->right;   
            }
        }
    }
    free(queue);
    return res;
}    

Tuple *creatTuple(struct TreeNode* node, int row, int col) {
    Tuple *obj = (Tuple *)malloc(sizeof(Tuple));
    obj->node = node;
    obj->row = row;
    obj->col = col;
    return obj;
}

char *** printTree(struct TreeNode* root, int* returnSize, int** returnColumnSizes){
    int height = calDepth(root);
    printf("height = %d\n", height);
    int m = height + 1;
    int n = (1 << (height + 1)) - 1;
    char ***res = (char ***)malloc(sizeof(char **) * m);
    for (int i = 0; i < m; i++) {
        res[i] = (char **)malloc(sizeof(char *) * n);
        for (int j = 0; j < n; j++) {
            res[i][j] = (char *)malloc(sizeof(char) * MAX_VAL_LEN);
            res[i][j][0] = '\0';
        }
    }
    Tuple **queue = (Tuple **)malloc(sizeof(Tuple *) * n);
    int head = 0, tail = 0;
    queue[tail++] = creatTuple(root, 0, (n - 1) / 2);
    while (head != tail) {
        Tuple *t = queue[head++];
        int r = t->row, c = t->col;
        sprintf(res[r][c], "%d", t->node->val);
        if (t->node->left) {
            queue[tail++] = creatTuple(t->node->left, r + 1, c - (1 << (height - r - 1)));
        }
        if (t->node->right) {
            queue[tail++] = creatTuple(t->node->right, r + 1, c + (1 << (height - r - 1)));
        }
    }
    for (int i = 0; i < tail; i++) {
        free(queue[i]);
    }
    free(queue);
    *returnSize = m;
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; i++) {
        (*returnColumnSizes)[i] = n;
    }
    return res;
}
```

```go [sol2-Golang]
func calDepth(root *TreeNode) int {
    h := -1
    q := []*TreeNode{root}
    for len(q) > 0 {
        h++
        tmp := q
        q = nil
        for _, node := range tmp {
            if node.Left != nil {
                q = append(q, node.Left)
            }
            if node.Right != nil {
                q = append(q, node.Right)
            }
        }
    }
    return h
}

func printTree(root *TreeNode) [][]string {
    height := calDepth(root)
    m := height + 1
    n := 1<<m - 1
    ans := make([][]string, m)
    for i := range ans {
        ans[i] = make([]string, n)
    }
    type entry struct {
        node *TreeNode
        r, c int
    }
    q := []entry{{root, 0, (n - 1) / 2}}
    for len(q) > 0 {
        e := q[0]
        q = q[1:]
        node, r, c := e.node, e.r, e.c
        ans[r][c] = strconv.Itoa(node.Val)
        if node.Left != nil {
            q = append(q, entry{node.Left, r + 1, c - 1<<(height-r-1)})
        }
        if node.Right != nil {
            q = append(q, entry{node.Right, r + 1, c + 1<<(height-r-1)})
        }
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
var printTree = function(root) {
    const height = CalDepth(root);
    const m = height + 1;
    const n = (1 << (height + 1)) - 1;
    const res = new Array(m).fill(0).map(() => new Array(n).fill(''));
    const queue = [];
    queue.push([root, 0, Math.floor((n - 1) / 2)]);
    while (queue.length > 0) {
        const t = queue.shift();
        const node = t[0];
        let r = t[1], c = t[2];
        res[r][c] = node.val.toString();
        if (node.left) {
            queue.push([node.left, r + 1, c - (1 << (height - r - 1))]);
        }
        if (node.right) {
            queue.push([node.right, r + 1, c + (1 << (height - r - 1))]);
        }
    }
    return res;
};

const CalDepth = (root) => {
    let res = -1;
    const queue = [root];
    while (queue.length > 0) {
        let len = queue.length;
        res++;
        while (len > 0) {
            len--;
            const t = queue.shift();
            if (t.left) {
                queue.push(t.left);
            }
            if (t.right) {
                queue.push(t.right);
            }
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{height} \times 2^\textit{height})$，其中 $\textit{height}$ 是二叉树的高度。需要填充 $(\textit{height} + 1) \times (2^{\textit{height} + 1} - 1)$ 的数组。

- 空间复杂度：$O(2^\textit{height})$，其中 $\textit{height}$ 是二叉树的高度。空间复杂度主要是队列空间，队列中的元素个数不超过二叉树的节点个数，为 $O(2^\textit{height})$。注意返回值不计入空间复杂度。