#### 前言

读者需要注意的题目中的一个小陷阱：**我们是从第 $0$ 天开始吃糖果**。因此对于第 $i$ 个询问，我们可以吃 $\textit{favoriteDay}_i+1$ 天的糖果。

#### 方法一：前缀和

**思路与算法**

对于第 $i$ 个询问 $(\textit{favoriteType}_i, \textit{favoriteDay}_i, \textit{dailyCap}_i)$，我们每天至少吃 $1$ 颗糖果，至多吃 $\textit{dailyCap}_i$ 颗糖果，因此我们吃的糖果的数量落在区间：

$$
\Big[ \textit{favoriteDay}_i+1, (\textit{favoriteDay}_i+1) \times \textit{dailyCap}_i \Big]
$$

内。那么只要这个区间包含了一颗第 $\textit{favoriteType}_i$ 种类型的糖果，就可以满足要求了。

因此我们求出糖果数量的前缀和，记录在数组 $\textit{sum}$ 中，那么第 $\textit{favoriteType}_i$ 种类型的糖果对应的编号范围为：

$$
\Big[ \textit{sum}[\textit{favoriteType}_i-1]+1, \textit{sum}[\textit{favoriteType}_i] \Big]
$$

特别地，如果 $\textit{favoriteType}_i$ 为 $0$，那么区间的左端点为 $1$。

我们只要判断这两个区间是否有交集即可。如果有交集，说明我们可以吃到第 $\textit{favoriteType}_i$ 类的糖果。判断是否有交集的方法如下：

> 对于区间 $[x_1, y_1]$ 以及 $[x_2, y_2]$，它们没有交集当且仅当 $x_1 > y_2$ 或者 $y_1 < x_2$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    using LL = long long;

public:
    vector<bool> canEat(vector<int>& candiesCount, vector<vector<int>>& queries) {
        int n = candiesCount.size();
        
        // 前缀和
        vector<LL> sum(n);
        sum[0] = candiesCount[0];
        for (int i = 1; i < n; ++i) {
            sum[i] = sum[i - 1] + candiesCount[i];
        }
        
        vector<bool> ans;
        for (const auto& q: queries) {
            int favoriteType = q[0], favoriteDay = q[1], dailyCap = q[2];
            
            LL x1 = favoriteDay + 1;
            LL y1 = (LL)(favoriteDay + 1) * dailyCap;
            LL x2 = (favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1);
            LL y2 = sum[favoriteType];
            
            ans.push_back(!(x1 > y2 || y1 < x2));
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean[] canEat(int[] candiesCount, int[][] queries) {
        int n = candiesCount.length;
        
        // 前缀和
        long[] sum = new long[n];
        sum[0] = candiesCount[0];
        for (int i = 1; i < n; ++i) {
            sum[i] = sum[i - 1] + candiesCount[i];
        }
        
        int q = queries.length;
        boolean[] ans = new boolean[q];
        for (int i = 0; i < q; ++i) {
            int[] query = queries[i];
            int favoriteType = query[0], favoriteDay = query[1], dailyCap = query[2];
            
            long x1 = favoriteDay + 1;
            long y1 = (long) (favoriteDay + 1) * dailyCap;
            long x2 = favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1;
            long y2 = sum[favoriteType];
            
            ans[i] = !(x1 > y2 || y1 < x2);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool[] CanEat(int[] candiesCount, int[][] queries) {
        int n = candiesCount.Length;
        
        // 前缀和
        long[] sum = new long[n];
        sum[0] = candiesCount[0];
        for (int i = 1; i < n; ++i) {
            sum[i] = sum[i - 1] + candiesCount[i];
        }
        
        int q = queries.Length;
        bool[] ans = new bool[q];
        for (int i = 0; i < q; ++i) {
            int[] query = queries[i];
            int favoriteType = query[0], favoriteDay = query[1], dailyCap = query[2];
            
            long x1 = favoriteDay + 1;
            long y1 = (long) (favoriteDay + 1) * dailyCap;
            long x2 = favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1;
            long y2 = sum[favoriteType];
            
            ans[i] = !(x1 > y2 || y1 < x2);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def canEat(self, candiesCount: List[int], queries: List[List[int]]) -> List[bool]:
        # 前缀和
        total = list(accumulate(candiesCount))
        
        ans = list()
        for favoriteType, favoriteDay, dailyCap in queries:
            x1 = favoriteDay + 1
            y1 = (favoriteDay + 1) * dailyCap
            x2 = 1 if favoriteType == 0 else total[favoriteType - 1] + 1
            y2 = total[favoriteType]
            
            ans.append(not(x1 > y2 or y1 < x2))
        
        return ans
```

```go [sol1-Golang]
func canEat(candiesCount []int, queries [][]int) []bool {
    n := len(candiesCount)

    // 前缀和
    sum := make([]int, n)
    sum[0] = candiesCount[0]
    for i := 1; i < n; i++ {
        sum[i] = sum[i-1] + candiesCount[i]
    }

    ans := make([]bool, len(queries))
    for i, q := range queries {
        favoriteType, favoriteDay, dailyCap := q[0], q[1], q[2]

        x1 := favoriteDay + 1
        y1 := (favoriteDay + 1) * dailyCap
        x2 := 1
        if favoriteType > 0 {
            x2 = sum[favoriteType-1] + 1
        }
        y2 := sum[favoriteType]

        ans[i] = !(x1 > y2 || y1 < x2)
    }
    return ans
}
```

```C [sol1-C]
bool* canEat(int* candiesCount, int candiesCountSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int n = candiesCountSize;

    // 前缀和
    long sum[n];
    sum[0] = candiesCount[0];
    for (int i = 1; i < n; ++i) {
        sum[i] = sum[i - 1] + candiesCount[i];
    }
    bool* ans = malloc(sizeof(bool) * queriesSize);
    *returnSize = queriesSize;
    for (int i = 0; i < queriesSize; i++) {
        int* q = queries[i];
        int favoriteType = q[0], favoriteDay = q[1], dailyCap = q[2];

        long x1 = favoriteDay + 1;
        long y1 = (long)(favoriteDay + 1) * dailyCap;
        long x2 = (favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1);
        long y2 = sum[favoriteType];

        ans[i] = !(x1 > y2 || y1 < x2);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var canEat = function(candiesCount, queries) {
    const n = candiesCount.length;
    
    // 前缀和
    const sum = new Array(n).fill(0);;
    sum[0] = candiesCount[0];
    for (let i = 1; i < n; ++i) {
        sum[i] = sum[i - 1] + candiesCount[i];
    }
    
    const q = queries.length;
    const ans = new Array(q).fill(0);
    for (let i = 0; i < q; ++i) {
        const query = queries[i];
        const favoriteType = query[0], favoriteDay = query[1], dailyCap = query[2];
        
        const x1 = favoriteDay + 1;
        const y1 = (favoriteDay + 1) * dailyCap;
        const x2 = favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1;
        const y2 = sum[favoriteType];
        
        ans[i] = !(x1 > y2 || y1 < x2);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n+q)$，其中 $n$ 和 $q$ 分别是数组 $\textit{candiesCount}$ 和 $\textit{queries}$ 的长度。我们需要 $O(n)$ 的时间计算前缀和，$O(q)$ 的时间得到所有询问的结果。

- 空间复杂度：$O(n)$，即为存储前缀和数组需要的空间。注意返回值不计入空间复杂度。