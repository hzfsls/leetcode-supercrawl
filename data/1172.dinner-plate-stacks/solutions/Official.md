## [1172.餐盘栈 中文官方题解](https://leetcode.cn/problems/dinner-plate-stacks/solutions/100000/can-pan-zhan-by-leetcode-solution-afsw)

#### 方法一：数组 + 有序集合模拟

**思路**

用一个数组 $\textit{stack}$ 来模拟栈，编号为 $\textit{index}$ 的栈的顶部 $\textit{stackTop}$ 在数组中的下标 $\textit{pos}$ 可以通过公式来表示：$\textit{pos} = \textit{index} \times \textit{capacity} + \textit{stackTop}$。用一个有序集合 $\textit{poppedPos}$ 来保存被方法 $\textit{popAtStack}$ 删除的位置。用数组 $\textit{top}$ 记录每个栈的栈顶元素在栈中的位置，比如 $\textit{top}[1] = 2$ 就表示，编号为 $1$ 的栈，栈顶元素在栈中的下标为 $2$（从 $0$ 开始计数，$\textit{capacity} > 2$），即在这个栈中，它上面没有元素，它下面还有两个元素。

执行 $\textit{push}$ 时，先考虑 $\textit{poppedPos}$ 中的位置，如果非空，则找出最小的位置，把元素 $\textit{push}$ 到这个位置。如果为空，则往 $\textit{stack}$ 后追加，然后更新 $\textit{top}$。

执行 $\textit{popAtStack}$ 时，先找出这个栈现在的栈顶位置，然后把这个位置的元素的下标计算出来并更新栈顶位置，把下标放入 $\textit{poppedPos}$，返回元素的值。当然有可能这个栈是空的，此时要返回 $-1$。

执行 $\textit{pop}$ 时，情况比较复杂。直观的想法是，返回 $\textit{stack}$ 元素即可。但 $\textit{stack}$ 末尾元素可能早已被 $\textit{popAtStack}$ 删除，因此，应该返回处于 $\textit{stack}$ 末尾且不位于 $\textit{popAtStack}$ 中的位置，如果 $\textit{stack}$ 末尾位置出现在 $\textit{popAtStack}$ 中，直接把 $\textit{stack}$ 末尾元素删除，再进行重复判断，直到满足上述条件或者 $\textit{stack}$ 为空。找到符合条件的位置后，需要更新 $\textit{top}$，然后返回元素的值。在执行 $\textit{pop}$ 时，上述判断可能会执行多次，但是一次 $\textit{popAtStack}$ 最多带来一次判断，因此不会带来时间复杂度的变大。


**代码**

```Java [sol1-Java]
class DinnerPlates {
    int capacity;
    List<Integer> stack;
    List<Integer> top;
    TreeSet<Integer> poppedPos;

    public DinnerPlates(int capacity) {
        this.capacity = capacity;
        stack = new LinkedList<>();
        top = new ArrayList<>();
        poppedPos = new TreeSet<>();
    }

    public void push(int val) {
        if (poppedPos.isEmpty()) {
            int pos = stack.size();
            stack.add(val);
            if (pos % capacity == 0) {
                top.add(0);
            }
            else {
                int stackPos = top.size()-1;
                int stackTop = top.get(stackPos);
                top.set(stackPos, stackTop + 1);
            }
        } else {
            int pos = poppedPos.pollFirst();
            stack.set(pos, val);
            int index = pos / capacity;
            int stackTop = top.get(index);
            top.set(index, stackTop + 1);
        }
    }

    public int pop() {
        while (!stack.isEmpty() && poppedPos.contains(stack.size()-1)) {
            stack.remove(stack.size()-1);
            int pos = poppedPos.pollLast();
            if (pos % capacity == 0) {
                top.remove(top.size()-1);
            }
        }
        if (stack.isEmpty()) {
            return -1;
        } else {
            int pos = stack.size() - 1;
            int val = stack.get(pos);
            stack.remove(pos);
            int index = top.size()-1;
            if (pos % capacity == 0) {
                top.remove(index);
            } else {
                top.set(index, index - 1);
            }
            return val;
        }
    }

    public int popAtStack(int index) {
        if (index >= top.size()) {
            return -1;
        }
        int stackTop = top.get(index);
        if (stackTop < 0) {
            return -1;
        }
        top.set(index, stackTop - 1);
        int pos = index * capacity + stackTop;
        poppedPos.add(pos);
        return stack.get(pos);
    }
}
```

