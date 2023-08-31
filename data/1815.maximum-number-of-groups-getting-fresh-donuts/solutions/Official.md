## [1815.得到新鲜甜甜圈的最多组数 中文官方题解](https://leetcode.cn/problems/maximum-number-of-groups-getting-fresh-donuts/solutions/100000/de-dao-xin-xian-tian-tian-quan-de-zui-du-pzra)
#### 方法一：状态压缩动态规划

**思路与算法**

根据题目的要求，当有一批顾客来到商店时，如果之前的顾客总数恰好是 $\textit{batchSize}$ 的倍数，那么这一批顾客会开心。因此，一批顾客的数量本身并不重要，重要的是**其对 $\textit{batchSize}$ 取模**的结果。

这样一来，我们可以将数组 $\textit{groups}$ 中的每个元素对 $\textit{batchSize}$ 进行取模。此时，元素的种类就只有 $\textit{batchSize}$ 种了。由于 $\textit{batchSize} \leq 9$，我们就可以考虑使用状态压缩动态规划解决本题。

> 为了方便叙述，我们用 $n$ 表示 $\textit{batchSize}$，$a_0, a_1, \cdots, a_{n-1}$ 分别表示值为 $0, 1, \cdots, n-1$ 的元素的个数。

记 $f(a_0, a_1, \cdots, a_{n-1})$ 表示当顾客的情况为 $a_0, a_1, \cdots, a_{n-1}$ 时，最多可以感到开心的顾客总数。在进行状态转移时，根据第一段叙述中的「如果之前的顾客总数恰好是 $n$ 的倍数，那么这一批顾客会开心」，我们就可以枚举**最后一组顾客**是 $0, 1, \cdots, n-1$ 中的哪一种。

我们以最后一组顾客是 $i = 3$ 举例，那么 $f(a_0, a_1, \cdots, a_{n-1})$ 就会从 $f(a_0, \cdots, a_2, a_3-1, a_4, \cdots, a_{n-1})$ 转移而来。顾客的总数对 $n$ 取模的结果为：

$$
S = \left( \sum_{j=0}^{n-1} j \times a_j \right) \bmod n
$$

如果 $S$ 和 $i=3$ 在模 $n$ 的意义下同余，那么说明在最后一组之前，顾客总数恰好是 $n$ 的倍数，即最后一组顾客会感到开心。此时状态转移方程即为：

$$
f(a_0, a_1, \cdots, a_{n-1}) = f(a_0, \cdots, a_2, a_3-1, a_4, \cdots, a_{n-1}) + 1
$$

如果不同余，最后一组顾客并不会感到开心。此时状态转移方程即为：

$$
f(a_0, a_1, \cdots, a_{n-1}) = f(a_0, \cdots, a_2, a_3-1, a_4, \cdots, a_{n-1})
$$

当 $i$ 枚举了 $0, 1, \cdots, n-1$ 中的所有值后，所有状态转移的最大值即为 $f(a_0, a_1, \cdots, a_{n-1})$。需要注意在枚举时，$a_i$ 一定要大于 $0$。

动态规划的边界情况为 $f(0, \cdots, 0) = 0$。上述动态规划使用记忆化搜索编写代码较为方便。

**如何存储 $a_0, a_1, \cdots, a_{n-1}$**

由于 $n \leq 9$，我们可以使用一个 $9$ 维的数组进行上述的状态转移，但这样做显然会使得代码看起来非常混乱且不易维护。因此我们需要思考更好的解决方法。

我们可以尝试对 $a_0, a_1, \cdots, a_{n-1}$ 进行状态压缩。由于数组 $\textit{groups}$ 的长度不超过 $30$，那么每一个 $a_i$ 也都不超过 $30$，可以用 $5$ 位二进制位来进行表示。那么整个 $a_0, a_1, \cdots, a_{n-1}$ 就可以用不超过 $5 \times 9 = 45$ 位二进制位来进行表示。大部分语言都支持 $64$ 位整数类型，因此可以存储这个 $45$ 位的二进制表示。

具体地，我们用 $\textit{mask}$ 来存储 $a_0, a_1, \cdots, a_{n-1}$。$\textit{mask}$ 最低的 $5$ 个二进制位存储了 $a_0$，更高的 $5$ 个二进制位存储了 $a_1$，以此类推。这样一来，我们可以通过位运算：

$$
\texttt{(mask >> (i * 5)) \& 0b11111}
$$

来获取 $a_i$ 的值。在进行状态转移时，如果我们需要将 $a_i$ 减去 $1$，就可以通过：

$$
\texttt{mask - (1 << (i * 5))}
$$

来完成。

**优化**

注意到 $a_0$ 是没有意义的，因为它本身为 $0$，并不会改变任意一组顾客「之前的顾客总数是否为 $n$ 的倍数」的情况。

