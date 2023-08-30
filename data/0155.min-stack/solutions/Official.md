### 📺视频题解  

![155.最小栈_甜姨.mp4](11ac0cb3-e770-4e9e-b581-b884cae3eb82)

### 📖文字题解

#### 方法一：辅助栈

**思路**

要做出这道题目，首先要理解栈结构先进后出的性质。

对于栈来说，如果一个元素 `a` 在入栈时，栈里有其它的元素 `b, c, d`，那么无论这个栈在之后经历了什么操作，只要 `a` 在栈中，`b, c, d` 就一定在栈中，因为在 `a` 被弹出之前，`b, c, d` 不会被弹出。

因此，在操作过程中的任意一个时刻，只要栈顶的元素是 `a`，那么我们就可以确定栈里面现在的元素一定是 `a, b, c, d`。

那么，我们可以在每个元素 `a` 入栈时把当前栈的最小值 `m` 存储起来。在这之后无论何时，如果栈顶元素是 `a`，我们就可以直接返回存储的最小值 `m`。

![fig1](https://assets.leetcode-cn.com/solution-static/155/155_fig1.gif)

**算法**

按照上面的思路，我们只需要设计一个数据结构，使得每个元素 `a` 与其相应的最小值 `m` 时刻保持一一对应。因此我们可以使用一个辅助栈，与元素栈同步插入与删除，用于存储与每个元素对应的最小值。

- 当一个元素要入栈时，我们取当前辅助栈的栈顶存储的最小值，与当前元素比较得出最小值，将这个最小值插入辅助栈中；

- 当一个元素要出栈时，我们把辅助栈的栈顶元素也一并弹出；

- 在任意一个时刻，栈内元素的最小值就存储在辅助栈的栈顶元素中。

```Python [sol1-Python3]
class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = [math.inf]

    def push(self, x: int) -> None:
        self.stack.append(x)
        self.min_stack.append(min(x, self.min_stack[-1]))

    def pop(self) -> None:
        self.stack.pop()
        self.min_stack.pop()

    def top(self) -> int:
        return self.stack[-1]

    def getMin(self) -> int:
        return self.min_stack[-1]
```

```C++ [sol1-C++]
class MinStack {
    stack<int> x_stack;
    stack<int> min_stack;
public:
    MinStack() {
        min_stack.push(INT_MAX);
    }
    
    void push(int x) {
        x_stack.push(x);
        min_stack.push(min(min_stack.top(), x));
    }
    
    void pop() {
        x_stack.pop();
        min_stack.pop();
    }
    
    int top() {
        return x_stack.top();
    }
    
    int getMin() {
        return min_stack.top();
    }
};
```

```Java [sol1-Java]
class MinStack {
    Deque<Integer> xStack;
    Deque<Integer> minStack;

    public MinStack() {
        xStack = new LinkedList<Integer>();
        minStack = new LinkedList<Integer>();
        minStack.push(Integer.MAX_VALUE);
    }
    
    public void push(int x) {
        xStack.push(x);
        minStack.push(Math.min(minStack.peek(), x));
    }
    
    public void pop() {
        xStack.pop();
        minStack.pop();
    }
    
    public int top() {
        return xStack.peek();
    }
    
    public int getMin() {
        return minStack.peek();
    }
}
```

```JavaScript [sol1-JavaScript]
var MinStack = function() {
    this.x_stack = [];
    this.min_stack = [Infinity];
};

MinStack.prototype.push = function(x) {
    this.x_stack.push(x);
    this.min_stack.push(Math.min(this.min_stack[this.min_stack.length - 1], x));
};

MinStack.prototype.pop = function() {
    this.x_stack.pop();
    this.min_stack.pop();
};

MinStack.prototype.top = function() {
    return this.x_stack[this.x_stack.length - 1];
};

MinStack.prototype.getMin = function() {
    return this.min_stack[this.min_stack.length - 1];
};
```

```golang [sol1-Golang]
type MinStack struct {
    stack []int
    minStack []int
}

func Constructor() MinStack {
    return MinStack{
        stack: []int{},
        minStack: []int{math.MaxInt64},
    }
}

func (this *MinStack) Push(x int)  {
    this.stack = append(this.stack, x)
    top := this.minStack[len(this.minStack)-1]
    this.minStack = append(this.minStack, min(x, top))
}

func (this *MinStack) Pop()  {
    this.stack = this.stack[:len(this.stack)-1]
    this.minStack = this.minStack[:len(this.minStack)-1]
}

func (this *MinStack) Top() int {
    return this.stack[len(this.stack)-1]
}

func (this *MinStack) GetMin() int {
    return this.minStack[len(this.minStack)-1]
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

**复杂度分析**

* 时间复杂度：对于题目中的所有操作，时间复杂度均为 $O(1)$。因为栈的插入、删除与读取操作都是 $O(1)$，我们定义的每个操作最多调用栈操作两次。

* 空间复杂度：$O(n)$，其中 $n$ 为总操作数。最坏情况下，我们会连续插入 $n$ 个元素，此时两个栈占用的空间为 $O(n)$。