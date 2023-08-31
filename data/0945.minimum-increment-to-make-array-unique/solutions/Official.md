## [945.使数组唯一的最小增量 中文官方题解](https://leetcode.cn/problems/minimum-increment-to-make-array-unique/solutions/100000/shi-shu-zu-wei-yi-de-zui-xiao-zeng-liang-by-leet-2)
#### 方法一：计数

**思路**

由于 `nums[i]` 的范围为 `[0, 40000)`，我们可以用数组统计出每个数出现的次数，然后对于每个重复出现的数，我们暴力地将它递增，直到它增加到一个没有重复出现的数为止。但这样的方法的时间复杂度较大，可以达到 $O(N^2)$，例如数组 `nums` 中所有元素都是 `1` 的情况。

因此，我们不能对重复出现的数暴力的进行递增，而是用以下的做法：当我们找到一个没有出现过的数的时候，将之前某个重复出现的数增加成这个没有出现过的数。注意，这里 **「之前某个重复出现的数」** 是可以任意选择的，它并不会影响最终的答案，因为将 `P` 增加到 `X` 并且将 `Q` 增加到 `Y`，与将 `P` 增加到 `Y` 并且将 `Q` 增加到 `X` 都需要进行 `(X + Y) - (P + Q)` 次操作。

例如当数组 `nums` 为 `[1, 1, 1, 1, 3, 5]` 时，我们发现有 `3` 个重复的 `1`，且没有出现过 `2`，`4` 和 `6`，因此一共需要进行 `(2 + 4 + 6) - (1 + 1 + 1) = 9` 次操作。

**算法**

首先统计出每个数出现的次数，然后从小到大遍历每个数 `x`：

- 如果 `x` 出现了两次以上，就将额外出现的数记录下来（例如保存到一个列表中）；

- 如果 `x` 没有出现过，那么在记录下来的数中选取一个 `v`，将它增加到 `x`，需要进行的操作次数为 `x - v`。

我们还可以对该算法进行优化，使得我们不需要将额外出现的数记录下来。还是以 `[1, 1, 1, 1, 3, 5]` 为例，当我们发现有 `3` 个重复的 `1` 时，我们先将操作次数减去 `1 + 1 + 1`。接下来，当我们发现 `2`，`4` 和 `6` 都没有出现过时，我们依次将操作次数增加 `2`，`4` 和 `6`。这种优化方法在方法二中也被使用。

**注意事项**

虽然 `nums[i]` 的范围为 `[0, 40000)`，但我们有可能会将数据递增到 `40000` 的两倍 `80000`。这是因为在最坏情况下，数组 `nums` 中有 `40000` 个 `40000`，这样要使得数组值唯一，需要将其递增为 `[40000, 40001, ..., 79999]`，因此用来统计的数组需要开到 `80000`。

