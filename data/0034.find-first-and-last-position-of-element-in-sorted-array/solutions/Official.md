### 📺 视频题解  
![...中查找元素的第一个和最后一个位置.mp4](213522fb-128b-4c73-bb88-efd20280c04d)

### 📖 文字题解
#### 方法一：二分查找

直观的思路肯定是从前往后遍历一遍。用两个变量记录第一次和最后一次遇见 $\textit{target}$ 的下标，但这个方法的时间复杂度为 $O(n)$，没有利用到数组**升序排列**的条件。

由于数组已经排序，因此整个数组是**单调递增**的，我们可以利用二分法来加速查找的过程。

考虑 $\textit{target}$ 开始和结束位置，其实我们要找的就是数组中「第一个等于 $\textit{target}$ 的位置」（记为 $\textit{leftIdx}$）和「第一个大于 $\textit{target}$ 的位置**减一**」（记为 $\textit{rightIdx}$）。

二分查找中，寻找 $\textit{leftIdx}$ 即为在数组中寻找第一个**大于等于** $\textit{target}$ 的下标，寻找 $\textit{rightIdx}$ 即为在数组中寻找第一个**大于** $\textit{target}$ 的下标，然后将下标减一。两者的判断条件不同，为了代码的复用，我们定义 `binarySearch(nums, target, lower)` 表示在 $\textit{nums}$ 数组中二分查找 $\textit{target}$ 的位置，如果 $\textit{lower}$ 为 $\rm true$，则查找第一个**大于等于** $\textit{target}$ 的下标，否则查找第一个**大于** $\textit{target}$ 的下标。

最后，因为 $\textit{target}$ 可能不存在数组中，因此我们需要重新校验我们得到的两个下标 $\textit{leftIdx}$ 和 $\textit{rightIdx}$，看是否符合条件，如果符合条件就返回 $[\textit{leftIdx},\textit{rightIdx}]$，不符合就返回 $[-1,-1]$。

<![ppt1](https://assets.leetcode-cn.com/solution-static/34/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/34/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/34/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/34/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/34/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/34/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/34/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/34/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/34/9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/34/10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/34/11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/34/12.png),![ppt13](https://assets.leetcode-cn.com/solution-static/34/13.png),![ppt14](https://assets.leetcode-cn.com/solution-static/34/14.png)>

```C++ [sol1-C++]
class Solution { 
public:
    int binarySearch(vector<int>& nums, int target, bool lower) {
        int left = 0, right = (int)nums.size() - 1, ans = (int)nums.size();
        while (left <= right) {
            int mid = (left + right) / 2;
            if (nums[mid] > target || (lower && nums[mid] >= target)) {
                right = mid - 1;
                ans = mid;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }

    vector<int> searchRange(vector<int>& nums, int target) {
        int leftIdx = binarySearch(nums, target, true);
        int rightIdx = binarySearch(nums, target, false) - 1;
        if (leftIdx <= rightIdx && rightIdx < nums.size() && nums[leftIdx] == target && nums[rightIdx] == target) {
            return vector<int>{leftIdx, rightIdx};
        } 
        return vector<int>{-1, -1};
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int leftIdx = binarySearch(nums, target, true);
        int rightIdx = binarySearch(nums, target, false) - 1;
        if (leftIdx <= rightIdx && rightIdx < nums.length && nums[leftIdx] == target && nums[rightIdx] == target) {
            return new int[]{leftIdx, rightIdx};
        } 
        return new int[]{-1, -1};
    }

    public int binarySearch(int[] nums, int target, boolean lower) {
        int left = 0, right = nums.length - 1, ans = nums.length;
        while (left <= right) {
            int mid = (left + right) / 2;
            if (nums[mid] > target || (lower && nums[mid] >= target)) {
                right = mid - 1;
                ans = mid;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
const binarySearch = (nums, target, lower) => {
    let left = 0, right = nums.length - 1, ans = nums.length;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (nums[mid] > target || (lower && nums[mid] >= target)) {
            right = mid - 1;
            ans = mid;
        } else {
            left = mid + 1;
        }
    }
    return ans;
}

var searchRange = function(nums, target) {
    let ans = [-1, -1];
    const leftIdx = binarySearch(nums, target, true);
    const rightIdx = binarySearch(nums, target, false) - 1;
    if (leftIdx <= rightIdx && rightIdx < nums.length && nums[leftIdx] === target && nums[rightIdx] === target) {
        ans = [leftIdx, rightIdx];
    } 
    return ans;
};
```

```Golang [sol1-Golang]
func searchRange(nums []int, target int) []int {
    leftmost := sort.SearchInts(nums, target)
    if leftmost == len(nums) || nums[leftmost] != target {
        return []int{-1, -1}
    }
    rightmost := sort.SearchInts(nums, target + 1) - 1
    return []int{leftmost, rightmost}
}
```

```C [sol1-C]
int binarySearch(int* nums, int numsSize, int target, bool lower) {
    int left = 0, right = numsSize - 1, ans = numsSize;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (nums[mid] > target || (lower && nums[mid] >= target)) {
            right = mid - 1;
            ans = mid;
        } else {
            left = mid + 1;
        }
    }
    return ans;
}

int* searchRange(int* nums, int numsSize, int target, int* returnSize) {
    int leftIdx = binarySearch(nums, numsSize, target, true);
    int rightIdx = binarySearch(nums, numsSize, target, false) - 1;
    int* ret = malloc(sizeof(int) * 2);
    *returnSize = 2;
    if (leftIdx <= rightIdx && rightIdx < numsSize && nums[leftIdx] == target && nums[rightIdx] == target) {
        ret[0] = leftIdx, ret[1] = rightIdx;
        return ret;
    }
    ret[0] = -1, ret[1] = -1;
    return ret;
}
```


**复杂度分析**

* 时间复杂度： $O(\log n)$ ，其中 $n$ 为数组的长度。二分查找的时间复杂度为 $O(\log n)$，一共会执行两次，因此总时间复杂度为 $O(\log n)$。

* 空间复杂度：$O(1)$ 。只需要常数空间存放若干变量。