#### 方法一：前缀和 + 二分查找

**思路与算法**

设数组 $w$ 的权重之和为 $\textit{total}$。根据题目的要求，我们可以看成将 $[1, \textit{total}]$ 范围内的所有整数分成 $n$ 个部分（其中 $n$ 是数组 $w$ 的长度），第 $i$ 个部分恰好包含 $w[i]$ 个整数，并且这 $n$ 个部分两两的交集为空。随后我们在 $[1, \textit{total}]$ 范围内随机选择一个整数 $x$，如果整数 $x$ 被包含在第 $i$ 个部分内，我们就返回 $i$。

一种较为简单的划分方法是按照从小到大的顺序依次划分每个部分。例如 $w = [3, 1, 2, 4]$ 时，权重之和 $\textit{total} = 10$，那么我们按照 $[1, 3], [4, 4], [5, 6], [7, 10]$ 对 $[1, 10]$ 进行划分，使得它们的长度恰好依次为 $3, 1, 2, 4$。可以发现，每个区间的左边界是在它之前出现的所有元素的和加上 $1$，右边界是到它为止的所有元素的和。因此，如果我们用 $\textit{pre}[i]$ 表示数组 $w$ 的前缀和：

$$
\textit{pre}[i] = \sum_{k=0}^i w[k]
$$

那么第 $i$ 个区间的左边界就是 $\textit{pre}[i] - w[i] + 1$，右边界就是 $\textit{pre}[i]$。

当划分完成后，假设我们随机到了整数 $x$，我们希望找到满足：

$$
\textit{pre}[i] - w[i] + 1 \leq x \leq \textit{pre}[i]
$$

的 $i$ 并将其作为答案返回。由于 $\textit{pre}[i]$ 是单调递增的，因此我们可以使用二分查找在 $O(\log n)$ 的时间内快速找到 $i$，即找出最小的满足 $x \leq \textit{pre}[i]$ 的下标 $i$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    mt19937 gen;
    uniform_int_distribution<int> dis;
    vector<int> pre;

public:
    Solution(vector<int>& w): gen(random_device{}()), dis(1, accumulate(w.begin(), w.end(), 0)) {
        partial_sum(w.begin(), w.end(), back_inserter(pre));
    }
    
    int pickIndex() {
        int x = dis(gen);
        return lower_bound(pre.begin(), pre.end(), x) - pre.begin();
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] pre;
    int total;
    
    public Solution(int[] w) {
        pre = new int[w.length];
        pre[0] = w[0];
        for (int i = 1; i < w.length; ++i) {
            pre[i] = pre[i - 1] + w[i];
        }
        total = Arrays.stream(w).sum();
    }
    
    public int pickIndex() {
        int x = (int) (Math.random() * total) + 1;
        return binarySearch(x);
    }

    private int binarySearch(int x) {
        int low = 0, high = pre.length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (pre[mid] < x) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[] pre;
    int total;
    Random ran = new Random();

    public Solution(int[] w) {
        pre = new int[w.Length];
        pre[0] = w[0];
        for (int i = 1; i < w.Length; ++i) {
            pre[i] = pre[i - 1] + w[i];
        }
        total = w.Sum();
    }
    
    public int PickIndex() {
        int x = ran.Next(1, total + 1);
        return BinarySearch(x);
    }

    private int BinarySearch(int x) {
        int low = 0, high = pre.Length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (pre[mid] < x) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```Python [sol1-Python3]
class Solution:

    def __init__(self, w: List[int]):
        self.pre = list(accumulate(w))
        self.total = sum(w)

    def pickIndex(self) -> int:
        x = random.randint(1, self.total)
        return bisect_left(self.pre, x)
```

```JavaScript [sol1-JavaScript]
var Solution = function(w) {
    pre = new Array(w.length).fill(0);
    pre[0] = w[0];
    for (let i = 1; i < w.length; ++i) {
        pre[i] = pre[i - 1] + w[i];
    }
    this.total = _.sum(w);
};

Solution.prototype.pickIndex = function() {
    const x = Math.floor((Math.random() * this.total)) + 1;
    const binarySearch = (x) => {
        let low = 0, high = pre.length - 1;
        while (low < high) {
            const mid = Math.floor((high - low) / 2) + low;
            if (pre[mid] < x) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
    return binarySearch(x);
};
```

```go [sol1-Golang]
type Solution struct {
    pre []int
}

func Constructor(w []int) Solution {
    for i := 1; i < len(w); i++ {
        w[i] += w[i-1]
    }
    return Solution{w}
}

func (s *Solution) PickIndex() int {
    x := rand.Intn(s.pre[len(s.pre)-1]) + 1
    return sort.SearchInts(s.pre, x)
}
```

```C [sol1-C]
typedef struct {
    int* pre;
    int preSize;
    int total;
} Solution;

Solution* solutionCreate(int* w, int wSize) {
    Solution* obj = malloc(sizeof(Solution));
    obj->pre = malloc(sizeof(int) * wSize);
    obj->preSize = wSize;
    obj->total = 0;
    for (int i = 0; i < wSize; i++) {
        obj->total += w[i];
        if (i > 0) {
            obj->pre[i] = obj->pre[i - 1] + w[i];
        } else {
            obj->pre[i] = w[i];
        }
    }
    return obj;
}

int binarySearch(Solution* obj, int x) {
    int low = 0, high = obj->preSize - 1;
    while (low < high) {
        int mid = (high - low) / 2 + low;
        if (obj->pre[mid] < x) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

int solutionPickIndex(Solution* obj) {
    int x = rand() % obj->total + 1;
    return binarySearch(obj, x);
}

void solutionFree(Solution* obj) {
    free(obj->pre);
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：初始化的时间复杂度为 $O(n)$，每次选择的时间复杂度为 $O(\log n)$，其中 $n$ 是数组 $w$ 的长度。

- 空间复杂度：$O(n)$，即为前缀和数组 $\textit{pre}$ 需要使用的空间。