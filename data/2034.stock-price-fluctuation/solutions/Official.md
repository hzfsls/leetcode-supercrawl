## [2034.股票价格波动 中文官方题解](https://leetcode.cn/problems/stock-price-fluctuation/solutions/100000/gu-piao-jie-ge-bo-dong-by-leetcode-solut-rwrb)
#### 方法一：哈希表 + 有序集合

这道题要求记录特定时间戳的股票价格、返回最新股票价格以及返回股票的最高和最低价格。

由于同一个时间戳可能出现多次，后面的记录会更正（覆盖）前面的记录，因此可以使用哈希表记录每个时间戳对应的股票价格。对于返回股票最新价格操作，我们可以维护最大的时间戳，用最大的时间戳在哈希表中查找，可以得到最新的股票价格。

对于返回股票的最高和最低价格的操作，我们需要知道当前哈希表中的股票的最高和最低价格。我们可以使用有序集合维护哈希表中的股票价格，有序集合中的最大值和最小值即为当前哈希表中的股票的最高和最低价格。

因此，$\texttt{StockPrice}$ 类需包含最大时间戳、哈希表和有序集合。初始化时，最大时间戳设为 $0$，哈希表和有序集合设为空。

对于更新操作：

1. 从哈希表中得到时间戳 $\textit{timestamp}$ 对应的原价格，如果哈希表中没有时间戳 $\textit{timestamp}$ 对应的原价格，则将原价格记为 $0$（由于实际价格都大于 $0$，因此可以将原价格记为 $0$ 表示哈希表中没有该时间戳）；

2. 将哈希表中的时间戳 $\textit{timestamp}$ 对应的价格更新为新价格 $\textit{price}$；

3. 如果原价格大于 $0$，即之前已经有时间戳 $\textit{timestamp}$ 对应的记录，则将原价格从有序集合中删除；

4. 在有序集合中加入新价格 $\textit{price}$。

注意，由于可能有重复的股票价格，对于不支持多重有序集合（如 C++ 中的 $\texttt{multiset}$）的语言，可以额外记录每个股票价格的出现次数，在加入、删除股票价格时，更新有序集合中该股票价格的出现次数。

其余的操作可以直接从哈希表和有序集合中得到结果：

- 对于返回股票最新价格操作，从哈希表中得到最大时间戳对应的股票价格并返回；

- 对于返回股票最高价格操作，从有序集合中得到最大值，即为股票最高价格，将其返回；

- 对于返回股票最低价格操作，从有序集合中得到最小值，即为股票最低价格，将其返回。

```Java [sol1-Java]
class StockPrice {
    int maxTimestamp;
    HashMap<Integer, Integer> timePriceMap;
    TreeMap<Integer, Integer> prices;

    public StockPrice() {
        maxTimestamp = 0;
        timePriceMap = new HashMap<Integer, Integer>();
        prices = new TreeMap<Integer, Integer>();
    }
    
    public void update(int timestamp, int price) {
        maxTimestamp = Math.max(maxTimestamp, timestamp);
        int prevPrice = timePriceMap.getOrDefault(timestamp, 0);
        timePriceMap.put(timestamp, price);
        if (prevPrice > 0) {
            prices.put(prevPrice, prices.get(prevPrice) - 1);
            if (prices.get(prevPrice) == 0) {
                prices.remove(prevPrice);
            }
        }
        prices.put(price, prices.getOrDefault(price, 0) + 1);
    }
    
    public int current() {
        return timePriceMap.get(maxTimestamp);
    }
    
    public int maximum() {
        return prices.lastKey();
    }
    
    public int minimum() {
        return prices.firstKey();
    }
}
```

```C++ [sol1-C++]
class StockPrice {
public:
    StockPrice() {
        this->maxTimestamp = 0;
    }
    
    void update(int timestamp, int price) {
        maxTimestamp = max(maxTimestamp, timestamp);
        int prevPrice = timePriceMap.count(timestamp) ? timePriceMap[timestamp] : 0;
        timePriceMap[timestamp] = price;
        if (prevPrice > 0) {
            auto it = prices.find(prevPrice);
            if (it != prices.end()) {
                prices.erase(it);
            }
        }
        prices.emplace(price);
    }
    
    int current() {
        return timePriceMap[maxTimestamp];
    }
    
    int maximum() {
        return *prices.rbegin();
    }
    
    int minimum() {
        return *prices.begin();
    }
private:
    int maxTimestamp;
    unordered_map<int, int> timePriceMap;
    multiset<int> prices;
};
```

```Python [sol1-Python3]
from sortedcontainers import SortedList

class StockPrice:
    def __init__(self):
        self.price = SortedList()
        self.timePriceMap = {}
        self.maxTimestamp = 0

    def update(self, timestamp: int, price: int) -> None:
        if timestamp in self.timePriceMap:
            self.price.discard(self.timePriceMap[timestamp])
        self.price.add(price)
        self.timePriceMap[timestamp] = price
        self.maxTimestamp = max(self.maxTimestamp, timestamp)

    def current(self) -> int:
        return self.timePriceMap[self.maxTimestamp]

    def maximum(self) -> int:
        return self.price[-1]

    def minimum(self) -> int:
        return self.price[0]
```

