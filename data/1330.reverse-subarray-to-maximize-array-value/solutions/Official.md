#### 方法一：枚举所有可能性

**思路**

设数组 $\textit{nums}$ 的长度为 $n$。原数组的数组值的表达式为 $\textit{value}_1 = \sum\limits_{i=0}^{n-2}|\textit{nums}[i+1]-\textit{nums}[i]|$。假设我们选择起点下标为 $j$，终点下标为 $k~(j\leq k)$ 的子数组进行翻转，下面进行讨论：

1. $j=k$，此时不难发现执行翻转操作后的数组的数组值 $\textit{value}_2 = \textit{value}_1$。
2. $j=0$ 且 $k=n-1$，此时 $\textit{value}_2 = \textit{value}_1$。
3. $j=0$ 且 $k\lt n-1$，此时 $\textit{value}_2 = \sum\limits_{i=0}^{k-1}|\textit{nums}[i+1]-\textit{nums}[i]| + |\textit{nums}[k+1]-\textit{nums}[0]| + \sum\limits_{i=k+1}^{n-1}|\textit{nums}[i+1]-\textit{nums}[i]|$。可以得到 $\textit{value}_2 = \textit{value}_1 - |\textit{nums}[k+1]-\textit{nums}[k]|+ |\textit{nums}[k+1]-\textit{nums}[0]|$。这种情况下 $\textit{value}_2$ 的最大值可以通过遍历 $k$ 获得。
4. $j>0$ 且 $k = n-1$。此时  $\textit{value}_2 = \textit{value}_1 - |\textit{nums}[j]-\textit{nums}[j-1]| + |\textit{nums}[n-1]-\textit{nums}[j-1]|$。这种情况下 $\textit{value}_2$ 的最大值可以通过遍历 $j$ 获得。
5. $j>0$ 且 $k\lt n-1$。此时 $\textit{value}_2 = \textit{value}_1 - |\textit{nums}[j]-\textit{nums}[j-1]| - |\textit{nums}[k+1]-\textit{nums}[k]| + |\textit{nums}[k]-\textit{nums}[j-1]| + |\textit{nums}[k+1]-\textit{nums}[j]|$。令 $\delta = -|\textit{nums}[j]-\textit{nums}[j-1]| - |\textit{nums}[k+1]-\textit{nums}[k]| + |\textit{nums}[k]-\textit{nums}[j-1]| + |\textit{nums}[k+1]-\textit{nums}[j]|$，则 $\textit{value}_2 = \textit{value}_1 + \delta$。因为 $\textit{value}_1$ 为定值，为了使 $\textit{value}_2$ 取得最大值，需要求出 $\delta$ 的最大值。这种情况下 $\delta$ 的最大值可以通过双重遍历 $j$ 和 $k$ 获得，但会带入较大的时间复杂度。为了降低时间复杂度，仍要进行讨论。假设 $\textit{nums}[j-1],\textit{nums}[j],\textit{nums}[k],\textit{nums}[k+1]$ 四个数由小到大排列的值分别为 $a,b,c,d$，下面进行讨论： 
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = b-a$，$|\textit{nums}[k+1]-\textit{nums}[k]| = d-c$，则 $\delta = -(b-a)-(d-c)+\textit{nums}[k]-\textit{nums}[j-1] + \textit{nums}[k+1]-\textit{nums}[j] = 2\times(c-b)$。
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = d-c$，$|\textit{nums}[k+1]-\textit{nums}[k]| = b-a$，则 $\delta = -(d-c)-(b-a)-\textit{nums}[k]+\textit{nums}[j-1] - \textit{nums}[k+1]+\textit{nums}[j] = 2\times(c-b)$。即同上。
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = c-a$，$|\textit{nums}[k+1]-\textit{nums}[k]| = d-b$。此时 $\delta = a+b-c-d +|\textit{nums}[k]-\textit{nums}[j-1]| + |\textit{nums}[k+1]-\textit{nums}[j]|$。可以发现这时 $\delta$ 不可能为正数，因为最大的两项已经为负数，后四项为两正两负，无法使 $\delta$ 为正数。
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = d-a$，$|\textit{nums}[k+1]-\textit{nums}[k]| = c-b$。此时 $\delta = a+b-c-d +|\textit{nums}[k]-\textit{nums}[j-1]| + |\textit{nums}[k+1]-\textit{nums}[j]|$。同上。
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = c-b$，$|\textit{nums}[k+1]-\textit{nums}[k]| = d-a$。同上。
    - $|\textit{nums}[j]-\textit{nums}[j-1]| = d-b$，$|\textit{nums}[k+1]-\textit{nums}[k]| = c-a$。同上。
   
    讨论完六种情况后发现只有两种情况下 $\delta$ 可能为正。这两种情况下，均是求 $2\times(c-b)$。即两个相邻数对，当一个数对的较大值小于另一个数对的较小值时，求差值的两倍。我们需要求出这个差值的两倍的最大值。求出 $\delta$ 的最大值后，加上 $\textit{value}_1$，即为 $\textit{value}_2$ 的最大值。

