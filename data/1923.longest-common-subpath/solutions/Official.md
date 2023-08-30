#### 前言

本题为[「718. 最长重复子数组」](https://leetcode-cn.com/problems/maximum-length-of-repeated-subarray/)的扩展题，需要求出多个数组的最长重复子数组。

在[「718. 最长重复子数组」的官方题解](https://leetcode-cn.com/problems/maximum-length-of-repeated-subarray/solution/zui-chang-zhong-fu-zi-shu-zu-by-leetcode-solution/)中，方法一与方法二对于本题而言，时间复杂度较高且不适用，因此我们需要使用方法三解决本题。

由于本题难度较大，本题解会将解题思路完整地讲解一遍。

#### 方法一：二分查找 + 滚动哈希

**提示 $1$**

假设给定的 $m$ 个数组有长度为 $\textit{len}$ 的公共子数组，那么它们一定也有长度为 $1, 2, \cdots, \textit{len}-1$ 的公共子数组。

因此，一定存在一个长度 $\textit{len}'$，使得：

- 当 $\textit{len} \leq \textit{len}'$ 时，给定的 $m$ 个数组存在长度为 $\textit{len}$ 的公共子数组；

- 当 $\textit{len} > \textit{len}'$ 时，给定的 $m$ 个子数组不存在长度为 $\textit{len}$ 的公共子数组。

这里的 $\textit{len}'$ 即为我们需要求出的答案。因此我们可以使用二分查找的方法求出 $\textit{len}'$。二分查找的下界为 $1$，上界为 $m$ 个数组中最短的数组长度。在二分查找的每一步中，我们需要解决一个判定问题，即：

> 判断给定的 $m$ 个数组是否存在长度为 $\textit{len}$ 的公共子数组。

**提示 $2$**

对于提示 $1$ 中的判定问题，我们可以考虑：

- 对于第 $i$ 个数组，我们将其中所有长度为 $\textit{len}$ 的子数组提取出来，并放入哈希集合 $\textit{set}[i]$ 中，去除重复的子数组。如果第 $i$ 个数组的长度为 $\textit{size}[i]$，那么不重复的子数组的数量最多为 $\textit{size}[i] - \textit{len} + 1$ 个；

- 我们求出所有的 $m$ 个 $\textit{set}[i]$ 的**并集**，如果该并集不为空，即表示存在至少一个长度为 $\textit{len}$ 的数组，它是所有的 $m$ 个数组的子数组，说明判定成立；如果并集为空，说明判定不成立。

那么上述方法的时间复杂度是多少呢？我们先不去详细地讨论具体该如何求出 $\textit{set}[i]$ 的并集，但我们至少需要把每一个 $\textit{set}[i]$ 中的每一个子数组都遍历一遍，那么遍历的时间复杂度为：

$$
O\left(\sum_{i=0}^{m-1} (\textit{size}[i] - \textit{len} + 1) \cdot \textit{len}\right)
$$

考虑极端情况，$m = 2$，$\textit{size}[i] = 5\times 10^4$，$\textit{len} = \dfrac{\textit{size}[i]}{2} = 2.5 \times 10^4$，带入上述时间复杂度会得到 $10^8$ 的数量级，会超出时间限制。

因此我们需要考虑一种将长度为 $\textit{len}$ 的子数组进行「压缩」的方法，使得：

- 我们可以快速求出第 $i$ 个数组中的每一个长度为 $\textit{len}$ 的子数组的「压缩」结果；

- 我们需要通过「压缩」结果代替子数组本身进行去重和求并集操作。

那么「滚动哈希」就是一种符合要求的方法。

**滚动哈希**

滚动哈希（rolling hash）也叫 $\texttt{Rabin-Karp}$ 字符串哈希算法，它将一个字符串看成某个进制下的整数，并将其对应的十进制值作为哈希值。在本题中，我们也可以将一个子数组看成某个进制下的整数，例如：

> 设数组 $a$ 的长度为 $n$，元素为 $a[0], a[1], \cdots, a[n-1]$，数组元素的最大值为 $\max a$。我们选取进制 $k$ 满足 $k > \max a$，将数组 $a$ 看成一个 $n$ 位的 $k$ 进制整数，那么其对应的十进制值为：
>
> $$
> \sum_{i=0}^{n-1} a[i] \cdot k^{n-1-i}
> $$

这样一来，**在子数组长度固定的前提下**，给定进制 $k$，子数组与其十进制值满足「一一对应」的关系，即不会有两个不同的子数组，它们的十进制值相同。因此滚动哈希得到的哈希值是可以表示原子数组的。

滚动哈希的一大优势在于，如果我们需要求出一个数组中长度为 $\textit{len}$ 的所有子数组的哈希值，需要的时间仅为线性，即如果我们已经计算出数组中以 $j$ 开始的子数组的哈希值：

$$
\textit{hash}[j] = \sum_{i=0}^{\textit{len}-1} a[j+i] \cdot k^{\textit{len}-1-i}
$$

那么要想计算以 $j+1$ 开始的子数组的哈希值，我们通过递推：

$$
\begin{aligned}
\textit{hash}[j+1] &= \sum_{i=0}^{\textit{len}-1} a[j+1+i] \cdot k^{\textit{len}-1-i} \\
&= \sum_{i=1}^{\textit{len}} a[j+i] \cdot k^{\textit{len}-i} \\
&= k \cdot \left( \sum_{i=1}^{\textit{len}} a[j+i] \cdot k^{\textit{len}-1-i} \right) \\
&= k \cdot (\textit{hash}[j] - a[j] \cdot k^{\textit{len}-1} + a[j+\textit{len}] \cdot k^{-1}) \\
&= \textit{hash}[j] \cdot k - a[j] \cdot k^\textit{len} + a[j+\textit{len}]
\end{aligned}
$$

即可在 $O(1)$ 的时间内得到该值。

**思路与算法**

根据上述的提示以及滚动哈希的方法，我们就可以设计出解决判定问题的算法：

- 我们首先对第 $0$ 个数组，计算其所有长度为 $\textit{len}$ 的子数组的哈希值，并放入哈希集合 $\textit{set}[0]$ 中；

- 随后我们依次遍历第 $1, 2, \cdots, m-1$ 个数组。在计算第 $i$ 个数组中所有长度为 $\textit{len}$ 的子数组的哈希值时，设当前计算出的哈希值为 $\textit{hash}$，只有当 $\textit{set}[i-1]$ 中包含 $\textit{hash}$ 时，我们才会将 $\textit{hash}$ 放入 $\textit{set}[i]$ 中；

- 遍历完成后，根据 $\textit{set}[m-1]$ 是否为空，调整二分查找的边界。

该算法的时间复杂度为：

$$
O\left(\sum_{i=0}^{m-1} size[i] \right)
$$

二分查找需要进行 $O(\log (\min \textit{size}[i]))$ 次，可以通过本题。

**滚动哈希的局限性**

在上面的分析中，我们忽略了很重要的一点：

> 子数组的哈希值会很大，可能会超过 $32$ 位甚至 $64$ 位整数类型，无法使用语言自带的类型进行存储。即使我们自行实现一个高精度类型，此时也不能将其单次运算的时间复杂度看成 $O(1)$，这样时间复杂度的计算是不合理的。

在滚动哈希中，一种可行的解决方法是将计算出的哈希值对一个整数 $\textit{mod}$ 进行取模，使其能够使用语言自带的整数类型存储。然而这样做会带来哈希冲突，即：

> 两个不同的子数组计算出的哈希值不同，但它们取模后的结果相同。

这是我们必须要解决的问题。

**生日悖论**

生日悖论告诉我们，如果我们随机选择 $23$ 个人，那么其中至少有两个人生日相同的概率大于 $50\%$。对于一般情况，如果我们在 $N$ 个数中可重复地随机选择 $K$ 个数，那么在 $K = O(\sqrt{N})$ 的前提下，我们选择的 $K$ 个数中存在重复的概率非常高。

回到本题，一个数组中最多会有 $10^5$ 个子数组，可以看成随机选择 $10^5$ 个数，而取模使用到的整数 $\textit{mod}$ 可以看成选择的范围是 $[0, \textit{mod})$ 共 $\textit{mod}$ 个数，因此 $\textit{mod}$ 必须远大于 $(10^5)^2 = 10^{10}$ 才可以尽量减少冲突。

**冲突是无法避免的**

实际上，如果能够预先知道代码中使用的进制 $k$ 以及取模 $\textit{mod}$，那么一定是能构造出两个哈希冲突的子数组的（只要使得一个子数组全为 $0$，另一个子数组对应的十进制值为 $\textit{mod}$ 即可）。因此，冲突是无法避免的。

但由于本题的出现场合是笔试，我们的目标是要「通过所有的测试数据」，因此我们可以通过「调参」的方法，选择合适的 $k$ 和 $\textit{mod}$，使代码通过全部的测试数据即可。例如，我们可以随机选择 $k$，并且选择质数作为 $\textit{mod}$，减少冲突的可能。

但如果是在工业代码中，**我们是必须要进行冲突检测的**，即如果两个子数组的哈希值取模后的值相等，**我们必须要去比较这两个子数组本身**，才能判定它们是否相同。这样做会导致时间复杂度的增加，但在工业代码中**是没有测试数据一说的，要保证的是系统 $100\%$ 正确，而不是投机取巧**。因此如果在面试中遇到本题，在提出基于滚动哈希的做法后，一定要和面试官积极地沟通哈希冲突的解决方案。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 根据正文部分的分析，我们选择的 mod 需要远大于 10^10
    // 所以 C++ 语言中我们需要用到 long long 类型
    // 那么在进行哈希值的运算时，中间值会超出 long long 类型的上限，而没有更大的类型了
    // 因此我们可以使用一种折中的办法：对 mod1 和 mod2 分别取模，得到一个二元组
    // 这本质上与对 mod1 * mod2 取模是一致的，这里我们选择 mod1=10^9+7，mod2=10^9+9
    // 它们都是质数，乘积约为 10^18，远大于 10^10
    static constexpr int mod1 = 1000000007;
    static constexpr int mod2 = 1000000009;

    // 由于我们得到的哈希是二元组，C++ 默认不支持将 pair 放入哈希表，我们需要自行实现哈希函数
    struct pairhash {
        size_t operator() (const pair<int, int>& p) const {
            auto fn = hash<int>();
            return (fn(p.first) << 16) ^ fn(p.second);
        }
    };

    using LL = long long;
    
public:
    int longestCommonSubpath(int n, vector<vector<int>>& paths) {
        // 本题中数组元素的范围为 [0, 10^5]
        // 因此我们在 [10^6, 10^7] 的范围内随机选取进制 base
        // 为了更减少冲突，我们可以对 mod1 和 mod2 分别选取 base1 和 base2
        mt19937 gen{random_device{}()};
        auto dis = uniform_int_distribution<int>(1e6, 1e7);
        int base1 = dis(gen);
        int base2 = dis(gen);
        
        int m = paths.size();
        // 确定二分查找的上下界
        int left = 1, right = min_element(paths.begin(), paths.end(), [](const auto& p1, const auto& p2) {return p1.size() < p2.size();})->size();
        int ans = 0;
        while (left <= right) {
            int len = (left + right) / 2;
            // 预处理 mult1=base1^len, mult2=base2^len
            int mult1 = 1, mult2 = 1;
            for (int i = 1; i <= len; ++i) {
                mult1 = (LL)mult1 * base1 % mod1;
                mult2 = (LL)mult2 * base2 % mod2;
            }
            
            unordered_set<pair<int, int>, pairhash> s;
            bool check = true;
            for (int i = 0; i < m; ++i) {
                int hash1 = 0, hash2 = 0;
                // 计算首个长度为 len 的子数组的哈希值
                for (int j = 0; j < len; ++j) {
                    hash1 = ((LL)hash1 * base1 + paths[i][j]) % mod1;
                    hash2 = ((LL)hash2 * base2 + paths[i][j]) % mod2;
                }

                unordered_set<pair<int, int>, pairhash> t;
                // 如果我们遍历的是第 0 个数组，或者上一个数组的哈希表中包含该二元组
                // 我们才会将二元组加入当前数组的哈希表中
                if (i == 0 || s.count({hash1, hash2})) {
                    t.emplace(hash1, hash2);
                }
                // 递推计算后续子数组的哈希值
                for (int j = len; j < paths[i].size(); ++j) {
                    hash1 = (((LL)hash1 * base1 % mod1 - (LL)paths[i][j - len] * mult1 % mod1 + paths[i][j]) % mod1 + mod1) % mod1;
                    hash2 = (((LL)hash2 * base2 % mod2 - (LL)paths[i][j - len] * mult2 % mod2 + paths[i][j]) % mod2 + mod2) % mod2;
                    if (i == 0 || s.count({hash1, hash2})) {
                        t.emplace(hash1, hash2);
                    }
                }
                if (t.empty()) {
                    check = false;
                    break;
                }
                s = move(t);
            }
            
            if (check) {
                ans = len;
                left = len + 1;
            }
            else {
                right = len - 1;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def longestCommonSubpath(self, n: int, paths: List[List[int]]) -> int:
        # 根据正文部分的分析，我们选择的 mod 需要远大于 10^10
        # Python 直接选择 10^9+7 * 10^9+9 作为模数即可
        # 乘积约为 10^18，远大于 10^10
        mod = (10**9 + 7) * (10**9 + 9)

        # 本题中数组元素的范围为 [0, 10^5]
        # 因此我们在 [10^6, 10^7] 的范围内随机选取进制 base
        base = random.randint(10**6, 10**7)
        
        m = len(paths)
        # 确定二分查找的上下界
        left, right, ans = 1, len(min(paths, key=lambda p: len(p))), 0
        while left <= right:
            length = (left + right) // 2
            mult = pow(base, length, mod)
            s = set()
            check = True

            for i in range(m):
                hashvalue = 0
                # 计算首个长度为 len 的子数组的哈希值
                for j in range(length):
                    hashvalue = (hashvalue * base + paths[i][j]) % mod

                t = set()
                # 如果我们遍历的是第 0 个数组，或者上一个数组的哈希表中包含该哈希值
                # 我们才会将哈希值加入当前数组的哈希表中
                if i == 0 or hashvalue in s:
                    t.add(hashvalue)
                # 递推计算后续子数组的哈希值
                for j in range(length, len(paths[i])):
                    hashvalue = (hashvalue * base - paths[i][j - length] * mult + paths[i][j]) % mod
                    if i == 0 or hashvalue in s:
                        t.add(hashvalue)
                if not t:
                    check = False
                    break
                s = t
            
            if check:
                ans = length
                left = length + 1
            else:
                right = length - 1
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(l \log l)$，其中 $l = \sum_{i=0}^{m-1} size[i]$ 是所有数组的总长度。

    - 在最坏情况下（只有一个数组），二分查找的次数为 $O(\log l)$；

    - 在二分查找的每一步中，我们需要 $O(l)$ 的时间计算每一个数组的长度为 $\textit{len}$ 的子数组的哈希值。

- 空间复杂度：$O(l)$，即为存储哈希值需要的空间。

#### 方法二：后缀数组

**思路与算法**

本题也有基于后缀数组的、无需解决冲突的方法。但这种方法远超过了面试和笔试难度，因此这里不会进行说明。

如果读者对此感兴趣，可以参考罗穗骞的 IOI2009 国家集训队论文《后缀数组——处理字符串的有力工具》。其中 2.4 节给出了如何使用后缀数组解决多个字符串的最长公共子串的问题，与本题的目标是一致的。