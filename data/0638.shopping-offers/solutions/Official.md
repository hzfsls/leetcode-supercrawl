#### 方法一：记忆化搜索

**思路**

首先，我们过滤掉不需要计算的大礼包。

如果大礼包完全没有优惠（大礼包的价格大于等于原价购买大礼包内所有物品的价格），或者大礼包内不包含任何的物品，那么购买这些大礼包不可能使整体价格降低。因此，我们可以不考虑这些大礼包，并将它们过滤掉，以提高效率和方便编码。

因为题目规定了「不能购买超出购物清单指定数量的物品」，所以只要我们购买过滤后的大礼包，都一定可以令整体价格降低。

然后，我们计算满足购物清单所需花费的最低价格。

因为 $1 \le \textit{needs} \le 6$ 和 $0 \le needs[i] \le 10$，所以最多只有 $11^6 = 1771561$ 种不同的购物清单 $\textit{needs}$。我们可以将所有可能的购物清单作为状态，并考虑这些状态之间相互转移的方法。

用 $\textit{dp}[\textit{needs}]$ 表示满足购物清单 $\textit{needs}$ 所需花费的最低价格。在进行状态转移时，我们考虑在满足购物清单 $\textit{needs}$ 时的最后一次购买；其中，将原价购买购物清单中的所有物品也视作一次购买。具体地，有以下两种情况：

- 第一种情况是购买大礼包，此时状态转移方程为：

  $$
  \textit{dp}[\textit{needs}] = \min_{i \in K} \{\textit{price}_i + \textit{dp}[\textit{needs} - \textit{needs}_i]\}
  $$

  其中，$K$ 表示所有可以购买的大礼包的下标集合，$i$ 表示其中一个大礼包的下标，$\textit{price}_i$ 表示第 $i$ 个大礼包的价格，$\textit{needs}_i$ 表示大礼包中包含的物品清单，$\textit{needs} - \textit{needs}_i$ 表示购物清单 $\textit{needs}$ 减去第 $i$ 个大礼包中包含的物品清单后剩余的物品清单。

- 第二种情况是不购买任何大礼包，原价购买购物清单中的所有物品，此时 $\textit{dp}[\textit{needs}]$ 可以直接求出。

$\textit{dp}[\textit{needs}]$ 为这两种情况的最小值。

**算法**

因为大礼包中可能包含多个物品，所以并不是所有状态都可以得到。因此，我们使用记忆化搜索而不是完全遍历的方法，来计算出满足每个购物清单 $\textit{needs}$  所需花费的最低价格。

具体地，在计算满足当前购物清单 $\textit{cur\_needs}$ 所需花费的最低价格 $\textit{min\_price}$ 时，我们可以采用如下方法：

- 将 $\textit{min\_price}$ 初始化为原价购买购物清单 $\textit{cur\_needs}$ 中的所有物品的花费；

- 逐个遍历所有可以购买的大礼包，不妨设当前遍历的大礼包为 $\textit{cur\_special}$，其价格为 $\textit{special\_price}$：

  - 计算购买大礼包 $\textit{cur\_special}$ 后新的购物清单 $\textit{nxt\_needs}$，并递归地计算满足购物清单 $\textit{nxt\_needs}$ 所需花费的最低价格 $\textit{nxt\_price}$；

  - 计算满足当前购物清单 $\textit{cur\_needs}$ 所需花费的最低价格 $\textit{cur\_price} = \textit{special\_price} + \textit{nxt\_price}$；

  - 如果 $\textit{cur\_price} < \textit{min\_price}$，则将 $\textit{min\_price}$ 更新为 $\textit{cur\_price}$。

- 返回计算满足购物清单 $\textit{cur\_needs}$ 所需花费的最低价格 $\textit{min\_price}$。

**细节**

我们也可以考虑使用状态压缩的方法来存储购物清单 $\textit{needs}$。但是因为购物清单中每种物品都可能有 $[0,10]$ 个，使用状态压缩需要设计一个相对复杂的方法来解决计算状态变化以及比较状态大小的问题，性价比较低，所以在这里不使用状态压缩的方法，感兴趣的读者可以自行实现。

**代码**

```Python [sol1-Python3]
from functools import lru_cache

class Solution:
    def shoppingOffers(self, price: List[int], special: List[List[int]], needs: List[int]) -> int:
        n = len(price)

        # 过滤不需要计算的大礼包，只保留需要计算的大礼包
        filter_special = []
        for sp in special:
            if sum(sp[i] for i in range(n)) > 0 and sum(sp[i] * price[i] for i in range(n)) > sp[-1]:
                filter_special.append(sp)

        # 记忆化搜索计算满足购物清单所需花费的最低价格
        @lru_cache(None)
        def dfs(cur_needs):
            # 不购买任何大礼包，原价购买购物清单中的所有物品
            min_price = sum(need * price[i] for i, need in enumerate(cur_needs))
            for cur_special in filter_special:
                special_price = cur_special[-1]
                nxt_needs = []
                for i in range(n):
                    if cur_special[i] > cur_needs[i]:  # 不能购买超出购物清单指定数量的物品
                        break
                    nxt_needs.append(cur_needs[i] - cur_special[i])
                if len(nxt_needs) == n:  # 大礼包可以购买
                    min_price = min(min_price, dfs(tuple(nxt_needs)) + special_price)
            return min_price

        return dfs(tuple(needs))
```

