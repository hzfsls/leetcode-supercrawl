## [1390.四因数 中文官方题解](https://leetcode.cn/problems/four-divisors/solutions/100000/si-yin-shu-by-leetcode-solution)
#### 方法一：枚举

我们可以遍历数组 `nums` 中的每个元素，依次判断这些元素是否恰好有四个因数。对于任一元素 `x`，我们可以用类似质数判定的方法得到它的因数个数，其本质为：如果整数 `x` 有因数 `y`，那么也必有因数 `x/y`，并且 `y` 和 `x/y` 中至少有一个不大于 `sqrt(x)`。这样我们只需要在 `[1, sqrt(x)]` 的区间内枚举可能为整数 `x` 的因数 `y`，并通过 `x/y` 得到整数 `x` 的其它因数，时间复杂度为 $O(\sqrt{x})$。

如果 `x` 恰好有四个因数，我们就将其因数之和累加到答案中。

```C++ [sol1-C++]
class Solution {
public:
    int sumFourDivisors(vector<int>& nums) {
        int ans = 0;
        for (int num: nums) {
            // factor_cnt: 因数的个数
            // factor_sum: 因数的和
            int factor_cnt = 0, factor_sum = 0;
            for (int i = 1; i * i <= num; ++i) {
                if (num % i == 0) {
                    ++factor_cnt;
                    factor_sum += i;
                    if (i * i != num) {   // 判断 i 和 num/i 是否相等，若不相等才能将 num/i 看成新的因数
                        ++factor_cnt;
                        factor_sum += num / i;
                    }
                }
            }
            if (factor_cnt == 4) {
                ans += factor_sum;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumFourDivisors(int[] nums) {
        int ans = 0;
        for (int num : nums) {
            // factor_cnt: 因数的个数
            // factor_sum: 因数的和
            int factor_cnt = 0, factor_sum = 0;
            for (int i = 1; i * i <= num; ++i) {
                if (num % i == 0) {
                    ++factor_cnt;
                    factor_sum += i;
                    if (i * i != num) {   // 判断 i 和 num/i 是否相等，若不相等才能将 num/i 看成新的因数
                        ++factor_cnt;
                        factor_sum += num / i;
                    }
                }
            }
            if (factor_cnt == 4) {
                ans += factor_sum;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sumFourDivisors(self, nums: List[int]) -> int:
        ans = 0
        for num in nums:
            # factor_cnt: 因数的个数
            # factor_sum: 因数的和
            factor_cnt = factor_sum = 0
            i = 1
            while i * i <= num:
                if num % i == 0:
                    factor_cnt += 1
                    factor_sum += i
                    if i * i != num:   # 判断 i 和 num/i 是否相等，若不相等才能将 num/i 看成新的因数
                        factor_cnt += 1
                        factor_sum += num // i
                i += 1
            if factor_cnt == 4:
                ans += factor_sum
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N\sqrt{C})$，其中 $N$ 是数组 `nums` 的长度，$C$ 是数组 `nums` 中元素值的范围，在本题中 $C$ 不超过 $10^5$。

- 空间复杂度：$O(1)$。

#### 方法二：预处理

**预备知识**

- [算数基本定理](https://baike.baidu.com/item/%E7%AE%97%E6%9C%AF%E5%9F%BA%E6%9C%AC%E5%AE%9A%E7%90%86)

- [埃拉托斯特尼筛法](https://baike.baidu.com/item/%E5%9F%83%E6%8B%89%E6%89%98%E6%96%AF%E7%89%B9%E5%B0%BC%E7%AD%9B%E6%B3%95) 或更高级的欧拉筛法

**分析与算法**

直觉告诉我们，恰好有四个因数的整数不会有很多，我们是否可以预先找出它们呢？

根据「算数基本定理」（又叫「唯一分解定理」），如果整数 $x$ 可以分解为：

$$
x = p_1^{\alpha_1}p_2^{\alpha_2}\cdots p_k^{\alpha_k}
$$

其中 $p_i$ 为互不相同的质数（即 $x$ 的质因数）。那么 $x$ 的因数个数为：

$$
\textit{factor\_count}(x) = \prod_{i=1}^k (\alpha_i + 1)
$$

如果 $\textit{factor\_count}(x)$ 的值为 $4$，那么只有两种可能：

- 整数 $x$ 只有一个质因数，对应的指数为 $3$，此时 $\textit{factor\_count}(x) = (3+1) = 4$；

- 整数 $x$ 有两个质因数，对应的指数均为 $1$，此时 $\textit{factor\_count}(x) = (1+1)(1+1) = 4$。

对于第一种情况，我们需要找到所有不大于 $C^{1/3}$ 的质数；对于第二种情况，我们需要找到所有不大于 $C$ 的质数，再将它们两两相乘并筛去超过 $C$ 的那些结果。这里 $C$ 的定义与方法一中的复杂度分析部分一致。综上所述，我们需要找到所有不大于 $C$ 的质数。

我们如何找出所有不大于 $C$ 的质数呢？这时就需要「埃拉托斯特尼筛法」或「欧拉筛法」的帮助了。它们可以帮助我们快速找到这些质数。这两种筛法的算法细节不是这篇题解的重点，这里不再赘述。在找到了这些质数后，我们就可以构造出所有满足上述两种可能的 $x$ 了。我们将 $x$ 以及它的因数之和存入哈希映射（HashMap）中，这样就可以在 $O(1)$ 的时间判断数组 `nums` 中的每个元素是否满足要求，并统计满足要求的元素的因数之和了。

下面的代码给出了 Python 和 C++ 语言的「埃拉托斯特尼筛法」以及「欧拉筛法」的实现。

```C++ [sol2-C++]
class Solution {
public:
    int sumFourDivisors(vector<int>& nums) {
        // C 是数组 nums 元素的上限，C3 是 C 的立方根
        int C = 100000, C3 = 46;
        
        vector<int> isprime(C + 1, 1);
        vector<int> primes;

        // 埃拉托斯特尼筛法
        for (int i = 2; i <= C; ++i) {
            if (isprime[i]) {
                primes.push_back(i);
            }
            for (int j = i + i; j <= C; j += i) {
                isprime[j] = 0;
            }
        }

        // 欧拉筛法
        /*
        for (int i = 2; i <= C; ++i) {
            if (isprime[i]) {
                primes.push_back(i);
            }
            for (int prime: primes) {
                if (i * prime > C) {
                    break;
                }
                isprime[i * prime] = 0;
                if (i % prime == 0) {
                    break;
                }
            }
        }
        */
        
        // 通过质数表构造出所有的四因数
        unordered_map<int, int> factor4;
        for (int prime: primes) {
            if (prime <= C3) {
                factor4[prime * prime * prime] = 1 + prime + prime * prime + prime * prime * prime;
            }
        }
        for (int i = 0; i < primes.size(); ++i) {
            for (int j = i + 1; j < primes.size(); ++j) {
                if (primes[i] <= C / primes[j]) {
                    factor4[primes[i] * primes[j]] = 1 + primes[i] + primes[j] + primes[i] * primes[j];
                }
                else {
                    break;
                }
            }
        }

        int ans = 0;
        for (int num: nums) {
            if (factor4.count(num)) {
                ans += factor4[num];
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int sumFourDivisors(int[] nums) {
        // C 是数组 nums 元素的上限，C3 是 C 的立方根
        int C = 100000, C3 = 46;
        
        boolean[] isPrime = new boolean[C + 1];
        Arrays.fill(isPrime, true);
        List<Integer> primes = new ArrayList<Integer>();

        // 埃拉托斯特尼筛法
        for (int i = 2; i <= C; ++i) {
            if (isPrime[i]) {
                primes.add(i);
            }
            for (int j = i + i; j <= C; j += i) {
                isPrime[j] = false;
            }
        }

        // 欧拉筛法
        /*
        for (int i = 2; i <= C; ++i) {
            if (isPrime[i]) {
                primes.add(i);
            }
            for (int prime : primes) {
                if (i * prime > C) {
                    break;
                }
                isPrime[i * prime] = false;
                if (i % prime == 0) {
                    break;
                }
            }
        }
        */
        
        // 通过质数表构造出所有的四因数
        Map<Integer, Integer> factor4 = new HashMap<Integer, Integer>();
        for (int prime : primes) {
            if (prime <= C3) {
                factor4.put(prime * prime * prime, 1 + prime + prime * prime + prime * prime * prime);
            }
        }
        for (int i = 0; i < primes.size(); ++i) {
            for (int j = i + 1; j < primes.size(); ++j) {
                if (primes.get(i) <= C / primes.get(j)) {
                    factor4.put(primes.get(i) * primes.get(j), 1 + primes.get(i) + primes.get(j) + primes.get(i) * primes.get(j));
                } else {
                    break;
                }
            }
        }

        int ans = 0;
        for (int num : nums) {
            if (factor4.containsKey(num)) {
                ans += factor4.get(num);
            }
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def sumFourDivisors(self, nums: List[int]) -> int:
        # C 是数组 nums 元素的上限，C3 是 C 的立方根
        C, C3 = 100000, 46

        isprime = [True] * (C + 1)
        primes = list()

        # 埃拉托斯特尼筛法
        for i in range(2, C + 1):
            if isprime[i]:
                primes.append(i)
            for j in range(i + i, C + 1, i):
                isprime[j] = False
        
        # 欧拉筛法
        """
        for i in range(2, C + 1):
            if isprime[i]:
                primes.append(i)
            for prime in primes:
                if i * prime > C:
                    break
                isprime[i * prime] = False
                if i % prime == 0:
                    break
        """
        
        # 通过质数表构造出所有的四因数
        factor4 = dict()
        for prime in primes:
            if prime <= C3:
                factor4[prime**3] = 1 + prime + prime**2 + prime**3
        for i in range(len(primes)):
            for j in range(i + 1, len(primes)):
                if primes[i] * primes[j] <= C:
                    factor4[primes[i] * primes[j]] = 1 + primes[i] + primes[j] + primes[i] * primes[j]
                else:
                    break
        
        ans = 0
        for num in nums:
            if num in factor4:
                ans += factor4[num]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(\pi^2(C) + C\log\log C + N)$ 或 $O(\pi^2(C) + C + N)$，其中 $\pi(X)$ 为「质数计数函数」，表示不超过 $X$ 的质数个数。「埃拉托斯特尼筛法」的时间复杂度为 $O(C\log\log C)$，「欧拉筛法」的时间复杂度为 $O(C)$；通过质数表构造出所有四因数的时间复杂度为 $O(\pi(C^{1/3})) + O(\pi^2(C)) = O(\pi^2(C))$，遍历数组 `nums` 中的所有元素并检查是否为四因数的时间复杂度为 $O(N)$。

- 空间复杂度：$O(C + \pi(C))$，无论哪一种筛法，都需要长度为 $C$ 的数组记录每个数是否为质数，以及长度为 $\pi(C)$ 的数组存储所有的质数。