最后再求出这五种情况下的最大值即可返回结果。

**代码**

```Java [sol1-Java]
class Solution {
    public int maxValueAfterReverse(int[] nums) {
        int value = 0, n = nums.length;
        for (int i = 0; i < n - 1; i++) {
            value += Math.abs(nums[i] - nums[i + 1]);
        }
        int mx1 = 0;
        for (int i = 1; i < n - 1; i++) {
            mx1 = Math.max(mx1, Math.abs(nums[0] - nums[i + 1]) - Math.abs(nums[i] - nums[i + 1]));
            mx1 = Math.max(mx1, Math.abs(nums[n - 1] - nums[i - 1]) - Math.abs(nums[i] - nums[i - 1]));
        }
        int mx2 = Integer.MIN_VALUE, mn2 = Integer.MAX_VALUE;
        for (int i = 0; i < n - 1; i++) {
            int x = nums[i], y = nums[i + 1];
            mx2 = Math.max(mx2, Math.min(x, y));
            mn2 = Math.min(mn2, Math.max(x, y));
        }
        return value + Math.max(mx1, 2 * (mx2 - mn2));
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxValueAfterReverse(int[] nums) {
        int value = 0, n = nums.Length;
        for (int i = 0; i < n - 1; i++) {
            value += Math.Abs(nums[i] - nums[i + 1]);
        }
        int mx1 = 0;
        for (int i = 1; i < n - 1; i++) {
            mx1 = Math.Max(mx1, Math.Abs(nums[0] - nums[i + 1]) - Math.Abs(nums[i] - nums[i + 1]));
            mx1 = Math.Max(mx1, Math.Abs(nums[n - 1] - nums[i - 1]) - Math.Abs(nums[i] - nums[i - 1]));
        }
        int mx2 = int.MinValue, mn2 = int.MaxValue;
        for (int i = 0; i < n - 1; i++) {
            int x = nums[i], y = nums[i + 1];
            mx2 = Math.Max(mx2, Math.Min(x, y));
            mn2 = Math.Min(mn2, Math.Max(x, y));
        }
        return value + Math.Max(mx1, 2 * (mx2 - mn2));
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxValueAfterReverse(self, nums: List[int]) -> int:
        value, n = 0, len(nums)
        for i in range(n - 1):
            value += abs(nums[i] - nums[i + 1])
        mx1 = 0
        for i in range(1, n - 1):
            mx1 = max(mx1, abs(nums[0] - nums[i + 1]) - abs(nums[i] - nums[i + 1]))
            mx1 = max(mx1, abs(nums[-1] - nums[i - 1]) - abs(nums[i] - nums[i - 1]))
        mx2, mn2 = -inf, inf
        for i in range(n - 1):
            x, y = nums[i], nums[i + 1]
            mx2 = max(mx2, min(x, y))
            mn2 = min(mn2, max(x, y))
        return value + max(mx1, 2 * (mx2 - mn2))
```

