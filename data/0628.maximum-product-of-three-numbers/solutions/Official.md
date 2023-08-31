## [628.三个数的最大乘积 中文官方题解](https://leetcode.cn/problems/maximum-product-of-three-numbers/solutions/100000/san-ge-shu-de-zui-da-cheng-ji-by-leetcod-t9sb)
#### 方法一：排序

首先将数组排序。

如果数组中全是非负数，则排序后最大的三个数相乘即为最大乘积；如果全是非正数，则最大的三个数相乘同样也为最大乘积。

如果数组中有正数有负数，则最大乘积既可能是三个最大正数的乘积，也可能是两个最小负数（即绝对值最大）与最大正数的乘积。

综上，我们在给数组排序后，分别求出三个最大正数的乘积，以及两个最小负数与最大正数的乘积，二者之间的最大值即为所求答案。

```C++ [sol1-C++]
class Solution {
public:
    int maximumProduct(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int n = nums.size();
        return max(nums[0] * nums[1] * nums[n - 1], nums[n - 3] * nums[n - 2] * nums[n - 1]);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumProduct(int[] nums) {
        Arrays.sort(nums);
        int n = nums.length;
        return Math.max(nums[0] * nums[1] * nums[n - 1], nums[n - 3] * nums[n - 2] * nums[n - 1]);
    }
}
```

```go [sol1-Golang]
func maximumProduct(nums []int) int {
    sort.Ints(nums)
    n := len(nums)
    return max(nums[0]*nums[1]*nums[n-1], nums[n-3]*nums[n-2]*nums[n-1])
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int cmp(int* a, int* b) {
    return *a - *b;
}

int maximumProduct(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    return fmax(nums[0] * nums[1] * nums[numsSize - 1], nums[numsSize - 3] * nums[numsSize - 2] * nums[numsSize - 1]);
}
```

```JavaScript [sol1-JavaScript]
var maximumProduct = function(nums) {
    nums.sort((a, b) => a - b);
    const n = nums.length;
    return Math.max(nums[0] * nums[1] * nums[n - 1], nums[n - 1] * nums[n - 2] * nums[n - 3]);
};
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组长度。排序需要 $O(N\log N)$ 的时间。

- 空间复杂度：$O(\log N)$，主要为排序的空间开销。

#### 方法二：线性扫描

在方法一中，我们实际上只要求出数组中最大的三个数以及最小的两个数，因此我们可以不用排序，用线性扫描直接得出这五个数。

```C++ [sol2-C++]
class Solution {
public:
    int maximumProduct(vector<int>& nums) {
        // 最小的和第二小的
        int min1 = INT_MAX, min2 = INT_MAX;
        // 最大的、第二大的和第三大的
        int max1 = INT_MIN, max2 = INT_MIN, max3 = INT_MIN;

        for (int x: nums) {
            if (x < min1) {
                min2 = min1;
                min1 = x;
            } else if (x < min2) {
                min2 = x;
            }

            if (x > max1) {
                max3 = max2;
                max2 = max1;
                max1 = x;
            } else if (x > max2) {
                max3 = max2;
                max2 = x;
            } else if (x > max3) {
                max3 = x;
            }
        }

        return max(min1 * min2 * max1, max1 * max2 * max3);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximumProduct(int[] nums) {
        // 最小的和第二小的
        int min1 = Integer.MAX_VALUE, min2 = Integer.MAX_VALUE;
        // 最大的、第二大的和第三大的
        int max1 = Integer.MIN_VALUE, max2 = Integer.MIN_VALUE, max3 = Integer.MIN_VALUE;

        for (int x : nums) {
            if (x < min1) {
                min2 = min1;
                min1 = x;
            } else if (x < min2) {
                min2 = x;
            }

            if (x > max1) {
                max3 = max2;
                max2 = max1;
                max1 = x;
            } else if (x > max2) {
                max3 = max2;
                max2 = x;
            } else if (x > max3) {
                max3 = x;
            }
        }

        return Math.max(min1 * min2 * max1, max1 * max2 * max3);
    }
}
```

```go [sol2-Golang]
func maximumProduct(nums []int) int {
    // 最小的和第二小的
    min1, min2 := math.MaxInt64, math.MaxInt64
    // 最大的、第二大的和第三大的
    max1, max2, max3 := math.MinInt64, math.MinInt64, math.MinInt64

    for _, x := range nums {
        if x < min1 {
            min2 = min1
            min1 = x
        } else if x < min2 {
            min2 = x
        }

        if x > max1 {
            max3 = max2
            max2 = max1
            max1 = x
        } else if x > max2 {
            max3 = max2
            max2 = x
        } else if x > max3 {
            max3 = x
        }
    }

    return max(min1*min2*max1, max1*max2*max3)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int maximumProduct(int* nums, int numsSize) {
    // 最小的和第二小的
    int min1 = INT_MAX, min2 = INT_MAX;
    // 最大的、第二大的和第三大的
    int max1 = INT_MIN, max2 = INT_MIN, max3 = INT_MIN;

    for (int i = 0; i < numsSize; i++) {
        int x = nums[i];
        if (x < min1) {
            min2 = min1;
            min1 = x;
        } else if (x < min2) {
            min2 = x;
        }

        if (x > max1) {
            max3 = max2;
            max2 = max1;
            max1 = x;
        } else if (x > max2) {
            max3 = max2;
            max2 = x;
        } else if (x > max3) {
            max3 = x;
        }
    }

    return fmax(min1 * min2 * max1, max1 * max2 * max3);
}
```

```JavaScript [sol2-JavaScript]
var maximumProduct = function(nums) {
    // 最小的和第二小的
    let min1 = Number.MAX_SAFE_INTEGER, min2 = Number.MAX_SAFE_INTEGER;
    // 最大的、第二大的和第三大的
    let max1 = -Number.MAX_SAFE_INTEGER, max2 = -Number.MAX_SAFE_INTEGER, max3 = -Number.MAX_SAFE_INTEGER;

    for (const x of nums) {
        if (x < min1) {
            min2 = min1;
            min1 = x;
        } else if (x < min2) {
            min2 = x;
        }

        if (x > max1) {
            max3 = max2;
            max2 = max1;
            max1 = x;
        } else if (x > max2) {
            max3 = max2;
            max2 = x;
        } else if (x > max3) {
            max3 = x;
        }
    }

    return Math.max(min1 * min2 * max1, max1 * max2 * max3);
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为数组长度。我们仅需遍历数组一次。

- 空间复杂度：$O(1)$。