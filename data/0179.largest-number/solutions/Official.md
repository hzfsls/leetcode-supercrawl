#### 方法一：排序

**思路与算法**

要想组成最大的整数，一种直观的想法是把数值大的数放在高位。于是我们可以比较输入数组的每个元素的最高位，最高位相同的时候比较次高位，以此类推，完成排序，然后把它们拼接起来。这种排序方式对于输入数组 **没有相同数字开头** 的时候是有效的，例如 $[45, 56, 81, 76, 123]$。

下面考虑输入数组 **有相同数字开头** 的情况，例如 $[4,42]$ 和 $[4,45]$。

+ 对于 $[4,42]$，比较 $442 > 424$，需要把 $4$ 放在前面；
+ 对于 $[4,45]$，比较 $445 < 454$，需要把 $45$ 放在前面。

因此我们需要比较两个数不同的拼接顺序的结果，进而决定它们在结果中的排列顺序。

由于需要拼接以后才能决定两个数在结果中的先后顺序，$N$ 个数就有 $N!$ 种拼接的可能，我们是不是需要先得到 $N$ 个数的全排列以后，再选出最大的呢？答案是没有必要。上述排序规则满足传递性，两个元素比较就可以确定它们在排序以后的相对位置关系。下面证明这种排序规则的必要性和充分性。

**证明**

定义一种非负整数集合上的二元运算，记作 $\oplus$，它表示将两个数拼接后的结果。

具体地，我们令 $s(x)$ 表示大于非负整数 $x$ 的最小的十的整次幂（即当 $x>0$ 时 $s(x)=10^{\lfloor \log_{10}x\rfloor + 1}$，特别地，$s(0) = 10$），那么 $x \oplus y = x \times s(y) + y$。显然这样的运算不满足交换律，但是满足结合律。

然后我们定义一个非负整数集合上的二元关系，记作 $\Theta$。当一个数 $x$ 排在数 $y$ 前面更优时（即 $x \oplus y \geq y \oplus x$），我们认为 $x \Theta y$。

我们知道，一个序列要能够正确地自定义排序，需要这种排序规则满足传递性（如果 $a \Theta b$ 且 $b \Theta c$ 则 $a \Theta c$）和完全性（即 $a \Theta b$ 或 $b \Theta a$ 必满足其一）。只要证明了传递性和完全性，即可证明该排序规则的必要性，完全性很容易证明，传递性证明如下：

由 $a \Theta b$ 且 $b \Theta c$ 可知：

1. $a \times s(b) + b \geq b \times s(a) + a$
2. $b \times s(c) + c \geq c \times s(b) + b$

移项整理得：

1. $a \times (s(b) - 1) \geq b \times (s(a) - 1)$
2. $b \times (s(c) - 1) \geq c \times (s(b) - 1)$

两式的左右两边均非负，因此由两式相乘可得：

$a \times b \times (s(b) - 1) \times (s(c) - 1) \geq b \times c \times (s(a) - 1) \times (s(b) - 1)$

不等式两边都有 $b$，根据 $b$ 是否为 $0$ 分类讨论：

1. 当 $b = 0$ 时：

   - 将 $b = 0$ 代入 $b \Theta c$ 可知：$c \geq c \times 10$，即 $c = 0$；

   - 当 $c = 0$ 时，有 $a \times s(c) + c \geq c \times s(a) +a$，恰符合 $a \Theta c$ 的定义。

2. 当 $b > 0$ 时：

   - $b \times (s(b) - 1)) > 0$；

   - 不等式两边同时除以 $b \times (s(b) - 1))$，化简得：$a \times (s(c) - 1) \geq c \times (s(a) - 1)$，恰符合 $a \Theta c$ 的定义。

综上，有 $a \Theta c$。