```Go [sol1-Go]
func maxValueAfterReverse(nums []int) int {
    value, n := 0, len(nums)
    for i := 0; i < n - 1; i++ {
        value += Abs(nums[i] - nums[i + 1])
    }
    mx1 := 0
    for i := 1; i < n - 1; i++ {
        mx1 = Max(mx1, Abs(nums[0] - nums[i + 1]) - Abs(nums[i] - nums[i + 1]))
        mx1 = Max(mx1, Abs(nums[n - 1] - nums[i - 1]) - Abs(nums[i] - nums[i - 1]))
    }
    mx2, mn2 := -100000, 100000
    for i := 0; i < n - 1; i++ {
        x, y := nums[i], nums[i + 1]
        mx2 = Max(mx2, Min(x, y))
        mn2 = Min(mn2, Max(x, y))
    }
    return value + Max(mx1, 2 * (mx2 - mn2))
}


func Abs(a int) int{
    if a < 0{
        return -a
    }
    return a
}

func Max(a,b int) int{
    if a < b{
        return b
    }
    return a
}

func Min(a,b int) int{
    if a > b{
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var maxValueAfterReverse = function(nums) {
    let value = 0;
    let n = nums.length;
    for (let i = 0; i < n - 1; i++) {
        value += Math.abs(nums[i] - nums[i + 1]);
    }
    let mx1 = 0;
    for (let i = 1; i < n - 1; i++) {
        mx1 = Math.max(mx1, Math.abs(nums[0] - nums[i + 1]) - Math.abs(nums[i] - nums[i + 1]));
        mx1 = Math.max(mx1, Math.abs(nums[n - 1] - nums[i - 1]) - Math.abs(nums[i] - nums[i - 1]));
    }
    let mx2 = -Infinity, mn2 = Infinity;
    for (let i = 0; i < n - 1; i++) {
        let x = nums[i];
        let y = nums[i + 1];
        mx2 = Math.max(mx2, Math.min(x, y));
        mn2 = Math.min(mn2, Math.max(x, y));
    }
    return value + Math.max(mx1, 2 * (mx2 - mn2));
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxValueAfterReverse(vector<int>& nums) {
        int value = 0, n = nums.size();
        for (int i = 0; i < n - 1; i++) {
            value += abs(nums[i] - nums[i + 1]);
        }
        int mx1 = 0;
        for (int i = 1; i < n - 1; i++) {
            mx1 = max(mx1, abs(nums[0] - nums[i + 1]) - abs(nums[i] - nums[i + 1]));
            mx1 = max(mx1, abs(nums[n - 1] - nums[i - 1]) - abs(nums[i] - nums[i - 1]));
        }
        int mx2 = INT_MIN, mn2 = INT_MAX;
        for (int i = 0; i < n - 1; i++) {
            int x = nums[i], y = nums[i + 1];
            mx2 = max(mx2, min(x, y));
            mn2 = min(mn2, max(x, y));
        }
        return value + max(mx1, 2 * (mx2 - mn2));
    }
};
```

```C [sol1-C]
static inline int max(int a, int b) {
    return a > b ? a : b;
}

static inline int min(int a, int b) {
    return a < b ? a : b;
}

int maxValueAfterReverse(int* nums, int numsSize) {
    int value = 0, n = numsSize;
    for (int i = 0; i < n - 1; i++) {
        value += abs(nums[i] - nums[i + 1]);
    }
    int mx1 = 0;
    for (int i = 1; i < n - 1; i++) {
        mx1 = max(mx1, abs(nums[0] - nums[i + 1]) - abs(nums[i] - nums[i + 1]));
        mx1 = max(mx1, abs(nums[n - 1] - nums[i - 1]) - abs(nums[i] - nums[i - 1]));
    }
    int mx2 = INT_MIN, mn2 = INT_MAX;
    for (int i = 0; i < n - 1; i++) {
        int x = nums[i], y = nums[i + 1];
        mx2 = max(mx2, min(x, y));
        mn2 = min(mn2, max(x, y));
    }
    return value + max(mx1, 2 * (mx2 - mn2));
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。仅使用常数空间。