这样一来，我们可以将所有的 $a_0$ 都放在最前面，即让数组 $\textit{groups}$ 中人数为 $n$ 的倍数的组都最先购买甜甜圈。可以发现，这些组都会完整购买若干批甜甜圈，因此都是感到开心。

因此，我们只需要将 $a_1, \cdots, a_{n-1}$ 进行状态压缩，答案即为 $f(a_1, \cdots, a_{n-1}) + a_0$。需要注意的是，因为我们丢弃了 $a_0$，所以前文的位运算中，$i$ 都需要被替换为 $i-1$。

**时空复杂度分析**

在进行了优化后，我们最多需要用一个 $40$ 位的二进制数表示状态，那么时空复杂度的数量级是 $O(2^{40})$ 吗？

其实并没有这么多。对于 $a_1, \cdots, a_{n-1}$，状态的数量为：

$$
\prod_{j=1}^{n-1} (a_j + 1)
$$

这就是空间复杂度的数量级。我们只需要使用哈希表配合记忆化搜索即可实现。时间复杂度的数量级需要在此基础上再乘 $n-1$，这是因为我们需要枚举 $1, \cdots, n-1$ 进行转移，而单次转移的时间是 $O(1)$ 的。

在最坏情况下，$n=9$，数组 $\textit{groups}$ 的长度为 $30$，那么所有 $a_j+1$ 的和为 $30+8=38$。要想使得它们的乘积最大，就应当平均进行分配。因此，当有 $2$ 个 $4$ 和 $6$ 个 $5$ 时，它们的乘积最大为：

$$
\prod_{j=1}^{n-1} (a_j + 1) = 4^2 \times 5^6 = 250000
$$

即空间复杂度的数量级在 $2 \times 10^5$ 左右。时间复杂度需要再乘 $8$，数量级在 $2 \times 10^6$ 左右，均可以满足现代 CPU 和内存的要求。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxHappyGroups(int batchSize, vector<int>& groups) {
        vector<int> cnt(batchSize);
        for (int x: groups) {
            ++cnt[x % batchSize];
        }

        long long start = 0;
        for (int i = batchSize - 1; i >= 1; --i) {
            start = (start << kWidth) | cnt[i];
        }

        unordered_map<long long, int> memo;

        function<int(long long)> dfs = [&](long long mask) -> int {
            if (mask == 0) {
                return 0;
            }
            if (memo.count(mask)) {
                return memo[mask];
            }

            int total = 0;
            for (int i = 1; i < batchSize; ++i) {
                int amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask);
                total += i * amount;
            }

            int best = 0;
            for (int i = 1; i < batchSize; ++i) {
                int amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask);
                if (amount > 0) {
                    int result = dfs(mask - (1LL << ((i - 1) * kWidth)));
                    if ((total - i) % batchSize == 0) {
                        ++result;
                    }
                    best = max(best, result);
                }
            }

            return memo[mask] = best;
        };

        return dfs(start) + cnt[0];
    }

private:
    static constexpr int kWidth = 5;
    static constexpr int kWidthMask = (1 << kWidth) - 1;
};
```

```Java [sol1-Java]
class Solution {
    static final int K_WIDTH = 5;
    static final int K_WIDTH_MASK = (1 << K_WIDTH) - 1;

    public int maxHappyGroups(int batchSize, int[] groups) {
        int[] cnt = new int[batchSize];
        for (int x : groups) {
            ++cnt[x % batchSize];
        }

        long start = 0;
        for (int i = batchSize - 1; i >= 1; --i) {
            start = (start << K_WIDTH) | cnt[i];
        }

        Map<Long, Integer> memo = new HashMap<Long, Integer>();

        return dfs(memo, batchSize, start) + cnt[0];
    }

