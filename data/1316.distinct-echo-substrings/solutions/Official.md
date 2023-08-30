#### 方法一：枚举

我们在 `text` 中枚举位置 `i` 和 `j`，若字符串 `text[i:j]` 和 `text[j:j*2-i]` 相等，那么字符串 `text[i:j*2-i]` 就是一个满足条件的子串，其中 `text[x:y]` 表示字符串 `text` 中以位置 `x` 开始，位置 `y` 结束并且不包含位置 `y` 的子串。

由于题目需要求出不同的子串数目，因此我们还需要使用哈希集合（HashSet）对所有满足条件的子串进行去重操作。

```C++ [sol1-C++]
class Solution {
public:
    int distinctEchoSubstrings(string text) {
        int n = text.size();
        unordered_set<string_view> seen;
        string_view text_v(text);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int l = j - i;
                if (j * 2 - i <= n && text_v.substr(i, l) == text_v.substr(j, l) && !seen.count(text_v.substr(i, l))) {
                    ++ans;
                    seen.insert(text_v.substr(i, l));
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def distinctEchoSubstrings(self, text: str) -> int:
        n = len(text)
        seen = set()
        ans = 0
        for i in range(n):
            for j in range(i + 1, n):
                if j * 2 - i <= n and text[i:j] == text[j:j*2-i] and text[i:j] not in seen:
                    ans += 1
                    seen.add(text[i:j])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N^3)$，其中 $N$ 是字符串 `text` 的长度。我们需要两重循环枚举位置 `i` 和 `j`，时间复杂度为 $O(N^2)$，而在比较字符串 `text[i:j]` 和 `text[j:j*2-i]` 时，最坏的时间复杂度为 $O(N)$，并且将字符串加入哈希集合中的时间复杂度也为 $O(N)$，因此总时间复杂度为 $O(N^3)$。但由于本题的测试数据较弱，它可以在规定时间内通过所有的测试数据。

- 空间复杂度：$O(N^2)$ 或 $O(N^3)$，在最坏情况下，哈希集合中会存储 $O(N^2)$ 个字符串，如果我们在哈希集合中存储的是字符串视图（例如 `C++` 中的 `std::string_view`），那么每个字符串视图使用的空间为 $O(1)$，总空间复杂度为 $O(N^2)$；如果我们在哈希集合中存储的是字符串本身（例如 `C++` 中的 `std::string` 和 `Python3` 中的 `str`），那么每个字符串使用的空间为 $O(N)$，总空间复杂度为 $O(N^3)$。


#### 方法二：滚动哈希 + 前缀和

**说明**

本方法需要一些关于「滚动哈希」或「Rabin-Karp 算法」的预备知识，其核心是将字符串看成一个 `k` 进制的整数，其中 `k` 是字符串中可能出现的字符种类，本题中字符串只包含小写字母，即 `k = 26`（也可以取比 `k` 大的整数，一般来说可以取一个质数，例如 `29` 或 `31`）。这样做的好处是绕开了字符串操作，将字符串看成整数进行比较，并可以在常数时间内将字符串加入哈希集合中。

关于「滚动哈希」或「Rabin-Karp 算法」的知识，可以参考 [1044. 最长重复子串的官方题解](https://leetcode-cn.com/problems/longest-duplicate-substring/solution/zui-chang-zhong-fu-zi-chuan-by-leetcode/) 或使用搜索引擎，这里对算法本身的流程不再赘述。

**使用滚动哈希**

我们仍然在 `text` 中枚举位置 `i` 和 `j`，并判断字符串 `text[i:j]` 和 `text[j:j*2-i]` 是否相等。但与方法一不同的是，我们比较这两个字符串的哈希值，而并非字符串本身。如果仅使用 Rabin-Karp 算法计算这两个字符串的哈希值，我们仍然需要使用 $O(N)$ 的时间，与直接比较字符串的时间复杂度相同。那么我们如何在更短的时间内计算出字符串的哈希值呢？

我们可以使用类似前缀和的方法。记 `prefix[i]` 表示字符串 `text[0:i]` 的哈希值。特别地，`prefix[0]` 的值为 `0`，为空串的哈希值。我们可以在 $O(N)$ 的时间内计算出数组 `prefix` 中的所有元素，即：

$$
\text{prefix}[i] = \text{prefix}[i - 1] * k + \text{text}[i]
$$

当我们得到了前缀和数组 `prefix` 之后，如何计算任意字符串 `text[i:j]` 的哈希值呢？观察 `prefix[i]` 和 `prefix[j]` 这两项，它们的表达式为：

$$
\begin{aligned}
\text{prefix}[i] &= \text{text}[0] * k^{i - 1} + \text{text}[1] * k^{i - 2} + \cdots + \text{text}[i-1]\\
\text{prefix}[j] &= \text{text}[0] * k^{j - 1} + \text{text}[1] * k^{j - 2} + \cdots + \text{text}[j-1]
\end{aligned}
$$

如果将 `prefix[i]` 乘以 $k^{j - i}$，那么等式两侧会变为：

$$
k^{j - i} * \text{prefix}[i] = \text{text}[0] * k^{j - 1} + \text{text}[1] * k^{j - 2} + \cdots + \text{text}[i-1] * k^{j - i}
$$

将上式与 `prefix[j]` 的表达式相减，得到：

$$
\text{prefix}[j] - k^{j - i} * \text{prefix}[i] = \text{text}[i] * k^{j - i - 1} + \cdots + \text{text}[j - 1]
$$

与 `text[i:j]` 的哈希值相等，因此我们可以在 $O(1)$ 的时间计算出任意字符串 `text[i:j]` 的哈希值。在此之前，我们还需要预处理计算出所有 `k` 的次幂，不然在进行乘法操作时，仍然需要超过 $O(1)$ 的时间。

注意：上面的所有等式都省略了取模操作（如果你不知道为什么要取模，那么你对「Rabin-Karp 算法」的预备知识还没有掌握透彻），但在实际的代码编写中不能忽略，并且在取模的意义下，做减法时会产生负数。通用的写法如下所示，它同时考虑了取模和负数（在 `C++` 等语言中，还需要注意乘法可能产生的溢出）：

$$
\text{hash\_value}(\text{text}[i:j]) = (\text{prefix}[j] - k^{j - i} * \text{prefix}[i] \% \text{mod} + \text{mod}) \% \text{mod}
$$

回到我们原来的问题，当我们用字符串 `text[i:j]` 和 `text[j:j*2-i]` 的哈希值代替其本身判断是否相等后，如果两者相等，字符串 `text[i:j*2-i]` 就是一个满足条件的子串。但我们还需要进行去重操作，才能得到最终的答案。

在「判断」这一步中，由于我们只对两个字符串进行比较，因此引入哈希冲突（在下方的注意事项中也有提及）的概率极小。然而在「去重」这一步中，最坏情况下字符串的数量为 $O(N^2)$，大量的字符串造成哈希冲突的概率极大。为了减少字符串的数量以降低冲突的概率，我们可以使用 `N` 个哈希集合，分别存放不同长度的字符串，即第 `m` 个哈希集合存放长度为 `m + 1` 的字符串的哈希值。这样每个哈希集合只对某一固定长度的字符串进行去重操作，并且其中最多只有 `N` 个字符串，冲突概率非常低。

更多的实现细节请参考后面给出的代码。

**注意事项**

由于 Rabin-Karp 算法会将字符串对应的整数值进行取模，那么：

- 如果字符串 `S1` 和 `S2` 对应的整数值 `I1` 和 `I2` 不相等，那么 `S1` 和 `S2` 一定不相等；

- 如果字符串 `S1` 和 `S2` 对应的整数值 `I1` 和 `I2` 相等，并不代表 `S1` 和 `S2` 一定相等；

这与实际应用中使用的哈希算法也是一致的，即先判断两个实例的哈希值是否相等，再判断它们本质上是否相等。而在竞赛题目中，由于数据量较少，几乎不会产生哈希冲突，因此我们可以直接用 `I1` 和 `I2` 的相等代替 `S1` 和 `S2` 的相等，减少时间复杂度。但需要牢记在实际应用中，这样做是不严谨的。

```C++ [sol2-C++]
using LL = long long;

