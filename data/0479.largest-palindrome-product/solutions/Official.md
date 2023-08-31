## [479.最大回文数乘积 中文官方题解](https://leetcode.cn/problems/largest-palindrome-product/solutions/100000/zui-da-hui-wen-shu-cheng-ji-by-leetcode-rcihq)
#### 方法一：枚举

我们可以从大到小枚举回文数，由于确定了回文数的左半部分，其右半部分也就确定了，因此我们只需要枚举左半部分，同时由于两个 $n$ 位整数的乘积至多是个 $2n$ 位数，我们可以从 $10^n-1$ 开始枚举回文数的左半部分。

得到回文数 $p$ 后，需要判断其能否分解成两个 $n$ 位整数。我们可以从 $10^n-1$ 开始从大到小枚举 $x$，若 $x$ 能整除 $p$ 且 $x$ 和 $\dfrac{p}{x}$ 均为 $n$ 位整数，则 $p$ 就是我们要找的答案。

代码实现时，在枚举 $x$ 时枚举到 $\lceil\sqrt{p}\rceil$ 即可，因为继续枚举的话有 $x<\dfrac{p}{x}$，若 $x$ 为 $p$ 的因子则说明更大的 $\dfrac{p}{x}$ 也是 $p$ 的因子，但是前面枚举 $x$ 的过程中并没有找到 $p$ 的因子，矛盾。

实际结果表明，上述算法在 $n>1$ 时总能找到答案，而 $n=1$ 时的答案为 $9$，是个 $1$ 位数，需要特判这种情况。

```Python [sol1-Python3]
class Solution:
    def largestPalindrome(self, n: int) -> int:
        if n == 1:
            return 9
        upper = 10 ** n - 1
        for left in range(upper, upper // 10, -1):  # 枚举回文数的左半部分
            p, x = left, left
            while x:
                p = p * 10 + x % 10  # 翻转左半部分到其自身末尾，构造回文数 p
                x //= 10
            x = upper
            while x * x >= p:
                if p % x == 0:  # x 是 p 的因子
                    return p % 1337
                x -= 1
```

```C++ [sol1-C++]
class Solution {
public:
    int largestPalindrome(int n) {
        if (n == 1) {
            return 9;
        }
        int upper = pow(10, n) - 1;
        for (int left = upper;; --left) { // 枚举回文数的左半部分
            long p = left;
            for (int x = left; x > 0; x /= 10) {
                p = p * 10 + x % 10; // 翻转左半部分到其自身末尾，构造回文数 p
            }
            for (long x = upper; x * x >= p; --x) {
                if (p % x == 0) { // x 是 p 的因子
                    return p % 1337;
                }
            }
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int largestPalindrome(int n) {
        if (n == 1) {
            return 9;
        }
        int upper = (int) Math.pow(10, n) - 1;
        int ans = 0;
        for (int left = upper; ans == 0; --left) { // 枚举回文数的左半部分
            long p = left;
            for (int x = left; x > 0; x /= 10) {
                p = p * 10 + x % 10; // 翻转左半部分到其自身末尾，构造回文数 p
            }
            for (long x = upper; x * x >= p; --x) {
                if (p % x == 0) { // x 是 p 的因子
                    ans = (int) (p % 1337);
                    break;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LargestPalindrome(int n) {
        if (n == 1) {
            return 9;
        }
        int upper = (int) Math.Pow(10, n) - 1;
        int ans = 0;
        for (int left = upper; ans == 0; --left) { // 枚举回文数的左半部分
            long p = left;
            for (int x = left; x > 0; x /= 10) {
                p = p * 10 + x % 10; // 翻转左半部分到其自身末尾，构造回文数 p
            }
            for (long x = upper; x * x >= p; --x) {
                if (p % x == 0) { // x 是 p 的因子
                    ans = (int) (p % 1337);
                    break;
                }
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func largestPalindrome(n int) int {
    if n == 1 {
        return 9
    }
    upper := int(math.Pow10(n)) - 1
    for left := upper; ; left-- { // 枚举回文数的左半部分
        p := left
        for x := left; x > 0; x /= 10 {
            p = p*10 + x%10 // 翻转左半部分到其自身末尾，构造回文数 p
        }
        for x := upper; x*x >= p; x-- {
            if p%x == 0 { // x 是 p 的因子
                return p % 1337
            }
        }
    }
}
```

```C [sol1-C]
int largestPalindrome(int n){
    if (n == 1) {
        return 9;
    }
    int upper = pow(10, n) - 1;
    for (int left = upper;; --left) { // 枚举回文数的左半部分
        long p = left;
        for (int x = left; x > 0; x /= 10) {
            p = p * 10 + x % 10; // 翻转左半部分到其自身末尾，构造回文数 p
        }
        for (long x = upper; x * x >= p; --x) {
            if (p % x == 0) { // x 是 p 的因子
                return p % 1337;
            }
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var largestPalindrome = function(n) {
    if (n === 1) {
        return 9;
    }
    const upper = 10 ** n - 1;
    for (let left = upper; left > upper / 10; left--) {
        let right = String(left).split('').reverse().join('');
        let p = BigInt(String(left) + right)    //得到回文数
        let x = BigInt(upper);
        while (x * x >= p) {
            if (p % x === BigInt(0)) { // x 是 p 的因子
                return p % BigInt(1337);
            }
            x--;
        }
    }
};
```

**复杂度分析**

- 时间复杂度：$O(10^{2n})$。枚举 $\textit{left}$ 和 $x$ 的时间复杂度均为 $O(10^n)$。实际上我们只需要枚举远小于 $10^n$ 个的 $\textit{left}$ 就能找到答案，实际的时间复杂度远低于 $O(10^{2n})$。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。