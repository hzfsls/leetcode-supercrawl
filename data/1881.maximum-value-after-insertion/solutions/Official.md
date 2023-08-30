#### 方法一：贪心

**提示 $1$**

由于插入操作**不会**改变 $n$ 的符号，因此如果 $n$ 为负数，那么插入后的最大值对应的**绝对值**最小；如果 $n$ 为正数，那么插入后的最大值对应的**绝对值**最大。

**提示 $2$**

如果 $n$ 中存在比 $x$ 小的位，那么如果要使得插入后的**绝对值**最大，则对应的插入位置一定在这些位之前。如果不存在，那么对应的插入位置为 $n$ 的结尾。

如果 $n$ 中存在比 $x$ 大的位，那么如果要使得插入后的**绝对值**最小，则对应的插入位置一定在这些位之前。如果不存在，那么对应的插入位置为 $n$ 的结尾。

**提示 $2$ 解释**

为了简化讨论，我们考虑插入操作前后数值的**绝对值**。我们可以考虑将 $x$ 插入 $n$ 的末尾时构成的数字绝对值为**基准值**。

那么对于其余插入位置，即第 $i$ 位之前，根据 $x$ 和 $n[i]$ 对应的数值大小，可以分为三种情况：

- $x > n[i]$，此时考虑 $n$ 中下标为 $i$ 的位置，由于旧的 $n[i]$ 小于新的 $x$，因此插入后的数值会大于基准值。

- $x = n[i]$，此时等价于插入 $n[i+1]$ 之前，故无需考虑。

- $x < n[i]$，此时考虑 $n$ 中下标为 $i$ 的位置，由于旧的 $n[i]$ 大于新的 $x$，因此插入后的数值会小于基准值。

不失一般性地，我们以 **提示 $2$** 的第一部分为例。如果 $n$ 中存在比 $x$ 小的位，那么插入后绝对值大于基准值的插入位置集合即为这些位之前，最大绝对值对应的插入位置也一定在该集合之中。而如果该集合为空集，那么最大值即为基准值，对应的插入位置为 $n$ 结尾。

**提示 $3$**

如果 $n$ 中存在比 $x$ 小的位，那么这些位之前的插入位置中的**第一个**对应的插入后绝对值一定是最大的。

如果 $n$ 中存在比 $x$ 大的位，那么这些位之前的插入位置中的**第一个**对应的插入后绝对值一定是最小的。

**提示 $3$ 解释**

不失一般性，我们考虑第一种情况，且假设 $n$ 对应的整数为正数。假设字符串 $n$ 的长度为 $l$，存在两个比 $x$ 小的位，他们对应的下标 $a$ 和 $b$ 满足 $a < b$。

我们设插入位置为 $n[a]$ 之前对应的值为 $n_a$，插入位置为 $n[b]$ 之前对应的值为 $n_b$。由于插入操作后两个数值的**位数相等**，因此我们可以用「字典序」的方法来比较这两个数值的大小。

这两个数的 $[0, a-1]$ 位相同，因此考虑第 $a$ 位。此时 $n_a$ 的第 $a$ 位为 $x$，而 $n_b$ 的第 $a$ 位为 $n[a]$。由于 $x > n[a]$，因此前者一定更大。

**思路与算法**

根据 **提示 $1$**，我们首先通过 $n$ 的第一个字符是否为 $\texttt{`-'}$ 确定它为负数还是正数，进而判断我们需要找到的绝对值应当最大还是最小。

- 如果 $n$ 是负数，那么根据 **提示 $3$**，我们需要寻找 $n$ 中第一个比 $x$ 大的位置。如果存在，则返回对应的插入后字符串；如果不存在，则返回 $x$ 插入 $n$ 结尾对应的字符串。

- 如果 $n$ 是正数，类似地，我们需要寻找 $n$ 中第一个比 $x$ 小的位置。如果存在，则返回对应的插入后字符串；如果不存在，则返回 $x$ 插入 $n$ 结尾对应的字符串。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string maxValue(string n, int x) {
        int l = n.size();
        if (n[0] == '-'){
            for (int i = 1; i < l; ++i){
                if (n[i] - '0' > x){
                    n.insert(i, 1, '0' + x);
                    return n;
                }
            }
            n.push_back('0' + x);
            return n;
        }
        else {
            for (int i = 0; i < l; ++i){
                if (n[i] - '0' < x){
                    n.insert(i, 1, '0' + x);
                    return n;
                }
            }
            n.push_back('0' + x);
            return n;
        }

    }
};
```


```Python [sol1-Python3]
class Solution:
    def maxValue(self, n: str, x: int) -> str:
        l = len(n)
        if n[0] == '-':
            for i in range(1, l):
                if int(n[i]) > x:
                    return n[:i] + str(x) + n[i:]
            return n + str(x)
        else:
            for i in range(l):
                if int(n[i]) < x:
                    return n[:i] + str(x) + n[i:]
            return n + str(x)
            
```

**复杂度分析**

- 时间复杂度：$O(l)$，其中 $l$ 为 $n$ 的长度。遍历 $n$ 寻找插入位置的最坏时间复杂度为 $O(l)$，将数字插入字符串的最坏时间复杂度为 $O(l)$。
 
- 空间复杂度：$O(1)$。