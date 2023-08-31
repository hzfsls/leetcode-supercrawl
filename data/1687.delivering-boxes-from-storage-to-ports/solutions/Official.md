## [1687.从仓库到码头运输箱子 中文官方题解](https://leetcode.cn/problems/delivering-boxes-from-storage-to-ports/solutions/100000/cong-cang-ku-dao-ma-tou-yun-shu-xiang-zi-4uya)
#### 方法一：动态规划 + 单调队列优化

**前言**

为了叙述方便，我们记箱子的数量为 $n$，它们的目的地分别为 $p_1, \cdots, p_n$，重量分别为 $w_1, \cdots, w_n$。

记 $W_i$ 表示 $w$ 的前缀和，即：

$$
W_i = \left\{
\begin{aligned}
& 0, && i = 0 \\
& \sum_{k=1}^i w_i, && i > 0
\end{aligned} \right.
$$

这样我们可以用 $W_i - W_{j-1}$ 方便地表示第 $i$ 个到第 $j$ 个箱子的重量，并与 $\textit{maxWeight}$ 进行比较。

记示性函数 $\mathbb{I}(i)$ 表示 $p_i$ 和 $p_{i+1}$ 是否**不等**，即：

$$
\mathbb{I}(i) = \begin{cases}
0, \quad p_i = p_{i+1} \\
1, \quad p_i \neq p_{i+1}
\end{cases}
$$

记 $\textit{neg}(i, j)$ 表示 $p_i, \cdots, p_j$ 相邻两项不等的次数，即：

$$
\textit{neg}(i, j) = \sum_{k=i}^{j-1} \mathbb{I}(k)
$$

这样我们可以用 $\textit{neg}(i, j) + 2$ 方便地求出**一次性**运送第 $i$ 个到第 $j$ 个箱子需要的行程次数，这里的 $+2$ 表示来回需要的 $2$ 次。

为了便于快速计算 $\textit{neg}(i, j)$，我们也可以使用前缀和的方式进行存储。记 $\textit{neg}_i = \textit{neg}(1, i)$ 表示前缀和，那么 $\textit{neg}(i, j) = \textit{neg}_j - \textit{neg}_{i}$ 可以在 $O(1)$ 的时间求出。

> 注意：这里是 $\textit{neg}_j - \textit{neg}_{i}$ 而不是 $\textit{neg}_j - \textit{neg}_{i-1}$，读者可以思考一下其原因。

**思路与算法**

我们可以使用动态规划解决本题。

记 $f_i$ 表示**运送前 $i$ 个箱子需要的最少行程次数**，这里的「前 $i$ 个箱子」指的是目的地为 $p_1, \cdots, p_i$ 的 $i$ 个箱子。我们可以写出状态转移方程：

$$
\begin{aligned}
& f_i = \min \big\{  f_j + \textit{neg}(j+1,i) + 2 \big\} \\\\
\text{subject to} \quad &
\begin{cases} 0 \leq j < i \\
i-j \leq \textit{maxBoxes} \\
W_i-W_j \leq \textit{maxWeight}
\end{cases}
\end{aligned}
$$

即枚举上一次运送的最后一个箱子为 $j$（这里的 $j$ 可以为 $0$，表示这一次是第一次运送箱子），那么这一次运送的箱子为 $[j+1, i]$。箱子的数量不超过 $\textit{maxBoxes}$，重量之和不能超过 $\textit{maxWeight}$。运送的行程次数即为 $p_{j+1}, \cdots, p_i$ 相邻两项不等的次数 $\textit{neg}(j+1, i)$ 加上来回的 $2$ 次。

边界条件为 $f_0 = 0$，最终答案即为 $f_n$。

**优化**

然而上述动态规划的时间复杂度为 $O(n^2)$，我们需要进行优化。我们将 $\textit{neg}(j+1, i)$ 拆分成两个前缀和的差，即：

$$
\textit{neg}(j+1, i) = \textit{neg}_i - \textit{neg}_{j+1}
$$

带入原状态转移方程：

$$
\begin{aligned}
f_i &= \min \big\{  f_j + \textit{neg}(j+1,i) + 2 \big\} \\
&= \min \big\{  f_j + \textit{neg}_i - \textit{neg}_{j+1} + 2 \big\} \\
&= \min \big\{  f_j - \textit{neg}_{j+1} \big\} + \textit{neg}_i + 2
\end{aligned}
$$

由于 $\textit{neg}_i$ 和 $2$ 都是与 $j$ 无关的项，因此可以从 $\min\{ \cdot \}$ 中提取出来。

记 $g_j = f_j - \textit{neg}_{j+1}$，状态转移方程即为：

$$
f_i = \min \{ g_j \} + \textit{neg}(i) + 2
$$

如果只有 $0 \leq j < i$ 的限制条件，那么我们实时维护 $g_j$ 的最小值进行 $O(1)$ 的转移即可。但现在有 $i-j \leq \textit{maxBoxes}$ 和 $W_i-W_j \leq \textit{maxWeight}$ 这两个额外的限制条件，最小的 $g_j$ 对应的 $j$ 不一定满足限制。

我们可以将两个额外的限制看成：

$$
\begin{cases}
j \geq i - \textit{maxBoxes} \\
W_j \geq W_i - \textit{maxWeight} 
\end{cases}
$$

注意到两个不等式右侧的值都是随着 $i$ 的递增而递增的，因此如果当 $i=i_0$ 时，某个 $j_0$ 不满足不等式限制，那么当 $i>i_0$ 时，$j_0$ 将永远不可能重新满足条件。

因此我们就可以使用单调队列对动态规划进行优化，对于两个可以进行转移的 $g_{j_0}$ 和 $g_{j_1}$，在 $j_0 < j_1$ 的前提下：

- 如果 $g_{j_0} < g_{j_1}$，那么我们需要将 $g_{j_0}$ 和 $g_{j_1}$ 都保留下来，这是因为当 $j_0$ 还满足限制时，$g_{j_0}$ 比 $g_{j_1}$ 更优；而当 $j_0$ 不满足限制后，$g_{j_1}$ 可能会代替 $g_{j_0}$，成为新的最优转移；

- 如果 $g_{j_0} \geq g_{j_1}$，那么我们只需要将 $g_{j_1}$ 保留下来即可。这是因为当 $j_0$ 还满足限制时，选择 $g_{j_1}$ 并不会更差，并且 $j_1$ 可以满足限制的时间（即随着 $i$ 的递增）更久。

因此，我们使用一个队列存储所有需要被保留的 $g_j$（存储下标 $j$ 即可），从队首到队尾，$j$ 的值单调递增，$g_j$ 的值也单调递增。在进行状态转移求解 $f_i$ 时：

- 首先我们不断从队首弹出元素，直到队首的 $j$ 是满足额外限制的；

- 使用队首的 $j$ 进行转移，得到 $f_i$；

- 计算出 $g_i$，并不断从队尾弹出元素，直到队列为空或者队尾元素对应的 $g$ 值严格小与 $g_i$；

- 将 $g_i$ 放入队列。

状态转移需要的时间为 $O(1)$。而对于单调队列的部分，每一个 $g_i$ 会被加入队列恰好一次，并且被从队列中弹出最多一次，因此均摊时间为 $O(1)$。这样一来，动态规划的时间复杂度降低为 $O(n)$。

**代码**

代码中很多变量都是为了和文字部分保持一致而添加的，如果熟练了掌握了本题使用的方法，可以优化掉一些变量。

```C++ [sol1-C++]
class Solution {
public:
    int boxDelivering(vector<vector<int>>& boxes, int portsCount, int maxBoxes, int maxWeight) {
        int n = boxes.size();
        vector<int> p(n + 1), w(n + 1), neg(n + 1);
        vector<long long> W(n + 1);
        for (int i = 1; i <= n; ++i) {
            p[i] = boxes[i - 1][0];
            w[i] = boxes[i - 1][1];
            if (i > 1) {
                neg[i] = neg[i - 1] + (p[i - 1] != p[i]);
            }
            W[i] = W[i - 1] + w[i];
        }
        
        deque<int> opt = {0};
        vector<int> f(n + 1), g(n + 1);
        
        for (int i = 1; i <= n; ++i) {
            while (i - opt.front() > maxBoxes || W[i] - W[opt.front()] > maxWeight) {
                opt.pop_front();
            }
            
            f[i] = g[opt.front()] + neg[i] + 2;
            
            if (i != n) {
                g[i] = f[i] - neg[i + 1];
                while (!opt.empty() && g[i] <= g[opt.back()]) {
                    opt.pop_back();
                }
                opt.push_back(i);
            }
        }
        
        return f[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int boxDelivering(int[][] boxes, int portsCount, int maxBoxes, int maxWeight) {
        int n = boxes.length;
        int[] p = new int[n + 1];
        int[] w = new int[n + 1];
        int[] neg = new int[n + 1];
        long[] W = new long[n + 1];
        for (int i = 1; i <= n; ++i) {
            p[i] = boxes[i - 1][0];
            w[i] = boxes[i - 1][1];
            if (i > 1) {
                neg[i] = neg[i - 1] + (p[i - 1] != p[i] ? 1 : 0);
            }
            W[i] = W[i - 1] + w[i];
        }

        Deque<Integer> opt = new ArrayDeque<Integer>();
        opt.offerLast(0);
        int[] f = new int[n + 1];
        int[] g = new int[n + 1];

        for (int i = 1; i <= n; ++i) {
            while (i - opt.peekFirst() > maxBoxes || W[i] - W[opt.peekFirst()] > maxWeight) {
                opt.pollFirst();
            }

            f[i] = g[opt.peekFirst()] + neg[i] + 2;

            if (i != n) {
                g[i] = f[i] - neg[i + 1];
                while (!opt.isEmpty() && g[i] <= g[opt.peekLast()]) {
                    opt.pollLast();
                }
                opt.offerLast(i);
            }
        }

        return f[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def boxDelivering(self, boxes: List[List[int]], portsCount: int, maxBoxes: int, maxWeight: int) -> int:
        def getArray() -> List[int]:
            return [0] * (n + 1)
        
        n = len(boxes)
        p, w, neg, W = getArray(), getArray(), getArray(), getArray()

        for i in range(1, n + 1):
            p[i], w[i] = boxes[i - 1]
            if i > 1:
                neg[i] = neg[i - 1] + (p[i - 1] != p[i])
            W[i] = W[i - 1] + w[i]
        
        opt = deque([0])
        f, g = getArray(), getArray()
        
        for i in range(1, n + 1):
            while i - opt[0] > maxBoxes or W[i] - W[opt[0]] > maxWeight:
                opt.popleft()
            
            f[i] = g[opt[0]] + neg[i] + 2
            
            if i != n:
                g[i] = f[i] - neg[i + 1]
                while opt and g[i] <= g[opt[-1]]:
                    opt.pop()
                opt.append(i)
        
        return f[n]
```

```C [sol1-C]
typedef struct {
    int *elements;
    int rear, front;
    int capacity;
} MyCircularDeque;

MyCircularDeque* myCircularDequeCreate(int k) {
    MyCircularDeque *obj = (MyCircularDeque *)malloc(sizeof(MyCircularDeque));
    obj->capacity = k + 1;
    obj->rear = obj->front = 0;
    obj->elements = (int *)malloc(sizeof(int) * obj->capacity);
    return obj;
}

bool myCircularDequeInsertFront(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->front = (obj->front - 1 + obj->capacity) % obj->capacity;
    obj->elements[obj->front] = value;
    return true;
}

bool myCircularDequeInsertLast(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->elements[obj->rear] = value;
    obj->rear = (obj->rear + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->front = (obj->front + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteLast(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->rear = (obj->rear - 1 + obj->capacity) % obj->capacity;
    return true;
}

int myCircularDequeGetFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[obj->front];
}

int myCircularDequeGetRear(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[(obj->rear - 1 + obj->capacity) % obj->capacity];
}

bool myCircularDequeIsEmpty(MyCircularDeque* obj) {
    return obj->rear == obj->front;
}

bool myCircularDequeIsFull(MyCircularDeque* obj) {
    return (obj->rear + 1) % obj->capacity == obj->front;
}

void myCircularDequeFree(MyCircularDeque* obj) {
    free(obj->elements);
    free(obj);
}

int boxDelivering(int** boxes, int boxesSize, int* boxesColSize, int portsCount, int maxBoxes, int maxWeight) {
    int n = boxesSize;
    int p[n + 1], w[n + 1], neg[n + 1];
    long long W[n + 1];
    memset(neg, 0, sizeof(neg));
    memset(W, 0, sizeof(W));
    for (int i = 1; i <= n; ++i) {
        p[i] = boxes[i - 1][0];
        w[i] = boxes[i - 1][1];
        if (i > 1) {
            neg[i] = neg[i - 1] + (p[i - 1] != p[i]);
        }
        W[i] = W[i - 1] + w[i];
    }
    
    int f[n + 1], g[n + 1];    
    memset(f, 0, sizeof(f));
    memset(g, 0, sizeof(g));
    MyCircularDeque *opt =  myCircularDequeCreate(n + 1);
    myCircularDequeInsertLast(opt, 0);
    for (int i = 1; i <= n; ++i) {
        while (i - myCircularDequeGetFront(opt) > maxBoxes || 
               W[i] - W[myCircularDequeGetFront(opt)] > maxWeight) {
            myCircularDequeDeleteFront(opt);
        }
        
        f[i] = g[myCircularDequeGetFront(opt)] + neg[i] + 2;
        if (i != n) {
            g[i] = f[i] - neg[i + 1];
            while (!myCircularDequeIsEmpty(opt) && g[i] <= g[myCircularDequeGetRear(opt)]) {
                myCircularDequeDeleteLast(opt);
            }
            myCircularDequeInsertLast(opt, i);
        }
    }
    myCircularDequeFree(opt);
    return f[n];
}
```

```JavaScript [sol1-JavaScript]
var boxDelivering = function(boxes, portsCount, maxBoxes, maxWeight) {
    const n = boxes.length;
    const p = new Array(n + 1).fill(0);
    const w = new Array(n + 1).fill(0);
    const neg = new Array(n + 1).fill(0);
    const W = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; ++i) {
        p[i] = boxes[i - 1][0];
        w[i] = boxes[i - 1][1];
        if (i > 1) {
            neg[i] = neg[i - 1] + (p[i - 1] != p[i] ? 1 : 0);
        }
        W[i] = W[i - 1] + w[i];
    }

    const opt = [0];
    const f = new Array(n + 1).fill(0);
    const g = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; ++i) {
        while (i - opt[0] > maxBoxes || W[i] - W[opt[0]] > maxWeight) {
            opt.shift();
        }

        f[i] = g[opt[0]] + neg[i] + 2;

        if (i !== n) {
            g[i] = f[i] - neg[i + 1];
            while (opt.length && g[i] <= g[opt[opt.length - 1]]) {
                opt.pop();
            }
            opt.push(i);
        }
    }

    return f[n];
};
```

```go [sol1-Golang]
func boxDelivering(boxes [][]int, portsCount int, maxBoxes int, maxWeight int) int {
    n := len(boxes)
    p := make([]int, n+1)
    w := make([]int, n+1)
    neg := make([]int, n+1)
    W := make([]int, n+1)
    for i := 1; i <= n; i++ {
        p[i] = boxes[i-1][0]
        w[i] = boxes[i-1][1]
        if i > 1 {
            neg[i] = neg[i-1]
            if p[i-1] != p[i] {
                neg[i]++
            }
        }
        W[i] = W[i-1] + w[i]
    }

    opt := []int{0}
    f := make([]int, n+1)
    g := make([]int, n+1)

    for i := 1; i <= n; i++ {
        for i-opt[0] > maxBoxes || W[i]-W[opt[0]] > maxWeight {
            opt = opt[1:]
        }

        f[i] = g[opt[0]] + neg[i] + 2

        if i != n {
            g[i] = f[i] - neg[i+1]
            for len(opt) > 0 && g[i] <= g[opt[len(opt)-1]] {
                opt = opt[:len(opt)-1]
            }
            opt = append(opt, i)
        }
    }

    return f[n]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{boxes}$ 的长度。

- 空间复杂度：$O(n)$，即为动态规划的数组 $f$ 和 $g$，单调队列以及前缀和数组需要使用的空间。