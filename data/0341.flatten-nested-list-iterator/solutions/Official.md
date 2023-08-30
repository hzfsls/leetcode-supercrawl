#### 方法一：深度优先搜索

**思路**

嵌套的整型列表是一个树形结构，树上的叶子节点对应一个整数，非叶节点对应一个列表。

在这棵树上深度优先搜索的顺序就是迭代器遍历的顺序。

我们可以先遍历整个嵌套列表，将所有整数存入一个数组，然后遍历该数组从而实现 $\texttt{next}$ 和 $\texttt{hasNext}$ 方法。

**代码**

```C++ [sol1-C++]
class NestedIterator {
private:
    vector<int> vals;
    vector<int>::iterator cur;

    void dfs(const vector<NestedInteger> &nestedList) {
        for (auto &nest : nestedList) {
            if (nest.isInteger()) {
                vals.push_back(nest.getInteger());
            } else {
                dfs(nest.getList());
            }
        }
    }

public:
    NestedIterator(vector<NestedInteger> &nestedList) {
        dfs(nestedList);
        cur = vals.begin();
    }

    int next() {
        return *cur++;
    }

    bool hasNext() {
        return cur != vals.end();
    }
};
```

```Java [sol1-Java]
public class NestedIterator implements Iterator<Integer> {
    private List<Integer> vals;
    private Iterator<Integer> cur;

    public NestedIterator(List<NestedInteger> nestedList) {
        vals = new ArrayList<Integer>();
        dfs(nestedList);
        cur = vals.iterator();
    }

    @Override
    public Integer next() {
        return cur.next();
    }

    @Override
    public boolean hasNext() {
        return cur.hasNext();
    }

    private void dfs(List<NestedInteger> nestedList) {
        for (NestedInteger nest : nestedList) {
            if (nest.isInteger()) {
                vals.add(nest.getInteger());
            } else {
                dfs(nest.getList());
            }
        }
    }
}
```

```go [sol1-Golang]
type NestedIterator struct {
    vals []int
}

func Constructor(nestedList []*NestedInteger) *NestedIterator {
    var vals []int
    var dfs func([]*NestedInteger)
    dfs = func(nestedList []*NestedInteger) {
        for _, nest := range nestedList {
            if nest.IsInteger() {
                vals = append(vals, nest.GetInteger())
            } else {
                dfs(nest.GetList())
            }
        }
    }
    dfs(nestedList)
    return &NestedIterator{vals}
}

func (it *NestedIterator) Next() int {
    val := it.vals[0]
    it.vals = it.vals[1:]
    return val
}

func (it *NestedIterator) HasNext() bool {
    return len(it.vals) > 0
}
```

```JavaScript [sol1-JavaScript]
var NestedIterator = function(nestedList) {
    vals = [];
    const dfs = (nestedList) => {
        for (const nest of nestedList) {
            if (nest.isInteger()) {
                vals.push(nest.getInteger());
            } else {
                dfs(nest.getList());
            }
        }
    }
    dfs(nestedList);
};

NestedIterator.prototype.hasNext = function() {
    return vals.length > 0;
};

NestedIterator.prototype.next = function() {
    const val = vals[0];
    vals = vals.slice(1);
    return val;
};
```

```C [sol1-C]
struct NestedIterator {
    int *vals;
    int size;
    int cur;
};

void dfs(struct NestedIterator *iter, struct NestedInteger **nestedList, int nestedListSize) {
    for (int i = 0; i < nestedListSize; i++) {
        if (NestedIntegerIsInteger(nestedList[i])) {
            (iter->vals)[(iter->size)++] = NestedIntegerGetInteger(nestedList[i]);
        } else {
            dfs(iter, NestedIntegerGetList(nestedList[i]), NestedIntegerGetListSize(nestedList[i]));
        }
    }
}

struct NestedIterator *nestedIterCreate(struct NestedInteger **nestedList, int nestedListSize) {
    struct NestedIterator *ret = malloc(sizeof(struct NestedIterator));
    ret->vals = malloc(sizeof(int) * 20001);
    ret->size = 0;
    ret->cur = 0;
    dfs(ret, nestedList, nestedListSize);
    return ret;
}

bool nestedIterHasNext(struct NestedIterator *iter) {
    return iter->cur != iter->size;
}

int nestedIterNext(struct NestedIterator *iter) {
    return (iter->vals)[(iter->cur)++];
}

void nestedIterFree(struct NestedIterator *iter) {
    free(iter->vals);
    free(iter);
}
```

**复杂度分析**

- 时间复杂度：初始化为 $O(n)$，$\texttt{next}$ 和 $\texttt{hasNext}$ 为 $O(1)$。其中 $n$ 是嵌套的整型列表中的元素个数。

- 空间复杂度：$O(n)$。需要一个数组存储嵌套的整型列表中的所有元素。

#### 方法二：栈

**思路**

我们可以用一个栈来代替方法一中的递归过程。

