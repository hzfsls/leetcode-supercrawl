## [786.第 K 个最小的素数分数 中文官方题解](https://leetcode.cn/problems/k-th-smallest-prime-fraction/solutions/100000/di-k-ge-zui-xiao-de-su-shu-fen-shu-by-le-argw)
#### 方法一：自定义排序

**思路与算法**

记数组 $\textit{arr}$ 的长度为 $n$。我们可以将全部的 $\dfrac{n(n-1)}{2}$ 个分数放入数组中进行自定义排序，规则为将这些分数按照升序进行排序。

在排序完成后，我们就可以得到第 $k$ 个最小的素数分数。

**细节**

当我们比较两个分数 $\dfrac{a}{b}$ 和 $\dfrac{c}{d}$ 时，我们可以直接对它们的值进行比较，但这会产生浮点数的计算，降低程序的效率，并且可能会引入浮点数误差。一种可行的替代方法是用：

$$
a \times d < b \times c
$$

来替代 $\dfrac{a}{b} < \dfrac{c}{d}$ 的判断，二者是等价的。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> kthSmallestPrimeFraction(vector<int>& arr, int k) {
        int n = arr.size();
        vector<pair<int, int>> frac;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                frac.emplace_back(arr[i], arr[j]);
            }
        }
        sort(frac.begin(), frac.end(), [&](const auto& x, const auto& y) {
            return x.first * y.second < x.second * y.first;
        });
        return {frac[k - 1].first, frac[k - 1].second};
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] kthSmallestPrimeFraction(int[] arr, int k) {
        int n = arr.length;
        List<int[]> frac = new ArrayList<int[]>();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                frac.add(new int[]{arr[i], arr[j]});
            }
        }
        Collections.sort(frac, (x, y) -> x[0] * y[1] - y[0] * x[1]);
        return frac.get(k - 1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] KthSmallestPrimeFraction(int[] arr, int k) {
        int n = arr.Length;
        List<int[]> frac = new List<int[]>();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                frac.Add(new int[]{arr[i], arr[j]});
            }
        }
        frac.Sort((x, y) => x[0] * y[1] - y[0] * x[1]);
        return frac[k - 1];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kthSmallestPrimeFraction(self, arr: List[int], k: int) -> List[int]:
        def cmp(x: Tuple[int, int], y: Tuple[int, int]) -> int:
            return -1 if x[0] * y[1] < x[1] * y[0] else 1
        
        n = len(arr)
        frac = list()
        for i in range(n):
            for j in range(i + 1, n):
                frac.append((arr[i], arr[j]))
        
        frac.sort(key=cmp_to_key(cmp))
        return list(frac[k - 1])
