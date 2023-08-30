#### 方法一：排序 + 哈希表

**思路与算法**

我们对数组 $\textit{nums}$ 进行排序，随后使用两个指针，初始分别指向 $\textit{nums}$ 首元素和尾元素对数组进行遍历，就可以不断得到当前数组的最大值和最小值。

由于「不同平均值的数目」和「不同和的数目」是等价的，因此在计算时，可以直接求出两个指针指向元素的和，代替平均值，避免浮点运算。我们只需要使用一个哈希集合，将所有的和添加进去，随后哈希集合中的元素个数即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int distinctAverages(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        unordered_set<int> seen;
        for (int i = 0, j = nums.size() - 1; i < j; ++i, --j) {
            seen.insert(nums[i] + nums[j]);
        }
        return seen.size();
    }
};
```

```Python [sol1-Python3]
class Solution:
    def distinctAverages(self, nums: List[int]) -> int:
        nums.sort()
        seen = set()
        i, j = 0, len(nums) - 1
        while i < j:
            seen.add(nums[i] + nums[j])
            i += 1
            j -= 1
        return len(seen)
```

```Java [sol1-Java]
class Solution {
    public int distinctAverages(int[] nums) {
        Arrays.sort(nums);
        Set<Integer> seen = new HashSet<Integer>();
        for (int i = 0, j = nums.length - 1; i < j; ++i, --j) {
            seen.add(nums[i] + nums[j]);
        }
        return seen.size();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DistinctAverages(int[] nums) {
        Array.Sort(nums);
        ISet<int> seen = new HashSet<int>();
        for (int i = 0, j = nums.Length - 1; i < j; ++i, --j) {
            seen.Add(nums[i] + nums[j]);
        }
        return seen.Count;
    }
}
```

```Go [sol1-Go]
func distinctAverages(nums []int) int {
    sort.Ints(nums)
    seen := make(map[int]bool)
    for i, j := 0, len(nums)-1; i < j; i, j = i + 1, j - 1 {
        seen[nums[i] + nums[j]] = true
    }
    return len(seen)
}
```

```JavaScript [sol1-JavaScript]
var distinctAverages = function(nums) {
    nums.sort((a, b) => a - b);
    const seen = new Set();
    for (let i = 0, j = nums.length - 1; i < j; i++, j--) {
        seen.add(nums[i] + nums[j]);
    }
    return seen.size;
}
```

```C [sol1-C]
int cmp(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int distinctAverages(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int seen[201] = {};
    int count = 0;
    for (int i = 0, j = numsSize - 1; i < j; i++, j--) {
        int sum = nums[i] + nums[j];
            if (!seen[sum]) {
            seen[sum] = 1;
            count++;
        }
    }
    return count;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$，即为哈希表需要使用的空间。