## [1054.距离相等的条形码 中文官方题解](https://leetcode.cn/problems/distant-barcodes/solutions/100000/ju-chi-xiang-deng-de-tiao-xing-ma-by-lee-31qt)

#### 方法一：最大堆

**思路**

题目要求重新排列这些条形码，使其中任意两个相邻的条形码不能相等，可以返回任何满足该要求的答案，并且此题保证存在答案。我们首先想到的思路就是，找到剩余数量最多的元素，尽可能优先排列它。

我们首先统计 $\textit{barcodes}$ 每个元素的个数，然后遍历这个频数表，把每个元素的 (剩余数量， 元素值) 二元数组，依次插入最大堆。这样操作后，堆顶的元素就是剩余数量最多的元素。

然后我们每次从堆顶拿出一个剩余最多的元素，放入排列中，再更新剩余数量，重新放入最大堆中。如果这个元素和排列结果中的最后一个元素相同，那么我们就需要再从最大堆中取出第二多的元素，放入排列中，之后再把这两个元素放回最大堆中。

依次重复上面的操作，直到我们把所有元素都重新排列。

**代码**

```Java [sol1-Java]
class Solution {
    public int[] rearrangeBarcodes(int[] barcodes) {
        Map<Integer, Integer> count = new HashMap<>();
        for (int b : barcodes) {
            if (!count.containsKey(b)) {
                count.put(b, 0);
            }
            count.put(b, count.get(b) + 1);
        }
        PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> b[0] - a[0]);
        for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
            pq.offer(new int[]{entry.getValue(), entry.getKey()});
        }
        int n = barcodes.length;
        int[] res = new int[n];
        for (int i = 0; i < n; ++i) {
            int[] p = pq.poll();
            int cx = p[0], x = p[1];
            if (i == 0 || res[i - 1] != x) {
                res[i] = x;
                if (cx > 1) {
                    pq.offer(new int[]{cx - 1, x});
                }
            } else {
                int[] p2 = pq.poll();
                int cy = p2[0], y = p2[1];
                res[i] = y;
                if (cy > 1) {
                    pq.offer(new int[]{cy - 1, y});
                }
                pq.offer(new int[]{cx, x});
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] RearrangeBarcodes(int[] barcodes) {
        IDictionary<int, int> count = new Dictionary<int, int>();
        foreach (int b in barcodes) {
            count.TryAdd(b, 0);
            count[b]++;
        }
        PriorityQueue<Tuple<int, int>, int> pq = new PriorityQueue<Tuple<int, int>, int>();
        foreach (KeyValuePair<int, int> pair in count) {
            pq.Enqueue(new Tuple<int, int>(pair.Value, pair.Key), -pair.Value);
        }
        int n = barcodes.Length;
        int[] res = new int[n];
        for (int i = 0; i < n; ++i) {
            Tuple<int, int> p = pq.Dequeue();
            int cx = p.Item1, x = p.Item2;
            if (i == 0 || res[i - 1] != x) {
                res[i] = x;
                if (cx > 1) {
                    pq.Enqueue(new Tuple<int, int>(cx - 1, x), 1 - cx);
                }
            } else {
                Tuple<int, int> p2 = pq.Dequeue();
                int cy = p2.Item1, y = p2.Item2;
                res[i] = y;
                if (cy > 1) {
                    pq.Enqueue(new Tuple<int, int>(cy - 1, y), 1 - cy);
                }
                pq.Enqueue(new Tuple<int, int>(cx, x), -cx);
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> rearrangeBarcodes(vector<int>& barcodes) {
        unordered_map<int, int> count;
        for (int b : barcodes) {
            count[b]++;
        }
        priority_queue<pair<int, int>> q;
        for (const auto &[x, cx] : count) {
            q.push({cx, x});
        }
        vector<int> res;
        while (q.size()) {
            auto [cx, x] = q.top();
            q.pop();
            if (res.empty() || res.back() != x) {
                res.push_back(x);
                if (cx > 1) {
                    q.push({cx - 1, x});
                }
            } else {
                if (q.size() < 1) return res;
                auto [cy, y] = q.top();
                q.pop();
                res.push_back(y);
                if (cy > 1)  {
                    q.push({cy - 1, y});
                }
                q.push({cx, x});
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rearrangeBarcodes(self, barcodes: List[int]) -> List[int]:
        count = Counter(barcodes)
        q = []
        for x, cx in count.items():
            heapq.heappush(q, (-cx, x))
        res = []
        while len(q) > 0:
            cx, x = heapq.heappop(q)
            if len(res) == 0 or res[-1] != x:
                res.append(x)
                if cx < -1:
                    heapq.heappush(q, (cx + 1, x))
            else:
                cy, y = heapq.heappop(q)
                res.append(y)
                if cy < -1:
                    heapq.heappush(q, (cy + 1, y))
                heapq.heappush(q, (cx, x))
        return res
```