```C++ [sol1-C++]
class DinnerPlates {
public:
    DinnerPlates(int capacity) {
        this->capacity = capacity;
    }

    void push(int val) {
        if (poppedPos.empty()) {
            int pos = stk.size();
            stk.emplace_back(val);
            if (pos % capacity == 0) {
                top.emplace_back(0);
            } else {
                top.back()++;
            }
        } else {
            int pos = *poppedPos.begin();
            poppedPos.erase(pos);
            stk[pos] = val;
            int index = pos / capacity;
            top[index]++;
        }
    }
    
    int pop() {
        while (!stk.empty() && poppedPos.count(stk.size() - 1)) {
            stk.pop_back();
            int pos = *poppedPos.rbegin();
            poppedPos.erase(pos);
            if (pos % capacity == 0) {
                top.pop_back();
            }
        }
        if (stk.empty()) {
            return -1;
        } else {
            int pos = stk.size() - 1;
            int val = stk.back();
            stk.pop_back();
            if (pos % capacity == 0) {
                top.pop_back();
            } else {
                top.back() = top.size() - 2;
            }
            return val;
        }
    }
    
    int popAtStack(int index) {
        if (index >= top.size()) {
            return -1;
        }
        int stackTop = top[index];
        if (stackTop < 0) {
            return -1;
        }
        top[index]--;
        int pos = index * capacity + stackTop;
        poppedPos.emplace(pos);
        return stk[pos];
    }
private:
    int capacity;
    vector<int> stk;
    vector<int> top;
    set<int> poppedPos;
};
```

```Python [sol1-Python3]
from sortedcontainers import *
class DinnerPlates:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.stack = []
        self.top = []
        self.poppedPos = SortedSet()

    def push(self, val: int) -> None:
        if not self.poppedPos:
            pos = len(self.stack)
            self.stack.append(val)
            if pos % self.capacity == 0:
                self.top.append(0)
            else:
                stackPos = len(self.top) - 1
                stackTop = self.top[stackPos]
                self.top[stackPos] = stackTop + 1
        else:
            pos = self.poppedPos.pop(0)
            self.stack[pos] = val
            index = pos // self.capacity
            stackTop = self.top[index]
            self.top[index] = stackTop + 1

    def pop(self) -> int:
        while self.stack and self.poppedPos and self.poppedPos[-1] == len(self.stack) - 1:
            self.stack.pop()
            pos = self.poppedPos.pop()
            if pos % self.capacity == 0:
                self.top.pop()
        if not self.stack:
            return -1
        else:
            pos = len(self.stack) - 1
            val = self.stack[pos]
            self.stack.pop()
            if pos % self.capacity == 0 and self.top:
                self.top.pop()
            elif self.top:
                self.top[-1] -= 1
            return val

    def popAtStack(self, index: int) -> int:
        if index >= len(self.top):
            return -1
        stackTop = self.top[index]
        if stackTop < 0:
            return -1
        self.top[index] = stackTop - 1
        pos = index * self.capacity + stackTop
        self.poppedPos.add(pos)
        return self.stack[pos]
```

```Go [sol1-Golang]
type DinnerPlates struct {
    capacity int
    stack []int
    top []int
    poppedPos []int
}

func Constructor(capacity int) DinnerPlates {
    return DinnerPlates{capacity, []int{}, []int{}, []int{}}
}

func (this *DinnerPlates) Push(val int) {
    if len(this.poppedPos) == 0 {
        pos := len(this.stack)
        this.stack = append(this.stack, val)
        if pos % this.capacity == 0 {
            this.top = append(this.top, 0)
        } else {
            stackPos := len(this.top) - 1
            stackTop := this.top[stackPos]
            this.top[stackPos] = stackTop + 1
        }
    } else {
        pos := this.poppedPos[0]
        this.poppedPos = this.poppedPos[1:]
        this.stack[pos] = val
        index := pos / this.capacity
        stackTop := this.top[index]
        this.top[index] = stackTop + 1
    }
}

func (this *DinnerPlates) Pop() int {
    for len(this.stack) > 0 && len(this.poppedPos) > 0 && this.poppedPos[len(this.poppedPos) - 1] == len(this.stack) - 1 {
        this.stack = this.stack[:len(this.stack) - 1]
        pos := this.poppedPos[len(this.poppedPos) - 1]
        this.poppedPos = this.poppedPos[:len(this.poppedPos) - 1]
        if pos % this.capacity == 0 {
            this.top = this.top[:len(this.top) - 1]
        }
    }
    if len(this.stack) == 0 {
        return -1
    } else {
        pos := len(this.stack) - 1
        val := this.stack[pos]
        this.stack = this.stack[:pos]
        if pos % this.capacity == 0 && len(this.top) > 0 {
            this.top = this.top[:len(this.top) - 1]
        } else if len(this.top) > 0 {
            this.top[len(this.top) - 1] -= 1
        }
        return val
    }
}

func (this *DinnerPlates) PopAtStack(index int) int {
    if index >= len(this.top) {
        return -1
    }
    stackTop := this.top[index]
    if stackTop < 0 {
        return -1
    }
    this.top[index] = stackTop - 1
    pos := index * this.capacity + stackTop
    i := sort.SearchInts(this.poppedPos, pos)
    this.poppedPos = append(this.poppedPos, 0)
    copy(this.poppedPos[i+1:], this.poppedPos[i:])
    this.poppedPos[i] = pos
    return this.stack[pos]
}
```

