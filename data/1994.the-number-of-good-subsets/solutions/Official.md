## [1994.好子集的数目 中文官方题解](https://leetcode.cn/problems/the-number-of-good-subsets/solutions/100000/hao-zi-ji-de-shu-mu-by-leetcode-solution-ky65)

#### 方法一：状态压缩动态规划

**思路与算法**

注意到题目规定数组 $\textit{nums}$ 中的元素不超过 $30$，因此我们可以将 $[1, 30]$ 中的整数分成如下三类：

- $1$：对于任意一个好子集而言，我们添加任意数目的 $1$，得到的新子集仍然是好子集；

- $2,3,5,6,7,10,11,13,14,15,17,19,21,22,23,26,29,30$：这些数均不包含平方因子，因此每个数在好子集中至多出现一次；

- $4,8,9,12,16,18,20,24,25,27,28$：这些数包含平方因子，因此一定不能在好子集中出现。

我们可以通过硬编码的方式把 $[1, 30]$ 中的整数按照上述分类，也可以先预处理出所有 $[1, 30]$ 中质数 $2,3,5,7,11,13,17,19,23,29$，再通过试除的方式动态分类。

分类完成后，我们就可以考虑动态规划了。由于每个质因数只能出现一次，并且 $[1, 30]$ 中一共有 $10$ 个质数，因此我们可以用一个长度为 $10$ 的二进制数 $\textit{mask}$ 表示这些质因数的使用情况，其中 $\textit{mask}$ 的第 $i$ 位为 $1$ 当且仅当第 $i$ 个质数已经被使用过。

这样一来，我们定义 $f[i][\textit{mask}]$ 表示当我们只选择 $[2, i]$ 范围内的数，并且选择的数的质因数使用情况为 $\textit{mask}$ 时的方案数。如果 $i$ 本身包含平方因子，那么我们无法选择 $i$，相当于在 $[2, i-1]$ 范围内选择，状态转移方程为：

$$
f[i][\textit{mask}] = f[i-1][\textit{mask}]
$$

如果 $i$ 本身不包含平方因子，记其包含的质因子的二进制表示为 $\textit{subset}$（同样可以通过试除的方法得到），那么状态转移方程为：

$$
f[i][\textit{mask}] = f[i - 1][\textit{mask}] + f[i-1][\textit{mask} \backslash \textit{subset}] \times \textit{freq}[i]
$$

其中：

- $\textit{freq}[i]$ 表示数组 $\textit{nums}$ 中 $i$ 出现的次数；

- $\textit{mask} \backslash \textit{subset}$ 表示从二进制表示 $\textit{mask}$ 中去除所有在 $\textit{subset}$ 中出现的 $1$，可以使用按位异或运算实现。这里需要保证 $\textit{subset}$ 是 $\textit{mask}$ 的子集，可以使用按位与运算来判断。

动态规划的边界条件为：

$$
f[1][0] = 2^{\textit{freq}[1]}
$$

即每一个在数组 $\textit{nums}$ 中出现的 $1$ 都可以选或不选。最终的答案即为所有 $f[30][..]$ 中除了 $f[30][0]$ 以外的项的总和。

**细节**

注意到 $f[i][\textit{mask}]$ 只会从 $f[i-1][..]$ 转移而来，并且 $f[i-1][..]$ 中的下标总是小于 $\textit{mask}$，因此我们可以使用类似 $0-1$ 背包的空间优化方法，在遍历 $\textit{mask}$ 时从 $2^{10}-1$ 到 $1$ 逆序遍历，这样就只需要使用一个长度为 $2^{10}$ 的一维数组做状态转移了。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr array<int, 10> primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
    static constexpr int num_max = 30;
    static constexpr int mod = 1000000007;

