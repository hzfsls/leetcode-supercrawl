#### 方法一：模拟构造

根据题目描述，数组 $\textit{rolls}$ 的长度为 $m$，记录了 $m$ 个观测数据，还有 $n$ 个观测数据缺失，共有 $n + m$ 个观测数据。由于所有观测数据的平均值为 $\textit{mean}$，因此所有观测数据之和为 $\textit{mean} \times (n + m)$。

根据所有观测数据之和与数组 $\textit{rolls}$ 中的 $m$ 个观测数据，可知缺失的 $n$ 个观测数据之和。将缺失的 $n$ 个观测数据之和记为 $\textit{missingSum}$。

由于每次观测数据的范围是 $1$ 到 $6$，因此如果存在符合要求的答案，则一定有 $n \le \textit{missingSum} \le 6 \times n$。如果 $\textit{missingSum}$ 不在上述范围内，则不存在符合要求的答案，返回空数组。

当 $\textit{missingSum}$ 满足 $n \le \textit{missingSum} \le 6 \times n$ 时，一定存在一种符合要求的答案，由 $n$ 个在 $[1, 6]$ 范围内的整数组成且这 $n$ 个整数之和为 $\textit{missingSum}$。记 $\textit{quotient} = \Big\lfloor \dfrac{\textit{missingSum}}{n} \Big\rfloor$，$\textit{remainder} = \textit{missingSum} \bmod n$，则可以构造一种符合要求的答案：在缺失的 $n$ 个观测数据中，有 $\textit{remainder}$ 个观测数据是 $\textit{quotient} + 1$，其余观测数据都是 $\textit{quotient}$。

```Python [sol1-Python3]
class Solution:
    def missingRolls(self, rolls: List[int], mean: int, n: int) -> List[int]:
        missingSum = mean * (n + len(rolls)) - sum(rolls)
        if not n <= missingSum <= n * 6:
            return []
        quotient, remainder = divmod(missingSum, n)
        return [quotient + 1] * remainder + [quotient] * (n - remainder)
```

```Java [sol1-Java]
class Solution {
    public int[] missingRolls(int[] rolls, int mean, int n) {
        int m = rolls.length;
        int sum = mean * (n + m);
        int missingSum = sum;
        for (int roll : rolls) {
            missingSum -= roll;
        }
        if (missingSum < n || missingSum > 6 * n) {
            return new int[0];
        }
        int quotient = missingSum / n, remainder = missingSum % n;
        int[] missing = new int[n];
        for (int i = 0; i < n; i++) {
            missing[i] = quotient + (i < remainder ? 1 : 0);
        }
        return missing;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] MissingRolls(int[] rolls, int mean, int n) {
        int m = rolls.Length;
        int sum = mean * (n + m);
        int missingSum = sum;
        foreach (int roll in rolls) {
            missingSum -= roll;
        }
        if (missingSum < n || missingSum > 6 * n) {
            return new int[0];
        }
        int quotient = missingSum / n, remainder = missingSum % n;
        int[] missing = new int[n];
        for (int i = 0; i < n; i++) {
            missing[i] = quotient + (i < remainder ? 1 : 0);
        }
        return missing;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> missingRolls(vector<int>& rolls, int mean, int n) {
        int m = rolls.size();
        int sum = mean * (n + m);
        int missingSum = sum;
        for (int & roll : rolls) {
            missingSum -= roll;
        }
        if (missingSum < n || missingSum > 6 * n) {
            return {};
        }
        int quotient = missingSum / n, remainder = missingSum % n;
        vector<int> missing(n);
        for (int i = 0; i < n; i++) {
            missing[i] = quotient + (i < remainder ? 1 : 0);
        }
        return missing;
    }
};
```

```C [sol1-C]
int* missingRolls(int* rolls, int rollsSize, int mean, int n, int* returnSize){
    int m = rollsSize;
    int sum = mean * (n + m);
    int missingSum = sum;
    for (int i = 0; i < m; i++) {
        missingSum -= rolls[i];
    }
    if (missingSum < n || missingSum > 6 * n) {
        *returnSize = 0;
        return NULL;
    }
    int quotient = missingSum / n, remainder = missingSum % n;
    int * missing = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        missing[i] = quotient + (i < remainder ? 1 : 0);
    }
    *returnSize = n;
    return missing;
}
```

```JavaScript [sol1-JavaScript]
var missingRolls = function(rolls, mean, n) {
    const m = rolls.length;
    const sum = mean * (n + m);
    let missingSum = sum;
    for (const roll of rolls) {
        missingSum -= roll;
    }
    if (missingSum < n || missingSum > 6 * n) {
        return [];
    }
    const quotient = Math.floor(missingSum / n), remainder = missingSum % n;
    const missing = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        missing[i] = quotient + (i < remainder ? 1 : 0);
    }
    return missing;
};
```

```go [sol1-Golang]
func missingRolls(rolls []int, mean, n int) []int {
    missingSum := mean * (n + len(rolls))
    for _, roll := range rolls {
        missingSum -= roll
    }
    if missingSum < n || missingSum > n*6 {
        return nil
    }

    quotient, remainder := missingSum/n, missingSum%n
    ans := make([]int, n)
    for i := range ans {
        ans[i] = quotient
        if i < remainder {
            ans[i]++
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 是缺失的观测数据个数，$m$ 是数组 $\textit{rolls}$ 的长度，即已知的观测数据个数。需要 $O(m)$ 的时间计算缺失的观测数据之和，需要 $O(n)$ 的时间构造答案。

- 空间复杂度：$O(1)$。除了返回值以外，使用的额外空间为 $O(1)$。