#### 方法一：哈希表

**思路与算法**

根据定义，在数组 $\textit{nums}$ 中，一个元素 $\textit{num}$ 为孤独数字**当且仅当**：
- $\textit{num}$ 在数组中仅出现一次；
- $\textit{num} - 1$ 在数组中没有出现；
- $\textit{num} + 1$ 在数组中没有出现。

因此我们可以使用一个哈希表来维护数组 $\textit{nums}$ 中每个元素的出现次数。随后，我们遍历 $\textit{nums}$ 数组的每个元素，并通过判断上述三个条件是否均满足来判断该元素是否为孤独数字。在遍历的同时，我们用数组记录所有孤独数字，并最终返回作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findLonely(vector<int>& nums) {
        vector<int> res;
        unordered_map<int, int> freq;   // 每个元素出现次数哈希表
        for (int num: nums) {
            ++freq[num];
        }
        for (int num: nums) {
            if (freq[num-1] == 0 && freq[num+1] == 0 && freq[num] == 1) {
                res.push_back(num);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findLonely(self, nums: List[int]) -> List[int]:
        res = []
        freq = Counter(nums)   # 每个元素出现次数哈希表
        for num in nums:
            if freq[num-1] == 0 and freq[num+1] == 0 and freq[num] == 1:
                res.append(num)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。遍历数组维护元素出现次数哈希表的时间复杂度为 $O(n)$，统计所有孤独数字的时间复杂度也为 $O(n)$。

- 空间复杂度：$O(n)$，即为元素出现次数哈希表的空间开销。


#### 方法二：排序

**思路与算法**

我们也可以通过对数组 $\textit{nums}$ 排序来判断每个元素是否为孤独数字。

首先，$\textit{num}$ 为孤独数字**等价于**数组中除了该元素以外，**其他元素**均不为 $\textit{num}$ 或 $\textit{num} \pm 1$。而对于一个**按元素大小升序排序后**的数组，如果在存在值为 $\textit{num}$ 或 $\textit{num} \pm 1$ 的其他元素，一定会有至少一个与该元素相邻。

我们不妨假设该元素下标为 $i$，根据前文可知，$\textit{nums}[i]$ 为孤独数字等价于（假设对应下标存在）：
- $\textit{nums}[i] - \textit{nums}[i-1] > 1$；
- $\textit{nums}[i+1] - \textit{nums}[i] > 1$。

综上，我们可以首先对 $\textit{nums}$ 按照元素大小升序排序，随后遍历每个元素，通过判断每个元素与相邻元素的差是否大于 $1$ 来判断该元素是否为孤独数字。同样地，我们用数组统计所有的孤独数字，并最终返回该数组作为答案。

**细节**

为了在判断时避免对排序后两端数字的额外判断，我们可以在 $\textit{nums}$ 中添加一个远大于数据范围的数和一个远小于数据范围的数（与数据范围的左右边界至少相差 $2$），再进行后续操作。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findLonely(vector<int>& nums) {
        // 避免额外判断边界条件
        nums.push_back(-2);
        nums.push_back(INT_MAX);
        sort(nums.begin(), nums.end());
        int n = nums.size();
        vector<int> res;
        for (int i = 1; i < n - 1; ++i) {
            if (nums[i] - nums[i-1] > 1 && nums[i+1] - nums[i] > 1) {
                res.push_back(nums[i]);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findLonely(self, nums: List[int]) -> List[int]:
        nums += [-float("INF"), float("INF")]   # 避免额外判断边界条件
        nums.sort()
        n = len(nums)
        res = []
        for i in range(1, n - 1):
            if nums[i] - nums[i-1] > 1 and nums[i+1] - nums[i] > 1:
                res.append(nums[i])
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。