public:
    int numberOfGoodSubsets(vector<int>& nums) {
        vector<int> freq(num_max + 1);
        for (int num: nums) {
            ++freq[num];
        }

        vector<int> f(1 << primes.size());
        f[0] = 1;
        for (int _ = 0; _ < freq[1]; ++_) {
            f[0] = f[0] * 2 % mod;
        }
        
        for (int i = 2; i <= num_max; ++i) {
            if (!freq[i]) {
                continue;
            }
            
            // 检查 i 的每个质因数是否均不超过 1 个
            int subset = 0, x = i;
            bool check = true;
            for (int j = 0; j < primes.size(); ++j) {
                int prime = primes[j];
                if (x % (prime * prime) == 0) {
                    check = false;
                    break;
                }
                if (x % prime == 0) {
                    subset |= (1 << j);
                }
            }
            if (!check) {
                continue;
            }

            // 动态规划
            for (int mask = (1 << primes.size()) - 1; mask > 0; --mask) {
                if ((mask & subset) == subset) {
                    f[mask] = (f[mask] + static_cast<long long>(f[mask ^ subset]) * freq[i]) % mod;
                }
            }
        }

        int ans = 0;
        for (int mask = 1, mask_max = (1 << primes.size()); mask < mask_max; ++mask) {
            ans = (ans + f[mask]) % mod;
        }
        
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int[] PRIMES = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
    static final int NUM_MAX = 30;
    static final int MOD = 1000000007;

    public int numberOfGoodSubsets(int[] nums) {
        int[] freq = new int[NUM_MAX + 1];
        for (int num : nums) {
            ++freq[num];
        }

        int[] f = new int[1 << PRIMES.length];
        f[0] = 1;
        for (int i = 0; i < freq[1]; ++i) {
            f[0] = f[0] * 2 % MOD;
        }
        
        for (int i = 2; i <= NUM_MAX; ++i) {
            if (freq[i] == 0) {
                continue;
            }
            
            // 检查 i 的每个质因数是否均不超过 1 个
            int subset = 0, x = i;
            boolean check = true;
            for (int j = 0; j < PRIMES.length; ++j) {
                int prime = PRIMES[j];
                if (x % (prime * prime) == 0) {
                    check = false;
                    break;
                }
                if (x % prime == 0) {
                    subset |= (1 << j);
                }
            }
            if (!check) {
                continue;
            }

            // 动态规划
            for (int mask = (1 << PRIMES.length) - 1; mask > 0; --mask) {
                if ((mask & subset) == subset) {
                    f[mask] = (int) ((f[mask] + ((long) f[mask ^ subset]) * freq[i]) % MOD);
                }
            }
        }

        int ans = 0;
        for (int mask = 1, maskMax = (1 << PRIMES.length); mask < maskMax; ++mask) {
            ans = (ans + f[mask]) % MOD;
        }
        
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[] PRIMES = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
    static int NUM_MAX = 30;
    static int MOD = 1000000007;

    public int NumberOfGoodSubsets(int[] nums) {
        int[] freq = new int[NUM_MAX + 1];
        foreach (int num in nums) {
            ++freq[num];
        }

        int[] f = new int[1 << PRIMES.Length];
        f[0] = 1;
        for (int i = 0; i < freq[1]; ++i) {
            f[0] = f[0] * 2 % MOD;
        }
        
        for (int i = 2; i <= NUM_MAX; ++i) {
            if (freq[i] == 0) {
                continue;
            }
            
            // 检查 i 的每个质因数是否均不超过 1 个
            int subset = 0, x = i;
            bool check = true;
            for (int j = 0; j < PRIMES.Length; ++j) {
                int prime = PRIMES[j];
                if (x % (prime * prime) == 0) {
                    check = false;
                    break;
                }
                if (x % prime == 0) {
                    subset |= (1 << j);
                }
            }
            if (!check) {
                continue;
            }

            // 动态规划
            for (int mask = (1 << PRIMES.Length) - 1; mask > 0; --mask) {
                if ((mask & subset) == subset) {
                    f[mask] = (int) ((f[mask] + ((long) f[mask ^ subset]) * freq[i]) % MOD);
                }
            }
        }

        int ans = 0;
        for (int mask = 1, maskMax = (1 << PRIMES.Length); mask < maskMax; ++mask) {
            ans = (ans + f[mask]) % MOD;
        }
        
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfGoodSubsets(self, nums: List[int]) -> int:
        primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
        mod = 10**9 + 7

        freq = Counter(nums)
        f = [0] * (1 << len(primes))
        f[0] = pow(2, freq[1], mod)

        for i, occ in freq.items():
            if i == 1:
                continue
            
            # 检查 i 的每个质因数是否均不超过 1 个
            subset, x = 0, i
            check = True
            for j, prime in enumerate(primes):
                if x % (prime * prime) == 0:
                    check = False
                    break
                if x % prime == 0:
                    subset |= (1 << j)
            
            if not check:
                continue

            # 动态规划
            for mask in range((1 << len(primes)) - 1, 0, -1):
                if (mask & subset) == subset:
                    f[mask] = (f[mask] + f[mask ^ subset] * occ) % mod

        ans = sum(f[1:]) % mod
        return ans
```

```C [sol1-C]
const int PRIMES[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29}; 
const int NUM_MAX = 30;
const int MOD = 1000000007;

int numberOfGoodSubsets(int* nums, int numsSize){
    int primesSize = sizeof(PRIMES) / sizeof(int);
    int * freq = (int *)malloc(sizeof(int) * (NUM_MAX + 1));
    memset(freq, 0, sizeof(int) * (NUM_MAX + 1));
    for (int i = 0; i < numsSize; i++) {
        ++freq[nums[i]];
    }
    int * f = (int *)malloc(sizeof(int) * (1 << primesSize));
    memset(f, 0, sizeof(int) * (1 << primesSize));
    f[0] = 1;
    for (int i = 0; i < freq[1]; ++i) {
        f[0] = f[0] * 2 % MOD;
    }
    
    for (int i = 2; i <= NUM_MAX; ++i) {
        if (!freq[i]) {
            continue;
        }
        
        // 检查 i 的每个质因数是否均不超过 1 个
        int subset = 0, x = i;
        bool check = true;
        for (int j = 0; j < primesSize; ++j) {
            int prime = PRIMES[j];
            if (x % (prime * prime) == 0) {
                check = false;
                break;
            }
            if (x % prime == 0) {
                subset |= (1 << j);
            }
        }
        if (!check) {
            continue;
        }

        // 动态规划
        for (int mask = (1 << primesSize) - 1; mask > 0; --mask) {
            if ((mask & subset) == subset) {
                f[mask] = (f[mask] + (long)(f[mask ^ subset]) * freq[i]) % MOD;
            }
        }
    }

    int ans = 0;
    for (int mask = 1, mask_max = (1 << primesSize); mask < mask_max; ++mask) {
        ans = (ans + f[mask]) % MOD;
    }
    free(freq);
    free(f);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
const PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];
const NUM_MAX = 30;
const MOD = 1000000007;
var numberOfGoodSubsets = function(nums) {
    const freq = new Array(NUM_MAX + 1).fill(0);
    for (const num of nums) {
        ++freq[num];
    }

    const f = new Array(1 << PRIMES.length).fill(0);
    f[0] = 1;
    for (let i = 0; i < freq[1]; ++i) {
        f[0] = f[0] * 2 % MOD;
    }
    
    for (let i = 2; i <= NUM_MAX; ++i) {
        if (freq[i] === 0) {
            continue;
        }
        
        // 检查 i 的每个质因数是否均不超过 1 个
        let subset = 0, x = i;
        let check = true;
        for (let j = 0; j < PRIMES.length; ++j) {
            const prime = PRIMES[j];
            if (x % (prime * prime) == 0) {
                check = false;
                break;
            }
            if (x % prime === 0) {
                subset |= (1 << j);
            }
        }
        if (!check) {
            continue;
        }

        // 动态规划
        for (let mask = (1 << PRIMES.length) - 1; mask > 0; --mask) {
            if ((mask & subset) === subset) {
                f[mask] = ((f[mask] + (f[mask ^ subset]) * freq[i]) % MOD);
            }
        }
    }

    let ans = 0;
    for (let mask = 1, maskMax = (1 << PRIMES.length); mask < maskMax; ++mask) {
        ans = (ans + f[mask]) % MOD;
    }
    
    return ans;
};
```

```go [sol1-Golang]
var primes = []int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29}

func numberOfGoodSubsets(nums []int) (ans int) {
    const mod int = 1e9 + 7
    freq := [31]int{}
    for _, num := range nums {
        freq[num]++
    }

    f := make([]int, 1<<len(primes))
    f[0] = 1
    for i := 0; i < freq[1]; i++ {
        f[0] = f[0] * 2 % mod
    }
next:
    for i := 2; i < 31; i++ {
        if freq[i] == 0 {
            continue
        }

        // 检查 i 的每个质因数是否均不超过 1 个
        subset := 0
        for j, prime := range primes {
            if i%(prime*prime) == 0 {
                continue next
            }
            if i%prime == 0 {
                subset |= 1 << j
            }
        }

        // 动态规划
        for mask := 1 << len(primes); mask > 0; mask-- {
            if mask&subset == subset {
                f[mask] = (f[mask] + f[mask^subset]*freq[i]) % mod
            }
        }
    }

    for _, v := range f[1:] {
        ans = (ans + v) % mod
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n + C \times 2^{\pi(C)})$。其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是 $\textit{nums}$ 元素的最大值，在本题中 $C = 30$，$\pi(x)$ 表示 $\leq x$ 的质数的个数。

    - 我们一共需要考虑 $O(C)$ 个数，每个数需要 $O(2^{\pi(C)})$ 的时间计算动态规划；

    - 除此之外，在初始时我们还需要遍历一遍所有的数，时间复杂度为 $O(n)$。

- 空间复杂度：$O(2^{\pi(C)})$，即为动态规划需要使用的空间。