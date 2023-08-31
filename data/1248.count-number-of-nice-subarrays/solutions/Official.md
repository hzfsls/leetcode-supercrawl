## [1248.统计「优美子数组」 中文官方题解](https://leetcode.cn/problems/count-number-of-nice-subarrays/solutions/100000/tong-ji-you-mei-zi-shu-zu-by-leetcode-solution)
### 📺 视频题解  
![1248.统计优美子数组.mp4](5103845f-f35e-445c-bd5a-38e180cc00d4)

### 📖 文字题解
#### 方法一：数学

**思路和算法**

这个题目中偶数其实是没有用的，我们可以单独建立一个 $\textit{odd}$ 数组来记录第 $i$ 个奇数的下标。那么我们可以枚举奇数，假设当前枚举到第 $i$ 个，那么 $[\textit{odd}[i],\textit{odd}[i+k-1]]$ 这个子数组就恰好包含 $k$ 个奇数。由于奇数和奇数间存在偶数，所以一定存在其他子数组 $[l,r]$ 满足 $[l,r]$ 包含 $[\textit{odd}[i],\textit{odd}[i+k-1]]$ 且 $[l,r]$ 里的奇数个数为 $k$ 个，那么这个需要怎么统计呢？

由于我们已经记录了每个奇数的下标，所以我们知道对于第 $i$ 个奇数，它的前一个奇数的下标为 $\textit{odd}[i-1]$，也就是说 $(\textit{odd}[i-1],\textit{odd}[i])$ 间的数都为偶数。同理可得 $(\textit{odd}[i+k-1],\textit{odd}[i+k])$ 间的数也都为偶数。那么我们可以得出满足 $l\in (\textit{odd}[i-1],\textit{odd}[i]]$ 且 $r\in [\textit{odd}[i+k-1],\textit{odd}[i+k])$ 条件的子数组 $[l,r]$ 包含 $[\textit{odd}[i],\textit{odd}[i+k-1]]$ 且 $[l,r]$ 里的奇数个数为 $k$ 个。因此对于第 $i$ 个奇数，它对答案的贡献为符合条件的 $[l,r]$ 的个数，即：

$$
(\textit{odd}[i] - \textit{odd}[i - 1]) \times (\textit{odd}[i + k] - \textit{odd}[i + k - 1])
$$

我们只要遍历一遍 $\textit{odd}$ 数组即可求得最后的答案，注意边界的处理。

