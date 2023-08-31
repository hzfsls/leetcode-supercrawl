## [1606.找到处理最多请求的服务器 中文官方题解](https://leetcode.cn/problems/find-servers-that-handled-most-number-of-requests/solutions/100000/zhao-dao-chu-li-zui-duo-qing-qiu-de-fu-w-e0a5)

#### 方法一: 模拟 + 有序集合 + 优先队列

**思路与算法**

将空闲服务器的编号都放入一个有序集合 $\textit{available}$ 中，将正在处理请求的服务器的处理结束时间和编号都放入一个优先队列 $\textit{busy}$ 中，优先队列满足队首的服务器的处理结束时间最小，用一个数组 $\textit{requests}$ 记录对应服务器处理的请求数目。

假设当前到达的请求为第 $i$ 个，如果 $\textit{busy}$ 不为空， 那么我们判断 $\textit{busy}$ 的队首对应的服务器的结束时间是否小于等于当前请求的到达时间 $\textit{arrival}[i]$，如果是，那么我们将它从 $\textit{busy}$ 中移除，并且将该服务器的编号放入 $\textit{available}$ 中，然后再次进行判断。如果 $\textit{available}$ 为空，那么该请求被丢弃；否则查找 $\textit{available}$ 中大于等于 $i \bmod k$ 的第一个元素，如果查找成功，那么将它作为处理请求的服务器，否则将 $\textit{available}$ 中编号最小的服务器作为处理请求的服务器。设处理请求的服务器的编号为 $j$，那么将 $\textit{requests}[j]$ 加 $1$，并且将该服务器从 $\textit{available}$ 移除，然后将服务器 $j$ 放入 $\textit{busy}$ 中，对应的处理结束时间为 $\textit{arrival}[i] + \textit{load}[i]$。

获取 $\textit{requests}$ 的最大值 $\textit{maxRequest}$，遍历 $\textit{requests}$ 数组，对于每个下标 $i$，如果 $\textit{requests}[i] = \textit{maxRequest}$，那么将编号 $i$ 加入结果中。

**代码**

