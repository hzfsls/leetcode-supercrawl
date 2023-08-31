## [747.至少是其他数字两倍的最大数 中文官方题解](https://leetcode.cn/problems/largest-number-at-least-twice-of-others/solutions/100000/zhi-shao-shi-qi-ta-shu-zi-liang-bei-de-z-985m)
#### 方法一：遍历

**思路与算法**

遍历数组分别找到数组的最大值 $m_1$ 和次大值 $m_2$。如果 $m_1 \ge m_2 \times 2$ 成立，则最大值至少是数组其余数字的两倍，此时返回最大值的下标，否则返回 $-1$。

为了返回最大值的下标，我们需要在计算最大值的同时记录最大值的下标。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int dominantIndex(vector<int>& nums) {
        int m1 = -1, m2 = -1;
        int index = -1;
        for (int i = 0; i < nums.size(); i++) {
            if (nums[i] > m1) {
                m2 = m1;
                m1 = nums[i];
                index = i;
            } else if (nums[i] > m2) {
                m2 = nums[i];
            }
        }
        return m1 >= m2 * 2 ? index : -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int dominantIndex(int[] nums) {
        int m1 = -1, m2 = -1;
        int index = -1;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] > m1) {
                m2 = m1;
                m1 = nums[i];
                index = i;
            } else if (nums[i] > m2) {
                m2 = nums[i];
            }
        }
        return m1 >= m2 * 2 ? index : -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DominantIndex(int[] nums) {
        int m1 = -1, m2 = -1;
        int index = -1;
        for (int i = 0; i < nums.Length; i++) {
            if (nums[i] > m1) {
                m2 = m1;
                m1 = nums[i];
                index = i;
            } else if (nums[i] > m2) {
                m2 = nums[i];
            }
        }
        return m1 >= m2 * 2 ? index : -1;
    }
}
```

```C [sol1-C]
int dominantIndex(int* nums, int numsSize) {
    int m1 = -1, m2 = -1;
    int index = -1;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] > m1) {
            m2 = m1;
            m1 = nums[i];
            index = i;
        } else if (nums[i] > m2) {
            m2 = nums[i];
        }
    }
    return m1 >= m2 * 2 ? index : -1;
}
```

```Python [sol1-Python3]
class Solution:
    def dominantIndex(self, nums: List[int]) -> int:
        m1, m2, idx = -1, -1, 0
        for i, num in enumerate(nums):
            if num > m1:
                m1, m2, idx = num, m1, i
            elif num > m2:
                m2 = num
        return idx if m1 >= m2 * 2 else -1
```

```go [sol1-Golang]
func dominantIndex(nums []int) int {
    m1, m2, idx := -1, -1, 0
    for i, num := range nums {
        if num > m1 {
            m1, m2, idx = num, m1, i
        } else if num > m2 {
            m2 = num
        }
    }
    if m1 >= m2*2 {
        return idx
    }
    return -1
}
```

```JavaScript [sol1-JavaScript]
var dominantIndex = function(nums) {
    let m1 = -1, m2 = -1;
    let index = -1;
    for (let i = 0; i < nums.length; i++) {
        if (nums[i] > m1) {
            m2 = m1;
            m1 = nums[i];
            index = i;
        } else if (nums[i] > m2) {
            m2 = nums[i];
        }
    }
    return m1 >= m2 * 2 ? index : -1;
};
```

**复杂度分析**

+ 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。遍历整个数组需要 $O(N)$。

+ 空间复杂度：$O(1)$。