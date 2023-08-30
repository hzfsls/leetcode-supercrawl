#### 方法一：贪心 + 二分查找

**思路**

根据题意，需要构造一个长度为 $n$ 的数组 $\textit{nums}$，所有元素均为正整数，元素之和不超过 $\textit{maxSum}$，相邻元素之差不超过 $1$，且需要最大化 $\textit{nums}[\textit{index}]$。根据贪心的思想，可以使 $\textit{nums}[\textit{index}]$ 成为数组最大的元素，并使其他元素尽可能小，即从 $\textit{nums}[\textit{index}]$ 开始，往左和往右，下标每相差 $1$，元素值就减少 $1$，直到到达数组边界，或者减少到仅为 $1$ 后保持为 $1$ 不变。

根据这个思路，一旦 $\textit{nums}[\textit{index}]$ 确定后，这个数组的和 $\textit{numsSum}$ 也就确定了。并且 $\textit{nums}[\textit{index}]$ 越大，数组和 $\textit{numsSum}$ 也越大。据此，可以使用二分搜索来找出最大的使得 $\textit{numsSum} \leq \textit{maxSum}$ 成立的 $\textit{nums}[\textit{index}]$。

代码实现上，二分搜索的左边界为 $1$，右边界为 $\textit{maxSum}$。函数 $\textit{valid}$ 用来判断当前的 $\textit{nums}[\textit{index}]$ 对应的 $\textit{numsSum}$ 是否满足条件。$\textit{numsSum}$ 由三部分组成，$\textit{nums}[\textit{index}]$，$\textit{nums}[\textit{index}]$ 左边的部分之和，和 $\textit{nums}[\textit{index}]$ 右边的部分之和。$\textit{cal}$ 用来计算单边的元素和，需要考虑边界元素是否早已下降到 $1$ 的情况。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxValue(self, n: int, index: int, maxSum: int) -> int: 
        left, right = 1, maxSum
        while left < right:
            mid = (left + right + 1) // 2
            if self.valid(mid, n, index, maxSum):
                left = mid
            else:
                right = mid - 1
        return left

    def valid(self, mid: int, n: int, index: int, maxSum: int) -> bool:
        left = index
        right = n - index - 1
        return mid + self.cal(mid, left) + self.cal(mid, right) <= maxSum

    def cal(self, big: int, length: int) -> int:
        if length + 1 < big:
            small = big - length
            return ((big - 1 + small) * length) // 2
        else:
            ones = length - (big - 1)
            return (big - 1 + 1) * (big - 1) // 2 + ones
