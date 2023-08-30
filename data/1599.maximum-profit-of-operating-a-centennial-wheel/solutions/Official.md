#### 方法一：模拟

假设每位游客需要支付的费用是 $\textit{boardingCost}$，一次轮转有 $\textit{curCustomers}$ 位游客登上座舱，每次轮转的运行成本是 $\textit{runningCost}$，则摩天轮当前一次轮转的利润是 $\textit{boardingCost} \times \textit{curCustomers} - \textit{runningCost}$，其中 $\textit{boardingCost}$ 和 $\textit{runningCost}$ 的值是已知的，$\textit{curCustomers}$ 的值由正在等摩天轮的游客的数量和座舱可以容纳的游客的数量中的最小值决定，其中座舱可以容纳的游客的数量为 $4$。

对于长度为 $n$ 的数组 $\textit{customers}$，$\textit{customers}[i]$ 是在第 $i$ 次轮转之前到达的新游客的数量（$i$ 从 $0$ 开始），因此可以根据到达的新游客的数量和登上摩天轮的游客的数量计算每一次轮转时正在等摩天轮的游客的数量。

轮转摩天轮分成两个阶段。第一阶段是前 $n$ 次轮转，每次轮转之前都可能有新游客到达。如果在第一阶段结束之后还有剩余的游客在等摩天轮，则进入第二阶段，将剩余的游客轮转完毕。

对于第一阶段的每次轮转，需要首先计算该次轮转时正在等摩天轮的游客的数量，然后计算该次轮转的利润以及总利润，同时维护最大利润与最大利润的最小轮转次数。具体而言，第 $i$ 次轮转的流程如下：

1. 使用 $\textit{customers}[i]$ 的值更新正在等摩天轮的游客的数量；

2. 计算登上座舱的游客的数量，为正在等摩天轮的游客的数量和座舱可以容纳的游客的数量的最小值；

3. 将登上座舱的游客的数量从正在等摩天轮的游客的数量中减去；

4. 计算该次轮转的利润，并计算到该次轮转的总利润；

5. 如果总利润大于最大利润，则更新最大利润与最大利润的最小轮转次数。

第一阶段结束后，如果没有剩余的游客在等摩天轮，则直接返回最大利润的最小轮转次数。如果还有剩余的游客在等摩天轮，只有当剩余的游客带来的利润为正时，才需要考虑第二阶段，可能获得更多的利润。

由于每位游客需要支付的费用是正数，因此当座舱满舱时（即座舱上有 $4$ 位游客，达到最大容纳数量），可以达到一次轮转的最大利润。如果一次轮转的最大利润不为正，则第二阶段的利润一定不为正，因此直接返回第一阶段的最大利润的最小轮转次数。

如果一次轮转的最大利润为正，则每次座舱满舱的轮转的利润都为正，因此计算全部满舱轮转之后的总利润，如果大于最大利润则更新最大利润与最大利润的最小轮转次数。最后可能剩下少于 $4$ 位游客，需要进行最后一次非满舱的轮转，在最后一次轮转之后计算总利润，如果总利润大于最大利润则更新最大利润与最大利润的最小轮转次数。

