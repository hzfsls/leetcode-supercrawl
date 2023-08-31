## [485.最大连续 1 的个数 中文官方题解](https://leetcode.cn/problems/max-consecutive-ones/solutions/100000/zui-da-lian-xu-1de-ge-shu-by-leetcode-so-252a)

#### 方法一：一次遍历

为了得到数组中最大连续 $1$ 的个数，需要遍历数组，并记录最大的连续 $1$ 的个数和当前的连续 $1$ 的个数。如果当前元素是 $1$，则将当前的连续 $1$ 的个数加 $1$，否则，使用之前的连续 $1$ 的个数更新最大的连续 $1$ 的个数，并将当前的连续 $1$ 的个数清零。

遍历数组结束之后，需要再次使用当前的连续 $1$ 的个数更新最大的连续 $1$ 的个数，因为数组的最后一个元素可能是 $1$，且最长连续 $1$ 的子数组可能出现在数组的末尾，如果遍历数组结束之后不更新最大的连续 $1$ 的个数，则会导致结果错误。

```Java [sol1-Java]
class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int maxCount = 0, count = 0;
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (nums[i] == 1) {
                count++;
            } else {
                maxCount = Math.max(maxCount, count);
                count = 0;
            }
        }
        maxCount = Math.max(maxCount, count);
        return maxCount;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findMaxConsecutiveOnes(vector<int>& nums) {
        int maxCount = 0, count = 0;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            if (nums[i] == 1) {
                count++;
            } else {
                maxCount = max(maxCount, count);
                count = 0;
            }
        }
        maxCount = max(maxCount, count);
        return maxCount;
    }
};
```

```JavaScript [sol1-JavaScript]
var findMaxConsecutiveOnes = function(nums) {
    let maxCount = 0, count = 0;
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        if (nums[i] === 1) {
            count++;
        } else {
            maxCount = Math.max(maxCount, count);
            count = 0;
        }
    }
    maxCount = Math.max(maxCount, count);
    return maxCount;
};
```

```go [sol1-Golang]
func findMaxConsecutiveOnes(nums []int) (maxCnt int) {
    cnt := 0
    for _, v := range nums {
        if v == 1 {
            cnt++
        } else {
            maxCnt = max(maxCnt, cnt)
            cnt = 0
        }
    }
    maxCnt = max(maxCnt, cnt)
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int findMaxConsecutiveOnes(int* nums, int numsSize) {
    int maxCount = 0, count = 0;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] == 1) {
            count++;
        } else {
            maxCount = fmax(maxCount, count);
            count = 0;
        }
    }
    maxCount = fmax(maxCount, count);
    return maxCount;
}
```

```Python [sol1-Python3]
class Solution:
    def findMaxConsecutiveOnes(self, nums: List[int]) -> int:
        maxCount = count = 0

        for i, num in enumerate(nums):
            if num == 1:
                count += 1
            else:
                maxCount = max(maxCount, count)
                count = 0
        
        maxCount = max(maxCount, count)
        return maxCount
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组的长度。需要遍历数组一次。

- 空间复杂度：$O(1)$。