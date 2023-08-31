## [1787.使所有区间的异或结果为零 中文官方题解](https://leetcode.cn/problems/make-the-xor-of-all-segments-equal-to-zero/solutions/100000/shi-suo-you-qu-jian-de-yi-huo-jie-guo-we-uds2)

#### 方法一：动态规划

**思路与算法**

设数组 $\textit{nums}$ 的长度为 $n$。首先我们需要分析出数组 $\textit{nums}$ 在修改之后应当具有哪些性质。

由于任意长度为 $k$ 的区间异或结果等于 $0$，那么对于任意的 $i$，有：

$$
\textit{nums}[i] \oplus \textit{nums}[i+1] \oplus \cdots \oplus \textit{nums}[i+k-1] = 0 \tag{1}
$$

以及：

$$
\textit{nums}[i+1] \oplus \textit{nums}[i+2] \oplus \cdots \oplus \textit{nums}[i+k] = 0 \tag{2}
$$

其中 $\oplus$ 表示异或运算。根据异或运算的性质 $a \oplus b \oplus b = a$，将 $(1)(2)$ 两式联立，即可得到：

$$
\textit{nums}[i] \oplus \textit{nums}[i+k] = 0
$$

其等价于 $\textit{nums}[i] = \textit{nums}[i+k]$。因此我们可以得出一个重要的结论：

> 数组 $\textit{nums}$ 在修改之后是一个以 $k$ 为周期的周期性数组，即 $\forall i \in [0, n-k), \textit{nums}[i] = \textit{nums}[i+k]$。

因此，我们可以将数组 $\textit{nums}$ 按照下标对 $k$ 取模的结果 $0, 1, \cdots, k-1$ 分成 $k$ 个组，每个组内的元素必须要相等，并且这 $k$ 个组对应的元素的异或和为 $0$，即：

$$
\textit{nums}[0] \oplus \textit{nums}[1] \oplus \cdots \oplus \textit{nums}[k-1] = 0
$$

只要满足上述的要求，修改后的数组的所有长度为 $k$ 的区间异或结果一定等于 $0$。

对于第 $i$ 个组，我们可以使用哈希映射来存储该组内的元素以及每个元素出现的次数，这样一来，我们就可以尝试使用动态规划来解决本题了。

设 $f(i, \textit{mask})$ 表示我们已经处理了第 $0, 1, \cdots, i$ 个组，并且这些组对应元素的异或和：

$$
\textit{nums}[0] \oplus \textit{nums}[1] \oplus \cdots \oplus \textit{nums}[i]
$$

为 $\textit{mask}$ 的前提下，这些组**总计**最少需要修改的元素个数。在进行状态转移时，我们可以枚举第 $i$ 组被修改成了哪个数。假设其被修改成了 $x$，那么第 $0, 1, \cdots, i-1$ 个组对应的元素的异或和即为 $\textit{mask} \oplus x$，因此我们可以得到状态转移方程：

$$
f(i, \textit{mask}) = \min_x \big\{ f(i-1, \textit{mask} \oplus x) + \text{size}(i) - \text{count}(i, x) \big\}
$$

其中 $\text{size}(i)$ 表示第 $i$ 个组里的元素个数，$\text{count}(i, x)$ 表示第 $i$ 个组里元素 $x$ 的次数，它们的值都可以通过哈希映射得到。上述状态转移方程的意义即为：如果我们选择将第 $i$ 组全部修改为 $x$，那么有 $\text{count}(i, x)$ 个数是无需修改的，这样就需要修改 $\text{size}(i) - \text{count}(i, x)$ 次。

动态规划的时间复杂度是多少呢？我们发现这并不好估计，这是因为 $x$ 可以很小，也可以很大，它并没有一个固定的范围。然而我们可以发现，题目中规定了 $\textit{nums}[i] < 2^{10}$，也就是 **$\textit{nums}[i]$ 的二进制表示的位数不超过 $10$**。因此我们可以断定，$x$ 的上限就是 $2^{10}$。

> 如果 $x \geq 2^{10}$，那么 $x$ 的二进制表示的最高位 $1$ 是在数组 $\textit{nums}$ 的其它元素中没有出现过的，因此根据异或的性质，要想将最终的异或结果变为 $0$，我们需要将另一个组的所有元素改为 $y$，且 $y$ 有与 $x$ 相同的高位 $1$。这样一来，我们不如将 $x$ 和 $y$ 的高位 $1$ 移除，让它们都在 $[0, 2^{10})$ 的范围内，这样更容易增大 $\text{count}(i, x)$，减少最终的修改次数。

