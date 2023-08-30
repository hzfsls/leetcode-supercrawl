#### 方法一：模拟

我们将所有的物品以及它们的价格存放进哈希映射（HashMap）中。对于哈希映射中的每个键值对，键表示物品的编号，值表示物品的价格，这样我们就可以方便快速地统计每一位顾客的消费金额了。

为了判断每一位顾客是否可以得到折扣，我们还需要使用一个计数器表示当前顾客的序号，如果该序号是 `n` 的倍数，我们就按照 `discount` 对顾客的消费金额进行打折。

```C++ [sol1-C++]
class Cashier {
private:
    unordered_map<int, int> price;
    int n, discount;
    int custom_id;
    
public:
    Cashier(int _n, int _d, vector<int>& products, vector<int>& prices): n(_n), discount(_d), custom_id(0) {
        for (int i = 0; i < products.size(); ++i) {
            price[products[i]] = prices[i];
        }
    }
    
    double getBill(vector<int> product, vector<int> amount) {
        ++custom_id;
        double payment = 0;
        for (int i = 0; i < product.size(); ++i) {
            payment += price[product[i]] * amount[i];
        }
        if (custom_id % n == 0) {
            payment -= payment * discount / 100;
        }
        return payment;
    }
};
```

```Python [sol1-Python3]
class Cashier:
    def __init__(self, n: int, discount: int, products: List[int], prices: List[int]):
        self.price = dict()
        for product, price in zip(products, prices):
            self.price[product] = price
        self.n = n
        self.discount = discount
        self.custom_id = 0

    def getBill(self, product: List[int], amount: List[int]) -> float:
        self.custom_id += 1
        payment = 0.0
        for k, v in zip(product, amount):
            payment += self.price[k] * v
        if self.custom_id % self.n == 0:
            payment -= payment * self.discount / 100
        return payment
```

**复杂度分析**

- 时间复杂度：预处理（Cashier 类的构造函数）的时间复杂度为 $O(P)$，其中 $P$ 是数组 `products` 和 `prices` 的长度。`getBill()` 的时间复杂度为 $O(M)$，其中 $M$ 是数组 `product` 和 `amount` 的长度。

- 空间复杂度：预处理的空间复杂度为 $O(P)$。`getBill()` 的额外（预处理的结果之外）空间复杂度为 $O(1)$。