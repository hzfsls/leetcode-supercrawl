## [1414.和为 K 的最少斐波那契数字数目 中文官方题解](https://leetcode.cn/problems/find-the-minimum-number-of-fibonacci-numbers-whose-sum-is-k/solutions/100000/he-wei-k-de-zui-shao-fei-bo-na-qi-shu-zi-shu-mu-by)

#### 方法一：贪心

**思路**

首先找到所有不超过 $k$ 的斐波那契数字，然后每次贪心地选取不超过 $k$ 的最大斐波那契数字，将 $k$ 减去该斐波那契数字，重复该操作直到 $k$ 变为 $0$，此时选取的斐波那契数字满足和为 $k$ 且数目最少。

**证明**

为了证明上述方案选取的斐波那契数字数目最少，只需要证明存在一种选取斐波那契数字数目最少的方案，该方案选取了不超过 $k$ 的最大斐波那契数字。

1. 当选取斐波那契数字数目最少时，不可能选取两个相邻的斐波那契数。

   假设选取了两个相邻的斐波那契数字 $F_x$ 和 $F_{x + 1}$，则根据斐波那契数字的定义，这两个斐波那契数字之和为后一个斐波那契数字：

   $$F_{x + 2} = F_x + F_{x + 1}$$

   因此可以用 $F_{x + 2}$ 代替 $F_x$ 和 $F_{x + 1}$，选取的斐波那契数字的总和不变，选取的斐波那契数字的数目减少 $1$ 个，比选取 $F_x$ 和 $F_{x + 1}$ 的方案更优。

2. 一定存在一种选取斐波那契数字数目最少的方案，使得选取的每个斐波那契数字各不相同。

   假设 $F_x$ 被选取了两次。当 $x \le 2$ 时，$F_x = 1$，可以用 $F_3 = 2$ 代替两个 $F_x$，此时选取的斐波那契数字的数目减少 $1$ 个。当 $x > 2$ 时，存在以下关系：

   $$2 \times F_x = (F_{x - 2} + F_{x - 1}) + F_x = F_{x - 2} + (F_{x - 1} + F_x) = F_{x - 2} + F_{x + 1}$$

   因此当 $x > 2$ 时，如果 $F_x$ 被选取了两次，则可以换成 $F_{x - 2}$ 和 $F_{x + 1}$。

3. 根据上述两个结论，必须选取不超过 $k$ 的最大斐波那契数字，才能使得选取的斐波那契数字满足和为 $k$ 且数目最少。

   用 $F_m$ 表示不超过 $k$ 的最大斐波那契数字。如果不选择 $F_m$，则考虑选取的斐波那契数字之和可能的最大值，记为 $N$。根据上述两个结论，选取的斐波那契数字中不存在相邻的斐波那契数字，也不存在重复的斐波那契数字，因此可以得到 $N$ 的表达式：

   $$
   N = \begin{cases}
   F_{m - 1} + F_{m - 3} + \ldots + F_4 + F_2, &m~是奇数 \\
   F_{m - 1} + F_{m - 3} + \ldots + F_3 + F_1, &m~是偶数
   \end{cases}
   $$

   当 $m$ 是奇数时，$N$ 的值计算如下：

   $$
   \begin{aligned}
   N &= F_{m - 1} + F_{m - 3} + \ldots + F_4 + F_2 \\
   &= F_{m - 1} + F_{m - 3} + \ldots + F_4 + F_2 + F_1 - F_1 \\
   &= F_{m - 1} + F_{m - 3} + \ldots + F_4 + F_3 - F_1 \\
   &= F_{m - 1} + F_{m - 3} + \ldots + F_5 - F_1 \\
   &= \ldots \\
   &= F_{m - 1} + F_{m - 2} - F_1 \\
   &= F_m - 1 \\
   &< F_m
   \end{aligned}
   $$

   此时 $N < F_m$，由于 $F_m \le k$，因此 $N < k$。如果不选择 $F_m$，则选取的斐波那契数字之和一定小于 $k$，因此必须选择 $F_m$。

   当 $m$ 是偶数时，$N$ 的值计算如下：

   $$
   \begin{aligned}
   N &= F_{m - 1} + F_{m - 3} + \ldots + F_3 + F_1 \\
   &= F_{m - 1} + F_{m - 3} + \ldots + F_3 + F_2 \\
   &= F_{m - 1} + F_{m - 3} + \ldots + F_4 \\
   &= \ldots \\
   &= F_{m - 1} + F_{m - 2} \\
   &= F_m
   \end{aligned}
   $$

   此时 $N = F_m$，$\dfrac{m}{2}$ 个斐波那契数字之和等于 $F_m$，用一个 $F_m$ 替换 $\dfrac{m}{2}$ 个斐波那契数字，选取的斐波那契数字数目不变或减少（只有当 $m = 2$ 时，选取的斐波那契数字数目不变）。

   综上所述，无论 $m$ 是奇数还是偶数，都需要选取 $F_m$，即不超过 $k$ 的最大斐波那契数字，才能使得选取的斐波那契数字满足和为 $k$ 且数目最少。

