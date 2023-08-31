## [2100.适合打劫银行的日子 中文官方题解](https://leetcode.cn/problems/find-good-days-to-rob-the-bank/solutions/100000/gua-he-da-jie-yin-xing-de-ri-zi-by-leetc-z6r1)
#### 方法一：动态规划

**思路**

题目中第 $i$ 天适合打劫需满足：第 $i$ 天前连续 $\textit{time}$ 天警卫数目都是非递增与第 $i$ 天后连续 $\textit{time}$ 天警卫数目都是非递减。只需要预先计算出第 $i$ 天前警卫数目连续非递增的天数以及第 $i$ 天后警卫数目连续非递减的天数即可判断第 $i$ 天是否适合打劫。设第 $i$ 天前警卫数目连续非递增的天数为 $\textit{left}_i$，第 $i$ 天后警卫数目连续非递减的天数为 $\textit{right}_i$，当第 $i$ 天同时满足 $\textit{left}_i \ge \textit{time},\textit{right}_i \ge \textit{time}$ 时，即可认定第 $i$ 天适合打劫。计算连续非递增和非递减的天数的方法如下：

+ 如果第 $i$ 天的警卫数目小于等于第 $i-1$ 天的警卫数目，假设已知第 $i-1$ 天前有 $j$ 天连续非递增，则此时满足 $\textit{security}_{i-1} \le \textit{security}_{i-2} \cdots \le \textit{security}_{i-j-1}$，已知 $\textit{security}_i \le \textit{security}_{i-1}$，可推出 $\textit{security}_{i} \le \textit{security}_{i-1} \cdots \le \textit{security}_{i-j-1}$，则此时 $\textit{left}_i = j + 1 = \textit{left}_{i-1} + 1$；如果第 $i$ 天的警卫数目大于第 $i-1$ 天的警卫数目，则此时 $\textit{left}_i = 0$。

+ 如果第 $i$ 天的警卫数目小于等于第 $i+1$ 天的警卫数目，假设已知第 $i+1$ 天后有 $j$ 天连续非递减，则此时满足 $\textit{security}_{i+1} \le \textit{security}_{i+2} \cdots \le \textit{security}_{i+j+1}$，已知 $\textit{security}_i \le \textit{security}_{i+1}$，可推出 $\textit{security}_{i} \le \textit{security}_{i+1} \cdots \le \textit{security}_{i+j+1}$，则此时 $\textit{right}_i = j + 1 = \textit{right}_{i+1} + 1$；如果第 $i$ 天的警卫数目大于第 $i+1$ 天的警卫数目，则此时 $\textit{right}_i = 0$。

依次检测所有的日期，即可得到所有适合打劫的日子。

**代码**

```Python [sol1-Python3]
class Solution:
    def goodDaysToRobBank(self, security: List[int], time: int) -> List[int]:
        n = len(security)
        left = [0] * n
        right = [0] * n
        for i in range(1, n):
            if security[i] <= security[i - 1]:
                left[i] = left[i - 1] + 1
            if security[n - i - 1] <= security[n - i]:
                right[n - i - 1] = right[n - i] + 1
        return [i for i in range(time, n - time) if left[i] >= time and right[i] >= time]
```

```Java [sol1-Java]
class Solution {
    public List<Integer> goodDaysToRobBank(int[] security, int time) {
        int n = security.length;
        int[] left = new int[n];
        int[] right = new int[n];
        for (int i = 1; i < n; i++) {
            if (security[i] <= security[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (security[n - i - 1] <= security[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        List<Integer> ans = new ArrayList<>();
        for (int i = time; i < n - time; i++) {
            if (left[i] >= time && right[i] >= time) {
                ans.add(i);    
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> goodDaysToRobBank(vector<int>& security, int time) {
        int n = security.size();
        vector<int> left(n);
        vector<int> right(n);
        for (int i = 1; i < n; i++) {
            if (security[i] <= security[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (security[n - i - 1] <= security[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        vector<int> ans;
        for (int i = time; i < n - time; i++) {
            if (left[i] >= time && right[i] >= time) {
                ans.emplace_back(i);
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public IList<int> GoodDaysToRobBank(int[] security, int time) {
        int n = security.Length;
        int[] left = new int[n];
        int[] right = new int[n];
        for (int i = 1; i < n; i++) {
            if (security[i] <= security[i - 1]) {
                left[i] = left[i - 1] + 1;
            }
            if (security[n - i - 1] <= security[n - i]) {
                right[n - i - 1] = right[n - i] + 1;
            }
        }

        IList<int> ans = new List<int>();
        for (int i = time; i < n - time; i++) {
            if (left[i] >= time && right[i] >= time) {
                ans.Add(i);    
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int* goodDaysToRobBank(int* security, int securitySize, int time, int* returnSize) {
    int * left = (int *)malloc(sizeof(int) * securitySize);
    int * right = (int *)malloc(sizeof(int) * securitySize);
    memset(left, 0, sizeof(int) * securitySize);
    memset(right, 0, sizeof(int) * securitySize);
    for (int i = 1; i < securitySize; i++) {
        if (security[i] <= security[i - 1]) {
            left[i] = left[i - 1] + 1;
        }
        if (security[securitySize - i - 1] <= security[securitySize - i]) {
            right[securitySize - i - 1] = right[securitySize - i] + 1;
        }
    }

    int * ans = (int *)malloc(sizeof(int) * securitySize);
    int pos = 0;
    for (int i = time; i < securitySize - time; i++) {
        if (left[i] >= time && right[i] >= time) {
            ans[pos++] = i;
        }
    }
    free(left);
    free(right);
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var goodDaysToRobBank = function(security, time) {
    const n = security.length;
    const left = new Array(n).fill(0);
    const right = new Array(n).fill(0);
    for (let i = 1; i < n; i++) {
        if (security[i] <= security[i - 1]) {
            left[i] = left[i - 1] + 1;
        }
        if (security[n - i - 1] <= security[n - i]) {
            right[n - i - 1] = right[n - i] + 1;
        }
    }

    const ans = [];
    for (let i = time; i < n - time; i++) {
        if (left[i] >= time && right[i] >= time) {
            ans.push(i);    
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func goodDaysToRobBank(security []int, time int) (ans []int) {
    n := len(security)
    left := make([]int, n)
    right := make([]int, n)
    for i := 1; i < n; i++ {
        if security[i] <= security[i-1] {
            left[i] = left[i-1] + 1
        }
        if security[n-i-1] <= security[n-i] {
            right[n-i-1] = right[n-i] + 1
        }
    }

    for i := time; i < n-time; i++ {
        if left[i] >= time && right[i] >= time {
            ans = append(ans, i)
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{security}$ 的长度。需要遍历数组求出第 $i$ 天前连续非递增的天数与第 $i$ 天后连续非递减的天数，然后再遍历数组检测第 $i$ 天是否适合打劫。

- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{security}$ 的长度。需要 $O(n)$ 的空间来存储第 $i$ 天前连续非递增的天数与第 $i$ 天后连续非递减的天数。