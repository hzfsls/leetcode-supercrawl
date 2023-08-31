## [2600.K 件物品的最大和 中文官方题解](https://leetcode.cn/problems/k-items-with-the-maximum-sum/solutions/100000/k-jian-wu-pin-de-zui-da-he-by-leetcode-s-a97g)

#### 方法一：贪心

题目的物品分为 $1$，$0$ 和 $-1$ 三种，要想选出 $k$ 件物品，使得和最大，那么贪心地选择前 $k$ 大的物品是最优的。根据 $k$ 的取值，有情况：

+ $k \le \textit{numOnes}$，可以全部选择 $k$ 个 $1$，最大和为 $k$。

+ $\textit{numOnes} \lt k \le \textit{numOnes} + \textit{numZeros}$，可以选择全部的 $1$ 和部分 $0$，最大和为 $\textit{numOnes}$。

+ $\textit{numOnes} + \textit{numZeros} \lt k$，可以选择全部的 $1$ 和 $0$，选择部分的 $-1$（数目为 $k - \textit{numOnes} - \textit{numZeros}$），最大和为 $\textit{numOnes} - (k - \textit{numOnes} - \textit{numZeros})$。

```C++ [sol1-C++]
class Solution {
public:
    int kItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k) {
        if (k <= numOnes) {
            return k;
        } else if (k <= numOnes + numZeros) {
            return numOnes;
        } else {
            return numOnes - (k - numOnes - numZeros);
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int kItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k) {
        if (k <= numOnes) {
            return k;
        } else if (k <= numOnes + numZeros) {
            return numOnes;
        } else {
            return numOnes - (k - numOnes - numZeros);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int KItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k) {
        if (k <= numOnes) {
            return k;
        } else if (k <= numOnes + numZeros) {
            return numOnes;
        } else {
            return numOnes - (k - numOnes - numZeros);
        }
    }
}
```

```Golang [sol1-Golang]
func kItemsWithMaximumSum(numOnes int, numZeros int, numNegOnes int, k int) int {
    if k <= numOnes {
        return k
    } else if k <= numOnes + numZeros {
        return numOnes
    } else {
        return numOnes - (k - numOnes - numZeros)
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kItemsWithMaximumSum(self, numOnes: int, numZeros: int, numNegOnes: int, k: int) -> int:
        if k <= numOnes:
            return k
        elif k <= numOnes + numZeros:
            return numOnes
        else:
            return numOnes - (k - numOnes - numZeros)

```

```JavaScript [sol1-JavaScript]
var kItemsWithMaximumSum = function(numOnes, numZeros, numNegOnes, k) {
    if (k <= numOnes) {
        return k;
    } else if (k <= numOnes + numZeros) {
        return numOnes;
    } else {
        return numOnes - (k - numOnes - numZeros);
    }
};

```

```C [sol1-C]
int kItemsWithMaximumSum(int numOnes, int numZeros, int numNegOnes, int k){
    if (k <= numOnes) {
        return k;
    } else if (k <= numOnes + numZeros) {
        return numOnes;
    } else {
        return numOnes - (k - numOnes - numZeros);
    }
}
```

**复杂度分析**

+ 时间复杂度：$O(1)$。

+ 空间复杂度：$O(1)$。