```C++ [sol1-C++]
class Solution {
public:
    int numberOfSubarrays(vector<int>& nums, int k) {
        int n = (int)nums.size();
        int odd[n + 2], ans = 0, cnt = 0;
        for (int i = 0; i < n; ++i) {
            if (nums[i] & 1) odd[++cnt] = i;
        }
        odd[0] = -1, odd[++cnt] = n;
        for (int i = 1; i + k <= cnt; ++i) {
            ans += (odd[i] - odd[i - 1]) * (odd[i + k] - odd[i + k - 1]); 
        }
        return ans;
    }
};
```
```Java [sol1-Java]
class Solution {
    public int numberOfSubarrays(int[] nums, int k) {
        int n = nums.length;
        int[] odd = new int[n + 2];
        int ans = 0, cnt = 0;
        for (int i = 0; i < n; ++i) {
            if ((nums[i] & 1) != 0) {
                odd[++cnt] = i;
            }
        }
        odd[0] = -1;
        odd[++cnt] = n;
        for (int i = 1; i + k <= cnt; ++i) {
            ans += (odd[i] - odd[i - 1]) * (odd[i + k] - odd[i + k - 1]); 
        }
        return ans;
    }
}
```
```Python3 [sol1-Python3]
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        n = len(nums)
        odd = [-1]
        ans = 0
        for i in range(n):
            if nums[i] % 2 == 1:
                odd.append(i)
        odd.append(n)
        print(odd)
        for i in range(1, len(odd) - k):
            ans += (odd[i] - odd[i - 1]) * (odd[i + k] - odd[i + k - 1])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的大小。遍历 $\textit{odd}$ 数组最坏情况下需要 $O(n)$ 的时间。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的大小。$\textit{odd}$ 数组需要 $O(n)$ 的空间。


#### 方法二：前缀和 + 差分

**思路和算法**

考虑以 $i$ 结尾的「优美子数组」个数，我们需要统计符合条件的下标 $j$ 的个数，其中 $0\leq j\leq i$ 且 $[j..i]$ 这个子数组里的奇数个数恰好为 $k$ 。如果枚举 $[0..i]$ 里所有的下标来判断是否符合条件，那么复杂度将会达到 $O(n^2)$ ，无法通过所有测试用例，因此我们需要优化枚举的时间复杂度。

我们定义 $\textit{pre}[i]$ 为 $[0..i]$ 中奇数的个数，则 $\textit{pre}[i]$ 可以由 $\textit{pre}[i-1]$ 递推而来，即：
$$
\textit{pre}[i]=\textit{pre}[i-1]+(\textit{nums}[i]\&1)
$$

那么「$[j..i]$ 这个子数组里的奇数个数恰好为 $k$ 」这个条件我们可以转化为

$$
\textit{pre}[i]-\textit{pre}[j-1]==k
$$

简单移项可得符合条件的下标 $j$ 需要满足
$$
\textit{pre}[j-1] == \textit{pre}[i] - k
$$
所以我们考虑以 $i$ 结尾的「优美子数组」个数时只要统计有多少个奇数个数为 $\textit{pre}[i]-k$ 的 $\textit{pre}[j]$ 即可。我们只要建立频次数组 $\textit{cnt}$ 记录 $\textit{pre}[i]$ 出现的次数，从左往右边更新 $\textit{cnt}$ 边计算答案，那么以 $i$ 结尾的答案 $\textit{cnt}[\textit{pre}[i]-k]$ 即可 $O(1)$ 得到。最后的答案即为所有下标结尾的「优美子数组」个数之和。

需要注意的是，从左往右边更新边计算的时候已经保证了$\textit{cnt}[\textit{pre}[i]-k]$ 里记录的 $\textit{pre}[j]$ 的下标范围是 $0\leq j\leq i$ 。同时，由于$\textit{pre}[i]$ 的计算只与前一项的答案有关，因此我们可以不用建立 $\textit{pre}$ 数组，直接用 $\textit{odd}$ 变量来记录 $pre[i-1]$ 的答案即可。

```C++ [sol2-C++]
class Solution {
    vector<int> cnt;
public:
    int numberOfSubarrays(vector<int>& nums, int k) {
        int n = (int)nums.size();
        cnt.resize(n + 1, 0);
        int odd = 0, ans = 0;
        cnt[0] = 1;
        for (int i = 0; i < n; ++i) {
            odd += nums[i] & 1;
            ans += odd >= k ? cnt[odd - k] : 0;
            cnt[odd] += 1;
        }
        return ans;
    }
};
```
```Java [sol2-Java]
class Solution {
    public int numberOfSubarrays(int[] nums, int k) {
        int n = nums.length;
        int[] cnt = new int[n + 1];
        int odd = 0, ans = 0;
        cnt[0] = 1;
        for (int i = 0; i < n; ++i) {
            odd += nums[i] & 1;
            ans += odd >= k ? cnt[odd - k] : 0;
            cnt[odd] += 1;
        }
        return ans;
    }
}
```
```Python3 [sol2-Python3]
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        cnt = [0] * (len(nums) + 1)
        cnt[0] = 1
        odd, ans = 0, 0
        for num in nums:
            if num % 2 == 1:
                odd += 1
            if odd >= k:
                ans += cnt[odd - k]
            cnt[odd] += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的大小。我们只需要遍历一遍数组即可求得答案。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的大小。频次数组 $\textit{cnt}$ 记录的最大值不会超过 $n$ ，因此只需要额外的 $O(n)$ 的空间。