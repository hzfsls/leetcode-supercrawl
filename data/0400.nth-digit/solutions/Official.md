## [400.第 N 位数字 中文官方题解](https://leetcode.cn/problems/nth-digit/solutions/100000/di-n-wei-shu-zi-by-leetcode-solution-mdl2)

#### 方法一：二分查找

为了得到无限整数序列中的第 $n$ 位数字，需要知道第 $n$ 位数字是哪一个整数的第几位。如果知道第 $n$ 位数字所在整数是几位数，就能计算得到第 $n$ 位数字是哪一个整数的第几位。

假设第 $n$ 位数字所在整数是 $d$ 位数，则所有位数不超过 $d - 1$ 的整数的位数之和小于 $n$，且所有位数不超过 $d$ 的整数的位数之和大于等于 $n$。由于所有位数不超过 $x$ 的整数的位数之和关于 $x$ 单调递增，因此可以使用二分查找确定上述 $d$ 的值。对于某个 $x$，如果所有位数不超过 $x$ 的整数的位数之和小于 $n$，则 $d > x$，否则 $d \le x$，以此调整二分查找的上下界。

由于任何整数都至少是一位数，因此 $d$ 的最小值是 $1$。对于 $d$ 的上界，可以通过找规律的方式确定。

- $1$ 位数的范围是 $1$ 到 $9$，共有 $9$ 个数，所有 $1$ 位数的位数之和是 $1 \times 9 = 9$。
- $2$ 位数的取值范围是 $10$ 到 $99$，共有 $90$ 个数，所有 $2$ 位数的位数之和是 $2 \times 90 = 180$。
- $3$ 位数的取值范围是 $100$ 到 $999$，共有 $900$ 个数，所有 $3$ 位数的位数之和是 $3 \times 900 = 2700$。
- ……

推广到一般情形，$x$ 位数的范围是 $10^{x - 1}$ 到 $10^x - 1$，共有 $10^x - 1 - 10^{x - 1} + 1 = 9 \times 10^{x - 1}$ 个数，所有 $x$ 位数的位数之和是 $x \times 9 \times 10^{x - 1}$。

由于 $n$ 的最大值为 $2^{31} - 1$，约为 $2 \times 10^9$，当 $x = 9$ 时，$x \times 9 \times 10^{x - 1} = 8.1 \times 10^9 > 2^{31} - 1$，因此第 $n$ 位数字所在整数最多是 $9$ 位数，令 $d$ 的上界为 $9$ 即可。

在得到 $d$ 的值之后，可以根据上述规律计算得到所有位数不超过 $d - 1$ 的整数的位数之和，然后得到第 $n$ 位数在所有 $d$ 位数的序列中的下标，为了方便计算，将下标转换成从 $0$ 开始记数。具体而言，用 $\textit{prevDigits}$ 表示所有位数不超过 $d - 1$ 的整数的位数之和，则第 $n$ 位数在所有 $d$ 位数的序列中的下标是 $\textit{index} = n - \textit{prevDigits} - 1$，$\textit{index}$ 的最小可能取值是 $0$。

得到下标 $\textit{index}$ 之后，可以得到无限整数序列中的第 $n$ 位数字是第 $\Big\lfloor \dfrac{\textit{index}}{d} \Big\rfloor$ 个 $d$ 位数的第 $\textit{index} \bmod d$ 位，注意编号都从 $0$ 开始。

由于最小的 $d$ 位数是 $10^{d - 1}$，因此第 $n$ 位数字所在的整数是 $10^{d - 1} + \Big\lfloor \dfrac{\textit{index}}{d} \Big\rfloor$，该整数的右边第 $d - (\textit{index} \bmod d) - 1$ 位（计数从 $0$ 开始）即为无限整数序列中的第 $n$ 位数字。

