## [2122.还原原数组 中文官方题解](https://leetcode.cn/problems/recover-the-original-array/solutions/100000/huan-yuan-yuan-shu-zu-by-leetcode-soluti-nizi)

#### 方法一：枚举 + 双指针

**思路与算法**

我们首先将数组 $\textit{arr}$ 按照升序排序。

根据题目的要求，$\textit{arr}$ 可以拆分成两个长度为 $n$ 的数组，并且对于元素较小的那个数组 $\textit{lower}$ 中的每一个元素，在元素较大的那个数组 $\textit{upper}$ 中都**唯一对应**着一个恰好比它大 $2k$ 的元素。当 $\textit{arr}$ 有序时，最小的那个元素 $\textit{arr}[0]$ 一定是属于 $\textit{lower}$ 的，这样一来，我们就可以枚举 $\textit{arr}$ 中剩余的 $2n-1$ 个元素，分别作为 $\textit{arr}[0]$ 在 $\textit{upper}$ 中唯一对应的元素，并判断剩余元素的合法性。

假设 $\textit{arr}[0]$ 对应着 $\textit{arr}[i]$，那么我们就可以得到 $k$ 的值：

$$
k = \frac{arr[i] - arr[0]}{2}
$$

由于 $k$ 是整数并且 $k > 0$，因此我们必须要求 $\textit{arr}[0]$ 与 $\textit{arr}[i]$ 同奇偶，并且它们的值不相等。在求出 $k$ 的值后，我们可以使用双指针的方法判断剩余的元素是否满足要求：

- 我们用两个指针 $\textit{left}$ 和 $\textit{right}$ 分别指向 $0$ 和 $i$，其中 $\textit{left}$ 的作用的是每次找到剩余元素中最小的那一个，它一定是属于 $\textit{lower}$ 的；$\textit{right}$ 的作用是指向恰好等于 $\textit{arr}[\textit{left}] + 2k$ 的元素，并且将 $\textit{left}$ 和 $\textit{right}$ 对应起来；

- 我们还需要一个长度为 $2n$ 的数组，记录每一个元素是否被使用过。如果指针到达了已经被使用过的元素，则无需处理当前元素；

- 由于我们还剩余 $2n-2$ 个元素，因此需要进行 $n-1$ 次对应操作。每一次操作中，我们首先向右移动 $\textit{left}$ 指针，直到指针指向的元素没有被使用过，此时 $\textit{arr}[\textit{left}]$ 就是最小的未被使用过的元素，它一定属于 $\textit{lower}$。随后我们向右移动 $\textit{right}$ 指针，直到 $\textit{arr}[\textit{left}] + 2k = \textit{arr}[\textit{right}]$ 成立并且 $\textit{arr}$ 未被使用过。如果不存在这样的元素，那么我们就可以断定剩余的元素无法满足要求；否则，我们就将 $\textit{arr}[\textit{left}]$ 和 $\textit{arr}[\textit{right}]$ 标记为「使用过」，并将 $\textit{arr}[\textit{left}] + k$（或 $\textit{arr}[\textit{right}] - k$）加入答案。

由于题目保证了「生成的测试用例保证存在至少一个有效数组」，因此上述双指针的方法也一定能找到一个正确的答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> recoverArray(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        for (int i = 1; i < n; ++i) {
            if (nums[i] == nums[0] || (nums[i] - nums[0]) % 2 != 0) {
                continue;
            }
            
            vector<int> used(n);
            used[0] = used[i] = true;
            int k = (nums[i] - nums[0]) / 2;
            vector<int> ans;
            ans.push_back(nums[0] + k);
            
            int left = 0, right = i;
            for (int j = 2; j + j <= n; ++j) {
                while (used[left]) {
                    ++left;
                }
                while (right < n && (used[right] || nums[right] - nums[left] != k * 2)) {
                    ++right;
                }
                if (right == n) {
                    break;
                }
                ans.push_back(nums[left] + k);
                used[left] = used[right] = true;
            }
            
            if (ans.size() == n / 2) {
                return ans;
            }
        }
        
        // 题目保证一定有解，不会到这一步
        return {};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def recoverArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        nums.sort()
        for i in range(1, n):
            if nums[i] == nums[0] or (nums[i] - nums[0]) % 2 != 0:
                continue
            
            used = [False] * n
            used[0] = used[i] = True
            k = (nums[i] - nums[0]) // 2
            ans = [nums[0] + k]
            
            left, right = 0, i
            for j in range(1, n // 2):
                while used[left]:
                    left += 1
                while right < n and (used[right] or nums[right] - nums[left] != k * 2):
                    right += 1
                if right == n:
                    break
                ans.append(nums[left] + k)
                used[left] = used[right] = True
            
            if len(ans) == n // 2:
                return ans
        
        # 题目保证一定有解，不会到这一步
        return None
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。排序需要的时间为 $O(n \log n)$。枚举 $\textit{arr}[i]$ 需要的时间为 $O(n)$，双指针判断需要的时间为 $O(n)$，这一部分的总时间为 $O(n^2)$。

- 空间复杂度：$O(n)$。排序需要 $O(\log n)$ 的栈空间。在每一次枚举 $\textit{arr}[i]$ 的过程中，我们需要 $O(n)$ 的空间记录每个元素是否被使用过，但枚举之间是互相独立的，因此一共也只需要 $O(n)$ 的空间。