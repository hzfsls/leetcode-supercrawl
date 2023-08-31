## [1558.得到目标数组的最少函数调用次数 中文官方题解](https://leetcode.cn/problems/minimum-numbers-of-function-calls-to-make-target-array/solutions/100000/de-dao-mu-biao-shu-zu-de-zui-shao-han-shu-diao-y-2)

#### 方法一：贪心

本题给定了两种操作：

1. 让序列中某个数加 $1$；

2. 让序列中所有数全体乘以 $2$。

询问你需要操作多少次，才能得到目标数组。

我们可以采用逆向思维，从目标数组转化为初始数组，支持两种操作：

1. 让序列中某个数减 $1$；

2. 让序列中所有数全体除以 $2$（要求序列中所有数均为偶数）。

询问你最少需要多少步才能让给定的数组中的全部元素变为 $0$。

我们贪心地考虑每一个数，显然我们应当尽可能多的执行第二种操作。因此我们只需要每次将序列中所有的奇数减 $1$，使其变为偶数，然后让整个偶数序列全体除以 $2$，直到所有数变为 $0$ 为止。

对于任意一个数，我们从二进制的角度考虑：

1. 如果它是奇数，那么它将被执行第一种操作。它的二进制表示中的末尾的 $1$ 将会变成 $0$；

2. 如果它是偶数，那么它将被执行第二种操作。它的二进制表示将会整体右移一位。

我们注意到对于任意一个数，它被执行第一种操作的次数等于它的二进制表示中的 $1$ 的数量。我们只需要统计序列中所有数的二进制表示中 $1$ 的数量之和，即可统计出第一种操作的数量。而第二种操作是全体数共同执行的，它的执行次数取决于序列中所有数的二进制表示的最高位数。我们只需要记录序列中最大值的二进制表示的位数，即可算出第二种操作的数量。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(vector<int>& nums) {
        int ret = 0, maxn = 0;
        for (auto num : nums) {
            maxn = max(maxn, num);
            while (num) {
                if (num & 1) {
                    ret++;
                }
                num >>= 1;
            }
        }
        if (maxn) {
            while (maxn) {
                ret++;
                maxn >>= 1;
            }
            ret--;
        }
        return ret;
    }
};
```

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(vector<int>& nums) {
        int ret = 0, maxn = 0;
        for (auto num : nums) {
            maxn = max(maxn, num);
            ret += __builtin_popcount(num);
        }
        if (maxn > 0) {
            ret += 31 - __builtin_clz(maxn);
        }
        return ret;
    }
};
```

```C [sol1-C]
int minOperations(int* nums, int numsSize) {
    int ret = 0, maxn = 0;
    for (int i = 0; i < numsSize; i++) {
        maxn = fmax(maxn, nums[i]);
        while (nums[i]) {
            if (nums[i] & 1) {
                ret++;
            }
            nums[i] >>= 1;
        }
    }
    if (maxn) {
        while (maxn) {
            ret++;
            maxn >>= 1;
        }
        ret--;
    }
    return ret;
}
```

```Java [sol1-Java]
class Solution {
    public int minOperations(int[] nums) {
        int ret = 0, maxn = 0;
        for (int num : nums) {
            maxn = Math.max(maxn, num);
            while (num != 0) {
                if ((num & 1) != 0) {
                    ret++;
                }
                num >>= 1;
            }
        }
        if (maxn != 0) {
            while (maxn != 0) {
                ret++;
                maxn >>= 1;
            }
            ret--;
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        maxn = max(nums)
        ret = 0
        for num in nums:
            while num > 0:
                if num & 1:
                    ret += 1
                num >>= 1
        if maxn > 0:
            while maxn > 0:
                ret += 1
                maxn >>= 1
            ret -= 1
        
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是数组中元素的二进制表示的最大位数，本题中这些元素均为 $32$ 位有符号整型数，因此 $m<32$。

- 空间复杂度：$O(1)$。