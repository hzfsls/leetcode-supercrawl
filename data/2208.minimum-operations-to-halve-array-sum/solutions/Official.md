#### 方法一：贪心 + 优先队列

基于贪心的思想，将数组和减半的操作次数最小化的做法为：每次操作都选择当前数组的最大值进行减半操作。

> 证明：假设某一种做法（该做法操作次数最小）的某一步操作没有选择对最大值 $x$ 进行操作，而是选择对 $y$ 进行操作，那么有两种情况：
> 1.后续的操作都没有选择对 $x$ 进行操作，那么我们将后续（包括当前操作）所有对 $y$ 的操作替换成对 $x$ 的操作，操作次数不变；
> 2.后续的某一步操作选择对 $x$ 进行操作，那么我们可以交换这两步操作，操作次数不变。

将数组所有元素都放入一个浮点数优先队列（最大堆）中，使用 $\textit{sum}$ 记录初始数组和，$\textit{sum}_2$ 记录减少和，当 $\textit{sum}_2 \lt \dfrac{\textit{sum}}{2}$ 时，重复以下步骤：

1. 从优先队列中取出最大元素 $x$；

2. 令 $\textit{sum}_2 = \textit{sum}_2 + \dfrac{x}{2}$；

3. 将 $\dfrac{x}{2}$ 放入优先队列中。

返回执行步骤次数即可。

```C++ [sol1-C++]
class Solution {
public:
    int halveArray(vector<int>& nums) {
        priority_queue<double> pq(nums.begin(), nums.end());
        int res = 0;
        double sum = accumulate(nums.begin(), nums.end(), 0.0), sum2 = 0.0;
        while (sum2 < sum / 2) {
            double x = pq.top();
            pq.pop();
            sum2 += x / 2;
            pq.push(x / 2);
            res++;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int halveArray(int[] nums) {
        PriorityQueue<Double> pq = new PriorityQueue<Double>((a, b) -> b.compareTo(a));
        for (int num : nums) {
            pq.offer((double) num);
        }
        int res = 0;
        double sum = 0;
        for (int num : nums) {
            sum += num;
        }
        double sum2 = 0.0;
        while (sum2 < sum / 2) {
            double x = pq.poll();
            sum2 += x / 2;
            pq.offer(x / 2);
            res++;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int HalveArray(int[] nums) {
        PriorityQueue<double, double> pq = new PriorityQueue<double, double>();
        foreach (int num in nums) {
            pq.Enqueue(num, -num);
        }
        int res = 0;
        double sum = 0;
        foreach (int num in nums) {
            sum += num;
        }
        double sum2 = 0.0;
        while (sum2 < sum / 2) {
            double x = pq.Dequeue();
            sum2 += x / 2;
            pq.Enqueue(x / 2, -x / 2);
            res++;
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def halveArray(self, nums: List[int]) -> int:
        pq = []
        for num in nums:
            heappush(pq, -num)
        res = 0
        sum1 = sum(nums)
        sum2 = 0
        while sum2 < sum1 / 2:
            x = -heappop(pq)
            sum2 += x / 2
            heappush(pq, -(x / 2))
            res += 1
        return res

```

```JavaScript [sol1-JavaScript]
var halveArray = function(nums) {
    const pq = new MaxPriorityQueue();
    for (const num of nums) {
        pq.enqueue(num);
    }
    let res = 0;
    let sum1 = nums.reduce((acc, curr) => acc + curr, 0);
    let sum2 = 0;
    while (sum2 < sum1 / 2) {
        const x = pq.dequeue().element;
        sum2 += x / 2;
        pq.enqueue(x / 2);
        res++;
    }
    return res;
};
```

```Golang [sol1-Golang]
type PriorityQueue []float64

func (pq PriorityQueue) Len() int {
    return len(pq)
}

func (pq PriorityQueue) Less(i, j int) bool {
    return pq[i] > pq[j]
}

func (pq PriorityQueue) Swap(i, j int) {
    pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PriorityQueue) Push(x any) {
    *pq = append(*pq, x.(float64))
}

func (pq *PriorityQueue) Pop() any {
    old, n := *pq, len(*pq)
    x := old[n - 1]
    *pq = old[0 : n-1]
    return x
}

func halveArray(nums []int) int {
    pq := &PriorityQueue{}
    sum, sum2 := 0.0, 0.0
    for _, x := range nums {
        heap.Push(pq, float64(x))
        sum += float64(x)
    }
    res := 0
    for sum2 < sum / 2 {
        x := heap.Pop(pq).(float64)
        sum2 += x / 2
        heap.Push(pq, x / 2)
        res++
    }
    return res
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。将数组和减半最多不超过 $n$ 次操作，每次操作需要 $O(\log n)$。

+ 空间复杂度：$O(n)$。保存优先队列需要 $O(n)$ 的空间。