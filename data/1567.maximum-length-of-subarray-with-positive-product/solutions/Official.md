## [1567.乘积为正数的最长子数组长度 中文官方题解](https://leetcode.cn/problems/maximum-length-of-subarray-with-positive-product/solutions/100000/cheng-ji-wei-zheng-shu-de-zui-chang-zi-shu-zu-ch-3)

#### 方法一：动态规划

可以使用动态规划得到乘积为正数的最长子数组长度。定义两个数组 $\textit{positive}$ 和 $\textit{negative}$，其中 $\textit{positive}[i]$ 表示以下标 $i$ 结尾的乘积为正数的最长子数组长度，$\textit{negative}[i]$ 表示乘积为负数的最长子数组长度。

当 $i=0$ 时，以下标 $i$ 结尾的子数组的长度为 $1$，因此当 $\textit{nums}[0]>0$ 时 $\textit{positive}[0]=1$，当 $\textit{nums}[0]<0$ 时 $\textit{negative}[0]=1$。

当 $i>1$ 时，根据 $\textit{nums}[i]$ 的值计算 $\textit{positive}[i]$ 和 $\textit{negative}[i]$ 的值。

- 当 $\textit{nums}[i]>0$ 时，之前的乘积乘以 $\textit{nums}[i]$ 不会改变乘积的正负性。

  $\textit{positive}[i]$ 的计算为：

  $$
  \textit{positive}[i]=\textit{positive}[i-1]+1
  $$

  $\textit{negative}[i]$ 的计算为：

  $$
  \textit{negative}[i]=\begin{cases}
    \textit{negative}[i-1]+1, & \textit{negative}[i-1]>0 \\
    0, & \textit{negative}[i-1] = 0
  \end{cases}
  $$

  这是因为当 $\textit{negative}[i-1]=0$ 时，$\textit{negative}[i]$ 本身无法形成一个乘积为正数的子数组，所以要特殊判断。

- 当 $\textit{nums}[i]<0$ 时，之前的乘积乘以 $\textit{nums}[i]$ 会改变乘积的正负性。

  $\textit{positive}[i]$ 的计算为：

  $$
  \textit{positive}[i]=\begin{cases}
    \textit{negative}[i-1]+1, & \textit{negative}[i-1]>0 \\
    0, & \textit{negative}[i-1] = 0
  \end{cases}
  $$

  这是因为当 $\textit{negative}[i-1]=0$ 时，$\textit{positive}[i]$ 本身无法形成一个乘积为负数的子数组，所以要特殊判断。

  $\textit{negative}[i]$ 的计算为：

  $$
  \textit{negative}[i]=\textit{positive}[i-1]+1
  $$

- 当 $\textit{nums}[i]=0$ 时，以下标 $i$ 结尾的子数组的元素乘积一定为 $0$，因此有 $\textit{positive}[i]=0$ 和 $\textit{negative}[i]=0$。

在计算 $\textit{positive}$ 和 $\textit{negative}$ 两个数组的过程中维护乘积为正数的最长子数组长度，当遍历结束时，即可得到最长子数组长度。

```Java [sol11-Java]
class Solution {
    public int getMaxLen(int[] nums) {
        int length = nums.length;
        int[] positive = new int[length];
        int[] negative = new int[length];
        if (nums[0] > 0) {
            positive[0] = 1;
        } else if (nums[0] < 0) {
            negative[0] = 1;
        }
        int maxLength = positive[0];
        for (int i = 1; i < length; i++) {
            if (nums[i] > 0) {
                positive[i] = positive[i - 1] + 1;
                negative[i] = negative[i - 1] > 0 ? negative[i - 1] + 1 : 0;
            } else if (nums[i] < 0) {
                positive[i] = negative[i - 1] > 0 ? negative[i - 1] + 1 : 0;
                negative[i] = positive[i - 1] + 1;
            } else {
                positive[i] = 0;
                negative[i] = 0;
            }
            maxLength = Math.max(maxLength, positive[i]);
        }
        return maxLength;
    }
}
```