当我们确定了 $x$ 的上限，就可以计算出动态规划的时间复杂度了。状态的数量有 $k \times 2^{10}$ 个，对于每一个状态，我们需要枚举 $x$ 来进行状态转移，而 $x$ 的数量同样有 $2^{10}$ 个，因此时间复杂度为 $O(2^{20} k) = O(2^{20} n)$，数量级约为 $2 \times 10^9$，超出了时间限制，因此我们必须要进行优化。

**优化**

对于未优化的状态转移方程：

$$
f(i, \textit{mask}) = \min_x \big\{ f(i-1, \textit{mask} \oplus x) + \text{size}(i) - \text{count}(i, x) \big\}
$$

首先 $\text{size}(i)$ 是与 $x$ 无关的常量，我们可以将其移出最小值的限制，即：

$$
f(i, \textit{mask}) = \text{size}(i) + \min_x \big\{ f(i-1, \textit{mask} \oplus x) - \text{count}(i, x) \big\}
$$

由于我们需要求的是「最小值」，因此在状态转移方程中添加若干大于等于「最小值」的项，对最终的答案不会产生影响。

考虑 $\text{count}(i, x)$ 这一项，如果 $x$ 没有在哈希表中出现，那么这一项的值为 $0$，否则这一项的值大于 $0$。即：

- 如果 $x$ 没有在哈希表中出现，那么转移的状态为：

    $$
    f(i-1, \textit{mask} \oplus x)
    $$

- 如果 $x$ 在哈希表中出现，那么转移的状态为：

    $$
    f(i-1, \textit{mask} \oplus x) - \text{count}(i, x)
    $$

    它严格小于 $f(i-1, \textit{mask} \oplus x)$。如果我们在状态转移方程中添加 $f(i-1, \textit{mask} \oplus x)$，最终的答案不会变化。

因此我们可以将状态转移方程变化为：

$$
f(i, \textit{mask}) = \text{size}(i) + \min\{ t_1, t_2 \}
$$

其中 $t_1$ 对应 $x$ 在哈希表中出现的状态，即：

$$
t_1 = \min_{x \in \text{HashTable}(i)} \big\{ f(i-1, \textit{mask} \oplus x) - \text{count}(i, x) \big\}
$$

$t_2$ 对应 $x$ 不在哈希表中出现的状态，以及 $x$ 在哈希表中出现并且我们额外添加的状态，即：

$$
t_2 = \min_x f(i - 1, \textit{mask} \oplus x)
$$

由于 $\textit{mask}$ 的取值范围是 $[0, 2^{10})$，$x$ 的取值范围也是 $[0, 2^{10})$，因此 **$\textit{mask} \oplus x$ 的取值范围就是 $[0, 2^{10})$，与 $x$ 无关**。也就是说：

> $t_2$ 就是所有状态 $f(i-1, ..)$ 中的最小值。

那么优化后的动态规划的时间复杂度是多少呢？对于第 $i$ 组，我们需要计算出第 $i-1$ 组对应的状态 $f(i-1, ..)$ 中的最小值，时间复杂度为 $O(2^{10})$，即为 $t_2$ 部分的状态转移。而对于 $t_1$ 部分，状态转移的次数等于第 $i$ 组哈希映射的大小，小于等于 $\text{size}(i)$。因此总的时间复杂度为：

$$
O\left( \sum_{i=0}^{k-1} \big( 2^{10} + \text{size}(i) \big) \right) = O(2^{10}k + n)
$$

最终的答案即为 $f(k-1, 0)$。

**细节**

由于 $f(i, ..)$ 只会从 $f(i-1, ..)$ 转移而来，因此我们可以使用两个长度为 $2^{10}$ 的一维数组代替二维数组，交替地进行状态转移，减少空间复杂度。

此外，当 $i=0$ 时，$f(-1, ..)$ 都是需要特殊考虑的边界条件。由于 $f(-1, ..)$ 表示没有考虑任何组时的异或和，因此该异或和一定为 $0$，即 $f(-1, 0) = 0$。其它的状态都是不合法的状态，我们可以将它们赋予一个极大值 $\infty$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // x 的范围为 [0, 2^10)
    static constexpr int MAXX = 1 << 10;
    // 极大值，为了防止整数溢出选择 INT_MAX / 2
    static constexpr int INFTY = INT_MAX / 2;
    
