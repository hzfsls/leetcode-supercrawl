#### 方法一：贪心

题目要求从原数组中取出部分元素，且满足取出的元素之和严格大于剩余的元素之和，且满足要求取出的元素数量尽可能的少的前提下，取出的元素之和尽可能的大。根据以上分析，我们可以利用贪心法。我们应尽量保证取出的元素尽可能的大，才能满足取出的元素尽可能的少且元素之和尽可能的大，因此我们按照从大到小的顺序依次从原始数组中取出数据，直到取出的数据之和 $\textit{curr}$ 大于数组中剩余的元素之和为止。

```Python [sol1-Python3]
class Solution:
    def minSubsequence(self, nums: List[int]) -> List[int]:
        nums.sort(reverse=True)
        tot, s = sum(nums), 0
        for i, num in enumerate(nums):
            s += num
            if s > tot - s:
                return nums[:i + 1]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> minSubsequence(vector<int>& nums) {
        int total = accumulate(nums.begin(), nums.end(), 0);
        sort(nums.begin(), nums.end());
        vector<int> ans;
        int curr = 0;
        for (int i = nums.size() - 1; i >= 0; --i) {
            curr += nums[i];
            ans.emplace_back(nums[i]);
            if (total - curr < curr) {
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> minSubsequence(int[] nums) {
        int total = Arrays.stream(nums).sum();
        Arrays.sort(nums);
        List<Integer> ans = new ArrayList<Integer>();
        int curr = 0;
        for (int i = nums.length - 1; i >= 0; --i) {
            curr += nums[i];
            ans.add(nums[i]);
            if (total - curr < curr) {
                break;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> MinSubsequence(int[] nums) {
        int total = nums.Sum();
        Array.Sort(nums);
        IList<int> ans = new List<int>();
        int curr = 0;
        for (int i = nums.Length - 1; i >= 0; --i) {
            curr += nums[i];
            ans.Add(nums[i]);
            if (total - curr < curr) {
                break;
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
static inline cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int* minSubsequence(int* nums, int numsSize, int* returnSize){
    int total = 0;
    for (int i = 0; i < numsSize; i++) {
        total += nums[i];
    }
    qsort(nums, numsSize, sizeof(int), cmp);
    int *ans = (int *)malloc(sizeof(int) * numsSize);
    int curr = 0, pos = 0;
    for (int i = numsSize - 1; i >= 0; --i) {
        curr += nums[i];
        ans[pos++] = nums[i];
        if (total - curr < curr) {
            break;
        }
    }
    *returnSize = pos;
    return ans;
}
```

```go [sol1-Golang]
func minSubsequence(nums []int) []int {
    sort.Sort(sort.Reverse(sort.IntSlice(nums)))
    tot := 0
    for _, num := range nums {
        tot += num
    }
    for i, sum := 0, 0; ; i++ {
        sum += nums[i]
        if sum > tot-sum {
            return nums[:i+1]
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var minSubsequence = function(nums) {
    const total = _.sum(nums);
    nums.sort((a, b) => a - b);
    const ans = [];
    let curr = 0;
    for (let i = nums.length - 1; i >= 0; --i) {
        curr += nums[i];
        ans.push(nums[i]);
        if (total - curr < curr) {
            break;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为 数组的长度。需要对数组进行排序，因此时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 为 数组的长度。排序需要的栈空间为 $O(\log n)$。