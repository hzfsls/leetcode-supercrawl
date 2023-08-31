## [1672.最富有客户的资产总量 中文官方题解](https://leetcode.cn/problems/richest-customer-wealth/solutions/100000/zui-fu-you-ke-hu-de-zi-chan-zong-liang-b-8p06)

#### 方法一：遍历

**思路与算法**

分别计算每位客户在各家银行托管的资产数量之和，返回这些资产总量的最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def maximumWealth(self, accounts: List[List[int]]) -> int:
        return max(map(sum, accounts))
```

```C++ [sol1-C++]
class Solution {
public:
    int maximumWealth(vector<vector<int>>& accounts) {
        int maxWealth = INT_MIN;
        for (auto &account : accounts) {
            maxWealth = max(maxWealth, accumulate(account.begin(), account.end(), 0));
        }
        return maxWealth;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumWealth(int[][] accounts) {
        int maxWealth = Integer.MIN_VALUE;
        for (int[] account : accounts) {
            maxWealth = Math.max(maxWealth, Arrays.stream(account).sum());
        }
        return maxWealth;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumWealth(int[][] accounts) {
        int maxWealth = int.MinValue;
        foreach (int[] account in accounts) {
            maxWealth = Math.Max(maxWealth, account.Sum());
        }
        return maxWealth;
    }
}
```

```go [sol1-Golang]
func maximumWealth(accounts [][]int) (ans int) {
    for _, account := range accounts {
        sum := 0
        for _, val := range account {
            sum += val
        }
        if sum > ans {
            ans = sum
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var maximumWealth = function(accounts) {
    let maxWealth = -Number.MAX_VALUE;
    for (const account of accounts) {
        maxWealth = Math.max(maxWealth, account.reduce((a, b) => a + b));
    }
    return maxWealth;
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maximumWealth(int** accounts, int accountsSize, int* accountsColSize){
    int maxWealth = INT_MIN;
    for (int i = 0; i < accountsSize; i++) {
        int sum = 0;
        for (int j = 0; j < accountsColSize[0]; j++) {
            sum += accounts[i][j];
        }
        maxWealth = MAX(maxWealth, sum);
    }
    return maxWealth;
}
```

**复杂度分析**

+ 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{accounts}$ 的行数和列数。

+ 空间复杂度：$O(1)$。