```Go [sol1-Go]
type PriorityQueue [][]int

func (pq PriorityQueue) Len() int {
    return len(pq)
}
func (pq PriorityQueue) Less(i, j int) bool {
    return pq[i][0] > pq[j][0]
}
func (pq PriorityQueue) Swap(i, j int) {
    pq[i], pq[j] = pq[j], pq[i]
}
func (pq *PriorityQueue) Push(x interface{}) {
    item := x.([]int)
    *pq = append(*pq, item)
}
func (pq *PriorityQueue) Pop() interface{} {
    old := *pq
    n := len(old)
    item := old[n-1]
    *pq = old[:n-1]
    return item
}

func rearrangeBarcodes(barcodes []int) []int {
    count := make(map[int]int)
    for _, b := range barcodes {
        count[b]++
    }
    q := &PriorityQueue{}
    heap.Init(q)
    for k, v := range count {
        heap.Push(q, []int{v, k})
    }
    n := len(barcodes)
    res := make([]int, n)
    for i := 0; i < n; i++ {
        p := heap.Pop(q).([]int)
        cx, x := p[0], p[1]
        if i == 0 || res[i-1] != x {
            res[i] = x
            if cx > 1 {
                heap.Push(q, []int{cx - 1, x})
            }
        } else {
            p2 := heap.Pop(q).([]int)
            cy, y := p2[0], p2[1]
            res[i] = y
            if cy > 1 {
                heap.Push(q, []int{cy - 1, y})
            }
            heap.Push(q, []int{cx, x})
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
class MaxHeap {
  constructor(compareFunc = (a, b) => a > b) {
    this.compare = compareFunc;
    this.heap = [];
  }

  get size() {
    return this.heap.length;
  }

  peek() {
    return this.heap[0];
  }

  add(value) {
    this.heap.push(value);
    this.heapifyUp();
  }

  poll() {
    if (this.size === 0) {
      return null;
    }
    if (this.size === 1) {
      return this.heap.pop();
    }
    const max = this.heap[0];
    this.heap[0] = this.heap.pop();
    this.heapifyDown();
    return max;
  }

  heapifyUp() {
    let currentIndex = this.size - 1;
    while (currentIndex > 0) {
      const parentIndex = Math.floor((currentIndex - 1) / 2);
      if (this.compare(this.heap[currentIndex], this.heap[parentIndex])) {
        [this.heap[currentIndex], this.heap[parentIndex]] = [this.heap[parentIndex], this.heap[currentIndex]];
        currentIndex = parentIndex;
      } else {
        break;
      }
    }
  }

  heapifyDown() {
    let currentIndex = 0;
    while (currentIndex < this.size) {
      let largestIndex = currentIndex;
      const leftChildIndex = 2 * currentIndex + 1;
      const rightChildIndex = 2 * currentIndex + 2;
      if (leftChildIndex < this.size && this.compare(this.heap[leftChildIndex], this.heap[largestIndex])) {
        largestIndex = leftChildIndex;
      }
      if (rightChildIndex < this.size && this.compare(this.heap[rightChildIndex], this.heap[largestIndex])) {
        largestIndex = rightChildIndex;
      }
      if (largestIndex !== currentIndex) {
        [this.heap[currentIndex], this.heap[largestIndex]] = [this.heap[largestIndex], this.heap[currentIndex]];
        currentIndex = largestIndex;
      } else {
        break;
      }
    }
  }
}

var rearrangeBarcodes = function(barcodes) {
    const count = new Map();
    for (const b of barcodes) {
        if (!count.has(b)) {
            count.set(b, 0);
        }
        count.set(b, count.get(b) + 1);
    }
    const pq = new MaxHeap((a, b) => a[0] > b[0] || (a[0] === b[0] && a[1] > b[1]));
    for (const [k, v] of count.entries()) {
        pq.add([v, k]);
    }
    const n = barcodes.length;
    const res = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        const p = pq.poll();
        const cx = p[0], x = p[1];
        if (i === 0 || res[i - 1] !== x) {
            res[i] = x;
            if (cx > 1) {
                pq.add([cx - 1, x]);
            }
        } else {
            const p2 = pq.poll();
            const cy = p2[0], y = p2[1];
            res[i] = y;
            if (cy > 1) {
                pq.add([cy - 1, y]);
            }
            pq.add([cx, x]);
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是 $\textit{barcodes}$ 长度。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{barcodes}$ 长度。

#### 方法二：计数统计

**思路**

通过观察我们可以发现，出现次数最多的元素，会始终在最大堆的顶部，我们实际上并不需要关心其他元素的相对大小顺序。在这个思路上可以进行优化，先统计所有元素的频数，找到出现次数最多的元素，然后将出现次数最多的元素交替排列。

这个方法在实现过程，会应用不常规的小技巧，具体证明过程可以参考题目「[767. 重构字符串的官方题解](https://leetcode.cn/problems/reorganize-string/solution/zhong-gou-zi-fu-chuan-by-leetcode-solution/)」的方法二。

首先统计每个元素的出现次数，然后根据每个元素的出现次数重构数组。

当 $n$ 是奇数且出现最多的元素的出现次数是 $\dfrac{n+1}{2}$ 时，出现次数最多的元素必须全部放置在偶数下标，否则一定会出现相邻的元素相同的情况。其余情况下，每个元素放置在偶数下标或者奇数下标都是可行的。

维护偶数下标 $\textit{evenIndex}$ 和奇数下标 $\textit{oddIndex}$，初始值分别为 $0$ 和 $1$。遍历每个元素，根据每个元素的出现次数判断元素应该放置在偶数下标还是奇数下标。

首先考虑是否可以放置在奇数下标。根据上述分析可知，只要元素的出现次数不超过数组的长度的一半（即出现次数小于或等于 $\Big\lfloor \dfrac{n}{2} \Big\rfloor$），就可以放置在奇数下标，只有当元素的出现次数超过数组的长度的一半时，才必须放置在偶数下标。元素的出现次数超过数组的长度的一半只可能发生在 $n$ 是奇数的情况下，且最多只有一个元素的出现次数会超过数组的长度的一半。

因此通过如下操作在重构的数组中放置元素。

- 如果元素的出现次数大于 $0$ 且小于或等于 $\Big\lfloor \dfrac{n}{2} \Big\rfloor$，且 $\textit{oddIndex}$ 没有超出数组下标范围，则将元素放置在 $\textit{oddIndex}$，然后将 $\textit{oddIndex}$ 的值加 $2$。

- 如果元素的出现次数大于 $\Big\lfloor \dfrac{n}{2} \Big\rfloor$，或 $\textit{oddIndex}$ 超出数组下标范围，则将元素放置在 $\textit{evenIndex}$，然后将 $\textit{evenIndex}$ 的值加 $2$。

如果一个元素出现了多次，则重复上述操作，直到该元素全部放置完毕。

**代码**

```Java [sol2-Java]
class Solution {
    public static int[] rearrangeBarcodes(int[] barcodes) {
        int length = barcodes.length;
        if (length < 2) {
            return barcodes;
        }

        Map<Integer, Integer> counts = new HashMap<>();
        int maxCount = 0;
        for (int b : barcodes) {
            counts.put(b, counts.getOrDefault(b, 0) + 1);
            maxCount = Math.max(maxCount, counts.get(b));
        }

        int evenIndex = 0;
        int oddIndex = 1;
        int halfLength = length / 2;
        int[] res = new int[length];
        for (Map.Entry<Integer, Integer> entry : counts.entrySet()) {
            int x = entry.getKey();
            int count = entry.getValue();
            while (count > 0 && count <= halfLength && oddIndex < length) {
                res[oddIndex] = x;
                count--;
                oddIndex += 2;
            }
            while (count > 0) {
                res[evenIndex] = x;
                count--;
                evenIndex += 2;
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] RearrangeBarcodes(int[] barcodes) {
        int length = barcodes.Length;
        if (length < 2) {
            return barcodes;
        }

        IDictionary<int, int> counts = new Dictionary<int, int>();
        int maxCount = 0;
        foreach (int b in barcodes) {
            counts.TryAdd(b, 0);
            counts[b]++;
            maxCount = Math.Max(maxCount, counts[b]);
        }

        int evenIndex = 0;
        int oddIndex = 1;
        int halfLength = length / 2;
        int[] res = new int[length];
        foreach (KeyValuePair<int, int> pair in counts) {
            int x = pair.Key;
            int count = pair.Value;
            while (count > 0 && count <= halfLength && oddIndex < length) {
                res[oddIndex] = x;
                count--;
                oddIndex += 2;
            }
            while (count > 0) {
                res[evenIndex] = x;
                count--;
                evenIndex += 2;
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> rearrangeBarcodes(vector<int>& barcodes) {
        int length = barcodes.size();
        if (length < 2) {
            return barcodes;
        }

        unordered_map<int, int> counts;
        int maxCount = 0;
        for (int b : barcodes) {
            maxCount = max(maxCount, ++counts[b]);
        }

        int evenIndex = 0, oddIndex = 1, halfLength = length / 2;
        vector<int> res(length);
        for (auto &[x, cx] : counts) {
            while (cx > 0 && cx <= halfLength && oddIndex < length) {
                res[oddIndex] = x;
                cx--;
                oddIndex += 2;
            }
            while (cx > 0) {
                res[evenIndex] = x;
                cx--;
                evenIndex += 2;
            }
        }
        return res;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def rearrangeBarcodes(self, barcodes: List[int]) -> List[int]:
        length = len(barcodes)
        if length < 2:
            return barcodes

        counts = {}
        max_count = 0
        for b in barcodes:
            counts[b] = counts.get(b, 0) + 1
            max_count = max(max_count, counts[b])

        evenIndex = 0
        oddIndex = 1
        half_length = length // 2
        res = [0] * length
        for x, count in counts.items():
            while count > 0 and count <= half_length and oddIndex < length:
                res[oddIndex] = x
                count -= 1
                oddIndex += 2
            while count > 0:
                res[evenIndex] = x
                count -= 1
                evenIndex += 2
        return res
```

```Go [sol2-Go]
func rearrangeBarcodes(barcodes []int) []int {
    if len(barcodes) < 2 {
        return barcodes
    }

    counts := make(map[int]int)
    maxCount := 0
    for _, b := range barcodes {
        counts[b] = counts[b] + 1
        if counts[b] > maxCount {
            maxCount = counts[b]
        }
    }

    evenIndex := 0
    oddIndex := 1
    halfLength := len(barcodes) / 2
    res := make([]int, len(barcodes))
    for x, count := range counts {
        for count > 0 && count <= halfLength && oddIndex < len(barcodes) {
            res[oddIndex] = x
            count--
            oddIndex += 2
        }
        for count > 0 {
            res[evenIndex] = x
            count--
            evenIndex += 2
        }
    }
    return res
}
```

```JavaScript [sol2-JavaScript]
var rearrangeBarcodes = function(barcodes) {
    const length = barcodes.length;
    if (length < 2) {
        return barcodes;
    }

    const counts = new Map();
    let maxCount = 0;
    for (const b of barcodes) {
        counts.set(b, (counts.get(b) || 0) + 1);
        maxCount = Math.max(maxCount, counts.get(b));
    }

    let evenIndex = 0;
    let oddIndex = 1;
    let halfLength = Math.floor(length / 2);
    const res = _.fill(Array(length), 0);
    for (let [x, count] of counts.entries()) {
        while (count > 0 && count <= halfLength && oddIndex < length) {
            res[oddIndex] = x;
            count--;
            oddIndex += 2;
        }
        while (count > 0) {
            res[evenIndex] = x;
            count--;
            evenIndex += 2;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{barcodes}$ 长度。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{barcodes}$ 长度。