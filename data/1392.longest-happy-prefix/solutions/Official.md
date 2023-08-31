## [1392.最长快乐前缀 中文官方题解](https://leetcode.cn/problems/longest-happy-prefix/solutions/100000/zui-chang-kuai-le-qian-zhui-by-leetcode-solution)
#### 方法一：Rabin-Karp 字符串编码

**背景知识**

Rabin-Karp 字符串编码是一种将字符串映射成整数的编码方式，可以看成是一种哈希算法。具体地，假设字符串包含的字符种类不超过 $|\Sigma|$（其中 $\Sigma$ 表示字符集），那么我们选一个大于等于 $|\Sigma|$ 的整数 $\textit{base}$，就可以将字符串看成 $\textit{base}$ 进制的整数，将其转换成十进制数后，就得到了字符串对应的编码。

例如给定字符串 $s = abca$，其包含的字符种类为 $3$（即 $abc$ 三种）。我们取 $\textit{base} = 9$，将字符串 $s$ 看成九进制数 $(0120)_9$，转换为十进制为 $99$，也就是说字符串 $abca$ 的编码为 $99$。一般地，计算编码值的公式如下：

$$
\textit{encrypt} = \sum_{i=0}^{|S|-1} s[i] * \textit{base}^{|S|-i-1}
$$

这样做的好处是什么？我们可以发现一个结论：

> 两个字符串 $s$ 和 $t$ 相等，当且仅当它们的长度相等且编码值相等。

对于长度为 $k$ 的所有字符串，我们会将它们编码成位数为 $k$（包含前导零）的 $base$ 进制数，这是一个单射，因此结论成立。这样以来，我们就可以通过比较两个字符串的编码值判断它们是否相等了。

但聪明的读者有没有发现什么问题呢？当字符串的长度很长时，对应的编码值也会很大，这样可能就无法用一般语言中的整数类型（例如 `int`，`long long` 等）存储编码值了。对此，一般的解决方法是将编码值对一个数 $\textit{mod}$ 进行取模，使得其保持在整数类型的范围之内。

但这样就带来了一个问题，两个不相同但长度相等的字符串在取模前会有不同的编码值，在取模后的编码值就有可能相同了。换句话说，我们的编码方式不是单射，这种哈希算法会产生碰撞。然而我们并不需要过分担心这个问题：

- 假设读者为防御者，本题的作者为攻击者，攻击者希望构造出一些长度相等的字符串，使得其中存在两个字符串，它们不相同，但取模后的编码值相同；

- 由于防御者取模使用的数 $\textit{mod}$ 对于攻击者是未知的，因此攻击者的策略可以看成是随机产生长度相等的字符串，然后期望它们中会产生碰撞。