    public int dfs(Map<Long, Integer> memo, int batchSize, long mask) {
        if (mask == 0) {
            return 0;
        }

        if (!memo.containsKey(mask)) {
            long total = 0;
            for (int i = 1; i < batchSize; ++i) {
                long amount = ((mask >> ((i - 1) * K_WIDTH)) & K_WIDTH_MASK);
                total += i * amount;
            }

            int best = 0;
            for (int i = 1; i < batchSize; ++i) {
                long amount = ((mask >> ((i - 1) * K_WIDTH)) & K_WIDTH_MASK);
                if (amount > 0) {
                    int result = dfs(memo, batchSize, mask - (1L << ((i - 1) * K_WIDTH)));
                    if ((total - i) % batchSize == 0) {
                        ++result;
                    }
                    best = Math.max(best, result);
                }
            }

            memo.put(mask, best);
        }
        return memo.get(mask);
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int K_WIDTH = 5;
    const int K_WIDTH_MASK = (1 << K_WIDTH) - 1;

    public int MaxHappyGroups(int batchSize, int[] groups) {
        int[] cnt = new int[batchSize];
        foreach (int x in groups) {
            ++cnt[x % batchSize];
        }

        long start = 0;
        for (int i = batchSize - 1; i >= 1; --i) {
            start = (start << K_WIDTH) | cnt[i];
        }

        IDictionary<long, int> memo = new Dictionary<long, int>();

        return DFS(memo, batchSize, start) + cnt[0];
    }

    public int DFS(IDictionary<long, int> memo, int batchSize, long mask) {
        if (mask == 0) {
            return 0;
        }

        if (!memo.ContainsKey(mask)) {
            long total = 0;
            for (int i = 1; i < batchSize; ++i) {
                long amount = ((mask >> ((i - 1) * K_WIDTH)) & K_WIDTH_MASK);
                total += i * amount;
            }

            int best = 0;
            for (int i = 1; i < batchSize; ++i) {
                long amount = ((mask >> ((i - 1) * K_WIDTH)) & K_WIDTH_MASK);
                if (amount > 0) {
                    int result = DFS(memo, batchSize, mask - (1L << ((i - 1) * K_WIDTH)));
                    if ((total - i) % batchSize == 0) {
                        ++result;
                    }
                    best = Math.Max(best, result);
                }
            }

            memo.Add(mask, best);
        }
        return memo[mask];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxHappyGroups(self, batchSize: int, groups: List[int]) -> int:
        kWidth = 5
        kWidthMask = (1 << kWidth) - 1

        cnt = Counter(x % batchSize for x in groups)

        start = 0
        for i in range(batchSize - 1, 0, -1):
            start = (start << kWidth) | cnt[i]

        @cache
        def dfs(mask: int) -> int:
            if mask == 0:
                return 0

            total = 0
            for i in range(1, batchSize):
                amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask)
                total += i * amount

            best = 0
            for i in range(1, batchSize):
                amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask)
                if amount > 0:
                    result = dfs(mask - (1 << ((i - 1) * kWidth)))
                    if (total - i) % batchSize == 0:
                        result += 1
                    best = max(best, result)

            return best

        ans = dfs(start) + cnt[0]
        dfs.cache_clear()
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

const int kWidth = 5;
const int kWidthMask = (1 << kWidth) - 1;

typedef struct {
    long long key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, long long key) {
    HashItem *pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, long long key, int val) {
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD(hh, *obj, key, sizeof(long long), pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, long long key, int val) {
    HashItem *pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    if (!pEntry) {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, long long key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

int dfs(long long mask, HashItem **memo, int batchSize) {
    if (mask == 0) {
        return 0;
    }
    int ret = hashGetItem(memo, mask, -1);
    if (ret != -1) {
        return ret;
    }

    int total = 0;
    for (int i = 1; i < batchSize; ++i) {
        int amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask);
        total += i * amount;
    }

    int best = 0;
    for (int i = 1; i < batchSize; ++i) {
        int amount = ((mask >> ((i - 1) * kWidth)) & kWidthMask);
        if (amount > 0) {
            long long nextMask = mask - (1LL << ((i - 1) * kWidth));
            int result = nextMask == 0 ? 0 : dfs(nextMask, memo, batchSize);
            if ((total - i) % batchSize == 0) {
                ++result;
            }
            best = MAX(best, result);
        }
    }
    hashAddItem(memo, mask, best);
    return best;
};

int maxHappyGroups(int batchSize, int* groups, int groupsSize) {
    int cnt[batchSize];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < groupsSize; i++) {
        ++cnt[groups[i] % batchSize];
    }
    long long start = 0;
    for (int i = batchSize - 1; i >= 1; --i) {
        start = (start << kWidth) | cnt[i];
    }
    HashItem *memo = NULL;
    int ret = dfs(start, &memo, batchSize) + cnt[0];
    hashFree(&memo);
    return ret;
}
```

```go [sol1-Golang]
func maxHappyGroups(batchSize int, groups []int) (ans int) {
	const kWidth = 5
	const kWidthMask = 1<<kWidth - 1

	cnt := make([]int, batchSize)
	for _, x := range groups {
		cnt[x%batchSize]++
	}

	start := 0
	for i := batchSize - 1; i > 0; i-- {
		start = start<<kWidth | cnt[i]
	}

	memo := map[int]int{}
	var dfs func(int) int
	dfs = func(mask int) (best int) {
		if mask == 0 {
			return
		}
		if res, ok := memo[mask]; ok {
			return res
		}

		total := 0
		for i := 1; i < batchSize; i++ {
			amount := mask >> ((i - 1) * kWidth) & kWidthMask
			total += i * amount
		}

		for i := 1; i < batchSize; i++ {
			amount := mask >> ((i - 1) * kWidth) & kWidthMask
			if amount > 0 {
				result := dfs(mask - 1<<((i-1)*kWidth))
				if (total-i)%batchSize == 0 {
					result++
				}
				best = max(best, result)
			}
		}
		memo[mask] = best
		return
	}
	return dfs(start) + cnt[0]
}

func max(a, b int) int {
	if b > a {
		return b
	}
	return a
}
```