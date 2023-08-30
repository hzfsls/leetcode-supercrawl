#### 方法一：动态规划

**思路与算法**

我们可以使用动态规划的方法解决本题。

记 $f[i][d][\textit{num}]$ 表示使用数组 $\textit{nums}$ 中下标小于等于 $i$ 的元素，构造公差为 $d$ 的等差数列，并且最后一个元素为 $\textit{num}$ 时，等差数列长度的**最大值**。在进行状态转移时，我们考虑是否将当前的第 $i$ 个元素作为末项加入等差数列。

- 如果不加入等差数列，那么每一项的答案应该与使用下标小于等于 $i-1$ 的元素对应的答案相同，即：

    $$
    f[i][d][\textit{num}] \leftarrow f[i-1][d][\textit{num}]
    $$

- 如果加入等差数列，那么有两种情况。第一种是等差数列的长度至少为 $2$，既然末项是 $\textit{nums}[i]$，那么倒数第二项就是 $\textit{nums}[i] - d$，这样我们就可以得到状态转移方程：

    $$
    f[i][d][\textit{nums}[i]] \leftarrow f[i-1][d][\textit{nums}[i] - d] + 1
    $$

    这里需要保证 $\textit{nums}[i] - d$ 落在满足要求的范围内，即必须在数组 $\textit{nums}$ 中最小值和最大值之间。并且 $f[i-1][d][\textit{nums}[i] - d]$ 本身也需要是一个合法的状态，即必须要存在以 $\textit{nums}[i] - d$ 为末项的等差数组。

    第二种是等差数列的长度为 $1$，即 $\textit{nums}[i]$ 单独形成一个等差数组，即：

    $$
    f[i][d][\textit{nums}[i]] \leftarrow 1
    $$

由于我们需要求出的是最大值，因此所有的状态转移都会取二者的较大值。如果我们使用数组表示 $f$，可以将所有状态的初始值均设置为 $-1$，表示不合法的状态；如果我们使用哈希表表示 $f$，那么没有在哈希表中出现过的状态，就是不合法的状态。

最终的答案即为 $f[n-1][..][..]$ 中的最大值，其中 $n$ 是数组 $\textit{nums}$ 的长度。

需要注意的是，$d$ 的取值范围是 $[-\textit{diff}, \textit{diff}~]$，其中 $\textit{diff}$ 是数组 $\textit{nums}$ 中最大值与最小值的差。

**优化**

在上面的状态转移方程中，我们发现，当状态的第一维从 $i-1$ 变成 $i$ 后，实际上只有 $f[i][d][\textit{nums}[i]]$ 可能会相较于 $f[i-1][d][\textit{nums}[i]]$ 的值发生变化，而其余的值均保持不变。因此，我们可以省去第一维，在状态转移时只需要修改最多一个状态的值。

此时，状态变为 $f[d][\textit{num}]$，当我们遍历到数组 $\textit{nums}$ 的第 $i$ 个元素时，只需要进行：

$$
f[d][\textit{nums}[i]] \leftarrow f[d][\textit{nums}[i] - d] + 1
$$

以及：

$$
f[d][\textit{nums}[i]] \leftarrow 1
$$

这两个状态转移即可。进一步我们发现，$f[d][..]$ 只会从 $f[d][..]$ 转移而来，因此我们可以继续省去当前的第一维，使用一个外层循环枚举 $d$，而在内层循环中，只需要进行：

$$
f[\textit{nums}[i]] \leftarrow f[\textit{nums}[i] - d] + 1 \tag{1}
$$

以及：

$$
f[\textit{nums}[i]] \leftarrow 1
$$

这两个状态转移即可。