- 熟悉 [生日攻击](https://baike.baidu.com/item/%E7%94%9F%E6%97%A5%E6%94%BB%E5%87%BB) 或 [生日悖论](https://baike.baidu.com/item/%E7%94%9F%E6%97%A5%E6%82%96%E8%AE%BA) 的防御者可以知道，对于一个模数 $\textit{mod}$，攻击者在随机产生 $O(\sqrt{\textit{mod}})$ 个字符串时，会有大概率（超过 $50\%$）产生碰撞，因此防御者可以将模数设置地尽量大来避免碰撞。防御者甚至可以设置多个模数 $\textit{mod}_1, \textit{mod}_2, \cdots, \textit{mod}_n$，只有两个字符串的编码值对这 $n$ 个数取模的值都分别相等，才会判定这两个字符串相同。

因此，只要我们将模数设置得很大，并且多选择一些模数，Rabin-Karp 字符串编码产生哈希碰撞的概率就微乎其微。一般来说，对于算法题而言，我们只需要选择一个模数即可，并且它最好是一个质数，例如 $10^9+7$。如有需要，还可以选择第二个模数 $10^9+9$。对于前文提到的 $\textit{base}$，一般也选择一个质数，例如本题中 $|\Sigma|=26$（即所有小写英文字母），我们可以选择 $\textit{base}=31$。

**算法**

我们从小到大枚举前缀的长度。对于枚举的长度 $i$，我们计算字符串 $s$ 长度为 $i$ 的前缀和后缀在 $\textit{base}=31, \textit{mod}=10^9+7$ 时的编码值。如果这两个编码值相等，我们就可以判定该前缀和后缀相等。

注意，我们可以使用 $O(1)$ 的时间通过长度为 $i-1$ 的前/后缀编码值计算出长度为 $i$ 的前/后缀编码值：

- 对于前缀而言，每在字符串最后多出一个新的字符，就相当于原编码值乘以 $\textit{base}$ 再加上新的字符的编码值；

- 对于后缀而言，每在字符串最前多出一个新的字符，就相当于原编码值加上新的字符的编码值乘以 $\textit{base}$ 的 $i-1$ 次幂。

```C++ [sol1-C++]
class Solution {
public:
    string longestPrefix(string s) {
        int n = s.size();
        int prefix = 0, suffix = 0;
        int base = 31, mod = 1000000007, mul = 1;
        int happy = 0;
        for (int i = 1; i < n; ++i) {
            prefix = ((long long)prefix * base + (s[i - 1] - 97)) % mod;
            suffix = (suffix + (long long)(s[n - i] - 97) * mul) % mod;
            if (prefix == suffix) {
                happy = i;
            }
            mul = (long long)mul * base % mod;
        }
        return s.substr(0, happy);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String longestPrefix(String s) {
        int n = s.length();
        long prefix = 0, suffix = 0;
        long base = 31, mod = 1000000007, mul = 1;
        int happy = 0;
        for (int i = 1; i < n; ++i) {
            prefix = (prefix * base + (s.charAt(i - 1) - 'a')) % mod;
            suffix = (suffix + (s.charAt(n - i) - 'a') * mul) % mod;
            if (prefix == suffix) {
                happy = i;
            }
            mul = mul * base % mod;
        }
        return s.substring(0, happy);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestPrefix(self, s: str) -> str:
        n = len(s)
        prefix, suffix = 0, 0
        base, mod, mul = 31, 1000000007, 1
        happy = 0
        for i in range(1, n):
            prefix = (prefix * base + (ord(s[i - 1]) - 97)) % mod
            suffix = (suffix + (ord(s[n - i]) - 97) * mul) % mod
            if prefix == suffix:
                happy = i
            mul = mul * base % mod
        return s[:happy]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。

#### 方法二：KMP 算法

**背景知识**

[KMP 算法](https://baike.baidu.com/item/kmp%E7%AE%97%E6%B3%95) 是一种高效的字符串匹配算法。KMP 算法的实现简单，但流程和证明较为复杂，有兴趣的读者可以尝试查阅相关资料（例如阅读算法导论的相关章节、使用搜索引擎等）进行学习。

在 KMP 算法中，我们会使用到一个匹配数组（一般称其为 $\textit{fail}$ 或 $\textit{next}$）数组，其中 $\textit{fail}[i]$ 表示关于字符串 $s$ 的子串 $s[0..i]$ 最长的既是前缀也是后缀的字符串，但这个字符串不能是 $s[0..i]$ 本身。例如当字符串为 $s = abacaba$ 时，$aba$ 就是最长的既是前缀也是后缀的字符串，$\textit{fail}[6]$ 的值为 $2$（注意字符串的下标是从 $0$ 开始的），$s$ 的前缀 $s[0..2]$ 和后缀 $s[4..6]$ 均为 $aba$。

**算法**

我们可以发现，「最长快乐前缀」就是最长的既是前缀也是后缀的字符串，因此我们使用 KMP 算法计算出数组 $\textit{fail}$，那么 $s$ 的长度为 $\textit{fail}[s.\textit{length} - 1] + 1$ 的前缀（或者后缀）即为答案。

```C++ [sol2-C++]
class Solution {
public:
    string longestPrefix(string s) {
        int n = s.size();
        vector<int> fail(n, -1);
        for (int i = 1; i < n; ++i) {
            int j = fail[i - 1];
            while (j != -1 && s[j + 1] != s[i]) {
                j = fail[j];
            }
            if (s[j + 1] == s[i]) {
                fail[i] = j + 1;
            }
        }
        return s.substr(0, fail[n - 1] + 1);
    }
};
```

```Java [sol2-Java]
class Solution {
    public String longestPrefix(String s) {
        int n = s.length();
        int[] fail = new int[n];
        Arrays.fill(fail, -1);
        for (int i = 1; i < n; ++i) {
            int j = fail[i - 1];
            while (j != -1 && s.charAt(j + 1) != s.charAt(i)) {
                j = fail[j];
            }
            if (s.charAt(j + 1) == s.charAt(i)) {
                fail[i] = j + 1;
            }
        }
        return s.substring(0, fail[n - 1] + 1);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def longestPrefix(self, s: str) -> str:
        n = len(s)
        fail = [-1] * n
        for i in range(1, n):
            j = fail[i - 1]
            while j != -1 and s[j + 1] != s[i]:
                j = fail[j]
            if s[j + 1] == s[i]:
                fail[i] = j + 1

        return s[:fail[-1] + 1]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(N)$，需要使用到长度为 $N$ 的数组 $\textit{fail}$。