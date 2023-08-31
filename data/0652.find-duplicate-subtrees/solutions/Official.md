## [652.寻找重复的子树 中文官方题解](https://leetcode.cn/problems/find-duplicate-subtrees/solutions/100000/xun-zhao-zhong-fu-de-zi-shu-by-leetcode-zoncw)

#### 方法一：使用序列化进行唯一表示

**思路与算法**

一种容易想到的方法是将每一棵子树都「序列化」成一个字符串，并且保证：

- 相同的子树会被序列化成相同的子串；
- 不同的子树会被序列化成不同的子串。

那么我们只要使用一个哈希表存储所有子树的序列化结果，如果某一个结果出现了超过一次，我们就发现了一类重复子树。

序列化一棵二叉树的方法可以参考[「剑指 Offer 37. 序列化二叉树」的官方题解](https://leetcode.cn/problems/xu-lie-hua-er-cha-shu-lcof/solution/xu-lie-hua-er-cha-shu-by-leetcode-soluti-4duq/)，这里也给出两种常用的序列化方法：

- 第一种方法是使用层序遍历的方法进行序列化，例如**示例 1**中的二叉树可以序列化为：

    $$
    \text{1,2,3,4,null,2,4,null,null,4}
    $$

    这也是力扣平台上测试代码时输入一棵二叉树的默认方法。

- 第二种方法是使用递归的方法进行序列化。我们可以将一棵以 $x$ 为根节点值的子树序列化为：

    $$
    \text{x(左子树的序列化结果)(右子树的序列化结果)}
    $$

    左右子树分别递归地进行序列化。如果子树为空，那么序列化结果为空串。**示例 1**中的二叉树可以序列化为：

    $$
    1(2(4()())())(3(2(4()())())(4()()))
    $$

下面的代码使用的是第二种方法。我们需要使用一个哈希映射 $\textit{seen}$ 存储序列到子树的映射。如果在计算序列时，通过 $\textit{seen}$ 查找到了已经出现过的序列，那么就可以把对应的子树放到哈希集合 $\textit{repeat}$ 中，这样就可以保证同一类的重复子树只会被存储在答案中一次。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<TreeNode*> findDuplicateSubtrees(TreeNode* root) {
        dfs(root);
        return {repeat.begin(), repeat.end()};
    }

    string dfs(TreeNode* node) {
        if (!node) {
            return "";
        }
        string serial = to_string(node->val) + "(" + dfs(node->left) + ")(" + dfs(node->right) + ")";
        if (auto it = seen.find(serial); it != seen.end()) {
            repeat.insert(it->second);
        }
        else {
            seen[serial] = node;
        }
        return serial;
    }

private:
    unordered_map<string, TreeNode*> seen;
    unordered_set<TreeNode*> repeat;
};
```

```Java [sol1-Java]
class Solution {
    Map<String, TreeNode> seen = new HashMap<String, TreeNode>();
    Set<TreeNode> repeat = new HashSet<TreeNode>();

    public List<TreeNode> findDuplicateSubtrees(TreeNode root) {
        dfs(root);
        return new ArrayList<TreeNode>(repeat);
    }

