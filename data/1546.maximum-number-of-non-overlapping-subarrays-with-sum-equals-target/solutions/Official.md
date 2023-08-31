## [1546.和为目标值且不重叠的非空子数组的最大数目 中文官方题解](https://leetcode.cn/problems/maximum-number-of-non-overlapping-subarrays-with-sum-equals-target/solutions/100000/he-wei-mu-biao-zhi-de-zui-da-shu-mu-bu-zhong-die-f)
#### 方法一：贪心

**思路与算法**

由于题目要求所有的子数组**互不重叠**，因此对于某个满足条件的子数组，如果其右端点是所有满足条件的子数组的右端点中最小的那一个，则该子数组一定会被选择。

故可以使用贪心算法：从左到右遍历数组，一旦发现有某个以当前下标 $i$ 为右端点的子数组和为 $\textit{target}$，就给计数器的值加 $1$，并从数组 $\textit{nums}$ 的下标 $i+1$ 开始，进行下一次寻找。

为了判断是否存在和为 $\textit{target}$ 的子数组，我们在遍历的过程中记录数组的前缀和，并将它们保存在哈希表中。如果位置 $i$ 对应的前缀和为 $\textit{sum}_i$，而 $\textit{sum}_i-\textit{target}$ 已经存在于哈希表中，就说明找到了一个和为 $\textit{target}$ 的子数组。

如果找到了一个符合条件的子数组，则接下来遍历时需要用一个新的哈希表，而不是使用原有的哈希表，因为要确保每次找到的子数组都与此前找到的不重合。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxNonOverlapping(vector<int>& nums, int target) {
        int size = nums.size();
        int ret = 0;
        int i = 0;
        while (i < size) {
            unordered_set <int> s = {0};
            int sum = 0;
            while (i < size) {
                sum += nums[i];
                if (s.find(sum - target) != s.end()) {
                    ret++;
                    break;
                } else {
                    s.insert(sum);
                    i++;
                }
            }
            i++;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxNonOverlapping(int[] nums, int target) {
        int size = nums.length;
        int ret = 0;
        int i = 0;
        while (i < size) {
            Set<Integer> set = new HashSet<Integer>() {{
                add(0);
            }};
            int sum = 0;
            while (i < size) {
                sum += nums[i];
                if (set.contains(sum - target)) {
                    ret++;
                    break;
                } else {
                    set.add(sum);
                    i++;
                }
            }
            i++;
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxNonOverlapping(self, nums: List[int], target: int) -> int:
        size = len(nums)
        ret = 0
        i = 0
        while i < size:
            s = {0}
            total = 0
            while i < size:
                total += nums[i]
                if total - target in s:
                    ret += 1
                    break
                else:
                    s.add(total)
                    i += 1
            i += 1
        return ret
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为数组 $\textit{nums}$ 的长度。我们要遍历数组的每个元素，其中哈希表的插入和查询都只需要单次 $O(1)$ 的时间。

- 空间复杂度：$O(N)$，因为哈希表中最多保存 $O(N)$ 个元素。