## [2163.删除元素后和的最小差值 中文官方题解](https://leetcode.cn/problems/minimum-difference-in-sums-after-removal-of-elements/solutions/100000/shan-chu-yuan-su-hou-he-de-zui-xiao-chai-ah0j)

#### 方法一：优先队列

**思路与算法**

题目中的要求等价于：

- 在 $[n, 2n]$ 中选择一个正整数 $k$；

- 数组 $\textit{nums}$ 的前 $k$ 个数属于第一部分，但只能保留 $n$ 个；

- 数组 $\textit{nums}$ 的后 $3n-k$ 个数属于第二部分，但只能保留 $n$ 个；

- 需要最小化第一部分和与第二部分和的差值。

其中 $k \in [n, 2n]$ 的原因是需要保证每一部分都至少有 $n$ 个元素。

由于我们需要「最小化第一部分和与第二部分和的差值」，那么就需要第一部分的和尽可能小，第二部分的和尽可能大，也就是说：

> 我们需要在第一部分中选择 $n$ 个最小的元素，第二部分中选择 $n$ 个最大的元素。

因此我们可以使用优先队列来进行选择。对于第一部分而言，我们首先将 $\textit{nums}[0 .. n-1]$ 全部放入大根堆中，随后遍历 $[n, 2n)$，记当前的下标为 $i$，那么将 $\textit{nums}[i]$ 放入大根堆后再取出堆顶的元素，剩余堆中的元素即为 $\textit{num}[0 .. i]$ 中的 $n$ 个最小的元素。

对于第二部分而言，类似地，我们首先将 $\textit{nums}[2n .. 3n-1]$ 全部放入小根堆中，随后**逆序**遍历 $[n, 2n)$，记当前的下标为 $i$，那么将 $\textit{nums}[i]$ 放入小根堆后再取出堆顶的元素，剩余堆中的元素即为 $\textit{num}[i .. 3n-1]$ 中的 $n$ 个最大的元素。

在对优先队列进行操作时，我们还需要维护当前所有在优先队列中的元素之和。当元素被放入堆时，我们加上元素的值；当元素被从堆顶取出时，我们减去元素的值。这样一来，我们就可以得到 $\textit{part}_1[n-1], \cdots \textit{part}_1[2n-1]$ 以及 $\textit{part}_2[n], \cdots \textit{part}_2[2n]$，其中 $\textit{part}_1[i]$ 表示 $\textit{nums}[0..i]$ 中 $n$ 个最小的元素之和，$\textit{part}_2[i]$ 表示 $\textit{nums}[i..3n-1]$ 中 $n$ 个最大的元素之和。

最终所有 $\textit{part}_1[i] - \textit{part}_2[i+1]$ 中的最小值即为答案。需要保证 $i \in [n-1, 2n)$。

**细节**

我们可以将 $\textit{part}_1$ 的下标全部减去 $n-1$，$\textit{part}_2$ 的下标全部减去 $n$，这样它们的下标范围都是 $[0, n)$，我们只需要使用两个长度为 $n+1$ 的数组进行存储。

更进一步，在计算 $\textit{part}_2$ 时，我们无需使用数组进行存储，只需要使用一个变量。当下标为 $i$ 时，我们需要的 $\textit{part}_1$ 项是 $\textit{part}_1[i-1]$，下标减去 $n-1$ 变为 $\textit{part}_1[i-n]$，那么使用 $\textit{part}_1[i-n] - \textit{part}_2$ 更新答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long minimumDifference(vector<int>& nums) {
        int n3 = nums.size(), n = n3 / 3;
        
        vector<long long> part1(n + 1);
        long long sum = 0;
        // 大根堆
        priority_queue<int> ql;
        for (int i = 0; i < n; ++i) {
            sum += nums[i];
            ql.push(nums[i]);
        }
        part1[0] = sum;
        for (int i = n; i < n * 2; ++i) {
            sum += nums[i];
            ql.push(nums[i]);
            sum -= ql.top();
            ql.pop();
            part1[i - (n - 1)] = sum;
        }
        
        long long part2 = 0;
        // 小根堆
        priority_queue<int, vector<int>, greater<int>> qr;
        for (int i = n * 3 - 1; i >= n * 2; --i) {
            part2 += nums[i];
            qr.push(nums[i]);
        }
        long long ans = part1[n] - part2;
        for (int i = n * 2 - 1; i >= n; --i) {
            part2 += nums[i];
            qr.push(nums[i]);
            part2 -= qr.top();
            qr.pop();
            ans = min(ans, part1[i - n] - part2);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumDifference(self, nums: List[int]) -> int:
        n3, n = len(nums), len(nums) // 3

        part1 = [0] * (n + 1)
        # 大根堆
        total = sum(nums[:n])
        ql = [-x for x in nums[:n]]
        heapq.heapify(ql)
        part1[0] = total

        for i in range(n, n * 2):
            total += nums[i]
            heapq.heappush(ql, -nums[i])
            total -= -heapq.heappop(ql)
            part1[i - (n - 1)] = total
        
        # 小根堆
        part2 = sum(nums[n * 2:])
        qr = nums[n * 2:]
        heapq.heapify(qr)
        ans = part1[n] - part2

        for i in range(n * 2 - 1, n - 1, -1):
            part2 += nums[i]
            heapq.heappush(qr, nums[i])
            part2 -= heapq.heappop(qr)
            ans = min(ans, part1[i - n] - part2)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。优先队列中包含 $n$ 个元素，单次操作时间复杂度为 $O(\log n)$，操作次数为 $O(n)$。

- 空间复杂度：$O(n)$，即为优先队列和数组 $\textit{part}_1$ 需要使用的空间。