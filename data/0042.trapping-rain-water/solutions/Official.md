### 📺 视频题解  
![42. 接雨水.mp4](21f6ec58-ab28-4e14-9fd0-bcd7d68f35b1)

### 📖 文字题解
#### 方法一：动态规划

对于下标 $i$，下雨后水能到达的最大高度等于下标 $i$ 两边的最大高度的最小值，下标 $i$ 处能接的雨水量等于下标 $i$ 处的水能到达的最大高度减去 $\textit{height}[i]$。

朴素的做法是对于数组 $\textit{height}$ 中的每个元素，分别向左和向右扫描并记录左边和右边的最大高度，然后计算每个下标位置能接的雨水量。假设数组 $\textit{height}$ 的长度为 $n$，该做法需要对每个下标位置使用 $O(n)$ 的时间向两边扫描并得到最大高度，因此总时间复杂度是 $O(n^2)$。

上述做法的时间复杂度较高是因为需要对每个下标位置都向两边扫描。如果已经知道每个位置两边的最大高度，则可以在 $O(n)$ 的时间内得到能接的雨水总量。使用动态规划的方法，可以在 $O(n)$ 的时间内预处理得到每个位置两边的最大高度。

创建两个长度为 $n$ 的数组 $\textit{leftMax}$ 和 $\textit{rightMax}$。对于 $0 \le i<n$，$\textit{leftMax}[i]$ 表示下标 $i$ 及其左边的位置中，$\textit{height}$ 的最大高度，$\textit{rightMax}[i]$ 表示下标 $i$ 及其右边的位置中，$\textit{height}$ 的最大高度。

显然，$\textit{leftMax}[0]=\textit{height}[0]$，$\textit{rightMax}[n-1]=\textit{height}[n-1]$。两个数组的其余元素的计算如下：

- 当 $1 \le i \le n-1$ 时，$\textit{leftMax}[i]=\max(\textit{leftMax}[i-1], \textit{height}[i])$；

- 当 $0 \le i \le n-2$ 时，$\textit{rightMax}[i]=\max(\textit{rightMax}[i+1], \textit{height}[i])$。

因此可以正向遍历数组 $\textit{height}$ 得到数组 $\textit{leftMax}$ 的每个元素值，反向遍历数组 $\textit{height}$ 得到数组 $\textit{rightMax}$ 的每个元素值。

在得到数组 $\textit{leftMax}$ 和 $\textit{rightMax}$ 的每个元素值之后，对于 $0 \le i<n$，下标 $i$ 处能接的雨水量等于 $\min(\textit{leftMax}[i],\textit{rightMax}[i])-\textit{height}[i]$。遍历每个下标位置即可得到能接的雨水总量。

动态规划做法可以由下图体现。

