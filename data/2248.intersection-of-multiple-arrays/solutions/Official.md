## [2248.多个数组求交集 中文官方题解](https://leetcode.cn/problems/intersection-of-multiple-arrays/solutions/100000/duo-ge-shu-zu-qiu-jiao-ji-by-leetcode-so-5c9z)
#### 方法一：模拟

**思路与算法**

我们可以用哈希集合来模拟求解交集的过程。具体地，我们用哈希集合 $\textit{res}$ 存储第一个数组 $\textit{nums}[0]$ 的所有元素，随后，我们遍历二维数组 $\textit{nums}$ 的剩余元素。遍历元素 $\textit{nums}[i]$ 时，我们用另一个哈希集合 $\textit{tmp}$ 来存储 $\textit{res}$ 和 $\textit{nums}[i]$ 中元素的交集。我们可以通过遍历 $\textit{nums}[i]$ 判断每个元素是否在 $\textit{res}$ 中。最后，我们令 $\textit{res} = \textit{tmp}$，即为前 $i + 1$ 个数组的交集。

最终，$\textit{res}$ 即为所有数组的元素交集。我们用数组记录哈希集合 $\textit{res}$ 的所有元素，并排序后作为答案返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> intersection(vector<vector<int>>& nums) {
        int n = nums.size();
        unordered_set<int> res(nums[0].begin(), nums[0].end());
        for (int i = 1; i < n; ++i) {
            unordered_set<int> tmp;
            for (int num: nums[i]) {
                if (res.count(num)) {
                    tmp.insert(num);
                }
            }
            res = tmp;
        }
        vector<int> ans(res.begin(), res.end());
        sort(ans.begin(), ans.end());
        return ans;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def intersection(self, nums: List[List[int]]) -> List[int]:
        n = len(nums)
        res = set(nums[0])
        for i in range(1, n):
            tmp = set()
            for num in nums[i]:
                if num in res:
                    tmp.add(num)
            res = tmp
        return sorted(res)
```


**复杂度分析**

- 时间复杂度：$O(\sum_i n_i + \min(n_i)\log\min(n_i))$，其中 $n_i$ 为 $\textit{nums}[i]$ 的长度。其中遍历求交集的时间复杂度为 $O(\sum_i n_i)$，对结果排序的时间复杂度为 $O(\min(n_i)\log\min(n_i))$。

- 空间复杂度：$O(\max(n_i))$，即为辅助哈希集合的空间开销。


#### 方法二：统计每个整数的出现次数

**思路与算法**

我们用 $n$ 表示二维数组 $\textit{nums}$ 的长度。由于二维数组 $\textit{nums}$ 里面的每个数组中的元素互不相同，因此如果一个元素在每个数组中均出现过，则它在 $\textit{nums}$ 中的出现次数应当等于 $n$。

因此我们可以用哈希表 $\textit{freq}$ 维护每个整数的出现次数，随后我们遍历 $\textit{nums}$ 并维护哈希表 $\textit{freq}$。最终，我们遍历 $\textit{freq}$ 并用 $\textit{res}$ 数组记录所有出现次数等于 $n$ 的整数，然后返回排序后的 $\textit{res}$ 数组作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> intersection(vector<vector<int>>& nums) {
        int n = nums.size();
        unordered_map<int, int> freq;
        for (const auto& arr: nums) {
            for (int num: arr) {
                ++freq[num];
            }
        }
        vector<int> res;
        for (const auto& [k, v]: freq) {
            if (v == n) {
                res.push_back(k);
            }
        }
        sort(res.begin(), res.end());
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def intersection(self, nums: List[List[int]]) -> List[int]:
        n = len(nums)
        freq = defaultdict(int)
        for arr in nums:
            for num in arr:
                freq[num] += 1
        res = []
        for k, v in freq.items():
            if v == n:
                res.append(k)
        return sorted(res)
```


**复杂度分析**

- 时间复杂度：$O(\sum_i n_i + \min(n_i)\log\min(n_i))$，其中 $n_i$ 为 $\textit{nums}[i]$ 的长度。即为遍历统计每个整数出现次数，遍历哈希表统计结果以及排序的时间复杂度。

- 空间复杂度：$O(\max_i n_i)$，即为辅助哈希表的时间复杂度。