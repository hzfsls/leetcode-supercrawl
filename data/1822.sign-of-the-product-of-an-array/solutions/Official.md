## [1822.数组元素积的符号 中文官方题解](https://leetcode.cn/problems/sign-of-the-product-of-an-array/solutions/100000/shu-zu-yuan-su-ji-de-fu-hao-by-leetcode-f4uuj)

#### 方法一：遍历

如果数组中有一个元素 $0$，那么所有元素值的乘积肯定为 $0$，我们直接返回 $0$。使用 $\textit{sign}$ 记录元素值乘积的符号，$1$ 为表示正，$-1$ 表示为负，初始时 $\textit{sign} = 1$。遍历整个数组，如果元素为正，那么 $\textit{sign}$ 不变，否则令 $\textit{sign} = -\textit{sign}$，最后返回 $\textit{sign}$。

```Python [sol1-Python3]
class Solution:
    def arraySign(self, nums: List[int]) -> int:
        sign = 1
        for num in nums:
            if num == 0:
                return 0
            if num < 0:
                sign = -sign
        return sign
```

```C++ [sol1-C++]
class Solution {
public:
    int arraySign(vector<int>& nums) {
        int sign = 1;
        for (auto num : nums) {
            if (num == 0) {
                return 0;
            }
            if (num < 0) {
                sign = -sign;
            }
        }
        return sign;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int arraySign(int[] nums) {
        int sign = 1;
        for (int num : nums) {
            if (num == 0) {
                return 0;
            }
            if (num < 0) {
                sign = -sign;
            }
        }
        return sign;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ArraySign(int[] nums) {
        int sign = 1;
        foreach (int num in nums) {
            if (num == 0) {
                return 0;
            }
            if (num < 0) {
                sign = -sign;
            }
        }
        return sign;
    }
}
```

```C [sol1-C]
int arraySign(int* nums, int numsSize) {
    int sign = 1;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] == 0) {
            return 0;
        }
        if (nums[i] < 0) {
            sign = -sign;
        }
    }
    return sign;
}
```

```JavaScript [sol1-JavaScript]
var arraySign = function(nums) {
    let sign = 1;
    for (const num of nums) {
        if (num === 0) {
            return 0;
        }
        if (num < 0) {
            sign = -sign;
        }
    }
    return sign;
};
```

```go [sol1-Golang]
func arraySign(nums []int) int {
    sign := 1
    for _, num := range nums {
        if num == 0 {
            return 0
        }
        if num < 0 {
            sign = -sign
        }
    }
    return sign
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为数组大小。

+ 空间复杂度：$O(1)$。