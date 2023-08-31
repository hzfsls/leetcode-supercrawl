## [1912.设计电影租借系统 中文官方题解](https://leetcode.cn/problems/design-movie-rental-system/solutions/100000/she-ji-dian-ying-zu-jie-xi-tong-by-leetc-dv3z)

#### 方法一：使用合适的数据结构

**提示 $1$**

对于一部电影，每个商店至多有它的拷贝，因此我们可以将 $(\textit{shop}, \textit{movie})$ 这一二元组作为数组 $\textit{entries}$ 中电影的唯一标识。

因此，我们可以使用一个哈希映射 $\textit{t\_price}$ 存储所有的电影。对于哈希映射中的每一个键值对，键表示 $(\textit{shop}, \textit{movie})$，值表示该电影的价格。

**提示 $2$**

我们可以考虑禁止修改 $\textit{t\_price}$，即在任何情况下（例如 $\texttt{rent}$ 操作或者 $\texttt{drop}$ 操作），我们都不会去修改 $\textit{t\_price}$ 本身。因此，我们需要两个额外的数据结构，一个存储未借出的电影 $\textit{t\_valid}$，一个存储已借出的电影 $\textit{t\_rent}$。

我们应该使用何种数据结构呢？

**提示 $3$**

对于未借出的电影，我们需要支持以下的三种操作：

- $\texttt{search(movie)}$ 操作，即给定 $\textit{movie}$ 查找出最便宜的 $5$ 个 $\textit{shop}$。因此，$\textit{t\_valid}$ 最好「相对于 $\textit{movie}$」是一个**有序的**数据结构。

    我们可以考虑将 $\textit{t\_valid}$ 设计成一个哈希映射，键表示 $\textit{movie}$，值为一个有序集合（例如平衡树），存储了所有拥有 $\textit{movie}$ 的 $\textit{shop}$。由于在 $\texttt{search}$ 操作中，我们需要按照 $\textit{price}$ 为第一关键字，$\textit{shop}$ 为第二关键字返回结果，因此我们可以在有序集合中存储 $(\textit{price}, \textit{shop})$ 这一二元组。

- $\texttt{rent(shop, movie)}$ 操作。我们只需要通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，从 $\textit{t\_valid}[\textit{movie}]$ 中删除 $(\textit{price}, \textit{shop})$ 即可。

- $\texttt{drop(shop, movie)}$ 操作。我们只需要通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，将 $(\textit{price}, \textit{shop})$ 加入 $\textit{t\_valid}[\textit{movie}]$ 即可。

对于已借出的电影，我们需要支持以下的三种操作：

- $\texttt{report()}$ 操作，即查找出最便宜的 $5$ 部电影。由于我们需要按照 $\textit{price}$ 为第一关键字，$\textit{shop}$ 为第二关键字，$\textit{movie}$ 为第三关键字返回结果，因此我们同样可以使用一个有序集合表示 $\textit{t\_rent}$，存储三元组 $(\textit{price}, \textit{shop}, \textit{movie})$。

- $\texttt{rent(shop, movie)}$ 操作。我们只需要通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，将 $(\textit{price}, \textit{shop}, \textit{movie})$ 加入 $\textit{t\_rent}$ 即可。

- $\texttt{drop(shop, movie)}$ 操作。我们只需要通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，从 $\textit{t\_rent}$ 中删除 $(\textit{price}, \textit{shop}, \textit{movie})$ 即可。

**思路与算法**

我们使用提示部分提及的数据结构 $\textit{t\_price}$，$\textit{t\_valid}$，$\textit{t\_rent}$。

- 对于 $\texttt{MovieRentingSystem(n, entries)}$ 操作：我们遍历 $\textit{entries}$ 中的 $(\textit{shop}, \textit{movie}, \textit{price})$，将 $(\textit{shop}, \textit{movie})$ 作为键、$\textit{price}$ 作为值加入 $\textit{t\_price}$，并且将 $(\textit{price}, \textit{shop})$ 加入 $\textit{t\_valid}[\textit{movie}]$。

- 对于 $\texttt{search(movie)}$ 操作，我们遍历 $\textit{t\_valid}[\textit{movie}]$ 中不超过 $5$ 个 $(\textit{price}, \textit{shop})$，并返回其中的 $\textit{shop}$。

