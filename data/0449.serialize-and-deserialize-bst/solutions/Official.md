#### 前言

二叉搜索树是一种特殊的二叉树，序列化和反序列化过程也可以参照「[297. 二叉树的序列化与反序列化](https://leetcode.cn/problems/serialize-and-deserialize-binary-tree/solution/er-cha-shu-de-xu-lie-hua-yu-fan-xu-lie-hua-by-le-2/)」的过程。二叉搜索树的特殊之处在于其中序遍历是有序的，可以利用这一点来优化时间和空间复杂度。

#### 方法一：后序遍历

**思路**

给定一棵二叉树的「先序遍历」和「中序遍历」可以恢复这颗二叉树。给定一棵二叉树的「后序遍历」和「中序遍历」也可以恢复这颗二叉树。而对于二叉搜索树，给定「先序遍历」或者「后序遍历」，对其经过排序即可得到「中序遍历」。因此，仅对二叉搜索树做「先序遍历」或者「后序遍历」，即可达到序列化和反序列化的要求。此题解采用「后序遍历」的方法。

序列化时，只需要对二叉搜索树进行后序遍历，再将数组编码成字符串即可。

反序列化时，需要先将字符串解码成后序遍历的数组。在将后序遍历的数组恢复成二叉搜索树时，不需要先排序得到中序遍历的数组再根据中序和后序遍历的数组来恢复二叉树，而可以根据有序性直接由后序遍历的数组恢复二叉搜索树。后序遍历得到的数组中，根结点的值位于数组末尾，左子树的节点均小于根节点的值，右子树的节点均大于根节点的值，可以根据这些性质设计递归函数恢复二叉搜索树。

**代码**

```Python [sol1-Python3]
class Codec:
    def serialize(self, root: TreeNode) -> str:
        arr = []
        def postOrder(root: TreeNode) -> None:
            if root is None:
                return
            postOrder(root.left)
            postOrder(root.right)
            arr.append(root.val)
        postOrder(root)
        return ' '.join(map(str, arr))

    def deserialize(self, data: str) -> TreeNode:
        arr = list(map(int, data.split()))
        def construct(lower: int, upper: int) -> TreeNode:
            if arr == [] or arr[-1] < lower or arr[-1] > upper:
                return None
            val = arr.pop()
            root = TreeNode(val)
            root.right = construct(val, upper)
            root.left = construct(lower, val)
            return root
        return construct(-inf, inf)
```

```Java [sol1-Java]
public class Codec {
    public String serialize(TreeNode root) {
        List<Integer> list = new ArrayList<Integer>();
        postOrder(root, list);
        String str = list.toString();
        return str.substring(1, str.length() - 1);
    }

    public TreeNode deserialize(String data) {
        if (data.isEmpty()) {
            return null;
        }
        String[] arr = data.split(", ");
        Deque<Integer> stack = new ArrayDeque<Integer>();
        int length = arr.length;
        for (int i = 0; i < length; i++) {
            stack.push(Integer.parseInt(arr[i]));
        }
        return construct(Integer.MIN_VALUE, Integer.MAX_VALUE, stack);
    }

    private void postOrder(TreeNode root, List<Integer> list) {
        if (root == null) {
            return;
        }
        postOrder(root.left, list);
        postOrder(root.right, list);
        list.add(root.val);
    }

    private TreeNode construct(int lower, int upper, Deque<Integer> stack) {
        if (stack.isEmpty() || stack.peek() < lower || stack.peek() > upper) {
            return null;
        }
        int val = stack.pop();
        TreeNode root = new TreeNode(val);
        root.right = construct(val, upper, stack);
        root.left = construct(lower, val, stack);
        return root;
    }
}
```

```C# [sol1-C#]
public class Codec {
    public string serialize(TreeNode root) {
        IList<int> list = new List<int>();
        PostOrder(root, list);
        return string.Join(",", list);
    }

    public TreeNode deserialize(string data) {
        if (data.Length == 0) {
            return null;
        }
        string[] arr = data.Split(",");
        Stack<int> stack = new Stack<int>();
        int length = arr.Length;
        for (int i = 0; i < length; i++) {
            stack.Push(int.Parse(arr[i]));
        }
        return Construct(int.MinValue, int.MaxValue, stack);
    }

    private void PostOrder(TreeNode root, IList<int> list) {
        if (root == null) {
            return;
        }
        PostOrder(root.left, list);
        PostOrder(root.right, list);
        list.Add(root.val);
    }

    private TreeNode Construct(int lower, int upper, Stack<int> stack) {
        if (stack.Count == 0 || stack.Peek() < lower || stack.Peek() > upper) {
            return null;
        }
        int val = stack.Pop();
        TreeNode root = new TreeNode(val);
        root.right = Construct(val, upper, stack);
        root.left = Construct(lower, val, stack);
        return root;
    }
}
```

```C++ [sol1-C++]
class Codec {
public:
    string serialize(TreeNode* root) {
        string res;
        vector<int> arr;
        postOrder(root, arr);
        if (arr.size() == 0) {
            return res;
        }
        for (int i = 0; i < arr.size() - 1; i++) {
            res.append(to_string(arr[i]) + ",");
        }
        res.append(to_string(arr.back()));
        return res;
    }

    vector<string> split(const string &str, char dec) {
        int pos = 0;
        int start = 0;
        vector<string> res;
        while (pos < str.size()) {
            while (pos < str.size() && str[pos] == dec) {
                pos++;
            }
            start = pos;
            while (pos < str.size() && str[pos] != dec) {
                pos++;
            }
            if (start < str.size()) {
                res.emplace_back(str.substr(start, pos - start));
            }
        }
        return res;
    }

    TreeNode* deserialize(string data) {
        if (data.size() == 0) {
            return nullptr;
        }
        vector<string> arr = split(data, ',');
        stack<int> st;
        for (auto & str : arr) {
            st.emplace(stoi(str));
        }
        return construct(INT_MIN, INT_MAX, st);
    }

    void postOrder(TreeNode *root,vector<int> & arr) {
        if (root == nullptr) {
            return;
        }
        postOrder(root->left, arr);
        postOrder(root->right, arr);
        arr.emplace_back(root->val);
    }

    TreeNode * construct(int lower, int upper, stack<int> & st) {
        if (st.size() == 0 || st.top() < lower || st.top() > upper) {
            return nullptr;
        }
        int val = st.top();
        st.pop();
        TreeNode *root = new TreeNode(val);
        root->right = construct(val, upper, st);
        root->left = construct(lower, val, st);
        return root;
    }
};
```

```C [sol1-C]
#define MAX_NODE_SIZE 10000

void postOrder(struct TreeNode *root, int *arr, int *pos) {
    if (root == NULL) {
        return;
    }
    postOrder(root->left, arr, pos);
    postOrder(root->right, arr, pos);
    arr[(*pos)++] = root->val;
}

struct TreeNode * construct(int lower, int upper, int *stack, int *top) {
    if (*top == 0 || stack[*top - 1] < lower || stack[*top - 1] > upper) {
        return NULL;
    }
    int val = stack[*top - 1];
    (*top)--;
    struct TreeNode *root = (struct TreeNode *)malloc(sizeof(struct TreeNode));
    root->val = val;
    root->right = construct(val, upper, stack, top);
    root->left = construct(lower, val, stack, top);
    return root;
}

char* serialize(struct TreeNode* root) {
    char *res = NULL;
    int *arr = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int pos = 0;
    postOrder(root, arr, &pos);
    if (pos == 0) {
        return "";
    }
    res = (char *)malloc(sizeof(char) * pos * 6);
    int len = 0;
    for (int i = 0; i < pos - 1; i++) {
        len += sprintf(res + len, "%d,", arr[i]);
    }
    sprintf(res + len, "%d", arr[pos - 1]);
    free(arr);
    return res;
}

struct TreeNode* deserialize(char* data) {
    int len = strlen(data);
    if (len == 0) {
        return NULL;
    }
    int *stack = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int pos = 0;
    int top = 0;
    while (pos < len) {
        while (pos < len && data[pos] == ',') {
            pos++;
        }
        int val = 0;
        int start = pos;
        while (pos < len && data[pos] != ',') {
            val = val * 10 + data[pos] - '0';
            pos++;
        }
        if (start < pos) {
            stack[top++] = val;
        }
    }
    struct TreeNode *root = construct(INT_MIN, INT_MAX, stack, &top);
    free(stack);
    return root;
}
```

```go [sol1-Golang]
type Codec struct{}

func Constructor() (_ Codec) { return }

func (Codec) serialize(root *TreeNode) string {
    arr := []string{}
    var postOrder func(*TreeNode)
    postOrder = func(node *TreeNode) {
        if node == nil {
            return
        }
        postOrder(node.Left)
        postOrder(node.Right)
        arr = append(arr, strconv.Itoa(node.Val))
    }
    postOrder(root)
    return strings.Join(arr, " ")
}

func (Codec) deserialize(data string) *TreeNode {
    if data == "" {
        return nil
    }
    arr := strings.Split(data, " ")
    var construct func(int, int) *TreeNode
    construct = func(lower, upper int) *TreeNode {
        if len(arr) == 0 {
            return nil
        }
        val, _ := strconv.Atoi(arr[len(arr)-1])
        if val < lower || val > upper {
            return nil
        }
        arr = arr[:len(arr)-1]
        return &TreeNode{Val: val, Right: construct(val, upper), Left: construct(lower, val)}
    }
    return construct(math.MinInt32, math.MaxInt32)
}
```

```JavaScript [sol1-JavaScript]
var serialize = function(root) {
    const list = [];

    const postOrder = (root, list) => {
        if (!root) {
            return;
        }
        postOrder(root.left, list);
        postOrder(root.right, list);
        list.push(root.val);
    }

    postOrder(root, list);
    const str = list.join(',');
    return str;
};

var deserialize = function(data) {
    if (data.length === 0) {
        return null;
    }
    let arr = data.split(',');
    const length = arr.length;
    const stack = [];
    for (let i = 0; i < length; i++) {
        stack.push(parseInt(arr[i]));
    }

    const construct = (lower, upper, stack) => {
        if (stack.length === 0 || stack[stack.length - 1] < lower || stack[stack.length - 1] > upper) {
            return null;
        }
        const val = stack.pop();
        const root = new TreeNode(val);
        root.right = construct(val, upper, stack);
        root.left = construct(lower, val, stack);
        return root;
    }

    return construct(-Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER, stack);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树的节点数。$\textit{serialize}$ 需要 $O(n)$ 时间遍历每个点。$\textit{deserialize}$ 需要 $O(n)$ 时间恢复每个点。

- 空间复杂度：$O(n)$，其中 $n$ 是树的节点数。$\textit{serialize}$ 需要 $O(n)$ 空间用数组保存每个点的值，递归的深度最深也为 $O(n)$。$\textit{deserialize}$ 需要 $O(n)$ 空间用数组保存每个点的值，递归的深度最深也为 $O(n)$。