class Solution {
private:
    constexpr static int mod = (int)1e9 + 7;
    
public:
    int gethash(const vector<int>& pre, const vector<int>& mul, int l, int r) {
        return (pre[r + 1] - (LL)pre[l] * mul[r - l + 1] % mod + mod) % mod;
    }
    
    int distinctEchoSubstrings(string text) {
        int n = text.size();
        
        int base = 31;
        vector<int> pre(n + 1), mul(n + 1);
        pre[0] = 0;
        mul[0] = 1;
        for (int i = 1; i <= n; ++i) {
            pre[i] = ((LL)pre[i - 1] * base + text[i - 1]) % mod;
            mul[i] = (LL)mul[i - 1] * base % mod;
        }
        
        unordered_set<int> seen[n];
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int l = j - i;
                if (j + l <= n) {
                    int hash_left = gethash(pre, mul, i, j - 1);
                    if (!seen[l - 1].count(hash_left) && hash_left == gethash(pre, mul, j, j + l - 1)) {
                        ++ans;
                        seen[l - 1].insert(hash_left);
                    }
                }
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def distinctEchoSubstrings(self, text: str) -> int:
        n = len(text)

        mod, base = 10**9 + 7, 31
        pre, mul = [0] * (n + 1), [1] + [0] * n
        for i in range(1, n + 1):
            pre[i] = (pre[i - 1] * base + ord(text[i - 1])) % mod
            mul[i] = mul[i - 1] * base % mod
        
        def get_hash(l, r):
            return (pre[r + 1] - pre[l] * mul[r - l + 1] % mod + mod) % mod

        seen = {x: set() for x in range(n)}
        ans = 0
        for i in range(n):
            for j in range(i + 1, n):
                l = j - i
                if j + l <= n:
                    hash_left = get_hash(i, j - 1)
                    if hash_left not in seen[l - 1] and hash_left == get_hash(j, j + l - 1):
                        ans += 1
                        seen[l - 1].add(hash_left)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是字符串 `text` 的长度。

- 空间复杂度：$O(N^2)$，为在最坏情况下 $N$ 个哈希集合占用的空间。注意到也我们可以先枚举字符串的长度（外循环），再枚举字符串的起始位置（内循环），这样对于每一层外循环，由于枚举的字符串的长度相同，我们只需要使用一个而不是 $N$ 个哈希集合，空间复杂度降低至 $O(N)$。