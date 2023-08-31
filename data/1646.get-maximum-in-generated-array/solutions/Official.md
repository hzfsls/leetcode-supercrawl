## [1646.获取生成数组中的最大值 中文官方题解](https://leetcode.cn/problems/get-maximum-in-generated-array/solutions/100000/huo-qu-sheng-cheng-shu-zu-zhong-de-zui-d-0z2l)

#### 方法一：模拟

我们可以直接根据题目中描述的规则来计算出 $\textit{nums}$ 数组，并返回其最大元素。

为了简化代码逻辑，我们可以化简题目中的递推式。当 $i\ge 2$ 时：

- 若 $i$ 为偶数，有 $\textit{nums}[i] = \textit{nums}[\dfrac{i}{2}]$；
- 若 $i$ 为奇数，有 $\textit{nums}[i] = \textit{nums}[\Big\lfloor\dfrac{i}{2}\Big\rfloor] + \textit{nums}[\Big\lfloor\dfrac{i}{2}\Big\rfloor+1]$。

这两种情况可以合并为：

$$
\textit{nums}[i] = \textit{nums}[\Big\lfloor\dfrac{i}{2}\Big\rfloor] + (i\bmod 2) \cdot \textit{nums}[\Big\lfloor\dfrac{i}{2}\Big\rfloor+1]
$$

```Python [sol1-Python3]
class Solution:
    def getMaximumGenerated(self, n: int) -> int:
        if n == 0:
            return 0
        nums = [0] * (n + 1)
        nums[1] = 1
        for i in range(2, n + 1):
            nums[i] = nums[i // 2] + i % 2 * nums[i // 2 + 1]
        return max(nums)
```

```C++ [sol1-C++]
class Solution {
public:
    int getMaximumGenerated(int n) {
        if (n == 0) {
            return 0;
        }
        vector<int> nums(n + 1);
        nums[1] = 1;
        for (int i = 2; i <= n; ++i) {
            nums[i] = nums[i / 2] + i % 2 * nums[i / 2 + 1];
        }
        return *max_element(nums.begin(), nums.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getMaximumGenerated(int n) {
        if (n == 0) {
            return 0;
        }
        int[] nums = new int[n + 1];
        nums[1] = 1;
        for (int i = 2; i <= n; ++i) {
            nums[i] = nums[i / 2] + i % 2 * nums[i / 2 + 1];
        }
        return Arrays.stream(nums).max().getAsInt();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GetMaximumGenerated(int n) {
        if (n == 0) {
            return 0;
        }
        int[] nums = new int[n + 1];
        nums[1] = 1;
        for (int i = 2; i <= n; ++i) {
            nums[i] = nums[i / 2] + i % 2 * nums[i / 2 + 1];
        }
        return nums.Max();
    }
}
```

```go [sol1-Golang]
func getMaximumGenerated(n int) (ans int) {
    if n == 0 {
        return
    }
    nums := make([]int, n+1)
    nums[1] = 1
    for i := 2; i <= n; i++ {
        nums[i] = nums[i/2] + i%2*nums[i/2+1]
    }
    for _, v := range nums {
        ans = max(ans, v)
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var getMaximumGenerated = function(n) {
    if (n === 0) {
        return 0;
    }
    const nums = new Array(n + 1).fill(0);
    nums[1] = 1;
    for (let i = 2; i <= n; ++i) {
        nums[i] = nums[Math.floor(i / 2)] + i % 2 * nums[Math.floor(i / 2) + 1];
    }
    return Math.max(...nums);
};
```

```C [sol1-C]
int getMaximumGenerated(int n) {
    if (n == 0) {
        return 0;
    }
    int nums[n + 1];
    nums[1] = 1;
    int ret = 1;
    for (int i = 2; i <= n; ++i) {
        nums[i] = nums[i / 2] + i % 2 * nums[i / 2 + 1];
        ret = fmax(ret, nums[i]);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(n)$。