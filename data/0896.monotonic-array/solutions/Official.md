## [896.单调数列 中文官方题解](https://leetcode.cn/problems/monotonic-array/solutions/100000/dan-diao-shu-lie-by-leetcode-solution-ysex)
#### 方法一：两次遍历

遍历两次数组，分别判断其是否为单调递增或单调递减。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isMonotonic(vector<int>& nums) {
        return is_sorted(nums.begin(), nums.end()) || is_sorted(nums.rbegin(), nums.rend());
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isMonotonic(int[] nums) {
        return isSorted(nums, true) || isSorted(nums, false);
    }

    public boolean isSorted(int[] nums, boolean increasing) {
        int n = nums.length;
        if (increasing) {
            for (int i = 0; i < n - 1; ++i) {
                if (nums[i] > nums[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = 0; i < n - 1; ++i) {
                if (nums[i] < nums[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```go [sol1-Golang]
func isMonotonic(nums []int) bool {
    return sort.IntsAreSorted(nums) || sort.IsSorted(sort.Reverse(sort.IntSlice(nums)))
}
```

```JavaScript [sol1-JavaScript]
var isMonotonic = function(nums) {
    return isSorted(nums) || isSorted(nums.reverse());
};

function isSorted(nums) {
    return nums.slice(1).every((item, i) => nums[i] <= item)
}
```

```C [sol1-C]
bool isSorted(int* nums, int numsSize, bool increasing) {
    if (increasing) {
        for (int i = 0; i < numsSize - 1; ++i) {
            if (nums[i] > nums[i + 1]) {
                return false;
            }
        }
    } else {
        for (int i = 0; i < numsSize - 1; ++i) {
            if (nums[i] < nums[i + 1]) {
                return false;
            }
        }
    }
    return true;
}

bool isMonotonic(int* nums, int numsSize) {
    return isSorted(nums, numsSize, true) || isSorted(nums, numsSize, false);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。

#### 方法二：一次遍历

遍历数组 $\textit{nums}$，若既遇到了 $\textit{nums}[i]>\textit{nums}[i+1]$ 又遇到了 $\textit{nums}[i']<\textit{nums}[i'+1]$，则说明 $\textit{nums}$ 既不是单调递增的，也不是单调递减的。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool isMonotonic(vector<int>& nums) {
        bool inc = true, dec = true;
        int n = nums.size();
        for (int i = 0; i < n - 1; ++i) {
            if (nums[i] > nums[i + 1]) {
                inc = false;
            }
            if (nums[i] < nums[i + 1]) {
                dec = false;
            }
        }
        return inc || dec;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isMonotonic(int[] nums) {
        boolean inc = true, dec = true;
        int n = nums.length;
        for (int i = 0; i < n - 1; ++i) {
            if (nums[i] > nums[i + 1]) {
                inc = false;
            }
            if (nums[i] < nums[i + 1]) {
                dec = false;
            }
        }
        return inc || dec;
    }
}
```

```go [sol2-Golang]
func isMonotonic(nums []int) bool {
    inc, dec := true, true
    for i := 0; i < len(nums)-1; i++ {
        if nums[i] > nums[i+1] {
            inc = false
        }
        if nums[i] < nums[i+1] {
            dec = false
        }
    }
    return inc || dec
}
```

```JavaScript [sol2-JavaScript]
var isMonotonic = function(nums) {
    let inc = true, dec = true;
    const n = nums.length;
    for (let i = 0; i < n - 1; ++i) {
        if (nums[i] > nums[i + 1]) {
            inc = false;
        }
        if (nums[i] < nums[i + 1]) {
            dec = false;
        }
    }
    return inc || dec;
};
```

```C [sol2-C]
bool isMonotonic(int* nums, int numsSize) {
    bool inc = true, dec = true;
    int n = numsSize;
    for (int i = 0; i < n - 1; ++i) {
        if (nums[i] > nums[i + 1]) {
            inc = false;
        }
        if (nums[i] < nums[i + 1]) {
            dec = false;
        }
    }
    return inc || dec;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。