```Java [sol1-Java]
class Solution {
    Map<List<Integer>, Integer> memo = new HashMap<List<Integer>, Integer>();

    public int shoppingOffers(List<Integer> price, List<List<Integer>> special, List<Integer> needs) {
        int n = price.size();

        // 过滤不需要计算的大礼包，只保留需要计算的大礼包
        List<List<Integer>> filterSpecial = new ArrayList<List<Integer>>();
        for (List<Integer> sp : special) {
            int totalCount = 0, totalPrice = 0;
            for (int i = 0; i < n; ++i) {
                totalCount += sp.get(i);
                totalPrice += sp.get(i) * price.get(i);
            }
            if (totalCount > 0 && totalPrice > sp.get(n)) {
                filterSpecial.add(sp);
            }
        }

        return dfs(price, special, needs, filterSpecial, n);
    }

    // 记忆化搜索计算满足购物清单所需花费的最低价格
    public int dfs(List<Integer> price, List<List<Integer>> special, List<Integer> curNeeds, List<List<Integer>> filterSpecial, int n) {
        if (!memo.containsKey(curNeeds)) {
            int minPrice = 0;
            for (int i = 0; i < n; ++i) {
                minPrice += curNeeds.get(i) * price.get(i); // 不购买任何大礼包，原价购买购物清单中的所有物品
            }
            for (List<Integer> curSpecial : filterSpecial) {
                int specialPrice = curSpecial.get(n);
                List<Integer> nxtNeeds = new ArrayList<Integer>();
                for (int i = 0; i < n; ++i) {
                    if (curSpecial.get(i) > curNeeds.get(i)) { // 不能购买超出购物清单指定数量的物品
                        break;
                    }
                    nxtNeeds.add(curNeeds.get(i) - curSpecial.get(i));
                }
                if (nxtNeeds.size() == n) { // 大礼包可以购买
                    minPrice = Math.min(minPrice, dfs(price, special, nxtNeeds, filterSpecial, n) + specialPrice);
                }
            }
            memo.put(curNeeds, minPrice);
        }
        return memo.get(curNeeds);
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<IList<int>, int> memo = new Dictionary<IList<int>, int>();

    public int ShoppingOffers(IList<int> price, IList<IList<int>> special, IList<int> needs) {
        int n = price.Count;

        // 过滤不需要计算的大礼包，只保留需要计算的大礼包
        IList<IList<int>> filterSpecial = new List<IList<int>>();
        foreach (IList<int> sp in special) {
            int totalCount = 0, totalPrice = 0;
            for (int i = 0; i < n; ++i) {
                totalCount += sp[i];
                totalPrice += sp[i] * price[i];
            }
            if (totalCount > 0 && totalPrice > sp[n]) {
                filterSpecial.Add(sp);
            }
        }

        return DFS(price, special, needs, filterSpecial, n);
    }

    // 记忆化搜索计算满足购物清单所需花费的最低价格
    public int DFS(IList<int> price, IList<IList<int>> special, IList<int> curNeeds, IList<IList<int>> filterSpecial, int n) {
        if (!memo.ContainsKey(curNeeds)) {
            int minPrice = 0;
            for (int i = 0; i < n; ++i) {
                minPrice += curNeeds[i] * price[i]; // 不购买任何大礼包，原价购买购物清单中的所有物品
            }
            foreach (IList<int> curSpecial in filterSpecial) {
                int specialPrice = curSpecial[n];
                IList<int> nxtNeeds = new List<int>();
                for (int i = 0; i < n; ++i) {
                    if (curSpecial[i] > curNeeds[i]) { // 不能购买超出购物清单指定数量的物品
                        break;
                    }
                    nxtNeeds.Add(curNeeds[i] - curSpecial[i]);
                }
                if (nxtNeeds.Count == n) { // 大礼包可以购买
                    minPrice = Math.Min(minPrice, DFS(price, special, nxtNeeds, filterSpecial, n) + specialPrice);
                }
            }
            memo.Add(curNeeds, minPrice);
        }
        return memo[curNeeds];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    map<vector<int>, int> memo;

    int shoppingOffers(vector<int>& price, vector<vector<int>>& special, vector<int>& needs) {
        int n = price.size();

        // 过滤不需要计算的大礼包，只保留需要计算的大礼包
        vector<vector<int>> filterSpecial;
        for (auto & sp : special) {
            int totalCount = 0, totalPrice = 0;
            for (int i = 0; i < n; ++i) {
                totalCount += sp[i];
                totalPrice += sp[i] * price[i];
            }
            if (totalCount > 0 && totalPrice > sp[n]) {
                filterSpecial.emplace_back(sp);
            }
        }

        return dfs(price, special, needs, filterSpecial, n);
    }

    // 记忆化搜索计算满足购物清单所需花费的最低价格
    int dfs(vector<int> price,const vector<vector<int>> & special, vector<int> curNeeds, vector<vector<int>> & filterSpecial, int n) {
        if (!memo.count(curNeeds)) {
            int minPrice = 0;
            for (int i = 0; i < n; ++i) {
                minPrice += curNeeds[i] * price[i]; // 不购买任何大礼包，原价购买购物清单中的所有物品
            }
            for (auto & curSpecial : filterSpecial) {
                int specialPrice = curSpecial[n];
                vector<int> nxtNeeds;
                for (int i = 0; i < n; ++i) {
                    if (curSpecial[i] > curNeeds[i]) { // 不能购买超出购物清单指定数量的物品
                        break;
                    }
                    nxtNeeds.emplace_back(curNeeds[i] - curSpecial[i]);
                }
                if (nxtNeeds.size() == n) { // 大礼包可以购买
                    minPrice = min(minPrice, dfs(price, special, nxtNeeds, filterSpecial, n) + specialPrice);
                }
            }
            memo[curNeeds] = minPrice;
        }
        return memo[curNeeds];
    }
};
```

