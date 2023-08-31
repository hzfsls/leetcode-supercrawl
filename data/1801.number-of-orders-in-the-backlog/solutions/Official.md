## [1801.积压订单中的订单总数 中文官方题解](https://leetcode.cn/problems/number-of-orders-in-the-backlog/solutions/100000/ji-ya-ding-dan-zhong-de-ding-dan-zong-sh-6g22)

#### 方法一：优先队列模拟

根据题意，需要遍历数组 $\textit{orders}$ 中的订单并依次处理。对于遍历到的每个订单，需要找到类型相反的积压订单，如果可以匹配则执行这两笔订单并将积压订单删除，否则将当前订单添加到积压订单中。

由于寻找已有的积压订单时，需要寻找价格最高的采购订单或者价格最低的销售订单，因此可以使用两个优先队列分别存储积压的采购订单和积压的销售订单，两个优先队列称为采购订单优先队列和销售订单优先队列，分别满足队首元素是价格最高的采购订单和价格最低的销售订单。

遍历数组 $\textit{orders}$，对于 $\textit{order} = [\textit{price}, \textit{amount}, \textit{orderType}]$，执行如下操作。

- 如果 $\textit{orderType} = 0$，则表示 $\textit{amount}$ 个价格为 $\textit{price}$ 的采购订单，需要将这些采购订单和积压的销售订单匹配并执行。当销售订单优先队列中存在价格小于等于 $\textit{price}$ 的销售订单时，将当前采购订单和积压的销售订单匹配并执行，直到当前采购订单全部匹配执行、积压的销售订单全部匹配执行或者剩余积压的销售订单的价格都大于 $\textit{price}$。如果还有剩余的当前采购订单尚未匹配执行，则将剩余的采购订单添加到采购订单优先队列中。

- 如果 $\textit{orderType} = 1$，则表示 $\textit{amount}$ 个价格为 $\textit{price}$ 的销售订单，需要将这些销售订单和积压的采购订单匹配并执行。当采购订单优先队列中存在价格大于等于 $\textit{price}$ 的采购订单时，将当前销售订单和积压的采购订单匹配并执行，直到当前销售订单全部匹配执行、积压的采购订单全部匹配执行或者剩余积压的采购订单的价格都小于 $\textit{price}$。如果还有剩余的当前销售订单尚未匹配执行，则将剩余的销售订单添加到销售订单优先队列中。

遍历数组 $\textit{orders}$ 之后，两个优先队列中剩余的元素表示输入所有订单之后的积压订单，计算两个优先队列中剩余的订单总数并返回。

```Python [sol1-Python3]
class Solution:
    def getNumberOfBacklogOrders(self, orders: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        buyOrders, sellOrders = [], []
        for price, amount, type in orders:
            if type == 0:
                while amount and sellOrders and sellOrders[0][0] <= price:
                    if sellOrders[0][1] > amount:
                        sellOrders[0][1] -= amount
                        amount = 0
                        break
                    amount -= heappop(sellOrders)[1]
                if amount:
                    heappush(buyOrders, [-price, amount])
            else:
                while amount and buyOrders and -buyOrders[0][0] >= price:
                    if buyOrders[0][1] > amount:
                        buyOrders[0][1] -= amount
                        amount = 0
                        break
                    amount -= heappop(buyOrders)[1]
                if amount:
                    heappush(sellOrders, [price, amount])
        return (sum(x for _, x in buyOrders) + sum(x for _, x in sellOrders)) % MOD
```