    public String dfs(TreeNode node) {
        if (node == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.append(node.val);
        sb.append("(");
        sb.append(dfs(node.left));
        sb.append(")(");
        sb.append(dfs(node.right));
        sb.append(")");
        String serial = sb.toString();
        if (seen.containsKey(serial)) {
            repeat.add(seen.get(serial));
        } else {
            seen.put(serial, node);
        }
        return serial;
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<string, TreeNode> seen = new Dictionary<string, TreeNode>();
    ISet<TreeNode> repeat = new HashSet<TreeNode>();

    public IList<TreeNode> FindDuplicateSubtrees(TreeNode root) {
        DFS(root);
        return new List<TreeNode>(repeat);
    }

    public string DFS(TreeNode node) {
        if (node == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(node.val);
        sb.Append("(");
        sb.Append(DFS(node.left));
        sb.Append(")(");
        sb.Append(DFS(node.right));
        sb.Append(")");
        string serial = sb.ToString();
        if (seen.ContainsKey(serial)) {
            repeat.Add(seen[serial]);
        } else {
            seen.Add(serial, node);
        }
        return serial;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findDuplicateSubtrees(self, root: Optional[TreeNode]) -> List[Optional[TreeNode]]:
        def dfs(node: Optional[TreeNode]) -> str:
            if not node:
                return ""
            
            serial = "".join([str(node.val), "(", dfs(node.left), ")(", dfs(node.right), ")"])
            if (tree := seen.get(serial, None)):
                repeat.add(tree)
            else:
                seen[serial] = node
            
            return serial
        
        seen = dict()
        repeat = set()

        dfs(root)
        return list(repeat)
```

```C [sol1-C]
typedef struct {
    char *key;
    struct TreeNode *val;
    UT_hash_handle hh;
} HashMapItem; 

typedef struct {
    void *key;
    UT_hash_handle hh;
} HashSetItem; 

char* dfs(struct TreeNode* node, HashMapItem **seen, HashSetItem **repeat) {
    if (!node) {
        return "";
    }
    char *str1 = dfs(node->left, seen, repeat);
    char *str2 = dfs(node->right, seen, repeat);
    char *serial = (char *)malloc(sizeof(char *) * (8 + strlen(str1) + strlen(str2)));
    sprintf(serial, "%d(%s)(%s)", node->val, str1, str2);
    HashMapItem *pHashMapEntry = NULL;
    HASH_FIND_STR(*seen, serial, pHashMapEntry);
    if (pHashMapEntry) {
        HashSetItem *pHashSetEntry = NULL;
        HASH_FIND_PTR(*repeat, &(pHashMapEntry->val), pHashSetEntry);
        if (pHashSetEntry == NULL) {
            pHashSetEntry = (HashSetItem *)malloc(sizeof(HashSetItem));
            pHashSetEntry->key = (void *)pHashMapEntry->val;
            HASH_ADD_PTR(*repeat, key, pHashSetEntry);
        }
    } else {
        pHashMapEntry = (HashMapItem *)malloc(sizeof(HashMapItem));
        pHashMapEntry->key = serial;
        pHashMapEntry->val = node;
        HASH_ADD_STR(*seen, key, pHashMapEntry);
    }
    return serial;
}

struct TreeNode** findDuplicateSubtrees(struct TreeNode* root, int* returnSize){
    HashMapItem *seen = NULL;
    HashSetItem *repeat = NULL;
    dfs(root, &seen, &repeat);

    int count = HASH_COUNT(repeat), pos = 0;
    struct TreeNode** ret = (struct TreeNode**)malloc(sizeof(struct TreeNode*) * count);
    HashSetItem *cur, *tmp;
    HASH_ITER(hh, repeat, cur, tmp) {
        ret[pos++] = (struct TreeNode*)cur->key;
        HASH_DEL(repeat, cur);
        free(cur);            
    }
    *returnSize = count;
    HashMapItem *curMap, *tmpMap;
    HASH_ITER(hh, seen, curMap, tmpMap) {
        HASH_DEL(seen, curMap);  
        free(curMap->key);
        free(curMap);             
    }
    return ret;
}
```

```go [sol1-Golang]
func findDuplicateSubtrees(root *TreeNode) []*TreeNode {
    repeat := map[*TreeNode]struct{}{}
    seen := map[string]*TreeNode{}
    var dfs func(*TreeNode) string
    dfs = func(node *TreeNode) string {
        if node == nil {
            return ""
        }
        serial := fmt.Sprintf("%d(%s)(%s)", node.Val, dfs(node.Left), dfs(node.Right))
        if n, ok := seen[serial]; ok {
            repeat[n] = struct{}{}
        } else {
            seen[serial] = node
        }
        return serial
    }
    dfs(root)
    ans := make([]*TreeNode, 0, len(repeat))
    for node := range repeat {
        ans = append(ans, node)
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var findDuplicateSubtrees = function(root) {
    const seen = new Map();
    const repeat = new Set();
    const dfs = (node) => {
        if (!node) {
            return "";
        }
        let sb = '';
        sb += node.val;
        sb += "(";
        sb += dfs(node.left);
        sb += ")(";
        sb += dfs(node.right);
        sb += ")";
        if (seen.has(sb)) {
            repeat.add(seen.get(sb));
        } else {
            seen.set(sb, node);
        }
        return sb;
    }
    dfs(root);
    return [...repeat];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是树中节点的数目。在最坏情况下，树呈现链状的结构，而每一个节点都会在其左右子树序列的基础上再增加最多 $9$ 个字符（两组括号以及节点本身的值），那么所有子树的序列长度之和为 $\sum_{i=1}^n 9n = O(n^2)$。构造出这些序列就需要 $O(n^2)$ 的时间。

- 空间复杂度：$O(n^2)$，即为哈希表需要使用的空间。

#### 方法二：使用三元组进行唯一表示

**思路与算法**

通过方法一中的递归序列化技巧，我们可以进一步进行优化。

我们可以用一个三元组直接表示一棵子树，即 $(x, l, r)$，它们分别表示：

- 根节点的值为 $x$；

- 左子树的**序号**为 $l$；

- 右子树的**序号**为 $r$。

这里的「序号」指的是：每当我们发现一棵新的子树，就给这棵子树一个序号，用来表示其结构。那么两棵树是重复的，当且仅当它们对应的三元组完全相同。

使用「序号」的好处在于同时减少了时间复杂度和空间复杂度。方法一的瓶颈在于生成的序列会变得非常长，而使用序号替换整个左子树和右子树的序列，可以使得每一个节点只使用常数大小的空间。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<TreeNode*> findDuplicateSubtrees(TreeNode* root) {
        dfs(root);
        return {repeat.begin(), repeat.end()};
    }

    int dfs(TreeNode* node) {
        if (!node) {
            return 0;
        }
        auto tri = tuple{node->val, dfs(node->left), dfs(node->right)};
        if (auto it = seen.find(tri); it != seen.end()) {
            repeat.insert(it->second.first);
            return it->second.second;
        }
        else {
            seen[tri] = {node, ++idx};
            return idx;
        }
    }

private:
    static constexpr auto tri_hash = [fn = hash<int>()](const tuple<int, int, int>& o) -> size_t {
        auto&& [x, y, z] = o;
        return (fn(x) << 24) ^ (fn(y) << 8) ^ fn(z);
    };

    unordered_map<tuple<int, int, int>, pair<TreeNode*, int>, decltype(tri_hash)> seen{0, tri_hash};
    unordered_set<TreeNode*> repeat;
    int idx = 0;
};
```

```Java [sol2-Java]
class Solution {
    Map<String, Pair<TreeNode, Integer>> seen = new HashMap<String, Pair<TreeNode, Integer>>();
    Set<TreeNode> repeat = new HashSet<TreeNode>();
    int idx = 0;

    public List<TreeNode> findDuplicateSubtrees(TreeNode root) {
        dfs(root);
        return new ArrayList<TreeNode>(repeat);
    }

    public int dfs(TreeNode node) {
        if (node == null) {
            return 0;
        }
        int[] tri = {node.val, dfs(node.left), dfs(node.right)};
        String hash = Arrays.toString(tri);
        if (seen.containsKey(hash)) {
            Pair<TreeNode, Integer> pair = seen.get(hash);
            repeat.add(pair.getKey());
            return pair.getValue();
        } else {
            seen.put(hash, new Pair<TreeNode, Integer>(node, ++idx));
            return idx;
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    Dictionary<string, Tuple<TreeNode, int>> seen = new Dictionary<string, Tuple<TreeNode, int>>();
    ISet<TreeNode> repeat = new HashSet<TreeNode>();
    int idx = 0;

    public IList<TreeNode> FindDuplicateSubtrees(TreeNode root) {
        DFS(root);
        return new List<TreeNode>(repeat);
    }

    public int DFS(TreeNode node) {
        if (node == null) {
            return 0;
        }
        Tuple<int, int, int> tri = new Tuple<int, int, int>(node.val, DFS(node.left), DFS(node.right));
        string hash = tri.ToString();
        if (seen.ContainsKey(hash)) {
            Tuple<TreeNode, int> pair = seen[hash];
            repeat.Add(pair.Item1);
            return pair.Item2;
        } else {
            seen.Add(hash, new Tuple<TreeNode, int>(node, ++idx));
            return idx;
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def findDuplicateSubtrees(self, root: Optional[TreeNode]) -> List[Optional[TreeNode]]:
        def dfs(node: Optional[TreeNode]) -> int:
            if not node:
                return 0
            
            tri = (node.val, dfs(node.left), dfs(node.right))
            if tri in seen:
                (tree, index) = seen[tri]
                repeat.add(tree)
                return index
            else:
                nonlocal idx
                idx += 1
                seen[tri] = (node, idx)
                return idx
        
        idx = 0
        seen = dict()
        repeat = set()

        dfs(root)
        return list(repeat)
```

```C [sol2-C]
#define MAX_STR_LEN 32

static inline char* tri_hash(int x, int y, int z) {
    char *str = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    sprintf(str, "%d,%d,%d", x, y, z);
    return str;
}

typedef struct {
    char key[MAX_STR_LEN];
    struct TreeNode *node;
    int idx;
    UT_hash_handle hh;
} HashMapItem; 

typedef struct {
    void *key;
    UT_hash_handle hh;
} HashSetItem; 

int dfs(struct TreeNode* node, HashMapItem **seen, HashSetItem **repeat, int *idx) {
    if (!node) {
        return 0;
    }
    int ret1 = dfs(node->left, seen, repeat, idx);
    int ret2 = dfs(node->right, seen, repeat, idx);
    HashMapItem *pHashMapEntry = NULL;
    char *hashKey = tri_hash(node->val, ret1, ret2);
    HASH_FIND_STR(*seen, hashKey, pHashMapEntry);
    if (pHashMapEntry) {
        HashSetItem *pHashSetEntry = NULL;
        HASH_FIND_PTR(*repeat, &(pHashMapEntry->node), pHashSetEntry);
        if (pHashSetEntry == NULL) {
            pHashSetEntry = (HashSetItem *)malloc(sizeof(HashSetItem));
            pHashSetEntry->key = (void *)pHashMapEntry->node;
            HASH_ADD_PTR(*repeat, key, pHashSetEntry);
        }
        free(hashKey);
        return pHashMapEntry->idx;
    } else {
        pHashMapEntry = (HashMapItem *)malloc(sizeof(HashMapItem));
        strcpy(pHashMapEntry->key, hashKey);
        pHashMapEntry->node = node;
        pHashMapEntry->idx = ++(*idx);
        HASH_ADD_STR(*seen, key, pHashMapEntry);
        free(hashKey);
        return *idx;
    }
}

struct TreeNode** findDuplicateSubtrees(struct TreeNode* root, int* returnSize){
    HashMapItem *seen = NULL;
    HashSetItem *repeat = NULL;
    int idx = 0;
    dfs(root, &seen, &repeat, &idx);

    int count = HASH_COUNT(repeat), pos = 0;
    struct TreeNode** ret = (struct TreeNode**)malloc(sizeof(struct TreeNode*) * count);
    HashSetItem *cur, *tmp;
    HASH_ITER(hh, repeat, cur, tmp) {
        ret[pos++] = (struct TreeNode*)cur->key;
        HASH_DEL(repeat, cur);
        free(cur);            
    }
    *returnSize = count;
    HashMapItem *curMap, *tmpMap;
    HASH_ITER(hh, seen, curMap, tmpMap) {
        HASH_DEL(seen, curMap);  
        free(curMap);             
    }
    return ret;
}
```

```go [sol2-Golang]
func findDuplicateSubtrees(root *TreeNode) []*TreeNode {
    type pair struct {
        node *TreeNode
        idx  int
    }
    repeat := map[*TreeNode]struct{}{}
    seen := map[[3]int]pair{}
    idx := 0
    var dfs func(*TreeNode) int
    dfs = func(node *TreeNode) int {
        if node == nil {
            return 0
        }
        tri := [3]int{node.Val, dfs(node.Left), dfs(node.Right)}
        if p, ok := seen[tri]; ok {
            repeat[p.node] = struct{}{}
            return p.idx
        }
        idx++
        seen[tri] = pair{node, idx}
        return idx
    }
    dfs(root)
    ans := make([]*TreeNode, 0, len(repeat))
    for node := range repeat {
        ans = append(ans, node)
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
var findDuplicateSubtrees = function(root) {
    const seen = new Map();
    const repeat = new Set();
    let idx = 0;
    const dfs = (node) => {
        if (!node) {
            return 0;
        }
        const tri = [node.val, dfs(node.left), dfs(node.right)];
        const hash = tri.toString();
        if (seen.has(hash)) {
            const pair = seen.get(hash);
            repeat.add(pair[0]);
            return pair[1];
        } else {
            seen.set(hash, [node, ++idx]);
            return idx;
        }
    }
    dfs(root);
    return [...repeat];
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中节点的数目。

- 空间复杂度：$O(n)$，即为哈希表需要使用的空间。