## [2154.将找到的值乘以 2 中文官方题解](https://leetcode.cn/problems/keep-multiplying-found-values-by-two/solutions/100000/jiang-zhao-dao-de-zhi-cheng-yi-2-by-leet-blv4)

#### 方法一：排序

**思路与算法**

如果我们不对数组 $\textit{nums}$ 进行任何操作，那么每次更新 $\textit{original}$ 后，都需要 $O(n)$ 的时间完整遍历一遍。最终时间复杂度为 $O(n^2)$。

我们可以对这一过程进行优化。具体而言，每次在数组中找到 $\textit{original}$ 后，$\textit{original}$ 的数值都会比更新前更大，因此我们可以先将数组 $\textit{nums}$ **升序排序**，这样每次更新后的 $\textit{original}$ 数值在数组中的位置（如有）只可能位于更新前的后面，我们只需要一边**从左至右遍历**排序后的 $\textit{nums}$ 数组一边尝试更新 $\textit{original}$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findFinalValue(vector<int>& nums, int original) {
        sort(nums.begin(), nums.end());
        for (int num: nums) {
            if (original == num) {
                original *= 2;
            }
        }
        return original;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findFinalValue(self, nums: List[int], original: int) -> int:
        nums.sort()
        for num in nums:
            if num == original:
                original *= 2
        return original
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。排序的时间复杂度为 $O(n \log n)$，遍历更新 $\textit{original}$ 的时间复杂度最多为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。


#### 方法二：哈希表

**思路与算法**

我们还可以采用更加直接地利用空间换取时间的方法：利用哈希集合存储数组 $\textit{nums}$ 中的元素，然后我们只需要每次判断 $\textit{original}$ 是否位于该哈希集合中即可。具体地：

- 如果 $\textit{original}$ 位于哈希集合中，我们将 $\textit{original}$ 乘以 $2$，然后再次判断；

- 如果 $\textit{original}$ 不位于哈希集合中，那么循环结束，我们返回当前的 $\textit{original}$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findFinalValue(vector<int>& nums, int original) {
        unordered_set<int> s(nums.begin(), nums.end());
        while (s.count(original)) {
            original *= 2;
        }
        return original;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findFinalValue(self, nums: List[int], original: int) -> int:
        s = set(nums)
        while original in s:
            original *= 2
        return original
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。遍历数组维护元素哈希集合的时间复杂度为 $O(n)$，遍历更新 $\textit{original}$ 的时间复杂度最多为 $O(n)$。

- 空间复杂度：$O(n)$，即为元素哈希集合的空间开销。