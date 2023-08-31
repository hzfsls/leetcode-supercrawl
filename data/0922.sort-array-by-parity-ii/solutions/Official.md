## [922.按奇偶排序数组 II 中文官方题解](https://leetcode.cn/problems/sort-array-by-parity-ii/solutions/100000/an-qi-ou-pai-xu-shu-zu-ii-by-leetcode-solution)

#### 方法一：两次遍历

**思路和算法**

遍历一遍数组把所有的偶数放进 $\textit{ans}[0]$，$\textit{ans}[2]$，$\textit{ans}[4]$，以此类推。

再遍历一遍数组把所有的奇数依次放进 $\textit{ans}[1]$，$\textit{ans}[3]$，$\textit{ans}[5]$，以此类推。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sortArrayByParityII(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n);

        int i = 0;
        for (int x: nums) {
            if (x % 2 == 0) {
                ans[i] = x;
                i += 2;
            }
        }
        i = 1;
        for (int x: nums) {
            if (x % 2 == 1) {
                ans[i] = x;
                i += 2;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] sortArrayByParityII(int[] nums) {
        int n = nums.length;
        int[] ans = new int[n];

        int i = 0;
        for (int x : nums) {
            if (x % 2 == 0) {
                ans[i] = x;
                i += 2;
            }
        }
        i = 1;
        for (int x : nums) {
            if (x % 2 == 1) {
                ans[i] = x;
                i += 2;
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int* sortArrayByParityII(int* nums, int numsSize, int* returnSize) {
    int* ans = malloc(sizeof(int) * numsSize);
    int add = 0;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] % 2 == 0) {
            ans[add] = nums[i];
            add += 2;
        }
    }
    add = 1;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] % 2 == 1) {
            ans[add] = nums[i];
            add += 2;
        }
    }
    *returnSize = numsSize;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var sortArrayByParityII = function(nums) {
    const n  = nums.length;
    const ans = new Array(n);
    let i = 0;
    for (const x of nums) {
        if (!(x & 1)) {
            ans[i] = x;
            i += 2;
        } 
    }

    i = 1;
    for (const x of nums) {
        if (x & 1) {
            ans[i] = x;
            i += 2;
        }
    }

    return ans;
};
```

```Golang [sol1-Golang]
func sortArrayByParityII(nums []int) []int {
    ans := make([]int, len(nums))
    i := 0
    for _, v := range nums {
        if v%2 == 0 {
            ans[i] = v
            i += 2
        }
    }
    i = 1
    for _, v := range nums {
        if v%2 == 1 {
            ans[i] = v
            i += 2
        }
    }
    return ans
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 是数组 $\textit{nums}$ 的长度。

* 空间复杂度：$O(1)$。注意在这里我们不考虑输出数组的空间占用。

#### 方法二：双指针

**思路与算法**

如果原数组可以修改，则可以使用就地算法求解。

为数组的偶数下标部分和奇数下标部分分别维护指针 $i, j$。随后，在每一步中，如果 $\textit{nums}[i]$ 为奇数，则不断地向前移动 $j$（每次移动两个单位），直到遇见下一个偶数。此时，可以直接将 $\textit{nums}[i]$ 与 $\textit{nums}[j]$ 交换。我们不断进行这样的过程，最终能够将所有的整数放在正确的位置上。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> sortArrayByParityII(vector<int>& nums) {
        int n = nums.size();
        int j = 1;
        for (int i = 0; i < n; i += 2) {
            if (nums[i] % 2 == 1) {
                while (nums[j] % 2 == 1) {
                    j += 2;
                }
                swap(nums[i], nums[j]);
            }
        }   
        return nums;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] sortArrayByParityII(int[] nums) {
        int n = nums.length;
        int j = 1;
        for (int i = 0; i < n; i += 2) {
            if (nums[i] % 2 == 1) {
                while (nums[j] % 2 == 1) {
                    j += 2;
                }
                swap(nums, i, j);
            }
        }   
        return nums;
    }

    public void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}
```

```C [sol2-C]
void swap(int* a, int* b) {
    int t = *a;
    *a = *b, *b = t;
}

int* sortArrayByParityII(int* nums, int numsSize, int* returnSize) {
    int j = 1;
    for (int i = 0; i < numsSize; i += 2) {
        if (nums[i] % 2 == 1) {
            while (nums[j] % 2 == 1) {
                j += 2;
            }
            swap(nums + i, nums + j);
        }
    }
    *returnSize = numsSize;
    return nums;
}
```

```JavaScript [sol2-JavaScript]
const swap = (nums, i, j) => {
    const temp = nums[i];
    nums[i] = nums[j];
    nums[j] = temp;
};
var sortArrayByParityII = function(nums) {
    const n  = nums.length;
    let j = 1;
    for (let i = 0; i < n; i += 2) {
        if (nums[i] & 1) {
            while (nums[j] & 1) {
                j += 2;
            }
            swap(nums, i, j);
        }
    }   
    return nums;
};
```

```Golang [sol2-Golang]
func sortArrayByParityII(nums []int) []int {
    for i, j := 0, 1; i < len(nums); i += 2 {
        if nums[i]%2 == 1 {
            for nums[j]%2 == 1 {
                j += 2
            }
            nums[i], nums[j] = nums[j], nums[i]
        }
    }
    return nums
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 是数组 $\textit{nums}$ 的长度。

* 空间复杂度：$O(1)$。