```Java [sol1-Java]
class Solution {
    public int findNthDigit(int n) {
        int low = 1, high = 9;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (totalDigits(mid) < n) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        int d = low;
        int prevDigits = totalDigits(d - 1);
        int index = n - prevDigits - 1;
        int start = (int) Math.pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int) (Math.pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }

    public int totalDigits(int length) {
        int digits = 0;
        int curLength = 1, curCount = 9;
        while (curLength <= length) {
            digits += curLength * curCount;
            curLength++;
            curCount *= 10;
        }
        return digits;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindNthDigit(int n) {
        int low = 1, high = 9;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (TotalDigits(mid) < n) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        int d = low;
        int prevDigits = TotalDigits(d - 1);
        int index = n - prevDigits - 1;
        int start = (int) Math.Pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int) (Math.Pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }

    public int TotalDigits(int length) {
        int digits = 0;
        int curLength = 1, curCount = 9;
        while (curLength <= length) {
            digits += curLength * curCount;
            curLength++;
            curCount *= 10;
        }
        return digits;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findNthDigit(int n) {
        int low = 1, high = 9;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (totalDigits(mid) < n) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        int d = low;
        int prevDigits = totalDigits(d - 1);
        int index = n - prevDigits - 1;
        int start = (int) pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int) (pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }

    int totalDigits(int length) {
        int digits = 0;
        int curLength = 1, curCount = 9;
        while (curLength <= length) {
            digits += curLength * curCount;
            curLength++;
            curCount *= 10;
        }
        return digits;
    }
};
```

```JavaScript [sol1-JavaScript]
var findNthDigit = function(n) {
    let low = 1, high = 9;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (totalDigits(mid) < n) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    const d = low;
    const prevDigits = totalDigits(d - 1);
    const index = n - prevDigits - 1;
    const start = Math.floor(Math.pow(10, d - 1));
    const num = start + Math.floor(index / d);
    const digitIndex = index % d;
    const digit = Math.floor(num / Math.floor(Math.pow(10, d - digitIndex - 1))) % 10;
    return digit;
};

const totalDigits = (length) => {
    let digits = 0;
    let curLength = 1, curCount = 9;
    while (curLength <= length) {
        digits += curLength * curCount;
        curLength++;
        curCount *= 10;
    }
    return digits;
}
```

```go [sol1-Golang]
func totalDigits(length int) (digits int) {
    for curLength, curCount := 1, 9; curLength <= length; curLength++ {
        digits += curLength * curCount
        curCount *= 10
    }
    return
}

func findNthDigit(n int) int {
    d := 1 + sort.Search(8, func(length int) bool {
        return totalDigits(length+1) >= n
    })
    prevDigits := totalDigits(d - 1)
    index := n - prevDigits - 1
    start := int(math.Pow10(d - 1))
    num := start + index/d
    digitIndex := index % d
    return num / int(math.Pow10(d-digitIndex-1)) % 10
}
```

```Python [sol1-Python3]
class Solution:
    def totalDigits(self, length: int) -> int:
        digits = 0
        curCount = 9
        for curLength in range(1, length + 1):
            digits += curLength * curCount
            curCount *= 10
        return digits

    def findNthDigit(self, n: int) -> int:
        low, high = 1, 9
        while low < high:
            mid = (low + high) // 2
            if self.totalDigits(mid) < n:
                low = mid + 1
            else:
                high = mid
        d = low
        prevDigits = self.totalDigits(d - 1)
        index = n - prevDigits - 1
        start = 10 ** (d - 1)
        num = start + index // d
        digitIndex = index % d
        return num // 10 ** (d - digitIndex - 1) % 10
```

**复杂度分析**

- 时间复杂度：$O(\log_{10} n \times \log \log_{10} n)$。用 $D$ 表示位数的上限，则有 $D = O(\log_{10} n)$。二分查找的执行次数是 $O(\log D)$，每次执行的时间复杂度是 $O(D)$，因此总时间复杂度是 $O(D \log D) = O(\log_{10} n \times \log \log_{10} n)$。

