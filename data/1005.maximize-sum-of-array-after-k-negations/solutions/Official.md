#### 方法一：从小到大修改每个负数

**思路与算法**

由于我们希望数组的和尽可能大，因此除非万不得已，我们应当总是修改负数，并且优先修改值最小的负数。因为将负数 $-x$ 修改成 $x$ 会使得数组的和增加 $2x$，所以这样的贪心操作是最优的。

当给定的 $K$ 小于等于数组中负数的个数时，我们按照上述方法从小到大依次修改每一个负数即可。但如果 $K$ 的值较大，那么我们不得不去修改非负数（即正数或者 $0$）了。由于修改 $0$ 对数组的和不会有影响，而修改正数会使得数组的和减小，因此：

- 如果数组中存在 $0$，那么我们可以对它进行多次修改，直到把剩余的修改次数用完；

- 如果数组中不存在 $0$ 并且剩余的修改次数是偶数，由于对同一个数修改两次等价于不进行修改，因此我们也可以在不减小数组的和的前提下，把修改次数用完；

- 如果数组中不存在 $0$ 并且剩余的修改次数是奇数，那么我们必然需要使用单独的一次修改将一个正数变为负数（剩余的修改次数为偶数，就不会减小数组的和）。为了使得数组的和尽可能大，我们就选择那个最小的正数。

    需要注意的是，在之前将负数修改为正数的过程中，可能出现了（相较于原始数组中最小的正数）更小的正数，这一点不能忽略。

**细节**

为了实现上面的算法，我们可以对数组进行升序排序，首先依次遍历每一个负数（将负数修改为正数），再遍历所有的数（将 $0$ 或最小的正数进行修改）。

然而注意到本题中数组元素的范围为 $[-100, 100]$，因此我们可以使用计数数组（桶）或者哈希表，直接统计每个元素出现的次数，再升序遍历元素的范围，这样就省去了排序需要的时间。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestSumAfterKNegations(vector<int>& nums, int k) {
        unordered_map<int, int> freq;
        for (int num: nums) {
            freq[num] += 1;
        }
        int ans = accumulate(nums.begin(), nums.end(), 0);
        for (int i = -100; i < 0; ++i) {
            if (freq[i]) {
                int ops = min(k, freq[i]);
                ans += (-i) * ops * 2;
                freq[i] -= ops;
                freq[-i] += ops;
                k -= ops;
                if (k == 0) {
                    break;
                }
            }
        }
        if (k > 0 && k % 2 == 1 && !freq[0]) {
            for (int i = 1; i <= 100; ++i) {
                if (freq[i]) {
                    ans -= i * 2;
                    break;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int largestSumAfterKNegations(int[] nums, int k) {
        Map<Integer, Integer> freq = new HashMap<Integer, Integer>();
        for (int num : nums) {
            freq.put(num, freq.getOrDefault(num, 0) + 1);
        }
        int ans = Arrays.stream(nums).sum();
        for (int i = -100; i < 0; ++i) {
            if (freq.containsKey(i)) {
                int ops = Math.min(k, freq.get(i));
                ans += (-i) * ops * 2;
                freq.put(i, freq.get(i) - ops);
                freq.put(-i, freq.getOrDefault(-i, 0) + ops);
                k -= ops;
                if (k == 0) {
                    break;
                }
            }
        }
        if (k > 0 && k % 2 == 1 && !freq.containsKey(0)) {
            for (int i = 1; i <= 100; ++i) {
                if (freq.containsKey(i)) {
                    ans -= i * 2;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LargestSumAfterKNegations(int[] nums, int k) {
        Dictionary<int, int> freq = new Dictionary<int, int>();
        foreach (int num in nums) {
            if (!freq.ContainsKey(num)) {
                freq.Add(num, 0);
            }
            freq[num] += 1;
        }
        int ans = nums.Sum();
        for (int i = -100; i < 0; ++i) {
            if (freq.ContainsKey(i)) {
                int ops = Math.Min(k, freq[i]);
                ans += (-i) * ops * 2;
                freq[i] -= ops;
                if (!freq.ContainsKey(-i)) {
                    freq.Add(-i, 0);
                }
                freq[-i] += ops;
                k -= ops;
                if (k == 0) {
                    break;
                }
            }
        }
        if (k > 0 && k % 2 == 1 && !freq.ContainsKey(0)) {
            for (int i = 1; i <= 100; ++i) {
                if (freq.ContainsKey(i)) {
                    ans -= i * 2;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def largestSumAfterKNegations(self, nums: List[int], k: int) -> int:
        freq = Counter(nums)
        ans = sum(nums)
        for i in range(-100, 0):
            if freq[i]:
                ops = min(k, freq[i])
                ans += -i * ops * 2
                freq[i] -= ops
                freq[-i] += ops
                k -= ops
                if k == 0:
                    break
        
        if k > 0 and k % 2 == 1 and not freq[0]:
            for i in range(1, 101):
                if freq[i]:
                    ans -= i * 2
                    break
        
        return ans
```

```go [sol1-Golang]
func largestSumAfterKNegations(nums []int, k int) (ans int) {
    freq := map[int]int{}
    for _, num := range nums {
        freq[num]++
        ans += num
    }
    for i := -100; i < 0 && k != 0; i++ {
        if freq[i] > 0 {
            ops := min(k, freq[i])
            ans -= i * ops * 2
            freq[-i] += ops
            k -= ops
        }
    }
    if k > 0 && k%2 == 1 && freq[0] == 0 {
        for i := 1; i <= 100; i++ {
            if freq[i] > 0 {
                ans -= i * 2
                break
            }
        }
    }
    return
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var largestSumAfterKNegations = function(nums, k) {
    const freq = new Map();
    for (const num of nums) {
        freq.set(num, (freq.get(num) || 0) + 1);
    }
    let ans = _.sum(nums);
    for (let i = -100; i < 0; ++i) {
        if (freq.has(i)) {
            const ops = Math.min(k, freq.get(i));
            ans += (-i) * ops * 2;
            freq.set(i, freq.get(i) - ops);
            freq.set(-i, (freq.get(-i) || 0) + ops);
            k -= ops;
            if (k === 0) {
                break;
            }
        }
    }
    if (k > 0 && k % 2 === 1 && !freq.has(0)) {
        for (let i = 1; i <= 100; ++i) {
            if (freq.has(i)) {
                ans -= i * 2;
                break;
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中元素的范围，本题中 $C = 201$。

    我们需要 $O(n)$ 的时间使用桶或哈希表统计每个元素出现的次数，随后需要 $O(C)$ 的时间对元素进行操作。

- 空间复杂度：$O(C)$，即为桶或哈希表需要使用的空间。