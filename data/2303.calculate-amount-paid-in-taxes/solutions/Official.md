## [2303.计算应缴税款总额 中文官方题解](https://leetcode.cn/problems/calculate-amount-paid-in-taxes/solutions/100000/ji-suan-ying-jiao-shui-kuan-zong-e-by-le-jv5s)

#### 方法一：直接模拟

**思路与算法**

设第 $i$ 个税级的上限是 $\textit{upper}_i$ ，征收的税率为 $\textit{percent}_i$。税级按上限从低到高排序且满足 $\textit{upper}_{i-1} < \textit{upper}_i$。

根据题意税款计算方式如下：
+ 不超过 $\textit{upper}_0$ 的收入按税率 $\textit{percent}_0$ 缴纳；
+ 接着处于 $[\textit{upper}_0,\textit{upper}_1]$ 的部分按税率 $\textit{percent}_1$ 缴纳；
+ 接着处于 $[\textit{upper}_1,\textit{upper}_2]$ 的部分按税率 $\textit{percent}_2$ 缴纳；
+ 以此类推；
  
给定的 $\textit{income}$ 表示总收入，依次计算 $\textit{income}$ 处于第 $i$ 个区间 $[\textit{upper}_{i-1},\textit{upper}_i]$ 之间的部分为 $\textit{pay}_i$，此时计算公式为 $\textit{pay}_i = \min(\textit{income},\textit{upper}_i) - \textit{upper}_{i-1}$，则在第 $i$ 个征税区间缴纳的税为 $\textit{tax}_i = \textit{pay}_i \times \textit{percent}_i$，则征税总额为 $\textit{totalTax} = \sum\limits_{i=0}^{n-1}\textit{tax}_i$。

其中第 $0$ 个征税区间为 $[0,\textit{upper}_i]$，为了计算方便可先进行整数累加，最后再进行浮点数除法计算。

**代码**

```Python [sol1-Python3]
class Solution:
    def calculateTax(self, brackets: List[List[int]], income: int) -> float:
        totalTax = lower = 0
        for upper, percent in brackets:
            tax = (min(income, upper) - lower) * percent
            totalTax += tax
            if income <= upper:
                break
            lower = upper
        return totalTax / 100
```

```C++ [sol1-C++]
class Solution {
public:
    double calculateTax(vector<vector<int>>& brackets, int income) {
        double totalTax = 0;
        int lower = 0;
        for (auto &bracket: brackets) {
            int upper = bracket[0], percent = bracket[1];
            int tax = (min(income, upper) - lower) * percent;
            totalTax += tax;
            if (income <= upper) {
                break;
            }
            lower = upper;
        }
        return (double)totalTax / 100.0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public double calculateTax(int[][] brackets, int income) {
        double totalTax = 0;
        int lower = 0;
        for (int[] bracket : brackets) {
            int upper = bracket[0], percent = bracket[1];
            int tax = (Math.min(income, upper) - lower) * percent;
            totalTax += tax;
            if (income <= upper) {
                break;
            }
            lower = upper;
        }
        return (double) totalTax / 100.0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double CalculateTax(int[][] brackets, int income) {
        double totalTax = 0;
        int lower = 0;
        foreach (int[] bracket in brackets) {
            int upper = bracket[0], percent = bracket[1];
            int tax = (Math.Min(income, upper) - lower) * percent;
            totalTax += tax;
            if (income <= upper) {
                break;
            }
            lower = upper;
        }
        return (double) totalTax / 100.0;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

double calculateTax(int** brackets, int bracketsSize, int* bracketsColSize, int income) {
    int totalTax = 0, lower = 0;
    for (int i = 0; i < bracketsSize; i++) {
        int upper = brackets[i][0], percent = brackets[i][1];
        int tax = (MIN(income, upper) - lower) * percent;
        totalTax += tax;
        if (income <= upper) {
            break;
        }
        lower = upper;
    }
    return (double) totalTax / 100.0;
}
```

```JavaScript [sol1-JavaScript]
var calculateTax = function(brackets, income) {
    let totalTax = 0;
    let lower = 0;
    for (const bracket of brackets) {
        const upper = bracket[0], percent = bracket[1];
        const tax = (Math.min(income, upper) - lower) * percent;
        totalTax += tax;
        if (income <= upper) {
            break;
        }
        lower = upper;
    }
    return totalTax / 100.0;
};
```

```go [sol1-Golang]
func calculateTax(brackets [][]int, income int) float64 {
    totalTax := 0
    lower := 0
    for _, bracket := range brackets {
        upper, percent := bracket[0], bracket[1]
        tax := (min(income, upper) - lower) * percent
        totalTax += tax
        if income <= upper {
            break
        }
        lower = upper
    }
    return float64(totalTax) / 100
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示数组的长度。我们只需要遍历一遍数组即可。

- 空间复杂度：$O(1)$。