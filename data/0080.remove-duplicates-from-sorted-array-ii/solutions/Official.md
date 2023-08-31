## [80.删除有序数组中的重复项 II 中文官方题解](https://leetcode.cn/problems/remove-duplicates-from-sorted-array-ii/solutions/100000/shan-chu-pai-xu-shu-zu-zhong-de-zhong-fu-yec2)
#### 方法一：双指针

**思路及解法**

在阅读本题前，读者们可以先尝试解决「[26. 删除有序数组中的重复项](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array)」。

因为给定数组是有序的，所以相同元素必然连续。我们可以使用双指针解决本题，遍历数组检查每一个元素是否应该被保留，如果应该被保留，就将其移动到指定位置。具体地，我们定义两个指针 $\textit{slow}$ 和 $\textit{fast}$ 分别为慢指针和快指针，其中慢指针表示处理出的数组的长度，快指针表示已经检查过的数组的长度，即 $\textit{nums}[\textit{fast}]$ 表示待检查的第一个元素，$\textit{nums}[\textit{slow} - 1]$ 为上一个应该被保留的元素所移动到的指定位置。

因为本题要求相同元素最多出现两次而非一次，所以我们需要检查上上个应该被保留的元素 $\textit{nums}[\textit{slow} - 2]$ 是否和当前待检查元素 $\textit{nums}[\textit{fast}]$ 相同。当且仅当 $\textit{nums}[\textit{slow} - 2] = \textit{nums}[\textit{fast}]$ 时，当前待检查元素 $\textit{nums}[\textit{fast}]$ 不应该被保留（因为此时必然有 $\textit{nums}[\textit{slow} - 2] = nums[\textit{slow} - 1] = \textit{nums}[\textit{fast}]$）。最后，$\textit{slow}$ 即为处理好的数组的长度。

特别地，数组的前两个数必然可以被保留，因此对于长度不超过 $2$ 的数组，我们无需进行任何处理，对于长度超过 $2$ 的数组，我们直接将双指针的初始值设为 $2$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int removeDuplicates(vector<int>& nums) {
        int n = nums.size();
        if (n <= 2) {
            return n;
        }
        int slow = 2, fast = 2;
        while (fast < n) {
            if (nums[slow - 2] != nums[fast]) {
                nums[slow] = nums[fast];
                ++slow;
            }
            ++fast;
        }
        return slow;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int removeDuplicates(int[] nums) {
        int n = nums.length;
        if (n <= 2) {
            return n;
        }
        int slow = 2, fast = 2;
        while (fast < n) {
            if (nums[slow - 2] != nums[fast]) {
                nums[slow] = nums[fast];
                ++slow;
            }
            ++fast;
        }
        return slow;
    }
}
```

```JavaScript [sol1-JavaScript]
var removeDuplicates = function(nums) {
    const n = nums.length;
    if (n <= 2) {
        return n;
    }
    let slow = 2, fast = 2;
    while (fast < n) {
        if (nums[slow - 2] != nums[fast]) {
            nums[slow] = nums[fast];
            ++slow;
        }
        ++fast;
    }
    return slow;
};
```

```go [sol1-Golang]
func removeDuplicates(nums []int) int {
    n := len(nums)
    if n <= 2 {
        return n
    }
    slow, fast := 2, 2
    for fast < n {
        if nums[slow-2] != nums[fast] {
            nums[slow] = nums[fast]
            slow++
        }
        fast++
    }
    return slow
}
```

```C [sol1-C]
int removeDuplicates(int* nums, int numsSize) {
    if (numsSize <= 2) {
        return numsSize;
    }
    int slow = 2, fast = 2;
    while (fast < numsSize) {
        if (nums[slow - 2] != nums[fast]) {
            nums[slow] = nums[fast];
            ++slow;
        }
        ++fast;
    }
    return slow;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组的长度。我们最多遍历该数组一次。

- 空间复杂度：$O(1)$。我们只需要常数的空间存储若干变量。