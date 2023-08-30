#### 方法一：贪心

**思路与算法**

不妨设 $a \le b \le c$，那么题目可以分解为两种情况：

1. $a + b \le c$，在这种情况下可以将 $a$ 和 $b$ 中的每一个石子与 $c$ 中的配对。答案为 $a + b$。
2. $a + b \gt c$，在这种情况下将 $c$ 中的所有石子与 $a$ 或 $b$ 中的石子配对，配对过程中总是优先匹配 $a$ 和 $b$ 中较大的那一个，最终 $a$ 和 $b$ 大小相等或相差 $1$。然后 $a$ 和 $b$ 中剩下的两两配对即可。为了表示结果，我们设 $a$ 与 $c$ 配对了 $k_1$ 次，$b$ 与 $c$ 配对了 $k_2$ 次，并且 $k_1 + k_2 = c$，因此答案为：$(k_1+k_2) + \left\lfloor \dfrac{(a-k_1)+(b-k_2)}{2} \right\rfloor$，化简后可得 $\left\lfloor \dfrac{a + b + c}{2} \right\rfloor$。

因为上面假设了 $a \le b \le c$，代码中实际上只关心 $a + b$ 的值以及 $c$ 的值，所以可以用 $\max(a, b, c)$ 求出排序后的 $c$，$a + b + c - \max(a, b, c)$ 求出排序后的 $a + b$。

**代码**

```Python [sol1-Python3]
class Solution:
    def maximumScore(self, a: int, b: int, c: int) -> int:
        s = a + b + c
        max_val = max(a, b, c)
        return s - max_val if s < max_val * 2 else s // 2
```

```C++ [sol1-C++]
class Solution {
public:
    int maximumScore(int a, int b, int c) {
        int sum = a + b + c;
        int maxVal = max({a, b, c});
        if (sum - maxVal < maxVal) {
            return sum - maxVal;
        } else {
            return sum / 2;
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumScore(int a, int b, int c) {
        int sum = a + b + c;
        int maxVal = Math.max(Math.max(a, b), c);
        return Math.min(sum - maxVal, sum / 2);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumScore(int a, int b, int c) {
        int sum = a + b + c;
        int maxVal = Math.Max(Math.Max(a, b), c);
        return Math.Min(sum - maxVal, sum / 2);
    }
}
```

```go [sol1-Golang]
func maximumScore(a, b, c int) int {
	sum := a + b + c
	maxVal := max(max(a, b), c)
	if sum < maxVal*2 {
		return sum - maxVal
	} else {
		return sum / 2
	}
}

func max(a, b int) int {
	if b > a {
		return b
	}
	return a
}
```

```JavaScript [sol1-JavaScript]
var maximumScore = function(a, b, c) {
    const sum = a + b + c;
    const maxVal = Math.max(Math.max(a, b), c);
    return Math.min(sum - maxVal, Math.floor(sum / 2));
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maximumScore(int a, int b, int c) {
    int sum = a + b + c;
    int maxVal = MAX(a, MAX(b, c));
    return MIN(sum - maxVal, sum / 2);
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。