```Java [sol1-Java]
class Solution {
    public int minIncrementForUnique(int[] nums) {
        int[] count = new int[80000];
        for (int x : nums) {
            count[x]++;
        }

        int ans = 0, taken = 0;

        for (int x = 0; x < 80000; ++x) {
            if (count[x] >= 2) {
                taken += count[x] - 1;
                ans -= x * (count[x] - 1);
            } else if (taken > 0 && count[x] == 0) {
                taken--;
                ans += x;
            }
        }

        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minIncrementForUnique(self, nums: List[int]) -> int:
        count = [0] * 80000
        for x in nums:
            count[x] += 1
        
        ans = taken = 0
        for x in range(80000):
            if count[x] >= 2:
                taken += count[x] - 1
                ans -= x * (count[x] - 1)
            elif taken > 0 and count[x] == 0:
                taken -= 1
                ans += x
        
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int minIncrementForUnique(vector<int>& nums) {
        int cnt[80000] = { 0 };
        for (int x: nums) {
            cnt[x]++;
        }

        int ans = 0, taken = 0;

        for (int x = 0; x < 80000; ++x) {
            if (cnt[x] >= 2) {
                taken += cnt[x] - 1;
                ans -= x * (cnt[x] - 1);
            } else if (taken > 0 && cnt[x] == 0) {
                taken--;
                ans += x;
            }
        }

        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(L)$，其中 $L$ 的数量级是数组 `nums` 的长度加上其数据范围内的最大值，因为在最坏情况下，数组 `nums` 中的所有数都是数据范围内的最大值。

- 空间复杂度：$O(L)$，需要长度 $L$ 的数组统计每个数出现的次数。

#### 方法二：排序

**思路**

我们可以将数组先进行排序，再使用方法一中提及的优化方法。

**算法**

将数组排完序后，我们对数组进行线性扫描，会有两种情况：

* 如果 `nums[i - 1] == nums[i]`，我们将操作次数减去 `nums[i]`，并将重复的数的个数增加 `1`；

* 如果 `nums[i - 1] < nums[i]`，则区间 $\big[\textit{nums}[i - 1] + 1, \textit{nums}[i] - 1\big]$ 里的数都是没有出现过的，所以我们可以将之前重复的数变为这个区间范围内的数。设当前重复的数的个数为 `taken`，则我们最多可以改变 `give = min(taken, nums[i] - nums[i - 1] - 1)` 个数，即区间 $\big[\textit{nums}[i - 1] + 1, \textit{nums}[i] - 1\big]$ 的长度与 `taken` 二者的较小值。它们的操作数对答案的贡献为：

$$
\textit{nums}[i-1] \times \mathrm{give} + \sum_{k=1}^{\mathrm{give}}\ k = \textit{nums}[i-1]\times \mathrm{give}+\frac{(\mathrm{give}+1)\times\mathrm{give}}{2}
$$

在扫描完数组后，如果仍然有重复的数，即 `taken` 不为 `0`，我们可以将这些数变为区间 $\big[\textit{nums}[n - 1] + 1, \infty \big)$ 中的数，其中 `nums[n - 1]` 是数组 `nums` 中的最后一个数。

```Java [sol2-Java]
class Solution {
    public int minIncrementForUnique(int[] nums) {
        Arrays.sort(nums);
        int ans = 0, taken = 0;

        for (int i = 1; i < nums.length; ++i) {
            if (nums[i - 1] == nums[i]) {
                taken++;
                ans -= nums[i];
            } else {
                int give = Math.min(taken, nums[i] - nums[i - 1] - 1);
                ans += give * (give + 1) / 2 + give * nums[i - 1];
                taken -= give;
            }
        }

        if (nums.length > 0) {
            ans += taken * (taken + 1) / 2 + taken * nums[nums.length - 1];
        }

        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minIncrementForUnique(self, nums: List[int]) -> int:
        nums.sort()
        nums.append(100000)
        ans = taken = 0

        for i in range(1, len(nums)):
            if nums[i - 1] == nums[i]:
                taken += 1
                ans -= nums[i]
            else:
                give = min(taken, nums[i] - nums[i - 1] - 1)
                ans += give * (give + 1) // 2 + give * nums[i - 1]
                taken -= give

        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int minIncrementForUnique(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int ans = 0, taken = 0;
        for (int i = 1; i < (int)nums.size(); ++i) {
            if (nums[i - 1] == nums[i]) {
                taken++;
                ans -= nums[i];
            } else {
                int give = min(taken, nums[i] - nums[i - 1] - 1);
                ans += give * (give + 1) / 2 + give * nums[i - 1];
                taken -= give;
            }
        }

        if (nums.size() > 0) {
            ans += taken * (taken + 1) / 2 + taken * nums.back();
        }

        return ans;
    }
};
```

**复杂度分析**

* 时间复杂度：$O(N\log N)$，其中 $N$ 是数组 $\textit{nums}$ 的长度，即排序的时间复杂度。

* 空间复杂度：$O(\log N)$，排序需要额外 $O(\log N)$ 的栈空间。