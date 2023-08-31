## [2413.最小偶倍数 中文官方题解](https://leetcode.cn/problems/smallest-even-multiple/solutions/100000/zui-xiao-ou-bei-shu-by-leetcode-solution-vy2o)
#### 方法一：数学

**思路与算法**

对于任意两个正整数 $n$，$m$ 的最小公倍数为 $\frac{n \times m}{\gcd(n, m)}$，其中 $\gcd(n, m)$ 为 $n$ 和 $m$ 的最大公约数。

现在题目给出一个正数 $n$，需要返回 $2$ 和 $n$ 的最小公倍数，又因为任意正偶数与 $2$ 的最大公约数为 $2$，任意正奇数与 $2$ 的最大公约数为 $1$。所以当 $n$ 为偶数时直接返回 $n$，否则返回 $2 \times n$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int smallestEvenMultiple(int n) {
        return n % 2 == 0 ? n : 2 * n;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int smallestEvenMultiple(int n) {
        return n % 2 == 0 ? n : 2 * n;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def smallestEvenMultiple(self, n: int) -> int:
        return n if n % 2 == 0 else n * 2
```

```C# [sol1-C#]
public class Solution {
    public int SmallestEvenMultiple(int n) {
        return n % 2 == 0 ? n : 2 * n;
    }
}
```

```C [sol1-C]
int smallestEvenMultiple(int n) {
    return n % 2 == 0 ? n : 2 * n;
}
```

```Go [sol1-Go]
func smallestEvenMultiple(n int) int {
    if n % 2 == 0 {
        return n
    } else {
        return n * 2
    }
}
```

```JavaScript [sol1-JavaScript]
var smallestEvenMultiple = function(n) {
    return n % 2 == 0 ? n : n * 2;
};
```
**复杂度分析**

- 时间复杂度：$O(1)$。仅需要判断一次 $n$ 的奇偶性。
- 空间复杂度：$O(1)$。