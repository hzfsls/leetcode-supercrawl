#### 分析

可以发现题目要求我们实现的 `push`、`pop` 和 `inc` 三个功能中，前两个功能就是普通的栈所具有的功能，为什么普通的栈没有 `inc` 功能呢？因为普通的栈只有栈顶元素是「可见」的，所以要实现的这个功能，我们就要让栈中的所有元素「可见」。

#### 方法一：模拟

我们使用数组模拟栈，用一个变量 `top` 来记录当前栈顶的位置。

- 对于 `push` 操作，首先判断当前元素的个数是否达到上限，如果没有达到，就把 `top` 后移一个位置并添加一个元素。

- 对于 `pop` 操作，首先判断当前栈是否为空，非空返回栈顶元素并将 `top` 前移一位，否则返回 $-1$。

- 对于 `inc` 操作，直接对栈底的**最多** `k` 个元素加上 `val`。

```C++ [sol1-C++]
class CustomStack {
public:
    vector<int> stk;
    int top;

    CustomStack(int maxSize) {
        stk.resize(maxSize);
        top = -1;
    }
    
    void push(int x) {
        if (top != stk.size() - 1) {
            ++top;
            stk[top] = x;
        }
    }
    
    int pop() {
        if (top == -1) {
            return -1;
        }
        --top;
        return stk[top + 1];
    }
    
    void increment(int k, int val) {
        int lim = min(k, top + 1);
        for (int i = 0; i < lim; ++i) {
            stk[i] += val;
        }
    }
};
```

```Java [sol1-Java]
class CustomStack {
    int[] stack;
    int top;

    public CustomStack(int maxSize) {
        stack = new int[maxSize];
        top = -1;
    }
    
    public void push(int x) {
        if (top != stack.length - 1) {
            ++top;
            stack[top] = x;
        }
    }
    
    public int pop() {
        if (top == -1) {
            return -1;
        }
        --top;
        return stack[top + 1];
    }
    
    public void increment(int k, int val) {
        int limit = Math.min(k, top + 1);
        for (int i = 0; i < limit; ++i) {
            stack[i] += val;
        }
    }
}
```

```Python [sol1-Python3]
class CustomStack:

    def __init__(self, maxSize: int):
        self.stk = [0] * maxSize
        self.top = -1

    def push(self, x: int) -> None:
        if self.top != len(self.stk) - 1:
            self.top += 1
            self.stk[self.top] = x

    def pop(self) -> int:
        if self.top == -1:
            return -1
        self.top -= 1
        return self.stk[self.top + 1]

    def increment(self, k: int, val: int) -> None:
        lim = min(k, self.top + 1)
        for i in range(lim):
            self.stk[i] += val
```

**复杂度分析**

- 时间复杂度：初始化（构造函数）、`push` 操作和 `pop` 操作的渐进时间复杂度为 $O(1)$，`inc` 操作的渐进时间复杂度为 $O(k)$。

- 空间复杂度：这里用到了一个长度为 `maxSize` 的数组作为辅助空间，渐进空间复杂度为 $O({\rm maxSize})$。

#### 方法二：模拟优化

在方法一中，只剩下 `inc` 操作的时间复杂度不为 $O(1)$，因此可以尝试对该操作进行优化。

我们用一个辅助数组 `add` 记录每次 `inc` 操作。具体地，如果 `inc` 操作是将栈底的 `k` 个元素（将 `k` 与栈中元素个数取较小值）增加 `val`，那么我们将 `add[k - 1]` 增加 `val`。这样做的目的在于，只有在 `pop` 操作时，我们才需要知道栈顶元素的具体值，在其余的情况下，我们只要存储每个元素的增量就行了。

因此在遇到 `pop` 操作时，我们返回栈顶元素的初始值加上增量 `add[top]`。在这之后，我们将增量向栈底进行传递，累加至 `add[top - 1]` 处，这样 `inc` 操作的时间复杂度也减少至 $O(1)$ 了。

```C++ [sol2-C++]
class CustomStack {
public:
    vector<int> stk, add;
    int top;

    CustomStack(int maxSize) {
        stk.resize(maxSize);
        add.resize(maxSize);
        top = -1;
    }
    
    void push(int x) {
        if (top != stk.size() - 1) {
            ++top;
            stk[top] = x;
        }
    }
    
    int pop() {
        if (top == -1) {
            return -1;
        }
        int ret = stk[top] + add[top];
        if (top != 0) {
            add[top - 1] += add[top];
        }
        add[top] = 0;
        --top;
        return ret;
    }
    
    void increment(int k, int val) {
        int lim = min(k - 1, top);
        if (lim >= 0) {
            add[lim] += val;
        }
    }
};
```

```Java [sol2-Java]
class CustomStack {
    int[] stack;
    int[] add;
    int top;

    public CustomStack(int maxSize) {
        stack = new int[maxSize];
        add = new int[maxSize];
        top = -1;
    }
    
    public void push(int x) {
        if (top != stack.length - 1) {
            ++top;
            stack[top] = x;
        }
    }
    
    public int pop() {
        if (top == -1) {
            return -1;
        }
        int ret = stack[top] + add[top];
        if (top != 0) {
            add[top - 1] += add[top];
        }
        add[top] = 0;
        --top;
        return ret;
    }
    
    public void increment(int k, int val) {
        int limit = Math.min(k - 1, top);
        if (limit >= 0) {
            add[limit] += val;
        }
    }
}
```

```Python [sol2-Python3]
class CustomStack:

    def __init__(self, maxSize: int):
        self.stk = [0] * maxSize
        self.add = [0] * maxSize
        self.top = -1

    def push(self, x: int) -> None:
        if self.top != len(self.stk) - 1:
            self.top += 1
            self.stk[self.top] = x

    def pop(self) -> int:
        if self.top == -1:
            return -1
        ret = self.stk[self.top] + self.add[self.top]
        if self.top != 0:
            self.add[self.top - 1] += self.add[self.top]
        self.add[self.top] = 0
        self.top -= 1
        return ret

    def increment(self, k: int, val: int) -> None:
        lim = min(k - 1, self.top)
        if lim >= 0:
            self.add[lim] += val
```

**复杂度分析**

- 时间复杂度：所有操作的渐进时间复杂度均为 $O(1)$。

- 空间复杂度：这里用到了两个长度为 `maxSize` 的数组作为辅助空间，渐进空间复杂度为 $O({\rm maxSize})$。