```go [sol1-Golang]
type StockPrice struct {
    prices       *redblacktree.Tree
    timePriceMap map[int]int
    maxTimestamp int
}

func Constructor() StockPrice {
    return StockPrice{redblacktree.NewWithIntComparator(), map[int]int{}, 0}
}

func (sp *StockPrice) Update(timestamp, price int) {
    if prevPrice := sp.timePriceMap[timestamp]; prevPrice > 0 {
        if times, _ := sp.prices.Get(prevPrice); times.(int) > 1 {
            sp.prices.Put(prevPrice, times.(int)-1)
        } else {
            sp.prices.Remove(prevPrice)
        }
    }
    times := 0
    if val, ok := sp.prices.Get(price); ok {
        times = val.(int)
    }
    sp.prices.Put(price, times+1)
    sp.timePriceMap[timestamp] = price
    if timestamp >= sp.maxTimestamp {
        sp.maxTimestamp = timestamp
    }
}

func (sp *StockPrice) Current() int { return sp.timePriceMap[sp.maxTimestamp] }
func (sp *StockPrice) Maximum() int { return sp.prices.Right().Key.(int) }
func (sp *StockPrice) Minimum() int { return sp.prices.Left().Key.(int) }
```

**复杂度分析**

- 时间复杂度：初始化的时间复杂度是 $O(1)$，更新操作、返回股票最高价格操作和返回股票最低价格操作的时间复杂度是 $O(\log n)$，返回股票最新价格操作的时间复杂度是 $O(1)$，其中 $n$ 是更新操作的次数。
  更新操作需要更新最大时间戳、哈希表和有序集合，更新最大时间戳和哈希表需要 $O(1)$ 的时间，更新有序集合需要 $O(\log n)$ 的时间。
  返回股票最高价格操作和返回股票最低价格操作分别需要在有序集合中寻找最大值和最小值，需要 $O(\log n)$ 的时间。
  返回股票最新价格操作需要在哈希表中得到最大时间戳对应的股票价格，需要 $O(1)$ 的时间。

- 空间复杂度：$O(n)$，其中 $n$ 是更新操作的次数。空间复杂度主要取决于哈希表和有序集合，哈希表和有序集合中存储的元素个数不会超过更新操作的次数。

#### 方法二：哈希表 + 两个优先队列

方法一使用一个有序集合存储每个股票价格的次数，在更新操作中将有序集合中的过期价格删除完毕，在其余操作中直接得到答案并返回。可以换一个思路，删除过期价格不一定要在更新操作中完成，而是可以在返回股票最高价格操作和返回股票最低价格操作中完成，即延迟删除。

为了实现延迟删除，需要维护两个优先队列用于存储股票价格和时间戳，分别基于大根堆和小根堆实现，大根堆的堆顶元素对应股票最高价格，小根堆的堆顶元素对应股票最低价格。以下将基于大根堆实现的优先队列称为最高价格队列，将基于小根堆实现的优先队列称为最低价格队列。

对于更新操作，使用 $\textit{timestamp}$ 更新最大时间戳，将 $\textit{timestamp}$ 和 $\textit{price}$ 存入哈希表，并将 $(\textit{price}, \textit{timestamp})$ 分别加入两个优先队列。

对于返回股票最新价格操作，从哈希表中得到最大时间戳对应的股票价格并返回。

对于返回股票最高价格操作，每次从最高价格队列的队首元素中得到价格和时间戳，并从哈希表中得到该时间戳对应的实际价格，如果队首元素中的价格和实际价格不一致，则队首元素为过期价格，将队首元素删除，重复该操作直到队首元素不为过期价格，此时返回队首元素中的价格。

对于返回股票最低价格操作，每次从最低价格队列的队首元素中得到价格和时间戳，并从哈希表中得到该时间戳对应的实际价格，如果队首元素中的价格和实际价格不一致，则队首元素为过期价格，将队首元素删除，重复该操作直到队首元素不为过期价格，此时返回队首元素中的价格。

```Java [sol2-Java]
class StockPrice {
    int maxTimestamp;
    HashMap<Integer, Integer> timePriceMap;
    PriorityQueue<int[]> pqMax;
    PriorityQueue<int[]> pqMin;

    public StockPrice() {
        maxTimestamp = 0;
        timePriceMap = new HashMap<Integer, Integer>();
        pqMax = new PriorityQueue<int[]>((a, b) -> b[0] - a[0]);
        pqMin = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
    }
    
    public void update(int timestamp, int price) {
        maxTimestamp = Math.max(maxTimestamp, timestamp);
        timePriceMap.put(timestamp, price);
        pqMax.offer(new int[]{price, timestamp});
        pqMin.offer(new int[]{price, timestamp});
    }
    
    public int current() {
        return timePriceMap.get(maxTimestamp);
    }
    
    public int maximum() {
        while (true) {
            int[] priceTime = pqMax.peek();
            int price = priceTime[0], timestamp = priceTime[1];
            if (timePriceMap.get(timestamp) == price) {
                return price;
            }
            pqMax.poll();
        }
    }
    
    public int minimum() {
        while (true) {
            int[] priceTime = pqMin.peek();
            int price = priceTime[0], timestamp = priceTime[1];
            if (timePriceMap.get(timestamp) == price) {
                return price;
            }
            pqMin.poll();
        }
    }
}
```

