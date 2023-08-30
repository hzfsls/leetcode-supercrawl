#### 方法一：堆（优先队列）

**思路**

首先我们看一个例子，假设数组 `sticks = [a, b, c, d, e]`，按照顺序连接其中的木材，且每次连接后的木材放在最后。
第一次连接：`sum = a + b`，`sticks = [c, d, e, a+b]`。
第二次连接：`sum = a + b + c + d`，`sticks = [e, a+b, c+d]`。
第三次连接：`sum = a + b + c + d + e + a + b`，`sticks = [c+d, a+b+e]`。
第四次连接：`sum = a + b + c + d + e + a + b + c + d + a + b + e`，`sticks = [a+b+c+d+e]`。
将相同的项合并后 `sum = 3a + 3b + 2c + 2d + 2e`，其中 `a` 和 `b` 被计算的次数最多，所以只有当 `a` 和 `b` 最小的时候，可以保证 `sum` 的值最小。

根据上面的想法要想让费用最低，那么越是短的棒材就要被使用越多次。所以我们可以在每次连接棒材的时候选择最短的两个棒材，这样可以使得短的棒子使用更多次并且本次合并的费用最少，从而使得总的费用最少。

我们可以使用堆来完成我们的操作。每次从堆中取出最小的两个棒子，计算这两个棒子的合并的费用。累加到总费用中并放到堆中。重复这样的操作直到堆的大小为 1。

**代码**

```Golang [sol1-Golang]
func connectSticks(sticks []int) int {
    h := IntHeap(sticks)
    heap.Init(&h)
    sum := 0
    for h.Len() > 1 {
        v1 := heap.Pop(&h).(int)
        v2 := heap.Pop(&h).(int)
        v := v1 + v2
        sum += v
        heap.Push(&h, v)
    }
    return sum
}

type IntHeap []int
func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *IntHeap) Push(x interface{}) {
    *h = append(*h, x.(int))
}
func (h *IntHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}
```

```cpp [sol1-cpp]
class Solution {
public:
    int connectSticks(vector<int>& sticks) {
        priority_queue <int, vector <int>, greater <int> > q;
        for (auto x: sticks) q.push(x);
        int ans = 0;
        while (!q.empty()) {
            if (q.size() == 1) break;
            int x = q.top(); q.pop();
            int y = q.top(); q.pop();
            q.push(x + y);
            ans += x + y;
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为数组 `sticks` 的长度。把一个乱序的数组变成堆结构的数组时间复杂度为 $O(n)$。堆的 `pop` 和 `push` 操作的时间复杂度都为 $O(\log n)$。一共执行了 $(n-1)*2$ 次 `pop` 和 $n-1$ 次 `push`，所以时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为数组 `sticks` 的大小。初始化堆的大小为数组的大小，此后每次 `pop` 两个，`push` 一个，堆的大小越来越小。