public:
    int minChanges(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> f(MAXX, INFTY);
        // 边界条件 f(-1,0)=0
        f[0] = 0;
        
        for (int i = 0; i < k; ++i) {
            // 第 i 个组的哈希映射
            unordered_map<int, int> cnt;
            int size = 0;
            for (int j = i; j < n; j += k) {
                ++cnt[nums[j]];
                ++size;
            }

            // 求出 t2
            int t2min = *min_element(f.begin(), f.end());

            vector<int> g(MAXX, t2min);
            for (int mask = 0; mask < MAXX; ++mask) {
                // t1 则需要枚举 x 才能求出
                for (auto [x, countx]: cnt) {
                    g[mask] = min(g[mask], f[mask ^ x] - countx);
                }
            }
            
            // 别忘了加上 size
            for_each(g.begin(), g.end(), [&](int& val) {val += size;});
            f = move(g);
        }

        return f[0];
    }
};
```

```Java [sol1-Java]
class Solution {
    // x 的范围为 [0, 2^10)
    static final int MAXX = 1 << 10;
    // 极大值，为了防止整数溢出选择 INT_MAX / 2
    static final int INFTY = Integer.MAX_VALUE / 2;

    public int minChanges(int[] nums, int k) {
        int n = nums.length;
        int[] f = new int[MAXX];
        Arrays.fill(f, INFTY);
        // 边界条件 f(-1,0)=0
        f[0] = 0;
        
        for (int i = 0; i < k; ++i) {
            // 第 i 个组的哈希映射
            Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
            int size = 0;
            for (int j = i; j < n; j += k) {
                cnt.put(nums[j], cnt.getOrDefault(nums[j], 0) + 1);
                ++size;
            }

            // 求出 t2
            int t2min = Arrays.stream(f).min().getAsInt();

            int[] g = new int[MAXX];
            Arrays.fill(g, t2min);
            for (int mask = 0; mask < MAXX; ++mask) {
                // t1 则需要枚举 x 才能求出
                for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
                    int x = entry.getKey(), countx = entry.getValue();
                    g[mask] = Math.min(g[mask], f[mask ^ x] - countx);
                }
            }
            
            // 别忘了加上 size
            for (int j = 0; j < MAXX; ++j) {
                g[j] += size;
            }
            f = g;
        }

        return f[0];
    }
}
```

```C# [sol1-C#]
public class Solution {
    // x 的范围为 [0, 2^10)
    const int MAXX = 1 << 10;
    // 极大值，为了防止整数溢出选择 INT_MAX / 2
    const int INFTY = int.MaxValue / 2;