```

```go [sol1-Golang]
func kthSmallestPrimeFraction(arr []int, k int) []int {
    n := len(arr)
    type pair struct{ x, y int }
    frac := make([]pair, 0, n*(n-1)/2)
    for i, x := range arr {
        for _, y := range arr[i+1:] {
            frac = append(frac, pair{x, y})
        }
    }
    sort.Slice(frac, func(i, j int) bool {
        a, b := frac[i], frac[j]
        return a.x*b.y < a.y*b.x
    })
    return []int{frac[k-1].x, frac[k-1].y}
}
```

```JavaScript [sol1-JavaScript]
var kthSmallestPrimeFraction = function(arr, k) {
    const n = arr.length;
    const frac = [];
    for (let i = 0; i < n; ++i) {
        for (let j = i + 1; j < n; ++j) {
            frac.push([arr[i], arr[j]]);
        }
    }
    frac.sort((x, y) => x[0] * y[1] - y[0] * x[1]);
    return frac[k - 1];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2 \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。素数分数一共有 $\dfrac{n(n-1)}{2} = O(n^2)$ 个，因此排序需要的时间为 $O(n^2 \log n)$。

- 空间复杂度：$O(n^2)$，即为存储所有素数分数需要的空间。

#### 方法二：优先队列

**思路与算法**

当分母为给定的 $\textit{arr}[j]$ 时，分子可以在 $\textit{arr}[0], \cdots, \textit{arr}[j-1]$ 中进行选择。由于数组 $\textit{arr}$ 是严格递增的，那么记分子为 $\textit{arr}[i] ~ (0 \leq i < j)$，随着 $i$ 的增加，分数的值也是严格递增的。

因此我们可以将每个分母 $\textit{arr}[j]$ 看成一个长度为 $j$ 的列表，它包含了：

$$
\frac{\textit{arr}[0]}{\textit{arr}[j]}, \frac{\textit{arr}[1]}{\textit{arr}[j]}, \cdots, \frac{arr[j-1]}{\textit{arr}[j]}
$$

这些分数，并且它们的值是严格递增的。我们的目标是找出这 $n-1$ 个列表（$\textit{arr}[0]$ 的列表为空，我们可以直接忽略）中第 $k$ 小的素数分数，这就提示我们参考[「23. 合并 K 个升序链表」](https://leetcode-cn.com/problems/merge-k-sorted-lists/)中的方法，使用优先队列来得到答案。

初始时，优先队列中存储了 $n-1$ 个分数 $\dfrac{\textit{arr}[0]}{\textit{arr}[1]}, \cdots, \dfrac{\textit{arr}[0]}{\textit{arr}[n-1]}$。在求解答案的过程中，我们每次从优先队列中取出一个最小的分数，记为 $\dfrac{\textit{arr}[i]}{\textit{arr}[j]}$。如果 $i + 1 < j$，我们将一个新的分数 $\dfrac{\textit{arr}[i+1]}{\textit{arr}[j]}$ 放入优先队列中。这样一来，当我们进行第 $k$ 次「取出」操作时，得到的分数就是第 $k$ 小的素数分数。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> kthSmallestPrimeFraction(vector<int>& arr, int k) {
        int n = arr.size();
        auto cmp = [&](const pair<int, int>& x, const pair<int, int>& y) {
            return arr[x.first] * arr[y.second] > arr[x.second] * arr[y.first];
        };
        priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(cmp)> q(cmp);
        for (int j = 1; j < n; ++j) {
            q.emplace(0, j);
        }
        for (int _ = 1; _ < k; ++_) {
            auto [i, j] = q.top();
            q.pop();
            if (i + 1 < j) {
                q.emplace(i + 1, j);
            }
        }
        return {arr[q.top().first], arr[q.top().second]};
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] kthSmallestPrimeFraction(int[] arr, int k) {
        int n = arr.length;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((x, y) -> arr[x[0]] * arr[y[1]] - arr[y[0]] * arr[x[1]]);
        for (int j = 1; j < n; ++j) {
            pq.offer(new int[]{0, j});
        }
        for (int i = 1; i < k; ++i) {
            int[] frac = pq.poll();
            int x = frac[0], y = frac[1];
            if (x + 1 < y) {
                pq.offer(new int[]{x + 1, y});
            }
        }
        return new int[]{arr[pq.peek()[0]], arr[pq.peek()[1]]};
    }
}
```

```Python [sol2-Python3]
class Frac:
    def __init__(self, idx: int, idy: int, x: int, y: int) -> None:
        self.idx = idx
        self.idy = idy
        self.x = x
        self.y = y

    def __lt__(self, other: "Frac") -> bool:
        return self.x * other.y < self.y * other.x


class Solution:
    def kthSmallestPrimeFraction(self, arr: List[int], k: int) -> List[int]:
        n = len(arr)
        q = [Frac(0, i, arr[0], arr[i]) for i in range(1, n)]
        heapq.heapify(q)

        for _ in range(k - 1):
            frac = heapq.heappop(q)
            i, j = frac.idx, frac.idy
            if i + 1 < j:
                heapq.heappush(q, Frac(i + 1, j, arr[i + 1], arr[j]))
        
        return [q[0].x, q[0].y]
```

```go [sol2-Golang]
func kthSmallestPrimeFraction(arr []int, k int) []int {
    n := len(arr)
    h := make(hp, n-1)
    for j := 1; j < n; j++ {
        h[j-1] = frac{arr[0], arr[j], 0, j}
    }
    heap.Init(&h)
    for loop := k - 1; loop > 0; loop-- {
        f := heap.Pop(&h).(frac)
        if f.i+1 < f.j {
            heap.Push(&h, frac{arr[f.i+1], f.y, f.i + 1, f.j})
        }
    }
    return []int{h[0].x, h[0].y}
}

type frac struct{ x, y, i, j int }
type hp []frac
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].x*h[j].y < h[i].y*h[j].x }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(frac)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：$O(k \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。优先队列的单次操作时间复杂度为 $O(\log n)$，一共需要进行 $O(k)$ 次操作。

- 空间复杂度：$O(n)$，即为优先队列需要使用的空间。

#### 方法三：二分查找 + 双指针

**思路与算法**

我们可以随便猜测一个实数 $\alpha$，如果恰好有 $k$ 个素数分数小于 $\alpha$，那么这 $k$ 个素数分数中最大的那个就是第 $k$ 个最小的素数分数。

对于 $\alpha$，我们如何求出有多少个小于 $\alpha$ 的素数分数呢？我们可以使用双指针来求出答案：

- 我们使用一个指针 $j$ 指向分母，这个指针每次会向右移动一个位置，表示枚举不同的分母；

- 我们再使用一个指针 $i$ 指向分子，这个指针会不断向右移动，并且保证 $\dfrac{\textit{arr}[i]}{\textit{arr}[j]} < \alpha$ 一直成立。当指针 $i$ 无法移动时，我们就可以知道 $\textit{arr}[0], \cdots, \textit{arr}[i]$ 都可以作为分子，但 $\textit{arr}[i+1]$ 及以后的元素都不可以，即分母为 $\textit{arr}[j]$ 并且小于 $\alpha$ 的素数分数有 $i+1$ 个。

- 在 $j$ 向右移动的过程中，我们把每一个 $j$ 对应的 $i+1$ 都加入答案。这样在双指针的过程完成后，我们就可以得到有多少个小于 $\alpha$ 的素数分数了。

如果我们得到的答案恰好等于 $k$，那么我们再进行一遍上面的过程，求出所有 $\dfrac{\textit{arr}[i]}{\textit{arr}[j]}$ 中的最大值即为第 $k$ 个最小的素数分数。但如果答案小于 $k$，这说明我们猜测的 $\alpha$ 太小了，我们需要增加它的值；如果答案大于 $k$，这说明我们猜测的 $\alpha$ 太大了，我们需要减少它的值。

这就提示我们使用二分查找来找到合适的 $\alpha$。二分查找的上界为 $1$，下界为 $0$。在二分查找的每一步中，我们取上下界区间的中点作为 $\alpha$，并计算小于 $\alpha$ 的素数分数的个数，并根据这个值来调整二分查找的上界或下界。

**细节**

由于我们是在实数范围内进行二分查找，那么最坏情况下需要进行多少步查找呢？

可以发现，数组 $\textit{arr}$ 中元素的最大值为 $3 \times 10^4$，即任意两个素数分数的差值不会小于 $\dfrac{1}{(3 \times 10^4)^2} = \dfrac{1}{9 \times 10^8}$。假设第 $k$ 个最小的素数分数为 $\beta_k$，第 $k+1$ 个为 $\beta_{k+1}$，那么有：

$$
\beta_{k+1} - \beta_k > \dfrac{1}{9 \times 10^8}
$$

只要我们的二分查找选取的 $\alpha$ 落在 $(\beta_k, \beta_{k+1}]$ 的区间内，那么就可以结束二分查找并返回答案。而二分查找的初始区间为 $[0, 1]$，每一步区间的长度会减少一半，因此在进行第 $\lceil \log (9 \times 10^8) \rceil = 30$ 次二分查找后，区间的长度小于 $\dfrac{1}{9 \times 10^8}$，这说明左边界和右边界中至少有一个落在 $(\beta_k, \beta_{k+1}]$ 区间内。不失一般性设落在区间内的是左边界，由于左边界的初始值 $0 \notin (\beta_k, \beta_{k+1}]$，说明左边界的值在之前的某一步二分查找时被修改，即那一次二分查找选取的 $\alpha$ 就落在 $(\beta_k, \beta_{k+1}]$ 内。

这就说明我们最多只需要进行 $30$ 次二分查找。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    vector<int> kthSmallestPrimeFraction(vector<int>& arr, int k) {
        int n = arr.size();
        double left = 0.0, right = 1.0;
        while (true) {
            double mid = (left + right) / 2;
            int i = -1, count = 0;
            // 记录最大的分数
            int x = 0, y = 1;
            
            for (int j = 1; j < n; ++j) {
                while ((double)arr[i + 1] / arr[j] < mid) {
                    ++i;
                    if (arr[i] * y > arr[j] * x) {
                        x = arr[i];
                        y = arr[j];
                    }
                }
                count += i + 1;
            }

            if (count == k) {
                return {x, y};
            }
            if (count < k) {
                left = mid;
            }
            else {
                right = mid;
            }
        }
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] kthSmallestPrimeFraction(int[] arr, int k) {
        int n = arr.length;
        double left = 0.0, right = 1.0;
        while (true) {
            double mid = (left + right) / 2;
            int i = -1, count = 0;
            // 记录最大的分数
            int x = 0, y = 1;
            
            for (int j = 1; j < n; ++j) {
                while ((double) arr[i + 1] / arr[j] < mid) {
                    ++i;
                    if (arr[i] * y > arr[j] * x) {
                        x = arr[i];
                        y = arr[j];
                    }
                }
                count += i + 1;
            }

            if (count == k) {
                return new int[]{x, y};
            }
            if (count < k) {
                left = mid;
            } else {
                right = mid;
            }
        }
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int[] KthSmallestPrimeFraction(int[] arr, int k) {
        int n = arr.Length;
        double left = 0.0, right = 1.0;
        while (true) {
            double mid = (left + right) / 2;
            int i = -1, count = 0;
            // 记录最大的分数
            int x = 0, y = 1;
            
            for (int j = 1; j < n; ++j) {
                while ((double) arr[i + 1] / arr[j] < mid) {
                    ++i;
                    if (arr[i] * y > arr[j] * x) {
                        x = arr[i];
                        y = arr[j];
                    }
                }
                count += i + 1;
            }

            if (count == k) {
                return new int[]{x, y};
            }
            if (count < k) {
                left = mid;
            } else {
                right = mid;
            }
        }
    }
}
```

```Python [sol3-Python3]
class Solution:
    def kthSmallestPrimeFraction(self, arr: List[int], k: int) -> List[int]:
        n = len(arr)
        left, right = 0.0, 1.0

        while True:
            mid = (left + right) / 2
            i, count = -1, 0
            # 记录最大的分数
            x, y = 0, 1
            
            for j in range(1, n):
                while arr[i + 1] / arr[j] < mid:
                    i += 1
                    if arr[i] * y > arr[j] * x:
                        x, y = arr[i], arr[j]
                count += i + 1

            if count == k:
                return [x, y]
            
            if count < k:
                left = mid
            else:
                right = mid
```

```go [sol3-Golang]
func kthSmallestPrimeFraction(arr []int, k int) []int {
    n := len(arr)
    left, right := 0., 1.
    for {
        mid := (left + right) / 2
        i, count := -1, 0
        // 记录最大的分数
        x, y := 0, 1

        for j := 1; j < n; j++ {
            for float64(arr[i+1])/float64(arr[j]) < mid {
                i++
                if arr[i]*y > arr[j]*x {
                    x, y = arr[i], arr[j]
                }
            }
            count += i + 1
        }

        if count == k {
            return []int{x, y}
        }
        if count < k {
            left = mid
        } else {
            right = mid
        }
    }
}
```

```JavaScript [sol3-JavaScript]
var kthSmallestPrimeFraction = function(arr, k) {
    const n = arr.length;
    let left = 0.0, right = 1.0;
    while (true) {
        const mid = (left + right) / 2;
        let i = -1, count = 0;
        // 记录最大的分数
        let x = 0, y = 1;
        
        for (let j = 1; j < n; ++j) {
            while (arr[i + 1] / arr[j] < mid) {
                ++i;
                if (arr[i] * y > arr[j] * x) {
                    x = arr[i];
                    y = arr[j];
                }
            }
            count += i + 1;
        }

        if (count === k) {
            return [x, y];
        }
        if (count < k) {
            left = mid;
        } else {
            right = mid;
        }
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$C$ 是数组 $\textit{arr}$ 中元素的上界。二分查找需要进行 $\lceil \log C^2 \rceil = O(\log C)$ 次，每一步需要 $O(n)$ 的时间得到小于 $\alpha$ 的素数分数的个数。

- 空间复杂度：O(1)。