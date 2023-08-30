#### 方法一：排序

**思路与算法**

题目给定字符串 $\textit{nums}$，我们需要找到两个在数组不同位置的数减一后的乘积最大。因为 $\textit{nums}$ 中的每一个元素都为正整数，所以为了使减一后的乘积最大，我们选择数组中的两个最大的元素即可。那么我们先对数组进行排序，然后选择两个最大的元素即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        nums.sort()
        return (nums[-1] - 1) * (nums[-2] - 1)
```

```C++ [sol1-C++]
class Solution {
public:
    int maxProduct(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        return (nums.back() - 1) * (nums[nums.size() - 2] - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxProduct(int[] nums) {
        Arrays.sort(nums);
        return (nums[nums.length - 1] - 1) * (nums[nums.length - 2] - 1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxProduct(int[] nums) {
        Array.Sort(nums);
        return (nums[nums.Length - 1] - 1) * (nums[nums.Length - 2] - 1);
    }
}
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int maxProduct(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    return (nums[numsSize - 1] - 1) * (nums[numsSize - 2] - 1);
}
```

```JavaScript [sol1-JavaScript]
var maxProduct = function(nums) {
    nums.sort((a, b) => a - b);
    console.log(nums)
    return (nums[nums.length - 1] - 1) * (nums[nums.length - 2] - 1);
};
```

```go [sol1-Golang]
func maxProduct(nums []int) int {
    sort.Ints(nums)
    return (nums[len(nums)-1] - 1) * (nums[len(nums)-2] - 1)
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，主要为数组排序的时间复杂度。
- 空间复杂度：$O(1)$，仅使用常量空间。

#### 方法二：一次遍历，维护最大和次大值

**思路与算法**

因为我们只需要得到数组中两个最大的元素，我们可以在从左到右遍历的过程中维护两个变量 $a,b$ 来表示遍历过程中的最大和次大元素，那么一次遍历就可以得到数组中两个最大的元素。

**代码**

```Python [sol2-Python3]
class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        a, b = nums[0], nums[1]
        if a < b:
            a, b = b, a
        for i in range(2, len(nums)):
            num = nums[i]
            if num > a:
                a, b = num, a
            elif num > b:
                b = num
        return (a - 1) * (b - 1)
```

```C++ [sol2-C++]
class Solution {
public:
    int maxProduct(vector<int>& nums) {
        int a = nums[0], b = nums[1];
        if (a < b) {
            swap(a, b);
        }
        for (int i = 2; i < nums.size(); i++) {
            if (nums[i] > a) {
                b = a;
                a = nums[i];
            } else if (nums[i] > b) {
                b = nums[i];
            }
        }
        return (a - 1) * (b - 1);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxProduct(int[] nums) {
        int a = nums[0], b = nums[1];
        if (a < b) {
            int temp = a;
            a = b;
            b = temp;
        }
        for (int i = 2; i < nums.length; i++) {
            if (nums[i] > a) {
                b = a;
                a = nums[i];
            } else if (nums[i] > b) {
                b = nums[i];
            }
        }
        return (a - 1) * (b - 1);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxProduct(int[] nums) {
        int a = nums[0], b = nums[1];
        if (a < b) {
            int temp = a;
            a = b;
            b = temp;
        }
        for (int i = 2; i < nums.Length; i++) {
            if (nums[i] > a) {
                b = a;
                a = nums[i];
            } else if (nums[i] > b) {
                b = nums[i];
            }
        }
        return (a - 1) * (b - 1);
    }
}
```

```C [sol2-C]
int maxProduct(int* nums, int numsSize){
    int a = nums[0], b = nums[1];
    if (a < b) {
        int c = a;
        a = b;
        b = c;
    }
    for (int i = 2; i < numsSize; i++) {
        if (nums[i] > a) {
            b = a;
            a = nums[i];
        } else if (nums[i] > b) {
            b = nums[i];
        }
    }
    return (a - 1) * (b - 1);
}
```

```JavaScript [sol2-JavaScript]
var maxProduct = function(nums) {
    let a = nums[0], b = nums[1];
    if (a < b) {
        const temp = a;
        a = b;
        b = temp;
    }
    for (let i = 2; i < nums.length; i++) {
        if (nums[i] > a) {
            b = a;
            a = nums[i];
        } else if (nums[i] > b) {
            b = nums[i];
        }
    }
    return (a - 1) * (b - 1);
};
```

```go [sol2-Golang]
func maxProduct(nums []int) int {
    a, b := nums[0], nums[1]
    if a < b {
        a, b = b, a
    }
    for _, num := range nums[2:] {
        if num > a {
            a, b = num, a
        } else if num > b {
            b = num
        }
    }
    return (a - 1) * (b - 1)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，需要遍历一遍数组。
- 空间复杂度：$O(1)$，仅使用常量空间。