## [2178.拆分成最多数目的正偶数之和 中文官方题解](https://leetcode.cn/problems/maximum-split-of-positive-even-integers/solutions/100000/chai-fen-cheng-zui-duo-shu-mu-de-ou-zhen-dntf)

#### 方法一：贪心

首先，如果 $\textit{finalSum}$ 为奇数，那么无法拆分为若干偶数，我们返回空数组即可。

其次，我们希望拆分成尽可能多的偶数，我们应该尽可能拆份成最小的若干个偶数。从**最小的偶整数** $2$ 开始依次尝试拆分，直到剩余的数值**小于等于**当前被拆分的**最大偶整数**为止。此时，我们已经拆分成尽可能多的偶数，不可能拆分出更多的互不相同的偶数。如果此时拆分后剩余的 $\textit{finalSum}$ 大于零，则将这个数值加到最大的偶整数上，从而保证所有的数互不相同。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<long long> maximumEvenSplit(long long finalSum) {
        vector<long long> res;
        if (finalSum % 2 > 0) {
            return res;
        }
        for (int i = 2; i <= finalSum; i += 2) {
            res.push_back(i);
            finalSum -= i;
        }
        res.back() += finalSum;
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Long> maximumEvenSplit(long finalSum) {
        List<Long> res = new ArrayList<>();
        if (finalSum % 2 > 0) {
            return res;
        }
        for (long i = 2; i <= finalSum; i += 2) {
            res.add(i);
            finalSum -= i;
        }
        res.set(res.size() - 1, res.get(res.size() - 1) + finalSum);
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maximumEvenSplit(self, finalSum: int) -> List[int]:
        res = []
        if finalSum % 2 > 0:
            return res
        i = 2
        while i <= finalSum:
            res.append(i)
            finalSum -= i
            i += 2
        res[-1] += finalSum
        return res
```

```Go [sol1-Go]
func maximumEvenSplit(finalSum int64) []int64 {
    var res []int64
    if finalSum % 2 > 0 {
        return res
    }
    for i := int64(2); i <= finalSum; i += 2 {
        res = append(res, i)
        finalSum -= i
    }
    res[len(res)-1] += finalSum
    return res
}
```

```JavaScript [sol1-JavaScript]
var maximumEvenSplit = function(finalSum) {
    const res = [];
    if (finalSum % 2 > 0) {
        return res;
    }
    for (let i = 2; i <= finalSum; i += 2) {
        res.push(i);
        finalSum -= i;
    }
    res[res.length - 1] += finalSum;
    return res;
};
```

```C# [sol1-C#]
public class Solution {
    public List<long> MaximumEvenSplit(long finalSum) {
        List<long> res = new List<long>();
        if (finalSum % 2 > 0) {
            return res;
        }
        for (int i = 2; i <= finalSum; i += 2) {
            res.Add(i);
            finalSum -= i;
        }
        res[res.Count - 1] += finalSum;
        return res;
    }
}
```

```C [sol1-C]
long long* maximumEvenSplit(long long finalSum, int* returnSize){
    long long* res = NULL;
    *returnSize = 0;
    if (finalSum % 2 > 0) {
        return res;
    }
    int k = sqrt(finalSum) + 1;
    res = (long long*)malloc(sizeof(long long) * k);
    for (int i = 2; i <= finalSum; i += 2) {
        res[++(*returnSize) - 1] = i;
        finalSum -= i;
    }
    res[(*returnSize) - 1] += finalSum;
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，即为拆分后的整数个数，其中 $n = \textit{finalSum}$。

   具体而言，若一个数想拆成 $k$ 个互不相同的偶数，则该数必定大于等于 $\sum_{i = 1}^k 2 \times i = k\times(k + 1)$，因此对于整数 $n$，可以拆分成的互不相同偶数个数最多大约为 $O(\sqrt{n})$ 个。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。