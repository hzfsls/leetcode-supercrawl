## [2215.找出两数组的不同 中文官方题解](https://leetcode.cn/problems/find-the-difference-of-two-arrays/solutions/100000/zhao-chu-liang-shu-zu-de-bu-tong-by-leet-78u0)
#### 方法一：哈希集合

**思路与算法**

为了较快地判断一个数组的某个元素是否在另一个数组中存在，我们可以用哈希集合来存储数组的元素，并进行判断。具体而言，我们用哈希集合 $\textit{set}_1$ 与 $\textit{set}_2$ 存储数组 $\textit{nums}_1$ 与 $\textit{nums}_2$ 中所有**不同**的元素。

我们用长度为 $2$ 的嵌套列表 $\textit{res}$ 来保存两数组中不存在于另一数组中的元素。我们首先遍历哈希集合 $\textit{set}_1$ 的每个元素，判断其是否位于 $\textit{set}_2$ 中，如果不在，则我们将它加入 $\textit{res}[0]$ 中；随后我们同样地遍历哈希集合 $\textit{set}_2$ 的每个元素，判断其是否位于 $\textit{set}_1$ 中，如果不在，则加入 $\textit{res}[1]$ 中。这样，我们就得到了两数组中各自的不同元素。

与此同时，由于哈希集合 $\textit{set}_1$ 与 $\textit{set}_2$ 中**不存在重复元素**，因此 $\textit{res}[0]$ 与 $\textit{res}[1]$ 也一定不存在重复元素。最终我们返回 $\textit{res}$ 作为答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> findDifference(vector<int>& nums1, vector<int>& nums2) {
        unordered_set<int> set1, set2;   // nums1 与 nums2 所有元素的哈希集合
        for (int num: nums1) {
            set1.insert(num);
        }
        for (int num: nums2) {
            set2.insert(num);
        }
        vector<vector<int>> res(2);
        for (int num: set1) {
            if (!set2.count(num)) {
                res[0].push_back(num);
            }
        }
        for (int num: set2) {
            if (!set1.count(num)) {
                res[1].push_back(num);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findDifference(self, nums1: List[int], nums2: List[int]) -> List[List[int]]:
        set1 = set(nums1)   # nums1 所有元素的哈希集合
        set2 = set(nums2)   # nums2 所有元素的哈希集合
        res = [[], []]
        for num in set1:
            if num not in set2:
                res[0].append(num)
        for num in set2:
            if num not in set1:
                res[1].append(num)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n_1 + n_2)$，其中 $n_1$ 与 $n_2$ 分别为数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。维护两数组元素对应哈希集合与遍历计算答案的时间复杂度均为 $O(n_1 + n_2)$。

- 空间复杂度：$O(n_1 + n_2)$，即为两数组元素对应哈希集合的空间开销。