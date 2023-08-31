## [704.二分查找 中文官方题解](https://leetcode.cn/problems/binary-search/solutions/100000/er-fen-cha-zhao-by-leetcode-solution-f0xw)

#### 方法一：二分查找

在升序数组 $\textit{nums}$ 中寻找目标值 $\textit{target}$，对于特定下标 $i$，比较 $\textit{nums}[i]$ 和 $\textit{target}$ 的大小：

- 如果 $\textit{nums}[i] = \textit{target}$，则下标 $i$ 即为要寻找的下标；

- 如果 $\textit{nums}[i] > \textit{target}$，则 $\textit{target}$ 只可能在下标 $i$ 的左侧；

- 如果 $\textit{nums}[i] < \textit{target}$，则 $\textit{target}$ 只可能在下标 $i$ 的右侧。

基于上述事实，可以在有序数组中使用二分查找寻找目标值。

二分查找的做法是，定义查找的范围 $[\textit{left}, \textit{right}]$，初始查找范围是整个数组。每次取查找范围的中点 $\textit{mid}$，比较 $\textit{nums}[\textit{mid}]$ 和 $\textit{target}$ 的大小，如果相等则 $\textit{mid}$ 即为要寻找的下标，如果不相等则根据 $\textit{nums}[\textit{mid}]$ 和 $\textit{target}$ 的大小关系将查找范围缩小一半。

由于每次查找都会将查找范围缩小一半，因此二分查找的时间复杂度是 $O(\log n)$，其中 $n$ 是数组的长度。

二分查找的条件是查找范围不为空，即 $\textit{left} \le \textit{right}$。如果 $\textit{target}$ 在数组中，二分查找可以保证找到 $\textit{target}$，返回 $\textit{target}$ 在数组中的下标。如果 $\textit{target}$ 不在数组中，则当 $\textit{left} > \textit{right}$ 时结束查找，返回 $-1$。

```Java [sol1-Java]
class Solution {
    public int search(int[] nums, int target) {
        int left = 0, right = nums.length - 1;
        while (left <= right) {
            int mid = (right - left) / 2 + left;
            int num = nums[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Search(int[] nums, int target) {
        int left = 0, right = nums.Length - 1;
        while (left <= right) {
            int mid = (right - left) / 2 + left;
            int num = nums[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int search(vector<int>& nums, int target) {
        int left = 0, right = nums.size() - 1;
        while(left <= right){
            int mid = (right - left) / 2 + left;
            int num = nums[mid];
            if (num == target) {
                return mid;
            } else if (num > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }
};
```

```JavaScript [sol1-JavaScript]
var search = function(nums, target) {
    let left = 0, right = nums.length - 1;
    while (left <= right) {
        const mid = Math.floor((right - left) / 2) + left;
        const num = nums[mid];
        if (num === target) {
            return mid;
        } else if (num > target) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return -1;
};
```

```go [sol1-Golang]
func search(nums []int, target int) int {
    left, right := 0, len(nums)-1
    for left <= right {
        mid := (right-left)/2 + left
        num := nums[mid]
        if num == target {
            return mid
        } else if num > target {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return -1
}
```

```Python [sol1-Python3]
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        left, right = 0, len(nums) - 1
        while left <= right:
            mid = (right - left) // 2 + left
            num = nums[mid]
            if num == target:
                return mid
            elif num > target:
                right = mid - 1
            else:
                left = mid + 1
        return -1
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 是数组的长度。

- 空间复杂度：$O(1)$。