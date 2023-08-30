#### 方法一：差分 + 计数

**思路与算法**

考虑一个比较直观的做法：

- 我们枚举等差数列的最后两项 $\textit{nums}[i - 1]$ 以及 $\textit{nums}[i]$，那么等差数列的公差 $d$ 即为 $\textit{nums}[i - 1] - \textit{nums}[i]$；

- 随后我们使用一个指针 $j$ 从 $i - 2$ 开始逆序地遍历数组的前缀部分 $\textit{nums}[0 .. i-2]$：

    - 如果 $\textit{nums}[j] - \textit{nums}[j + 1] = d$，那么说明 $\textit{nums}[j], \cdots, \textit{nums}[i]$ 组成了一个长度至少为 $3$ 的等差数列，答案增加 $1$；

    - 否则更小的 $j$ 也无法作为等差数列的首个位置了，我们直接退出遍历。

这个做法的时间复杂度是 $O(n^2)$ 的，即枚举最后两项的时间复杂度为 $O(n)$，使用指针 $j$ 遍历的时间复杂度也为 $O(n)$，相乘得到总时间复杂度 $O(n^2)$。对于一些运行较慢的语言，该方法可能会超出时间限制，因此我们需要进行优化。

**优化**

如果我们已经求出了 $\textit{nums}[i - 1]$ 以及 $\textit{nums}[i]$ 作为等差数列的最后两项时，答案增加的次数 $t_i$，那么能否快速地求出 $t_{i+1}$ 呢？

答案是可以的：

- 如果 $\textit{nums}[i] - \textit{nums}[i + 1] = d$，那么在这一轮遍历中，$j$ 会遍历到与上一轮相同的位置，答案增加的次数相同，并且额外多出了 $\textit{nums}[i-1], \textit{nums}[i], \textit{nums}[i+1]$ 这一个等差数列，因此有：

$$
t_{i+1} = t_i + 1
$$

- 如果 $\textit{nums}[i] - \textit{num}[i + 1] \neq d$，那么 $j$ 从初始值 $i-1$ 开始就会直接退出遍历，答案不会增加，因此有：

$$
t_{i+1} = 0
$$

这样一来，我们通过上述简单的递推，即可在 $O(1)$ 的时间计算等差数列数量的增量，总时间复杂度减少至 $O(n)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfArithmeticSlices(vector<int>& nums) {
        int n = nums.size();
        if (n == 1) {
            return 0;
        }

        int d = nums[0] - nums[1], t = 0;
        int ans = 0;
        // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
        for (int i = 2; i < n; ++i) {
            if (nums[i - 1] - nums[i] == d) {
                ++t;
            }
            else {
                d = nums[i - 1] - nums[i];
                t = 0;
            }
            ans += t;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfArithmeticSlices(int[] nums) {
        int n = nums.length;
        if (n == 1) {
            return 0;
        }

        int d = nums[0] - nums[1], t = 0;
        int ans = 0;
        // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
        for (int i = 2; i < n; ++i) {
            if (nums[i - 1] - nums[i] == d) {
                ++t;
            } else {
                d = nums[i - 1] - nums[i];
                t = 0;
            }
            ans += t;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfArithmeticSlices(int[] nums) {
        int n = nums.Length;
        if (n == 1) {
            return 0;
        }

        int d = nums[0] - nums[1], t = 0;
        int ans = 0;
        // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
        for (int i = 2; i < n; ++i) {
            if (nums[i - 1] - nums[i] == d) {
                ++t;
            } else {
                d = nums[i - 1] - nums[i];
                t = 0;
            }
            ans += t;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        n = len(nums)
        if n == 1:
            return 0
        
        d, t = nums[0] - nums[1], 0
        ans = 0
        
        # 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
        for i in range(2, n):
            if nums[i - 1] - nums[i] == d:
                t += 1
            else:
                d = nums[i - 1] - nums[i]
                t = 0
            ans += t
        
        return ans
```

```go [sol1-Golang]
func numberOfArithmeticSlices(nums []int) (ans int) {
    n := len(nums)
    if n == 1 {
        return
    }

    d, t := nums[0]-nums[1], 0
    // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
    for i := 2; i < n; i++ {
        if nums[i-1]-nums[i] == d {
            t++
        } else {
            d, t = nums[i-1]-nums[i], 0
        }
        ans += t
    }
    return
}
```

```C [sol1-C]
int numberOfArithmeticSlices(int* nums, int numsSize) {
    if (numsSize == 1) {
        return 0;
    }

    int d = nums[0] - nums[1], t = 0;
    int ans = 0;
    // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
    for (int i = 2; i < numsSize; ++i) {
        if (nums[i - 1] - nums[i] == d) {
            ++t;
        } else {
            d = nums[i - 1] - nums[i];
            t = 0;
        }
        ans += t;
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numberOfArithmeticSlices = function(nums) {
    const n = nums.length;
    if (n === 1) {
        return 0;
    }

    let d = nums[0] - nums[1], t = 0;
    let ans = 0;
    // 因为等差数列的长度至少为 3，所以可以从 i=2 开始枚举
    for (let i = 2; i < n; ++i) {
        if (nums[i - 1] - nums[i] === d) {
            ++t;
        } else {
            d = nums[i - 1] - nums[i];
            t = 0;
        }
        ans += t;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。