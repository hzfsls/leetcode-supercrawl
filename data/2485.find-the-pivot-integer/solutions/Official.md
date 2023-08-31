## [2485.找出中枢整数 中文官方题解](https://leetcode.cn/problems/find-the-pivot-integer/solutions/100000/zhao-chu-zhong-shu-zheng-shu-by-leetcode-t7gn)
#### 方法一：数学

**思路与算法** 

记从正整数 $x$ 加到正整数 $y$，$y \ge x$ 的和为 

$$\textit{sum}(x, y) = x + (x + 1) + \cdots + y$$

由「等差数列求和公式」得

$$\textit{sum}(x, y) = \frac{(x + y) \times (y - x + 1)}{2}$$

则题目等价于给定一个正整数 $n$，判断是否存在正整数 $x$ 满足

$$\textit{sum}(1, x) = \textit{sum}(x, n)$$

进一步将上式化简得到

$$x = \sqrt{\frac{n^2 + n}{2}}$$

若 $x$ 不为整数则返回 $-1$，否则得到「中枢整数」$x$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int pivotInteger(int n) {
        int t = (n * n + n) / 2;
        int x = sqrt(t);
        if (x * x == t) {
            return x;
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int pivotInteger(int n) {
        int t = (n * n + n) / 2;
        int x = (int) Math.sqrt(t);
        if (x * x == t) {
            return x;
        }
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def pivotInteger(self, n: int) -> int:
        t = (n * n + n) // 2
        x = int(t ** 0.5)
        if x * x == t:
            return x
        return -1

```

```Go [sol1-Go]
func pivotInteger(n int) int {
    t := (n * n + n) / 2
    x := int(math.Sqrt(float64(t)))
    if x * x == t {
        return x
    }
    return -1
}
```

```JavaScript [sol1-JavaScript]
var pivotInteger = function(n) {
    let t = (n * n + n) / 2;
    let x = parseInt(Math.sqrt(t));
    if (x * x === t) {
        return x;
    }
    return -1;
};
```

```C# [sol1-C#]
public class Solution {
    public int PivotInteger(int n) {
        int t = (n * n + n) / 2;
        int x = (int) Math.Sqrt(t);
        if (x * x == t) {
            return x;
        }
        return -1;
    }
}
```

```C [sol1-C]
int pivotInteger(int n) {
    int t = (n * n + n) / 2;
    int x = sqrt(t);
    if (x * x == t) {
        return x;
    }
    return -1;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$，其中计算平方根有专门对应的 $\text{CPU}$ 指令，可看作 $O(1)$ 时间复杂度。
- 空间复杂度：$O(1)$，仅使用常量空间。