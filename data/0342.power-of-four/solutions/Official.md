## [342.4的幂 中文官方题解](https://leetcode.cn/problems/power-of-four/solutions/100000/4de-mi-by-leetcode-solution-b3ya)

#### 前言

如果 $n$ 是 $4$ 的幂，那么 $n$ 一定也是 $2$ 的幂。因此我们可以首先判断 $n$ 是否是 $2$ 的幂，在此基础上再判断 $n$ 是否是 $4$ 的幂。

判断 $n$ 是否是 $2$ 的幂可以参考「[231. 2的幂的官方题解](https://leetcode-cn.com/problems/power-of-two/solution/2de-mi-by-leetcode-solution-rny3/)」。由于这一步的方法有很多种，在下面的题解中，我们使用

$$
\texttt{n \& (n - 1)}
$$

这一方法进行判断。

#### 方法一：二进制表示中 $1$ 的位置

**思路与算法**

如果 $n$ 是 $4$ 的幂，那么 $n$ 的二进制表示中有且仅有一个 $1$，并且这个 $1$ 出现在从低位开始的第**偶数**个二进制位上（这是因为这个 $1$ 后面必须有偶数个 $0$）。这里我们规定最低位为第 $0$ 位，例如 $n=16$ 时，$n$ 的二进制表示为

$$
(10000)_2
$$

唯一的 $1$ 出现在第 $4$ 个二进制位上，因此 $n$ 是 $4$ 的幂。

由于题目保证了 $n$ 是一个 $32$ 位的有符号整数，因此我们可以构造一个整数 $\textit{mask}$，它的所有偶数二进制位都是 $0$，所有奇数二进制位都是 $1$。这样一来，我们将 $n$ 和 $\textit{mask}$ 进行按位与运算，如果结果为 $0$，说明 $n$ 二进制表示中的 $1$ 出现在偶数的位置，否则说明其出现在奇数的位置。

根据上面的思路，$\textit{mask}$ 的二进制表示为：

$$
\textit{mask} = (10101010101010101010101010101010)_2
$$

我们也可以将其表示成 $16$ 进制的形式，使其更加美观：

$$
\textit{mask} = (\text{AAAAAAAA})_{16}
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && (n & 0xaaaaaaaa) == 0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && (n & 0xaaaaaaaa) == 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && (n & 0xaaaaaaaa) == 0;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isPowerOfFour(self, n: int) -> bool:
        return n > 0 and (n & (n - 1)) == 0 and (n & 0xaaaaaaaa) == 0
```

```JavaScript [sol1-JavaScript]
var isPowerOfFour = function(n) {
    return n > 0 && (n & (n - 1)) === 0 && (n & 0xaaaaaaaa) === 0;
};
```

```go [sol1-Golang]
func isPowerOfFour(n int) bool {
    return n > 0 && n&(n-1) == 0 && n&0xaaaaaaaa == 0
}
```

```C [sol1-C]
bool isPowerOfFour(int n) {
    return n > 0 && (n & (n - 1)) == 0 && (n & 0xaaaaaaaa) == 0;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。

**思考**

事实上，我们令：

$$
\textit{mask} = (\text{2AAAAAAA})_{16}
$$

也可以使得上面的判断满足要求，读者可以思考其中的原因。

**提示：**$n$ 是一个「有符号」的 $32$ 位整数。

#### 方法二：取模性质

**思路与算法**

如果 $n$ 是 $4$ 的幂，那么它可以表示成 $4^x$ 的形式，我们可以发现它除以 $3$ 的余数一定为 $1$，即：

$$
4^x \equiv (3+1)^x \equiv 1^x \equiv 1 \quad (\bmod ~3)
$$

如果 $n$ 是 $2$ 的幂却不是 $4$ 的幂，那么它可以表示成 $4^x \times 2$ 的形式，此时它除以 $3$ 的余数一定为 $2$。

因此我们可以通过 $n$ 除以 $3$ 的余数是否为 $1$ 来判断 $n$ 是否是 $4$ 的幂。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool isPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && n % 3 == 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && n % 3 == 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IsPowerOfFour(int n) {
        return n > 0 && (n & (n - 1)) == 0 && n % 3 == 1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def isPowerOfFour(self, n: int) -> bool:
        return n > 0 and (n & (n - 1)) == 0 and n % 3 == 1
```

```JavaScript [sol2-JavaScript]
var isPowerOfFour = function(n) {
    return n > 0 && (n & (n - 1)) === 0 && n % 3 === 1;
};
```

```go [sol2-Golang]
func isPowerOfFour(n int) bool {
    return n > 0 && n&(n-1) == 0 && n%3 == 1
}
```

```C [sol2-C]
bool isPowerOfFour(int n) {
    return n > 0 && (n & (n - 1)) == 0 && n % 3 == 1;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。

---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[🐞 你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)