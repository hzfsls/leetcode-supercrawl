## [662.二叉树最大宽度 中文官方题解](https://leetcode.cn/problems/maximum-width-of-binary-tree/solutions/100000/er-cha-shu-zui-da-kuan-du-by-leetcode-so-9zp3)

#### 方法一：广度优先搜索

**思路**

此题求二叉树所有层的最大宽度，比较直观的方法是求出每一层的宽度，然后求出最大值。求每一层的宽度时，因为两端点间的 $\texttt{null}$ 节点也需要计入宽度，因此可以对节点进行编号。一个编号为 $\textit{index}$ 的左子节点的编号记为 $2 \times \textit{index}$，右子节点的编号记为 $2 \times \textit{index} + 1$，计算每层宽度时，用每层节点的最大编号减去最小编号再加 $1$ 即为宽度。

遍历节点时，可以用广度优先搜索来遍历每一层的节点，并求出最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def widthOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        res = 1
        arr = [[root, 1]]
        while arr:
            tmp = []
            for node, index in arr:
                if node.left:
                    tmp.append([node.left, index * 2])
                if node.right:
                    tmp.append([node.right, index * 2 + 1])
            res = max(res, arr[-1][1] - arr[0][1] + 1)
            arr = tmp
        return res
```

```Java [sol1-Java]
class Solution {
    public int widthOfBinaryTree(TreeNode root) {
        int res = 1;
        List<Pair<TreeNode, Integer>> arr = new ArrayList<Pair<TreeNode, Integer>>();
        arr.add(new Pair<TreeNode, Integer>(root, 1));
        while (!arr.isEmpty()) {
            List<Pair<TreeNode, Integer>> tmp = new ArrayList<Pair<TreeNode, Integer>>();
            for (Pair<TreeNode, Integer> pair : arr) {
                TreeNode node = pair.getKey();
                int index = pair.getValue();
                if (node.left != null) {
                    tmp.add(new Pair<TreeNode, Integer>(node.left, index * 2));
                }
                if (node.right != null) {
                    tmp.add(new Pair<TreeNode, Integer>(node.right, index * 2 + 1));
                }
            }
            res = Math.max(res, arr.get(arr.size() - 1).getValue() - arr.get(0).getValue() + 1);
            arr = tmp;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int WidthOfBinaryTree(TreeNode root) {
        int res = 1;
        IList<Tuple<TreeNode, int>> arr = new List<Tuple<TreeNode, int>>();
        arr.Add(new Tuple<TreeNode, int>(root, 1));
        while (arr.Count > 0) {
            IList<Tuple<TreeNode, int>> tmp = new List<Tuple<TreeNode, int>>();
            foreach (Tuple<TreeNode, int> pair in arr) {
                TreeNode node = pair.Item1;
                int index = pair.Item2;
                if (node.left != null) {
                    tmp.Add(new Tuple<TreeNode, int>(node.left, index * 2));
                }
                if (node.right != null) {
                    tmp.Add(new Tuple<TreeNode, int>(node.right, index * 2 + 1));
                }
            }
            res = Math.Max(res, arr[arr.Count - 1].Item2 - arr[0].Item2 + 1);
            arr = tmp;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int widthOfBinaryTree(TreeNode* root) {
        unsigned long long res = 1;
        vector<pair<TreeNode *, unsigned long long>> arr;
        arr.emplace_back(root, 1L);
        while (!arr.empty()) {
            vector<pair<TreeNode *, unsigned long long>> tmp;
            for (auto &[node, index] : arr) {
                if (node->left) {
                    tmp.emplace_back(node->left, index * 2);
                }
                if (node->right) {
                    tmp.emplace_back(node->right, index * 2 + 1);
                }
            }
            res = max(res, arr.back().second - arr[0].second + 1);
            arr = move(tmp);
        }
        return res;
    }
};
```

```C [sol1-C]
#define MAX_NODE_SIZE 3000
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    struct TreeNode *node;
    unsigned long long index;
} Pair;

int widthOfBinaryTree(struct TreeNode* root){
    unsigned long long res = 1;
    Pair * arr = (Pair *)malloc(sizeof(Pair) * MAX_NODE_SIZE);
    Pair * tmp = (Pair *)malloc(sizeof(Pair) * MAX_NODE_SIZE);
    int arrSize = 0, tmpSize = 0;
    arr[arrSize].node = root;
    arr[arrSize].index = 1LL;
    arrSize++;
    while (arrSize > 0) {
        tmpSize = 0;
        for (int i = 0; i < arrSize; i++) {
            if (arr[i].node->left) {
                tmp[tmpSize].node = arr[i].node->left;
                tmp[tmpSize].index = arr[i].index * 2;
                tmpSize++;
            }
            if (arr[i].node->right) {
                tmp[tmpSize].node = arr[i].node->right;
                tmp[tmpSize].index = arr[i].index * 2 + 1;
                tmpSize++;
            }
        }
        res = MAX(res, arr[arrSize - 1].index - arr[0].index + 1);
        arrSize = tmpSize;
        Pair * p = arr;
        arr = tmp;
        tmp = p;
    }
    return res;
}
```

```go [sol1-Golang]
type pair struct {
    node  *TreeNode
    index int
}

func widthOfBinaryTree(root *TreeNode) int {
    ans := 1
    q := []pair{{root, 1}}
    for q != nil {
        ans = max(ans, q[len(q)-1].index-q[0].index+1)
        tmp := q
        q = nil
        for _, p := range tmp {
            if p.node.Left != nil {
                q = append(q, pair{p.node.Left, p.index * 2})
            }
            if p.node.Right != nil {
                q = append(q, pair{p.node.Right, p.index*2 + 1})
            }
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。需要遍历所有节点。

- 空间复杂度：$O(n)$。广度优先搜索的空间复杂度最多为 $O(n)$。 

#### 方法二：深度优先搜索

**思路**

仍然按照上述方法编号，可以用深度优先搜索来遍历。遍历时如果是先访问左子节点，再访问右子节点，每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值，需要记录下来进行后续的比较。一次深度优先搜索中，需要当前节点到当前行最左边节点的宽度，以及对子节点进行深度优先搜索，求出最大宽度，并返回最大宽度。

**代码**

```Python [sol2-Python3]
class Solution:
    def widthOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        levelMin = {}
        def dfs(node: Optional[TreeNode], depth: int, index: int) -> int:
            if node is None:
                return 0
            if depth not in levelMin:
                levelMin[depth] = index  # 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
            return max(index - levelMin[depth] + 1,
                       dfs(node.left, depth + 1, index * 2),
                       dfs(node.right, depth + 1, index * 2 + 1))
        return dfs(root, 1, 1)
```

```Java [sol2-Java]
class Solution {
    Map<Integer, Integer> levelMin = new HashMap<Integer, Integer>();

    public int widthOfBinaryTree(TreeNode root) {
        return dfs(root, 1, 1);
    }

    public int dfs(TreeNode node, int depth, int index) {
        if (node == null) {
            return 0;
        }
        levelMin.putIfAbsent(depth, index); // 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
        return Math.max(index - levelMin.get(depth) + 1, Math.max(dfs(node.left, depth + 1, index * 2), dfs(node.right, depth + 1, index * 2 + 1)));
    }
}
```

```C# [sol2-C#]
public class Solution {
    Dictionary<int, int> levelMin = new Dictionary<int, int>();

    public int WidthOfBinaryTree(TreeNode root) {
        return DFS(root, 1, 1);
    }

    public int DFS(TreeNode node, int depth, int index) {
        if (node == null) {
            return 0;
        }
        levelMin.TryAdd(depth, index); // 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
        return Math.Max(index - levelMin[depth] + 1, Math.Max(DFS(node.left, depth + 1, index * 2), DFS(node.right, depth + 1, index * 2 + 1)));
    }
}
```

```C++ [sol2-C++]
using ULL = unsigned long long;

class Solution {
public:
    int widthOfBinaryTree(TreeNode* root) {
        unordered_map<int, ULL> levelMin;
        function<ULL(TreeNode*, int, ULL)> dfs = [&](TreeNode* node, int depth, ULL index)->ULL {
            if (node == nullptr) {
                return 0LL;
            }
            if (!levelMin.count(depth)) {
                levelMin[depth] = index; // 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
            }
            return max({index - levelMin[depth] + 1LL, dfs(node->left, depth + 1, index * 2), dfs(node->right, depth + 1, index * 2 + 1)});
        };
        return dfs(root, 1, 1LL);
    }
};
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
typedef unsigned long long ULL;

typedef struct {
    int key;
    ULL val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

HashItem *hashAddItem(HashItem **obj, int key, ULL val) {
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return pEntry;
}

bool hashSetItem(HashItem **obj, int key, ULL val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

ULL hashGetItem(HashItem **obj, int key, ULL defaultVal) {
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

ULL dfs(HashItem **levelMin, struct TreeNode* node, int depth, ULL index) {
    if (node == NULL) {
        return 0LL;
    }
    HashItem *pEntry = hashFindItem(levelMin, depth);
    if (!pEntry) {
        pEntry = hashAddItem(levelMin, depth, index); // 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
    }
    ULL ret =  index - pEntry->val + 1;
    if (node->left) {
        ULL val = dfs(levelMin, node->left, depth + 1, index * 2);
        ret = MAX(ret, val);
    }
    if (node->right) {
        ULL val = dfs(levelMin, node->right, depth + 1, index * 2 + 1);
        ret = MAX(ret, val);
    }
    return ret;
}   

int widthOfBinaryTree(struct TreeNode* root) {
    HashItem *levelMin = NULL;
    ULL ret = dfs(&levelMin, root, 1, 1LL);
    hashFree(&levelMin);
    return ret;
}
```

```go [sol2-Golang]
func widthOfBinaryTree(root *TreeNode) int {
    levelMin := map[int]int{}
    var dfs func(*TreeNode, int, int) int
    dfs = func(node *TreeNode, depth, index int) int {
        if node == nil {
            return 0
        }
        if _, ok := levelMin[depth]; !ok {
            levelMin[depth] = index // 每一层最先访问到的节点会是最左边的节点，即每一层编号的最小值
        }
        return max(index-levelMin[depth]+1, max(dfs(node.Left, depth+1, index*2), dfs(node.Right, depth+1, index*2+1)))
    }
    return dfs(root, 1, 1)
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。需要遍历所有节点。

- 空间复杂度：$O(n)$。递归的深度最多为 $O(n)$。