## [1281.整数的各位积和之差 中文官方题解](https://leetcode.cn/problems/subtract-the-product-and-sum-of-digits-of-an-integer/solutions/100000/zheng-shu-de-ge-wei-ji-he-zhi-chai-by-leetcode-sol)

#### 方法一：模拟

**思路与算法**

我们只需要依次取出数字 $n$ 中的各位数字，并计算各个数字的乘积 $m$ 以及数字和 $s$，最后返回 $m - s$ 即可。

我们可以依次取出 $n$ 的最低位来得到 $n$ 的各位数字：

- 通过「取模」操作 $n \bmod 10$ 得到此时 $n$ 的最低位。
- 通过「整除」操作 $n = \lfloor \frac{n}{10} \rfloor$ 来去掉当前 $n$ 的最低位。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int subtractProductAndSum(int n) {
        int m = 1, s = 0;
        while (n) {
            int x = n % 10;
            n /= 10;
            m *= x;
            s += x;
        }
        return m - s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int subtractProductAndSum(int n) {
        int m = 1, s = 0;
        while (n != 0) {
            int x = n % 10;
            n /= 10;
            m *= x;
            s += x;
        }
        return m - s;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SubtractProductAndSum(int n) {
        int m = 1, s = 0;
        while (n != 0) {
            int x = n % 10;
            n /= 10;
            m *= x;
            s += x;
        }
        return m - s;
    }
}
```

```Python [sol1-Python]
class Solution:
    def subtractProductAndSum(self, n: int) -> int:
        m, s = 1, 0
        while n != 0:
            x, n = n % 10, n // 10
            m *= x
            s += x
        return m - s
```

```Go [sol1-Go]
func subtractProductAndSum(n int) int {
    m := 1
    s := 0
    for n > 0 {
        x := n % 10
        n /= 10
        m *= x
        s += x
    }
    return m - s
}
```

```JavaScript [sol1-JavaScript]
var subtractProductAndSum = function(n) {
    let m = 1, s = 0;
    while (n > 0) {
        let x = n % 10;
        n = Math.floor(n / 10);
        m *= x;
        s += x;
    }
    return m - s;
}
```

```C [sol1-C]
int subtractProductAndSum(int n) {
    int m = 1, s = 0;
    while (n) {
        int x = n % 10;
        n /= 10;
        m *= x;
        s += x;
    }
    return m - s;
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 为题目给定的数字。
- 空间复杂度：$O(1)$，仅使用常量空间。