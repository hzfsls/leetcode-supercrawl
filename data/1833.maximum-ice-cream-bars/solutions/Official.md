#### 方法一：排序 + 贪心

在给定硬币数量 $\textit{coins}$ 的情况下，要买到最多的雪糕，应该买最便宜的雪糕，理由如下。

> 假设购买最便宜的雪糕，在总价格不超过 $\textit{coins}$ 的情况下最多可以购买 $k$ 支雪糕。如果将 $k$ 支最便宜的雪糕中的任意一支雪糕替换成另一支雪糕，则替换后的雪糕的价格大于或等于替换前的雪糕的价格，因此替换后的总价格大于或等于替换前的总价格，允许购买的雪糕数量不可能超过 $k$。因此可以买到的雪糕的最大数量为 $k$。

由此可以得到贪心的解法：对数组 $\textit{costs}$ 排序，然后按照从小到大的顺序遍历数组元素，对于每个元素，如果该元素不超过剩余的硬币数，则将硬币数减去该元素值，表示购买了这支雪糕，当遇到一个元素超过剩余的硬币数时，结束遍历，此时购买的雪糕数量即为可以购买雪糕的最大数量。

```Java [sol1-Java]
class Solution {
    public int maxIceCream(int[] costs, int coins) {
        Arrays.sort(costs);
        int count = 0;
        int n = costs.length;
        for (int i = 0; i < n; i++) {
            int cost = costs[i];
            if (coins >= cost) {
                coins -= cost;
                count++;
            } else {
                break;
            }
        }
        return count;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxIceCream(int[] costs, int coins) {
        Array.Sort(costs);
        int count = 0;
        int n = costs.Length;
        for (int i = 0; i < n; i++) {
            int cost = costs[i];
            if (coins >= cost) {
                coins -= cost;
                count++;
            } else {
                break;
            }
        }
        return count;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxIceCream(vector<int>& costs, int coins) {
        sort(costs.begin(), costs.end());
        int count = 0;
        int n = costs.size();
        for (int i = 0; i < n; i++) {
            int cost = costs[i];
            if (coins >= cost) {
                coins -= cost;
                count++;
            } else {
                break;
            }
        }
        return count;
    }
};
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int maxIceCream(int *costs, int costsSize, int coins) {
    qsort(costs, costsSize, sizeof(int), cmp);
    int count = 0;
    int n = costsSize;
    for (int i = 0; i < n; i++) {
        int cost = costs[i];
        if (coins >= cost) {
            coins -= cost;
            count++;
        } else {
            break;
        }
    }
    return count;
}
```

```JavaScript [sol1-JavaScript]
var maxIceCream = function(costs, coins) {
    costs.sort((a, b) => a - b);
    let count = 0;
    const n = costs.length;
    for (let i = 0; i < n; i++) {
        const cost = costs[i];
        if (coins >= cost) {
            coins -= cost;
            count++;
        } else {
            break;
        }
    }
    return count;
};
```

```go [sol1-Golang]
func maxIceCream(costs []int, coins int) (ans int) {
    sort.Ints(costs)
    for _, c := range costs {
        if coins < c {
            break
        }
        coins -= c
        ans++
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{costs}$ 的长度。对数组排序的时间复杂度是 $O(n \log n)$，遍历数组的时间复杂度是 $O(n)$，因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{costs}$ 的长度。空间复杂度主要取决于排序使用的额外空间。

#### 方法二：计数排序 + 贪心

由于数组 $\textit{costs}$ 中的元素不会超过 $10^5$，因此可以使用计数排序，将时间复杂度降低到线性。

使用数组 $\textit{freq}$ 记录数组 $\textit{costs}$ 中的每个元素出现的次数，其中 $\textit{freq}[i]$ 表示元素 $i$ 在数组 $\textit{costs}$ 中出现的次数。仍然使用贪心的思想，买最便宜的雪糕，因此按照下标从小到大的顺序遍历数组 $\textit{freq}$，对于每个下标，如果该下标不超过剩余的硬币数，则根据下标值和该下标处的元素值计算价格为该下标的雪糕的可以购买的最大数量，然后将硬币数减去购买当前雪糕的花费，当遇到一个下标超过剩余的硬币数时，结束遍历，此时购买的雪糕数量即为可以购买雪糕的最大数量。

```Java [sol2-Java]
class Solution {
    public int maxIceCream(int[] costs, int coins) {
        int[] freq = new int[100001];
        for (int cost : costs) {
            freq[cost]++;
        }
        int count = 0;
        for (int i = 1; i <= 100000; i++) {
            if (coins >= i) {
                int curCount = Math.min(freq[i], coins / i);
                count += curCount;
                coins -= i * curCount;
            } else {
                break;
            }
        }
        return count;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxIceCream(int[] costs, int coins) {
        int[] freq = new int[100001];
        foreach (int cost in costs) {
            freq[cost]++;
        }
        int count = 0;
        for (int i = 1; i <= 100000; i++) {
            if (coins >= i) {
                int curCount = Math.Min(freq[i], coins / i);
                count += curCount;
                coins -= i * curCount;
            } else {
                break;
            }
        }
        return count;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxIceCream(vector<int>& costs, int coins) {
        vector<int> freq(100001);
        for (int& cost : costs) {
            freq[cost]++;
        }
        int count = 0;
        for (int i = 1; i <= 100000; i++) {
            if (coins >= i) {
                int curCount = min(freq[i], coins / i);
                count += curCount;
                coins -= i * curCount;
            } else {
                break;
            }
        }
        return count;
    }
};
```

```C [sol2-C]
int maxIceCream(int *costs, int costsSize, int coins) {
    int freq[100001];
    memset(freq, 0, sizeof(freq));
    for (int i = 0; i < costsSize; i++) {
        freq[costs[i]]++;
    }
    int count = 0;
    for (int i = 1; i <= 100000; i++) {
        if (coins >= i) {
            int curCount = fmin(freq[i], coins / i);
            count += curCount;
            coins -= i * curCount;
        } else {
            break;
        }
    }
    return count;
}
```

```JavaScript [sol2-JavaScript]
var maxIceCream = function(costs, coins) {
    const freq = new Array(100001).fill(0);
    for (const cost of costs) {
        freq[cost]++;
    }
    let count = 0;
    for (let i = 1; i <= 100000; i++) {
        if (coins >= i) {
            const curCount = Math.min(freq[i], Math.floor(coins / i));
            count += curCount;
            coins -= i * curCount;
        } else {
            break;
        }
    }
    return count;
};
```

```go [sol2-Golang]
func maxIceCream(costs []int, coins int) (ans int) {
    const mx int = 1e5
    freq := [mx + 1]int{}
    for _, c := range costs {
        freq[c]++
    }
    for i := 1; i <= mx && coins >= i; i++ {
        c := min(freq[i], coins/i)
        ans += c
        coins -= i * c
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $n$ 是数组 $\textit{costs}$ 的长度，$C$ 是数组 $\textit{costs}$ 中的元素的最大可能值，这道题中 $C=10^5$。

- 空间复杂度：$O(C)$，其中 $C$ 是数组 $\textit{costs}$ 中的元素的最大可能值，这道题中 $C=10^5$。需要使用 $O(C)$ 的空间记录数组 $\textit{costs}$ 中的每个元素的次数。