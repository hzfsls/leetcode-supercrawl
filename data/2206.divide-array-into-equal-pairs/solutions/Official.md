## [2206.将数组划分成相等数对 中文官方题解](https://leetcode.cn/problems/divide-array-into-equal-pairs/solutions/100000/jiang-shu-zu-hua-fen-cheng-xiang-deng-sh-vrd5)

#### 方法一：哈希表

**思路与算法**

对于数组 $\textit{nums}$，它「能被划分成 $n$ 个相等数对」**等价于**「所有元素的出现次数均为偶数」。因此，我们只需要判断数组 $\textit{nums}$ 的每个元素的出现次数是否为偶数即可。

具体地，我们遍历数组 $\textit{nums}$，并用哈希表 $\textit{freq}$ 统计每个元素的出现次数。最后，我们遍历 $\textit{freq}$ 的所有值检查它们是否均为偶数。如果是，则说明该数组可以被划分成 $n$ 个相等数对，我们返回 $\texttt{true}$；反之则不行，我们返回 $\texttt{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool divideArray(vector<int>& nums) {
        unordered_map<int, int> freq;   // 元素出现次数哈希表
        for (int num: nums) {
            ++freq[num];
        }
        return all_of(freq.begin(), freq.end(), [](auto p) { return p.second % 2 == 0; });
    }
};
```


```Python [sol1-Python3]
class Solution:
    def divideArray(self, nums: List[int]) -> bool:
        freq = Counter(nums)   # 元素出现次数哈希表
        return all(f % 2 == 0 for f in freq.values())
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 可以拆分的数对个数。即为统计数组中每个数字出现次数并判断是否可以按要求划分的时间复杂度。

- 空间复杂度：$O(n)$，即为出现次数哈希表的空间开销。