- 对于 $\texttt{rent(shop, movie)}$ 操作，我们通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，从 $\textit{t\_valid}[\textit{movie}]$ 中删除 $(\textit{price}, \textit{shop})$，并且将 $(\textit{price}, \textit{shop}, \textit{movie})$ 加入 $\textit{t\_rent}$。

- 对于 $\texttt{drop(shop, movie)}$ 操作，我们通过 $\textit{t\_price}[(\textit{shop}, \textit{movie})]$ 得到 $\textit{price}$，将 $(\textit{price}, \textit{shop})$ 加入 $\textit{t\_valid}[\textit{movie}]$，并且从 $\textit{t\_rent}$ 中删除 $(\textit{price}, \textit{shop}, \textit{movie})$。

- 对于 $\texttt{report()}$ 操作，我们遍历 $\textit{t\_rent}$ 中不超过 $5$ 个 $(\textit{price}, \textit{shop}, \textit{movie})$，并返回其中的 $(\textit{shop}, \textit{movie})$。

**代码**

```C++ [sol1-C++]
class MovieRentingSystem {
private:
    # 需要自行实现 pair<int, int> 的哈希函数
    static constexpr auto pairHash = [fn = hash<int>()](const pair<int, int>& o) {return (fn(o.first) << 16) ^ fn(o.second);};
    unordered_map<pair<int, int>, int, decltype(pairHash)> t_price{0, pairHash};

    unordered_map<int, set<pair<int, int>>> t_valid;

    set<tuple<int, int, int>> t_rent;

public:
    MovieRentingSystem(int n, vector<vector<int>>& entries) {
        for (const auto& entry: entries) {
            t_price[{entry[0], entry[1]}] = entry[2];
            t_valid[entry[1]].emplace(entry[2], entry[0]);
        }
    }
    
    vector<int> search(int movie) {
        if (!t_valid.count(movie)) {
            return {};
        }
        
        vector<int> ret;
        auto it = t_valid[movie].begin();
        for (int i = 0; i < 5 && it != t_valid[movie].end(); ++i, ++it) {
            ret.push_back(it->second);
        }
        return ret;
    }
    
    void rent(int shop, int movie) {
        int price = t_price[{shop, movie}];
        t_valid[movie].erase({price, shop});
        t_rent.emplace(price, shop, movie);
    }
    
    void drop(int shop, int movie) {
        int price = t_price[{shop, movie}];
        t_valid[movie].emplace(price, shop);
        t_rent.erase({price, shop, movie});
    }
    
    vector<vector<int>> report() {
        vector<vector<int>> ret;
        auto it = t_rent.begin();
        for (int i = 0; i < 5 && it != t_rent.end(); ++i, ++it) {
            ret.emplace_back(initializer_list<int>{get<1>(*it), get<2>(*it)});
        }
        return ret;
    }
};
```

```Python [sol1-Python3]
class MovieRentingSystem:

    def __init__(self, n: int, entries: List[List[int]]):
        self.t_price = dict()
        self.t_valid = defaultdict(sortedcontainers.SortedList)
        self.t_rent = sortedcontainers.SortedList()
        
        for shop, movie, price in entries:
            self.t_price[(shop, movie)] = price
            self.t_valid[movie].add((price, shop))

    def search(self, movie: int) -> List[int]:
        t_valid_ = self.t_valid
        
        if movie not in t_valid_:
            return []
        
        return [shop for (price, shop) in t_valid_[movie][:5]]
        
    def rent(self, shop: int, movie: int) -> None:
        price = self.t_price[(shop, movie)]
        self.t_valid[movie].discard((price, shop))
        self.t_rent.add((price, shop, movie))

    def drop(self, shop: int, movie: int) -> None:
        price = self.t_price[(shop, movie)]
        self.t_valid[movie].add((price, shop))
        self.t_rent.discard((price, shop, movie))

    def report(self) -> List[List[int]]:
        return [(shop, movie) for price, shop, movie in self.t_rent[:5]]
```

**复杂度分析**

- 时间复杂度：

    - $\texttt{MovieRentingSystem(n, entries)}$ 操作：$O(n \log n)$。

    - $\texttt{search(movie)}$ 操作：$O(\log n)$。

    - $\texttt{rent(shop, movie)}$ 操作：$O(\log n)$。

    - $\texttt{drop(shop, movie)}$ 操作：$O(\log n)$。

    - $\texttt{report()}$ 操作：$O(\log n)$。

- 空间复杂度：$O(n)$。