```Python [sol1-Python3]
class Solution:
    def minOperationsMaxProfit(self, customers: List[int], boardingCost: int, runningCost: int) -> int:
        ans = -1
        maxProfit = totalProfit = operations = customersCount = 0
        for c in customers:
            operations += 1
            customersCount += c
            curCustomers = min(customersCount, 4)
            customersCount -= curCustomers
            totalProfit += boardingCost * curCustomers - runningCost
            if totalProfit > maxProfit:
                maxProfit = totalProfit
                ans = operations

        if customersCount == 0:
            return ans

        profitEachTime = boardingCost * 4 - runningCost
        if profitEachTime <= 0:
            return ans

        if customersCount > 0:
            fullTimes = customersCount // 4
            totalProfit += profitEachTime * fullTimes
            operations += fullTimes
            if totalProfit > maxProfit:
                maxProfit = totalProfit
                ans = operations

            remainingCustomers = customersCount % 4
            remainingProfit = boardingCost * remainingCustomers - runningCost
            totalProfit += remainingProfit
            if totalProfit > maxProfit:
                operations += 1
                ans += 1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int minOperationsMaxProfit(int[] customers, int boardingCost, int runningCost) {
        int ans = -1;
        int maxProfit = 0;
        int totalProfit = 0;
        int operations = 0;
        int customersCount = 0;
        int n = customers.length;
        for (int i = 0; i < n; i++) {
            operations++;
            customersCount += customers[i];
            int curCustomers = Math.min(customersCount, 4);
            customersCount -= curCustomers;
            totalProfit += boardingCost * curCustomers - runningCost;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
        }
        if (customersCount == 0) {
            return ans;
        }
        int profitEachTime = boardingCost * 4 - runningCost;
        if (profitEachTime <= 0) {
            return ans;
        }
        if (customersCount > 0) {
            int fullTimes = customersCount / 4;
            totalProfit += profitEachTime * fullTimes;
            operations += fullTimes;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
            int remainingCustomers = customersCount % 4;
            int remainingProfit = boardingCost * remainingCustomers - runningCost;
            totalProfit += remainingProfit;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                operations++;
                ans++;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperationsMaxProfit(int[] customers, int boardingCost, int runningCost) {
        int ans = -1;
        int maxProfit = 0;
        int totalProfit = 0;
        int operations = 0;
        int customersCount = 0;
        int n = customers.Length;
        for (int i = 0; i < n; i++) {
            operations++;
            customersCount += customers[i];
            int curCustomers = Math.Min(customersCount, 4);
            customersCount -= curCustomers;
            totalProfit += boardingCost * curCustomers - runningCost;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
        }
        if (customersCount == 0) {
            return ans;
        }
        int profitEachTime = boardingCost * 4 - runningCost;
        if (profitEachTime <= 0) {
            return ans;
        }
        if (customersCount > 0) {
            int fullTimes = customersCount / 4;
            totalProfit += profitEachTime * fullTimes;
            operations += fullTimes;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
            int remainingCustomers = customersCount % 4;
            int remainingProfit = boardingCost * remainingCustomers - runningCost;
            totalProfit += remainingProfit;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                operations++;
                ans++;
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minOperationsMaxProfit(int* customers, int customersSize, int boardingCost, int runningCost) {
    int ans = -1;
    int maxProfit = 0;
    int totalProfit = 0;
    int operations = 0;
    int customersCount = 0;
    int n = customersSize;
    for (int i = 0; i < n; i++) {
        operations++;
        customersCount += customers[i];
        int curCustomers = MIN(customersCount, 4);
        customersCount -= curCustomers;
        totalProfit += boardingCost * curCustomers - runningCost;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            ans = operations;
        }
    }
    if (customersCount == 0) {
        return ans;
    }
    int profitEachTime = boardingCost * 4 - runningCost;
    if (profitEachTime <= 0) {
        return ans;
    }
    if (customersCount > 0) {
        int fullTimes = customersCount / 4;
        totalProfit += profitEachTime * fullTimes;
        operations += fullTimes;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            ans = operations;
        }
        int remainingCustomers = customersCount % 4;
        int remainingProfit = boardingCost * remainingCustomers - runningCost;
        totalProfit += remainingProfit;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            operations++;
            ans++;
        }
    }
    return ans;
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minOperationsMaxProfit(vector<int>& customers, int boardingCost, int runningCost) {
        int ans = -1;
        int maxProfit = 0;
        int totalProfit = 0;
        int operations = 0;
        int customersCount = 0;
        int n = customers.size();
        for (int i = 0; i < n; i++) {
            operations++;
            customersCount += customers[i];
            int curCustomers = min(customersCount, 4);
            customersCount -= curCustomers;
            totalProfit += boardingCost * curCustomers - runningCost;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
        }
        if (customersCount == 0) {
            return ans;
        }
        int profitEachTime = boardingCost * 4 - runningCost;
        if (profitEachTime <= 0) {
            return ans;
        }
        if (customersCount > 0) {
            int fullTimes = customersCount / 4;
            totalProfit += profitEachTime * fullTimes;
            operations += fullTimes;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                ans = operations;
            }
            int remainingCustomers = customersCount % 4;
            int remainingProfit = boardingCost * remainingCustomers - runningCost;
            totalProfit += remainingProfit;
            if (totalProfit > maxProfit) {
                maxProfit = totalProfit;
                operations++;
                ans++;
            }
        }
        return ans;
    }
};
```

```JavaScript [sol1-JavaScript]
var minOperationsMaxProfit = function(customers, boardingCost, runningCost) {
    let ans = -1;
    let maxProfit = 0;
    let totalProfit = 0;
    let operations = 0;
    let customersCount = 0;
    const n = customers.length;
    for (let i = 0; i < n; i++) {
        operations++;
        customersCount += customers[i];
        let curCustomers = Math.min(customersCount, 4);
        customersCount -= curCustomers;
        totalProfit += boardingCost * curCustomers - runningCost;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            ans = operations;
        }
    }
    if (customersCount === 0) {
        return ans;
    }
    const profitEachTime = boardingCost * 4 - runningCost;
    if (profitEachTime <= 0) {
        return ans;
    }
    if (customersCount > 0) {
        const fullTimes = Math.floor(customersCount / 4);
        totalProfit += profitEachTime * fullTimes;
        operations += fullTimes;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            ans = operations;
        }
        const remainingCustomers = customersCount % 4;
        const remainingProfit = boardingCost * remainingCustomers - runningCost;
        totalProfit += remainingProfit;
        if (totalProfit > maxProfit) {
            maxProfit = totalProfit;
            operations++;
            ans++;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func minOperationsMaxProfit(customers []int, boardingCost, runningCost int) int {
    ans := -1
    var maxProfit, totalProfit, operations, customersCount int
    for _, c := range customers {
        operations++
        customersCount += c
        curCustomers := min(customersCount, 4)
        customersCount -= curCustomers
        totalProfit += boardingCost*curCustomers - runningCost
        if totalProfit > maxProfit {
            maxProfit = totalProfit
            ans = operations
        }
    }
    if customersCount == 0 {
        return ans
    }
    profitEachTime := boardingCost*4 - runningCost
    if profitEachTime <= 0 {
        return ans
    }
    if customersCount > 0 {
        fullTimes := customersCount / 4
        totalProfit += profitEachTime * fullTimes
        operations += fullTimes
        if totalProfit > maxProfit {
            maxProfit = totalProfit
            ans = operations
        }
        remainingCustomers := customersCount % 4
        remainingProfit := boardingCost*remainingCustomers - runningCost
        totalProfit += remainingProfit
        if totalProfit > maxProfit {
            maxProfit = totalProfit
            operations++
            ans++
        }
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{customers}$ 的长度。遍历数组一次计算第一阶段的最大利润与最小轮转次数，时间复杂度是 $O(n)$，第二阶段的最大利润与最小轮转次数的计算的时间复杂度是 $O(1)$。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。