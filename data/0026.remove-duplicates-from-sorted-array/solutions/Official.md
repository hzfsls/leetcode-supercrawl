## [26.删除有序数组中的重复项 中文官方题解](https://leetcode.cn/problems/remove-duplicates-from-sorted-array/solutions/100000/shan-chu-pai-xu-shu-zu-zhong-de-zhong-fu-tudo)

### 📺 视频题解  
![26. 删除排序数组中的重复项.mp4](539b4994-eb74-4041-ab3e-e949603c8d15)

### 📖 文字题解

#### 方法一：双指针

这道题目的要求是：对给定的有序数组 $\textit{nums}$ 删除重复元素，在删除重复元素之后，每个元素只出现一次，并返回新的长度，上述操作必须通过原地修改数组的方法，使用 $O(1)$ 的空间复杂度完成。

由于给定的数组 $\textit{nums}$ 是有序的，因此对于任意 $i<j$，如果 $\textit{nums}[i]=\textit{nums}[j]$，则对任意 $i \le k \le j$，必有 $\textit{nums}[i]=\textit{nums}[k]=\textit{nums}[j]$，即相等的元素在数组中的下标一定是连续的。利用数组有序的特点，可以通过双指针的方法删除重复元素。

如果数组 $\textit{nums}$ 的长度为 $0$，则数组不包含任何元素，因此返回 $0$。

当数组 $\textit{nums}$ 的长度大于 $0$ 时，数组中至少包含一个元素，在删除重复元素之后也至少剩下一个元素，因此 $\textit{nums}[0]$ 保持原状即可，从下标 $1$ 开始删除重复元素。

定义两个指针 $\textit{fast}$ 和 $\textit{slow}$ 分别为快指针和慢指针，快指针表示遍历数组到达的下标位置，慢指针表示下一个不同元素要填入的下标位置，初始时两个指针都指向下标 $1$。

假设数组 $\textit{nums}$ 的长度为 $n$。将快指针 $\textit{fast}$ 依次遍历从 $1$ 到 $n-1$ 的每个位置，对于每个位置，如果 $\textit{nums}[\textit{fast}] \ne \textit{nums}[\textit{fast}-1]$，说明 $\textit{nums}[\textit{fast}]$ 和之前的元素都不同，因此将 $\textit{nums}[\textit{fast}]$ 的值复制到 $\textit{nums}[\textit{slow}]$，然后将 $\textit{slow}$ 的值加 $1$，即指向下一个位置。

遍历结束之后，从 $\textit{nums}[0]$ 到 $\textit{nums}[\textit{slow}-1]$ 的每个元素都不相同且包含原数组中的每个不同的元素，因此新的长度即为 $\textit{slow}$，返回 $\textit{slow}$ 即可。

<![fig1](https://assets.leetcode-cn.com/solution-static/26/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/26/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/26/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/26/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/26/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/26/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/26/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/26/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/26/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/26/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/26/11.png)>

```Java [sol1-Java]
class Solution {
    public int removeDuplicates(int[] nums) {
        int n = nums.length;
        if (n == 0) {
            return 0;
        }
        int fast = 1, slow = 1;
        while (fast < n) {
            if (nums[fast] != nums[fast - 1]) {
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
    if (n === 0) {
        return 0;
    }
    let fast = 1, slow = 1;
    while (fast < n) {
        if (nums[fast] !== nums[fast - 1]) {
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
    if n == 0 {
        return 0
    }
    slow := 1
    for fast := 1; fast < n; fast++ {
        if nums[fast] != nums[fast-1] {
            nums[slow] = nums[fast]
            slow++
        }
    }
    return slow
}
```

```Python [sol1-Python3]
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        if not nums:
            return 0
        
        n = len(nums)
        fast = slow = 1
        while fast < n:
            if nums[fast] != nums[fast - 1]:
                nums[slow] = nums[fast]
                slow += 1
            fast += 1
        
        return slow
```

```C++ [sol1-C++]
class Solution {
public:
    int removeDuplicates(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) {
            return 0;
        }
        int fast = 1, slow = 1;
        while (fast < n) {
            if (nums[fast] != nums[fast - 1]) {
                nums[slow] = nums[fast];
                ++slow;
            }
            ++fast;
        }
        return slow;
    }
};
```

```C [sol1-C]
int removeDuplicates(int* nums, int numsSize) {
    if (numsSize == 0) {
        return 0;
    }
    int fast = 1, slow = 1;
    while (fast < numsSize) {
        if (nums[fast] != nums[fast - 1]) {
            nums[slow] = nums[fast];
            ++slow;
        }
        ++fast;
    }
    return slow;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组的长度。快指针和慢指针最多各移动 $n$ 次。

- 空间复杂度：$O(1)$。只需要使用常数的额外空间。