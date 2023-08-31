## [590.N 叉树的后序遍历 中文官方题解](https://leetcode.cn/problems/n-ary-tree-postorder-traversal/solutions/100000/n-cha-shu-de-hou-xu-bian-li-by-leetcode-txesi)
#### 方法一：递归

**思路**

递归思路比较简单，$N$ 叉树的前序遍历与二叉树的后序遍历的思路和方法基本一致，可以参考「[145. 二叉树的后序遍历](https://leetcode-cn.com/problems/binary-tree-postorder-traversal/)」的方法，每次递归时，先递归访问每个孩子节点，然后再访问根节点即可。

**代码**

```Java [sol1-Java]
class Solution {
    public List<Integer> postorder(Node root) {
        List<Integer> res = new ArrayList<>();
        helper(root, res);
        return res;
    }

    public void helper(Node root, List<Integer> res) {
        if (root == null) {
            return;
        }
        for (Node ch : root.children) {
            helper(ch, res);
        }
        res.add(root.val);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    void helper(const Node* root, vector<int> & res) {
        if (root == nullptr) {
            return;
        }
        for (auto & ch : root->children) {
            helper(ch, res);
        }
        res.emplace_back(root->val);
    }

    vector<int> postorder(Node* root) {
        vector<int> res;
        helper(root, res);
        return res;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public IList<int> Postorder(Node root) {
        IList<int> res = new List<int>();
        Helper(root, res);
        return res;
    }

    public void Helper(Node root, IList<int> res) {
        if (root == null) {
            return;
        }
        foreach (Node ch in root.children) {
            Helper(ch, res);
        }
        res.Add(root.val);
    }
}
```

```C [sol1-C]
#define MAX_NODE_SIZE 10000

void helper(const struct Node* root, int* res, int* pos) {
    if (NULL == root) {
        return;
    }
    for (int i = 0; i < root->numChildren; i++) {
        helper(root->children[i], res, pos);
    }
    res[(*pos)++] = root->val;
}

int* postorder(struct Node* root, int* returnSize) {
    int * res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int pos = 0;
    helper(root, res, &pos);
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var postorder = function(root) {
    const res = [];
        helper(root, res);
        return res;
    }

const helper = (root, res) => {
    if (root == null) {
        return;
    }
    for (const ch of root.children) {
        helper(ch, res);
    }
    res.push(root.val);
};
```

```Python [sol1-Python3]
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        ans = []
        def dfs(node: 'Node'):
            if node is None:
                return
            for ch in node.children:
                dfs(ch)
            ans.append(node.val)
        dfs(root)
        return ans
```

```go [sol1-Golang]
func postorder(root *Node) (ans []int) {
    var dfs func(*Node)
    dfs = func(node *Node) {
        if node == nil {
            return
        }
        for _, ch := range node.Children {
            dfs(ch)
        }
        ans = append(ans, node.Val)
    }
    dfs(root)
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。每个节点恰好被遍历一次。

- 空间复杂度：$O(m)$，递归过程中需要调用栈的开销，平均情况下为 $O(\log m)$，最坏情况下树的深度为 $m-1$，需要的空间为 $O(m-1)$，因此空间复杂度为 $O(m)$。

#### 方法二：迭代

**思路**

方法一中利用递归来遍历树，实际的递归中隐式利用了栈，在此我们可以直接模拟递归中栈的调用。在后序遍历中从左向右依次先序遍历该每个以子节点为根的子树，然后先遍历节点本身。

在这里的栈模拟中比较难处理的在于从当前节点 $u$ 的子节点 $v_1$ 返回时，此时需要处理节点 $u$ 的下一个节点 $v_2$，此时需要记录当前已经遍历完成哪些子节点，才能找到下一个需要遍历的节点。在二叉树树中因为只有左右两个子节点，因此比较方便处理，在 $N$ 叉树中由于有多个子节点，因此使用哈希表记录当前节点 $u$ 已经访问过哪些子节点。

+ 每次入栈时都将当前节点的 $u$ 的第一个子节点压入栈中，直到当前节点为空节点为止。

+ 每次查看栈顶元素 $p$，如果节点 $p$ 的子节点已经全部访问过，则记录当前节点的值，并将节点 $p$ 的从栈中弹出，并从哈希表中移除，表示该以该节点的子树已经全部遍历过；如果当前节点 $p$ 的子节点还有未遍历的，则将当前节点的 $p$ 的下一个未访问的节点压入到栈中，重复上述的入栈操作。

**代码**

```Java [sol2-Java]
class Solution {
    public List<Integer> postorder(Node root) {
        List<Integer> res = new ArrayList<Integer>();
        if (root == null) {
            return res;
        }
        Map<Node, Integer> map = new HashMap<Node, Integer>();
        Deque<Node> stack = new ArrayDeque<Node>();
        Node node = root;
        while (!stack.isEmpty() || node != null) {
            while (node != null) {
                stack.push(node);
                List<Node> children = node.children;
                if (children != null && children.size() > 0) {
                    map.put(node, 0);
                    node = children.get(0);
                } else {
                    node = null;
                }
            }
            node = stack.peek();
            int index = map.getOrDefault(node, -1) + 1;
            List<Node> children = node.children;
            if (children != null && children.size() > index) {
                map.put(node, index);
                node = children.get(index);
            } else {
                res.add(node.val);
                stack.pop();
                map.remove(node);
                node = null;
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> postorder(Node* root) {
        vector<int> res;
        if (root == nullptr) {
            return res;
        }
        
        unordered_map<Node *, int> cnt;
        stack<Node *> st;
        Node * node = root;
        while (!st.empty() || node != nullptr) {
            while (node != nullptr) {
                st.emplace(node);
                if (node->children.size() > 0) {
                    cnt[node] = 0;
                    node = node->children[0];
                } else {
                    node = nullptr;
                }         
            }
            node = st.top();
            int index = cnt.count(node) ? (cnt[node] + 1) : 0;
            if (index < node->children.size()) {
                cnt[node] = index;
                node = node->children[index];
            } else {
                res.emplace_back(node->val);
                st.pop();
                cnt.erase(node);
                node = nullptr;
            }
        }
        return res;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public IList<int> Postorder(Node root) {
        IList<int> res = new List<int>();
        if (root == null) {
            return res;
        }
        Dictionary<Node, int> dictionary = new Dictionary<Node, int>();
        Stack<Node> stack = new Stack<Node>();
        Node node = root;
        while (stack.Count > 0 || node != null) {
            while (node != null) {
                stack.Push(node);
                IList<Node> childrenList = node.children;
                if (childrenList != null && childrenList.Count > 0) {
                    dictionary.Add(node, 0);
                    node = childrenList[0];
                } else {
                    node = null;
                }
            }
            node = stack.Peek();
            int index = (dictionary.ContainsKey(node) ? dictionary[node] : -1) + 1;
            IList<Node> children = node.children;
            if (children != null && children.Count > index) {
                dictionary[node] = index;
                node = children[index];
            } else {
                res.Add(node.val);
                stack.Pop();
                dictionary.Remove(node);
                node = null;
            }
        }
        return res;
    }
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 10000

typedef struct {
    void * key;
    int val;
    UT_hash_handle hh; 
} HashItem;

void freeHash(HashItem ** obj) {
    HashItem * curr = NULL, * next = NULL;
    HASH_ITER(hh, *obj, curr, next) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

int* postorder(struct Node* root, int* returnSize) {
    if (NULL == root) {
        *returnSize = 0;
        return NULL;
    }
    int * res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    struct Node ** stack = (struct Node **)malloc(sizeof(struct Node *) * MAX_NODE_SIZE);
    int pos = 0, top = 0;  

    struct Node * node = root;
    HashItem * cnt = NULL;
    HashItem * pEntry = NULL;
    while (top != 0 || node != NULL) {
        while (node != NULL) {
            stack[top++] = node;
            if (node->numChildren > 0) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = node;
                pEntry->val = 0;
                HASH_ADD_PTR(cnt, key, pEntry);
                node = node->children[0];
            } else {
                node = NULL;
            }
        }
        node = stack[top - 1];
        int index = 0;
        HASH_FIND_PTR(cnt, &node, pEntry);
        if (pEntry != NULL) {
            index = pEntry->val + 1;
        }
        if (index < node->numChildren) {
            pEntry->val++;
            node = node->children[index];
        } else {
            top--;
            res[pos++] = node->val;
            if (pEntry != NULL) {
                HASH_DEL(cnt, pEntry);
            }
            node = NULL;
        }
    }
    free(stack);
    freeHash(&cnt);
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol2-JavaScript]
var postorder = function(root) {
    const res = [];
    if (root == null) {
        return res;
    }
    const map = new Map();
    const stack = [];
    let node = root;
    while (stack.length || node) {
        while (node) {
            stack.push(node);
            const children = node.children;
            if (children && children.length > 0) {
                map.set(node, 0);
                node = children[0];
            } else {
                node = null;
            }
        }
        node = stack[stack.length - 1];
        const index = (map.get(node) || 0) + 1;
        const children = node.children;
        if (children && children.length > index) {
            map.set(node, index);
            node = children[index];
        } else {
            res.push(node.val);
            stack.pop();
            map.delete(node);
            node = null;
        }
    }
    return res;
};
```

```Python [sol2-Python3]
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        if root is None:
            return []
        ans = []
        st = []
        nextIndex = defaultdict(int)
        node = root
        while st or node:
            while node:
                st.append(node)
                if not node.children:
                    break
                nextIndex[node] = 1
                node = node.children[0]
            node = st[-1]
            i = nextIndex[node]
            if i < len(node.children):
                nextIndex[node] = i + 1
                node = node.children[i]
            else:
                ans.append(node.val)
                st.pop()
                del nextIndex[node]
                node = None
        return ans
```

```go [sol2-Golang]
func postorder(root *Node) (ans []int) {
    if root == nil {
        return
    }
    st := []*Node{}
    nextIndex := map[*Node]int{}
    node := root
    for len(st) > 0 || node != nil {
        for node != nil {
            st = append(st, node)
            if len(node.Children) == 0 {
                break
            }
            nextIndex[node] = 1
            node = node.Children[0]
        }
        node = st[len(st)-1]
        i := nextIndex[node]
        if i < len(node.Children) {
            nextIndex[node] = i + 1
            node = node.Children[i]
        } else {
            ans = append(ans, node.Val)
            st = st[:len(st)-1]
            delete(nextIndex, node)
            node = nil
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。每个节点恰好被访问一次。

- 空间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。如果 $N$ 叉树的深度为 $1$ 则此时栈和哈希表的空间为 $O(1)$，如果 $N$ 叉树的深度为 $m-1$ 则此时栈和哈希表的空间为 $O(m-1)$，平均情况下栈和哈希表的空间为 $O(\log m)$，因此空间复杂度为 $O(m)$。

#### 方法三：迭代优化

**思路**

在后序遍历中，我们会先从左向右依次后序遍历每个子节点为根的子树，再遍历根节点本身。此时利用栈先进后出的原理，依次从右向左将子节点入栈，这样出栈的时候即可保证从左向右依次遍历每个子树。参考方法二的原理，可以提前将后续需要访问的节点压入栈中。

首先把根节点入栈，因为根节点是前序遍历中的第一个节点。随后每次我们找到栈顶节点 $u$，如果当前节点的子节点没有遍历过，则应该先把 $u$ 的所有子节点从右向左逆序压入栈中，这样出栈的节点则是顺序从左向右的，同时对节点 $u$ 进行标记，表示该节点的子节点已经全部入栈；如果当前节点 $u$ 为叶子节点或者当前节点的子节点已经全部遍历过，则从栈中弹出节点 $u$，并记录节点 $u$ 的值。例如 $u$ 的子节点从左到右为 $v_1, v_2, v_3$，那么入栈的顺序应当为 $v_3, v_2, v_1$，这样就保证了下一个遍历到的节点（即 $u$ 的左侧第一个孩子节点 $v_1$）出现在栈顶的位置。此时，访问第一个子节点 $v_1$ 时，仍然按照此方法则会先访问 $v_1$ 的左侧第一个孩子节点。

**代码**

```Java [sol3-Java]
class Solution {
    public List<Integer> postorder(Node root) {
        List<Integer> res = new ArrayList<>();
        if (root == null) {
            return res;
        }

        Deque<Node> stack = new ArrayDeque<Node>();
        Set<Node> visited = new HashSet<Node>();
        stack.push(root);
        while (!stack.isEmpty()) {
            Node node = stack.peek();
            /* 如果当前节点为叶子节点或者当前节点的子节点已经遍历过 */
            if (node.children.size() == 0 || visited.contains(node)) {
                stack.pop();
                res.add(node.val);
                continue;
            }
            for (int i = node.children.size() - 1; i >= 0; --i) {
                stack.push(node.children.get(i));
            }
            visited.add(node);
        }
        return res;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    vector<int> postorder(Node* root) {
        vector<int> res;
        if (root == nullptr) {
            return res;
        }

        stack<Node *> st;
        unordered_set<Node *> visited;
        st.emplace(root);
        while (!st.empty()) {
            Node * node = st.top();
            /* 如果当前节点为叶子节点或者当前节点的子节点已经遍历过 */
            if (node->children.size() == 0 || visited.count(node)) {
                res.emplace_back(node->val);
                st.pop();
                continue;
            }
            for (auto it = node->children.rbegin(); it != node->children.rend(); it++) {
                st.emplace(*it);
            }
            visited.emplace(node);
        }       
        return res;
    }
};
```

```C# [sol3-C#]
public class Solution {
    public IList<int> Postorder(Node root) {
        IList<int> res = new List<int>();
        if (root == null) {
            return res;
        }

        Stack<Node> stack = new Stack<Node>();
        ISet<Node> visited = new HashSet<Node>();
        stack.Push(root);
        while (stack.Count > 0) {
            Node node = stack.Peek();
            /* 如果当前节点为叶子节点或者当前节点的子节点已经遍历过 */
            if (node.children.Count == 0 || visited.Contains(node)) {
                stack.Pop();
                res.Add(node.val);
                continue;
            }
            for (int i = node.children.Count - 1; i >= 0; i--) {
                stack.Push(node.children[i]);
            }
            visited.Add(node);
        }
        return res;
    }
}
```

```C [sol3-C]
#define MAX_NODE_SIZE 10000

typedef struct {
    void * key;
    UT_hash_handle hh; 
} HashItem;

void freeHash(HashItem ** obj) {
    HashItem * curr = NULL, * next = NULL;
    HASH_ITER(hh, *obj, curr, next) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

int* postorder(struct Node* root, int* returnSize) {
    if (NULL == root) {
        *returnSize = 0;
        return NULL;
    }
    int * res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    struct Node ** stack = (struct Node **)malloc(sizeof(struct Node *) * MAX_NODE_SIZE);
    int pos = 0, top = 0;  

    stack[top++] = root;
    HashItem * visited = NULL;
    HashItem * pEntry = NULL;
    while (top != 0) {
        struct Node * node = stack[top - 1];
        pEntry = NULL;
        HASH_FIND_PTR(visited, &node, pEntry);
        /* 如果当前节点为叶子节点或者当前节点的子节点已经遍历过 */
        if (node->numChildren == 0 || NULL != pEntry) {
            res[pos++] = node->val;
            top--;
            continue;
        }
        for (int i = node->numChildren - 1; i >= 0; i--) {
            stack[top++] = node->children[i];
        }
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = node;
        HASH_ADD_PTR(visited, key, pEntry);
    }
    free(stack);
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol3-JavaScript]
var postorder = function(root) {
    const res = [];
    if (root == null) {
        return res;
    }

    const stack = [];
    const visited = new Set();
    stack.push(root);
    while (stack.length) {
        const node = stack[stack.length - 1];
        /* 如果当前节点为叶子节点或者当前节点的子节点已经遍历过 */
        if (node.children.length === 0 || visited.has(node)) {
            stack.pop();
            res.push(node.val);
            continue;
        }
        for (let i = node.children.length - 1; i >= 0; --i) {
            stack.push(node.children[i]);
        }
        visited.add(node);
    }
    return res;
};
```

```Python [sol3-Python3]
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        if root is None:
            return []
        ans = []
        st = [root]
        vis = set()
        while st:
            node = st[-1]
            # 如果当前节点为叶子节点或者当前节点的子节点已经遍历过
            if len(node.children) == 0 or node in vis:
                ans.append(node.val)
                st.pop()
                continue
            st.extend(reversed(node.children))
            vis.add(node)
        return ans
```

```go [sol3-Golang]
func postorder(root *Node) (ans []int) {
    if root == nil {
        return
    }
    st := []*Node{root}
    vis := map[*Node]bool{}
    for len(st) > 0 {
        node := st[len(st)-1]
        // 如果当前节点为叶子节点或者当前节点的子节点已经遍历过
        if len(node.Children) == 0 || vis[node] {
            ans = append(ans, node.Val)
            st = st[:len(st)-1]
            continue
        }
        for i := len(node.Children) - 1; i >= 0; i-- {
            st = append(st, node.Children[i])
        }
        vis[node] = true
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。每个节点恰好被访问一次。

- 空间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。哈希表的空间为 $O(m)$，栈的空间与树的深度相同，栈的空间最大为 $O(m-1)$，因此空间复杂度为 $O(m)$。

#### 方法四：利用前序遍历反转

**思路**

在前序遍历中，我们会先遍历节点本身，然后从左向右依次先序遍历该每个以子节点为根的子树，而在后序遍历中，需要先从左到右依次遍历每个以子节点为根的子树，然后再访问根节点。

例如：当前的节点为 $u$，它的从左至右子节点依次为 $v_1, v_2, v_3$ 时，此时我们可以知道它的前序遍历结果为：
$$
[u, v_1, \textit{children}(v_1), v_2, \textit{children}(v_2), v_3, \textit{children}(v_3)]
$$
后序遍历结果为:
$$
[\textit{children}(v_1), v_1, \textit{children}(v_2), v_2, \textit{children}(v_3), v_3, u]
$$

其中 $\textit{children}(v_k)$ 表示以 $v_k$ 为根节点的子树的遍历结果（不包括 $v_k$）。仔细观察可以知道，将前序遍历中子树的访问顺序改为从右向左可以得到如下访问顺序：
$$
[u, v_3, \textit{children}(v_3), v_2, \textit{children}(v_2), v_1, \textit{children}(v_1)]
$$
将上述的结果进行反转，得到:
$$
[\textit{children}(v_1), v_1, \textit{children}(v_2), v_2, \textit{children}(v_3), v_3, u]
$$
刚好与后续遍历的结果相同。此时我们可以利用前序遍历，只不过前序遍历中对子节点的遍历顺序是从左向右，而这里是从右向左。因此我们可以使用和 $N$ 叉树的前序遍历相同的方法，使用一个栈来得到后序遍历。

我们首先把根节点入栈。当每次我们从栈顶取出一个节点 $u$ 时，就把 $u$ 的所有子节点顺序推入栈中。例如 $u$ 的子节点从左到右为 $v_1, v_2, v_3$，那么推入栈的顺序应当为 $v_1, v_2, v_3$，这样就保证了出栈顺序是从右向左，下一个遍历到的节点（即 $u$ 的右侧第一个子节点 $v_3$）出现在栈顶的位置。在遍历结束之后，我们把遍历结果进行反转，就可以得到后序遍历。

**代码**

```Java [sol4-Java]
class Solution {
    public List<Integer> postorder(Node root) {
        List<Integer> res = new ArrayList<>();
        if (root == null) {
            return res;
        }

        Deque<Node> stack = new ArrayDeque<Node>();
        stack.push(root);
        while (!stack.isEmpty()) {
            Node node = stack.pop();
            res.add(node.val);
            for (Node item : node.children) {
                stack.push(item);
            }
        }
        Collections.reverse(res);
        return res;
    }
}
```

```C++ [sol4-C++]
class Solution {
public:
    vector<int> postorder(Node* root) {
        vector<int> res;
        if (root == nullptr) {
            return res;
        }

        stack<Node *> st;
        st.emplace(root);
        while (!st.empty()) {
            Node * node = st.top();
            st.pop();
            res.emplace_back(node->val);
            for (auto &item : node->children) {
                st.emplace(item);
            }
        }       
        reverse(res.begin(), res.end()); 
        return res;
    }
};
```

```C# [sol4-C#]
public class Solution {
    public IList<int> Postorder(Node root) {
        IList<int> res = new List<int>();
        if (root == null) {
            return res;
        }

        Stack<Node> stack = new Stack<Node>();
        stack.Push(root);
        while (stack.Count > 0) {
            Node node = stack.Pop();
            res.Add(node.val);
            foreach (Node item in node.children) {
                stack.Push(item);
            }
        }
        ((List<int>) res).Reverse();
        return res;
    }
}
```

```C [sol4-C]
#define MAX_NODE_SIZE 10000

int* postorder(struct Node* root, int* returnSize) {
    if (NULL == root) {
        *returnSize = 0;
        return NULL;
    }
    int * res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    struct Node ** stack = (struct Node **)malloc(sizeof(struct Node *) * MAX_NODE_SIZE);
    int pos = 0, top = 0;  

    stack[top++] = root;
    while (top != 0) {
        struct Node * node = stack[--top];
        res[pos++] = node->val;
        for (int i = 0; i < node->numChildren; i++) {
            stack[top++] = node->children[i];
        }
    }
    free(stack);
    for (int l = 0, r = pos - 1; l < r; l++, r--) {
        int tmp = res[l];
        res[l] = res[r];
        res[r] = tmp;
    }
    *returnSize = pos;
    return res;
}
```

```JavaScript [sol4-JavaScript]
var postorder = function(root) {
    const res = [];
    if (root == null) {
        return res;
    }

    const stack = [];
    stack.push(root);
    while (stack.length) {
        const node = stack.pop();
        res.push(node.val);
        for (const item of node.children) {
            stack.push(item);
        }
    }
    res.reverse();
    return res;
};
```

```Python [sol4-Python3]
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        if root is None:
            return []
        ans = []
        st = [root]
        while st:
            node = st.pop()
            ans.append(node.val)
            st.extend(node.children)
        ans.reverse()
        return ans
```

```go [sol4-Golang]
func postorder(root *Node) (ans []int) {
    if root == nil {
        return
    }
    st := []*Node{root}
    for len(st) > 0 {
        node := st[len(st)-1]
        st = st[:len(st)-1]
        ans = append(ans, node.Val)
        st = append(st, node.Children...)
    }
    for i, n := 0, len(ans); i < n/2; i++ {
        ans[i], ans[n-1-i] = ans[n-1-i], ans[i]
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。每个节点恰好被访问一次。

- 空间复杂度：$O(m)$，其中 $m$ 为 $N$ 叉树的节点。如果 $N$ 叉树的深度为 $1$ 则此时栈的空间为 $O(1)$，如果 $N$ 叉树的深度为 $1$ 则此时栈的空间为 $O(m-1)$，平均情况下栈的空间为 $O(\log m)$，因此空间复杂度为 $O(m)$。