## [2104.子数组范围和 中文官方题解](https://leetcode.cn/problems/sum-of-subarray-ranges/solutions/100000/zi-shu-zu-fan-wei-he-by-leetcode-solutio-lamr)
#### 方法一：遍历子数组

**思路与算法**

为了方便计算子数组的最大值与最小值，我们首先枚举子数组的左边界 $i$，然后枚举子数组的右边界 $j$，且 $i \le j$。在枚举 $j$ 的过程中我们可以迭代地计算子数组 $[i,j]$ 的最小值 $\textit{minVal}$ 与最大值 $\textit{maxVal}$，然后将范围值 $\textit{maxVal} - \textit{minVal}$ 加到总范围和。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long subArrayRanges(vector<int>& nums) {
        int n = nums.size();
        long long ret = 0;
        for (int i = 0; i < n; i++) {
            int minVal = INT_MAX, maxVal = INT_MIN;
            for (int j = i; j < n; j++) {
                minVal = min(minVal, nums[j]);
                maxVal = max(maxVal, nums[j]);
                ret += maxVal - minVal;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public long subArrayRanges(int[] nums) {
        int n = nums.length;
        long ret = 0;
        for (int i = 0; i < n; i++) {
            int minVal = Integer.MAX_VALUE, maxVal = Integer.MIN_VALUE;
            for (int j = i; j < n; j++) {
                minVal = Math.min(minVal, nums[j]);
                maxVal = Math.max(maxVal, nums[j]);
                ret += maxVal - minVal;
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public long SubArrayRanges(int[] nums) {
        int n = nums.Length;
        long ret = 0;
        for (int i = 0; i < n; i++) {
            int minVal = int.MaxValue, maxVal = int.MinValue;
            for (int j = i; j < n; j++) {
                minVal = Math.Min(minVal, nums[j]);
                maxVal = Math.Max(maxVal, nums[j]);
                ret += maxVal - minVal;
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

long long subArrayRanges(int* nums, int numsSize){
    long long ret = 0;
    for (int i = 0; i < numsSize; i++) {
        int minVal = INT_MAX, maxVal = INT_MIN;
        for (int j = i; j < numsSize; j++) {
            minVal = MIN(minVal, nums[j]);
            maxVal = MAX(maxVal, nums[j]);
            ret += maxVal - minVal;
        }
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var subArrayRanges = function(nums) {
    const n = nums.length;
    let ret = 0;
    for (let i = 0; i < n; i++) {
        let minVal = Number.MAX_VALUE, maxVal = -Number.MAX_VALUE;
        for (let j = i; j < n; j++) {
            minVal = Math.min(minVal, nums[j]);
            maxVal = Math.max(maxVal, nums[j]);
            ret += maxVal - minVal;
        }
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def subArrayRanges(self, nums: List[int]) -> int:
        ans, n = 0, len(nums)
        for i in range(n):
            minVal, maxVal = inf, -inf
            for j in range(i, n):
                minVal = min(minVal, nums[j])
                maxVal = max(maxVal, nums[j])
                ans += maxVal - minVal
        return ans
```

```go [sol1-Golang]
func subArrayRanges(nums []int) (ans int64) {
    for i, num := range nums {
        minVal, maxVal := num, num
        for _, v := range nums[i+1:] {
            if v < minVal {
                minVal = v
            } else if v > maxVal {
                maxVal = v
            }
            ans += int64(maxVal - minVal)
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 为数组的大小。两层循环需要 $O(n^2)$。

+ 空间复杂度：$O(1)$。

#### 方法二：单调栈

**思路与算法**

为了使子数组的最小值或最大值唯一，我们定义如果 $\textit{nums}[i] = \textit{nums}[j]$，那么 $\textit{nums}[i]$ 与 $\textit{nums}[j]$ 的逻辑大小由下标 $i$ 与下标 $j$ 的逻辑大小决定，即如果 $i < j$，那么 $\textit{nums}[i]$ 逻辑上小于 $\textit{nums}[j]$。

根据范围和的定义，可以推出范围和 $\textit{sum}$ 等于所有子数组的最大值之和 $\textit{sumMax}$ 减去所有子数组的最小值之和 $\textit{sumMin}$。

假设 $\textit{nums}[i]$ 左侧最近的比它小的数为 $\textit{nums}[j]$，右侧最近的比它小的数为 $\textit{nums}[k]$，那么所有以 $\textit{nums}[i]$ 为最小值的子数组数目为 $(k - i) \times (i - j)$。为了能获得 $\textit{nums}[i]$ 左侧和右侧最近的比它小的数的下标，我们可以使用单调递增栈分别预处理出数组 $\textit{minLeft}$ 和 $\textit{minRight}$，其中 $\textit{minLeft}[i]$ 表示 $\textit{nums}[i]$ 左侧最近的比它小的数的下标，$\textit{minRight}[i]$ 表示 $\textit{nums}[i]$ 右侧最近的比它小的数的下标。

> 以求解 $\textit{minLeft}$ 为例，我们从左到右遍历整个数组 $\textit{nums}$。处理到 $\textit{nums}[i]$ 时，我们执行出栈操作直到栈为空或者 $\textit{nums}$ 中以栈顶元素为下标的数逻辑上小于 $\textit{nums}[i]$。如果栈为空，那么 $\textit{minLeft}[i] = -1$，否则 $\textit{minLeft}[i]$ 等于栈顶元素，然后将下标 $i$ 入栈。

那么所有子数组的最小值之和 $\textit{sumMin} = \sum_{i=0}^{n-1} (\textit{minRight}[i] - i) \times (i - \textit{minLeft}[i]) \times \textit{nums}[i]$。同理我们也可以求得所有子数组的最大值之和 $\textit{sumMax}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    long long subArrayRanges(vector<int>& nums) {
        int n = nums.size();
        vector<int> minLeft(n), minRight(n), maxLeft(n), maxRight(n);
        stack<int> minStack, maxStack;
        for (int i = 0; i < n; i++) {
            while (!minStack.empty() && nums[minStack.top()] > nums[i]) {
                minStack.pop();
            }
            minLeft[i] = minStack.empty() ? -1 : minStack.top();
            minStack.push(i);
            
            // 如果 nums[maxStack.top()] == nums[i], 那么根据定义，
            // nums[maxStack.top()] 逻辑上小于 nums[i]，因为 maxStack.top() < i
            while (!maxStack.empty() && nums[maxStack.top()] <= nums[i]) { 
                maxStack.pop();
            }
            maxLeft[i] = maxStack.empty() ? -1 : maxStack.top();
            maxStack.push(i);
        }
        minStack = stack<int>();
        maxStack = stack<int>();
        for (int i = n - 1; i >= 0; i--) {
            // 如果 nums[minStack.top()] == nums[i], 那么根据定义，
            // nums[minStack.top()] 逻辑上大于 nums[i]，因为 minStack.top() > i
            while (!minStack.empty() && nums[minStack.top()] >= nums[i]) { 
                minStack.pop();
            }
            minRight[i] = minStack.empty() ? n : minStack.top();
            minStack.push(i);

            while (!maxStack.empty() && nums[maxStack.top()] < nums[i]) {
                maxStack.pop();
            }
            maxRight[i] = maxStack.empty() ? n : maxStack.top();
            maxStack.push(i);
        }

        long long sumMax = 0, sumMin = 0;
        for (int i = 0; i < n; i++) {
            sumMax += static_cast<long long>(maxRight[i] - i) * (i - maxLeft[i]) * nums[i];
            sumMin += static_cast<long long>(minRight[i] - i) * (i - minLeft[i]) * nums[i];
        }
        return sumMax - sumMin;
    }
};
```

```Java [sol2-Java]
class Solution {
    public long subArrayRanges(int[] nums) {
        int n = nums.length;
        int[] minLeft = new int[n];
        int[] minRight = new int[n];
        int[] maxLeft = new int[n];
        int[] maxRight = new int[n];
        Deque<Integer> minStack = new ArrayDeque<Integer>();
        Deque<Integer> maxStack = new ArrayDeque<Integer>();
        for (int i = 0; i < n; i++) {
            while (!minStack.isEmpty() && nums[minStack.peek()] > nums[i]) {
                minStack.pop();
            }
            minLeft[i] = minStack.isEmpty() ? -1 : minStack.peek();
            minStack.push(i);
            
            // 如果 nums[maxStack.peek()] == nums[i], 那么根据定义，
            // nums[maxStack.peek()] 逻辑上小于 nums[i]，因为 maxStack.peek() < i
            while (!maxStack.isEmpty() && nums[maxStack.peek()] <= nums[i]) { 
                maxStack.pop();
            }
            maxLeft[i] = maxStack.isEmpty() ? -1 : maxStack.peek();
            maxStack.push(i);
        }
        minStack.clear();
        maxStack.clear();
        for (int i = n - 1; i >= 0; i--) {
            // 如果 nums[minStack.peek()] == nums[i], 那么根据定义，
            // nums[minStack.peek()] 逻辑上大于 nums[i]，因为 minStack.peek() > i
            while (!minStack.isEmpty() && nums[minStack.peek()] >= nums[i]) { 
                minStack.pop();
            }
            minRight[i] = minStack.isEmpty() ? n : minStack.peek();
            minStack.push(i);

            while (!maxStack.isEmpty() && nums[maxStack.peek()] < nums[i]) {
                maxStack.pop();
            }
            maxRight[i] = maxStack.isEmpty() ? n : maxStack.peek();
            maxStack.push(i);
        }

        long sumMax = 0, sumMin = 0;
        for (int i = 0; i < n; i++) {
            sumMax += (long) (maxRight[i] - i) * (i - maxLeft[i]) * nums[i];
            sumMin += (long) (minRight[i] - i) * (i - minLeft[i]) * nums[i];
        }
        return sumMax - sumMin;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public long SubArrayRanges(int[] nums) {
        int n = nums.Length;
        int[] minLeft = new int[n];
        int[] minRight = new int[n];
        int[] maxLeft = new int[n];
        int[] maxRight = new int[n];
        Stack<int> minStack = new Stack<int>();
        Stack<int> maxStack = new Stack<int>();
        for (int i = 0; i < n; i++) {
            while (minStack.Count > 0 && nums[minStack.Peek()] > nums[i]) {
                minStack.Pop();
            }
            minLeft[i] = minStack.Count == 0 ? -1 : minStack.Peek();
            minStack.Push(i);
            
            // 如果 nums[maxStack.Peek()] == nums[i], 那么根据定义，
            // nums[maxStack.Peek()] 逻辑上小于 nums[i]，因为 maxStack.Peek() < i
            while (maxStack.Count > 0 && nums[maxStack.Peek()] <= nums[i]) { 
                maxStack.Pop();
            }
            maxLeft[i] = maxStack.Count == 0 ? -1 : maxStack.Peek();
            maxStack.Push(i);
        }
        minStack.Clear();
        maxStack.Clear();
        for (int i = n - 1; i >= 0; i--) {
            // 如果 nums[minStack.Peek()] == nums[i], 那么根据定义，
            // nums[minStack.Peek()] 逻辑上大于 nums[i]，因为 minStack.Peek() > i
            while (minStack.Count > 0 && nums[minStack.Peek()] >= nums[i]) { 
                minStack.Pop();
            }
            minRight[i] = minStack.Count == 0 ? n : minStack.Peek();
            minStack.Push(i);

            while (maxStack.Count > 0 && nums[maxStack.Peek()] < nums[i]) {
                maxStack.Pop();
            }
            maxRight[i] = maxStack.Count == 0 ? n : maxStack.Peek();
            maxStack.Push(i);
        }

        long sumMax = 0, sumMin = 0;
        for (int i = 0; i < n; i++) {
            sumMax += (long) (maxRight[i] - i) * (i - maxLeft[i]) * nums[i];
            sumMin += (long) (minRight[i] - i) * (i - minLeft[i]) * nums[i];
        }
        return sumMax - sumMin;
    }
}
```

```C [sol2-C]
typedef struct {
    int * stBuff;
    int stSize;
    int stTop;
} Stack;

void initStack(Stack * obj, int stSize) {
    obj->stBuff = (int *)malloc(sizeof(int) * stSize);
    obj->stSize = stSize;
    obj->stTop = 0;
}

static inline bool pushStack(Stack * obj, int val) {
    if (obj->stTop == obj->stSize) {
        return false;
    }
    obj->stBuff[obj->stTop++] = val;
    return true;
}

static inline int popStack(Stack * obj) {
    if (obj->stTop == 0) {
        return -1;
    }
    int res =  obj->stBuff[obj->stTop - 1];
    obj->stTop--;
    return res;
}


static inline bool isEmptyStack(const Stack * obj) {
    return obj->stTop == 0;
}

static inline int topStack(const Stack * obj) {
    if (obj->stTop == 0) {
        return -1;
    }
    return obj->stBuff[obj->stTop - 1]; 
}

static inline bool clearStack(Stack * obj) {
    obj->stTop = 0;
    return true;
}

static inline void freeStack(Stack * obj) {
    free(obj->stBuff);
}

long long subArrayRanges(int* nums, int numsSize){
    int * minLeft = (int *)malloc(sizeof(int) * numsSize);
    int * minRight = (int *)malloc(sizeof(int) * numsSize);
    int * maxLeft = (int *)malloc(sizeof(int) * numsSize);
    int * maxRight = (int *)malloc(sizeof(int) * numsSize);
    Stack minStack, maxStack;
    initStack(&minStack, numsSize);
    initStack(&maxStack, numsSize);
    for (int i = 0; i < numsSize; i++) {
        while (!isEmptyStack(&minStack) && nums[topStack(&minStack)] > nums[i]) {
            popStack(&minStack);
        }
        minLeft[i] = isEmptyStack(&minStack) ? -1 : topStack(&minStack);
        pushStack(&minStack, i);
        
        // 如果 nums[maxStack.top()] == nums[i], 那么根据定义，
        // nums[maxStack.top()] 逻辑上小于 nums[i]，因为 maxStack.top() < i
        while (!isEmptyStack(&maxStack) && nums[topStack(&maxStack)] <= nums[i]) { 
            popStack(&maxStack);
        }
        maxLeft[i] = isEmptyStack(&maxStack) ? -1 : topStack(&maxStack);
        pushStack(&maxStack, i);
    }
    clearStack(&minStack);
    clearStack(&maxStack);
    for (int i = numsSize - 1; i >= 0; i--) {
        // 如果 nums[minStack.top()] == nums[i], 那么根据定义，
        // nums[minStack.top()] 逻辑上大于 nums[i]，因为 minStack.top() > i
        while (!isEmptyStack(&minStack) && nums[topStack(&minStack)] >= nums[i]) { 
            popStack(&minStack);
        }
        minRight[i] = isEmptyStack(&minStack) ? numsSize : topStack(&minStack);
        pushStack(&minStack, i);

        while (!isEmptyStack(&maxStack) && nums[topStack(&maxStack)] < nums[i]) { 
            popStack(&maxStack);
        }
        maxRight[i] = isEmptyStack(&maxStack) ? numsSize : topStack(&maxStack);
        pushStack(&maxStack, i);
    }
    freeStack(&minStack);
    freeStack(&maxStack);

    long long sumMax = 0, sumMin = 0;
    for (int i = 0; i < numsSize; i++) {
        sumMax += (long long)(maxRight[i] - i) * (i - maxLeft[i]) * nums[i];
        sumMin += (long long)(minRight[i] - i) * (i - minLeft[i]) * nums[i];
    }
    
    return sumMax - sumMin;
}
```

```JavaScript [sol2-JavaScript]
var subArrayRanges = function(nums) {
    const n = nums.length;
    const minLeft = new Array(n).fill(0);
    const minRight = new Array(n).fill(0);
    const maxLeft = new Array(n).fill(0);
    const maxRight = new Array(n).fill(0);
    let minStack = [];
    let maxStack = [];
    for (let i = 0; i < n; i++) {
        while (minStack.length && nums[minStack[minStack.length - 1]] > nums[i]) {
            minStack.pop();
        }
        minLeft[i] = minStack.length === 0 ? -1 : minStack[minStack.length - 1];
        minStack.push(i);
        
        // 如果 nums[maxStack[maxStack.length - 1]] == nums[i], 那么根据定义，
        // nums[maxStack[maxStack.length - 1]] 逻辑上小于 nums[i]，因为 maxStack[maxStack.length - 1] < i
        while (maxStack.length && nums[maxStack[maxStack.length - 1]] <= nums[i]) { 
            maxStack.pop();
        }
        maxLeft[i] = maxStack.length === 0 ? -1 : maxStack[maxStack.length - 1];
        maxStack.push(i);
    }
    minStack = [];
    maxStack = [];
    for (let i = n - 1; i >= 0; i--) {
        // 如果 nums[minStack[minStack.length - 1]] == nums[i], 那么根据定义，
        // nums[minStack[minStack.length - 1]] 逻辑上大于 nums[i]，因为 minStack[minStack.length - 1] > i
        while (minStack.length && nums[minStack[minStack.length - 1]] >= nums[i]) { 
            minStack.pop();
        }
        minRight[i] = minStack.length === 0 ? n : minStack[minStack.length - 1];
        minStack.push(i);

        while (maxStack.length && nums[maxStack[maxStack.length - 1]] < nums[i]) {
            maxStack.pop();
        }
        maxRight[i] = maxStack.length === 0 ? n : maxStack[maxStack.length - 1];
        maxStack.push(i);
    }

    let sumMax = 0, sumMin = 0;
    for (let i = 0; i < n; i++) {
        sumMax += (maxRight[i] - i) * (i - maxLeft[i]) * nums[i];
        sumMin += (minRight[i] - i) * (i - minLeft[i]) * nums[i];
    }
    return sumMax - sumMin;
};
```

```Python [sol2-Python3]
class Solution:
    def subArrayRanges(self, nums: List[int]) -> int:
        n = len(nums)
        minLeft, maxLeft = [0] * n, [0] * n
        minStack, maxStack = [], []
        for i, num in enumerate(nums):
            while minStack and nums[minStack[-1]] > num:
                minStack.pop()
            minLeft[i] = minStack[-1] if minStack else -1
            minStack.append(i)

            # 如果 nums[maxStack[-1]] == num, 那么根据定义，
            # nums[maxStack[-1]] 逻辑上小于 num，因为 maxStack[-1] < i
            while maxStack and nums[maxStack[-1]] <= num:
                maxStack.pop()
            maxLeft[i] = maxStack[-1] if maxStack else -1
            maxStack.append(i)

        minRight, maxRight = [0] * n, [0] * n
        minStack, maxStack = [], []
        for i in range(n - 1, -1, -1):
            num = nums[i]
            # 如果 nums[minStack[-1]] == num, 那么根据定义，
            # nums[minStack[-1]] 逻辑上大于 num，因为 minStack[-1] > i
            while minStack and nums[minStack[-1]] >= num:
                minStack.pop()
            minRight[i] = minStack[-1] if minStack else n
            minStack.append(i)

            while maxStack and nums[maxStack[-1]] < num:
                maxStack.pop()
            maxRight[i] = maxStack[-1] if maxStack else n
            maxStack.append(i)

        sumMax, sumMin = 0, 0
        for i, num in enumerate(nums):
            sumMax += (maxRight[i] - i) * (i - maxLeft[i]) * num
            sumMin += (minRight[i] - i) * (i - minLeft[i]) * num
        return sumMax - sumMin
```

```go [sol2-Golang]
func subArrayRanges(nums []int) int64 {
    n := len(nums)
    minLeft := make([]int, n)
    maxLeft := make([]int, n)
    var minStk, maxStk []int
    for i, num := range nums {
        for len(minStk) > 0 && nums[minStk[len(minStk)-1]] > num {
            minStk = minStk[:len(minStk)-1]
        }
        if len(minStk) > 0 {
            minLeft[i] = minStk[len(minStk)-1]
        } else {
            minLeft[i] = -1
        }
        minStk = append(minStk, i)

        // 如果 nums[maxStk[len(maxStk)-1]] == num, 那么根据定义，
        // nums[maxStk[len(maxStk)-1]] 逻辑上小于 num，因为 maxStk[len(maxStk)-1] < i
        for len(maxStk) > 0 && nums[maxStk[len(maxStk)-1]] <= num {
            maxStk = maxStk[:len(maxStk)-1]
        }
        if len(maxStk) > 0 {
            maxLeft[i] = maxStk[len(maxStk)-1]
        } else {
            maxLeft[i] = -1
        }
        maxStk = append(maxStk, i)
    }

    minRight := make([]int, n)
    maxRight := make([]int, n)
    minStk = minStk[:0]
    maxStk = maxStk[:0]
    for i := n - 1; i >= 0; i-- {
        num := nums[i]
        // 如果 nums[minStk[len(minStk)-1]] == num, 那么根据定义，
        // nums[minStk[len(minStk)-1]] 逻辑上大于 num，因为 minStk[len(minStk)-1] > i
        for len(minStk) > 0 && nums[minStk[len(minStk)-1]] >= num {
            minStk = minStk[:len(minStk)-1]
        }
        if len(minStk) > 0 {
            minRight[i] = minStk[len(minStk)-1]
        } else {
            minRight[i] = n
        }
        minStk = append(minStk, i)

        for len(maxStk) > 0 && nums[maxStk[len(maxStk)-1]] < num {
            maxStk = maxStk[:len(maxStk)-1]
        }
        if len(maxStk) > 0 {
            maxRight[i] = maxStk[len(maxStk)-1]
        } else {
            maxRight[i] = n
        }
        maxStk = append(maxStk, i)
    }

    var sumMax, sumMin int64
    for i, num := range nums {
        sumMax += int64(maxRight[i]-i) * int64(i-maxLeft[i]) * int64(num)
        sumMin += int64(minRight[i]-i) * int64(i-minLeft[i]) * int64(num)
    }
    return sumMax - sumMin
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为数组的大小。使用单调栈预处理出四个数组需要 $O(n)$，计算最大值之和与最小值之和需要 $O(n)$。

+ 空间复杂度：$O(n)$。保存四个数组需要 $O(n)$；单调栈最多保存 $n$ 个元素，需要 $O(n)$。