```Python [sol1-Python3]
from sortedcontainers import SortedList

class Solution:
    def busiestServers(self, k: int, arrival: List[int], load: List[int]) -> List[int]:
        available = SortedList(range(k))
        busy = []
        requests = [0] * k
        for i, (start, t) in enumerate(zip(arrival, load)):
            while busy and busy[0][0] <= start:
                available.add(busy[0][1])
                heappop(busy)
            if len(available) == 0:
                continue
            j = available.bisect_left(i % k)
            if j == len(available):
                j = 0
            id = available[j]
            requests[id] += 1
            heappush(busy, (start + t, id))
            available.remove(id)
        maxRequest = max(requests)
        return [i for i, req in enumerate(requests) if req == maxRequest]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> busiestServers(int k, vector<int> &arrival, vector<int> &load) {
        set<int> available;
        for (int i = 0; i < k; i++) {
            available.insert(i);
        }
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> busy;
        vector<int> requests(k);
        for (int i = 0; i < arrival.size(); i++) {
            while (!busy.empty() && busy.top().first <= arrival[i]) {
                available.insert(busy.top().second);
                busy.pop();
            }
            if (available.empty()) {
                continue;
            }
            auto p = available.lower_bound(i % k);
            if (p == available.end()) {
                p = available.begin();
            }
            requests[*p]++;
            busy.emplace(arrival[i] + load[i], *p);
            available.erase(p);
        }
        int maxRequest = *max_element(requests.begin(), requests.end());
        vector<int> ret;
        for (int i = 0; i < k; i++) {
            if (requests[i] == maxRequest) {
                ret.push_back(i);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> busiestServers(int k, int[] arrival, int[] load) {
        TreeSet<Integer> available = new TreeSet<Integer>();
        for (int i = 0; i < k; i++) {
            available.add(i);
        }
        PriorityQueue<int[]> busy = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        int[] requests = new int[k];
        for (int i = 0; i < arrival.length; i++) {
            while (!busy.isEmpty() && busy.peek()[0] <= arrival[i]) {
                available.add(busy.poll()[1]);
            }
            if (available.isEmpty()) {
                continue;
            }
            Integer p = available.ceiling(i % k);
            if (p == null) {
                p = available.first();
            }
            requests[p]++;
            busy.offer(new int[]{arrival[i] + load[i], p});
            available.remove(p);
        }
        int maxRequest = Arrays.stream(requests).max().getAsInt();
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < k; i++) {
            if (requests[i] == maxRequest) {
                ret.add(i);
            }
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func busiestServers(k int, arrival, load []int) (ans []int) {
    available := redblacktree.NewWithIntComparator()
    for i := 0; i < k; i++ {
        available.Put(i, nil)
    }
    busy := hp{}
    requests := make([]int, k)
    maxRequest := 0
    for i, t := range arrival {
        for len(busy) > 0 && busy[0].end <= t {
            available.Put(busy[0].id, nil)
            heap.Pop(&busy)
        }
        if available.Size() == 0 {
            continue
        }
        node, _ := available.Ceiling(i % k)
        if node == nil {
            node = available.Left()
        }
        id := node.Key.(int)
        requests[id]++
        if requests[id] > maxRequest {
            maxRequest = requests[id]
            ans = []int{id}
        } else if requests[id] == maxRequest {
            ans = append(ans, id)
        }
        heap.Push(&busy, pair{t + load[i], id})
        available.Remove(id)
    }
    return
}

type pair struct{ end, id int }
type hp []pair
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].end < h[j].end }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

+ 时间复杂度：$O((k + n) \log k)$，其中 $k$ 为服务器的数目，$n$ 为请求的数目。开始时 $\textit{available}$ 放入所有的服务器的时间复杂度为 $O(k \log k)$；在处理请求时，$\textit{busy}$ 最多执行 $n$ 次放入和移除操作，$\textit{available}$ 最多执行 $n$ 次放入、移除和查找操作， 因此时间复杂度为 $O(n \log k)$；获取最繁忙服务器列表的时间复杂度为 $O(k)$。

+ 空间复杂度：$O(k)$。$\textit{busy}$ 和 $\textit{available}$ 最多放入 $k$ 个元素，需要 $O(k)$ 的空间；$\textit{requests}$ 需要 $O(k)$ 的空间。

#### 方法二：模拟 + 双优先队列

**思路与算法**

方法一中的 $\textit{available}$ 也可以用优先队列实现。

设在第 $i$ 个请求到来时，编号为 $\textit{id}$ 的服务器已经处理完请求，那么将 $\textit{id}$ 从 $\textit{busy}$ 中移除，并放入一个不小于 $i$ 且同余于 $\textit{id}$ 的编号，这样就能在保证 $\textit{available}$ 中，编号小于 $i \bmod k$ 的空闲服务器能排到编号不小于 $i \bmod k$ 的空闲服务器后面。

**代码**

```Python [sol2-Python3]
class Solution:
    def busiestServers(self, k: int, arrival: List[int], load: List[int]) -> List[int]:
        available = list(range(k))
        busy = []
        requests = [0] * k
        for i, (start, t) in enumerate(zip(arrival, load)):
            while busy and busy[0][0] <= start:
                _, id = heappop(busy)
                heappush(available, i + (id - i) % k)  # 利用 Python 负数取模变成同余的非负数的性质
            if available:
                id = heappop(available) % k
                requests[id] += 1
                heappush(busy, (start + t, id))
        maxRequest = max(requests)
        return [i for i, req in enumerate(requests) if req == maxRequest]
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> busiestServers(int k, vector<int> &arrival, vector<int> &load) {
        priority_queue<int, vector<int>, greater<int>> available;
        for (int i = 0; i < k; i++) {
            available.push(i);
        }
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> busy;
        vector<int> requests(k, 0);
        for (int i = 0; i < arrival.size(); i++) {
            while (!busy.empty() && busy.top().first <= arrival[i]) {
                auto[_, id] = busy.top();
                busy.pop();
                available.push(i + ((id - i) % k + k) % k); // 保证得到的是一个不小于 i 的且与 id 同余的数
            }
            if (available.empty()) {
                continue;
            }
            int id = available.top() % k;
            available.pop();
            requests[id]++;
            busy.push({arrival[i] + load[i], id});
        }
        int maxRequest = *max_element(requests.begin(), requests.end());
        vector<int> ret;
        for (int i = 0; i < k; i++) {
            if (requests[i] == maxRequest) {
                ret.push_back(i);
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> busiestServers(int k, int[] arrival, int[] load) {
        PriorityQueue<Integer> available = new PriorityQueue<Integer>((a, b) -> a - b);
        for (int i = 0; i < k; i++) {
            available.offer(i);
        }
        PriorityQueue<int[]> busy = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        int[] requests = new int[k];
        for (int i = 0; i < arrival.length; i++) {
            while (!busy.isEmpty() && busy.peek()[0] <= arrival[i]) {
                int id = busy.peek()[1];
                busy.poll();
                available.offer(i + ((id - i) % k + k) % k); // 保证得到的是一个不小于 i 的且与 id 同余的数
            }
            if (available.isEmpty()) {
                continue;
            }
            int server = available.poll() % k;
            requests[server]++;
            busy.offer(new int[]{arrival[i] + load[i], server});
        }
        int maxRequest = Arrays.stream(requests).max().getAsInt();
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < k; i++) {
            if (requests[i] == maxRequest) {
                ret.add(i);
            }
        }
        return ret;
    }
}
```

```go [sol2-Golang]
func busiestServers(k int, arrival, load []int) (ans []int) {
    available := hi{make([]int, k)}
    for i := 0; i < k; i++ {
        available.IntSlice[i] = i
    }
    busy := hp{}
    requests := make([]int, k)
    maxRequest := 0
    for i, t := range arrival {
        for len(busy) > 0 && busy[0].end <= t {
            heap.Push(&available, i+((busy[0].id-i)%k+k)%k) // 保证得到的是一个不小于 i 的且与 id 同余的数
            heap.Pop(&busy)
        }
        if available.Len() == 0 {
            continue
        }
        id := heap.Pop(&available).(int) % k
        requests[id]++
        if requests[id] > maxRequest {
            maxRequest = requests[id]
            ans = []int{id}
        } else if requests[id] == maxRequest {
            ans = append(ans, id)
        }
        heap.Push(&busy, pair{t + load[i], id})
    }
    return
}

type hi struct{ sort.IntSlice }
func (h *hi) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hi) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }

type pair struct{ end, id int }
type hp []pair
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].end < h[j].end }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

+ 时间复杂度：$O((k + n) \log k)$ 或 $O(k + n \log k)$，其中 $k$ 为服务器的数目，$n$ 为请求的数目。开始时 $\textit{available}$ 放入所有的服务器的时间复杂度为 $O(k \log k)$ 或 $O(k)$，取决于语言实现；在处理请求时，$\textit{busy}$ 最多执行 $n$ 次放入和移除操作，$\textit{available}$ 最多执行 $n$ 次放入和移除操作，因此时间复杂度为 $O(n \log k)$；获取最繁忙服务器列表的时间复杂度为 $O(k)$。

+ 空间复杂度：$O(k)$。$\textit{busy}$ 和 $\textit{available}$ 最多放入 $k$ 个元素，需要 $O(k)$ 的空间；$\textit{requests}$ 需要 $O(k)$ 的空间。