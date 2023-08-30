#### 方法一：贪心

设所有洗衣机内的衣服个数之和为 $\textit{tot}$，要使最终所有洗衣机内的衣服个数相同，那么 $\textit{tot}$ 必须是 $n$ 的倍数，否则我们直接返回 $-1$。

记 $\textit{avg}=\dfrac{\textit{tot}}{n}$，定义 $\textit{machines}[i]'=\textit{machines}[i]-\textit{avg}$，若 $\textit{machines}[i]'$ 为正则说明需要移出 $\textit{machines}[i]'$ 件衣服，为负则说明需要移入 $-\textit{machines}[i]'$ 件衣服。

将前 $i$ 台洗衣机看成一组，记作 $A$，其余洗衣机看成另一组，记作 $B$。设 $\textit{sum}[i]=\sum_{j=0}^i \textit{machines}[j]'$，若 $\textit{sum}[i]$ 为正则说明需要从 $A$ 向 $B$ 移入 $\textit{sum}[i]$ 件衣服，为负则说明需要从 $B$ 向 $A$ 移入 $-\textit{sum}[i]$ 件衣服。

我们分两种情况来考虑操作步数：

1. $A$ 与 $B$ 两组之间的衣服，最多需要 $\max_{i=0}^{n-1}|\textit{sum}[i]|$ 次衣服移动；
2. 组内的某一台洗衣机内的衣服数量过多，需要向左右两侧移出衣服，这最多需要 $\max_{i=0}^{n-1}\textit{machines}[i]'$ 次衣服移动。

取两者的最大值即为答案。

```Python [sol1-Python3]
class Solution:
    def findMinMoves(self, machines: List[int]) -> int:
        tot = sum(machines)
        n = len(machines)
        if tot % n:
            return -1
        avg = tot // n
        ans, s = 0, 0
        for num in machines:
            num -= avg
            s += num
            ans = max(ans, abs(s), num)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int findMinMoves(vector<int> &machines) {
        int tot = accumulate(machines.begin(), machines.end(), 0);
        int n = machines.size();
        if (tot % n) {
            return -1;
        }
        int avg = tot / n;
        int ans = 0, sum = 0;
        for (int num: machines) {
            num -= avg;
            sum += num;
            ans = max(ans, max(abs(sum), num));
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findMinMoves(int[] machines) {
        int tot = Arrays.stream(machines).sum();
        int n = machines.length;
        if (tot % n != 0) {
            return -1;
        }
        int avg = tot / n;
        int ans = 0, sum = 0;
        for (int num : machines) {
            num -= avg;
            sum += num;
            ans = Math.max(ans, Math.max(Math.abs(sum), num));
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMinMoves(int[] machines) {
        int tot = machines.Sum();
        int n = machines.Length;
        if (tot % n != 0) {
            return -1;
        }
        int avg = tot / n;
        int ans = 0, sum = 0;
        foreach (int num in machines) {
            int tmp = num - avg;
            sum += tmp;
            ans = Math.Max(ans, Math.Max(Math.Abs(sum), tmp));
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func findMinMoves(machines []int) (ans int) {
    tot := 0
    for _, v := range machines {
        tot += v
    }
    n := len(machines)
    if tot%n > 0 {
        return -1
    }
    avg := tot / n
    sum := 0
    for _, num := range machines {
        num -= avg
        sum += num
        ans = max(ans, max(abs(sum), num))
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var findMinMoves = function(machines) {
    const tot = eval(machines.join('+'));
    const n = machines.length;
    if (tot % n !== 0) {
        return -1;
    }
    let avg = Math.floor(tot / n);
    let ans = 0, sum = 0;
    for (let num of machines) {
        num -= avg;
        sum += num;
        ans = Math.max(ans, Math.max(Math.abs(sum), num));
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{machines}$ 的长度。

- 空间复杂度：$O(1)$。只需要常数的空间存放若干变量。