具体来说，用一个栈来维护深度优先搜索时，从根节点到当前节点路径上的所有节点。由于非叶节点对应的是一个列表，我们在栈中存储的是指向列表当前遍历的元素的指针（下标）。每次向下搜索时，取出列表的当前指针指向的元素并将其入栈，同时将该指针向后移动一位。如此反复直到找到一个整数。循环时若栈顶指针指向了列表末尾，则将其从栈顶弹出。

下面的代码中，$\texttt{C++}$ 和 $\texttt{Java}$ 的栈存储的是迭代器，迭代器可以起到指向元素的指针的效果，$\texttt{Go}$ 的栈存储的是切片（视作队列），通过将元素弹出队首的操作代替移动指针的操作。

**代码**

```C++ [sol2-C++]
class NestedIterator {
private:
    // pair 中存储的是列表的当前遍历位置，以及一个尾后迭代器用于判断是否遍历到了列表末尾
    stack<pair<vector<NestedInteger>::iterator, vector<NestedInteger>::iterator>> stk;

public:
    NestedIterator(vector<NestedInteger> &nestedList) {
        stk.emplace(nestedList.begin(), nestedList.end());
    }

    int next() {
        // 由于保证调用 next 之前会调用 hasNext，直接返回栈顶列表的当前元素，然后迭代器指向下一个元素
        return stk.top().first++->getInteger();
    }

    bool hasNext() {
        while (!stk.empty()) {
            auto &p = stk.top();
            if (p.first == p.second) { // 遍历到当前列表末尾，出栈
                stk.pop();
                continue;
            }
            if (p.first->isInteger()) {
                return true;
            }
            // 若当前元素为列表，则将其入栈，且迭代器指向下一个元素
            auto &lst = p.first++->getList();
            stk.emplace(lst.begin(), lst.end());
        }
        return false;
    }
};
```

```Java [sol2-Java]
public class NestedIterator implements Iterator<Integer> {
    // 存储列表的当前遍历位置
    private Deque<Iterator<NestedInteger>> stack;

    public NestedIterator(List<NestedInteger> nestedList) {
        stack = new LinkedList<Iterator<NestedInteger>>();
        stack.push(nestedList.iterator());
    }

    @Override
    public Integer next() {
        // 由于保证调用 next 之前会调用 hasNext，直接返回栈顶列表的当前元素
        return stack.peek().next().getInteger();
    }

    @Override
    public boolean hasNext() {
        while (!stack.isEmpty()) {
            Iterator<NestedInteger> it = stack.peek();
            if (!it.hasNext()) { // 遍历到当前列表末尾，出栈
                stack.pop();
                continue;
            }
            // 若取出的元素是整数，则通过创建一个额外的列表将其重新放入栈中
            NestedInteger nest = it.next();
            if (nest.isInteger()) {
                List<NestedInteger> list = new ArrayList<NestedInteger>();
                list.add(nest);
                stack.push(list.iterator());
                return true;
            }
            stack.push(nest.getList().iterator());
        }
        return false;
    }
}
```

```go [sol2-Golang]
type NestedIterator struct {
    // 将列表视作一个队列，栈中直接存储该队列
    stack [][]*NestedInteger
}

func Constructor(nestedList []*NestedInteger) *NestedIterator {
    return &NestedIterator{[][]*NestedInteger{nestedList}}
}

func (it *NestedIterator) Next() int {
    // 由于保证调用 Next 之前会调用 HasNext，直接返回栈顶列表的队首元素，将其弹出队首并返回
    queue := it.stack[len(it.stack)-1]
    val := queue[0].GetInteger()
    it.stack[len(it.stack)-1] = queue[1:]
    return val
}

func (it *NestedIterator) HasNext() bool {
    for len(it.stack) > 0 {
        queue := it.stack[len(it.stack)-1]
        if len(queue) == 0 { // 当前队列为空，出栈
            it.stack = it.stack[:len(it.stack)-1]
            continue
        }
        nest := queue[0]
        if nest.IsInteger() {
            return true
        }
        // 若队首元素为列表，则将其弹出队列并入栈
        it.stack[len(it.stack)-1] = queue[1:]
        it.stack = append(it.stack, nest.GetList())
    }
    return false
}
```

```JavaScript [sol2-JavaScript]
var NestedIterator = function(nestedList) {
    this.stack = nestedList;
};

NestedIterator.prototype.hasNext = function() {
    while (this.stack.length !== 0) {
        if (this.stack[0].isInteger()) {
            return true;
        } else {
            let cur = this.stack[0].getList();
            this.stack.shift();
            this.stack.unshift(...cur);
        }
    }
};

NestedIterator.prototype.next = function() {
    return this.stack.shift().getInteger();
};
```

**复杂度分析**

- 时间复杂度：初始化和 $\texttt{next}$ 为 $O(1)$，$\texttt{hasNext}$ 为均摊 $O(1)$。

- 空间复杂度：$O(n)$。最坏情况下嵌套的整型列表是一条链，我们需要一个 $O(n)$ 大小的栈来存储链上的所有元素。