    public int MinChanges(int[] nums, int k) {
        int n = nums.Length;
        int[] f = new int[MAXX];
        Array.Fill(f, INFTY);
        // 边界条件 f(-1,0)=0
        f[0] = 0;
        
        for (int i = 0; i < k; ++i) {
            // 第 i 个组的哈希映射
            Dictionary<int, int> cnt = new Dictionary<int, int>();
            int size = 0;
            for (int j = i; j < n; j += k) {
                if (!cnt.ContainsKey(nums[j])) {
                    cnt.Add(nums[j], 1);
                } else {
                    ++cnt[nums[j]];
                }
                ++size;
            }

            // 求出 t2
            int t2min = f.Min();

            int[] g = new int[MAXX];
            Array.Fill(g, t2min);
            for (int mask = 0; mask < MAXX; ++mask) {
                // t1 则需要枚举 x 才能求出
                foreach (var entry in cnt) {
                    int x = entry.Key, countx = entry.Value;
                    g[mask] = Math.Min(g[mask], f[mask ^ x] - countx);
                }
            }
            
            // 别忘了加上 size
            for (int j = 0; j < MAXX; ++j) {
                g[j] += size;
            }
            f = g;
        }

        return f[0];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minChanges(self, nums: List[int], k: int) -> int:
        # x 的范围为 [0, 2^10)
        MAXX = 2**10
        
        n = len(nums)
        f = [float("inf")] * MAXX
        # 边界条件 f(-1,0)=0
        f[0] = 0
        
        for i in range(k):
            # 第 i 个组的哈希映射
            count = Counter()
            size = 0
            for j in range(i, n, k):
                count[nums[j]] += 1
                size += 1

            # 求出 t2
            t2min = min(f)

            g = [t2min] * MAXX
            for mask in range(MAXX):
                # t1 则需要枚举 x 才能求出
                for x, countx in count.items():
                    g[mask] = min(g[mask], f[mask ^ x] - countx)
            
            # 别忘了加上 size
            f = [val + size for val in g]

        return f[0]
```

```JavaScript [sol1-JavaScript]
var minChanges = function(nums, k) {
    // x 的范围为 [0, 2^10)
    const MAXX = 2**10;

    const n = nums.length;
    let f = new Array(MAXX).fill(Number.MAX_VALUE);
    // 边界条件 f(-1,0)=0
    f[0] = 0;

    for (let i = 0; i < k; i++) {
        // 第 i 个组的哈希映射
        const count = new Map();
        let size = 0;
        for (let j = i; j < n; j += k) {
            count.has(nums[j]) ? count.set(nums[j], count.get(nums[j]) + 1) : count.set(nums[j], 1);
            size++;
        }

        // 求出 t2
        const t2min = Math.min(...f);

        const g = new Array(MAXX).fill(t2min);
        for (let mask = 0; mask < MAXX; mask++) {
            // t1 则需要枚举 x 才能求出
            for (const [x, countx] of count.entries()) {
                g[mask] = Math.min(g[mask], f[mask ^ x] - countx);
            }
        }

        // 别忘了加上 size
        for (const [index, val] of g.entries()) {
            f[index] = val + size;
        }
    }

    return f[0];
};
```

```go [sol1-Golang]
func minChanges(nums []int, k int) int {
    const maxX = 1 << 10 // x 的范围为 [0, 2^10)
    const inf = math.MaxInt32 / 2 // 极大值，为了防止整数溢出

    n := len(nums)
    f := make([]int, maxX)
    for i := range f {
        f[i] = inf
    }
    // 边界条件 f(-1,0)=0
    f[0] = 0

    for i := 0; i < k; i++ {
        // 第 i 个组的哈希映射
        cnt := map[int]int{}
        size := 0
        for j := i; j < n; j += k {
            cnt[nums[j]]++
            size++
        }

        // 求出 t2
        t2min := min(f...)

        g := make([]int, maxX)
        for j := range g {
            g[j] = t2min
        }
        for mask := range g {
            // t1 则需要枚举 x 才能求出
            for x, cntX := range cnt {
                g[mask] = min(g[mask], f[mask^x]-cntX)
            }
        }

        // 别忘了加上 size
        for j := range g {
            g[j] += size
        }
        f = g
    }

    return f[0]
}

func min(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v < res {
            res = v
        }
    }
    return res
}
```

```C [sol1-C]
// x 的范围为 [0, 2^10)
const int MAXX = 1 << 10;
// 极大值，为了防止整数溢出选择 INT_MAX / 2
const int INFTY = INT_MAX / 2;

struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int min_element(int* arr, int arrSize) {
    int ret = arr[0];
    for (int i = 1; i < arrSize; ++i) {
        ret = fmin(ret, arr[i]);
    }
    return ret;
}

int minChanges(int* nums, int numsSize, int k) {
    int f[MAXX];
    for (int i = 0; i < MAXX; ++i) {
        f[i] = INFTY;
    }
    // 边界条件 f(-1,0)=0
    f[0] = 0;

    for (int i = 0; i < k; ++i) {
        // 第 i 个组的哈希映射
        struct HashTable* cnt = NULL;
        int size = 0;
        for (int j = i; j < numsSize; j += k) {
            struct HashTable* tmp;
            HASH_FIND_INT(cnt, &nums[j], tmp);
            if (tmp == NULL) {
                tmp = malloc(sizeof(struct HashTable));
                tmp->key = nums[j];
                tmp->val = 1;
                HASH_ADD_INT(cnt, key, tmp);
            } else {
                tmp->val++;
            }
            ++size;
        }

        // 求出 t2
        int t2min = min_element(f, MAXX);

        int g[MAXX];
        for (int i = 0; i < MAXX; ++i) {
            g[i] = t2min;
        }
        for (int mask = 0; mask < MAXX; ++mask) {
            // t1 则需要枚举 x 才能求出
            struct HashTable *iter, *tmp;
            HASH_ITER(hh, cnt, iter, tmp) {
                int x = iter->key, countx = iter->val;
                g[mask] = fmin(g[mask], f[mask ^ x] - countx);
            }
        }
        struct HashTable *iter, *tmp;
        HASH_ITER(hh, cnt, iter, tmp) {
            HASH_DEL(cnt, iter);
            free(iter);
        }

        // 别忘了加上 size
        for (int i = 0; i < MAXX; ++i) {
            g[i] += size;
        }
        memcpy(f, g, sizeof(g));
    }

    return f[0];
}
```

**复杂度分析**

- 时间复杂度：$O(2^Ck + n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中元素二进制表示的最大位数，在本题中 $C = 10$。对于每一个组，构造其哈希表的时间严格小于动态规划的时间，因此可以忽略不计。

- 空间复杂度：$O(2^C + \dfrac{n}{k})$。动态规划需要两个长度为 $2^C$ 的一维数组，每一个组 $i$ 对应的哈希表的大小为 $O(\dfrac{n}{k})$。