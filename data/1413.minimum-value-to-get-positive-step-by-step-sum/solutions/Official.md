## [1413.逐步求和得到正数的最小值 中文官方题解](https://leetcode.cn/problems/minimum-value-to-get-positive-step-by-step-sum/solutions/100000/zhu-bu-qiu-he-de-dao-zheng-shu-de-zui-xi-vyrt)
#### 方法一：贪心

**思路**

要保证所有的累加和 $\textit{accSum}$ 满足 $\textit{accSum} + \textit{startValue} \ge 1$，只需保证累加和的最小值 $\textit{accSumMin}$ 满足 $\textit{accSumMin} + \textit{startValue} \ge 1$，那么 $\textit{startValue}$ 的最小值即可取 $-\textit{accSumMin} + 1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minStartValue(self, nums: List[int]) -> int:
        accSum, accSumMin = 0, 0
        for num in nums:
            accSum += num
            accSumMin = min(accSumMin, accSum)
        return -accSumMin + 1
```

```Java [sol1-Java]
class Solution {
    public int minStartValue(int[] nums) {
        int accSum = 0, accSumMin = 0;
        for (int num : nums) {
            accSum += num;
            accSumMin = Math.min(accSumMin, accSum);
        }
        return -accSumMin + 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinStartValue(int[] nums) {
        int accSum = 0, accSumMin = 0;
        foreach (int num in nums) {
            accSum += num;
            accSumMin = Math.Min(accSumMin, accSum);
        }
        return -accSumMin + 1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minStartValue(vector<int>& nums) {
        int accSum = 0, accSumMin = 0;
        for (int num : nums) {
            accSum += num;
            accSumMin = min(accSumMin, accSum);
        }
        return -accSumMin + 1;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
int minStartValue(int* nums, int numsSize){
    int accSum = 0, accSumMin = 0;
    for (int i = 0; i < numsSize; i++) {
        accSum += nums[i];
        accSumMin = MIN(accSumMin, accSum);
    }
    return -accSumMin + 1;
}
```

```go [sol1-Golang]
func minStartValue(nums []int) int {
    accSum, accSumMin := 0, 0
    for _, num := range nums {
        accSum += num
        accSumMin = min(accSumMin, accSum)
    }
    return -accSumMin + 1
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var minStartValue = function(nums) {
    let accSum = 0, accSumMin = 0;
    for (const num of nums) {
        accSum += num;
        accSumMin = Math.min(accSumMin, accSum);
    }
    return -accSumMin + 1;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。只需要遍历数组一次。

- 空间复杂度：$O(1)$。只需要使用常量空间。

#### 方法二：二分查找

**思路**

当 $\textit{nums}$ 所有元素均为非负数时，可以直接返回 $1$。当有负数时，可以

当某个数字满足 $\textit{startValue}$ 的要求时，比它大的数字肯定也都满足，比它小的数字则不一定能满足，因此 $\textit{startValue}$ 的性质具有单调性，此题可以用二分查找来解决。二分查找的左起始点为 $1$，右起始点可以设为 $\textit{nums}$ 的最小值的相反数乘上长度后再加 $1$，这样可以保证右端点一定满足 $\textit{startValue}$ 的要求。

判断某个数字是否满足 $\textit{startValue}$ 的要求时，可以将 $\textit{nums}$ 的数字逐步加到这个数字上，判断是否一直为正即可。
**代码**

```Python [sol2-Python3]
class Solution:
    def minStartValue(self, nums: List[int]) -> int:
        m = min(nums)
        if m >= 0:
            return 1
        left, right = 1, -m * len(nums) + 1
        while left < right:
            medium = (left + right) // 2
            if self.valid(medium, nums):
                right = medium
            else:
                left = medium + 1
        return left
    
    def valid(self, startValue: int, nums: List[int]) -> bool:
        for num in nums:
            startValue += num
            if startValue <= 0:
                return False
        return True
```

```Java [sol2-Java]
class Solution {
    public int minStartValue(int[] nums) {
        int m = Arrays.stream(nums).min().getAsInt();
        if (m >= 0) {
            return 1;
        }
        int left = 1, right = -m * nums.length + 1;
        while (left < right) {
            int medium = (left + right) / 2;
            if (valid(medium, nums)) {
                right = medium;
            } else {
                left = medium + 1;
            }
        }
        return left;
    }

    public boolean valid(int startValue, int[] nums) {
        for (int num : nums) {
            startValue += num;
            if (startValue <= 0) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinStartValue(int[] nums) {
        int m = nums.Min();
        if (m >= 0) {
            return 1;
        }
        int left = 1, right = -m * nums.Length + 1;
        while (left < right) {
            int medium = (left + right) / 2;
            if (Valid(medium, nums)) {
                right = medium;
            } else {
                left = medium + 1;
            }
        }
        return left;
    }

    public bool Valid(int startValue, int[] nums) {
        foreach (int num in nums) {
            startValue += num;
            if (startValue <= 0) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int minStartValue(vector<int>& nums) {
        int m = *min_element(nums.begin(), nums.end());
        if (m >= 0) {
            return 1;
        }
        int left = 1, right = -m * nums.size() + 1;
        while (left < right) {
            int medium = (left + right) / 2;
            if (valid(medium, nums)) {
                right = medium;
            } else {
                left = medium + 1;
            }
        }
        return left;
    }

    bool valid(int startValue, vector<int>& nums) {
        for (int num : nums) {
            startValue += num;
            if (startValue <= 0) {
                return false;
            }
        }
        return true;
    }
};
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

bool valid(int startValue, const int* nums, int numsSize) {
    for (int i = 0; i < numsSize; i++) {
        startValue += nums[i];
        if (startValue <= 0) {
            return false;
        }
    }
    return true;
}

int minStartValue(int* nums, int numsSize){
    int m = nums[0];
    for (int i = 1; i < numsSize; i++) {
        m = MIN(m, nums[i]);
    }
    if (m >= 0) {
        return 1;
    }
    int left = 1, right = -m * numsSize + 1;
    while (left < right) {
        int medium = (left + right) / 2;
        if (valid(medium, nums, numsSize)) {
            right = medium;
        } else {
            left = medium + 1;
        }
    }
    return left;
}
```

```go [sol2-Golang]
func minStartValue(nums []int) int {
    m := nums[0]
    for _, num := range nums[1:] {
        m = min(m, num)
    }
    return 1 + sort.Search(-m*len(nums), func(startValue int) bool {
        startValue++
        for _, num := range nums {
            startValue += num
            if startValue <= 0 {
                return false
            }
        }
        return true
    })
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
var minStartValue = function(nums) {
    const m = _.min(nums);
    if (m >= 0) {
        return 1;
    }
    let left = 1, right = -m * nums.length + 1;
    while (left < right) {
        const medium = Math.floor((left + right) / 2);
        if (valid(medium, nums)) {
            right = medium;
        } else {
            left = medium + 1;
        }
    }
    return left;
};

const valid = (startValue, nums) => {
    for (const num of nums) {
        startValue += num;
        if (startValue <= 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log (mn))$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是数组最小值的绝对值。二分查找的次数是 $O(\log (mn))$，每次消耗 $O(n)$。

- 空间复杂度：$O(1)$。只需要使用常量空间。