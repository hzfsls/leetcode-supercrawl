[TOC]

## 解决方法

---

#### 方法：前缀和 + 哈希映射

 **思路**
 一个数组大小为 `n` 的可能的子数组有多少个？有 1 个长度为 `n` 的子数组，有 2 个长度为 `n - 1` 的子数组，有 3 个长度为 `n - 2` 的子数组，等等。这意味着可能的子数组有 $n + (n - 1) + (n - 2) + ... + 2 + 1 = \frac{n(n + 1)}{2}$个。此题的边界是 $n <= 2 * 10^5$，这意味着如果过于简单地检查每个可能的子数组，可能需要查看超过 200 亿个子数组。这个方法的速度有点不尽人意，我们需要一个更好的解决方案。
 幸运的是，我们不必关心绝大多数的子数组——只有那些和为 `k` 的子数组，所以我们可以做得比简单解决方案好得多。一个子数组需要是连贯的这一事实对我们有很大的帮助——它让我们可以使用一个被称为 **前缀和** 的想法。对于那些不熟悉前缀和的术语的人来说，前缀和就是一个数组的运行总和。例如，对于 `nums = [1, 2, 2, 3]`，前缀和就是 `prefix = [1, 3, 5, 8]`。对于一个索引 `i`，`prefix[i]` 就是 `nums` 中到索引 `i` 位置（包括 `i`）的所有数的和。
 我们退一步——如果问题是""是否存在和为 `k` 的子数组""，我们如何检测出和为 `k` 的子数组？在前缀和中，元素之间的差异代表了子数组的和。例如，如果你有 `prefix` 代表了一个数组 `nums` 的前缀和，那么 `prefix[10] - prefix[2]` 就等于 `nums` 中索引 `3` 到索引 `10` 的子数组的和。这是因为 `prefix[10] = nums[0] + nums[1] + nums[2] + ... + nums[10]` 和 `prefix[2] = nums[0] + nums[1] + nums[2]`。正如你所看到的，所有 `prefix[2]` 都在 `prefix[10]` 中，减去它就剩下了 `nums[3] + ... + nums[10]`。

 <![image.png](https://pic.leetcode.cn/1692169175-JQRItT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169178-utpFRh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169180-SkHNxV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169183-UCLNYX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169187-pYeEmr-image.png){:width=400}>

 因此，如果 `nums` 中存在和为 `k` 的子数组，那么在 `prefix` 中就存在一对数，它们的差是 `k`。这个重新阐述的问题可能对你来说很熟悉；这基本上是 [两数之和](https://leetcode.cn/problems/two-sum/) 的一个变体。在两数之和中，我们必须在一个数组中找到两个不同的数，当它们加起来时等于一个目标值。我们可以通过在哈希表中存储已经看到的数，并且对于每个数，检查它的补数是否已经被看到来实现这一点。我们可以采用类似的技术来解决这个问题——在哈希映射中存储已经看到的前缀和以便快速($O(1)$)检查，并在我们沿着 `prefix` 迭代时检查特定的值是否存在于哈希映射中。在这种情况下，当我们从左到右沿着 `prefix` 迭代时，如果 `prefix[i] - k` 已经被看到，那么我们就找到了一个和为 `k` 的子数组的一对索引。
 现在我们已经建立了如何检测和为 k 的子数组，我们需要处理原问题的另一部分——找出和为 k 的最长子数组的长度。如前所述，我们使用哈希映射来快速检查已有的数。类似于两数之和，我们可以在这个哈希映射中存储索引作为其值。因此，当我们找到一对时，我们可以使用这个存储的索引和当前索引来找出索引对形成的子数组的长度。
 我们实际上并没有一个前缀数组，也不需要它——一个只被用来上面描述例子的。而是我们可以使用一个整数变量来跟踪前缀和，并在每个数字上，将前缀和（包括该数）和当前索引一起存储在一个哈希映射中。如果我们遇到一个重复的数（这可能因为负数），我们不应该在哈希映射中更新索引，因为我们想要最长的子数组，所以我们想要尽可能将索引保持在左边。例如，如果我们有输入 `nums = [1, -1, 1, 3]` 和 `k = 4`，那么最长的子数组就是整个数组。每个步骤的前缀和为 `[1, 0, 1, 4]`。如你所见，我们总是想要选择最左边的索引以最大化长度。因此，当我们到达第三个元素并看到 `1` 已经存在于哈希映射中时，我们不应该用当前索引替换值。
 还有一件事：我们需要考虑前缀和等于 `k` 的情况。我们可以特别检查当前缀和等于 `k` 的情况，或者我们可以初始化我们的哈希映射，对应于值 `-1` 的键为 `0`。如果你有 `nums = [1, 2]` 和 `k = 1`，那么最长的子数组肯定是 `1`。然而，在第一个元素时，我们的前缀和是 `1`，这意味着我们需要在我们的哈希映射中找到一个 `0` 来形成一对。如果没有检查这种情况，我们的算法将认为不存在和为 `1` 的子数组。
 **算法**

 1. 初始化三个变量:  
    - 一个整数 `prefixSum` 记录 `nums` 的前缀和，初始设为 `0`。  
    - 一个整数 `longestSubarray` 来记录和为 `k` 的最长子数组的长度，初始设为0。  
    - 一个哈希映射 `indices`，这个哈希映射的键是迄今为止见过的前缀和，而值是每个键第一次出现的索引。
 2. 遍历 `nums`。在每个索引 `i`，将 `nums[i]` 加到 `prefixSum`上。然后，进行以下检查:  
    - 如果 `prefixSum == k`，那意味着到这个索引位置的数组的和等于 `k`。更新 `longestSubarray = i + 1` (因为 `i` 是从 0 开始的索引)  
    - 如果 `prefixSum - k` 存在于 `indices`中，那意味着存在一个和为 `k` 的子数组结束在当前的 `i`。长度将是 `i - indices[prefixSum - k]`。如果这个长度大于 `longestSubarray`，更新 `longestSubarray`。  
    - 如果 当前 `prefixSum` 还没有在 `indices` 中出现过，那么设定 `indices[prefixSum] = i`。只有在它还不存在的时候做这个操作，因为我们只想要这个前缀和最早出现的实例。
 3. 返回 `longestSubarray`。

 <![image.png](https://pic.leetcode.cn/1692169189-ohWbMx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169192-EVCYyr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169195-tdaLQs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169197-YvOxnU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169200-CWZHBg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692169203-oreYTj-image.png){:width=400}>

 **代码实现**

 ```C++ [solution]
class Solution {
public:
    int maxSubArrayLen(vector<int>& nums, int k) {
        int prefixSum = 0;
        int longestSubarray = 0;
        unordered_map<int, int> indices;
        for (int i = 0; i < nums.size(); i++) {
            prefixSum += nums[i];

            // 检查是否存在累加和等于k的子数组
            if (prefixSum == k) {
                longestSubarray = i + 1;
            }
            
            // 如果之前出现过累加和等于prefixSum - k的位置
            // 则更新最长子数组长度
            if (indices.find(prefixSum - k) != indices.end()) {
                longestSubarray = max(longestSubarray, i - indices[prefixSum - k]);
            }

            // 仅当当前前缀和不在哈希映射中时，将其添加到映射中
            if (indices.find(prefixSum) == indices.end()) {
                indices[prefixSum] = i;
            }
        }
        
        return longestSubarray;
    }
};
 ```

```Java [solution]
class Solution {
    public int maxSubArrayLen(int[] nums, int k) {
        int prefixSum = 0;
        int longestSubarray = 0;
        HashMap<Integer, Integer> indices = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            prefixSum += nums[i];

            // 检查是否存在累加和等于k的子数组
            if (prefixSum == k) {
                longestSubarray = i + 1;
            }

            // 如果之前出现过累加和等于prefixSum - k的位置
            // 则更新最长子数组长度
            if (indices.containsKey(prefixSum - k)) {
                longestSubarray = Math.max(longestSubarray, i - indices.get(prefixSum - k));
            }
            
            // 仅当当前前缀和不在哈希映射中时，将其添加到映射中
            if (!indices.containsKey(prefixSum)) {
                indices.put(prefixSum, i);
            }
        }
        
        return longestSubarray;
    }
}
```

```Python3 [solution]
class Solution:
    def maxSubArrayLen(self, nums: List[int], k: int) -> int:
        prefix_sum = 0
        longest_subarray = 0
        indices = {}
        for i, num in enumerate(nums):
            prefix_sum += num 
            
            # 检查是否存在累加和等于k的子数组
            if prefix_sum == k:
                longest_subarray = i + 1
                
            # 如果之前出现过累加和等于prefix_sum - k的位置
            # 则更新最长子数组长度
            if prefix_sum - k in indices:
                longest_subarray = max(longest_subarray, i - indices[prefix_sum - k])
                
            # 仅当当前前缀和不在字典中时，将其添加到字典中
            if prefix_sum not in indices:
                indices[prefix_sum] = i
        
        return longest_subarray
```

 **复杂度分析**
 设定 $N$ 为 `nums` 的长度,

- 时间复杂度: $O(N)$
  我们只遍历一次 `nums`，每次做一定数量的工作。所有的哈希映射操作都是 $O(1)$。
- 空间复杂度: $O(N)$
  我们的哈希映射可能会持有和 `nums` 中的数字数量一样多的键值对。当数组中没有负数的时候就会发生这种情况。

---