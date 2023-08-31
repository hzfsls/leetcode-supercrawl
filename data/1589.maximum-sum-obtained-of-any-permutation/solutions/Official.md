## [1589.所有排列中的最大和 中文官方题解](https://leetcode.cn/problems/maximum-sum-obtained-of-any-permutation/solutions/100000/suo-you-pai-lie-zhong-de-zui-da-he-by-leetcode-sol)
#### 预备知识：前缀和与差分

**问题引入**

现在有一个长度为 $n$ 的数组 $a$，初始值都为 $0$。$q$ 个操作，每个操作给出一个区间 $[l_i, r_i]$，我们需要把 $[l_i, r_i]$ 这个区间内所有元素加 $1$。返回 $q$ 个操作后的数组。$n , q \leq 10^5$。

**求解方法**

最朴素的方法是按照题意模拟，不过时间复杂度是 $O(n \times q)$，这显然不是很令人满意。我们可以看出这是一个非常典型的区间修改（加法），单点查询的问题。解决这类问题的方法有很多，例如 $O(q \sqrt{n} + n)$ 的分块、$O((q + n) \log n)$ 的线段树。不过因为这里修改和查询是分离开来的，不用一边修改一边查询，我们还可以使用差分数组来解决这个问题，时间复杂度为 $O(q + n)$，这里简单介绍下差分数组。

我们对数组 $a$ 的某个区间一次做区间加法，如果直接维护数组 $a$ 的时间代价可能会很大，达到 $O(n)$。但是我们可以维护 $a$ 的差分数组。$a$ 的差分数组 $b$ 的定义是：

