## [2190.数组中紧跟 key 之后出现最频繁的数字 中文官方题解](https://leetcode.cn/problems/most-frequent-number-following-key-in-an-array/solutions/100000/shu-zu-zhong-jin-gen-key-zhi-hou-chu-xia-elzm)
#### 方法一：哈希表

**思路与算法**

我们不妨用 $n$ 表示 $\textit{nums}$ 数组的元素数量。为了统计不同 $\textit{target}$ 的出现次数，我们可以用哈希表 $\textit{freq}$ 来维护。

具体而言，我们遍历 $\textit{nums}$ 数组中下标 $i$ 在**闭区间** $[0, n - 2]$ 的元素。当 $\textit{nums}[i] = \textit{key}$ 时，$\textit{nums}[i + 1]$ 即为 $\textit{target}$，我们在 $\textit{freq}$ 中将该元素的出现次数加上 $1$。最终，我们统计哈希表 $\textit{freq}$ 中统计出现次数最多的数字，并返回作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int mostFrequent(vector<int>& nums, int key) {
        int n = nums.size();
        unordered_map<int, int> freq;   // 统计出现次数的哈希表
        for (int i = 0; i < n - 1; ++i) {
            if (nums[i] == key) {
                ++freq[nums[i+1]];
            }
        }
        // 计算并返回最高频元素
        int maxfreq = 0;
        int res = 0;
        for (const auto& [v, f]: freq) {
            if (f > maxfreq) {
                res = v; 
                maxfreq = f;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def mostFrequent(self, nums: List[int], key: int) -> int:
        n = len(nums)
        freq = Counter()   # 统计出现次数的哈希表
        for i in range(n - 1):
            if nums[i] == key:
                freq[nums[i+1]] += 1;
        return freq.most_common(1)[0][0]   # 计算并返回最高频元素
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。即为统计各个 $\textit{target}$ 出现次数哈希表，并计算出现次数最多的 $\textit{target}$ 的时间复杂度。

- 空间复杂度：$O(n)$，即为统计各个 $\textit{target}$ 出现次数哈希表的空间开销。