![fig1](https://assets.leetcode-cn.com/solution-static/42/1.png)

```Java [sol1-Java]
class Solution {
    public int trap(int[] height) {
        int n = height.length;
        if (n == 0) {
            return 0;
        }

        int[] leftMax = new int[n];
        leftMax[0] = height[0];
        for (int i = 1; i < n; ++i) {
            leftMax[i] = Math.max(leftMax[i - 1], height[i]);
        }

        int[] rightMax = new int[n];
        rightMax[n - 1] = height[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            rightMax[i] = Math.max(rightMax[i + 1], height[i]);
        }

        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans += Math.min(leftMax[i], rightMax[i]) - height[i];
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func trap(height []int) (ans int) {
    n := len(height)
    if n == 0 {
        return
    }

    leftMax := make([]int, n)
    leftMax[0] = height[0]
    for i := 1; i < n; i++ {
        leftMax[i] = max(leftMax[i-1], height[i])
    }

    rightMax := make([]int, n)
    rightMax[n-1] = height[n-1]
    for i := n - 2; i >= 0; i-- {
        rightMax[i] = max(rightMax[i+1], height[i])
    }

    for i, h := range height {
        ans += min(leftMax[i], rightMax[i]) - h
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var trap = function(height) {
    const n = height.length;
    if (n == 0) {
        return 0;
    }

    const leftMax = new Array(n).fill(0);
    leftMax[0] = height[0];
    for (let i = 1; i < n; ++i) {
        leftMax[i] = Math.max(leftMax[i - 1], height[i]);
    }

    const rightMax = new Array(n).fill(0);
    rightMax[n - 1] = height[n - 1];
    for (let i = n - 2; i >= 0; --i) {
        rightMax[i] = Math.max(rightMax[i + 1], height[i]);
    }

    let ans = 0;
    for (let i = 0; i < n; ++i) {
        ans += Math.min(leftMax[i], rightMax[i]) - height[i];
    }
    return ans;
};
```

```Python [sol1-Python3]
class Solution:
    def trap(self, height: List[int]) -> int:
        if not height:
            return 0
        
        n = len(height)
        leftMax = [height[0]] + [0] * (n - 1)
        for i in range(1, n):
            leftMax[i] = max(leftMax[i - 1], height[i])

        rightMax = [0] * (n - 1) + [height[n - 1]]
        for i in range(n - 2, -1, -1):
            rightMax[i] = max(rightMax[i + 1], height[i])

        ans = sum(min(leftMax[i], rightMax[i]) - height[i] for i in range(n))
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int trap(vector<int>& height) {
        int n = height.size();
        if (n == 0) {
            return 0;
        }
        vector<int> leftMax(n);
        leftMax[0] = height[0];
        for (int i = 1; i < n; ++i) {
            leftMax[i] = max(leftMax[i - 1], height[i]);
        }

        vector<int> rightMax(n);
        rightMax[n - 1] = height[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            rightMax[i] = max(rightMax[i + 1], height[i]);
        }

        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans += min(leftMax[i], rightMax[i]) - height[i];
        }
        return ans;
    }
};
```

```C [sol1-C]
int trap(int* height, int heightSize) {
    int n = heightSize;
    if (n == 0) {
        return 0;
    }
    int leftMax[n];
    memset(leftMax, 0, sizeof(leftMax));
    leftMax[0] = height[0];
    for (int i = 1; i < n; ++i) {
        leftMax[i] = fmax(leftMax[i - 1], height[i]);
    }

    int rightMax[n];
    memset(rightMax, 0, sizeof(rightMax));
    rightMax[n - 1] = height[n - 1];
    for (int i = n - 2; i >= 0; --i) {
        rightMax[i] = fmax(rightMax[i + 1], height[i]);
    }

    int ans = 0;
    for (int i = 0; i < n; ++i) {
        ans += fmin(leftMax[i], rightMax[i]) - height[i];
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{height}$ 的长度。计算数组 $\textit{leftMax}$ 和 $\textit{rightMax}$ 的元素值各需要遍历数组 $\textit{height}$ 一次，计算能接的雨水总量还需要遍历一次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{height}$ 的长度。需要创建两个长度为 $n$ 的数组 $\textit{leftMax}$ 和 $\textit{rightMax}$。

#### 方法二：单调栈

除了计算并存储每个位置两边的最大高度以外，也可以用单调栈计算能接的雨水总量。

维护一个单调栈，单调栈存储的是下标，满足从栈底到栈顶的下标对应的数组 $\textit{height}$ 中的元素递减。

从左到右遍历数组，遍历到下标 $i$ 时，如果栈内至少有两个元素，记栈顶元素为 $\textit{top}$，$\textit{top}$ 的下面一个元素是 $\textit{left}$，则一定有 $\textit{height}[\textit{left}] \ge \textit{height}[\textit{top}]$。如果 $\textit{height}[i]>\textit{height}[\textit{top}]$，则得到一个可以接雨水的区域，该区域的宽度是 $i-\textit{left}-1$，高度是 $\min(\textit{height}[\textit{left}],\textit{height}[i])-\textit{height}[\textit{top}]$，根据宽度和高度即可计算得到该区域能接的雨水量。

为了得到 $\textit{left}$，需要将 $\textit{top}$ 出栈。在对 $\textit{top}$ 计算能接的雨水量之后，$\textit{left}$ 变成新的 $\textit{top}$，重复上述操作，直到栈变为空，或者栈顶下标对应的 $\textit{height}$ 中的元素大于或等于 $\textit{height}[i]$。

在对下标 $i$ 处计算能接的雨水量之后，将 $i$ 入栈，继续遍历后面的下标，计算能接的雨水量。遍历结束之后即可得到能接的雨水总量。

下面用一个例子 $\textit{height}=[0,1,0,2,1,0,1,3,2,1,2,1]$ 来帮助读者理解单调栈的做法。

<![f1](https://assets.leetcode-cn.com/solution-static/42/f1.png),![f2](https://assets.leetcode-cn.com/solution-static/42/f2.png),![f3](https://assets.leetcode-cn.com/solution-static/42/f3.png),![f4](https://assets.leetcode-cn.com/solution-static/42/f4.png),![f5](https://assets.leetcode-cn.com/solution-static/42/f5.png),![f6](https://assets.leetcode-cn.com/solution-static/42/f6.png),![f7](https://assets.leetcode-cn.com/solution-static/42/f7.png),![f8](https://assets.leetcode-cn.com/solution-static/42/f8.png),![f9](https://assets.leetcode-cn.com/solution-static/42/f9.png),![f10](https://assets.leetcode-cn.com/solution-static/42/f10.png),![f11](https://assets.leetcode-cn.com/solution-static/42/f11.png),![f12](https://assets.leetcode-cn.com/solution-static/42/f12.png),![f13](https://assets.leetcode-cn.com/solution-static/42/f13.png),![f14](https://assets.leetcode-cn.com/solution-static/42/f14.png),![f15](https://assets.leetcode-cn.com/solution-static/42/f15.png),![f16](https://assets.leetcode-cn.com/solution-static/42/f16.png),![f17](https://assets.leetcode-cn.com/solution-static/42/f17.png),![f18](https://assets.leetcode-cn.com/solution-static/42/f18.png),![f19](https://assets.leetcode-cn.com/solution-static/42/f19.png),![f20](https://assets.leetcode-cn.com/solution-static/42/f20.png),![f21](https://assets.leetcode-cn.com/solution-static/42/f21.png)>

```Java [sol2-Java]
class Solution {
    public int trap(int[] height) {
        int ans = 0;
        Deque<Integer> stack = new LinkedList<Integer>();
        int n = height.length;
        for (int i = 0; i < n; ++i) {
            while (!stack.isEmpty() && height[i] > height[stack.peek()]) {
                int top = stack.pop();
                if (stack.isEmpty()) {
                    break;
                }
                int left = stack.peek();
                int currWidth = i - left - 1;
                int currHeight = Math.min(height[left], height[i]) - height[top];
                ans += currWidth * currHeight;
            }
            stack.push(i);
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func trap(height []int) (ans int) {
    stack := []int{}
    for i, h := range height {
        for len(stack) > 0 && h > height[stack[len(stack)-1]] {
            top := stack[len(stack)-1]
            stack = stack[:len(stack)-1]
            if len(stack) == 0 {
                break
            }
            left := stack[len(stack)-1]
            curWidth := i - left - 1
            curHeight := min(height[left], h) - height[top]
            ans += curWidth * curHeight
        }
        stack = append(stack, i)
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol2-JavaScript]
var trap = function(height) {
    let ans = 0;
    const stack = [];
    const n = height.length;
    for (let i = 0; i < n; ++i) {
        while (stack.length && height[i] > height[stack[stack.length - 1]]) {
            const top = stack.pop();
            if (!stack.length) {
                break;
            }
            const left = stack[stack.length - 1];
            const currWidth = i - left - 1;
            const currHeight = Math.min(height[left], height[i]) - height[top];
            ans += currWidth * currHeight;
        }
        stack.push(i);
    }
    return ans;
};
```

```Python [sol2-Python3]
class Solution:
    def trap(self, height: List[int]) -> int:
        ans = 0
        stack = list()
        n = len(height)
        
        for i, h in enumerate(height):
            while stack and h > height[stack[-1]]:
                top = stack.pop()
                if not stack:
                    break
                left = stack[-1]
                currWidth = i - left - 1
                currHeight = min(height[left], height[i]) - height[top]
                ans += currWidth * currHeight
            stack.append(i)
        
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        stack<int> stk;
        int n = height.size();
        for (int i = 0; i < n; ++i) {
            while (!stk.empty() && height[i] > height[stk.top()]) {
                int top = stk.top();
                stk.pop();
                if (stk.empty()) {
                    break;
                }
                int left = stk.top();
                int currWidth = i - left - 1;
                int currHeight = min(height[left], height[i]) - height[top];
                ans += currWidth * currHeight;
            }
            stk.push(i);
        }
        return ans;
    }
};
```

```C [sol2-C]
int trap(int* height, int heightSize) {
    int n = heightSize;
    if (n == 0) {
        return 0;
    }
    int ans = 0;
    int stk[n], top = 0;
    for (int i = 0; i < n; ++i) {
        while (top && height[i] > height[stk[top - 1]]) {
            int stk_top = stk[--top];
            if (!top) {
                break;
            }
            int left = stk[top - 1];
            int currWidth = i - left - 1;
            int currHeight = fmin(height[left], height[i]) - height[stk_top];
            ans += currWidth * currHeight;
        }
        stk[top++] = i;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{height}$ 的长度。从 $0$ 到 $n-1$ 的每个下标最多只会入栈和出栈各一次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{height}$ 的长度。空间复杂度主要取决于栈空间，栈的大小不会超过 $n$。

#### 方法三：双指针

动态规划的做法中，需要维护两个数组 $\textit{leftMax}$ 和 $\textit{rightMax}$，因此空间复杂度是 $O(n)$。是否可以将空间复杂度降到 $O(1)$？

注意到下标 $i$ 处能接的雨水量由 $\textit{leftMax}[i]$ 和 $\textit{rightMax}[i]$ 中的最小值决定。由于数组 $\textit{leftMax}$ 是从左往右计算，数组 $\textit{rightMax}$ 是从右往左计算，因此可以使用双指针和两个变量代替两个数组。

维护两个指针 $\textit{left}$ 和 $\textit{right}$，以及两个变量 $\textit{leftMax}$ 和 $\textit{rightMax}$，初始时 $\textit{left}=0,\textit{right}=n-1,\textit{leftMax}=0,\textit{rightMax}=0$。指针 $\textit{left}$ 只会向右移动，指针 $\textit{right}$ 只会向左移动，在移动指针的过程中维护两个变量 $\textit{leftMax}$ 和 $\textit{rightMax}$ 的值。

当两个指针没有相遇时，进行如下操作：

- 使用 $\textit{height}[\textit{left}]$ 和 $\textit{height}[\textit{right}]$ 的值更新 $\textit{leftMax}$ 和 $\textit{rightMax}$ 的值；

- 如果 $\textit{height}[\textit{left}]<\textit{height}[\textit{right}]$，则必有 $\textit{leftMax}<\textit{rightMax}$，下标 $\textit{left}$ 处能接的雨水量等于 $\textit{leftMax}-\textit{height}[\textit{left}]$，将下标 $\textit{left}$ 处能接的雨水量加到能接的雨水总量，然后将 $\textit{left}$ 加 $1$（即向右移动一位）；

- 如果 $\textit{height}[\textit{left}] \ge \textit{height}[\textit{right}]$，则必有 $\textit{leftMax} \ge \textit{rightMax}$，下标 $\textit{right}$ 处能接的雨水量等于 $\textit{rightMax}-\textit{height}[\textit{right}]$，将下标 $\textit{right}$ 处能接的雨水量加到能接的雨水总量，然后将 $\textit{right}$ 减 $1$（即向左移动一位）。

当两个指针相遇时，即可得到能接的雨水总量。

下面用一个例子 $\textit{height}=[0,1,0,2,1,0,1,3,2,1,2,1]$ 来帮助读者理解双指针的做法。

<![p1](https://assets.leetcode-cn.com/solution-static/42/p1.png),![p2](https://assets.leetcode-cn.com/solution-static/42/p2.png),![p3](https://assets.leetcode-cn.com/solution-static/42/p3.png),![p4](https://assets.leetcode-cn.com/solution-static/42/p4.png),![p5](https://assets.leetcode-cn.com/solution-static/42/p5.png),![p6](https://assets.leetcode-cn.com/solution-static/42/p6.png),![p7](https://assets.leetcode-cn.com/solution-static/42/p7.png),![p8](https://assets.leetcode-cn.com/solution-static/42/p8.png),![p9](https://assets.leetcode-cn.com/solution-static/42/p9.png),![p10](https://assets.leetcode-cn.com/solution-static/42/p10.png),![p11](https://assets.leetcode-cn.com/solution-static/42/p11.png),![p12](https://assets.leetcode-cn.com/solution-static/42/p12.png)>

```Java [sol3-Java]
class Solution {
    public int trap(int[] height) {
        int ans = 0;
        int left = 0, right = height.length - 1;
        int leftMax = 0, rightMax = 0;
        while (left < right) {
            leftMax = Math.max(leftMax, height[left]);
            rightMax = Math.max(rightMax, height[right]);
            if (height[left] < height[right]) {
                ans += leftMax - height[left];
                ++left;
            } else {
                ans += rightMax - height[right];
                --right;
            }
        }
        return ans;
    }
}
```

```go [sol3-Golang]
func trap(height []int) (ans int) {
    left, right := 0, len(height)-1
    leftMax, rightMax := 0, 0
    for left < right {
        leftMax = max(leftMax, height[left])
        rightMax = max(rightMax, height[right])
        if height[left] < height[right] {
            ans += leftMax - height[left]
            left++
        } else {
            ans += rightMax - height[right]
            right--
        }
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol3-JavaScript]
var trap = function(height) {
    let ans = 0;
    let left = 0, right = height.length - 1;
    let leftMax = 0, rightMax = 0;
    while (left < right) {
        leftMax = Math.max(leftMax, height[left]);
        rightMax = Math.max(rightMax, height[right]);
        if (height[left] < height[right]) {
            ans += leftMax - height[left];
            ++left;
        } else {
            ans += rightMax - height[right];
            --right;
        }
    }
    return ans;
};
```

```Python [sol3-Python3]
class Solution:
    def trap(self, height: List[int]) -> int:
        ans = 0
        left, right = 0, len(height) - 1
        leftMax = rightMax = 0

        while left < right:
            leftMax = max(leftMax, height[left])
            rightMax = max(rightMax, height[right])
            if height[left] < height[right]:
                ans += leftMax - height[left]
                left += 1
            else:
                ans += rightMax - height[right]
                right -= 1
        
        return ans
```

```C++ [sol3-C++]
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        int left = 0, right = height.size() - 1;
        int leftMax = 0, rightMax = 0;
        while (left < right) {
            leftMax = max(leftMax, height[left]);
            rightMax = max(rightMax, height[right]);
            if (height[left] < height[right]) {
                ans += leftMax - height[left];
                ++left;
            } else {
                ans += rightMax - height[right];
                --right;
            }
        }
        return ans;
    }
};
```

```C [sol3-C]
int trap(int* height, int heightSize) {
    int ans = 0;
    int left = 0, right = heightSize - 1;
    int leftMax = 0, rightMax = 0;
    while (left < right) {
        leftMax = fmax(leftMax, height[left]);
        rightMax = fmax(rightMax, height[right]);
        if (height[left] < height[right]) {
            ans += leftMax - height[left];
            ++left;
        } else {
            ans += rightMax - height[right];
            --right;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{height}$ 的长度。两个指针的移动总次数不超过 $n$。

- 空间复杂度：$O(1)$。只需要使用常数的额外空间。