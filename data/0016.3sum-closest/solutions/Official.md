## [16.最接近的三数之和 中文官方题解](https://leetcode.cn/problems/3sum-closest/solutions/100000/zui-jie-jin-de-san-shu-zhi-he-by-leetcode-solution)
#### 前言

本题与 [15. 三数之和](https://leetcode-cn.com/problems/3sum/) 非常类似，可以使用「双指针」的方法来解决。但基于题解的独立性，这里还是会从零开始讲解。

#### 方法一：排序 + 双指针

**思路与算法**

题目要求找到与目标值 $\textit{target}$ 最接近的三元组，这里的「最接近」即为差值的绝对值最小。我们可以考虑直接使用三重循环枚举三元组，找出与目标值最接近的作为答案，时间复杂度为 $O(N^3)$。然而本题的 $N$ 最大为 $1000$，会超出时间限制。

那么如何进行优化呢？我们首先考虑枚举第一个元素 $a$，对于剩下的两个元素 $b$ 和 $c$，我们希望它们的和最接近 $\textit{target} - a$。对于 $b$ 和 $c$，如果它们在原数组中枚举的范围（既包括下标的范围，也包括元素值的范围）没有任何规律可言，那么我们还是只能使用两重循环来枚举所有的可能情况。因此，我们可以考虑对整个数组进行升序排序，这样一来：

- 假设数组的长度为 $n$，我们先枚举 $a$，它在数组中的位置为 $i$；

- 为了防止重复枚举，我们在位置 $[i+1, n)$ 的范围内枚举 $b$ 和 $c$。

当我们知道了 $b$ 和 $c$ 可以枚举的下标范围，并且知道这一范围对应的数组元素是有序（升序）的，那么我们是否可以对枚举的过程进行优化呢？

答案是可以的。借助双指针，我们就可以对枚举的过程进行优化。我们用 $p_b$ 和 $p_c$ 分别表示指向 $b$ 和 $c$ 的指针，初始时，$p_b$ 指向位置 $i+1$，即左边界；$p_c$ 指向位置 $n-1$，即右边界。在每一步枚举的过程中，我们用 $a+b+c$ 来更新答案，并且：

- 如果 $a+b+c \geq \textit{target}$，那么就将 $p_c$ 向左移动一个位置；

- 如果 $a+b+c < \textit{target}$，那么就将 $p_b$ 向右移动一个位置。

这是为什么呢？我们对 $a+b+c \geq \textit{target}$ 的情况进行一个详细的分析：

> 如果 $a+b+c \geq \textit{target}$，并且我们知道 $p_b$ 到 $p_c$ 这个范围内的所有数是按照升序排序的，那么如果 $p_c$ 不变而 $p_b$ 向右移动，那么 $a+b+c$ 的值就会不断地增加，显然就不会成为最接近 $\textit{target}$ 的值了。因此，我们可以知道在固定了 $p_c$ 的情况下，此时的 $p_b$ 就可以得到一个最接近 $\textit{target}$ 的值，那么我们以后就不用再考虑 $p_c$ 了，就可以将 $p_c$ 向左移动一个位置。

同样地，在 $a+b+c < \textit{target}$ 时：

> 如果 $a+b+c < \textit{target}$，并且我们知道 $p_b$ 到 $p_c$ 这个范围内的所有数是按照升序排序的，那么如果 $p_b$ 不变而 $p_c$ 向左移动，那么 $a+b+c$ 的值就会不断地减小，显然就不会成为最接近 $\textit{target}$ 的值了。因此，我们可以知道在固定了 $p_b$ 的情况下，此时的 $p_c$ 就可以得到一个最接近 $\textit{target}$ 的值，那么我们以后就不用再考虑 $p_b$ 了，就可以将 $p_b$ 向右移动一个位置。

实际上，$p_b$ 和 $p_c$ 就表示了我们当前**可以选择的数的范围**，而每一次枚举的过程中，我们**尝试边界上的两个元素**，根据它们与 $\textit{target}$ 的值的关系，选择「抛弃」左边界的元素还是右边界的元素，从而减少了枚举的范围。这种思路与 [11. 盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water/) 中的双指针解法也是类似的。

**小优化**

本题也有一些可以减少运行时间（但不会减少时间复杂度）的小优化。当我们枚举到恰好等于 $\textit{target}$ 的 $a+b+c$ 时，可以直接返回 $\textit{target}$ 作为答案，因为不会有再比这个更接近的值了。

另一个优化与 [15. 三数之和的官方题解](https://leetcode-cn.com/problems/3sum/solution/san-shu-zhi-he-by-leetcode-solution/) 中提到的类似。当我们枚举 $a, b, c$ 中任意元素并移动指针时，可以直接将其移动到下一个与这次枚举到的不相同的元素，减少枚举的次数。

```C++ [sol1-C++]
class Solution {
public:
    int threeSumClosest(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        int n = nums.size();
        int best = 1e7;

        // 根据差值的绝对值来更新答案
        auto update = [&](int cur) {
            if (abs(cur - target) < abs(best - target)) {
                best = cur;
            }
        };

        // 枚举 a
        for (int i = 0; i < n; ++i) {
            // 保证和上一次枚举的元素不相等
            if (i > 0 && nums[i] == nums[i - 1]) {
                continue;
            }
            // 使用双指针枚举 b 和 c
            int j = i + 1, k = n - 1;
            while (j < k) {
                int sum = nums[i] + nums[j] + nums[k];
                // 如果和为 target 直接返回答案
                if (sum == target) {
                    return target;
                }
                update(sum);
                if (sum > target) {
                    // 如果和大于 target，移动 c 对应的指针
                    int k0 = k - 1;
                    // 移动到下一个不相等的元素
                    while (j < k0 && nums[k0] == nums[k]) {
                        --k0;
                    }
                    k = k0;
                } else {
                    // 如果和小于 target，移动 b 对应的指针
                    int j0 = j + 1;
                    // 移动到下一个不相等的元素
                    while (j0 < k && nums[j0] == nums[j]) {
                        ++j0;
                    }
                    j = j0;
                }
            }
        }
        return best;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int n = nums.length;
        int best = 10000000;

        // 枚举 a
        for (int i = 0; i < n; ++i) {
            // 保证和上一次枚举的元素不相等
            if (i > 0 && nums[i] == nums[i - 1]) {
                continue;
            }
            // 使用双指针枚举 b 和 c
            int j = i + 1, k = n - 1;
            while (j < k) {
                int sum = nums[i] + nums[j] + nums[k];
                // 如果和为 target 直接返回答案
                if (sum == target) {
                    return target;
                }
                // 根据差值的绝对值来更新答案
                if (Math.abs(sum - target) < Math.abs(best - target)) {
                    best = sum;
                }
                if (sum > target) {
                    // 如果和大于 target，移动 c 对应的指针
                    int k0 = k - 1;
                    // 移动到下一个不相等的元素
                    while (j < k0 && nums[k0] == nums[k]) {
                        --k0;
                    }
                    k = k0;
                } else {
                    // 如果和小于 target，移动 b 对应的指针
                    int j0 = j + 1;
                    // 移动到下一个不相等的元素
                    while (j0 < k && nums[j0] == nums[j]) {
                        ++j0;
                    }
                    j = j0;
                }
            }
        }
        return best;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        nums.sort()
        n = len(nums)
        best = 10**7
        
        # 根据差值的绝对值来更新答案
        def update(cur):
            nonlocal best
            if abs(cur - target) < abs(best - target):
                best = cur
        
        # 枚举 a
        for i in range(n):
            # 保证和上一次枚举的元素不相等
            if i > 0 and nums[i] == nums[i - 1]:
                continue
            # 使用双指针枚举 b 和 c
            j, k = i + 1, n - 1
            while j < k:
                s = nums[i] + nums[j] + nums[k]
                # 如果和为 target 直接返回答案
                if s == target:
                    return target
                update(s)
                if s > target:
                    # 如果和大于 target，移动 c 对应的指针
                    k0 = k - 1
                    # 移动到下一个不相等的元素
                    while j < k0 and nums[k0] == nums[k]:
                        k0 -= 1
                    k = k0
                else:
                    # 如果和小于 target，移动 b 对应的指针
                    j0 = j + 1
                    # 移动到下一个不相等的元素
                    while j0 < k and nums[j0] == nums[j]:
                        j0 += 1
                    j = j0

        return best
```

```golang [sol1-Golang]
func threeSumClosest(nums []int, target int) int {
    sort.Ints(nums)
    var (
        n = len(nums)
        best = math.MaxInt32
    )

    // 根据差值的绝对值来更新答案
    update := func(cur int) {
        if abs(cur - target) < abs(best - target) {
            best = cur
        }
    }

    // 枚举 a
    for i := 0; i < n; i++ {
        // 保证和上一次枚举的元素不相等
        if i > 0 && nums[i] == nums[i-1] {
            continue
        }
        // 使用双指针枚举 b 和 c
        j, k := i + 1, n - 1
        for j < k {
            sum := nums[i] + nums[j] + nums[k]
            // 如果和为 target 直接返回答案
            if sum == target {
                return target
            }
            update(sum)
            if sum > target {
                // 如果和大于 target，移动 c 对应的指针
                k0 := k - 1
                // 移动到下一个不相等的元素
                for j < k0 && nums[k0] == nums[k] {
                    k0--
                } 
                k = k0
            } else {
                // 如果和小于 target，移动 b 对应的指针
                j0 := j + 1
                // 移动到下一个不相等的元素
                for j0 < k && nums[j0] == nums[j] {
                    j0++
                }
                j = j0
            }
        }
    }
    return best
}

func abs(x int) int {
    if x < 0 {
        return -1 * x
    }
    return x
}
```

```C [sol1-C]
int comp(const void *a, const void *b) { return *(int *)a - *(int *)b; }
int threeSumClosest(int *nums, int numsSize, int target) {
    int n = numsSize;
    qsort(nums, n, sizeof(int), comp);
    int best = 1e7;

    // 根据差值的绝对值来更新答案

    // 枚举 a
    for (int i = 0; i < n; ++i) {
        // 保证和上一次枚举的元素不相等
        if (i > 0 && nums[i] == nums[i - 1]) {
            continue;
        }
        // 使用双指针枚举 b 和 c
        int j = i + 1, k = n - 1;
        while (j < k) {
            int sum = nums[i] + nums[j] + nums[k];
            // 如果和为 target 直接返回答案
            if (sum == target) {
                return target;
            }
            if (abs(sum - target) < abs(best - target)) {
                best = sum;
            }
            if (sum > target) {
                // 如果和大于 target，移动 c 对应的指针
                int k0 = k - 1;
                // 移动到下一个不相等的元素
                while (j < k0 && nums[k0] == nums[k]) {
                    --k0;
                }
                k = k0;
            } else {
                // 如果和小于 target，移动 b 对应的指针
                int j0 = j + 1;
                // 移动到下一个不相等的元素
                while (j0 < k && nums[j0] == nums[j]) {
                    ++j0;
                }
                j = j0;
            }
        }
    }
    return best;
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是数组 $\textit{nums}$ 的长度。我们首先需要 $O(N \log N)$ 的时间对数组进行排序，随后在枚举的过程中，使用一重循环 $O(N)$ 枚举 $a$，双指针 $O(N)$ 枚举 $b$ 和 $c$，故一共是 $O(N^2)$。

- 空间复杂度：$O(\log N)$。排序需要使用 $O(\log N)$ 的空间。然而我们修改了输入的数组 $\textit{nums}$，在实际情况下不一定允许，因此也可以看成使用了一个额外的数组存储了 $\textit{nums}$ 的副本并进行排序，此时空间复杂度为 $O(N)$。