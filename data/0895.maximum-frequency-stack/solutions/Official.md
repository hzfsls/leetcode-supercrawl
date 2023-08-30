#### 方法一：哈希表和栈

**思路与算法**

在本题中，每次需要优先弹出频率最大的元素，如果频率最大元素有多个，则优先弹出靠近栈顶的元素。因此，我们可以考虑将栈序列分解为多个频率不同的栈序列，每个栈维护同一频率的元素。当元素入栈时频率增加，将元素加入到更高频率的栈中，低频率栈中的元素不需要出栈。当元素出栈时，将频率最高的栈的栈顶元素出栈即可。

更详细的，我们用一个哈希表 $\textit{freq}$ 来记录每个元素出现的次数。设当前最大频率为 $\textit{maxFreq}$，为 $1 \sim \textit{maxFreq}$ 中的每种频率单独设置一个栈。为了方便描述，记 $\textit{freq}[x]$ 为 $x$ 的频率，$\textit{group}[i]$ 为频率为 $i$ 的栈。

1. 当元素 $x$ 入栈时，令 $\textit{freq}[x] + 1$，然后将 $x$ 放入 $\textit{group}[\textit{freq}[x]]$ 中，更新 $\textit{maxFreq} = \max(\textit{maxFreq}, \textit{freq}[x])$。此时，$\textit{group}[1] \sim \textit{group}[\textit{freq}[x]]$ 的每一个栈中都包含 $x$。
2. 元素出栈时，获取 $x = \textit{group}[\textit{maxFreq}].top()$ 作为出栈元素，令 $\textit{freq}[x] - 1$，若 $x$ 出栈后 $\textit{group}[\textit{maxFreq}]$ 为空，则令 $\textit{maxFreq} - 1$。

**代码**

```Python [sol1-Python3]
class FreqStack:
    def __init__(self):
        self.freq = defaultdict(int)
        self.group = defaultdict(list)
        self.maxFreq = 0

    def push(self, val: int) -> None:
        self.freq[val] += 1
        self.group[self.freq[val]].append(val)
        self.maxFreq = max(self.maxFreq, self.freq[val])

    def pop(self) -> int:
        val = self.group[self.maxFreq].pop()
        self.freq[val] -= 1
        if len(self.group[self.maxFreq]) == 0:
            self.maxFreq -= 1
        return val
```

```C++ [sol1-C++]
class FreqStack {
public:
    FreqStack() {
        maxFreq = 0;
    }

    void push(int val) {
        freq[val]++;
        group[freq[val]].push(val);
        maxFreq = max(maxFreq, freq[val]);
    }

    int pop() {
        int val = group[maxFreq].top();
        freq[val]--;
        group[maxFreq].pop();
        if (group[maxFreq].empty()) {
            maxFreq--;
        }
        return val;
    }

private:
    unordered_map<int, int> freq;
    unordered_map<int, stack<int>> group;
    int maxFreq;
};
```

```Java [sol1-Java]
class FreqStack {
    private Map<Integer, Integer> freq;
    private Map<Integer, Deque<Integer>> group;
    private int maxFreq;

    public FreqStack() {
        freq = new HashMap<Integer, Integer>();
        group = new HashMap<Integer, Deque<Integer>>();
        maxFreq = 0;
    }

    public void push(int val) {
        freq.put(val, freq.getOrDefault(val, 0) + 1);
        group.putIfAbsent(freq.get(val), new ArrayDeque<Integer>());
        group.get(freq.get(val)).push(val);
        maxFreq = Math.max(maxFreq, freq.get(val));
    }

    public int pop() {
        int val = group.get(maxFreq).peek();
        freq.put(val, freq.get(val) - 1);
        group.get(maxFreq).pop();
        if (group.get(maxFreq).isEmpty()) {
            maxFreq--;
        }
        return val;
    }
}
```

```C# [sol1-C#]
public class FreqStack {
    private IDictionary<int, int> freq;
    private IDictionary<int, Stack<int>> group;
    private int maxFreq;

    public FreqStack() {
        freq = new Dictionary<int, int>();
        group = new Dictionary<int, Stack<int>>();
        maxFreq = 0;
    }

    public void Push(int val) {
        if (!freq.ContainsKey(val)) {
            freq.Add(val, 0);
        }
        freq[val]++;
        if (!group.ContainsKey(freq[val])) {
            group.Add(freq[val], new Stack<int>());
        }
        group[freq[val]].Push(val);
        maxFreq = Math.Max(maxFreq, freq[val]);
    }

    public int Pop() {
        int val = group[maxFreq].Peek();
        freq[val]--;
        group[maxFreq].Pop();
        if (group[maxFreq].Count == 0) {
            maxFreq--;
        }
        return val;
    }
}
```