显然，最终的答案至少为 $1$。因此我们只需要在进行 $(1)$ 的状态转移时，使用 $f[\textit{nums}[i]]$ 对答案进行更新。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int longestArithSeqLength(vector<int>& nums) {
        auto [minit, maxit] = minmax_element(nums.begin(), nums.end());
        int diff = *maxit - *minit;
        int ans = 1;
        for (int d = -diff; d <= diff; ++d) {
            vector<int> f(*maxit + 1, -1);
            for (int num: nums) {
                if (int prev = num - d; prev >= *minit && prev <= *maxit && f[prev] != -1) {
                    f[num] = max(f[num], f[prev] + 1);
                    ans = max(ans, f[num]);
                }
                f[num] = max(f[num], 1);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestArithSeqLength(int[] nums) {
        int minv = Arrays.stream(nums).min().getAsInt();
        int maxv = Arrays.stream(nums).max().getAsInt();
        int diff = maxv - minv;
        int ans = 1;
        for (int d = -diff; d <= diff; ++d) {
            int[] f = new int[maxv + 1];
            Arrays.fill(f, -1);
            for (int num : nums) {
                int prev = num - d;
                if (prev >= minv && prev <= maxv && f[prev] != -1) {
                    f[num] = Math.max(f[num], f[prev] + 1);
                    ans = Math.max(ans, f[num]);
                }
                f[num] = Math.max(f[num], 1);
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LongestArithSeqLength(int[] nums) {
        int minv = nums.Min();
        int maxv = nums.Max();
        int diff = maxv - minv;
        int ans = 1;
        for (int d = -diff; d <= diff; ++d) {
            int[] f = new int[maxv + 1];
            Array.Fill(f, -1);
            foreach (int num in nums) {
                int prev = num - d;
                if (prev >= minv && prev <= maxv && f[prev] != -1) {
                    f[num] = Math.Max(f[num], f[prev] + 1);
                    ans = Math.Max(ans, f[num]);
                }
                f[num] = Math.Max(f[num], 1);
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestArithSeqLength(self, nums: List[int]) -> int:
        minv, maxv = min(nums), max(nums)
        diff = maxv - minv
        ans = 1

        for d in range(-diff, diff + 1):
            f = dict()
            for num in nums:
                if (prev := num - d) in f:
                    f[num] = max(f.get(num, 0), f[prev] + 1)
                    ans = max(ans, f[num])
                f[num] = max(f.get(num, 0), 1)
        
        return ans
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int longestArithSeqLength(int* nums, int numsSize) {
    int maxVal = nums[0];
    int minVal = nums[0];
    for (int i = 0; i < numsSize; i++) {
        maxVal = MAX(maxVal, nums[i]);
        minVal = MIN(minVal, nums[i]);
    }
    int diff = maxVal - minVal;
    int ans = 1;
    for (int d = -diff; d <= diff; ++d) {
        int f[maxVal + 1];
        memset(f, 0xff, sizeof(f));
        for (int i = 0; i < numsSize; i++) {
            int prev = nums[i] - d; 
            if (prev >= minVal && prev <= maxVal && f[prev] != -1) {
                f[nums[i]] = MAX(f[nums[i]], f[prev] + 1);
                ans = MAX(ans, f[nums[i]]);
            }
            f[nums[i]] = MAX(f[nums[i]], 1);
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var longestArithSeqLength = function(nums) {
    const minv = _.min(nums);
    const maxv = _.max(nums);
    const diff = maxv - minv;
    let ans = 1;
    for (let d = -diff; d <= diff; ++d) {
        const f = new Array(maxv + 1).fill(-1);
        for (const num of nums) {
            let prev = num - d;
            if (prev >= minv && prev <= maxv && f[prev] !== -1) {
                f[num] = Math.max(f[num], f[prev] + 1);
                ans = Math.max(ans, f[num]);
            }
            f[num] = Math.max(f[num], 1);
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func longestArithSeqLength(nums []int) int {
    minv, maxv := nums[0], nums[0]
    for _, num := range nums[1:] {
        if num < minv {
            minv = num
        } else if num > maxv {
            maxv = num
        }
    }
    diff := maxv - minv
    ans := 1
    for d := -diff; d <= diff; d++ {
        f := make([]int, maxv+1)
        for i := range f {
            f[i] = -1
        }
        for _, num := range nums {
            prev := num - d
            if prev >= minv && prev <= maxv && f[prev] != -1 {
                f[num] = max(f[num], f[prev]+1)
                ans = max(ans, f[num])
            }
            f[num] = max(f[num], 1)
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(nC)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的元素范围。

- 空间复杂度：$O(n)$，即为动态规划中数组（或哈希表）$f$ 需要使用的空间。