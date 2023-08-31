## [1600.王位继承顺序 中文官方题解](https://leetcode.cn/problems/throne-inheritance/solutions/100000/huang-wei-ji-cheng-shun-xu-by-leetcode-s-p6lk)

#### 方法一：多叉树的前序遍历

**思路与算法**

我们可以发现，题目中定义的 $\texttt{Successor(x, curOrder)}$ 函数，与多叉树的前序遍历过程是一致的：

- 「返回 $\texttt{x}$ 不在 $\texttt{curOrder}$ 中最年长的孩子」对应着选择 $\texttt{x}$ 在树中的一个子节点，递归地进行遍历操作；

- 「返回 $\texttt{Successor(x} ~的父亲\texttt{, curOrder)}$」对应着当我们将以 $\texttt{x}$ 为根的子树遍历完成后，回溯到 $\texttt{x}$ 的父节点继续进行遍历；

- 「返回 $\texttt{null}$」对应着我们将整棵树遍历完成。

因此，对于题目中需要实现的每一个函数，我们可以分别设计出如下的算法：

- $\texttt{ThroneInheritance(kingName)}$：我们将 $\texttt{kingName}$ 作为树的根节点；

- $\texttt{birth(parentName, childName)}$：我们在树中添加一条从 $\texttt{parentName}$ 到 $\texttt{childName}$ 的边，将 $\texttt{childName}$ 作为 $\texttt{parentName}$ 的子节点；

- $\texttt{death(name)}$：我们使用一个哈希集合记录所有的死亡人员，将 $\texttt{name}$ 加入该哈希集合中；

- $\texttt{getInheritanceOrder()}$：我们从根节点开始对整棵树进行前序遍历。需要注意的是，**如果遍历到死亡人员，那么不能将其加入继承顺序列表中**。

**细节**

那么我们如何存储这棵树呢？

一种可行的方法是使用哈希映射。记哈希映射为 $\textit{edges}$，那么对于 $\textit{edges}$ 中的每一个键值对 $(k, v)$，键 $k$ 表示一个人，值 $v$ 以列表的形式存放了这个人所有的孩子，列表可以为空。

这样一来，对于 $\texttt{birth(parentName, childName)}$ 操作，我们只需要将 $\texttt{childName}$ 加入 $\texttt{parentName}$ 在哈希映射中的列表末尾即可。

**代码**

```C++ [sol1-C++]
class ThroneInheritance {
private:
    unordered_map<string, vector<string>> edges;
    unordered_set<string> dead;
    string king;

public:
    ThroneInheritance(string kingName): king{move(kingName)} {}
    
    void birth(string parentName, string childName) {
        edges[move(parentName)].push_back(move(childName));
    }
    
    void death(string name) {
        dead.insert(move(name));
    }
    
    vector<string> getInheritanceOrder() {
        vector<string> ans;

        function<void(const string&)> preorder = [&](const string& name) {
            if (!dead.count(name)) {
                ans.push_back(name);
            }
            if (edges.count(name)) {
                for (const string& childName: edges[name]) {
                    preorder(childName);
                }
            }
        };

        preorder(king);
        return ans;
    }
};
```

```Java [sol1-Java]
class ThroneInheritance {
    Map<String, List<String>> edges;
    Set<String> dead;
    String king;

    public ThroneInheritance(String kingName) {
        edges = new HashMap<String, List<String>>();
        dead = new HashSet<String>();
        king = kingName;
    }
    
    public void birth(String parentName, String childName) {
        List<String> children = edges.getOrDefault(parentName, new ArrayList<String>());
        children.add(childName);
        edges.put(parentName, children);
    }
    
    public void death(String name) {
        dead.add(name);
    }
    
    public List<String> getInheritanceOrder() {
        List<String> ans = new ArrayList<String>();
        preorder(ans, king);
        return ans;
    }

    private void preorder(List<String> ans, String name) {
        if (!dead.contains(name)) {
            ans.add(name);
        }
        List<String> children = edges.getOrDefault(name, new ArrayList<String>());
        for (String childName : children) {
            preorder(ans, childName);
        }
    }
}
```

