## [1798.你能构造出连续值的最大数目 中文官方题解](https://leetcode.cn/problems/maximum-number-of-consecutive-values-you-can-make/solutions/100000/ni-neng-gou-zao-chu-lian-xu-zhi-de-zui-d-wci4)

#### 方法一：贪心

**思路与算法**

题目给出一个下标从 $0$ 开始长度为 $n$ 的整数数组 $\textit{coins}$，表示我们拥有 $n$ 个硬币。第 $i$ 个硬币的值为 $\textit{coins}[i]$，$0 \le i < n$。如果我们能从这些硬币中选出一部分硬币，它们的和为 $x$，则表示我们可以构造出 $x$。现在我们需要返回我们能构造出从 $0$ 开始（包括 $0$）的多少个连续整数。

首先我们用 $[l, r]$，$0 \le l, r$ 表示一段连续的从 $l$ 到 $r$ 的连续整数区间，不妨设我们现在能构造出 $[0, x]$ 区间的整数，现在我们新增一个整数 $y$，那么我们可以构造出的区间为 $[0,x]$ 和 $[y, x + y]$，那么如果 $y \le x + 1$，则加入整数 $y$ 后我们能构造出 $[0, x + y]$ 区间的整数，否则我们还是只能构造出 $[0, x]$ 区间的数字。因此我们每次从数组中找到未选择数字中的最小值来作为 $y$，因为如果此时的最小值 $y$ 都不能更新区间 $[0, x]$，那么剩下的其他元素都不能更新区间 $[0, x]$。那么我们初始从 $x = 0$ 开始，按照升序来遍历数组 $\textit{nums}$ 的元素来作为 $y$，如果 $y \le x + 1$ 那么我们扩充区间为 $[0, x + y]$，否则我们无论选任何未选的数字都不能使答案区间变大，此时直接退出即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getMaximumConsecutive(vector<int>& coins) {
        int res = 1;
        sort(coins.begin(), coins.end());
        for (auto& i : coins) {
            if (i > res) {
                break;
            }
            res += i;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getMaximumConsecutive(int[] coins) {
        int res = 1;
        Arrays.sort(coins);
        for (int i : coins) {
            if (i > res) {
                break;
            }
            res += i;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GetMaximumConsecutive(int[] coins) {
        int res = 1;
        Array.Sort(coins);
        foreach (int i in coins) {
            if (i > res) {
                break;
            }
            res += i;
        }
        return res;
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int getMaximumConsecutive(int* coins, int coinsSize) {
    int res = 1;
    qsort(coins, coinsSize, sizeof(int), cmp);
    for (int i = 0; i < coinsSize; i++) {
        if (coins[i] > res) {
            break;
        }
        res += coins[i];
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var getMaximumConsecutive = function(coins) {
    let res = 1;
    coins.sort((a, b) => a - b);
    for (const i of coins) {
        if (i > res) {
            break;
        }
        res += i;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组 $\textit{coins}$ 的长度。主要为排序所需要的时间开销。
- 空间复杂度：$O(\log n)$。排序需要 $O(\log n)$ 的栈空间。