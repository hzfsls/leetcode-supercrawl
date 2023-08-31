## [2183.统计可以被 K 整除的下标对数目 中文官方题解](https://leetcode.cn/problems/count-array-pairs-divisible-by-k/solutions/100000/tong-ji-ke-yi-bei-k-zheng-chu-de-xia-bia-ql6d)

#### 前言

本题有非常多的做法，具体原因在于求出每一个数与 $k$ 的最大公约数（时间复杂度为 $O(n \log k)$）之后，剩余的步骤需要的时间相对较少。因此剩余的步骤使用较为暴力的方法也可以通过。

本题解中会较少一种较为简洁的方法。

#### 方法一：数学

**思路与算法**

我们首先求出数组 $\textit{nums}$ 中每一个数与 $k$ 的最大公约数，这里记 $\textit{gcd}[i] = \gcd(\textit{nums}[i], k)$。求解最大公约数的意义在于，如果两个整数 $x$ 和 $y$，它们的乘积能被 $k$ 整除，那么 $\gcd(x, k) \times \gcd(y, k)$ 同样也能被 $k$ 整除，这是因为每个整数与 $k$ 包含的因数无关的部分（例如 $\dfrac{x}{\gcd(x, k)}$）不会对「是否能被 $k$ 整除」产生影响。

因此我们可以得到一个暴力的方法：

- 我们使用双重循环枚举 $i, j$，根据 $\textit{nums}[i]$ 和 $\textit{nums}[j]$ 计算出 $\textit{gcd}[i]$ 和 $\textit{gcd}[j]$，如果 $\textit{gcd}[i] \times \textit{gcd}[j]$ 能被 $k$ 整除，那么答案增加 $1$。

上述方法的时间复杂度为 $O(n^2 \log k)$，其中 $C$ 是数组 $\textit{nums}$ 中元素的范围，即为求解最大公约数需要的时间。这个时间复杂度较高，会超出时间限制，因此需要进行优化。

注意到每一个 $\textit{gcd}[i]$ 一定是 $k$ 的因数，不同的 $\textit{gcd}[i]$ 的种类不会超过 $O(\sqrt{k})$ 个（因为对于 $k$ 的任意一个因数 $u$，$u$ 和 $\dfrac{k}{u}$ 中总有一个小于等于 $\sqrt{k}$，因此 $k$ 的因数个数不会超过 $2 \times \lfloor \sqrt{k} \rfloor = O(\sqrt{k})$ 个）。这样一来，我们可以使用一个哈希映射 $\textit{freq}$ 存储所有的 $\textit{gcd}[i]$。对于哈希映射中的每一个键值对，键表示 $k$ 的某一个因数，值表示该因数在 $\textit{gcd}[i]$ 中出现的次数。

这样一来，我们只需要使用二重循环枚举哈希映射中的两个键 $x$ 和 $y$，如果 $x \times y$ 能被 $k$ 整除，那么就有 $\textit{freq}[x] \times \textit{freq}[y]$ 个满足要求的下标对。由于键的个数为 $O(\sqrt{k})$，因此枚举需要的时间为 $O(k)$。

需要注意的是，上面的方法会导致重复枚举和错误枚举：

- 对于满足要求的下标对 $(i, j)$，它会被枚举两次；

- 对于满足 $\textit{nums}[i] \times \textit{nums}[i]$ 是 $k$ 的倍数但并不合法的下标对 $(i, i)$，它会被枚举一次。

因此，在枚举完成后，我们需要再对数组 $\textit{nums}[i]$ 进行一次遍历，每遇到一个满足 $\textit{nums}[i] \times \textit{nums}[i]$ 是 $k$ 的倍数的元素，就将答案减去 $1$。在遍历完成后，我们将答案除以 $2$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long coutPairs(vector<int>& nums, int k) {
        unordered_map<int, int> freq;
        for (int num: nums) {
            ++freq[gcd(num, k)];
        }

        long long ans = 0;
        for (auto&& [x, occx]: freq) {
            for (auto&& [y, occy]: freq) {
                if (static_cast<long long>(x) * y % k == 0) {
                    ans += static_cast<long long>(occx) * occy;
                }
            }
        }

        for (int num: nums) {
            if (static_cast<long long>(num) * num % k == 0) {
                --ans;
            }
        }

        return ans / 2;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def coutPairs(self, nums: List[int], k: int) -> int:
        freq = Counter(gcd(num, k) for num in nums)

        ans = 0
        for x in freq:
            for y in freq:
                if x * y % k == 0:
                    ans += freq[x] * freq[y]

        for num in nums:
            if num * num % k == 0:
                ans -= 1

        return ans // 2
```

**复杂度分析**

- 时间复杂度：$O(n \log k + k)$。

- 空间复杂度：$O(\sqrt{k})$，即为哈希映射需要的空间。