```go [sol1-Golang]
type FreqStack struct {
    freq    map[int]int
    group   map[int][]int
    maxFreq int
}

func Constructor() FreqStack {
    return FreqStack{map[int]int{}, map[int][]int{}, 0}
}

func (f *FreqStack) Push(val int) {
    f.freq[val]++
    f.group[f.freq[val]] = append(f.group[f.freq[val]], val)
    f.maxFreq = max(f.maxFreq, f.freq[val])
}

func (f *FreqStack) Pop() int {
    val := f.group[f.maxFreq][len(f.group[f.maxFreq])-1]
    f.group[f.maxFreq] = f.group[f.maxFreq][:len(f.group[f.maxFreq])-1]
    f.freq[val]--
    if len(f.group[f.maxFreq]) == 0 {
        f.maxFreq--
    }
    return val
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var FreqStack = function() {
    this.freq = new Map();
    this.group = new Map();
    this.maxFreq = 0;
};

FreqStack.prototype.push = function(val) {
    this.freq.set(val, (this.freq.get(val) || 0) + 1);
    if (!this.group.has(this.freq.get(val))) {
        this.group.set(this.freq.get(val), []);
    }
    this.group.get(this.freq.get(val)).push(val);
    this.maxFreq = Math.max(this.maxFreq, this.freq.get(val));
};

FreqStack.prototype.pop = function() {
    const val = this.group.get(this.maxFreq)[this.group.get(this.maxFreq).length - 1];
    this.freq.set(val, this.freq.get(val) - 1);
    this.group.get(this.maxFreq).pop();
    
    if (this.group.get(this.maxFreq).length === 0) {
        this.maxFreq--;
    }
    return val;
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    struct ListNode *head;
    int stackSize;
} Stack;

typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashFreqItem; 

typedef struct {
    int key;
    Stack *val;
    UT_hash_handle hh;
} HashGroupItem; 

typedef struct {
    HashFreqItem *freq;
    HashGroupItem *group;
    int maxFreq;
} FreqStack;

Stack* stackCreate() {
    Stack *obj = (Stack *)malloc(sizeof(Stack));
    obj->head= NULL;
    obj->stackSize = 0;
    return obj;
}

bool stackEmpty(Stack *obj) {
    return obj->stackSize == 0;
}

bool stackPush(Stack *obj, int val) {
    struct ListNode *p = (struct ListNode *)malloc(sizeof(struct ListNode));
    p->val = val;
    p->next = obj->head;
    obj->head = p;
    obj->stackSize++;
    return true;
}

int stackPop(Stack *obj) {
    if (stackEmpty(obj)) {
        return -1;
    }
    int ret = obj->head->val;
    obj->head = obj->head->next;
    obj->stackSize--;
    return ret;
}

void stackFree(Stack *obj) {
    for (struct ListNode * cur = obj->head; cur;) {
        struct ListNode *p = cur;
        cur = cur->next;
        free(p);
    }
    free(obj);
}

FreqStack* freqStackCreate() {
    FreqStack *obj = (FreqStack *)malloc(sizeof(FreqStack));
    obj->maxFreq = 0;
    obj->freq = NULL;
    obj->group = NULL;
    return obj;
}

void freqStackPush(FreqStack* obj, int val) {
    HashFreqItem *pFreqEntry = NULL;
    HASH_FIND_INT(obj->freq, &val, pFreqEntry);
    if (pFreqEntry == NULL) {
        pFreqEntry = (HashFreqItem *)malloc(sizeof(HashFreqItem));
        pFreqEntry->key = val;
        pFreqEntry->val = 1;
        HASH_ADD_INT(obj->freq, key, pFreqEntry);
    } else {
        pFreqEntry->val++;
    }
    int freq = pFreqEntry->val;
    HashGroupItem *pGroupEntry = NULL;
    HASH_FIND_INT(obj->group, &freq, pGroupEntry);
    if (pGroupEntry == NULL) {
        pGroupEntry = (HashGroupItem *)malloc(sizeof(HashGroupItem));
        pGroupEntry->key = freq;
        pGroupEntry->val = stackCreate();
        HASH_ADD_INT(obj->group, key, pGroupEntry);
    }
    stackPush(pGroupEntry->val, val);
    obj->maxFreq = MAX(obj->maxFreq, freq);
}

int freqStackPop(FreqStack* obj) {
    int freq = obj->maxFreq;
    HashGroupItem *pGroupEntry = NULL;
    HASH_FIND_INT(obj->group, &freq, pGroupEntry);
    int val = stackPop(pGroupEntry->val);    
    if (stackEmpty(pGroupEntry->val)) {
        obj->maxFreq--;
    }
    HashFreqItem *pFreqEntry = NULL;
    HASH_FIND_INT(obj->freq, &val, pFreqEntry);
    pFreqEntry->val--;
    return val;
}

void freqStackFree(FreqStack* obj) {
    HashFreqItem *pCurr = NULL, *pNext = NULL;
    HASH_ITER(hh, obj->freq, pCurr, pNext) {
        HASH_DEL(obj->freq, pCurr);  
        free(pCurr);             
    }
    HashGroupItem *pGroupCurr = NULL, *pGroupNext = NULL;
    HASH_ITER(hh, obj->group, pGroupCurr, pGroupNext) {
        HASH_DEL(obj->group, pGroupCurr);  
        stackFree(pGroupCurr->val);
        free(pGroupCurr);          
    }
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：对于 $\textit{push}$ 和 $\textit{pop}$ 操作，时间复杂度为 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{FreqStack}$ 中元素的个数。