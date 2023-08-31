## [2460.对数组执行操作 中文官方题解](https://leetcode.cn/problems/apply-operations-to-an-array/solutions/100000/dui-shu-zu-zhi-xing-cao-zuo-by-leetcode-vz70b)

#### 方法一：直接模拟

**思路与算法**

根据题意要求，如果 $\textit{nums}[i] == \textit{nums}[i + 1]$ ，则需要进行以下变换：
+ $\textit{nums}[i] = 2 \times \textit{nums}[i]$；
+ $\textit{nums}[i + 1] = 0$；
  
在执行上述完操作后，将所有 $0$ 移动到数组的末尾。在遍历数组时，遇到前后相等的两个元素时直接进行变换，在遍历的同时进行原地交换，将所有非零的元素移动到数组的头部。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> applyOperations(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0, j = 0; i < n; i++) {
            if (i + 1 < n && nums[i] == nums[i + 1]) {
                nums[i] *= 2;
                nums[i + 1] = 0;
            }
            if (nums[i] != 0) {
                swap(nums[i], nums[j]);
                j++;
            }
        }
        return nums;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] applyOperations(int[] nums) {
        int n = nums.length;
        for (int i = 0, j = 0; i < n; i++) {
            if (i + 1 < n && nums[i] == nums[i + 1]) {
                nums[i] *= 2;
                nums[i + 1] = 0;
            }
            if (nums[i] != 0) {
                swap(nums, i, j);
                j++;
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

```Python [sol1-Python3]
class Solution:
    def applyOperations(self, nums: List[int]) -> List[int]:
        n = len(nums)
        j = 0
        for i in range(n):
            if i + 1 < n and nums[i] == nums[i + 1]:
                nums[i] *= 2
                nums[i + 1] = 0
            if nums[i] != 0:
                nums[i], nums[j] = nums[j], nums[i]
                j += 1
        return nums
```

```Go [sol1-Go]
func applyOperations(nums []int) []int {
    n := len(nums)
    j := 0
    for i := 0; i < n; i++ {
        if i+1 < n && nums[i] == nums[i+1] {
            nums[i] *= 2
            nums[i + 1] = 0
        }
        if nums[i] != 0 {
            nums[i], nums[j] = nums[j], nums[i]
            j++
        }
    }
    return nums
}
```

```JavaScript [sol1-JavaScript]
var applyOperations = function(nums) {
    let n = nums.length;
    let j = 0;
    for (let i = 0; i < n; i++) {
        if (i + 1 < n && nums[i] == nums[i + 1]) {
            nums[i] *= 2;
            nums[i + 1] = 0;
        }
        if (nums[i] != 0) {
            [nums[i], nums[j]] = [nums[j], nums[i]];
            j++;
        }
    }
    return nums;
};
```

```C# [sol1-C#]
public class Solution {
    public int[] ApplyOperations(int[] nums) {
        int n = nums.Length;
        for (int i = 0, j = 0; i < n; i++) {
            if (i + 1 < n && nums[i] == nums[i + 1]) {
                nums[i] *= 2;
                nums[i + 1] = 0;
            }
            if (nums[i] != 0) {
                Swap(nums, i, j);
                j++;
            }
        }
        return nums;
    }

    public void Swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}
```

```C [sol1-C]
int* applyOperations(int* nums, int numsSize, int* returnSize) {
    for (int i = 0, j = 0; i < numsSize; i++) {
        if (i + 1 < numsSize && nums[i] == nums[i + 1]) {
            nums[i] *= 2;
            nums[i + 1] = 0;
        }
        if (nums[i] != 0) {
            int val = nums[i];
            nums[i] = nums[j];
            nums[j] = val; 
            j++;
        }
    }
    *returnSize = numsSize;
    return nums;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示数组的长度。只需遍历一遍数组即可，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。直接在原数组上进行修改即可，不需要占用额外的空间。