```JavaScript [sol1-JavaScript]
var shoppingOffers = function(price, special, needs) {
    const memo = new Map();

    // 记忆化搜索计算满足购物清单所需花费的最低价格
    const dfs = (price, special, curNeeds, filterSpecial, n) => {
        if (!memo.has(curNeeds)) {
            let minPrice = 0;
            for (let i = 0; i < n; ++i) {
                minPrice += curNeeds[i] * price[i]; // 不购买任何大礼包，原价购买购物清单中的所有物品
            }
            for (const curSpecial of filterSpecial) {
                const specialPrice = curSpecial[n];
                const nxtNeeds = [];
                for (let i = 0; i < n; ++i) {
                    if (curSpecial[i] > curNeeds[i]) { // 不能购买超出购物清单指定数量的物品
                        break;
                    }
                    nxtNeeds.push(curNeeds[i] - curSpecial[i]);
                }
                if (nxtNeeds.length === n) { // 大礼包可以购买
                    minPrice = Math.min(minPrice, dfs(price, special, nxtNeeds, filterSpecial, n) + specialPrice);
                }
            }
            memo.set(curNeeds, minPrice);
        }
        return memo.get(curNeeds);
    }

    const n = price.length;

    // 过滤不需要计算的大礼包，只保留需要计算的大礼包
    const filterSpecial = [];
    for (const sp of special) {
        let totalCount = 0, totalPrice = 0;
        for (let i = 0; i < n; ++i) {
            totalCount += sp[i];
            totalPrice += sp[i] * price[i];
        }
        if (totalCount > 0 && totalPrice > sp[n]) {
            filterSpecial.push(sp);
        }
    }

    return dfs(price, special, needs, filterSpecial, n);
};
```

```go [sol1-Golang]
func shoppingOffers(price []int, special [][]int, needs []int) int {
    n := len(price)

    // 过滤不需要计算的大礼包，只保留需要计算的大礼包
    filterSpecial := [][]int{}
    for _, s := range special {
        totalCount, totalPrice := 0, 0
        for i, c := range s[:n] {
            totalCount += c
            totalPrice += c * price[i]
        }
        if totalCount > 0 && totalPrice > s[n] {
            filterSpecial = append(filterSpecial, s)
        }
    }

    // 记忆化搜索计算满足购物清单所需花费的最低价格
    dp := map[string]int{}
    var dfs func([]byte) int
    dfs = func(curNeeds []byte) (minPrice int) {
        if res, has := dp[string(curNeeds)]; has {
            return res
        }
        for i, p := range price {
            minPrice += int(curNeeds[i]) * p // 不购买任何大礼包，原价购买购物清单中的所有物品
        }
        nextNeeds := make([]byte, n)
    outer:
        for _, s := range filterSpecial {
            for i, need := range curNeeds {
                if need < byte(s[i]) { // 不能购买超出购物清单指定数量的物品
                    continue outer
                }
                nextNeeds[i] = need - byte(s[i])
            }
            minPrice = min(minPrice, dfs(nextNeeds)+s[n])
        }
        dp[string(curNeeds)] = minPrice
        return
    }

    curNeeds := make([]byte, n)
    for i, need := range needs {
        curNeeds[i] = byte(need)
    }
    return dfs(curNeeds)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times k \times m^n)$，其中 $k$ 表示大礼包的数量，$m$ 表示每种物品的需求量的可能情况数（等于最大需求量加 $1$），$n$ 表示物品数量。我们最多需要处理 $m^n$ 个状态，每个状态需要遍历 $k$ 种大礼包的情况，每个大礼包需要遍历 $n$ 种商品以检查大礼包是否可以购买。

- 空间复杂度：$O(n \times m^n)$，用于存储记忆化搜索中 $m^n$ 个状态的计算结果，每个状态需要存储 $n$ 个商品的需求量。