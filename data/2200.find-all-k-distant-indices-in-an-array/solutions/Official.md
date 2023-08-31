## [2200.找出数组中的所有 K 近邻下标 中文官方题解](https://leetcode.cn/problems/find-all-k-distant-indices-in-an-array/solutions/100000/zhao-chu-shu-zu-zhong-de-suo-you-k-jin-l-b3k2)
#### 方法一：枚举

**思路与算法**

我们可以枚举所有的下标对 $(i, j)$，并判断是否满足 $\textit{nums}[j] = \textit{key}$ 且 $|i - j| \le k$。与此同时，我们用数组 $\textit{res}$ 维护所有 $K$ 近邻下标。如果上述两个条件均满足，则我们将 $i$ 添加进数组 $\textit{res}$ 中。

为了使得 $\textit{res}$ 中不含有重复下标，且按照递增顺序，我们可以先**按递增顺序**枚举 $i$，再枚举 $j$，并且每当 $i$ 被添加进 $\textit{res}$ 后，我们就**终止内层循环**，开始遍历下一个 $i$。最终，数组 $\textit{res}$ 即为符合要求的所有 $K$ 近邻下标，我们返回作为答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findKDistantIndices(vector<int>& nums, int key, int k) {
        vector<int> res;
        int n = nums.size();
        // 遍历数对
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (nums[j] == key && abs(i - j) <= k) {
                    res.push_back(i);
                    break;   // 提前结束以防止重复添加
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        res = []
        n = len(nums)
        # 遍历数对
        for i in range(n):
            for j in range(n):
                if nums[j] == key and abs(i - j) <= k:
                    res.append(i)
                    break   # 提前结束以防止重复添加
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。即为遍历下标 $i, j$ 寻找目标下标的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。


#### 方法二：一遍遍历

**思路与算法**

我们不妨设数组 $\textit{nums}$ 的长度为 $n$。那么，对于任何一个满足 $\textit{nums}[j] = \textit{key}$ 的下标 $j$，**闭区间** $[\max(0, j - k), \min(n - 1, j + k)]$ 区间内的所有下标均为 $K$ 近邻下标（此处取最大最小值是为了保证下标合法）。

那么，我们就可以通过一次遍历数组 $\textit{nums}$，找到所有满足 $\textit{nums}[j] = \textit{key}$ 的下标 $j$，并将对应区间内的整数添加进 $\textit{res}$ 即可。但这样仍然会导致可能有重复的下标被添加进答案数组。为此，我们可以用 $r$ 来表示当前**未被判断过**是否为 $K$ 近邻下标的**最小**下标。在遍历开始前，$r = 0$；每当遍历到符合条件的 $j$ 时，我们只需要将**闭区间** $[\max(0, j - k), \min(n - 1, j + k)]$ 区间内的所有下标依次添加至 $\textit{res}$ 中即可，同时，我们将 $r$ 更新为 $\min(n - 1, j + k) + 1$。当遍历完成后，$\textit{res}$ 即为按递增顺序排序、且不重复的符合要求的所有 $K$ 近邻下标。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findKDistantIndices(vector<int>& nums, int key, int k) {
        vector<int> res;
        int r = 0;   // 未被判断过的最小下标
        int n = nums.size();
        for (int j = 0; j < n; ++j) {
            if (nums[j] == key) {
                int l = max(r, j - k);
                r = min(n - 1, j + k) + 1;
                for (int i = l; i < r; ++i) {
                    res.push_back(i);
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        res = []
        r = 0   # 未被判断过的最小下标
        n = len(nums)
        for j in range(n):
            if nums[j] == key:
                l = max(r, j - k)
                r = min(n - 1, j + k) + 1
                for i in range(l, r):
                    res.append(i)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。即为遍历数组统计所有目标下标的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。