最后我们证明该排序规则的充分性：假设存在一个最优序列不满足该排序规则，那么必然存在至少一对相邻数字 $a$ 与 $b$，我们将 $a$ 与 $b$ 交换后新序列的值必然增加，与假设矛盾。因此，满足该排序规则是该序列最优的充分条件。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string largestNumber(vector<int> &nums) {
        sort(nums.begin(), nums.end(), [](const int &x, const int &y) {
            long sx = 10, sy = 10;
            while (sx <= x) {
                sx *= 10;
            }
            while (sy <= y) {
                sy *= 10;
            }
            return sy * x + y > sx * y + x;
        });
        if (nums[0] == 0) {
            return "0";
        }
        string ret;
        for (int &x : nums) {
            ret += to_string(x);
        }
        return ret;
    }
};
```
```Java [sol1-Java]
class Solution {
    public String largestNumber(int[] nums) {
        int n = nums.length;
        // 转换成包装类型，以便传入 Comparator 对象（此处为 lambda 表达式）
        Integer[] numsArr = new Integer[n];
        for (int i = 0; i < n; i++) {
            numsArr[i] = nums[i];
        }

        Arrays.sort(numsArr, (x, y) -> {
            long sx = 10, sy = 10;
            while (sx <= x) {
                sx *= 10;
            }
            while (sy <= y) {
                sy *= 10;
            }
            return (int) (-sy * x - y + sx * y + x);
        });

        if (numsArr[0] == 0) {
            return "0";
        }
        StringBuilder ret = new StringBuilder();
        for (int num : numsArr) {
            ret.append(num);
        }
        return ret.toString();
    }
}
```
```JavaScript [sol1-JavaScript]
var largestNumber = function(nums) {
    nums.sort((x, y) => {
        let sx = 10, sy = 10;
        while (sx <= x) {
            sx *= 10;
        }
        while (sy <= y) {
            sy *= 10;
        }
        return '' + (sx * y + x) - ('' + (sy * x + y));
    })
    if (nums[0] === 0) {
        return '0';
    }
    return nums.join('');
};
```

```go [sol1-Golang]
func largestNumber(nums []int) string {
    sort.Slice(nums, func(i, j int) bool {
        x, y := nums[i], nums[j]
        sx, sy := 10, 10
        for sx <= x {
            sx *= 10
        }
        for sy <= y {
            sy *= 10
        }
        return sy*x+y > sx*y+x
    })
    if nums[0] == 0 {
        return "0"
    }
    ans := []byte{}
    for _, x := range nums {
        ans = append(ans, strconv.Itoa(x)...)
    }
    return string(ans)
}
```

```C [sol1-C]
long cmp(int *x, int *y) {
    long sx = 10, sy = 10;
    while (sx <= *x) {
        sx *= 10;
    }
    while (sy <= *y) {
        sy *= 10;
    }
    return sx * (*y) + (*x) - sy * (*x) - (*y);
}

char *largestNumber(int *nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    if (nums[0] == 0) {
        char *ret = malloc(sizeof(char) * 2);
        ret[0] = '0', ret[1] = '\0';
        return "0";
    }
    char *ret = malloc(sizeof(char) * 1000);
    char *p = ret;
    for (int i = 0; i < numsSize; i++) {
        sprintf(p, "%d", nums[i]);
        p += strlen(p);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n \log m)$，其中 $n$ 是给定序列的长度，$m$ 是 $32$ 位整数的最大值，每个数转化为字符串后的长度是 $O(\log m)$ 的数量级。排序比较函数的时间复杂度为 $O(\log m)$，共需要进行 $O(n \log n)$ 次比较。同时我们需要对字符串序列进行拼接，时间复杂度为 $O(n \log m)$，在渐进意义上小于 $O(n \log n \log m)$。

    - 我们也可以对排序比较函数进行优化，如预处理出数组每一个数的大于它的最小的十的整次幂，这样可用将时间复杂度降低到 $O(n \log n)$，但这样会使得空间复杂度上升到 $O(n)$。我们也可以使用数学方法加速计算整次幂，如二分计算等，但这种优化常数较大，最终耗时不一定更短。

- 空间复杂度：$O(\log n)$，排序需要 $O(\log n)$ 的栈空间。