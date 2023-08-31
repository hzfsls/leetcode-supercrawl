## [2517.礼盒的最大甜蜜度 中文官方题解](https://leetcode.cn/problems/maximum-tastiness-of-candy-basket/solutions/100000/li-he-de-zui-da-tian-mi-du-by-leetcode-s-sq44)

#### 方法一：贪心 + 二分查找

**思路**

礼盒的甜蜜度是 $k$ 种不同的糖果中，任意两种糖果价格差的绝对值的最小值。计算礼盒的甜蜜度时，可以先将 $k$ 种糖果按照价格排序，然后计算相邻的价格差的绝对值，然后取出最小值。

要求甜蜜度的最大值，可以采用二分查找的方法。先假设一个甜蜜度 $\textit{mid}$，然后尝试在排好序的 $\textit{price}$ 中找出 $k$ 种糖果，并且任意两种相邻的价格差绝对值都大于 $\textit{mid}$。如果可以找到这样的 $k$ 种糖果，则说明可能存在更大的甜蜜度，需要修改二分查找的下边界；如果找不到这样的 $k$ 种糖果，则说明最大的甜蜜度只可能更小，需要修改二分查找的上边界。

在假设一个甜蜜度 $\textit{mid}$ 后，在排好序的 $\textit{price}$ 中找 $k$ 种糖果时，需要用到贪心的算法。即从小到大遍历 $\textit{price}$ 的元素，如果当前糖果的价格比上一个选中的糖果的价格的差大于 $\textit{mid}$，则选中当前糖果，否则继续考察下一个糖果。

二分查找起始时，下边界为 $0$，上边界为 $\textit{price}$ 的最大值与最小值之差。二分查找结束时，即可得到最大甜蜜度。

**代码**

```Python [sol1-Python3]
class Solution:
    def maximumTastiness(self, price: List[int], k: int) -> int:
        price.sort()
        left, right = 0, price[-1] - price[0]
        while left < right:
            mid = (left + right + 1) // 2
            if self.check(price, k, mid):
                left = mid
            else:
                right = mid - 1
        return left

    def check(self, price: List[int], k: int, tastiness: int) -> bool:
        prev = -inf
        cnt = 0
        for p in price:
            if p - prev >= tastiness:
                cnt += 1
                prev = p
        return cnt >= k
```

```Java [sol1-Java]
class Solution {
    public int maximumTastiness(int[] price, int k) {
        Arrays.sort(price);
        int left = 0, right = price[price.length - 1] - price[0];
        while (left < right) {
            int mid = (left + right + 1) / 2;
            if (check(price, k, mid)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    public boolean check(int[] price, int k, int tastiness) {
        int prev = Integer.MIN_VALUE / 2;
        int cnt = 0;
        for (int p : price) {
            if (p - prev >= tastiness) {
                cnt++;
                prev = p;
            }
        }
        return cnt >= k;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumTastiness(int[] price, int k) {
        Array.Sort(price);
        int left = 0, right = price[price.Length - 1] - price[0];
        while (left < right) {
            int mid = (left + right + 1) / 2;
            if (Check(price, k, mid)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    public bool Check(int[] price, int k, int tastiness) {
        int prev = int.MinValue / 2;
        int cnt = 0;
        foreach (int p in price) {
            if (p - prev >= tastiness) {
                cnt++;
                prev = p;
            }
        }
        return cnt >= k;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maximumTastiness(vector<int>& price, int k) {
        int n = price.size();
        sort(price.begin(), price.end());
        int left = 0, right = price[n - 1] - price[0];
        while (left < right) {
            int mid = (left + right + 1) >> 1;
            if (check(price, k, mid)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    bool check(const vector<int> &price, int k, int tastiness) {
        int prev = INT_MIN >> 1;
        int cnt = 0;
        for (int p : price) {
            if (p - prev >= tastiness) {
                cnt++;
                prev = p;
            }
        }
        return cnt >= k;
    }
};
```

```C [sol1-C]
bool check(const int* price, int priceSize,int k, int tastiness) {
    int prev = INT_MIN >> 1;
    int cnt = 0;
    for (int i = 0; i < priceSize; i++) {
        int p = price[i];
        if (p - prev >= tastiness) {
            cnt++;
            prev = p;
        }
    }
    return cnt >= k;
}

static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int maximumTastiness(int* price, int priceSize, int k) {
    qsort(price, priceSize, sizeof(int), cmp);
    int left = 0, right = price[priceSize - 1] - price[0];
    while (left < right) {
        int mid = (left + right + 1) >> 1;
        if (check(price, priceSize, k, mid)) {
            left = mid;
        } else {
            right = mid - 1;
        }
    }
    return left;
}
```

```JavaScript [sol1-JavaScript]
var maximumTastiness = function(price, k) {
    price.sort((a, b) => a - b);
    let left = 0, right = price[price.length - 1] - price[0];
    while (left < right) {
        const mid = Math.floor((left + right + 1) / 2);
        if (check(price, k, mid)) {
            left = mid;
        } else {
            right = mid - 1;
        }
    }
    return left;
}

const check = (price, k, tastiness) => {
    let prev = -Number.MAX_VALUE / 2;
    let cnt = 0;
    for (const p of price) {
        if (p - prev >= tastiness) {
            cnt++;
            prev = p;
        }
    }
    return cnt >= k;
};
```

```Go [sol1-Go]
func maximumTastiness(price []int, k int) int {
    sort.Ints(price)
    left, right := 0, price[len(price)-1]-price[0]
    for left < right {
        mid := (left + right + 1) / 2
        if check(price, k, mid) {
            left = mid
        } else {
            right = mid - 1
        }
    }
    return left
}

func check(price []int, k int, tastiness int) bool {
    prev := int(math.Inf(-1)) >> 1
    cnt := 0
    for _, p := range price {
        if p - prev >= tastiness {
            cnt++
            prev = p
        }
    }
    return cnt >= k
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n + n \log C)$，其中 $n$ 是数组 $\textit{price}$ 的长度，$C$ 是数组 $\textit{price}$ 的最大值与最小值之差。排序的时间是 $O(n \log n)$，二分查找的次数是 $O(\log C)$，每次查找的时间是 $O(n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{price}$ 的长度。为排序的空间复杂度。