```C++ [sol2-C++]
typedef pair<int,int> pii;

class StockPrice {
public:
    StockPrice() {
        this->maxTimestamp = 0;
    }
    
    void update(int timestamp, int price) {
        maxTimestamp = max(maxTimestamp, timestamp);
        timePriceMap[timestamp] = price;
        pqMax.emplace(price, timestamp);
        pqMin.emplace(price, timestamp);
    }
    
    int current() {
        return timePriceMap[maxTimestamp];
    }
    
    int maximum() {
        while (true) {
            int price = pqMax.top().first, timestamp = pqMax.top().second;
            if (timePriceMap[timestamp] == price) {
                return price;
            }
            pqMax.pop();
        }
    }
    
    int minimum() {
        while (true) {
            int price = pqMin.top().first, timestamp = pqMin.top().second;
            if (timePriceMap[timestamp] == price) {
                return price;
            }
            pqMin.pop();
        }
    }
private:
    int maxTimestamp;
    unordered_map<int, int> timePriceMap;
    priority_queue<pii, vector<pii>, less<pii>> pqMax;
    priority_queue<pii, vector<pii>, greater<pii>> pqMin;
};
```

```Python [sol2-Python3]
class StockPrice:
    def __init__(self):
        self.maxPrice = []
        self.minPrice = []
        self.timePriceMap = {}
        self.maxTimestamp = 0

    def update(self, timestamp: int, price: int) -> None:
        heappush(self.maxPrice, (-price, timestamp))
        heappush(self.minPrice, (price, timestamp))
        self.timePriceMap[timestamp] = price
        self.maxTimestamp = max(self.maxTimestamp, timestamp)

    def current(self) -> int:
        return self.timePriceMap[self.maxTimestamp]

    def maximum(self) -> int:
        while True:
            price, timestamp = self.maxPrice[0]
            if -price == self.timePriceMap[timestamp]:
                return -price
            heappop(self.maxPrice)

    def minimum(self) -> int:
        while True:
            price, timestamp = self.minPrice[0]
            if price == self.timePriceMap[timestamp]:
                return price
            heappop(self.minPrice)
```

```go [sol2-Golang]
type StockPrice struct {
    maxPrice, minPrice hp
    timePriceMap       map[int]int
    maxTimestamp       int
}

func Constructor() StockPrice {
    return StockPrice{timePriceMap: map[int]int{}}
}

func (sp *StockPrice) Update(timestamp, price int) {
    heap.Push(&sp.maxPrice, pair{-price, timestamp})
    heap.Push(&sp.minPrice, pair{price, timestamp})
    sp.timePriceMap[timestamp] = price
    if timestamp > sp.maxTimestamp {
        sp.maxTimestamp = timestamp
    }
}

func (sp *StockPrice) Current() int {
    return sp.timePriceMap[sp.maxTimestamp]
}

func (sp *StockPrice) Maximum() int {
    for {
        if p := sp.maxPrice[0]; -p.price == sp.timePriceMap[p.timestamp] {
            return -p.price
        }
        heap.Pop(&sp.maxPrice)
    }
}

func (sp *StockPrice) Minimum() int {
    for {
        if p := sp.minPrice[0]; p.price == sp.timePriceMap[p.timestamp] {
            return p.price
        }
        heap.Pop(&sp.minPrice)
    }
}

type pair struct{ price, timestamp int }
type hp []pair
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].price < h[j].price }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：初始化的时间复杂度是 $O(1)$，更新操作、返回股票最高价格操作和返回股票最低价格操作的**均摊**时间复杂度是 $O(\log n)$，返回股票最新价格操作的时间复杂度是 $O(1)$，其中 $n$ 是更新操作的次数。
  更新操作需要更新最大时间戳、哈希表和两个优先队列，更新最大时间戳和哈希表需要 $O(1)$ 的时间。
  更新操作、返回股票最高价格操作和返回股票最低价格操作中，每个元素分别在两个优先队列中添加和删除一次，平均需要 $O(\log n)$ 的时间。
  返回股票最新价格操作需要在哈希表中得到最大时间戳对应的股票价格，需要 $O(1)$ 的时间。

- 空间复杂度：$O(n)$，其中 $n$ 是更新操作的次数。空间复杂度主要取决于哈希表和优先队列，哈希表和每个优先队列中存储的元素个数不会超过更新操作的次数。