$$b[i] = \left\{ \begin{aligned} 
    & a[i] ,& i = 0 \\
    & a[i] - a[i - 1] ,& i \neq 0
\end{aligned} \right.$$

对于 $a$ 的区间 $[l, r]$ 如果要执行区间加 $1$，那么对应 $b$ 区间的操作为：

+ $b[l] \leftarrow b[l] + 1$
+ $b[r + 1] \leftarrow b[r + 1] - 1$，如果 $r + 1 > n$ 则不执行这个操作

因此我们就可以把单次区间加的时间代价变成 $O(1)$。在我们执行完所有的修改操作后，对 $b$ 求前缀和，就可以得到最后的 $a$ 数组。

#### 方法一：贪心

每次查询的范围都是一个子数组，因此可以根据查询数组 $\textit{requests}$ 计算得到数组 $\textit{nums}$ 的每个下标位置被查询的次数。题目要求返回所有查询结果之和的最大值，当查询结果之和最大时，应满足数组 $\textit{nums}$ 中的越大的数字被查询的次数越多，因此可以使用贪心算法求解。

首先计算数组 $\textit{nums}$ 的每个下标位置被查询的次数。暴力的做法是遍历查询数组中的每个查询范围，对于每个查询范围，将其中的每个下标位置的被查询的次数加 $1$。显然，暴力的做法时间复杂度太高。优化的做法是维护一个差分数组，对于每个查询范围只在其开始和结束位置进行记录，例如查询范围是 $[\textit{start},\textit{end}]$，则只需要将 $\textit{start}$ 处的被查询的次数加 $1$，将 $\textit{end}+1$ 处的被查询的次数减 $1$ 即可（如果 $\textit{end}+1$ 超出数组下标范围则不需要进行减 $1$ 的操作），然后对于被查询的次数的差分数组计算前缀和，即可得到数组 $\textit{nums}$ 的每个下标位置被查询的次数。使用数组 $\textit{counts}$ 记录数组 $\textit{nums}$ 的每个下标位置被查询的次数，则数组 $\textit{counts}$ 和数组 $\textit{nums}$ 的长度相同。

在得到数组 $\textit{counts}$ 之后，对数组 $\textit{nums}$ 和数组 $\textit{counts}$ 排序。假设两个数组的长度都为 $n$，则在排序之后通过如下方式计算最大和：

$$
\sum_{i=0}^{n-1} \textit{nums}[i] \times \textit{counts}[i]
$$

由于被查询 $0$ 次的数字对查询结果没有影响，因此计算方法可以进行优化，倒序遍历两个数组，遇到查询次数为 $0$ 则结束计算。

如何证明贪心算法得到的一定是查询结果之和的最大值？假设数组 $\textit{nums}$ 中的 $n$ 个元素从小到大依次是 $a_0, a_1, \ldots, a_{n-1}$，数组 $\textit{counts}$ 中的 $n$ 个元素从小到大依次是 $c_0, c_1, \ldots, c_{n-1}$，此时的查询结果之和是

$$
\textit{sum}_1=\sum_{i=0}^{n-1} a_i \times c_i
$$

如果从数组 $\textit{nums}$ 中任意选取两个不同的数 $a_j$ 和 $a_k$，其中 $j<k$，将 $a_j$ 和 $a_k$ 交换位置之后，得到的查询结果之和记为 $\textit{sum}_2$，则有

$$
\begin{aligned}
&~~~~~\textit{sum}_1-\textit{sum}_2 \\
&=(a_j \times c_j + a_k \times c_k) - (a_k \times c_j + a_j \times c_k) \\
&=(a_j-a_k) \times (c_j-c_k)
\end{aligned}
$$

当 $j < k$ 时，$a_j-a_k \le 0$ 且 $c_j-c_k \le 0$，因此 $(a_j-a_k) \times (c_j-c_k) \ge 0$，即 $\textit{sum}_1-\textit{sum}_2 \ge 0$，因此 $\textit{sum}_1$ 一定是查询结果之和的最大值。

```Java [sol1-Java]
class Solution {
    public int maxSumRangeQuery(int[] nums, int[][] requests) {
        final int MODULO = 1000000007;
        int length = nums.length;
        int[] counts = new int[length];
        for (int[] request : requests) {
            int start = request[0], end = request[1];
            counts[start]++;
            if (end + 1 < length) {
                counts[end + 1]--;
            }
        }
        for (int i = 1; i < length; i++) {
            counts[i] += counts[i - 1];
        }
        Arrays.sort(counts);
        Arrays.sort(nums);
        long sum = 0;
        for (int i = length - 1; i >= 0 && counts[i] > 0; i--) {
            sum += (long) nums[i] * counts[i];
        }
        return (int) (sum % MODULO);
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int maxSumRangeQuery(vector<int>& nums, vector<vector<int>>& requests) {
        int MODULO = 1000000007;
        int length = nums.size();
        auto counts = vector<int>(length);
        for (auto request: requests) {
            int start = request[0], end = request[1];
            counts[start]++;
            if (end + 1 < length) {
                counts[end + 1]--;
            }
        }
        for (int i = 1; i < length; i++) {
            counts[i] += counts[i - 1];
        }
        sort(counts.begin(), counts.end());
        sort(nums.begin(), nums.end());
        long long sum = 0;
        for (int i = length - 1; i >= 0 && counts[i] > 0; i--) {
            sum += (long long)nums[i] * counts[i];
        }
        return sum % MODULO;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxSumRangeQuery(self, nums: List[int], requests: List[List[int]]) -> int:
        MODULO = 10**9 + 7
        length = len(nums)
        
        counts = [0] * length
        for start, end in requests:
            counts[start] += 1
            if end + 1 < length:
                counts[end + 1] -= 1
        
        for i in range(1, length):
            counts[i] += counts[i - 1]

        counts.sort()
        nums.sort()
        
        total = sum(num * count for num, count in zip(nums, counts))
        return total % MODULO
```

**复杂度分析**

- 时间复杂度：$O(m+n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是查询数组 $\textit{requests}$ 的长度。
  需要遍历查询数组计算得到数组 $\textit{nums}$ 的每个下标位置被查询的次数，时间复杂度是 $O(m)$，然后计算前缀和得到数组 $\textit{counts}$，时间复杂度是 $O(n)$。
  然后对数组 $\textit{nums}$ 和数组 $\textit{counts}$ 排序，时间复杂度是 $O(n \log n)$。
  最后遍历数组 $\textit{nums}$ 和数组 $\textit{counts}$ 计算查询结果之和的最大值，时间复杂度是 $O(n)$。
  因此总时间复杂度是 $O(m+n+n \log n+n)=O(m+n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要创建数组 $\textit{counts}$ 记录数组 $\textit{nums}$ 的每个下标位置被查询的次数，长度为 $n$，排序的空间复杂度不会超过 $O(n)$，因此总空间复杂度是 $O(n)$。