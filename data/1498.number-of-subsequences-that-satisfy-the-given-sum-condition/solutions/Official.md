#### 方法一：计算贡献

**算法**

题目要求我们统计符合「最小元素与最大元素的和小于或等于 $\rm target$」的非空子序列的个数。我们可以关注到两个点：

+ 「子序列」是不要求连续的；

+ 在这题中，我们只关心这个子序列的最小值和最大值，而不关心元素的相对顺序。

这道题我们显然不能枚举出所有的子序列然后进行判断，但是我们可以转化成求出「从原序列中选出一些元素来构成符合条件的子序列」的方案数。假如我们可以固定住这个子序列的最小值 $v_{\min}$，那么这个子序列最大值 $v_{\max}$ 一定小于等于 ${\rm target} - v_{\min}$，我们得到这样一个不等式：

$$ v_{\min} \leq v_{\max} \leq {\rm target} - v_{\min}$$

于是可以得到这样一个关系 $2 \times v_{\min} \leq {\rm target}$，也即 $v_{\min} \leq \lfloor \frac{\rm target}{2} \rfloor$，这个结论在后续的过程中会使用到。

再回到刚刚的假设，如果我们固定住 $v_{\min}$，我们可以求出 $v_{\max}$ 的最大可能值为 ${\rm target} - v_{\min}$。我们尝试枚举 $v_{\max}$，它可能是是序列中在区间 $[v_{\min}, {\rm target} - v_{\min}]$ 中的任意一个元素，例如原序列为 $\{ 5, 1, 8, 2, 9 \}$，$\rm target = 7$，$v_{\min} = 1$ 的时候，$[v_{\min}, {\rm target} - v_{\min}]$ 就是 $[1, 6]$，对应可能的 $v_{\max}$ 为 $1$ 或 $2$ 或 $5$。因为 $1$ 是我们假设「固定的」，所以我们认为 $1$ 必须出现在我们选出的子序列当中作为最小值，而 $2$ 和 $5$ 可出现也可不出现在最终的子序列当中，所以，如果 $1$ 以最小值的形式出现在我们选出的子序列中的话，一共有 $4$ 种选法：

+ $1$
+ $1, 2$
+ $1, 5$
+ $1, 2, 5$

这里的 $4 = 2^2$，即 $2$ 和 $5$ 这两个数每个数都有「出现在子序列中」和「不出现在子序列中」两种状态。这可以看作 $v_{\min} = 1$ 的情况下对答案的贡献，那么我们只要枚举所有的合法的 $v_{\min}$，把它们对答案的贡献求和，就可以计算出总的方案数。

**由于我们刚刚得到了 $2 \times v_{\min} \leq {\rm target}$，** 于是我们很容易枚举 $v_{\min}$，只要找到原序列中所有满足这个条件的元素，都可以作为 $v_{\min}$。那我们怎么找出符合条件的 $v_{\max}$ 的个数呢？我们可以对原序列排序之后做二分查找，就可以得到区间 $[v_{\min}, {\rm target} - v_{\min}]$ 中数的个数 $x$，但是由于 $v_{\min}$ 是必取的，所以这里的贡献应该是 $2^{x - 1}$。**因为「我们只关心这个子序列的最小值和最大值，而不关心元素的相对顺序」**，所以我们才可以重新排序。

具体地，我们可以先预处理出所有 $2^i \bmod (10^9 + 7)$ 的值，然后对原序列进行排序。排序之后，我们顺序枚举所有合法的 $v_{\min}$，对于每个 $v_{\min}$，二分出最大的 $v_{\max}$ 的位置，这个时候 $v_{\min}$ 和 $v_{\max}$最大值下标的差的绝对值为 $x$，当前的贡献就是 $2^x$。**（思考：为什么不是 $2^{x - 1}$ ？）**

这个时候也许有同学会提问：为什么这里用的是预处理，而不是直接对每个位置算一次快速幂呢？这是个好问题。其实这样做也是可以的，但是快速幂求到单个 $2^i$ 的时间代价是 $O(\log i) = O(\log n)$，假设序列一共有 $n$ 个数，最坏情况下这里的总代价是 $O(n \log n)$；而由于这里要用到的 $2^i$ 底数不变，可以用递推的方法在 $O(n)$ 时间内预处理出所有的 $2^i$，均摊到每个位置是 $O(1)$ 的，预处理和查询的总代价为 $O(n)$。所以这里预处理所耗费的时间更小。

在实现中，我们会用到取模来防止答案过大而溢出，这里需要用这样的小技巧来处理：

$$
(a + b) \bmod P = [(a \bmod P) + (b \bmod P)] \bmod P \\
(a \times b) \bmod P = [(a \bmod P) \times (b \bmod P)] \bmod P
$$

代码如下。注意如果使用 Java，需要自己实现二分查找的方法。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    static constexpr int P = int(1E9) + 7;
    static constexpr int MAX_N = int(1E5) + 5;

    int f[MAX_N];

    void pretreatment() {
        f[0] = 1;
        for (int i = 1; i < MAX_N; ++i) {
            f[i] = (long long)f[i - 1] * 2 % P;
        }
    }

    int numSubseq(vector<int>& nums, int target) {
        pretreatment();

        sort(nums.begin(), nums.end());

        int ans = 0;
        for (int i = 0; i < nums.size() && nums[i] * 2 <= target; ++i) {
            int maxValue = target - nums[i];
            int pos = upper_bound(nums.begin(), nums.end(), maxValue) - nums.begin() - 1;
            int contribute = (pos >= i) ? f[pos - i] : 0;
            ans = (ans + contribute) % P;
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int P = 1000000007;
    static final int MAX_N = 100005;

    int[] f = new int[MAX_N];

    public int numSubseq(int[] nums, int target) {
        pretreatment();

        Arrays.sort(nums);

        int ans = 0;
        for (int i = 0; i < nums.length && nums[i] * 2 <= target; ++i) {
            int maxValue = target - nums[i];
            int pos = binarySearch(nums, maxValue) - 1;
            int contribute = (pos >= i) ? f[pos - i] : 0;
            ans = (ans + contribute) % P;
        }

        return ans;
    }

    public void pretreatment() {
        f[0] = 1;
        for (int i = 1; i < MAX_N; ++i) {
            f[i] = (f[i - 1] << 1) % P;
        }
    }

    public int binarySearch(int[] nums, int target) {
        int low = 0, high = nums.length;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (mid == nums.length) {
                return mid;
            }
            int num = nums[mid];
            if (num <= target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numSubseq(self, nums: List[int], target: int) -> int:
        n = len(nums)
        P = 10**9 + 7
        f = [1] + [0] * (n - 1)
        for i in range(1, n):
            f[i] = f[i - 1] * 2 % P

        nums.sort()
        ans = 0
        for i, num in enumerate(nums):
            if nums[i] * 2 > target:
                break
            maxValue = target - nums[i]
            pos = bisect.bisect_right(nums, maxValue) - 1
            contribute = f[pos - i] if pos >= i else 0
            ans += contribute
        
        return ans % P
```

**复杂度**

假设这里元素的个数为 $n$。

+ 时间复杂度：$O(n \log n)$。预处理的时间代价为 $O(n)$；排序的时间代价为 $O(n \log n)$；单次二分的时间代价为 $O(\log n)$，所以二分的总代价为 $O(n \log n)$；计算贡献的单次代价为 $O(1)$，总代价为 $O(n)$。故渐进时间复杂度为 $O(n \log n)$。

+ 空间复杂度：$O(n)$。预处理的空间代价为 $O(n)$。