```

```Java [sol1-Java]
class Solution {
    public int maxValue(int n, int index, int maxSum) {
        int left = 1, right = maxSum;
        while (left < right) {
            int mid = (left + right + 1) / 2;
            if (valid(mid, n, index, maxSum)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    public boolean valid(int mid, int n, int index, int maxSum) {
        int left = index;
        int right = n - index - 1;
        return mid + cal(mid, left) + cal(mid, right) <= maxSum;
    }

    public long cal(int big, int length) {
        if (length + 1 < big) {
            int small = big - length;
            return (long) (big - 1 + small) * length / 2;
        } else {
            int ones = length - (big - 1);
            return (long) big * (big - 1) / 2 + ones;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxValue(int n, int index, int maxSum) {
        int left = 1, right = maxSum;
        while (left < right) {
            int mid = (left + right + 1) / 2;
            if (Valid(mid, n, index, maxSum)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    public bool Valid(int mid, int n, int index, int maxSum) {
        int left = index;
        int right = n - index - 1;
        return mid + Cal(mid, left) + Cal(mid, right) <= maxSum;
    }

    public long Cal(int big, int length) {
        if (length + 1 < big) {
            int small = big - length;
            return (long) (big - 1 + small) * length / 2;
        } else {
            int ones = length - (big - 1);
            return (long) big * (big - 1) / 2 + ones;
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxValue(int n, int index, int maxSum) {
        int left = 1, right = maxSum;
        while (left < right) {
            int mid = (left + right + 1) / 2;
            if (valid(mid, n, index, maxSum)) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }

    bool valid(int mid, int n, int index, int maxSum) {
        int left = index;
        int right = n - index - 1;
        return mid + cal(mid, left) + cal(mid, right) <= maxSum;
    }

    long cal(int big, int length) {
        if (length + 1 < big) {
            int small = big - length;
            return (long) (big - 1 + small) * length / 2;
        } else {
            int ones = length - (big - 1);
            return (long) big * (big - 1) / 2 + ones;
        }
    }
};
```

```C [sol1-C]
long cal(int big, int length) {
    if (length + 1 < big) {
        int small = big - length;
        return (long) (big - 1 + small) * length / 2;
    } else {
        int ones = length - (big - 1);
        return (long) big * (big - 1) / 2 + ones;
    }
}

bool valid(int mid, int n, int index, int maxSum) {
    int left = index;
    int right = n - index - 1;
    return mid + cal(mid, left) + cal(mid, right) <= maxSum;
}

int maxValue(int n, int index, int maxSum) {
    int left = 1, right = maxSum;
    while (left < right) {
        int mid = (left + right + 1) / 2;
        if (valid(mid, n, index, maxSum)) {
            left = mid;
        } else {
            right = mid - 1;
        }
    }
    return left;
}
```

```JavaScript [sol1-JavaScript]
var maxValue = function(n, index, maxSum) {
    let left = 1, right = maxSum;
    while (left < right) {
        const mid = Math.floor((left + right + 1) / 2);
        if (valid(mid, n, index, maxSum)) {
            left = mid;
        } else {
            right = mid - 1;
        }
    }
    return left;
}

const valid = (mid, n, index, maxSum) => {
    let left = index;
    let right = n - index - 1;
    return mid + cal(mid, left) + cal(mid, right) <= maxSum;
}

const cal = (big, length) => {
    if (length + 1 < big) {
        const small = big - length;
        return Math.floor((big - 1 + small) * length / 2);
    } else {
        const ones = length - (big - 1);
        return Math.floor(big * (big - 1) / 2) + ones;
    }
};
```

```go [sol1-Golang]
func f(big, length int) int {
    if length == 0 {
        return 0
    }
    if length <= big {
        return (2*big + 1 - length) * length / 2
    }
    return (big+1)*big/2 + length - big
}

func maxValue(n, index, maxSum int) int {
    return sort.Search(maxSum, func(mid int) bool {
        left := index
        right := n - index - 1
        return mid+f(mid, left)+f(mid, right) >= maxSum
    })
}
```

**复杂度分析**

- 时间复杂度：$O(\lg (\textit{maxSum}))$。二分搜索上下界的差为 $\textit{maxSum}$。

- 空间复杂度：$O(1)$，仅需要常数空间。

#### 方法二：数学推导

**思路**

仍然按照方法一的贪心思路，根据方法一的推导，$\textit{nums}[\textit{index}]$ 左边或者右边的元素和，要分情况讨论。记 $\textit{nums}[\textit{index}]$ 为 $\text{big}$，它离数组的某个边界的距离为 $\textit{length}$。当 $\text{big} \leq \textit{length+1}$ 时，还未到达边界附近时，元素值就已经降为 $1$，并保持为 $1$ 直到到达数组边界，此时这部分的元素和为 $\dfrac{\textit{big}^2-3\textit{big}}{2}+\textit{length}+1$。否则，元素会呈现出梯形的形状，此时这部分的元素和为 $\dfrac{(2\textit{big}-\textit{length}-1)\times\textit{length}}{2}$。

$\textit{numsSum}$ 由三部分组成，$\textit{nums}[\textit{index}]$，$\textit{nums}[\textit{index}]$ 左边的部分之和，和 $\textit{nums}[\textit{index}]$ 右边的部分之和。记 $\textit{nums}[\textit{index}]$ 左边的元素个数为 $\textit{left}= \textit{index}$，右边的元素个数为 $\textit{right} = n-1-\textit{index}$。根据对称性，不妨设 $\textit{left} \leq \textit{right}$。这样一来，$\textit{numsSum}$ 的组成可以用三种情况来表示。即:

 - $\textit{big} \leq \textit{left+1}$，$\textit{numsSum} = \dfrac{\textit{big}^2-3\textit{big}}{2}+\textit{left}+1 + \textit{big} + \dfrac{\textit{big}^2-3\textit{big}}{2}+\textit{right}+1$
 - $\textit{left+1} \lt \textit{big} \leq \textit{right+1}$, $\textit{numsSum} = \dfrac{(2\textit{big}-\textit{left}-1)\times\textit{left}}{2} + \textit{big} + \dfrac{\textit{big}^2-3\textit{big}}{2}+\textit{right}+1$
 - $\textit{right+1} \lt \textit{big}$, $\textit{numsSum} = \dfrac{(2\textit{big}-\textit{left}-1)\times\textit{left}}{2} + \textit{big} + \dfrac{(2\textit{big}-\textit{right}-1)\times\textit{right}}{2}$

对于前两种情况，我们可以分别求出上限，如果上限不超过 $\textit{maxSum}$，则可以通过解一元二次方程来求出 $\textit{big}$。否则需要根据第三种情况解一元一次方程来求 $\textit{big}$。


**代码**

```Python [sol2-Python3]
class Solution:
    def maxValue(self, n: int, index: int, maxSum: int) -> int: 
        left = index
        right = n - index - 1
        if left > right:
            left, right = right, left

        upper = ((left + 1) ** 2 - 3 * (left + 1)) // 2 + left + 1 + (left + 1) + ((left + 1) ** 2 - 3 * (left + 1)) // 2 + right + 1
        if upper >= maxSum:
            a = 1
            b = -2
            c = left + right + 2 - maxSum
            return floor(((-b + (b ** 2 - 4 * a * c) ** 0.5) / (2 * a)))

        upper = (2 * (right + 1) - left - 1) * left // 2 + (right + 1) + ((right + 1) ** 2 - 3 * (right + 1)) // 2 + right + 1
        if upper >= maxSum:
            a = 1/2
            b = left + 1 - 3/2
            c = right + 1 + (-left - 1) * left / 2 - maxSum
            return floor(((-b + (b ** 2 - 4 * a * c) ** 0.5) / (2 * a)))

        else:
            a = left + right + 1
            b = (-left ** 2 - left - right ** 2 - right) / 2 - maxSum
            return floor(-b / a)
```

```Java [sol2-Java]
class Solution {
    public int maxValue(int n, int index, int maxSum) {
        double left = index;
        double right = n - index - 1;
        if (left > right) {
            double temp = left;
            left = right;
            right = temp;
        }

        double upper = ((double) (left + 1) * (left + 1) - 3 * (left + 1)) / 2 + left + 1 + (left + 1) + ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1;
            double b = -2;
            double c = left + right + 2 - maxSum;
            return (int) Math.floor((-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a));
        }

        upper = ((double) 2 * (right + 1) - left - 1) * left / 2 + (right + 1) + ((right + 1) * (right + 1) - 3 * (right + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1.0 / 2;
            double b = left + 1 - 3.0 / 2;
            double c = right + 1 + (-left - 1) * left / 2 - maxSum;
            return (int) Math.floor((-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a));
        } else {
            double a = left + right + 1;;
            double b = (-left * left - left - right * right - right) / 2 - maxSum;
            return (int) Math.floor(-b / a);
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxValue(int n, int index, int maxSum) {
        double left = index;
        double right = n - index - 1;
        if (left > right) {
            double temp = left;
            left = right;
            right = temp;
        }

        double upper = ((double) (left + 1) * (left + 1) - 3 * (left + 1)) / 2 + left + 1 + (left + 1) + ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1;
            double b = -2;
            double c = left + right + 2 - maxSum;
            return (int) Math.Floor((-b + Math.Sqrt(b * b - 4 * a * c)) / (2 * a));
        }

        upper = ((double) 2 * (right + 1) - left - 1) * left / 2 + (right + 1) + ((right + 1) * (right + 1) - 3 * (right + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1.0 / 2;
            double b = left + 1 - 3.0 / 2;
            double c = right + 1 + (-left - 1) * left / 2 - maxSum;
            return (int) Math.Floor((-b + Math.Sqrt(b * b - 4 * a * c)) / (2 * a));
        } else {
            double a = left + right + 1;;
            double b = (-left * left - left - right * right - right) / 2 - maxSum;
            return (int) Math.Floor(-b / a);
        }
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxValue(int n, int index, int maxSum) {
        double left = index;
        double right = n - index - 1;
        if (left > right) {
            double temp = left;
            left = right;
            right = temp;
        }

        double upper = ((double) (left + 1) * (left + 1) - 3 * (left + 1)) / 2 + left + 1 + (left + 1) + ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1;
            double b = -2;
            double c = left + right + 2 - maxSum;
            return (int) floor((-b + sqrt(b * b - 4 * a * c)) / (2 * a));
        }

        upper = ((double) 2 * (right + 1) - left - 1) * left / 2 + (right + 1) + ((right + 1) * (right + 1) - 3 * (right + 1)) / 2 + right + 1;
        if (upper >= maxSum) {
            double a = 1.0 / 2;
            double b = left + 1 - 3.0 / 2;
            double c = right + 1 + (-left - 1) * left / 2 - maxSum;
            return (int) floor((-b + sqrt(b * b - 4 * a * c)) / (2 * a));
        } else {
            double a = left + right + 1;;
            double b = (-left * left - left - right * right - right) / 2 - maxSum;
            return (int) floor(-b / a);
        }
    }
};
```

```C [sol2-C]
int maxValue(int n, int index, int maxSum) {
    double left = index;
    double right = n - index - 1;
    if (left > right) {
        double temp = left;
        left = right;
        right = temp;
    }

    double upper = ((double) (left + 1) * (left + 1) - 3 * (left + 1)) / 2 + left + 1 + (left + 1) + ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + right + 1;
    if (upper >= maxSum) {
        double a = 1;
        double b = -2;
        double c = left + right + 2 - maxSum;
        return (int) floor((-b + sqrt(b * b - 4 * a * c)) / (2 * a));
    }

    upper = ((double) 2 * (right + 1) - left - 1) * left / 2 + (right + 1) + ((right + 1) * (right + 1) - 3 * (right + 1)) / 2 + right + 1;
    if (upper >= maxSum) {
        double a = 1.0 / 2;
        double b = left + 1 - 3.0 / 2;
        double c = right + 1 + (-left - 1) * left / 2 - maxSum;
        return (int) floor((-b + sqrt(b * b - 4 * a * c)) / (2 * a));
    } else {
        double a = left + right + 1;;
        double b = (-left * left - left - right * right - right) / 2 - maxSum;
        return (int) floor(-b / a);
    }
}
```

```JavaScript [sol2-JavaScript]
var maxValue = function(n, index, maxSum) {
    let left = index;
    let right = n - index - 1;
    if (left > right) {
        let temp = left;
        left = right;
        right = temp;
    }

    let upper = ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + left + 1 + (left + 1) + ((left + 1) * (left + 1) - 3 * (left + 1)) / 2 + right + 1;
    if (upper >= maxSum) {
        let a = 1;
        let b = -2;
        let c = left + right + 2 - maxSum;
        return Math.floor((-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a));
    }

    upper = (2 * (right + 1) - left - 1) * left / 2 + (right + 1) + ((right + 1) * (right + 1) - 3 * (right + 1)) / 2 + right + 1;
    if (upper >= maxSum) {
        let a = 1.0 / 2;
        let b = left + 1 - 3.0 / 2;
        let c = right + 1 + (-left - 1) * left / 2 - maxSum;
        return Math.floor((-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a));
    } else {
        let a = left + right + 1;;
        let b = (-left * left - left - right * right - right) / 2 - maxSum;
        return Math.floor(-b / a);
    }
};
```

```go [sol2-Golang]
func maxValue(n, index, maxSum int) int {
    left := index
    right := n - index - 1
    if left > right {
        left, right = right, left
    }

    upper := ((left+1)*(left+1)-3*(left+1))/2 + left + 1 + (left + 1) + ((left+1)*(left+1)-3*(left+1))/2 + right + 1
    if upper >= maxSum {
        a := 1.0
        b := -2.0
        c := float64(left + right + 2 - maxSum)
        return int((-b + math.Sqrt(b*b-4*a*c)) / (2 * a))
    }

    upper = (2*(right+1)-left-1)*left/2 + (right + 1) + ((right+1)*(right+1)-3*(right+1))/2 + right + 1
    if upper >= maxSum {
        a := 1.0 / 2
        b := float64(left) + 1 - 3.0/2
        c := float64(right + 1 + (-left-1)*left/2.0 - maxSum)
        return int((-b + math.Sqrt(b*b-4*a*c)) / (2 * a))
    } else {
        a := float64(left + right + 1)
        b := float64(-left*left-left-right*right-right)/2 - float64(maxSum)
        return int(-b / a)
    }
}
```

**复杂度分析**

- 时间复杂度：$O(1)$，仅使用常数时间。

- 空间复杂度：$O(1)$，仅使用常数空间。