```JavaScript [sol1-JavaScript]
class TreeSet {
    constructor(comparator) {
        this.set = new Set();
        this.comparator = comparator || ((a, b) => a - b);
        this.array = [];
    }

    add(item) {
        if (!this.set.has(item)) {
            this.set.add(item);
            this.array.push(item);
            this.array.sort(this.comparator);
        }
    }

    delete(item) {
        if (this.set.has(item)) {
            this.set.delete(item);
            this.array.splice(this.array.indexOf(item), 1);
        }
    }

    has(item) {
        return this.set.has(item);
    }

    get size() {
        return this.set.size;
    }

    toArray() {
        return [...this.array];
    }

    pollFirst() {
        const item = this.array.shift();
        this.set.delete(item);
        return item;
    }

    pollLast() {
        const item = this.array.pop();
        this.set.delete(item);
        return item;
    }
}

var DinnerPlates = function(capacity) {
    this.capacity = capacity;
    this.stack = [];
    this.top = [];
    this.poppedPos = new TreeSet();
};

DinnerPlates.prototype.push = function(val) {
    if (this.poppedPos.size === 0) {
        const pos = this.stack.length;
        this.stack.push(val);
        if (pos % this.capacity === 0) {
            this.top.push(0);
        }
        else {
            const stackPos = this.top.length - 1;
            const stackTop = this.top[stackPos];
            this.top.splice(stackPos, 1 , stackTop + 1);
        }
    } else {
        const pos = this.poppedPos.pollFirst();
        this.stack.splice(pos, 1 , val);
        const index = Math.floor(pos / this.capacity);
        const stackTop = this.top[index];
        this.top.splice(index, 1 ,stackTop + 1);
    }
};

DinnerPlates.prototype.pop = function() {
    while (this.stack.length !== 0 && this.poppedPos.has(this.stack.length - 1)) {
        this.stack.splice(this.stack.length - 1,1);
        const pos = this.poppedPos.pollLast();
        if (pos % this.capacity === 0) {
            this.top.splice(this.top.length - 1, 1);
        }
    }
    if (this.stack.length === 0) {
        return -1;
    } else {
        const pos = this.stack.length - 1;
        const val = this.stack[pos];
        this.stack.splice(pos, 1);
        const index = this.top.length - 1;
        if (pos % this.capacity === 0) {
            this.top.splice(index, 1);
        } else {
            this.top.splice(index, 1 , index - 1);
        }
        return val;
    }
};

DinnerPlates.prototype.popAtStack = function(index) {
    if (index >= this.top.length) {
        return -1;
    }
    const stackTop = this.top[index];
    if (stackTop < 0) {
        return -1;
    }
    this.top.splice(index,  1, stackTop - 1);
    const pos = index * this.capacity + stackTop;
    this.poppedPos.add(pos);
    return this.stack[pos];
};
```

**复杂度分析**

- 时间复杂度：记 $n$ 为 $\textit{push}$ 的调用次数。单次 $\textit{push}$ 的时间复杂度为 $O(\log n)$，单次 $\textit{popAtStack}$ 的时间复杂度为 $O(\log n)$，$\textit{pop}$ 单次均摊的时间复杂度为 $O(\log n)$。

- 空间复杂度：使用到的数组和有序集合空间复杂度均为 $O(n)$。