```Java [sol1-Java]
class Solution {
    public int getNumberOfBacklogOrders(int[][] orders) {
        final int MOD = 1000000007;
        PriorityQueue<int[]> buyOrders = new PriorityQueue<int[]>((a, b) -> b[0] - a[0]);
        PriorityQueue<int[]> sellOrders = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        for (int[] order : orders) {
            int price = order[0], amount = order[1], orderType = order[2];
            if (orderType == 0) {
                while (amount > 0 && !sellOrders.isEmpty() && sellOrders.peek()[0] <= price) {
                    int[] sellOrder = sellOrders.poll();
                    int sellAmount = Math.min(amount, sellOrder[1]);
                    amount -= sellAmount;
                    sellOrder[1] -= sellAmount;
                    if (sellOrder[1] > 0) {
                        sellOrders.offer(sellOrder);
                    }
                }
                if (amount > 0) {
                    buyOrders.offer(new int[]{price, amount});
                }
            } else {
                while (amount > 0 && !buyOrders.isEmpty() && buyOrders.peek()[0] >= price) {
                    int[] buyOrder = buyOrders.poll();
                    int buyAmount = Math.min(amount, buyOrder[1]);
                    amount -= buyAmount;
                    buyOrder[1] -= buyAmount;
                    if (buyOrder[1] > 0) {
                        buyOrders.offer(buyOrder);
                    }
                }
                if (amount > 0) {
                    sellOrders.offer(new int[]{price, amount});
                }
            }
        }
        int total = 0;
        for (PriorityQueue<int[]> pq : Arrays.asList(buyOrders, sellOrders)) {
            while (!pq.isEmpty()) {
                int[] order = pq.poll();
                total = (total + order[1]) % MOD;
            }
        }
        return total;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GetNumberOfBacklogOrders(int[][] orders) {
        const int MOD = 1000000007;
        PriorityQueue<int[], int> buyOrders = new PriorityQueue<int[], int>();
        PriorityQueue<int[], int> sellOrders = new PriorityQueue<int[], int>();
        foreach (int[] order in orders) {
            int price = order[0], amount = order[1], orderType = order[2];
            if (orderType == 0) {
                while (amount > 0 && sellOrders.Count > 0 && sellOrders.Peek()[0] <= price) {
                    int[] sellOrder = sellOrders.Dequeue();
                    int sellAmount = Math.Min(amount, sellOrder[1]);
                    amount -= sellAmount;
                    sellOrder[1] -= sellAmount;
                    if (sellOrder[1] > 0) {
                        sellOrders.Enqueue(sellOrder, sellOrder[0]);
                    }
                }
                if (amount > 0) {
                    buyOrders.Enqueue(new int[]{price, amount}, -price);
                }
            } else {
                while (amount > 0 && buyOrders.Count > 0 && buyOrders.Peek()[0] >= price) {
                    int[] buyOrder = buyOrders.Dequeue();
                    int buyAmount = Math.Min(amount, buyOrder[1]);
                    amount -= buyAmount;
                    buyOrder[1] -= buyAmount;
                    if (buyOrder[1] > 0) {
                        buyOrders.Enqueue(buyOrder, -buyOrder[0]);
                    }
                }
                if (amount > 0) {
                    sellOrders.Enqueue(new int[]{price, amount}, price);
                }
            }
        }
        int total = 0;
        foreach (PriorityQueue<int[], int> pq in new PriorityQueue<int[], int>[]{buyOrders, sellOrders}) {
            while (pq.Count > 0) {
                int[] order = pq.Dequeue();
                total = (total + order[1]) % MOD;
            }
        }
        return total;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int getNumberOfBacklogOrders(vector<vector<int>>& orders) {
        const int MOD = 1000000007;
        priority_queue<pair<int, int>, vector<pair<int, int>>, less<pair<int, int>>> buyOrders;
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> sellOrders;
        for (auto &&order : orders) {
            int price = order[0], amount = order[1], orderType = order[2];
            if (orderType == 0) {
                while (amount > 0 && !sellOrders.empty() && sellOrders.top().first <= price) {
                    auto sellOrder = sellOrders.top();
                    sellOrders.pop();
                    int sellAmount = min(amount, sellOrder.second);
                    amount -= sellAmount;
                    sellOrder.second -= sellAmount;
                    if (sellOrder.second > 0) {
                        sellOrders.push(sellOrder);
                    }
                }
                if (amount > 0) {
                    buyOrders.emplace(price, amount);
                }
            } else {
                while (amount > 0 && !buyOrders.empty() && buyOrders.top().first >= price) {
                    auto buyOrder = buyOrders.top();
                    buyOrders.pop();
                    int buyAmount = min(amount, buyOrder.second);
                    amount -= buyAmount;
                    buyOrder.second -= buyAmount;
                    if (buyOrder.second > 0) {
                        buyOrders.push(buyOrder);
                    }
                }
                if (amount > 0) {
                    sellOrders.emplace(price, amount);
                }
            }
        }
        int total = 0;
        while (!buyOrders.empty()) {
            total = (total + buyOrders.top().second) % MOD;
            buyOrders.pop();
        }
        while (!sellOrders.empty()) {
            total = (total + sellOrders.top().second) % MOD;
            sellOrders.pop();
        }
        return total;
    }
};
```

```go [sol1-Golang]
func getNumberOfBacklogOrders(orders [][]int) (ans int) {
	buyOrders, sellOrders := hp{}, hp2{}
	for _, o := range orders {
		price, amount := o[0], o[1]
		if o[2] == 0 {
			for amount > 0 && len(sellOrders) > 0 && sellOrders[0].price <= price {
				if sellOrders[0].left > amount {
					sellOrders[0].left -= amount
					amount = 0
					break
				}
				amount -= heap.Pop(&sellOrders).(pair).left
			}
			if amount > 0 {
				heap.Push(&buyOrders, pair{price, amount})
			}
		} else {
			for amount > 0 && len(buyOrders) > 0 && buyOrders[0].price >= price {
				if buyOrders[0].left > amount {
					buyOrders[0].left -= amount
					amount = 0
					break
				}
				amount -= heap.Pop(&buyOrders).(pair).left
			}
			if amount > 0 {
				heap.Push(&sellOrders, pair{price, amount})
			}
		}
	}
	for _, p := range buyOrders {
		ans += p.left
	}
	for _, p := range sellOrders {
		ans += p.left
	}
	return ans % (1e9 + 7)
}

type pair struct{ price, left int }
type hp []pair
func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].price > h[j].price }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }

type hp2 []pair
func (h hp2) Len() int            { return len(h) }
func (h hp2) Less(i, j int) bool  { return h[i].price < h[j].price }
func (h hp2) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp2) Push(v interface{}) { *h = append(*h, v.(pair)) }
func (h *hp2) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{orders}$ 的长度。需要遍历数组 $\textit{orders}$ 一次，对于每个元素处理优先队列的时间是 $O(\log n)$，共需要 $O(n \log n)$ 的时间，遍历结束之后计算剩余的积压订单总数需要 $O(n \log n)$ 的时间。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{orders}$ 的长度。优先队列需要 $O(n)$ 的空间。