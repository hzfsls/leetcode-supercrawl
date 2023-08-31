## [128.最长连续序列 中文官方题解](https://leetcode.cn/problems/longest-consecutive-sequence/solutions/100000/zui-chang-lian-xu-xu-lie-by-leetcode-solution)

#### 方法一：哈希表

**思路和算法**

我们考虑枚举数组中的每个数 $x$，考虑以其为起点，不断尝试匹配 $x+1, x+2, \cdots$ 是否存在，假设最长匹配到了 $x+y$，那么以 $x$ 为起点的最长连续序列即为 $x, x+1, x+2, \cdots, x+y$，其长度为 $y+1$，我们不断枚举并更新答案即可。

对于匹配的过程，暴力的方法是 $O(n)$ 遍历数组去看是否存在这个数，但其实更高效的方法是用一个哈希表存储数组中的数，这样查看一个数是否存在即能优化至 $O(1)$ 的时间复杂度。

仅仅是这样我们的算法时间复杂度最坏情况下还是会达到 $O(n^2)$（即外层需要枚举 $O(n)$ 个数，内层需要暴力匹配 $O(n)$ 次），无法满足题目的要求。但仔细分析这个过程，我们会发现其中执行了很多不必要的枚举，如果已知有一个 $x, x+1, x+2, \cdots, x+y$ 的连续序列，而我们却重新从 $x+1$，$x+2$ 或者是 $x+y$ 处开始尝试匹配，那么得到的结果肯定不会优于枚举 $x$ 为起点的答案，因此我们在外层循环的时候碰到这种情况跳过即可。

那么怎么判断是否跳过呢？由于我们要枚举的数 $x$ 一定是在数组中不存在前驱数 $x-1$ 的，不然按照上面的分析我们会从 $x-1$ 开始尝试匹配，因此我们每次在哈希表中检查是否存在 $x-1$ 即能判断是否需要跳过了。

<![fig1](https://assets.leetcode-cn.com/solution-static/128/1.PNG),![fig2](https://assets.leetcode-cn.com/solution-static/128/2.PNG),![fig3](https://assets.leetcode-cn.com/solution-static/128/3.PNG),![fig4](https://assets.leetcode-cn.com/solution-static/128/4.PNG),![fig5](https://assets.leetcode-cn.com/solution-static/128/5.PNG),![fig6](https://assets.leetcode-cn.com/solution-static/128/6.PNG),![fig7](https://assets.leetcode-cn.com/solution-static/128/7.PNG),![fig8](https://assets.leetcode-cn.com/solution-static/128/8.PNG),![fig9](https://assets.leetcode-cn.com/solution-static/128/9.PNG),![fig10](https://assets.leetcode-cn.com/solution-static/128/10.PNG),![fig11](https://assets.leetcode-cn.com/solution-static/128/11.PNG),![fig12](https://assets.leetcode-cn.com/solution-static/128/12.PNG)>

增加了判断跳过的逻辑之后，时间复杂度是多少呢？外层循环需要 $O(n)$ 的时间复杂度，只有当一个数是连续序列的第一个数的情况下才会进入内层循环，然后在内层循环中匹配连续序列中的数，因此数组中的每个数只会进入内层循环一次。根据上述分析可知，总时间复杂度为 $O(n)$，符合题目要求。

```Java [sol1-Java]
class Solution {
    public int longestConsecutive(int[] nums) {
        Set<Integer> num_set = new HashSet<Integer>();
        for (int num : nums) {
            num_set.add(num);
        }

        int longestStreak = 0;

        for (int num : num_set) {
            if (!num_set.contains(num - 1)) {
                int currentNum = num;
                int currentStreak = 1;

                while (num_set.contains(currentNum + 1)) {
                    currentNum += 1;
                    currentStreak += 1;
                }

                longestStreak = Math.max(longestStreak, currentStreak);
            }
        }

        return longestStreak;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        longest_streak = 0
        num_set = set(nums)

        for num in num_set:
            if num - 1 not in num_set:
                current_num = num
                current_streak = 1

                while current_num + 1 in num_set:
                    current_num += 1
                    current_streak += 1

                longest_streak = max(longest_streak, current_streak)

        return longest_streak
```

```C++ [sol1-C++]
class Solution {
public:
    int longestConsecutive(vector<int>& nums) {
        unordered_set<int> num_set;
        for (const int& num : nums) {
            num_set.insert(num);
        }

        int longestStreak = 0;

        for (const int& num : num_set) {
            if (!num_set.count(num - 1)) {
                int currentNum = num;
                int currentStreak = 1;

                while (num_set.count(currentNum + 1)) {
                    currentNum += 1;
                    currentStreak += 1;
                }

                longestStreak = max(longestStreak, currentStreak);
            }
        }

        return longestStreak;           
    }
};
```

```TypeScript [sol1-TypeScript]
var longestConsecutive = function(nums: number[]): number {
    let num_set: Set<number> = new Set();
    for (const num of nums) {
        num_set.add(num);
    }

    let longestStreak = 0;

    for (const num of num_set) {
        if (!num_set.has(num - 1)) {
            let currentNum = num;
            let currentStreak = 1;

            while (num_set.has(currentNum + 1)) {
                currentNum += 1;
                currentStreak += 1;
            }

            longestStreak = Math.max(longestStreak, currentStreak);
        }
    }

    return longestStreak;   
};
```

```golang [sol1-Golang]
func longestConsecutive(nums []int) int {
    numSet := map[int]bool{}
    for _, num := range nums {
        numSet[num] = true
    }
    longestStreak := 0
    for num := range numSet {
        if !numSet[num-1] {
            currentNum := num
            currentStreak := 1
            for numSet[currentNum+1] {
                currentNum++
                currentStreak++
            }
            if longestStreak < currentStreak {
                longestStreak = currentStreak
            }
        }
    }
    return longestStreak
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。具体分析已在上面正文中给出。

- 空间复杂度：$O(n)$。哈希表存储数组中所有的数需要 $O(n)$ 的空间。