- 空间复杂度：$O(1)$。

#### 方法二：直接计算

方法一使用二分查找得到第 $n$ 位数字所在整数是几位数。也可以不使用二分查找，而是直接根据规律计算。

已知 $x$ 位数共有 $9 \times 10^{x - 1}$ 个，所有 $x$ 位数的位数之和是 $x \times 9 \times 10^{x - 1}$。使用 $d$ 和 $\textit{count}$ 分别表示当前遍历到的位数和当前位数下的所有整数的位数之和，初始时 $d = 1$，$\textit{count} = 9$。每次将 $n$ 减去 $d \times \textit{count}$，然后将 $d$ 加 $1$，将 $\textit{count}$ 乘以 $10$，直到 $n \le d \times \textit{count}$，此时的 $d$ 是目标数字所在整数的位数，$n$ 是所有 $d$ 位数中从第一位到目标数字的位数。

为了方便计算目标数字，使用目标数字在所有 $d$ 位数中的下标进行计算，下标从 $0$ 开始计数。令 $\textit{index} = n - 1$，则 $\textit{index}$ 即为目标数字在所有 $d$ 位数中的下标，$\textit{index}$ 的最小可能取值是 $0$。

得到下标 $\textit{index}$ 之后，即可使用方法一的做法得到无限整数序列中的第 $n$ 位数字。

```Java [sol2-Java]
class Solution {
    public int findNthDigit(int n) {
        int d = 1, count = 9;
        while (n > (long) d * count) {
            n -= d * count;
            d++;
            count *= 10;
        }
        int index = n - 1;
        int start = (int) Math.pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int)(Math.pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindNthDigit(int n) {
        int d = 1, count = 9;
        while (n > (long) d * count) {
            n -= d * count;
            d++;
            count *= 10;
        }
        int index = n - 1;
        int start = (int) Math.Pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int) (Math.Pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int findNthDigit(int n) {
        int d = 1, count = 9;
        while (n > (long) d * count) {
            n -= d * count;
            d++;
            count *= 10;
        }
        int index = n - 1;
        int start = (int) pow(10, d - 1);
        int num = start + index / d;
        int digitIndex = index % d;
        int digit = (num / (int) (pow(10, d - digitIndex - 1))) % 10;
        return digit;
    }
};
```

```JavaScript [sol2-JavaScript]
var findNthDigit = function(n) {
    let d = 1, count = 9;
    while (n > d * count) {
        n -= d * count;
        d++;
        count *= 10;
    }
    const index = n - 1;
    const start = Math.floor(Math.pow(10, d - 1));
    const num = start + Math.floor(index / d);
    const digitIndex = index % d;
    const digit = Math.floor(num / Math.floor(Math.pow(10, d - digitIndex - 1))) % 10;
    return digit;
};
```

```go [sol2-Golang]
func findNthDigit(n int) int {
    d := 1
    for count := 9; n > d*count; count *= 10 {
        n -= d * count
        d++
    }
    index := n - 1
    start := int(math.Pow10(d - 1))
    num := start + index/d
    digitIndex := index % d
    return num / int(math.Pow10(d-digitIndex-1)) % 10
}
```

```Python [sol2-Python3]
class Solution:
    def findNthDigit(self, n: int) -> int:
        d, count = 1, 9
        while n > d * count:
            n -= d * count
            d += 1
            count *= 10
        index = n - 1
        start = 10 ** (d - 1)
        num = start + index // d
        digitIndex = index % d
        return num // 10 ** (d - digitIndex - 1) % 10
```

**复杂度分析**

- 时间复杂度：$O(\log_{10} n)$。用 $d$ 表示第 $n$ 位数字所在整数的位数，循环需要遍历 $d$ 次，由于 $d = O(\log_{10} n)$，因此时间复杂度是 $O(\log_{10} n)$。

- 空间复杂度：$O(1)$。