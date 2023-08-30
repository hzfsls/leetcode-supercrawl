#### 说明

本题来源于一家印度公司的面试题，其难度远高于国内和北美的面试难度。如果你觉得此题无从下手、对下一节的「预备知识」一无所知、或者是看不懂这篇题解，都是很正常的。这道题已经达到了竞赛的难度，即使是非常优秀的竞赛选手，也要花至少 10 分钟的时间写出完整（但不一定可读）的代码。竞赛选手有大量的做题基础，因此在遇到这题时几乎不需要思考的时间，可以直接上手编写代码。而对于普通的面试准备者来说，在 40 分钟内理清思路、写出代码、编写测试并给面试官讲解清楚是几乎不可能的。

#### 预备知识

**数位动态规划（数位 DP）**

数位动态规划是一类特殊的动态规划，它的形式一般为：

> 给定下界 $l$ 和上界 $r$，求 $[l, r]$ 之间满足某一要求的元素个数。

在力扣平台上，数位动态规划的题目很少，典型的例子为 [1012. 至少有 1 位重复的数字](https://leetcode-cn.com/problems/numbers-with-repeated-digits/)，即给定下界 $1$ 和上界 $N$，求上下界之间满足「至少有 $1$ 位重复数字」的元素个数。

我们如何解决数位动态规划的题目呢？一般来说，数位动态规划有一个特定的状态表达：

$$
f[\textit{pos}][\textit{stats}][\textit{bound}]
$$

它表示：

- 我们现在处理到了数的第 $\textit{pos}$ 位。在数位动态规划中，我们是从高位到低位，一位一位地处理数字的。例如当下界 $l = 13$，上界 $r = 678$ 时，我们会先将上下界的高位补零使得它们拥有相同的位数，即 $(l, r) = (013, 678)$。随后我们从高位开始进行动态规划；

- 在 $\textit{pos}$ 位之前的那些数的状态被压缩成了 $\textit{stats}$。这是什么意思呢？我们举一个简单的例子，假设我们现在想要求出在 $[l, r]$ 之间各位数字之和是 $5$ 的倍数的所有数，那么此时 $\textit{stats}$ 就可以表示为「在 $\textit{pos}$ 位之前的那些数的数字之和对 $5$ 取模的值」，这样我们只用一个整数就能够表示 $\textit{pos}$ 位之前的状态。如果在第 $\textit{pos}$ 位我们选择了数 $d$，那么动态规划中的下一个状态就为 $f[\textit{pos} + 1][(\textit{stats} + d) \bmod 5][\ldots]$；

- 在 $pos$ 位之前的那些数和上下界 $l, r$ 的关系为 $\textit{bound}$。这又是什么意思呢？我们还是使用上面的那个例子，求出 $[013, 678]$ 内各位数字之和是 $5$ 的倍数的所有数。

    - 如果最高位的数字我们选择了 $2$，它和上下界的最高位数字没有任何关系，因此对于次高位的数字，我们可以在 $[0, 9]$ 之间任意选择；

    - 如果最高位的数字我们选择了 $6$，此时这个数字是「贴着」上界的，也就是说，对于次高位的数字，我们只能在 $[0, 7]$ 之间选择，其中 $7$ 就是上界的次高位的数字。如果我们选择了数字 $8$ 或 $9$，那么整个数为 $68\_$，无论最后一位怎么选择，都不可能在上下界的区间内；

    - 如果最高位的数字我们选择了 $0$，此时这个数字是「贴着」下界的，也就是说，对于次高位的数字，我们只能在 $[1, 9]$ 之间选择，其中 $1$ 就是下界的次高位数字。如果我们选择了数字 $0$，那么整个数为 $00\_$，无论最后一位怎么选择，都不可能在上下界的区间内；

    - 此外，还有一种最为特殊的情况。如果上下界为 $(l, r) = (123, 156)$，并且最高位我们选择了 $1$，那么此时这个数字既「贴着」上界，也「贴着」下界，对于次高位的数字，我们只能在 $[2, 5]$ 之间选择，其中 $2$ 是下界的次高位数字，$5$ 是上界的次高位数字。
  
  综上所述，$\textit{bound}$ 共有 $4$ 种不同的情况，我们可以给它们分别设定取值 $0, 1, 2, 3$：

    - 如果和上下界没有任何关系，那么取值为 $0$，并且以后也不可能和上下界有关系；

    - 如果「贴着」下界，那么取值为 $1$，并且只有当第 $\textit{pos}$ 位取了下界对应位置的数字时，才会延续 $1$ 值，否则会变为 $0$；

    - 如果「贴着」上界，那么取值为 $2$，并且只有当第 $\textit{pos}$ 位取了上界对应位置的数字时，才会延续 $2$ 值，否则会变为 $0$；

    - 如果同时「贴着」上下界，那么取值为 $3$，并且：
    
        - 如果 $\textit{pos}$ 位同时取了上下界对应位置的数字（此时上下界对应位置的数字一定相同），那么延续 $3$ 值；

        - 如果 $\textit{pos}$ 位取了下界对应位置的数字，那么会变为 $1$；

        - 如果 $\textit{pos}$ 位取了上界对应位置的数字，那么会变为 $2$；

        - 其余情况会变为 $0$。
  
  另一种理解方式是，$\textit{bound}$ 是一个 $2$ 位的二进制数，低位为 $1$ 当且仅当「贴着」下界，高位为 $1$ 当且仅当「贴着」上界。

而对于 $f[\textit{pos}][\textit{stats}][\textit{bound}]$ 的值本身，它表示「满足上述条件的数的个数」。这样以来，我们可以使用记忆化搜索（DFS + memo）的方法进行动态规划，即

$$
f[\textit{pos}][\textit{stats}][\textit{bound}] = \sum_d f[\textit{pos + 1}][g_s(\textit{stats}, d)][g_b(\textit{bound}, d)]
$$

其中 $d$ 为第 $\textit{pos}$ 位选择的数字；$g_b(\textit{bound}, d)$ 是关于 $\textit{bound}$ 的转移函数，例如上文中四个取值 $0, 1, 2, 3$ 之间的转化；$g_s(\textit{stats}, d)$ 是关于 $\textit{stats}$ 的转移函数，例如上文中的 $(\textit{stats} + d) \bmod 5$。最终的答案存放在

$$
f[0][\textit{stats}_{\textit{init}}][3]
$$

中，即满足「枚举到最高位、初始状态、同时贴着上下界（可以想象成更高位还可以补零，那么在最高位之前的数字都是贴着上下界的）」的数的个数，也就是需要求出的答案。

**KMP**

KMP 是一种字符串匹配算法，在力扣平台上出现的次数不少，但一般会用较易理解的「Rabin-Karp 字符串哈希算法」替代之，例如 [1392. 最长快乐前缀](https://leetcode-cn.com/problems/longest-happy-prefix/)。在本题中，KMP 算法用来计算关于 $\textit{stats}$ 的转移函数 $g_s(\textit{stats}, d)$，但由于算法时间的瓶颈不在于此（也就是说，我们用最暴力的方法求出转移函数，都可以在规定的时间内通过本题），并且 KMP 本身的证明很复杂，因此这里不再赘述，有兴趣的读者可以尝试查阅相关资料（例如阅读算法导论的相关章节、使用搜索引擎等）进行学习。

#### 方法一：数位动态规划

本题虽然给定的是两个字符串，但仍然可以用数位动态规划的方法解决，因为根据字符串的字典序，它就具有

> 给定下界 $l$ 和上界 $r$，求 $[l, r]$ 之间满足某一要求的元素个数。

的形式。其中「下界」为给定的字符串 $s1$，「上界」为给定的字符串 $s2$，「要求」为「字符串中不能出现子串 $\textit{evil}$」。

在预备知识的章节中，我们已经详细介绍了 $f[\textit{pos}][\textit{stats}][\textit{bound}]$ 中的 $\textit{pos}$ 和 $\textit{bound}$，它们基本不会随着题目而改变。但 $\textit{stats}$ 和它的转移函数 $g_s(\textit{stats}, d)$ 是和题目紧密相关的，在本题中，我们可以将 $\textit{stats}$ 定义为：

> 在 $pos$ 位之前的那些字符组成的字符串，匹配到 $\textit{evil}$ 的位置；也就是说，$\textit{stats}$ 表示最大的 $l$，使得前者长度为 $l$ 的后缀等于后者长度为 $l$ 的前缀。这和 KMP 算法中对于「匹配」的定义也是一致的。

举一个例子，假设 $\textit{evil}$ 为 $"abcab"$，如果 $pos$ 为之前的那些字符组成的字符串为 $"adab"$，那么就匹配到了 $\textit{evil}$ 中的第 $1$ 个字符（最左侧为第 $0$ 个字符），即第一次出现的 $b$。对于第 $pos$ 位，如果我们选择字符 $"c"$，那么匹配的位置会增加 $1$，因为 $"adabc"$ 匹配到了 $"abcab"$ 中的第 $2$ 个字符；如果我们选择字符 $"a"$，那么匹配的位置会变为 $0$，因为 $"adaba"$ 只能匹配到 $"abcab"$ 中的第 $0$ 个字母；如果我们选择其它的字符（例如 $"b"$），那么情况就很糟了，$"adabb"$ 不能匹配 $"abcab"$ 中的任何位置。

这样以来，只有当 $\textit{stats}$ 指向了 $\textit{evil}$ 中的最后一位时，当前的字符串才会包含 $\textit{evil}$。此时我们需要在记忆化搜索中进行回溯并返回 $0$，这是因为后面搜索到的所有字符串都一定包含 $\textit{evil}$ 了。除此之外，我们可以一直搜索下去，直到达到边界。

那么给定当前的状态 $\textit{stats}$ 和第 $\textit{pos}$ 位选择的字符 $d$，我们如何计算转移函数 $g_s(\textit{stats}, d)$ 呢？此时就需要 KMP 算法的帮助了。在 KMP 算法中，我们需要两个字符串，其一为「模式串」，另一位「主串」，我们需要判断「主串」中是否包含「模式串」，具体的做法就是按照顺序遍历「主串」中的每一个字符，并根据上一次在「模式串」中匹配到的位置以及当前遍历到的字符，求出此字符之后在「模式串」中匹配到的位置。一旦我们匹配到了「模式串」的末尾，就说明「主串」中出现了「模式串」。而匹配时用到的转移函数就是 KMP 算法中对「模式串」求得的 $\textit{fail}[]$ 数组。因此在本题中，我们也只需要对 $\textit{evil}$ 求出对应的 $\textit{fail}[]$ 数组，就可以计算转移函数了。

到这里，题解的分析部分就结束了，你是不是还觉得一头雾水？没关系，如果你真的想解决本题，编者在这里推荐了一系列的步骤：

- 学习 KMP 算法。具体地，可以参考《算法导论》或使用搜索引擎查找介绍 KMP 算法的博客。KMP 算法理解起来十分不容易，对于本题而言，你需要掌握 KMP 算法中的 $\textit{fail}[]$ 数组（也就是「模式串」对应的数组），并且知道是如何在「主串」上匹配「模式串」的；

- 如果实在无法理解 KMP 算法，也可以放弃上一步，从而尝试写一个暴力的转移函数 $g_s(\textit{stats}, d)$。具体地，你只要编写一个函数，求出 $\textit{evil}$ 的前 $\textit{stats}$ 个字符加上 $d$ 组成的字符串与 $\textit{evil}$ 的匹配长度，你只需要暴力地枚举 $l$，再判断前者长度为 $l$ 的后缀等于后者长度为 $l$ 的前缀即可。这一步对于大部分的读者应该不会很难；

- 尝试理解上文关于数位 DP 的预备知识。同样地，有很多介绍数位 DP 的博客。为了检测你是否正确理解了数位 DP，你可以阅读本题给出的参考代码，其中包含大量的注释。如果你都能理解，说明你已经掌握了数位 DP 的预备知识；

- 自己编写本题的代码。在编写过程中坚持住不要回看参考代码，如果在编写过程中有地方卡住了，可以在纸上自行推导一下，这样有助于加深你对数位 DP 以及 KMP 算法的理解。

只要跟着这些步骤自主学习，你一定能够做出本题的！并且编者相信，如果做出本题，你一定能获得很大的成就感！

```C++ [sol1-C++]
class Solution {
private:
    // 这是用来帮助计算关于 stats 的转移函数的 fail 数组
    vector<int> fail;
    // 这是存储动态规划结果的数组
    // 维度从左到右分别为 pos, stats, bound
    int f[500][50][4];
    // 这是存储转移函数结果的数组
    // 两个维度分别为 stats 和 d
    int trans[50][26];
    static constexpr int mod = 1000000007;
    string s1, s2, evil;

public:
    // 这是计算关于 stats 的转移函数
    // 输入为 stats 和 d
    // 输出为转移的结果 g_s(stats, d)
    int getTrans(int stats, char ch) {
        // 如果之前计算过该转移函数就直接返回结果
        if (trans[stats][ch - 97] != -1) {
            return trans[stats][ch - 97];
        }
        // 这是 KMP 算法的一部分
        // 把 evil 看作「模式串」，stats 看作「主串」匹配到的位置
        while (stats && evil[stats] != ch) {
            stats = fail[stats - 1];
        }
        // 存储结果并返回
        return trans[stats][ch - 97] = (evil[stats] == ch ? stats + 1 : 0);
    }

    // 这是用来进行记忆化搜索的函数
    // 输入为 pos, stats 和 bound
    // 输出为 f[pos][stats][bound]
    int dfs(int pos, int stats, int bound) {
        // 如果匹配到了 evil 的末尾
        // 说明字符串不满足要求了
        // 返回 0
        if (stats == evil.size()) {
            return 0;
        }
        // 如果匹配到了上下界的末尾
        // 说明找到了一个满足要求的字符串
        // 返回 1
        if (pos == s1.size()) {
            return 1;
        }
        // 记忆化搜索的关键
        // 如果之前计算过该状态就直接返回结果
        if (f[pos][stats][bound] != -1) {
            return f[pos][stats][bound];
        }
        
        // 将当前状态初始化
        // 因为未初始化的状态值为 -1
        f[pos][stats][bound] = 0;
        // 计算第 pos 位可枚举的字符下界
        char l = (bound & 1 ? s1[pos] : 'a');
        // 计算第 pos 位可枚举的字符上界
        char r = (bound & 2 ? s2[pos] : 'z');
        for (char ch = l; ch <= r; ++ch) {
            int nxt_stats = getTrans(stats, ch);
            // 这里写得较为复杂
            // 本质上就是关于 bound 的转移函数
            // 可以根据自己的理解编写
            int nxt_bound = (bound & 1 ? ch == s1[pos] : 0) ^ (bound & 2 ? (ch == s2[pos]) << 1 : 0);
            f[pos][stats][bound] += dfs(pos + 1, nxt_stats, nxt_bound);
            f[pos][stats][bound] %= mod;
        }
        return f[pos][stats][bound];
    }

    int findGoodStrings(int n, string _s1, string _s2, string _evil) {
        s1 = _s1;
        s2 = _s2;
        evil = _evil;

        int m = evil.size();
        fail.resize(m);
        // 这是 KMP 算法的一部分
        // 把「evil」看作模式串，得到它的 fail[] 数组
        for (int i = 1; i < m; ++i) {
            int j = fail[i - 1];
            while (j && evil[j] != evil[i]) {
                j = fail[j - 1];
            }
            if (evil[j] == evil[i]) {
                fail[i] = j + 1;
            }
        }
        // 将未搜索过的动态规划状态置为 -1
        memset(f, -1, sizeof(f));
        // 将未计算过的转移函数置为 -1
        memset(trans, -1, sizeof(trans));
        // 答案即为 f[0][0][3]
        return dfs(0, 0, 3);
    }
};
```
```Java [sol1-Java]
class Solution {
    int[] fail;
    // 这是存储动态规划结果的数组
    // 维度从左到右分别为 pos, stats, bound
    int[][][] f;
    // int f[500][50][4];
    // 这是存储转移函数结果的数组
    // 两个维度分别为 stats 和 d
    int[][] trans;
    static final int MOD = 1000000007;
    String s1, s2, evil;

    public int findGoodStrings(int n, String s1, String s2, String evil) {
        this.s1 = s1;
        this.s2 = s2;
        this.evil = evil;

        int m = evil.length();
        fail = new int[m];
        // 这是 KMP 算法的一部分
        // 把「evil」看作模式串，得到它的 fail[] 数组
        for (int i = 1; i < m; ++i) {
            int j = fail[i - 1];
            while (j != 0 && evil.charAt(j) != evil.charAt(i)) {
                j = fail[j - 1];
            }
            if (evil.charAt(j) == evil.charAt(i)) {
                fail[i] = j + 1;
            }
        }
        // 将未搜索过的动态规划状态置为 -1
        f = new int[n][m][4];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                Arrays.fill(f[i][j], -1);
            }
        }
        // 将未计算过的转移函数置为 -1
        trans = new int[m][26];
        for (int i = 0; i < m; ++i) {
            Arrays.fill(trans[i], -1);
        }
        // 答案即为 f[0][0][3]
        return dfs(0, 0, 3);
    }

    // 这是用来进行记忆化搜索的函数
    // 输入为 pos, stats 和 bound
    // 输出为 f[pos][stats][bound]
    public int dfs(int pos, int stats, int bound) {
        // 如果匹配到了 evil 的末尾
        // 说明字符串不满足要求了
        // 返回 0
        if (stats == evil.length()) {
            return 0;
        }
        // 如果匹配到了上下界的末尾
        // 说明找到了一个满足要求的字符串
        // 返回 1
        if (pos == s1.length()) {
            return 1;
        }
        // 记忆化搜索的关键
        // 如果之前计算过该状态就直接返回结果
        if (f[pos][stats][bound] != -1) {
            return f[pos][stats][bound];
        }
        
        // 将当前状态初始化
        // 因为未初始化的状态值为 -1
        f[pos][stats][bound] = 0;
        // 计算第 pos 位可枚举的字符下界
        char l = ((bound & 1) != 0 ? s1.charAt(pos) : 'a');
        // 计算第 pos 位可枚举的字符上界
        char r = ((bound & 2) != 0 ? s2.charAt(pos) : 'z');
        for (char ch = l; ch <= r; ++ch) {
            int nxt_stats = getTrans(stats, ch);
            // 这里写得较为复杂
            // 本质上就是关于 bound 的转移函数
            // 可以根据自己的理解编写
            int nxt_bound = ((bound & 1) != 0 ? (ch == s1.charAt(pos) ? 1 : 0) : 0) ^ ((bound & 2) != 0 ? (ch == s2.charAt(pos) ? 1 : 0) << 1 : 0);
            f[pos][stats][bound] += dfs(pos + 1, nxt_stats, nxt_bound);
            f[pos][stats][bound] %= MOD;
        }
        return f[pos][stats][bound];
    }

    // 这是计算关于 stats 的转移函数
    // 输入为 stats 和 d
    // 输出为转移的结果 g_s(stats, d)
    public int getTrans(int stats, char ch) {
        // 如果之前计算过该转移函数就直接返回结果
        if (trans[stats][ch - 'a'] != -1) {
            return trans[stats][ch - 'a'];
        }
        // 这是 KMP 算法的一部分
        // 把 evil 看作「模式串」，stats 看作「主串」匹配到的位置
        while (stats != 0 && evil.charAt(stats) != ch) {
            stats = fail[stats - 1];
        }
        // 存储结果并返回
        return trans[stats][ch - 'a'] = (evil.charAt(stats) == ch ? stats + 1 : 0);
    }
}
```
```Python [sol1-Python3]
class Solution:
    """@lru_cache 装饰器是 Python 语言提供的可供记忆化搜索的利器
    相当于将该参数的（输入，输出）对缓存起来
    在以相同的输入调用该函数时，就可以避免计算，直接返回输出
    """
    
    def findGoodStrings(self, n: int, s1: str, s2: str, evil: str) -> int:
        @lru_cache(None)
        def getTrans(stats, ch):
            """这是计算关于 stats 的转移函数
            输入为 stats 和 d
            输出为转移的结果 g_s(stats, d)"""

            u = ord(ch) - 97
            # 这是 KMP 算法的一部分
            # 把 evil 看作「模式串」，stats 看作「主串」匹配到的位置
            while stats > 0 and evil[stats] != ch:
                stats = fail[stats - 1]
            return stats + 1 if evil[stats] == ch else 0
        
        @lru_cache(None)
        def dfs(pos, stats, bound):
            """这是用来进行记忆化搜索的函数
            输入为 pos, stats 和 bound
            输出为 f[pos][stats][bound]"""

            # 如果匹配到了 evil 的末尾
            # 说明字符串不满足要求了
            # 返回 0
            if stats == len(evil):
                return 0
            # 如果匹配到了上下界的末尾
            # 说明找到了一个满足要求的字符串
            # 返回 1
            if pos == len(s1):
                return 1
            
            ans = 0
            # 计算第 pos 位可枚举的字符下界
            l = (ord(s1[pos]) if bound & 1 else ord('a'))
            # 计算第 pos 位可枚举的字符上界
            r = (ord(s2[pos]) if bound & 2 else ord('z'))
            for u in range(l, r + 1):
                ch = chr(u)
                nxt_stats = getTrans(stats, ch)
                # 这里写得较为复杂
                # 本质上就是关于 bound 的转移函数
                # 可以根据自己的理解编写
                nxt_bound = (ch == s1[pos] if bound & 1 else 0) ^ ((ch == s2[pos]) << 1 if bound & 2 else 0)
                ans += dfs(pos + 1, nxt_stats, nxt_bound)
            return ans % 1000000007

        m = len(evil)
        # 这是用来帮助计算关于 stats 的转移函数的 fail 数组
        fail = [0] * m
        # 这是 KMP 算法的一部分
        # 把「evil」看作模式串，得到它的 fail[] 数组
        for i in range(1, m):
            j = fail[i - 1]
            while j > 0 and evil[j] != evil[i]:
                j = fail[j - 1]
            if evil[j] == evil[i]:
                fail[i] = j + 1
        
        # 答案即为 f[0][0][3]
        return dfs(0, 0, 3)
```

**复杂度分析**

- 时间复杂度：$O(NMS)$，其中 $N$ 是字符串 $s1$ 和 $s2$ 的长度，$M$ 是字符串 $\textit{eval}$ 的长度，$S$ 是字符集大小，在本题中字符串仅包含小写字母，即 $S = 26$。时间复杂度分为以下这些部分：

    - 计算字符串 $\textit{eval}$ 的 $\textit{fail}[]$ 数组需要的时间复杂度为 $O(M)$；

    - 在记忆化搜索中状态数量有 $O(N*M*4) = O(NM)$ 个，每个状态需要枚举后续最多 $S$ 个状态进行转移，时间复杂度为 $O(NMS)$；

    - 在进行转移时，需要借助 $\textit{fail}[]$ 数组计算转移函数，这部分的均摊复杂度为单次 $O(1)$，时间复杂度为 $O(NMS)$。

  因此总时间复杂度为 $O(NMS)$。

- 空间复杂度：$O(M(N + S))$。空间复杂度分为以下这些部分：

    - $\textit{fail}[]$ 数组需要的空间复杂度为 $O(M)$；

    - 存储转移函数结果的数组需要的空间复杂度为 $O(MS)$；

    - 存储记忆化搜索结果的数组需要的空间复杂度为 $O(NM)$。

  因此总空间复杂度为 $O(M(N + S))$。