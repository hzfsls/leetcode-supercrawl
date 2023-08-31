## [2335.装满杯子需要的最短总时长 中文官方题解](https://leetcode.cn/problems/minimum-amount-of-time-to-fill-cups/solutions/100000/zhuang-man-bei-zi-xu-yao-de-zui-duan-zon-c7y4)
#### 方法一：贪心 + 分类讨论

假设不同类型杯子的数量分别为 $x$, $y$ 和 $z$，其中 $x \le y \le z$。

+ 如果 $x + y \le z$，那么每次装满 $z$ 的时候，可以同时装满 $x$ 或 $y$，因此总时长为 $z$。

+ 如果 $x + y \gt z$，令 $t = x + y - z$，因为 $y - z \le 0$，所以 $t = x + y - z \le x \le y$。

    + 如果 $t$ 为偶数，相应的 $x + y + z$ 也为偶数，那么可以同时将 $x$ 和 $y$ 都装满 $\dfrac{t}{2}$，剩余的 $x + y - t = z$，可以同时装满，因此总时长为 $\dfrac{t}{2} + z = \dfrac{x + y - z}{2} + z = \dfrac{x + y + z}{2}$。

    + 如果 $t$ 为奇数，相应的 $x + y + z$ 也为奇数，那么可以同时将 $x$ 和 $y$ 都装满 $\dfrac{t - 1}{2}$，剩余的 $x + y - (t - 1) = z + 1 \gt z$，因此总时长为 $\dfrac{t - 1}{2} + z + 1 = \dfrac{x + y - z - 1}{2} + z + 1 = \dfrac{x + y + z + 1}{2}$。

    因此无论 $t$ 为奇数还是偶数，总时长都为 $\big \lceil \dfrac{x + y + z}{2} \big \rceil$。

```Python [sol1-Python3]
class Solution:
    def fillCups(self, amount: List[int]) -> int:
        amount.sort()
        if amount[2] > amount[1] + amount[0]:
            return amount[2]
        return (sum(amount) + 1) // 2
```

```C++ [sol1-C++]
class Solution {
public:
    int fillCups(vector<int>& amount) {
        sort(amount.begin(), amount.end());
        if (amount[2] > amount[1] + amount[0]) {
            return amount[2];
        }
        return (accumulate(amount.begin(), amount.end(), 0) + 1) / 2;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int fillCups(int[] amount) {
        Arrays.sort(amount);
        if (amount[2] > amount[1] + amount[0]) {
            return amount[2];
        }
        return (amount[0] + amount[1] + amount[2] + 1) / 2;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FillCups(int[] amount) {
        Array.Sort(amount);
        if (amount[2] > amount[1] + amount[0]) {
            return amount[2];
        }
        return (amount[0] + amount[1] + amount[2] + 1) / 2;
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int fillCups(int* amount, int amountSize) {
    qsort(amount, amountSize, sizeof(int), cmp);
    if (amount[2] > amount[1] + amount[0]) {
        return amount[2];
    }
    return (amount[0] + amount[1] + amount[2] + 1) / 2;
}
```

```JavaScript [sol1-JavaScript]
var fillCups = function(amount) {
    amount.sort((a, b) => a - b);
    if (amount[2] > amount[1] + amount[0]) {
        return amount[2];
    }
    return Math.floor((amount[0] + amount[1] + amount[2] + 1) / 2);
};
```

```go [sol1-Golang]
func fillCups(amount []int) int {
    sort.Ints(amount)
    if amount[2] > amount[1]+amount[0] {
        return amount[2]
    }
    return (amount[0] + amount[1] + amount[2] + 1) / 2
}
```

**复杂度分析**

+ 时间复杂度：$O(1)$。

+ 空间复杂度：$O(1)$。