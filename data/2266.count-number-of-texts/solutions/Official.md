## [2266.统计打字方案数 中文官方题解](https://leetcode.cn/problems/count-number-of-texts/solutions/100000/tong-ji-da-zi-fang-an-shu-by-leetcode-so-714a)
#### 方法一：动态规划

**思路与算法**

我们可以将字符串分解为多个部分，每个部分由相同的字符组成，且相邻两个部分的字符不一样。那么，根据乘法原理，构成文字信息的总方案数等于这些部分各自对应方案数的**乘积**。

而对于某个特定字符组成的子串，其方案数仅与**子串的长度**和**字符对应的字母种类数**有关。我们用 $\textit{dp}_4[i]$ 表示连续 $i$ 个对应 $4$ 个字母的字符（即 $\texttt{`7'}$ 或 $\texttt{`9'}$）组成子串对应的方案数，用 $\textit{dp}_3[i]$ 表示连续 $i$ 个对应 $3$ 个字母的字符（即其余字符）组成子串对应的方案数。

我们以 $\textit{dp}_3[i]$ 为例构造转移方程。对于 $3$ 个字母的按键，对应字母字符串的末尾字符可能有三种情况，分别对应按 $1, 2, 3$ 次的情况。那么，我们可以得到如下的转移方程（为了方便起见，当 $i < 0$ 时 $\textit{dp}_3[i] = 0$；当 $i = 0$ 时，由于空字符串也是一种方案，因此 $\textit{dp}_3[0] = 1$，下同）：

$$
\textit{dp}_3[i] = （\textit{dp}_3[i - 1] + \textit{dp}_3[i - 2] + \textit{dp}_3[i - 3]）\bmod (10^9 + 7).
$$

注意由于我们需要将结果对 $10^9 + 7$ 取余，因此我们可以提前对数组元素进行取模处理。

同理，对于 $4$ 个字母的按键，我们也可以类似地构造转移方程：

$$
\textit{dp}_4[i] = (\textit{dp}_4[i - 1] + \textit{dp}_4[i - 2] + \textit{dp}_4[i - 3] + \textit{dp}_4[i - 4]）\bmod (10^9 + 7).
$$

我们用 $n$ 表示字符串 $\textit{pressedKeys}$，为了方便计算，我们可以预处理并用数组保存 $[0, n]$ 闭区间内的 $\textit{dp}_4$ 与 $\textit{dp}_3$ 数组。随后，我们遍历字符串 $\textit{pressedKeys}$ 计算总方案数。

具体地，我们用 $\textit{res}$ 表示总方案数，$\textit{res}$ 的初值为 $1$。随后，我们从左至右遍历字符串，并统计当前字符连续出现的次数 $\textit{cnt}$。每当我们遍历到与前一个字符不一样的新字符，此时说明我们刚刚遍历完成长度为 $\textit{cnt}$ 的相同字符子串，我们就根据前一个字符的数值将 $\textit{res}$ 乘上对应的 $\textit{dp}_4[\textit{cnt}]$ 或 $\textit{dp}_3[\textit{cnt}]$ 并对 $10^9 + 7$ 取余。最终，我们还需要对最后一段相同字符组成的子串进行计算并更新 $\textit{res}$。当上述操作完成后，我们返回 $\textit{res}$ 作为答案。


**细节**

由于计算的中间值可能超过 $32$ 位有符号整数的上界，因此我们可以考虑用 $64$ 位整数保存 $\textit{res}$ 以及 $\textit{dp}_4$ 与 $\textit{dp}_3$ 数组的元素。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countTexts(string pressedKeys) {
        int m = 1000000007;
        vector<long long> dp3 = {1, 1, 2, 4};   // 连续按多次 3 个字母按键对应的方案数
        vector<long long> dp4 = {1, 1, 2, 4};   // 连续按多次 4 个字母按键对应的方案数
        int n = pressedKeys.size();
        for (int i = 4; i < n + 1; ++i) {
            dp3.push_back((dp3[i-1] + dp3[i-2] + dp3[i-3]) % m);
            dp4.push_back((dp4[i-1] + dp4[i-2] + dp4[i-3] + dp4[i-4]) % m);
        }
        long long res = 1;   // 总方案数
        int cnt = 1;   // 当前字符连续出现的次数
        for (int i = 1; i < n; ++i) {
            if (pressedKeys[i] == pressedKeys[i-1]) {
                ++cnt;
            } else {
                // 对按键对应字符数量讨论并更新总方案数
                if (pressedKeys[i-1] == '7' || pressedKeys[i-1] == '9') {
                    res *= dp4[cnt];
                } else {
                    res *= dp3[cnt];
                }
                res %= m;
                cnt = 1;
            }
        }
        // 更新最后一段连续字符子串对应的方案数
        if (pressedKeys[n-1] == '7' || pressedKeys[n-1] == '9') {
            res *= dp4[cnt];
        } else {
            res *= dp3[cnt];
        }
        res %= m;
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countTexts(self, pressedKeys: str) -> int:
        m = 10 ** 9 + 7
        dp3 = [1, 1, 2, 4]   # 连续按多次 3 个字母按键对应的方案数
        dp4 = [1, 1, 2, 4]   # 连续按多次 4 个字母按键对应的方案数
        n = len(pressedKeys)
        for i in range(4, n + 1):
            dp3.append((dp3[i-1] + dp3[i-2] + dp3[i-3]) % m)
            dp4.append((dp4[i-1] + dp4[i-2] + dp4[i-3] + dp4[i-4]) % m)
        res = 1   # 总方案数
        cnt = 1   # 当前字符连续出现的次数
        for i in range(1, n):
            if pressedKeys[i] == pressedKeys[i-1]:
                cnt += 1
            else:
                # 对按键对应字符数量讨论并更新总方案数
                if pressedKeys[i-1] in "79":
                    res *= dp4[cnt]
                else:
                    res *= dp3[cnt]
                res %= m
                cnt = 1
        # 更新最后一段连续字符子串对应的方案数
        if pressedKeys[-1] in "79":
            res *= dp4[cnt]
        else:
            res *= dp3[cnt]
        res %= m
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{pressedKeys}$ 的长度。即为预处理动态规划数组与遍历字符串计算方案数的时间复杂度。

- 空间复杂度：$O(n)$，即为动态规划数组的空间开销。