**代码**

```Python [sol1-Python3]
class Solution:
    def findMinFibonacciNumbers(self, k: int) -> int:
        f = [1, 1]
        while f[-1] < k:
            f.append(f[-1] + f[-2])
        ans, i = 0, len(f) - 1
        while k:
            if k >= f[i]:
                k -= f[i]
                ans += 1
            i -= 1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int findMinFibonacciNumbers(int k) {
        List<Integer> f = new ArrayList<Integer>();
        f.add(1);
        int a = 1, b = 1;
        while (a + b <= k) {
            int c = a + b;
            f.add(c);
            a = b;
            b = c;
        }
        int ans = 0;
        for (int i = f.size() - 1; i >= 0 && k > 0; i--) {
            int num = f.get(i);
            if (k >= num) {
                k -= num;
                ans++;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMinFibonacciNumbers(int k) {
        IList<int> f = new List<int>();
        f.Add(1);
        int a = 1, b = 1;
        while (a + b <= k) {
            int c = a + b;
            f.Add(c);
            a = b;
            b = c;
        }
        int ans = 0;
        for (int i = f.Count - 1; i >= 0 && k > 0; i--) {
            int num = f[i];
            if (k >= num) {
                k -= num;
                ans++;
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findMinFibonacciNumbers(int k) {
        vector<int> f;
        f.emplace_back(1);
        int a = 1, b = 1;
        while (a + b <= k) {
            int c = a + b;
            f.emplace_back(c);
            a = b;
            b = c;
        }
        int ans = 0;
        for (int i = f.size() - 1; i >= 0 && k > 0; i--) {
            int num = f[i];
            if (k >= num) {
                k -= num;
                ans++;
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
int findMinFibonacciNumbers(int k){
    int f[100];
    int pos = 0;
    f[pos++] = 1;
    int a = 1, b = 1;
    while (a + b <= k) {
        int c = a + b;
        f[pos++] = c;
        a = b;
        b = c;
    }
    int ans = 0;
    for (int i = pos - 1; i >= 0 && k > 0; i--) {
        int num = f[i];
        if (k >= num) {
            k -= num;
            ans++;
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func findMinFibonacciNumbers(k int) (ans int) {
    f := []int{1, 1}
    for f[len(f)-1] < k {
        f = append(f, f[len(f)-1]+f[len(f)-2])
    }
    for i := len(f) - 1; k > 0; i-- {
        if k >= f[i] {
            k -= f[i]
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findMinFibonacciNumbers = function(k) {
    const f = [1];
    let a = 1, b = 1;
    while (a + b <= k) {
        let c = a + b;
        f.push(c);
        a = b;
        b = c;
    }
    let ans = 0;
    for (let i = f.length - 1; i >= 0 && k > 0; i--) {
        const num = f[i];
        if (k >= num) {
            k -= num;
            ans++;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\log k)$，其中 $k$ 为给定的整数。需要找到所有不超过 $k$ 的斐波那契数字，然后计算和为 $k$ 的最少斐波那契数字数目，不超过 $k$ 的斐波那契数字的个数是 $O(\log k)$ 个。

- 空间复杂度：$O(\log k)$，其中 $k$ 为给定的整数。需要 $O(\log k)$ 的空间存储所有不超过 $k$ 的斐波那契数字。