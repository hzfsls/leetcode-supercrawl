## [2395.和相等的子数组 中文官方题解](https://leetcode.cn/problems/find-subarrays-with-equal-sum/solutions/100000/he-xiang-deng-de-zi-shu-zu-by-leetcode-s-3945)
#### 方法一：哈希表

**思路与算法**

我们只需要对数组进行一次遍历。当我们遍历到第 $i$ 个元素时，计算 $\textit{nums}[i] + \textit{nums}[i + 1]$ 的值，并判断该值是否已经出现过即可。

判断的操作可以使用一个哈希表，记录已经出现过的值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool findSubarrays(vector<int>& nums) {
        int n = nums.size();
        unordered_set<int> seen;
        for (int i = 0; i < n - 1; ++i) {
            int sum = nums[i] + nums[i + 1];
            if (seen.count(sum)) {
                return true;
            }
            seen.insert(sum);
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean findSubarrays(int[] nums) {
        int n = nums.length;
        Set<Integer> seen = new HashSet<Integer>();
        for (int i = 0; i < n - 1; ++i) {
            int sum = nums[i] + nums[i + 1];
            if (!seen.add(sum)) {
                return true;
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool FindSubarrays(int[] nums) {
        int n = nums.Length;
        ISet<int> seen = new HashSet<int>();
        for (int i = 0; i < n - 1; ++i) {
            int sum = nums[i] + nums[i + 1];
            if (!seen.Add(sum)) {
                return true;
            }
        }
        return false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findSubarrays(self, nums: List[int]) -> bool:
        n = len(nums)
        seen = set()
        for i in range(n - 1):
            total = nums[i] + nums[i + 1]
            if total in seen:
                return True
            seen.add(total)
        return False
```

```JavaScript [sol1-JavaScript]
var findSubarrays = function(nums) {
    const n = nums.length;
    const seen = new Set();
    for (let i = 0; i < n - 1; ++i) {
        let sum = nums[i] + nums[i + 1];
        if (seen.has(sum)) {
            return true;
        }
        seen.add(sum);
    }
    return false;
};
```

```go [sol1-Golang]
func findSubarrays(nums []int) bool {
    seen := map[int]bool{}
    for i := 1; i < len(nums); i++ {
        sum := nums[i-1] + nums[i]
        if seen[sum] {
            return true
        }
        seen[sum] = true
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。即为哈希表需要使用的空间。