```C# [sol1-C#]
public class ThroneInheritance {
    Dictionary<string, IList<string>> edges;
    ISet<string> dead;
    string king;

    public ThroneInheritance(string kingName) {
        edges = new Dictionary<string, IList<string>>();
        dead = new HashSet<string>();
        king = kingName;
    }
    
    public void Birth(string parentName, string childName) {
        IList<string> children;
        if (edges.TryGetValue(parentName, out children)) {
            children.Add(childName);
            edges[parentName] = children;
        } else {
            children = new List<string>();
            children.Add(childName);
            edges.Add(parentName, children);
        }
    }
    
    public void Death(string name) {
        dead.Add(name);
    }
    
    public IList<string> GetInheritanceOrder() {
        IList<string> ans = new List<string>();
        Preorder(ans, king);
        return ans;
    }

    private void Preorder(IList<string> ans, string name) {
        if (!dead.Contains(name)) {
            ans.Add(name);
        }
        IList<string> children = edges.TryGetValue(name, out children) ? children : new List<string>();
        foreach (string childName in children) {
            Preorder(ans, childName);
        }
    }
}
```

```Python [sol1-Python3]
class ThroneInheritance:

    def __init__(self, kingName: str):
        self.edges = defaultdict(list)
        self.dead = set()
        self.king = kingName

    def birth(self, parentName: str, childName: str) -> None:
        self.edges[parentName].append(childName)

    def death(self, name: str) -> None:
        self.dead.add(name)

    def getInheritanceOrder(self) -> List[str]:
        ans = list()

        def preorder(name: str) -> None:
            if name not in self.dead:
                ans.append(name)
            if name in self.edges:
                for childName in self.edges[name]:
                    preorder(childName)

        preorder(self.king)
        return ans
```

```JavaScript [sol1-JavaScript]
var ThroneInheritance = function(kingName) {
    this.edges = new Map();
    this.dead = new Set();
    this.king = kingName;
};

ThroneInheritance.prototype.birth = function(parentName, childName) {
    if (!this.edges.has(parentName)) {
        this.edges.set(parentName, []);
    }
    this.edges.get(parentName).push(childName);
};

ThroneInheritance.prototype.death = function(name) {
    this.dead.add(name);
};

ThroneInheritance.prototype.getInheritanceOrder = function() {
    const ans = [];

    const preorder = (name) => {
        if (!this.dead.has(name)) {
            ans.push(name);
        }
        if (this.edges.has(name)) {
            for (const childName of this.edges.get(name)) {
                preorder(childName);
            }
        }
    }

    preorder(this.king);
    return ans;
};
```

```go [sol1-Golang]
type ThroneInheritance struct {
    king  string
    edges map[string][]string
    dead  map[string]bool
}

func Constructor(kingName string) (t ThroneInheritance) {
    return ThroneInheritance{kingName, map[string][]string{}, map[string]bool{}}
}

func (t *ThroneInheritance) Birth(parentName, childName string) {
    t.edges[parentName] = append(t.edges[parentName], childName)
}

func (t *ThroneInheritance) Death(name string) {
    t.dead[name] = true
}

func (t *ThroneInheritance) GetInheritanceOrder() (ans []string) {
    var preorder func(string)
    preorder = func(name string) {
        if !t.dead[name] {
            ans = append(ans, name)
        }
        for _, childName := range t.edges[name] {
            preorder(childName)
        }
    }
    preorder(t.king)
    return
}
```

**复杂度分析**

- 时间复杂度：

    - $\texttt{ThroneInheritance(kingName)}$：$O(1)$；

    - $\texttt{birth(parentName, childName)}$：$O(1)$；

    - $\texttt{death(name)}$：$O(1)$；

    - $\texttt{getInheritanceOrder()}$：$O(n)$，其中 $n$ 是当前树中的总人数。我们需要对整棵树进行一次前序遍历，时间复杂度为 $O(n)$。

- 空间复杂度：

    - $n$ 个节点的树包含 $n-1$ 条边，因此我们需要 $O(n)$ 的空间（即哈希映射 $\textit{edges}$）存储整棵树；

    - 我们需要 $O(n)$ 的空间（即哈希集合）存储所有的死亡人员；

    - 在 $\texttt{getInheritanceOrder()}$ 中前序遍历的过程中，我们使用的是递归，需要一定的栈空间，栈空间的大小与树的高度成正比。由于树的高度不会超过树中的节点个数，因此栈空间最多为 $O(n)$。

在上述的时空复杂度分析中，我们默认了所有字符串（即人名）的操作时间以及存储空间都是 $O(1)$ 的。如果读者希望将字符串的长度也看作变量，那么只需要将除了栈空间以外的所有项由 $O(1)/O(n)$ 变为 $O(l)/O(nl)$ 即可，其中 $l$ 是字符串的最大长度。