## [81.搜索旋转排序数组 II 中文官方题解](https://leetcode.cn/problems/search-in-rotated-sorted-array-ii/solutions/100000/sou-suo-xuan-zhuan-pai-xu-shu-zu-ii-by-l-0nmp)
#### 前言

本篇题解基于「[33. 搜索旋转排序数组的官方题解](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/solution/sou-suo-xuan-zhuan-pai-xu-shu-zu-by-leetcode-solut/)」，请读者在阅读完该题解后再继续阅读本篇题解。

#### 方法一：二分查找

**思路**

对于数组中有重复元素的情况，二分查找时可能会有 $a[l]=a[\textit{mid}]=a[r]$，此时无法判断区间 $[l,\textit{mid}]$ 和区间 $[\textit{mid}+1,r]$ 哪个是有序的。

例如 $\textit{nums}=[3,1,2,3,3,3,3]$，$\textit{target}=2$，首次二分时无法判断区间 $[0,3]$ 和区间 $[4,6]$ 哪个是有序的。

对于这种情况，我们只能将当前二分区间的左边界加一，右边界减一，然后在新区间上继续二分查找。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool search(vector<int> &nums, int target) {
        int n = nums.size();
        if (n == 0) {
            return false;
        }
        if (n == 1) {
            return nums[0] == target;
        }
        int l = 0, r = n - 1;
        while (l <= r) {
            int mid = (l + r) / 2;
            if (nums[mid] == target) {
                return true;
            }
            if (nums[l] == nums[mid] && nums[mid] == nums[r]) {
                ++l;
                --r;
            } else if (nums[l] <= nums[mid]) {
                if (nums[l] <= target && target < nums[mid]) {
                    r = mid - 1;
                } else {
                    l = mid + 1;
                }
            } else {
                if (nums[mid] < target && target <= nums[n - 1]) {
                    l = mid + 1;
                } else {
                    r = mid - 1;
                }
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean search(int[] nums, int target) {
        int n = nums.length;
        if (n == 0) {
            return false;
        }
        if (n == 1) {
            return nums[0] == target;
        }
        int l = 0, r = n - 1;
        while (l <= r) {
            int mid = (l + r) / 2;
            if (nums[mid] == target) {
                return true;
            }
            if (nums[l] == nums[mid] && nums[mid] == nums[r]) {
                ++l;
                --r;
            } else if (nums[l] <= nums[mid]) {
                if (nums[l] <= target && target < nums[mid]) {
                    r = mid - 1;
                } else {
                    l = mid + 1;
                }
            } else {
                if (nums[mid] < target && target <= nums[n - 1]) {
                    l = mid + 1;
                } else {
                    r = mid - 1;
                }
            }
        }
        return false;
    }
}
```

```go [sol1-Golang]
func search(nums []int, target int) bool {
    n := len(nums)
    if n == 0 {
        return false
    }
    if n == 1 {
        return nums[0] == target
    }
    l, r := 0, n-1
    for l <= r {
        mid := (l + r) / 2
        if nums[mid] == target {
            return true
        }
        if nums[l] == nums[mid] && nums[mid] == nums[r] {
            l++
            r--
        } else if nums[l] <= nums[mid] {
            if nums[l] <= target && target < nums[mid] {
                r = mid - 1
            } else {
                l = mid + 1
            }
        } else {
            if nums[mid] < target && target <= nums[n-1] {
                l = mid + 1
            } else {
                r = mid - 1
            }
        }
    }
    return false
}
```

```Python [sol1-Python3]
class Solution:
    def search(self, nums: List[int], target: int) -> bool:
        if not nums:
            return False
        
        n = len(nums)
        if n == 1:
            return nums[0] == target
        
        l, r = 0, n - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return True
            if nums[l] == nums[mid] and nums[mid] == nums[r]:
                l += 1
                r -= 1
            elif nums[l] <= nums[mid]:
                if nums[l] <= target and target < nums[mid]:
                    r = mid - 1
                else:
                    l = mid + 1
            else:
                if nums[mid] < target and target <= nums[n - 1]:
                    l = mid + 1
                else:
                    r = mid - 1
        
        return False
```

```C [sol1-C]
bool search(int* nums, int numsSize, int target) {
    if (numsSize == 0) {
        return false;
    }
    if (numsSize == 1) {
        return nums[0] == target;
    }
    int l = 0, r = numsSize - 1;
    while (l <= r) {
        int mid = (l + r) / 2;
        if (nums[mid] == target) {
            return true;
        }
        if (nums[l] == nums[mid] && nums[mid] == nums[r]) {
            ++l;
            --r;
        } else if (nums[l] <= nums[mid]) {
            if (nums[l] <= target && target < nums[mid]) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        } else {
            if (nums[mid] < target && target <= nums[numsSize - 1]) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
    }
    return false;
}
```

```JavaScript [sol1-JavaScript]
var search = function(nums, target) {
    const n = nums.length;
    if (n === 0) {
        return false;
    }
    if (n === 1) {
        return nums[0] === target;
    }
    let l = 0, r = n - 1;
    while (l <= r) {
        const mid = Math.floor((l + r) / 2);
        if (nums[mid] === target) {
            return true;
        }
        if (nums[l] === nums[mid] && nums[mid] === nums[r]) {
            ++l;
            --r;
        } else if (nums[l] <= nums[mid]) {
            if (nums[l] <= target && target < nums[mid]) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        } else {
            if (nums[mid] < target && target <= nums[n - 1]) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。最坏情况下数组元素均相等且不为 $\textit{target}$，我们需要访问所有位置才能得出结果。

- 空间复杂度：$O(1)$。