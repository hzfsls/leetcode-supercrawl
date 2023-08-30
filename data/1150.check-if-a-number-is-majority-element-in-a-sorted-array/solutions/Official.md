#### 方法一：遍历

**思路**

我们先不考虑其他的条件，本题只需要我们判断目标数值 `target` 在数组中出现的次数是否超过 $N/2$ 次。那么只需要遍历数组，记录目标出现的次数，最后和数组长度的一半比较即可。

**代码**

```Golang [ ]
func isMajorityElement(nums []int, target int) bool {
    count := 0
    for i := 0; i < len(nums); i++ {
        if nums[i] == target {
            count++
        }
    }
    return count > len(nums)/2
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，遍历一次数组。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。

#### 方法二：遍历直到目标数字

**思路**

方法一没有考虑任何前置条件，但是题目告诉我们这是一个**非递减**顺序排列的数组 nums，那么当发现 `nums[i] > target` 的时候就可以退出遍历直接比较了。

**代码**
```Golang [ ]
func isMajorityElement(nums []int, target int) bool {
    count := 0
    for i := 0; i < len(nums); i++ {
        if nums[i] == target {
            count++
        } else if nums[i] > target {
            break
        }
    }
    return count > len(nums)/2
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，最慢遍历一次数组。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。

#### 方法三：双指针

**思路**

既然数组有序，那么我们还可以通过双指针的方法找到目标数字的左右下标，然后通过下标计算长度。

**代码**
```Golang [ ]
func isMajorityElement(nums []int, target int) bool {
    if len(nums) == 1 {
        return nums[0] == target
    }
    left, right := 0, len(nums) - 1
    for left < right {
        if nums[left] < target {
            left++
        } else if nums[left] > target {
            return false
        }

        if nums[right] > target {
            right--
        } else if nums[right] < target {
            return false
        }

        if nums[left] == target && nums[right] == target {
            break
        }
    }
    return right - left + 1 > len(nums) / 2
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，最慢遍历一次数组。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。

#### 方法四：两次二分查找

**思路**

查找有序数组中的数字最快的方法还是二分查找，在方法三的基础上，我们使用二分查找求目标数字的左右下标。

二分查找目标数字的左右下标的相关算法请看 [**34. 在排序数组中查找元素的第一个和最后一个位置**](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/) 。

**代码**

```Golang [ ]
func isMajorityElement(nums []int, target int) bool {
    left, right := binarySearchLeft(nums, target), binarySearchRight(nums, target)
    return left != -1 && right != -1 && right - left + 1 > len(nums)/2
}

func binarySearchLeft(nums []int, target int) int {
    l, r := 0, len(nums) - 1
    for l <= r {
        mid := l + (r - l)/2
        if nums[mid] >= target {
            r = mid - 1
        } else {
            l = mid + 1
        }
    }
    if l < len(nums) && nums[l] == target {
        return l
    }
    return -1 
}

func binarySearchRight(nums []int, target int) int {
    l, r := 0, len(nums) - 1
    for l <= r {
        mid := l + (r - l)/2
        if nums[mid] <= target {
            l = mid + 1
        } else {
            r = mid - 1
        }
    }
    if r >= 0 && nums[r] == target {
        return r
    }
    return r - 1
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。由于二分查找每次将搜索区间大约划分为两等分，所以时间复杂度为 $O(\log n)$。二分查找的过程被调用了两次，所以总的时间复杂度是对数级别的。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。

#### 方法五：一次二分查找

**思路**

在方法四的基础上，我们还可以继续优化时间复杂度，只需要使用一次二分查找。找到边界下标，再判断边界下标加上数组一半的下标的数字是否等于目标数字。

**算法**

1. 使用二分查找找到目标数字的最左边的下标 `left`。
2. 判断 `left + len(nums)/2` 下标是否等于 `target`，如果等于，则说明长度大于一半。

**需要注意判断相加后的下标是否越界。**

**代码**

```Golang [ ]
func isMajorityElement(nums []int, target int) bool {
    left := binarySearchLeft(nums, target)
    return left != -1 && left + len(nums)/2 < len(nums) && nums[left + len(nums)/2] == target
}

func binarySearchLeft(nums []int, target int) int {
    l, r := 0, len(nums) - 1 
    for l <= r {
        mid := l + (r - l)/2
        if nums[mid] >= target {
            r = mid - 1
        } else {
            l = mid + 1
        }
    }
    if l < len(nums) && nums[l] == target {
        return l
    }
    return -1 
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。由于二分查找每次将搜索区间大约划分为两等分，所以时间复杂度为 $O(\log n)$。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。