```C++ [sol11-C++]
class Solution {
public:
    int getMaxLen(vector<int>& nums) {
        int length = nums.size();
        vector<int> positive(length), negative(length);
        if (nums[0] > 0) {
            positive[0] = 1;
        }
        else if (nums[0] < 0) {
            negative[0] = 1;
        }
        int maxLength = positive[0];
        for (int i = 1; i < length; ++i) {
            if (nums[i] > 0) {
                positive[i] = positive[i - 1] + 1;
                negative[i] = (negative[i - 1] > 0 ? negative[i - 1] + 1 : 0);
            }
            else if (nums[i] < 0) {
                positive[i] = (negative[i - 1] > 0 ? negative[i - 1] + 1 : 0);
                negative[i] = positive[i - 1] + 1;
            }
            else {
                positive[i] = 0;
                negative[i] = 0;
            }
            maxLength = max(maxLength, positive[i]);
        }
        return maxLength;
    }
};
```

```Python [sol11-Python3]
class Solution:
    def getMaxLen(self, nums: List[int]) -> int:
        length = len(nums)
        positive, negative = [0] * length, [0] * length
        if nums[0] > 0:
            positive[0] = 1
        elif nums[0] < 0:
            negative[0] = 1
        
        maxLength = positive[0]
        for i in range(1, length):
            if nums[i] > 0:
                positive[i] = positive[i - 1] + 1
                negative[i] = (negative[i - 1] + 1 if negative[i - 1] > 0 else 0)
            elif nums[i] < 0:
                positive[i] = (negative[i - 1] + 1 if negative[i - 1] > 0 else 0)
                negative[i] = positive[i - 1] + 1
            else:
                positive[i] = negative[i] = 0
            maxLength = max(maxLength, positive[i])

        return maxLength
```

注意到 $\textit{positive}[i]$ 和 $\textit{negative}[i]$ 的值只与 $\textit{positive}[i-1]$ 和 $\textit{negative}[i-1]$ 有关，因此可以使用滚动数组优化空间。

```Java [sol12-Java]
class Solution {
    public int getMaxLen(int[] nums) {
        int length = nums.length;
        int positive = nums[0] > 0 ? 1 : 0;
        int negative = nums[0] < 0 ? 1 : 0;
        int maxLength = positive;
        for (int i = 1; i < length; i++) {
            if (nums[i] > 0) {
                positive++;
                negative = negative > 0 ? negative + 1 : 0;
            } else if (nums[i] < 0) {
                int newPositive = negative > 0 ? negative + 1 : 0;
                int newNegative = positive + 1;
                positive = newPositive;
                negative = newNegative;
            } else {
                positive = 0;
                negative = 0;
            }
            maxLength = Math.max(maxLength, positive);
        }
        return maxLength;
    }
}
```

```C++ [sol12-C++]
class Solution {
public:
    int getMaxLen(vector<int>& nums) {
        int length = nums.size();
        int positive = (nums[0] > 0);
        int negative = (nums[0] < 0);
        int maxLength = positive;
        for (int i = 1; i < length; ++i) {
            if (nums[i] > 0) {
                ++positive;
                negative = (negative > 0 ? negative + 1 : 0);
            }
            else if (nums[i] < 0) {
                int newPositive = negative > 0 ? negative + 1 : 0;
                int newNegative = positive + 1;
                tie(positive, negative) = {newPositive, newNegative};
            }
            else {
                positive = negative = 0;
            }
            maxLength = max(maxLength, positive);
        }
        return maxLength;
    }
};
```

```Python [sol12-Python3]
class Solution:
    def getMaxLen(self, nums: List[int]) -> int:
        length = len(nums)
        positive, negative = int(nums[0] > 0), int(nums[0] < 0)
        maxLength = positive

        for i in range(1, length):
            if nums[i] > 0:
                positive += 1
                negative = (negative + 1 if negative > 0 else 0)
            elif nums[i] < 0:
                newPositive = (negative + 1 if negative > 0 else 0)
                newNegative = positive + 1
                positive, negative = newPositive, newNegative
            else:
                positive = negative = 0
            maxLength = max(maxLength, positive)

        return maxLength
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组的长度。遍历数组一次，在遍历过程中维护最长子数组长度，对于数组中的每个元素的时间复杂度都是 $O(1)$，因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(1)$。通过滚动数组实现，只需要使用常数的额外空间。